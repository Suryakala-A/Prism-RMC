/*$File_version=MS4.3.0.07$*/      
/*********************************************************************************/      
/* Procedure : spy_wf_sp_process       */      
/* Description :          */      
/*********************************************************************************/      
/* Project :          */      
/* EcrNo :          */      
/* Version :          */      
/*********************************************************************************/      
/* Referenced :          */      
/* Tables :          */      
/*********************************************************************************/      
/* Development history:         */      
/*********************************************************************************/      
/* Author : Veangadakrishnan R       */      
/* Date  : Apr  9 2010  9:36AM       */      
/*********************************************************************************/      
/* Modification History :         */      
/*********************************************************************************/      
/* Modified By :   Date:   Description:  */      
/* Esther J   15/05/2010  10H109_spy_00004 */      
/* Veangadakrishnan R  17/05/2010  10H109_spy_00006 */      
/* MohanaKrishna A   21/08/2010  ES_spy_00219(10H109_spy_00010) */      
/* Anitha N     31/08/2010  ES_spy_00219(10H109_spy_00010:10H109_spy_00032) */      
/* Esther J     14/02/2012  11H103_spy_00048 */       
/* Damodharan. R   28/09/2012   12H124_GENERAL_00004 */      
/* gokul M       10/10/2019   epe-15519  */          
/* Balaji C       09/06/2021   PROCPSS-2409  */    
/* Abinaya		 06-06-2022	   EPE-46106	 */  
/*Srinivasan M   12/03/2024    RSSIL-862*/
/*Shrimalavika M		22-01-2025  CU Merging-PJRMC-1252 */
/*********************************************************************************/      
create   procedure spy_wf_sp_process      
 @ctxt_ouinstance         fin_ctxt_ouinstance, --Input       
 @ctxt_user               fin_ctxt_user, --Input       
 @ctxt_language           fin_ctxt_language, --Input       
 @ctxt_service            fin_ctxt_service, --Input       
 @ctxt_role               fin_ctxt_role, --Input       
 @calling_service         fin_ctxt_service, --Input       
 @guid                    fin_guid, --Input       
 @m_errorid               fin_int output --To Return Execution Status      
as      
Begin      
 -- nocount should be switched on to prevent phantom rows      
 Set nocount on      
 -- @m_errorid should be 0 to Indicate Success      
 Set @m_errorid = 0      
      
 --BEGIN of Standard code for getting precision type       
 declare @pqty_tmp              fin_int ,        
  @pamt_tmp                  fin_int ,      
  @prate_tmp                 fin_int ,      
  @perate_tmp                fin_int ,      
  @phigh_tmp                 fin_int ,      
  @pmed_tmp                  fin_int ,      
  @plow_tmp                  fin_int      
       
 exec  fin_sp_precisiontype_rtr @pqty_tmp output, @pamt_tmp output,      
  @prate_tmp output, @perate_tmp output, @phigh_tmp output,      
  @pmed_tmp output, @plow_tmp output      
 --END of Standard code for getting precision type      
      
 --declaration of temporary variables      
 declare @wf_ou   fin_ctxt_ouinstance,      
  @voucher_no  fin_documentno,      
  @voucher_ou  fin_ctxt_ouinstance,      
  @guid_itr  fin_guid,      
  @errorno  fin_int,      
  @errormsg  fin_text255,      
  @self_auth_flag  fin_flag,      
  @exec_flag  fin_modeflag,      
  @isvalidate_service fin_int        
      
 declare @doc_activitycd         wfactivitycode,      
  @doc_taskcd  wftaskname,      
  @isinit_service  fin_int,      
  @isauth_service  fin_int,      
  @doc_key  wfdockey, 
  @doc_key_old  wfdockey,--code added by RSSIL-862
  @lo_id   fin_buid,      
  @company_code  fin_companycode      
  /*code added for the DFN ID: ES_spy_00219(10H109_spy_00010) starts here */      
  ,@isinit_service_paybatch fin_int,       
  @isauth_service_paybatch fin_int      
  /*code added for the DFN ID: ES_spy_00219(10H109_spy_00010) ends here */      
  --epe-15519      
  ,@isinit_service_advpaybatch fin_int,       
  @isauth_service_advpaybatch fin_int,      
  @isret_service_advpaybatch  fin_int      
  --epe-15519      
      
 declare @account_desc  fin_accountdescription,      
  @suppliername  fin_name,      
  @bankdesc  fin_desc40,      
  @bank_cash_code  fin_bankcashcode,      
  @createdby  fin_ctxt_user,      
  @createddate  fin_desc16,        
  @dd_charges  fin_ddoption,      
  @exchange_rate  fin_desc40,      
  @fb_id   fin_financebookid,      
  @modifiedby  fin_ctxt_user,      
  @modifieddate  fin_desc16,      
  @lcnumber  fin_lcnumber,      
  @pay_amount  fin_desc40,      
  @pay_currency  fin_currency,      
  @pay_date  fin_desc16,      
  @payment_route  fin_route,      
  @pay_mode  fin_paymode,      
  @voucher_type  fin_documenttype,      
  @priority  fin_priority,      
  @relpay_ou  fin_desc5,      
  /* code added for the dts id 11H103_spy_00048 starts */      
  @PRJOU   fin_desc5,      
  @PRJSUBPRJCD fin_projectcode,      
  @PRJSUBPRJDESC  fin_projectdescription,      
  /* code added for the dts id 11H103_spy_00048 ends*/      
  @remarks  fin_comments,      
  @request_date  fin_desc16,      
  @status   fin_status,      
  @supp_code  fin_suppliercode,      
  @account_code  fin_accountcode,      
  @supp_area  fin_ouinstname,      
  @supp_doc_amt  fin_desc40,      
  @supp_doc_date  fin_desc16,      
  @supp_doc_no  fin_documentno,      
  @workflow_status fin_wfstatename,      
  @area_code  wfareacode,      
  /*Code modified for DTS ID: 10H109_spy_00006 starts here*/      
  @payment_routedesc fin_param_text,      
  @prioritydesc  fin_param_text,      
  @ddoptiondesc  fin_param_text,      
  @ppvouchertypedesc fin_param_text,      
  @paymodedesc  fin_param_text,      
  @status_desc  fin_param_text,      
  @supp_area_name  fin_ouinstname,      
  @relpay_ou_desc  fin_ouinstname      
  /*Code modified for DTS ID: 10H109_spy_00006 ends here*/      
 /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) starts here*/      
 declare @pay_chargeby  fin_paramcode      
 declare @pay_chargeby_desc fin_param_text      
 declare @actiononunadjpp fin_paramcode      
 declare @actiononunadjpp_desc fin_param_text      
 declare @elecpayment  fin_paramcode      
 declare @elecpayment_desc fin_param_text      
 declare @tran_type   fin_cmntrantype      
 declare @TotalPayAmountBase   fin_Amount,--deepika      
   @TotalPayAmountTran   fin_Amount,      
   @exrate_tmp     fin_type      
 /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) ends here*/      
 --epe-15519      
 declare       
  @ACTIONONCUSTOMERBALANCECHECK fin_desc255,      
  @ACTIONUNADJPP   fin_paramchar,      
  @CREATEDDATE_adv    fin_date,      
  @CREATIONBY    fin_ctxt_user,      
  @DDOPTION       fin_ddoption,      
  @DOCPRIORITY      fin_priority,      
  @ELECPAYMENT_adv    fin_option,      
  @EXCHANGERATE     fin_exchangerate,      
  @FBHDR         fin_financebookid,      
  @PAYBATCHNOTYPENO   fin_notypeno,      
  @PAYBATCHNUMBER    fin_documentnumber,      
  @PAYCURRENCYCODE    fin_currencycode,      
  @PAYDATE        fin_date,      
  @PAYGROUPNUMBER    fin_paygroup,      
  @PAYMENTROUTE     fin_route,      
  @PAYMODE        fin_paymode,      
  @RELPAYOU        fin_ouinstname,      
  @REMARKS_adv      fin_text255,      
  @REQUESTDATE      fin_date,      
  @STATUS_adv       fin_status,      
  @VOUCHERNOTYPENO   fin_notypeno  ,
  @status_code		  fin_status  
      
 --epe-15519      
      
 --temporary and formal parameters mapping      
 Set @ctxt_user               = ltrim(rtrim(@ctxt_user))      
 Set @ctxt_service            = ltrim(rtrim(@ctxt_service))      
 Set @ctxt_role = ltrim(rtrim(@ctxt_role))      
 Set @calling_service         = upper(ltrim(rtrim(@calling_service)))      
 Set @guid                    = ltrim(rtrim(@guid))      
      
 --null checking      
      
 IF @ctxt_ouinstance = -915      
  Select @ctxt_ouinstance = null        
      
 IF @ctxt_user = '~#~'       
  Select @ctxt_user = null        
      
 IF @ctxt_language = -915      
  Select @ctxt_language = null        
      
 IF @ctxt_service = '~#~'       
  Select @ctxt_service = null        
      
 IF @ctxt_role = '~#~'       
  Select @ctxt_role = null        
      
 IF @calling_service = '~#~'       
  Select @calling_service = null        
      
 IF @guid = '~#~'       
  Select @guid = null  
	
	--EPE-46106 starts
	if	@calling_service	in (select callingservice
							from   erp_cmn_notification_metadata(nolock)
							where  component_id = 'SPY'
							and    wf_flag = 1) 
	begin
		select @calling_service = 'spyaurpensrblkaut'
	end	

	else if @calling_service in (select callingservice
									 from  erp_cmn_notification_metadata(nolock)
									 where component_id = 'SPY'
									 and wf_flag = 0) 
	begin 
		select @calling_service = 'spyaurpmnsrreturn'
	end 
	--EPE-46106 ends   
      
 select  @isinit_service = 1,      
   @isauth_service = 1,      
   @isvalidate_service = 1      
      
 select  @self_auth_flag = 'N'       
      
 if @calling_service = 'SPYREVPPVSRREVERS'      
 begin      
  select @area_code = 'SPPVREVNEW'      
 end      
 else if @calling_service in ('SPYHLDPPVSRHOLD','SPYHLDPPVSRRLSE')      
 begin      
  select @area_code = 'SPPVHRNEW'      
 end       
 /* code added for the DFN ID:ES_spy_00219(10H109_spy_00010) starts here*/      
 else if @calling_service in ( 'SPYEDRPENSRBLKDEL','SPYAURPENSRBLKAUT','SPYADRPMNSRCREATE','SPYADRPMNSRCRAUTH',      
     'SPYAURPMNSREDIT',  'SPYEdRpMnSrModify','SPYAURPMNSREDAUT', 'SPYEDRPMNSRMODAUT',      
     'SPYAURPMNSRRETURN','SPYEdRpMnSrDelete')      
 Begin      
  select @area_code = 'SPYRBPAUTH'      
 End      
 /* code added for the DFN ID:ES_spy_00219(10H109_spy_00010) ends here*/      
 else      
 begin      
  select @area_code = 'SPPVAUTNEW'      
 end      
      
 if @calling_service in ('SPYAUPPMNSREDIT','SPYEDPPMNSRMODIFY')             
 begin      
  select @isinit_service = 0      
 end       
       
 /* code added for the DFN ID: ES_spy_00219(10H109_spy_00010) starts here */      
 if @calling_service in ('SPYAuRpMnSrEdit','SPYEdRpMnSrModify')       
 begin      
  select @isinit_service_paybatch = 0      
 end       
 /* code added for the DFN ID: ES_spy_00219(10H109_spy_00010) ends here */      
      
 if @calling_service in ('SPYAUPPMNSREDAUT','SPYAUPPENSRBLKAUT','SPYEDPPMNSRMODAUT')      
             
 begin      
  select @isauth_service = 0      
 end       
       
 /* code added for the DFN ID: ES_spy_00219(10H109_spy_00010)starts here */      
 if @calling_service in ('SPYAuRpMnSrEdAut','SPYAuRpEnSrBlkAut','SPYEdRpMnSrModAut')       
 begin      
  select @isauth_service_paybatch = 0      
 end       
 /* code added for the DFN ID: ES_spy_00219(10H109_spy_00010) ends  here */      
      
 --epe-15519      
 if @calling_service in ('spyadapmnsrsavdoc','spyadapbnsrcreate','spyedapmnsrmodify','spyedapbnsrmodify','spyauapmnsredit','spyauapbnsrsave')       
 begin      
  select @isinit_service_advpaybatch = 0      
  select @area_code = 'SPYADBAUTH'      
 end      
      
 if @calling_service in ('spyadapbnsrcrauth','spyedapbnsrmodaut',/*'spyauapensrblkaut',*/'spyauapbnsrsavaut')       
 begin      
  select @isauth_service_advpaybatch = 0      
  select @area_code = 'SPYADBAUTH'      
 end       
      
 if @calling_service in ('SPYAuApMnSrReturn','SPYAuApBnSrReturn')       
 begin      
  select @isret_service_advpaybatch = 0      
  select @area_code = 'SPYADBAUTH'      
 end       
      
 if @calling_service in ( 'spyadapmnsrsavdoc')       
 begin      
  select @doc_activitycd = 'SpyAddPV',  --spyaddpvdocmain        
     @doc_taskcd  = 'SpyAddPVTrn4'      
 end      
      
 if @calling_service in ( 'spyadapbnsrcreate','spyadapbnsrcrauth')      
 begin      
  select  @doc_activitycd = 'SpyAddPV', --'SpyAddPVBnkAdl',        
    @doc_taskcd  = case when @calling_service = 'spyadapbnsrcreate' then 'SpyAddPVTrn4'      
              when @calling_service = 'spyadapbnsrcrauth' then 'SpyAddPVTrn4'      
            end       
 end      
      
 if @calling_service in ( 'spyadapbnsrcrauth')      
 begin      
 select @self_auth_flag = 'Y'      
 end      
      
 if @calling_service in ( 'spyedapmnsrmodify')       
 begin      
  select @doc_activitycd = 'SpyMntPV', --'spymntpvdocmod',        
     @doc_taskcd  = 'SpyMntPVTrn9'      
 end      
      
 if @calling_service in ( 'spyedapbnsrmodify')      
 begin      
  select  @doc_activitycd = 'SpyMntPV',  --'SpyMntPVBnkMod',        
    @doc_taskcd  = 'SpyMntPVTrn9'                    
 end  
   
 if @calling_service in ( 'spyedapbnsrmodaut')      
 begin      
  select  @doc_activitycd = 'SpyAuPV',  --'SpyMntPVBnkMod',        
    @doc_taskcd  =  'SpyMntPVTrn16'                       
 end      
      
 /*if @calling_service in ( 'spyauapensrblkaut')       
 begin      
  select @doc_activitycd = 'SpyAuPV', --'spyaupvselent',        
     @doc_taskcd  = 'SpyMntPVTrn16'      
 end      */
      
 if @calling_service in ( 'spyauapmnsredit')       
 begin      
  select @doc_activitycd = 'SpyMntPV', --'spyaupvdocmod',        
     @doc_taskcd  = 'SpyMntPVTrn9'      
 end      
      
 if @calling_service in ( 'spyauapbnsrsave')      
 begin      
  select  @doc_activitycd = 'SpyMntPV', --'spyaupvbnkmod',        
    @doc_taskcd  = 'SpyMntPVTrn9'      
end  
  
 if @calling_service in ('spyauapbnsrsavaut')      
 begin      
  select  @doc_activitycd = 'SpyAuPV', --'spyaupvbnkmod',        
    @doc_taskcd  = 'SpyMntPVTrn16'      
 end      
      
 if @calling_service in ( 'SPYAuApMnSrReturn')       
 begin      
  select @doc_activitycd = 'SpyAuPV', --'spyaupvdocmod',      
     @doc_taskcd  = 'SpyAuPVTrn16'      
 end      
      
 if @calling_service in ( 'SPYAuApBnSrReturn')      
 begin      
  select  @doc_activitycd = 'SpyAuPV', --'spyaupvbnkmod',        
    @doc_taskcd  = 'SpyAuPVTrn16'       
 end      
      
 --epe-15519      
      
 if @isauth_service = 0      
 begin      
  select  @doc_activitycd = 'SPYAUPPV',      
    @doc_taskcd  = 'SPYMNTPPVTRN5'      
 end      
      
 /* code added for the DFN ID: ES_spy_00219(10H109_spy_00010) ends  here */      
 if @isauth_service_paybatch = 0      
 begin      
  select  @doc_activitycd = 'SpyAuSCPV',      
    @doc_taskcd  = 'SpyMntSCPVTrn8',      
    @isauth_service = 0      
 end      
 /* code added for the DFN ID: ES_spy_00219(10H109_spy_00010) ends  here */      
      
 if @isinit_service = 0      
 begin      
  select  @doc_activitycd = 'SPYAUPPV',      
    @doc_taskcd = 'SPYMNTPPVTRN3'      
 end      
       
 /* code added for the DFN ID: ES_spy_00219(10H109_spy_00010) starts here */      
 if @isinit_service_paybatch = 0      
 begin      
  select  @doc_activitycd = 'SpyAuSCPV',      
    @doc_taskcd  = 'SpyMntSCPVTrn4',      
    @isinit_service = 0       
 end      
 /* code added for the DFN ID: ES_spy_00219(10H109_spy_00010) ends here */      
      
 if @calling_service = 'SPYADPPMNSRCREATE'      
 begin      
  select  @doc_activitycd = 'SPYADDPPV',      
    @doc_taskcd = 'SPYADDPPVTRN2'      
 end       
      
 /* code added for the DFN ID: ES_spy_00219(10H109_spy_00010) starts here */      
 if @calling_service = 'SPYAdRpMnSrCreate'      
 begin      
  select  @doc_activitycd = 'SpyAddSCPV',      
    @doc_taskcd  = 'SpyAddSCPVTrn3'      
 end       
 /* code added for the DFN ID: ES_spy_00219(10H109_spy_00010) ends here */      
      
 if @calling_service = 'SPYADPPMNSRCRAUTH'      
 begin      
  select  @doc_activitycd = 'SPYADDPPV',      
    @doc_taskcd  = 'SPYADDPPVTRN2',      
    @self_auth_flag = 'Y'      
 end         
      
 /* code added for the DFN ID: ES_spy_00219(10H109_spy_00010) starts here */      
 if @calling_service = 'SPYAdRpMnSrCrAuth'      
  begin      
   select  @doc_activitycd = 'SpyAddSCPV',      
     @doc_taskcd  = 'SPYADDSCPVTRN3',      
     @self_auth_flag = 'Y'      
  end         
 /* code added for the DFN ID: ES_spy_00219(10H109_spy_00010) ends here */      
      
       
if @calling_service = 'SPYHLDPPVSRHOLD'      
 begin 
  select  @doc_activitycd = 'SPYHRPV',      
    @doc_taskcd = 'SPYHRPVTRN4'      
 end       
       
 if @calling_service = 'SPYHLDPPVSRRLSE'      
 begin      
  select  @doc_activitycd = 'SPYHRPV',      
    @doc_taskcd = 'SPYHRPVTRN5'      
 end      
       
 if @calling_service = 'SPYREVPPVSRREVERS'      
 begin      
  select  @doc_activitycd = 'SPYREVPV',      
    @doc_taskcd = 'SPYREVPVTRN3'      
 end       
       
 if @calling_service = 'SPYAUPPMNSRRETURN'      
 begin      
  select @doc_activitycd = 'SPYAUPPV',      
    @doc_taskcd = 'SPYAUPPVTRN5'      
 end       
      
 if @calling_service = 'SPYAURPMNSRRETURN'      
 begin      
  select @doc_activitycd = 'SPYAUSCPV',      
    @doc_taskcd = 'SPYAUSCPVTRN8'      
 end       
        
 select @lo_id  = lo_id,      
   @company_code = company_code      
 from emod_lo_bu_ou_vw(nolock)      
 where ou_id = @ctxt_ouinstance      
      
  --EPE-46106  starts
  declare @workflow_app  fin_param_code, 
		  @paybatch_no_tmp fin_documentnumber 
  
  select @workflow_app = dbo.workflowapp_fet_fn(@ctxt_user,@ctxt_ouinstance,'SPY','SPYRBPAUTH','CRAUPB') 
 
  if @workflow_app = 'Y'
  begin
		select @payBatch_no_tmp = paybatch_no    
		from   spy_paybatch_hdr_tmp (nolock)  
		where  guid			    = @guid
		
		select @workflow_status	= workflow_status
		from   spy_paybatch_hdr (nolock)  
		where  paybatch_no		= @payBatch_no_tmp
  end
  --EPE-46106 ends

 if @calling_service not in ('SPYREVPPVSRREVERS','SPYHLDPPVSRHOLD','SPYHLDPPVSRRLSE','SPYAURPMNSRRETURN','SPYAURPMNSRRETURN'      
           --epe-15519             
           ,'spyadapmnsrsavdoc','spyadapbnsrcreate','spyadapbnsrcrauth','spyedapmnsrmodify','spyedapbnsrmodify','spyedapbnsrmodaut',       
           'spyauapmnsredit','spyauapbnsrsave','spyauapbnsrsavaut', 'SPYAuApMnSrReturn' ,'SPYAuApBnSrReturn'/*,'spyauapensrblkaut'*/)      
           --epe-15519      
           and @doc_taskcd != 'SPYAUPPVTRN5' /*code modified for the DFN ID: ES_spy_00219(10H109_spy_00010)*/  
		   and  isnull(@workflow_status,'') = ''  --code added for EPE-46106    
 begin      
	exec   fbp_is_loc_sptrnpostings @ctxt_language, @ctxt_ouinstance,      
		   'SPYADRPMNSRCREATE',        
			@ctxt_user,@guid,@errorno output,@errormsg output,'N'       
      
	if @errorno > 0      
	begin      
		exec fin_raise_error @errormsg      
		return      
	end       
 end      
      
 /*code added for the DFN ID: ES_spy_00219(10H109_spy_00010) starts here */      
 if @area_code ='SPYRBPAUTH'      
 begin      
  if exists( select 'X'      
    from spy_paybatch_hdr_tmp (nolock)       
    where guid  = @guid )      
  Begin      
   select @voucher_no = paybatch_no,      
    @voucher_ou = ou_id      
   from spy_paybatch_hdr_tmp (nolock)       
   where guid   = @guid      
  end      
  else      
  begin      
   select  top 1      
    @voucher_no = paybatch_no,      
    @voucher_ou = @ctxt_ouinstance      
   from spy_voucher_hdr_tmp(nolock)      
   where guid  = @guid             
  end      
      
  select  @tran_type      = tran_type      
  from spy_paybatch_hdr (nolock)      
  where paybatch_no = @voucher_no      
  and ou_id     = @voucher_ou        
 end      
       
 --epe-15519      
 else if @area_code = 'SPYADBAUTH'      
 begin      
  if exists ( select 'x' from       
      spy_paybatch_hdr_tmp (nolock)      
      where guid = @guid )      
  begin      
   select  top 1      
      @voucher_no = paybatch_no,      
      @voucher_ou = ou_id,      
      @tran_type      = tran_type      
   from  spy_paybatch_hdr_tmp (nolock)       
   where guid   = @guid      
  end      
 end      
 --epe-15519      
      
 else       
 begin      
 /*code added for the DFN ID: ES_spy_00219(10H109_spy_00010) ends here */      
  if exists ( select 'X'      
    from spy_prepay_vch_hdr(nolock)      
    where batch_id  = @guid)      
  begin       
   select  top 1      
    @voucher_no = voucher_no,      
    @voucher_ou = ou_id      
   from spy_prepay_vch_hdr(nolock)      
   where batch_id  = @guid      
  end      
  else      
  begin      
   select  top 1      
    @voucher_no = tran_no,      
    @voucher_ou = @ctxt_ouinstance      
   from spy_tranno_tmp(nolock)      
   where guid  = @guid      
  end       
 /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) starts here*/      
  select  top 1      
   @tran_type      = tran_type      
  from spy_prepay_vch_hdr(nolock)      
  where voucher_no  = @voucher_no      
  and ou_id     = @voucher_ou       
 end       
 /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) endshere*/      
 if exists (      
  select  'X'      
  from fw_admin_view_comp_intxn_model(nolock)       
  where sourcecomponentname = 'SPY'      
  and sourceouinstid  = @voucher_ou      
  and destinationcomponentname= 'WFMTASKBAS'      
  and destinationouinstid = @voucher_ou)      
 begin      
  select @wf_ou = @voucher_ou      
 end      
 else      
 begin      
  select @wf_ou = destinationouinstid      
  from fw_admin_view_comp_intxn_model(nolock)       
  where sourcecomponentname = 'SPY'      
  and sourceouinstid  = @voucher_ou      
  and destinationcomponentname= 'WFMTASKBAS'       
 end      
      
 --select @doc_key = 'SPY'+'$~$'+@tran_type+'$~$'+convert(nvarchar(4),@voucher_ou)+'$~$'+@voucher_no /* code modified for the DFN ID:ES_spy_00219(10H109_spy_00010)*/      
  select @doc_key_old = 'SPY'+'$~$'+@tran_type+'$~$'+convert(nvarchar(4),@voucher_ou)+'$~$'+@voucher_no--code added by RSSIL-862
  select @doc_key = /*'SPY'+'$~$'+*/@tran_type+'$~$'+convert(nvarchar(4),@voucher_ou)+'$~$'+@voucher_no --EPE-46106


		  --code satrts by RSSIL-862--
		if exists( select 'X'       
				   from wf_doc_status_vw(nolock)      
				   where doc_unique_id = @voucher_no      
				   and doc_key  = @doc_key_old      
				   and wf_instance_status= 'P'      
				   and user_closed = 'P')      
		 begin       
		  select @doc_key =  @doc_key_old
		 end  
		  --code ends by RSSIL-862--

 if not exists( select 'X'       
   from wf_doc_status_vw(nolock)      
   where doc_unique_id = @voucher_no      
   and doc_key  = @doc_key      
   and wf_instance_status= 'P'      
   and user_closed = 'P') and @isauth_service = 0      
 begin      
 /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) starts here*/      
  if(@area_code = 'SPYRBPAUTH')      
  begin       
   select  @doc_activitycd = 'SpyAuSCPV',      
    @doc_taskcd = 'SpyMntSCPVTrn4',      
    @self_auth_flag = 'Y'       
  end      
  --epe-15519      
  else if (@area_code = 'SPYADBAUTH')      
  begin       
   select @self_auth_flag = 'Y'       
  end      
  --epe-15519      
  else      
  begin      
 /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) ends here*/      
   select  @doc_activitycd = 'SPYAUPPV',      
    @doc_taskcd = 'SPYMNTPPVTRN3',      
    @self_auth_flag = 'Y'       
  end /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010)*/      
 end      
      
 if ( select count('X')      
  from wf_doc_status_vw(nolock)      
  where doc_key    = @doc_key      
  and doc_status   != 'FRESH'      
  and wf_instance_status= 'P'      
  and user_closed   = 'C') >= 1 and @calling_service not in ('SPYAUPPMNSRRETURN','SPYAURPMNSRRETURN')      
 begin      
  select @isvalidate_service = 0      
      
  exec spy_wf_doc_param_ins_val      
   @ctxt_ouinstance,      
   @ctxt_user,      
   @ctxt_language,      
   @ctxt_service,      
   @ctxt_role,      
   @calling_service,      
   @guid,      
   @voucher_no,      
   @voucher_ou,      
   @tran_type,   /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010)*/      
   'V',      
   @m_errorid output      
 end      
      
 /*code added for the DFN ID: ES_spy_00219(10H109_spy_00010) starts here */      
 if @area_code ='SPYRBPAUTH'      
 begin      
   if exists ( select 'X'      
      from spy_paybatch_hdr_wf_backup (nolock)      
      where paybatch_no = @voucher_no      
      and ou_id  = @voucher_ou)      
   begin      
     select @area_code = @area_code      
   end      
   else      
   begin      
     exec spy_wf_doc_param_ins_val      
     @ctxt_ouinstance,   
     @ctxt_user,      
     @ctxt_language,      
     @ctxt_service,      
     @ctxt_role,      
     @calling_service,      
     @guid,      
     @voucher_no,      
     @voucher_ou,      
     @tran_type,   /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010)*/      
     'I',      
     @m_errorid output      
   end      
 end      
 else      
 begin      
 /*code added for the DFN ID: ES_spy_00219(10H109_spy_00010) starts here */      
  if not exists ( select 'X'       
    from spy_prepay_vch_hdr_wf_bkup(nolock)      
    where voucher_no = @voucher_no      
    and ou_id = @voucher_ou)          
  begin      
      
   exec spy_wf_doc_param_ins_val      
    @ctxt_ouinstance,      
    @ctxt_user,      
    @ctxt_language,      
    @ctxt_service,      
    @ctxt_role,      
    @calling_service,      
    @guid,      
    @voucher_no,      
    @voucher_ou,      
    @tran_type,  /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) ends here*/      
    'I',      
    @m_errorid output      
  end      
 end    /*code added for the DFN ID: ES_spy_00219(10H109_spy_00010)*/      
      
      
 if exists ( select 'X'      
  from wf_doc_status_vw(nolock)      
  where doc_key    = @doc_key      
  and doc_status   = 'FRESH'      
  and wf_instance_status= 'P'      
  and user_closed   in ('C','P')) and @isvalidate_service = 1 and @isauth_service = 0        
 begin      
  exec spy_wf_doc_param_ins_val      
   @ctxt_ouinstance,      
   @ctxt_user,      
   @ctxt_language,      
   @ctxt_service,      
   @ctxt_role,      
   @calling_service,      
   @guid,      
   @voucher_no,      
   @voucher_ou,      
   @tran_type,  /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) ends here*/      
   'VS',      
   @m_errorid output,      
   @exec_flag output      
      
  if @exec_flag = 'F'      
  begin      
  /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) starts here*/      
   if(@area_code = 'SPYRBPAUTH')      
   begin      
    select  @doc_activitycd = 'SpyAuSCPV',      
     @doc_taskcd = 'SpyMntSCPVTrn4',      
     @self_auth_flag = 'Y'       
   end      
   else      
   begin      
  /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) ends here*/      
    select  @doc_activitycd = 'SPYAUPPV',      
     @doc_taskcd = 'SPYMNTPPVTRN3',      
     @self_auth_flag = 'Y'       
  /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) starts here*/      
   end      
  end        
 end      
       
 --epe-15519      
 if @area_code ='SPYADBAUTH'      
 begin      
  select      
  @ACTIONONCUSTOMERBALANCECHECK = unadjdebitchk_flag      
  ,@ACTIONUNADJPP = unadjppchk_flag      
  ,@CREATEDDATE_adv = createddate      
  ,@CREATIONBY = createdby      
  ,@DDOPTION = pay_chargeby      
  ,@DOCPRIORITY = priority      
  ,@ELECPAYMENT_adv  = elect_payment      
  ,@EXCHANGERATE = basecur_erate      
  ,@FBHDR = fb_id      
  ,@PAYBATCHNOTYPENO = paybatch_notype      
  ,@PAYBATCHNUMBER = paybatch_no      
  ,@PAYCURRENCYCODE = pay_currency      
  ,@PAYDATE = pay_date      
  ,@PAYGROUPNUMBER = paygroup_no      
  ,@PAYMENTROUTE  = payment_route      
  ,@PAYMODE  = pay_mode      
  ,@RELPAYOU  = relpay_ou      
  ,@REMARKS_adv = remarks      
  ,@REQUESTDATE = request_date      
  ,@STATUS_adv = status      
  ,@VOUCHERNOTYPENO = voucher_notype 
  ,@status_code		= status     
  from  spy_paybatch_hdr (nolock)      
  where paybatch_no  = @voucher_no      
  and ou_id   = @voucher_ou       
      
  select  @ACTIONONCUSTOMERBALANCECHECK = ltrim(rtrim(parameter_text))      
  from  fin_quick_code_met (nolock)      
  where  component_id   = 'SPY'      
  and  parameter_type   = 'COMBO'      
  and  parameter_category  = 'UNADJDEBITCHK'      
  and  parameter_code   = @ACTIONONCUSTOMERBALANCECHECK      
  and  language_id   = @ctxt_language      
      
  select  @ACTIONUNADJPP = parameter_text      
  from  fin_quick_code_met (nolock)      
  where  component_id   = 'SPY'      
  and  parameter_type   = 'COMBO'      
  and  parameter_category  = 'ACUNADPPYMT'      
  and  parameter_code   = @ACTIONUNADJPP      
  and  language_id   = @ctxt_language      
      
  select @DDOPTION = parameter_text      
  from fin_quick_code_met(nolock)      
  where component_id  = 'SPY'      
  and parameter_type  = 'COMBO'      
  and parameter_category = 'DDCHARGES'      
  and parameter_code  = @DDOPTION      
  and language_id  = @ctxt_language      
      
  select @DOCPRIORITY = parameter_text      
  from fin_quick_code_met(nolock)      
  where component_id  = 'SPY'      
  and parameter_type  = 'COMBO'      
  and parameter_category = 'PRIORITY'      
  and parameter_code  = @DOCPRIORITY      
  and language_id  = @ctxt_language      
      
  select @ELECPAYMENT_adv = parameter_text      
  from fin_quick_code_met(nolock)      
  where component_id  = 'SPY'      
  and parameter_type  = 'COMBO'      
  and parameter_category = 'YESNO'      
  and parameter_code = @ELECPAYMENT_adv      
  and language_id  = @ctxt_language      
      
  select @PAYMENTROUTE = parameter_text      
  from fin_quick_code_met(nolock)      
  where component_id  = 'SPY'      
  and parameter_type  = 'COMBO'      
  and parameter_category = 'PAYTYPE'      
  and parameter_code  = @PAYMENTROUTE      
  and language_id  = @ctxt_language      
      
  select  @PAYMODE = ltrim(rtrim(paymode_desc))      
  from  spy_paymode_vw(nolock)      
  where   paymode  = @PAYMODE      
      
  select  @RELPAYOU = ouinstname      
  from  fw_admin_view_ouinstance (nolock)      
  where  ouinstid   = @RELPAYOU      
      
  select  @STATUS_adv  = parameter_text      
  from  fin_quick_code_met (nolock)      
  where  component_id   = 'SPY'      
  and  parameter_type  = 'STATUS'      
  and  parameter_category = 'PAYBATCH'      
  and  parameter_code   = @STATUS_adv      
  and  language_id   = @ctxt_language      
      
 end      
 --epe-15519      
      
      
 if @area_code ='SPYRBPAUTH'      
 begin      
  select  @actiononunadjpp = unadjppchk_flag,      
   @pay_chargeby = pay_chargeby,      
   @priority  = priority,      
   @elecpayment = elect_payment,      
   @exchange_rate = ltrim(str(basecur_erate,28,@perate_tmp)),      
   @fb_id   = fb_id,      
   @voucher_no  = paybatch_no,      
   @pay_currency = pay_currency,      
   @pay_date  = convert(nvarchar(11),pay_date,120),      
   @payment_route = payment_route,      
   @pay_mode  = pay_mode,      
   @relpay_ou  = convert(nvarchar(4),relpay_ou),    
   @remarks  = remarks,      
   @request_date = convert(nvarchar(11),request_date,120),      
   @status   = status,--deepika      
   @createdby  = createdby,      
   @createddate = convert(nvarchar(11),createddate,120),      
   @modifiedby  = modifiedby,      
   @modifieddate = convert(nvarchar(11),modifieddate,120)      
  from spy_paybatch_hdr(nolock)      
  where paybatch_no  = @voucher_no      
  and ou_id   = @voucher_ou       
      
  select  @bank_cash_code = bank_cash_code      
  from spy_voucher_hdr(nolock)      
  where paybatch_no  = @voucher_no      
  and ou_id   = @voucher_ou       
        
  --deepika       
  SELECT  @totalpayamounttran  =       
   SUM      
   (      
      ISNULL(tran_amount, 0) -ISNULL(discount, 0) + ISNULL(penalty, 0)      
         ),      
         @totalpayamountbase   =       
   SUM      
   (      
      ISNULL(tran_amount, 0) * basecur_erate -ISNULL(discount, 0) +       
      ISNULL(penalty, 0)      
         )      
  FROM    spy_paybatch_dtl(NOLOCK)      
  WHERE   paybatch_no   = @voucher_no      
  AND     ou_id     = @ctxt_ouinstance      
      
  select @pay_chargeby_desc =  dbo.spy_getdesc('COMBO','DDCHARGES',@pay_chargeby,@ctxt_language)         
  select @actiononunadjpp_desc =  dbo.spy_getdesc('COMBO','ACUNADPPYMT',@actiononunadjpp,@ctxt_language)         
  select @elecpayment_desc =  dbo.spy_getdesc('COMBO','YESNO',@elecpayment,@ctxt_language)         
 end      
 else      
 begin      
 /*code added for the DFN ID: ES_spy_00219(10H109_spy_00010) ends here */      
  select  @bank_cash_code = bank_cash_code,      
    @createdby = createdby,      
    @createddate = convert(nvarchar(11),createddate,120),      
    @dd_charges = dd_charges,      
    @exchange_rate = ltrim(str(exchange_rate,28,@perate_tmp)),      
    @fb_id  = fb_id,      
    @modifiedby = modifiedby,      
    @modifieddate = convert(nvarchar(11),modifieddate,120),      
    @lcnumber = lcnumber,      
    @pay_amount = ltrim(str(pay_amount,28,@pamt_tmp)),      
    @pay_currency = pay_currency,      
    @pay_date = convert(nvarchar(11),pay_date,120),      
    @payment_route = payment_route,      
    @pay_mode = pay_mode,      
    @voucher_type = voucher_type,      
    @priority = priority,      
    @relpay_ou = convert(nvarchar(4),relpay_ou),      
    @remarks = remarks,      
    @request_date = convert(nvarchar(11),request_date,120),      
    @status  = status,      
    @supp_code = supp_code,      
    @account_code = supp_prepay_acct,      
    @supp_area = supp_area,      
    @supp_doc_amt = ltrim(str(supp_doc_amt,28,@pamt_tmp)),      
    @supp_doc_date = convert(nvarchar(11),supp_doc_date,120),      
    @supp_doc_no = supp_doc_no,      
    @voucher_no = voucher_no      
    /* code added for the dts id 11H103_spy_00048 starts */      
    ,@PRJOU   = convert(nvarchar(4),Project_ou),      
    @PRJSUBPRJCD = Project_code,      
    @PRJSUBPRJDESC = dbo.fin_get_prjdesc(@ctxt_ouinstance,@ctxt_language,Project_ou,Project_code)       
    /* code added for the dts id 11H103_spy_00048 ends*/      
  from spy_prepay_vch_hdr(nolock)      
  where voucher_no = @voucher_no      
  and ou_id    = @voucher_ou       
 end /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) ends here*/      
      
 /*Code modified for DTS ID: 10H109_spy_00006 starts here*/      
 select @payment_routedesc = dbo.spy_getdesc('COMBO','PAYTYPE',@payment_route,@ctxt_language)      
 select @prioritydesc  = dbo.spy_getdesc('COMBO','PRIORITY',@priority,@ctxt_language)        
 select @ddoptiondesc  = dbo.spy_getdesc('COMBO','DDCHARGES',@dd_charges,@ctxt_language)        
 select @ppvouchertypedesc = dbo.spy_getdesc('COMBO','PPVOUTYPE',@voucher_type,@ctxt_language)      
 select @status_desc  = dbo.spy_getdesc('STATUS','VOUSTATUS',@status,@ctxt_language)        
      
 if @ddoptiondesc = '' -- code added for the dts id 10H109_spy_00004      
  select @ddoptiondesc = NULL      
      
 select @paymodedesc = rcpt_pymt_mode        
 from   bnkdef_rcpt_pay_mode_vw (nolock)        
 where  rcpt_pymt_mode_code = @pay_mode        
 and    language_id  = @ctxt_language        
      
 if @paymodedesc is null       
 begin      
  select @paymodedesc=  parameter_text      
  from fin_quick_code_met(nolock)      
  where component_id  = 'BNKDEF'      
  and parameter_type   =  'COMBO'      
  and  parameter_category  =  'PAYMODE'      
  and parameter_code  = @pay_mode      
  and language_id  =  @ctxt_language      
 end      
 
 select  @supp_area_name = ouinstname        
 from  fw_admin_view_ouinstance (nolock)        
 where  ouinstid   = @supp_area        
      
 select  @relpay_ou_desc = ouinstname      
 from  fw_admin_view_ouinstance (nolock)        
 where  ouinstid    = @relpay_ou       
 /*Code modified for DTS ID: 10H109_spy_00006 ends here*/       
      
 select @account_desc = ml_account_desc      
 from as_opacctfball_ml_vw vw(nolock)      
 where vw.company_code = @company_code      
 and vw.fb_id = @fb_id      
 and vw.currency_code= @pay_currency      
 and vw.account_code = @account_code      
 and language_id = @ctxt_language      
      
 if  @payment_route         = 'B'      
 begin       
  select  @bankdesc  = bank_cash_desc      
  from  bnkdef_sysact_bnkcshptt_vw( nolock)      
  where  company_code           = @company_code      
  and  bank_ptt_cash          = 'B'      
  and  bank_cash_code         = @bank_cash_code      
  and  language_id            = @ctxt_language      
 end       
 else       
 if  @payment_route         = 'C'      
 begin       
  select  @bankdesc  = bank_cash_desc      
  from  bnkdef_sysact_bnkcshptt_vw( nolock)      
where  company_code           = @company_code      
  and  bank_ptt_cash          = 'C'      
  and  bank_cash_code       = @bank_cash_code      
  and  language_id        = @ctxt_language      
 end       
 else       
 if  @payment_route         = 'P'      
 begin      
  select  @bankdesc         = bank_cash_desc      
  from  bnkdef_sysact_bnkcshptt_vw( nolock)      
  where  company_code           = @company_code      
  and  bank_ptt_cash          = 'P'      
  and  bank_cash_code         = @bank_cash_code      
  and  language_id            = @ctxt_language      
 end      
      
 select  @suppliername                  = ltrim( rtrim( supp_spmn_supname))      
 from  supp_spmn_suplmain(nolock)      
 where  supp_spmn_supcode   =  @supp_code      
 and  supp_spmn_loid                 =  @lo_id      
 /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) starts here*/      
 if @account_desc = ''      
  select @account_desc = null      
 if @bank_cash_code = ''      
  select @bank_cash_code = null      
 if @bankdesc = ''      
  select @bankdesc = null      
 if @createddate = ''      
  select @createddate = null      
 if @createdby = ''      
  select @createdby = null      
 if @ddoptiondesc = ''      
  select @ddoptiondesc = null      
 if @exchange_rate = ''      
  select @exchange_rate = null      
 if @fb_id = ''      
  select @fb_id = null      
 if @modifiedby = ''      
  select @modifiedby = null      
 if @modifieddate = ''      
  select @modifieddate = null      
 if @lcnumber = ''      
  select @lcnumber = null      
 if @pay_amount = ''      
  select @pay_amount = null      
 if @pay_currency = ''      
  select @pay_currency = null      
 if @pay_date = ''      
  select @pay_date = null      
 if @payment_routedesc = ''      
  select @payment_routedesc = null      
 if @paymodedesc = ''      
  select @paymodedesc = null      
 if @ppvouchertypedesc = ''      
  select @ppvouchertypedesc = null      
 if @prioritydesc = ''      
  select @prioritydesc = null      
 if @relpay_ou_desc = ''      
  select @relpay_ou_desc = null      
 if @remarks = ''      
  select @remarks = null      
 if @request_date = ''      
  select @request_date = null      
 if @status_desc = ''      
  select @status_desc = null      
 if @supp_code = ''      
  select @supp_code = null      
 if @account_code = ''      
  select @account_code = null      
 if @supp_area_name = ''      
  select @supp_area_name = null      
 if @supp_doc_amt = ''      
  select @supp_doc_amt = null      
 if @supp_doc_date = ''      
  select @supp_doc_date = null      
 if @supp_doc_no = ''      
  select @supp_doc_no = null      
 if @suppliername = ''      
  select @suppliername = null      
 if @actiononunadjpp_desc = ''      
  select @actiononunadjpp_desc = null      
 if @pay_chargeby_desc = ''      
  select @pay_chargeby_desc = null      
 if @elecpayment_desc = ''      
  select @elecpayment_desc = null      
 /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) ends here*/      
 select @guid_itr = newid()      
       
 insert into fin_wf_input      
  (log_role,  log_user,   log_orgunitid,  doc_area_code,      
  doc_componentcd, doc_activitycd,  doc_taskcd,  doc_orgunitid,      
  doc_parameter,   doc_current_state,  doc_action_combo_val,       
  doc_newst_todo_user_ou, doc_newst_todo_user,  doc_key,      
  doc_unique_id,  doc_date,   doc_auth_flag,   doc_float_dummy_1,       
  doc_float_dummy_2, doc_char_dummy_1,  doc_char_dummy_2,        
  doc_guid,   service,  parent_guid)      
 values(      
  @ctxt_role,   @ctxt_user,  @ctxt_ouinstance,  @area_code,      
  'SPY',    @doc_activitycd, @doc_taskcd,  @ctxt_ouinstance,      
  '' ,  case       
      when @isinit_service = 0 then ''      
      else @workflow_status      
     end,   '~#~',         
  --@ctxt_ouinstance, @ctxt_user,  @doc_key,	--PROCPSS-2409
  -915, '~#~',  @doc_key,						--PROCPSS-2409
  --Code commented and added for Defect ID 12H124_GENERAL_00004 starts here      
  --@voucher_no,  @pay_date,  @self_auth_flag, -915,       
  @voucher_no,  convert(nvarchar(10), dbo.RES_Getdate(@ctxt_ouinstance), 120),  @self_auth_flag, -915,      
  --Code commented and added for Defect ID 12H124_GENERAL_00004 ends here      
  -915,    '~#~',   'FIN',         
  @guid_itr,  @ctxt_service,  @guid)      
      
 /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) starts here*/      
 if @tran_type = 'PM_SPPV'      
 begin      
 /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) ends here*/      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'ACCOUNTDESCRIPTION',@account_desc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'BANKCASH',@bank_cash_code,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'BANKDESCRIPTION',@bankdesc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'CREATEDDATE',@createddate,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'CREATIONBY',@createdby,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'DDOPTION',@ddoptiondesc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'EXCHANGERATE',@exchange_rate,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'FB',@fb_id,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'LASTMODIFICATIONBY',@modifiedby,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'LASTMODIFIEDDATE',@modifieddate,'SPY',@doc_key,@guid)          
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'LCNUMBER',@lcnumber,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'PAYAMOUNT',@pay_amount,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'PAYCURRENCYCODE',@pay_currency,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'PAYDATE',@pay_date,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'PAYMENTROUTE',@payment_routedesc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'PAYMODE',@paymodedesc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'PPVOUCHERTYPE',@ppvouchertypedesc,'SPY',@doc_key,@guid)          
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'PRIORITY',@prioritydesc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'RELPAYOU',@relpay_ou_desc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)     
  values(@guid_itr,'REMARKS',@remarks,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'REQUESTDATE',@request_date,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'STATUS',@status_desc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'SUPPLIER',@supp_code,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'SUPPLIERACCOUNTCODE',@account_code,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'SUPPLIERAREA',@supp_area_name,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'SUPPLIERDOCUMENTAMOUNT',@supp_doc_amt,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'SUPPLIERDOCUMENTDATE',@supp_doc_date,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'SUPPLIERDOCUMENTNUMBER',@supp_doc_no,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'SUPPLIERNAME',@suppliername,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'VOUCHERNUMBER',@voucher_no,'SPY',@doc_key,@guid)      
  /* code added for the dts id 11H103_spy_00048 starts */      
 insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'PRJOU',@PRJOU,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'PRJSUBPRJCD',@PRJSUBPRJCD,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'PRJSUBPRJDESC',@PRJSUBPRJDESC,'SPY',@doc_key,@guid)      
  /* code added for the dts id 11H103_spy_00048 ends*/      
     
 /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) starts here*/      
 end      
 --epe-15519      
 else if @area_code = 'SPYADBAUTH'      
 begin      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'ACTIONONCUSTOMERBALANCECHECK',@ACTIONONCUSTOMERBALANCECHECK,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'ACTIONUNADJPP',@ACTIONUNADJPP,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'CREATEDDATE',@CREATEDDATE_adv,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'CREATIONBY',@CREATIONBY,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'DDOPTION',@DDOPTION,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'DOCPRIORITY',@DOCPRIORITY,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'ELECPAYMENT',@ELECPAYMENT_adv,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'EXCHANGERATE',@EXCHANGERATE,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'FBHDR',@FBHDR,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'PAYBATCHNOTYPENO',@PAYBATCHNOTYPENO,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'PAYBATCHNUMBER',@PAYBATCHNUMBER,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'PAYCURRENCYCODE',@PAYCURRENCYCODE,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'PAYDATE',@PAYDATE,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'PAYGROUPNUMBER',@PAYGROUPNUMBER,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'PAYMENTROUTE',@PAYMENTROUTE,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'PAYMODE',@PAYMODE,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'RELPAYOU',@RELPAYOU,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'REMARKS',@REMARKS_adv,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'REQUESTDATE',@REQUESTDATE,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'STATUS',@STATUS_adv,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid) values(@guid_itr,'VOUCHERNOTYPENO',@VOUCHERNOTYPENO,'SPY',@doc_key,@guid)      
        
 end      
 --epe-15519      
 else      
 begin      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'ACTIONONUNADJPP',@actiononunadjpp_desc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'BANKCASH',@bank_cash_code,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'BANKDESCRIPTION',@bankdesc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'DDOPTION',@pay_chargeby_desc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'DOCPRIORITY',@prioritydesc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'ELECPAYMENT',@elecpayment_desc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'EXCHANGERATE',@exchange_rate,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'FB',@fb_id,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'PAYBATCHNUMBER',@voucher_no,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'PAYCURRENCYCODE',@pay_currency,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'PAYDATE',@pay_date,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'PAYMENTROUTE',@payment_routedesc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'PAYMODE',@paymodedesc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'RELPAYOU',@relpay_ou_desc,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'REMARKS',@remarks,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'REQUESTDATE',@request_date,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)       
  values(@guid_itr,'STATUS',@status_desc,'SPY',@doc_key,@guid)      
 --deepika      
  insert into fin_wf_param_codeval(guid,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'TOTALPAYAMOUNTBASE',@TotalPayAmountBase,'SPY',@doc_key,@guid) --10H109_spy_00032      
  insert into fin_wf_param_codeval(guid,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'TOTALPAYAMOUNTTRAN',@TotalPayAmountTran,'SPY',@doc_key,@guid)--10H109_spy_00032      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'CREATEDDATE',@createddate,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'CREATIONBY',@createdby,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'LASTMODIFICATIONBY',@modifiedby,'SPY',@doc_key,@guid)      
  insert into fin_wf_param_codeval(guid ,param_code,param_value,component_id,doc_key,parent_guid)      
  values(@guid_itr,'LASTMODIFIEDDATE',@modifieddate,'SPY',@doc_key,@guid)          
      
 end      
 /* code added  for the DFN ID:ES_spy_00219(10H109_spy_00010) ends here*/      
     
	 --EPE-46106 starts
	if	@status_code	IN	('F')
	begin
		update	wf_by_mailreply_dtl
		set		record_status		=	'C'
		where	doc_key				=	@doc_key
		AND		record_status		=	'F'			
	end
	
	insert into wf_by_mailreply_hdr
	(
	wf_token,wf_docou,doc_key,doc_unique_id,created_date,created_by
	)
	select
	@guid_itr,@ctxt_ouinstance,rtrim(@doc_key),@voucher_no,dbo.res_getdate(@ctxt_ouinstance),@ctxt_user
	--EPE-46106 ends

	/* Code added by Shrimalavika M begins */
	Declare @Pathid		varchar(50)		,
	@doc_value			numeric(28,2)	,
	@doc_date			date	,	
	 @component	varchar(40)	=	'SPY',
	@activity	varchar(50)	=	'SPYAUSCPV'

	select	
				--@creator			=	createdby
					@doc_date		=	due_date
				,	@doc_value		=   dtl.tran_amount
				 from spy_paybatch_dtl_tmp  tmp with(nolock)
				 join scmdb..spy_paybatch_hdr  hdr with(nolock)	
				 on tmp.paybatch_no	=	hdr.paybatch_no
				 and tmp.ou_id		=	hdr.ou_id
				 join spy_paybatch_dtl dtl with(nolock)
				 on hdr.ou_id			=	dtl.ou_id
				 and hdr.paybatch_no	=	dtl.paybatch_no
				 where hdr.paybatch_no	=	isnull(@voucher_no,hdr.paybatch_no)
				 and	hdr.ou_id		=	@ctxt_ouinstance
				 and	tmp.guid		=	@guid

	select @Pathid		=	wfi_path							
	from zrit_workflow_iedk_view with(nolock)
	where  wfi_ouid		= @ctxt_ouinstance            
	and wfi_status		= 'AC'            
	and wfi_component	= @component             
	and wfi_activity	= @activity  
	and @doc_value between wfi_val_from and wfi_val_to
	and @doc_date	>	getdate()

	/* Code added by Shrimalavika M Ends */
 Select      
 '~#~'   'DOC_ACTION_COMBO_VAL',       
 @doc_activitycd  'DOC_ACTIVITYCD',       
 @area_code  'DOC_AREA_CODE',       
 @self_auth_flag   'DOC_AUTH_FLAG', --epe-15519      
 '~#~'   'DOC_CHAR_DUMMY_1',       
 'FIN'   'DOC_CHAR_DUMMY_2',       
 'SPY'   'DOC_COMPONENTCD',       
 NULL   'DOC_CURRENT_STATE',       
 --Code commented and added for Defect ID 12H124_GENERAL_00004 starts here      
 --NULL   'DOC_DATE',       
 convert(nvarchar(10), dbo.RES_Getdate(@ctxt_ouinstance), 120)  'DOC_DATE',       
 --Code commented and added for Defect ID 12H124_GENERAL_00004 ends here      
 NULL   'DOC_FLOAT_DUMMY_1',       
 NULL   'DOC_FLOAT_DUMMY_2',       
 @guid   'DOC_GUID',       
 @doc_key  'DOC_KEY',       
 @ctxt_user  'DOC_NEWST_TODO_USER',       
 @ctxt_ouinstance 'DOC_NEWST_TODO_USER_OU',       
 @ctxt_ouinstance 'DOC_ORGUNITID',       
 NULL   'DOC_PARAMETER',       
 @doc_taskcd  'DOC_TASKCD',       
 @voucher_no  'DOC_UNIQUE_ID',       
 @ctxt_ouinstance 'LOG_ORGUNITID',       
 @ctxt_role  'LOG_ROLE',       
 @ctxt_user  'LOG_USER',       
 @wf_ou   'WF_CONTEXT_OU'      
       
Set nocount off      
      
End      
     








