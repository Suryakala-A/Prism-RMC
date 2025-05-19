/*$File_version=MS4.3.0.15$*/      
/******************************************************************************************      
file name : so_is_sp_wf_exec_out.sql      
version  : 4.0.0.0      
procedure name : so_is_sp_wf_exec_out      
purpose  :       
author  : venkata ganesh      
date  : 22 jan 2003      
component name : nso      
method name :       
      
objects referred      
 object name  object type  operation      
       (insert/update/delete/select/exec)       
modification details      
 modified by  modified on  remarks      
 Appala Raju.K  8/23/2004  NSODMS41SYTST_000165      
 Appala Raju.K  23 Nov 2006  NSODms412at_000412      
 Damodharan. R  08 Aug 2007  NSODMS412AT_000505      
 Anitha N   19 May 2008  DMS412AT_NSO_00048      
 Veangadakrishnan R 23/03/2009  ES_NSO_00206      
 Vadivukkarasi A  07-09-2009  9H123-1_NSO_00030      
 Lavanya K J   29-04-2011  11H103_SLA_00001      
 Lavanya    16 May 2011  ES_SOD_00018(11H103_SOD_00001)      
 Sejal N Khimani  25 Jan 2014  13H120_Supp_00004:ES_Supp_00320      
 Kandavel S   21/03/2016  ES_NSO_01107  \    
     
/* sasirekha k    22/03/2020  EPE-18180     */    
/* Akash V        07/03/2022  KPE-623      */  
/* Sheerapthi KR  12/04/2023  EPE-60232	   */
/* Sheerapthi KR  29/05/2023  EPE-60232	   */
/* Mancy Biska N   01-03-2023  RCEPL-591   */
/* Kathiravan P	   21/03/2024  RCEPL-637   */
/* Kathiravan P    02/04/2024  EPE-79907   */
/*Shrimalavika M  22-01-2025  RMC-SAL-29 */
******************************************************************************************/       
create   procedure so_is_sp_wf_exec_out      
 @calling_service udd_ctxt_service,      
 @ctxt_language   udd_ctxt_language,      
 @ctxt_ouinstance    udd_ctxt_ouinstance,      
 @ctxt_service    udd_ctxt_service,      
 @ctxt_user     udd_ctxt_user,       
 @guid   udd_guid,      
 @transactionno  udd_documentno,      
 @m_errorid  udd_int output      
as      
begin      
 set nocount on      
      
 select @m_errorid = 0      
      
 select  @calling_service = ltrim(rtrim(upper(@calling_service)))      
 if  @calling_service = '~#~'       
    select @calling_service = null      
 if  @ctxt_language = -915       
  select @ctxt_language = null      
 if  @ctxt_ouinstance = -915       
    select @ctxt_ouinstance = null      
 select  @ctxt_service = ltrim(rtrim(@ctxt_service))      
 if  @ctxt_service = '~#~'       
    select @ctxt_service = null      
 select  @ctxt_user = ltrim(rtrim(@ctxt_user))      
 if  @ctxt_user = '~#~'       
    select @ctxt_user = null      
 select  @guid = ltrim(rtrim(@guid))      
 if  @guid = '~#~'       
    select @guid = null      
 select  @transactionno = ltrim(rtrim(upper(@transactionno)))      
 if  @transactionno = '~#~'       
    select @transactionno = null      
      
      
 declare @auth_wf_flag udd_int,      
  @del_wf_flag  udd_int,      
  @hold_wf_flag  udd_int,      
  @rel_wf_flag  udd_int,      
  @scl_wf_flag  udd_int,      
  @order_status  udd_metadata_code,      
  @workflow_status udd_wfstatename,      
  @wf_ou    udd_ctxt_ouinstance,      
  @m_errorid_tmp  udd_int,      
  /*Code added for the DTS id:ES_NSO_00206 starts here*/      
  @companycode  udd_companycode ,      
  @workflow_app  udd_metadata_code,      
  @workflow_tran  udd_remarks,      
  @prev_order_status udd_metadata_code,      
  @doc_key   udd_wfdockey,      
  @order_status_tmp udd_metadata_code,      
  @isdocauthorized udd_int,      
  @isdocpend_auth  udd_int      
    /*Code added for the DTS id:ES_NSO_00206 ends here*/   

  /* Code added for EPE-60232 begins */
  if @calling_service in ('APP','REJ')
	begin
		select	@calling_service	=	newcallingservice
		from	erp_cmn_notification_metadata	with(nolock)
		where   component_id		=    'SAL_CON'
		and		callingservice		=    @calling_service
		and     language_id			=    @ctxt_language
	end--if @callingservice in ('APP','REJ')

  if	@calling_service	in ('so_CnCrMn_Ser_Sbt','so_cnedmn_ser_sbt','so_cnaumn_ser_ret','so_cnauen_ser_ret','so_cnaumn_ser_sav','so_cnaumn_ser_sbt','so_cnauen_ser_sbt','so_cnammn_ser_sbt','so_cnedmn_ser_del','so_cneden_ser_del','so_cncrbs_ser_sbt','so_cncrag_ser_sbt') 
  BEGIN
  declare	@return_val		udd_int,
			--@status_tmp		udd_metadata_code,	--Code commented for EPE-60232 
			@amendment_no	udd_int,
			@status			udd_status

			Select	@amendment_no	= conhdr_amend_no,
					@status			= conhdr_status
			from so_contract_hdr
			where	conhdr_contract_no	=	@transactionno
			and		conhdr_ou			=	@ctxt_ouinstance

 select		@auth_wf_flag		= 	1,
			@del_wf_flag		= 	1,
			@hold_wf_flag		= 	1,
			@rel_wf_flag		= 	1,
			@scl_wf_flag		= 	1,
			@workflow_app		=	'N'

select @doc_key = 'SAL_CON' + '$~$'+ convert(nvarchar(28),@ctxt_ouinstance)+ '$~$'+ @transactionno+'$~$'+ convert(nvarchar(4),@amendment_no)

if (@status = 'DR')                
	Begin              
		if exists (	select 'X'              
					from  	so_contract_hdr 	a (nolock), 
							wf_mypage_todo_vw 	b (nolock)              
					where 	a.conhdr_contract_no + '~'+CONVERT(nvarchar(28),a.conhdr_amend_no)= b.doc_unique_id 
					and 	b.component_name  		=	'NSO'            
					and 	b.wf_instance_status  	=	'P'              
					and  	a.conhdr_contract_no  	=	@transactionno
					and		a.conhdr_amend_no		=	@amendment_no
					and		a.conhdr_ou				=	@ctxt_ouinstance
					and		doc_key					=	@doc_key
				)              
		begin                
			select @del_wf_flag  = 0	
		end 
	End

	if @amendment_no > 0
	begin
		select	@workflow_app		=	dbo.workflowapp_fet_fn    (@ctxt_user,@ctxt_ouinstance,'NSO','NSOCO','SAL_CON_AMAU')
	end
	else
	begin
		select	@workflow_app		=	dbo.workflowapp_fet_fn(@ctxt_user,@ctxt_ouinstance,'NSO','NSOCO','SAL_CON_CRAU')
	end
 /* Code added by Shrimalavika M for contract supper approver logic against RMC-SAL-29  starts */
 
     if exists (select 'X'          
    from depdb..fw_admin_usrrole with(nolock)          
    where RoleName = 'SUPER_APPROVER'          
    and UserName = @ctxt_user          
   )          
   Begin   
  
    select @workflow_app = 'N'               
	End         
	
 /* Code added by Shrimalavika M for contract supper approver logic against RMC-SAL-29  Ends */         
if @workflow_app ='N'
	begin
		select	@auth_wf_flag		'AUTH_WF_FLAG', 
				@del_wf_flag		'DEL_WF_FLAG', 
				@hold_wf_flag		'HOLD_WF_FLAG', 
				@rel_wf_flag		'REL_WF_FLAG', 
				@scl_wf_flag		'SCL_WF_FLAG'
		return
	end--if @workflow_app ='N'           

    if    @return_val = 1
    begin
		return
	end	

	if @calling_service in ('so_cnedmn_ser_del','so_cneden_ser_del')
	begin
	  select	@del_wf_flag	=	0
	end

	if	@calling_service	in ('so_cnedmn_ser_sbt','so_cnaumn_ser_ret','so_cnauen_ser_ret','so_cnaumn_ser_sav','so_cnaumn_ser_sbt','so_cnauen_ser_sbt','so_cnammn_ser_sbt','so_cncrbs_ser_sbt','so_cncrag_ser_sbt') and @status <> 'DR'

	begin
		select	@auth_wf_flag	=	0
	end
	/*Code Added for EPE-60232 begins*/
	if	@calling_service	in	('so_cncrag_ser_sbt','so_cncrbs_ser_sbt')
	begin
		select	@auth_wf_flag	=	0
	end
	/*Code Added for EPE-60232 ends*/

	select @guid	=	newid()
END
ELSE
BEGIN
  /* Code added for EPE-60232 ends */


 select @m_errorid_tmp = 0      

  /* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Begins */      
 insert into ict_po_so_tmp      
 ( tmp_guid, tmp_sono)      
 values      
 ( @guid, @transactionno)      
       
  /* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Ends */      
 select @auth_wf_flag = 1,      
  @del_wf_flag = 1,      
  @hold_wf_flag = 1,      
  @rel_wf_flag = 1,      
  @scl_wf_flag = 1,      
  @isdocauthorized = 1,/*Code added for the DTS id:ES_NSO_00206*/      
  @isdocpend_auth  = 1/*Code added for the DTS id:ES_NSO_00206*/      
       
 /* Code added for ITS ID : ES_NSO_01107 Begins */      
 declare @amendno  udd_int      
       
 select @amendno  = sohdr_amend_no      
 from so_order_hdr(nolock)      
 where sohdr_order_no = @transactionno      
 and  sohdr_ou  = @ctxt_ouinstance      
 /* Code added for ITS ID : ES_NSO_01107 Ends */      
        
 /*Code added for the DTS id:ES_NSO_00206 starts here*/      
       
   /*code added for notification starts */    
    
  if  @calling_service in (select  callingservice    
     from    erp_cmn_notification_metadata   
     where   component_id  =    'NSO'    
     and     language_id   =    @ctxt_language)    
  begin    
  select @calling_service = newcallingservice     
  from erp_cmn_notification_metadata    
  where component_id='NSO'    
  and callingservice=@calling_service    
    
 end    
  /*code added for notification ends*/    
  
  -- Code added for KPE-623 begins   
  if @calling_service ='so_scen_ser_sbt' 
begin 
	if not exists( select 'X'
					from	so_upd_status_tmp(nolock)
					where	guid		=	@guid 
					and		order_no	=	@transactionno )
	begin    
		select	1 'AUTH_WF_FLAG',     
				1 'DEL_WF_FLAG',     
				1 'HOLD_WF_FLAG',    
				1 'REL_WF_FLAG',    
				1 'SCL_WF_FLAG'
		return
	end    
end 
  -- Code added for KPE-623 ends 
  
 /* Code commented and added for ITS ID : ES_NSO_01107 Begins */      
 --if @calling_service in ('sopp_AmMn_ser_Sbt1','sopp_AmMn_ser_Auth1','sopp_AmMn_ser_AuAm1','NSO_amd_Ser_ret')--Added for the DTs id :9H123-1_NSO_00030      
 if @calling_service in ('sopp_AmMn_ser_Sbt1','sopp_AmMn_ser_Auth1','sopp_AmMn_ser_AuAm1','NSO_amd_Ser_ret') or  ((@calling_service in ('so_crdtc_ser_sbt','so_critc_ser_sbt')) and (@amendno >0))      
 /* Code commented and added for ITS ID : ES_NSO_01107 Ends */      
 begin      
  select @workflow_tran ='AMAU'      
 end      
 else      
 begin      
  select @workflow_tran ='CRAU'      
 end      
      
 select @workflow_app = dbo.workflowapp_fet_fn(@ctxt_user,@ctxt_ouinstance,'NSO','NSOSO',@workflow_tran)      
      
 select @workflow_app =isnull(@workflow_app,'N')      
 /* Code added by Shrimalavika M starts */ 
 
  if exists (
				select 'X'
				from depdb..fw_admin_usrrole with(nolock)
				where RoleName	=	'SUPER_APPROVER'
				and UserName	=	@ctxt_user
			)
			Begin
				select @workflow_app	=	'N'
		
			update a
			set a.user_closed	=	'C'
			from wfm40..wf_mypage_todo a with(nolock)
			where ou_code	=@ctxt_ouinstance
			and doc_key like '%'+@transactionno+'%'
			 and  user_closed	=	'P'

End

/* Code added by Shrimalavika M Ends */
 if @workflow_app ='N'      
 begin      
  select 1 'AUTH_WF_FLAG',       
    1 'DEL_WF_FLAG',       
    1 'HOLD_WF_FLAG',      
    1 'REL_WF_FLAG',      
    1 'SCL_WF_FLAG'      
  return      
 end      
 /*Code Added for the DTS id:ES_NSO_00206 ends here*/      
      
 exec scm_get_dest_ou      
  @ctxt_ouinstance,      
  @ctxt_language,      
  @ctxt_user,      
  'NSO',      
  'WFMTASKBAS',      
  @wf_ou out,      
  @m_errorid_tmp out      
      
 if @m_errorid_tmp <> 0      
 begin      
  /*Code Added for the DTS id:ES_NSO_00206 starts here*/      
  if @workflow_app ='Y'      
  begin      
   --'Component interaction has not set between Normal Sale Order and Workflow.'      
   exec fin_german_raiserror_sp 'NSO',@ctxt_language,1000      
  end      
  /*Code Added for the DTS id:ES_NSO_00206 ends here*/      
      
  select 1 'AUTH_WF_FLAG',       
    1 'DEL_WF_FLAG',       
    1 'HOLD_WF_FLAG',      
    1 'REL_WF_FLAG',      
    1 'SCL_WF_FLAG'      
  return      
 end       
    /*select @transactionno  = sohdr_order_no      
  from  sotmp_order_hdr (nolock)      
  where  sohdr_guid   = @guid  */    
 if @calling_service in ('SOPP_CRMN_SER_EDT1','SOPP_CRMN_SER_SBT1')      
 begin      
  select @transactionno  = sohdr_order_no      
  from  sotmp_order_hdr (nolock)      
  where  sohdr_guid   = @guid      
 end      
      
 if(@transactionno is null)      
 begin      
  select @transactionno  = sohdr_order_no      
  from  sotmp_order_hdr (nolock)      
  where  sohdr_guid   = @guid      
 end      
      
 select  @order_status   = current_status,      
   @prev_order_status = isnull(prev_status,'')      
 from  so_upd_status_tmp (nolock)      
 where  guid   = @guid      
 and  order_no  = @transactionno      
      
 select @workflow_status = sohdr_workflow_status,      
   @order_status_tmp= sohdr_order_status --Added for the DTS id :ES_NSO_00206      
 from  so_order_hdr (nolock)      
 where  sohdr_ou   = @ctxt_ouinstance      
 and  sohdr_order_no  = @transactionno      
       
 --Added for DTS ID: ES_NSO_00206 starts here      
 select @doc_key = 'NSO' + '$~$'+ convert(nvarchar(4),@ctxt_ouinstance)+ '$~$'+ @transactionno      
      
 if exists( select 'X'       
    from wf_doc_status_vw(nolock)      
    where doc_unique_id = @transactionno      
    and  doc_key    = @doc_key      
    and  doc_status   = 'AUTH'      
  and  user_closed   = 'C')      
 begin  
 select @isdocauthorized = 0      
 end      
      
 if exists( select 'X'       
    from wf_doc_status_vw(nolock)      
    where doc_unique_id = @transactionno      
    and  doc_key    = @doc_key      
    and  doc_status   not in ('Fresh','AMD')      
    and  user_closed   = 'P')      
 begin      
  select @isdocpend_auth = 0      
 end      
      
 /*At the time of document creation workflow is not enabled and at the time of document       
 authorization if workflow enabled means then workflow IS should not be       
 called when calling service other than Edit and amend because       
 these service are initiaing services. In any case workflow IS called then error       
 is thron like "No document is available for authorize"*/      
 if @order_status_tmp in ('FR','AM') and @workflow_status is null       
 /* Code Modified by Lavanya against the defect id ES_SOD_00018(11H103_SOD_00001) begins */      
  and @calling_service not in ('sopp_CrMn_ser_Edt1','sopp_AmMn_ser_Sbt1','so_rlcrmn_ser_genrel','so_RlEdMn_Ser_GenRel','PVL_SLA_Sr_Gen','Sod_mnord_Ser_crso','so_crdtc_ser_sbt','so_critc_ser_sbt') --code added for DTSid:ES_NSO_01107) -- code changed for 11

  
    
--H103_SLA_00001      
 /* Code Modified by Lavanya against the defect id ES_SOD_00018(11H103_SOD_00001) ends */      
 begin      
  if exists( select 'X'       
     from wf_doc_status_vw(nolock)      
     where doc_unique_id = @transactionno      
     and  doc_key    = @doc_key      
     and  doc_status   in ('Fresh','AMD')      
     and  user_closed   = 'P')      
  begin      
   select @transactionno = @transactionno      
  end      
  else      
  begin      
   select 1 'AUTH_WF_FLAG',       
     1 'DEL_WF_FLAG',       
     1 'HOLD_WF_FLAG',      
     1 'REL_WF_FLAG',      
     1 'SCL_WF_FLAG'      
   return      
  end      
 end      
 /* Code Modified by Lavanya against the defect id ES_SOD_00018(11H103_SOD_00001) begins */      
 if @calling_service in ('sopp_CrMn_ser_sbt1', 'sopp_CrMn_ser_Edt1', 'sopp_CrMn_ser_Auth1',      
       'sopp_AmMn_ser_Sbt1', 'sopp_AmMn_ser_Auth1', 'sopp_CrMn_ser_CrAu1',      
       'sopp_AmMn_ser_AuAm1', 'NSOmn69_serSave1',  'NSOSER042',      
       'so_CrRef_Ser_Sbt',  'SO_RLCRMN_SER_GENREL', 'SO_RLEDMN_SER_GENREL',      
       'so_crdtc_ser_sbt',  'so_critc_ser_sbt', --code added for DTSid:ES_NSO_01107      
       'PVL_SLA_Sr_Gen','Sod_mnord_Ser_crso') -- -- code changed for 11H103_SLA_00001      
 /* Code Modified by Lavanya against the defect id ES_SOD_00018(11H103_SOD_00001) ends */      
 begin      
  if @prev_order_status in ('DR','LI','AU','RT','') and @order_status in ('DR','LI','DL','HD','RT')      
  begin      
   select @auth_wf_flag = 1      
  end      
  else      
  begin      
   select @auth_wf_flag = 0      
  end      
      
  if @prev_order_status = 'HD' and @order_status = 'AU'      
  begin      
   select @auth_wf_flag = 1      
  end      
 end 
 
	--Code added for EPE-79907 begins
	if  @calling_service in ('sopp_CrMn_ser_Del1')
	begin
		if @prev_order_status in ('FR','AM') and @order_status in ('DR','RT','LI','DL','HD') and @workflow_status is not null    
		begin
			 select	@del_wf_flag	=	0
		end
	end
	--Code added for EPE-79907 ends
      
 --if  @calling_service in ('sopp_CrMn_ser_Edt1','NSO_Mnt_SerRet','sopp_CrMn_ser_Del1',    --Code commented for EPE-79907    
 if  @calling_service in ('sopp_CrMn_ser_Edt1','NSO_Mnt_SerRet',	--Code added for EPE-79907
 'so_crdtc_ser_sbt',  'so_critc_ser_sbt', --code added for DTSid:ES_NSO_01107      
  'NSO_amd_Ser_ret')--Added for the DTs id :9H123-1_NSO_00030      
 begin      
  if @prev_order_status in ('FR','AM') and @order_status in ('DR','RT','LI','DL','HD') and @workflow_status is not null      
  begin      
   select @auth_wf_flag = 0 --1     --Modified for RCEPL-637    
   select @del_wf_flag = 1	--0     --Modified for RCEPL-637
  end  
  


  /*Code modified for the DTs id :9H123-1_NSO_00030 starts here*/      
--   if @calling_service = 'NSO_Mnt_SerRet' and @prev_order_status = 'FR' and @order_status = 'RT'       
  if @calling_service in('NSO_Mnt_SerRet','NSO_amd_Ser_ret') and @prev_order_status in('FR','AM') and @order_status = 'RT'       
  /*Code modified for the DTs id :9H123-1_NSO_00030 ends here*/     
   and (@workflow_status not in ('Fresh','AMD') or @isdocauthorized = 0 or @isdocpend_auth = 0) 
  begin      
   select @auth_wf_flag =0 --1     --Modified for RCEPL-591 
   select @del_wf_flag = 1      
   select @scl_wf_flag = 1--0        --Modified for RCEPL-591 
  end      
 end         
      
 if @calling_service in ('so_ScMn_Ser_Sbt','so_ScEn_Ser_Sbt')      
 begin      
  if exists( select 'X'       
     from wf_doc_status_vw(nolock)      
     where doc_unique_id = @transactionno      
     and  doc_key    = @doc_key      
     )      
  begin      
   select  @auth_wf_flag = 0       
  end      
  else      
  begin      
   select  @auth_wf_flag = 1      
  end      
 end      
      
 if @calling_service in ('so_HdMn_Ser_RSbt','so_HdEn_Ser_RSbt')      
 begin      
  if exists( select 'X'       
     from wf_doc_hold_dtl_vw(nolock)      
     where doc_unique_id = @transactionno      
     and  doc_key    = @doc_key      
     and  hold_status_flag = 'Y'      
     )      
  begin      
   select @rel_wf_flag = 0       
  end      
  else      
  begin      
   select @rel_wf_flag = 1      
  end      
 end      
      
 if @calling_service in ('so_HdMn_Ser_HSbt','so_HdEn_Ser_HSbt')      
 begin      
  if exists( select 'X'     
     from wf_doc_status_vw(nolock)      
     where doc_unique_id = @transactionno      
     and  doc_key    = @doc_key      
     and  user_closed  = 'P'      
     )      
  begin      
   select @hold_wf_flag = 0       
  end      
  else      
  begin      
   select @hold_wf_flag = 1      
  end      
 end      
  END --Code added for EPE-60232

  /* Code added by Shrimalavika M Begins */          
  /*          
declare @bu varchar(40)          
select @bu = bu_id          
from emod_ou_bu_map with(nolock)          
where ou_id = @ctxt_ouinstance          
          
  if @bu = 'AGG'          
Begin          
          
 if exists (select 'X' from          
    scmdb..so_order_hdr with(nolock)          
     join so_order_item_dtl with(nolock)          
     on sohdr_ou     = sodtl_ou          
     and sohdr_order_no   = sodtl_order_no          
    join item_var_bu_vw with(nolock)          
    on item_code = sodtl_item_code          
    where sohdr_order_no     =  isnull(@transactionno,sohdr_order_no)          
and sodtl_ou      =  @ctxt_ouinstance          
     and category      not in ('100024','100032','100030','100126')     
 )          
    Begin          
             
     select @workflow_app = 'N'          
     select @auth_wf_flag 'AUTH_WF_FLAG',                 
     @del_wf_flag 'DEL_WF_FLAG',                 
     @hold_wf_flag 'HOLD_WF_FLAG',                
     @rel_wf_flag 'REL_WF_FLAG',                
@scl_wf_flag 'SCL_WF_FLAG'             

     return         
    End          
          
End          
/* Code added by Shrimalavika M Ends */*/  

 select @auth_wf_flag 'AUTH_WF_FLAG',       
  @del_wf_flag 'DEL_WF_FLAG',       
  @hold_wf_flag 'HOLD_WF_FLAG',      
  @rel_wf_flag 'REL_WF_FLAG',      
  @scl_wf_flag 'SCL_WF_FLAG'      
/*Code Added for the DTS id:ES_NSO_00206 ends here*/      
/*Code commented for the DTS id:ES_NSO_00206 starts here*/      
/*      
/* Code modified by Raju against NSODms412at_000412 starts*/      
 if @calling_service like 'SOPP_%'      
 begin      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in ('SOPP_CRMN_SER_EDT','SOPP_CRMN_SER_SBT')      
  if @calling_service in ('SOPP_CRMN_SER_EDT','SOPP_CRMN_SER_SBT','SOPP_CRMN_SER_EDT1','SOPP_CRMN_SER_SBT1')      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   select @transactionno  = sohdr_order_no      
   from  sotmp_order_hdr (nolock)      
   where  sohdr_guid  = @guid      
  end      
--DMS412AT_NSO_00048 begins      
  if(@transactionno is null)      
  begin      
   select @transactionno  = sohdr_order_no      
   from  sotmp_order_hdr (nolock)      
   where  sohdr_guid  = @guid      
  end      
--DMS412AT_NSO_00048 ends      
  select  @order_status  = sohdr_order_status      
  from  so_order_hdr (nolock)      
  where  sohdr_ou  = @ctxt_ouinstance      
  and  sohdr_order_no  = @transactionno      
      
  select @workflow_status = sohdr_workflow_status      
  from  so_order_hdr (nolock)      
  where  sohdr_ou  = @ctxt_ouinstance      
  and  sohdr_order_no  = @transactionno      
       
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in ('SOPP_CRMN_SER_SBT','SOPP_AMMN_SER_SBT','SOPP_CRMN_SER_EDT','SOPP_CRMN_SER_CRAU','SOPP_CRMN_SER_AUTH','SOPP_AMMN_SER_AUAM','SOPP_AMMN_SER_AUTH','NSOSER042')      
  if @calling_service in ('SOPP_CRMN_SER_SBT','SOPP_AMMN_SER_SBT','SOPP_CRMN_SER_EDT','SOPP_CRMN_SER_CRAU','SOPP_CRMN_SER_AUTH','SOPP_AMMN_SER_AUAM','SOPP_AMMN_SER_AUTH','NSOSER042')      
   or @calling_service in ('SOPP_CRMN_SER_SBT1','SOPP_AMMN_SER_SBT1','SOPP_CRMN_SER_EDT1','SOPP_CRMN_SER_CRAU1','SOPP_CRMN_SER_AUTH1','SOPP_AMMN_SER_AUAM1','SOPP_AMMN_SER_AUTH1','NSOSER0421')      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   select @auth_wf_flag = 0 --DMS412AT_NSO_00048      
  end      
  --If order is in draft status. No workflow      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in ('SOPP_CRMN_SER_SBT','SOPP_CRMN_SER_EDT','SOPP_CRMN_SER_CRAU','SOPP_CRMN_SER_AUTH','SOPP_AMMN_SER_AUAM','SOPP_AMMN_SER_AUTH','NSOSER042') and @order_status = 'DR'      
  if @calling_service in ('SOPP_CRMN_SER_SBT','SOPP_CRMN_SER_EDT','SOPP_CRMN_SER_CRAU','SOPP_CRMN_SER_AUTH','SOPP_AMMN_SER_AUAM','SOPP_AMMN_SER_AUTH','NSOSER042',      
        'SOPP_CRMN_SER_SBT1','SOPP_CRMN_SER_EDT1','SOPP_CRMN_SER_CRAU1','SOPP_CRMN_SER_AUTH1','SOPP_AMMN_SER_AUAM1','SOPP_AMMN_SER_AUTH1','NSOSER0421') and @order_status = 'DR'      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   select @auth_wf_flag = 1      
  end      
       
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in ('SOPP_CRMN_SER_CRAU','SOPP_CRMN_SER_AUTH','SOPP_AMMN_SER_AUAM','SOPP_AMMN_SER_AUTH','SOPP_AMMN_SER_SBT') and (@workflow_status is null)      
--DMS412AT_NSO_00048 begins      
--  if @calling_service in ('SOPP_CRMN_SER_CRAU','SOPP_CRMN_SER_AUTH','SOPP_AMMN_SER_AUAM','SOPP_AMMN_SER_AUTH','SOPP_AMMN_SER_SBT','SOPP_CRMN_SER_CRAU1','SOPP_CRMN_SER_AUTH1','SOPP_AMMN_SER_AUAM1','SOPP_AMMN_SER_AUTH1','SOPP_AMMN_SER_SBT1') and (@workfl






  
    
     
      
       
      
      
      
      
      
      
      
      
      
      
      
      
      
      
ow_status is null)      
  if @calling_service in ('SOPP_CRMN_SER_AUTH','SOPP_AMMN_SER_AUAM','SOPP_AMMN_SER_AUTH',--'SOPP_AMMN_SER_SBT', /*Code commented for the DTS id:8H123-3_NSO_00001 */      
        'SOPP_CRMN_SER_AUTH1','SOPP_AMMN_SER_AUAM1','SOPP_AMMN_SER_AUTH1')--,'SOPP_AMMN_SER_SBT1')  /*Code commented for the DTS id:8H123-3_NSO_00001*/      
        and (@workflow_status is null)        
/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */        
--DMS412AT_NSO_00048 ends      
  begin      
   select @auth_wf_flag = 1      
  end      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in ('SOPP_CRMN_SER_DEL') and (@workflow_status is not null)      
  if @calling_service in ('SOPP_CRMN_SER_DEL','SOPP_CRMN_SER_DEL1') and (@workflow_status is not null)      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   select @del_wf_flag = 0      
  end      
       
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in ('SOPP_CRMN_SER_EDT') and (@workflow_status is null) and @order_status = 'FR'      
  if @calling_service in ('SOPP_CRMN_SER_EDT','SOPP_CRMN_SER_EDT1')       
      -- and (@workflow_status is null) /*Code commented for the DTS id:8H123-3_NSO_00001 */      
        and @order_status = 'FR'      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   select @auth_wf_flag = 0      
  end      
      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in ('SOPP_SCMN_SER_SBT')      
  if @calling_service in ('SOPP_SCMN_SER_SBT','SOPP_SCMN_SER_SBT1')      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   select @scl_wf_flag = 0      
  end      
       
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service = 'SOPP_HDMN_SER_HSBT' and (@workflow_status is not null)      
  if @calling_service in ('SOPP_HDMN_SER_HSBT','SOPP_HDMN_SER_HSBT1') and (@workflow_status is not null)      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   select @hold_wf_flag = 0      
  end      
       
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service = 'SOPP_HDMN_SER_RSBT' and (@workflow_status is not null)      
  if @calling_service in ('SOPP_HDMN_SER_RSBT','SOPP_HDMN_SER_RSBT1') and (@workflow_status is not null)      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   select @rel_wf_flag = 0      
  end      
      
 end      
 else      
 begin      
/* Code modified by Raju against NSODms412at_000412 ends*/      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  if @calling_service in ('SO_CRMN_SER_SBT','SO_CRREF_SER_SBT', 'SO_CRMN_SER_COPY','SO_CRMN_SER_SBT1','SO_CRREF_SER_SBT1', 'SO_CRMN_SER_COPY1')      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   select @transactionno = sohdr_order_no        
   from sotmp_order_hdr (nolock)      
   where sohdr_guid = @guid        
  end       
       
  select @order_status = sohdr_order_status      
  from so_order_hdr (nolock)      
  where sohdr_ou = @ctxt_ouinstance      
  and sohdr_order_no = @transactionno      
         
  select @workflow_status =  sohdr_workflow_status      
  from so_order_hdr (nolock)      
  where sohdr_ou = @ctxt_ouinstance      
  and sohdr_order_no = @transactionno       
       
  -- Call Process SP if called from Create / Authorize      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in('SO_AUMN_SER_SBT', 'SO_AUMN_SER_SAV', 'SO_AUEN_SER_SBT', 'SO_CRMN_SER_SBT', 'SO_CRMN_SER_COPY', 'SO_AMMN_SER_SBT', 'SO_AUMN_SER_RET', 'SO_CRREF_SER_SBT', 'NSOSER042', 'SO_AUEN_SER_SAV', 'SO_RLCRMN_SER_GENREL', SO_RLEDMN_SER_GENR



  
    
    
      
      
EL', 'SO_CRSCH_SER_SBT')      
--DMS412AT_NSO_00048 begins      
  if @calling_service in('SO_AUMN_SER_SBT', 'SO_AUMN_SER_SAV', 'SO_AUEN_SER_SBT', 'SO_CRMN_SER_SBT', 'SO_CRMN_SER_COPY', 'SO_AMMN_SER_SBT', 'SO_AUMN_SER_RET', 'SO_CRREF_SER_SBT', 'NSOSER042', 'SO_AUEN_SER_SAV', 'SO_RLCRMN_SER_GENREL', 'SO_RLEDMN_SER_GENRE



  
    
    
      
      
L', 'SO_CRSCH_SER_SBT','SO_AUMN_SER_SBT1', 'SO_AUMN_SER_SAV1', 'SO_AUEN_SER_SBT1', 'SO_CRMN_SER_SBT1', 'SO_CRMN_SER_COPY1', 'SO_AMMN_SER_SBT1', 'SO_AUMN_SER_RET1', 'SO_CRREF_SER_SBT1', 'NSOSER0421', 'SO_AUEN_SER_SAV1',      
   'SO_RLCRMN_SER_GENREL1', 'SO_RLEDMN_SER_GENREL1', 'SO_CRSCH_SER_SBT1')      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin        
   select @auth_wf_flag = 0      
  end      
--DMS412AT_NSO_00048 ends       
  --If order is in draft status. No workflow      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in ('SO_CRMN_SER_SBT', 'SO_CRMN_SER_COPY', 'SO_CRREF_SER_SBT', 'SO_AUMN_SER_SBT', 'SO_AUMN_SER_SAV', 'SO_AUEN_SER_SBT', 'SO_AUMN_SER_RET', 'NSOSER042', 'SO_AUEN_SER_SAV', 'SO_RLCRMN_SER_GENREL', 'SO_RLEDMN_SER_GENREL', 'SO_CRSCH_SE



  
    
    
      
      
      
R_SBT') and ( @order_status = 'DR' or @order_status = 'LI')      
  if @calling_service in ('SO_CRMN_SER_SBT', 'SO_CRMN_SER_COPY', 'SO_CRREF_SER_SBT', 'SO_AUMN_SER_SBT', 'SO_AUMN_SER_SAV', 'SO_AUEN_SER_SBT', 'SO_AUMN_SER_RET', 'NSOSER042', 'SO_AUEN_SER_SAV', 'SO_RLCRMN_SER_GENREL', 'SO_RLEDMN_SER_GENREL', 'SO_CRSCH_SER_




  
    
    
      
      
      
SBT',      
  'SO_CRMN_SER_SBT1', 'SO_CRMN_SER_COPY1', 'SO_CRREF_SER_SBT1', 'SO_AUMN_SER_SBT1', 'SO_AUMN_SER_SAV1', 'SO_AUEN_SER_SBT1', 'SO_AUMN_SER_RET1', 'NSOSER0421', 'SO_AUEN_SER_SAV1', 'SO_RLCRMN_SER_GENREL1', 'SO_RLEDMN_SER_GENREL1', 'SO_CRSCH_SER_SBT1') and ( 



  
    
    
      
      
      
@order_status = 'DR' or @order_status = 'LI')      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   select @auth_wf_flag = 1      
  end         
       
  -- Previous Workflow Status is Null, Donot post Workflow entry for Authorize      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in ('SO_AUMN_SER_SBT','SO_AUEN_SER_SBT', 'SO_AMMN_SER_SBT', 'SO_AUMN_SER_RET', 'SO_AUEN_SER_SAV') and (@workflow_status is null)      
  if @calling_service in ('SO_AUMN_SER_SBT','SO_AUEN_SER_SBT', 'SO_AMMN_SER_SBT', 'SO_AUMN_SER_RET', 'SO_AUEN_SER_SAV','SO_AUMN_SER_SBT1','SO_AUEN_SER_SBT1', 'SO_AMMN_SER_SBT1', 'SO_AUMN_SER_RET1', 'SO_AUEN_SER_SAV1') and (@workflow_status is null)      










  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   select @auth_wf_flag = 1      
  end      
       
  -- Authorize the Sales Order      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in ('SO_AUEN_SER_SBT')      
  if @calling_service in ('SO_AUEN_SER_SBT','SO_AUEN_SER_SBT1')      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   if exists (select 'X' from so_upd_status_tmp (nolock)      
     where guid  = @guid      
      and order_no = @transactionno      
      and current_status = 'AU')      
       
    select @transactionno = @transactionno      
   else      
    select @auth_wf_flag = 1      
  end      
       
  -- Return the Sales Order      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in ('SO_AUEN_SER_SAV')      
  if @calling_service in ('SO_AUEN_SER_SAV','SO_AUEN_SER_SAV1')      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   if exists (select 'X' from so_upd_status_tmp (nolock)      
      where guid  = @guid      
      and order_no = @transactionno      
     and current_status = 'RT')      
       
    select @transactionno = @transactionno      
   else      
    select @auth_wf_flag = 1      
  end      
       
  -- Deletion of Sales Order      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in ('SO_EDEN_SER_SBT', 'SO_EDMN_SER_DEL') and (@workflow_status is not null)      
  if @calling_service in ('SO_EDEN_SER_SBT', 'SO_EDMN_SER_DEL','SO_EDEN_SER_SBT1', 'SO_EDMN_SER_DEL1') and (@workflow_status is not null)      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
    select @del_wf_flag = 0      
         
   /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
   --if @calling_service in ('SO_EDEN_SER_SBT')      
   if @calling_service in ('SO_EDEN_SER_SBT','SO_EDEN_SER_SBT1')      
   /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
   begin      
    if exists (select 'X' from so_upd_status_tmp (nolock)      
       where guid  = @guid      
       and order_no = @transactionno      
       and current_status = 'DL')      
        
     select @transactionno = @transactionno      
    else      
     select @del_wf_flag = 1      
   end      
  end      
  
  -- Sales Order Edit      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
   --if @calling_service in ('SO_EDMN_SER_SBT') and (@workflow_status is null) and @order_status = 'FR'      
  if @calling_service in ('SO_EDMN_SER_SBT','SO_EDMN_SER_SBT1') and (@workflow_status is null) and @order_status = 'FR'      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
   begin        
    select @auth_wf_flag = 0      
   end      
         
  -- Sales Order Short Close      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
   --if @calling_service in ('SO_SCMN_SER_SBT','SO_SCEN_SER_SBT') and (@workflow_status is not null)      
  if @calling_service in ('SO_SCMN_SER_SBT','SO_SCEN_SER_SBT','SO_SCMN_SER_SBT1','SO_SCEN_SER_SBT1') and (@workflow_status is not null)      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
    select @scl_wf_flag = 0        
       
   /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
   --if @calling_service in ('SO_SCEN_SER_SBT')      
   if @calling_service in ('SO_SCEN_SER_SBT','SO_SCEN_SER_SBT1')      
   /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
   begin      
    if exists (select 'X' from so_upd_status_tmp (nolock)      
       where guid  = @guid      
       and order_no = @transactionno      
       and current_status = 'SC')      
        
     select @transactionno = @transactionno      
    else      
     select @scl_wf_flag = 1      
   end      
  end      
       
  -- Hold and Release are Notification Messages with different Doc. Keys. Hence, the Workflow Status need not be checked      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in ('SO_HDEN_SER_HSBT','SO_HDMN_SER_HSBT') --and (@workflow_status is not null)      
  if @calling_service in ('SO_HDEN_SER_HSBT','SO_HDMN_SER_HSBT','SO_HDEN_SER_HSBT1','SO_HDMN_SER_HSBT1') --and (@workflow_status is not null)      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   -- Call Process SP for Hold      
 --  select @hold_wf_flag = 0      
   select @auth_wf_flag = 0      
       
   /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
   --if @calling_service in ('SO_HDEN_SER_HSBT')      
   if @calling_service in ('SO_HDEN_SER_HSBT','SO_HDEN_SER_HSBT1')      
   /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
   begin      
    if exists (select 'X' from so_upd_status_tmp (nolock)      
       where guid  = @guid      
       and order_no = @transactionno      
       and current_status = 'HD')      
        
     select @transactionno = @transactionno      
    else      
     select @auth_wf_flag = 1      
   end      
  end      
       
  -- Hold and Release are Notification Messages with different Doc. Keys. Hence, the Workflow Status need not be checked      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
  --if @calling_service in ('SO_HDEN_SER_RSBT','SO_HDMN_SER_RSBT') --and (@workflow_status is not null)      
  if @calling_service in ('SO_HDEN_SER_RSBT','SO_HDMN_SER_RSBT','SO_HDEN_SER_RSBT1','SO_HDMN_SER_RSBT1') --and (@workflow_status is not null)      
  /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */      
  begin      
   -- Call Process SP for Hold      
 --  select @rel_wf_flag = 0      
   select @auth_wf_flag = 0      
       
   /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */      
   --if @calling_service in ('SO_HDEN_SER_RSBT')      
   if @calling_service in ('SO_HDEN_SER_RSBT','SO_HDEN_SER_RSBT1')      
   /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */     
   begin      
    if exists (select 'X' from so_upd_status_tmp (nolock)      
       where guid  = @guid      
       and order_no = @transactionno      
       and prev_status =  'HD')      
        
     select @transactionno = @transactionno      
    else      
     select @auth_wf_flag = 1      
   end      
  end      
/* Code modified by Raju against NSODms412at_000412 starts*/      
 end      
/* Code modified by Raju against NSODms412at_000412 ends*/      
      
 select @auth_wf_flag 'AUTH_WF_FLAG',       
  @del_wf_flag 'DEL_WF_FLAG',       
  @hold_wf_flag 'HOLD_WF_FLAG',      
  @rel_wf_flag 'REL_WF_FLAG',      
  @scl_wf_flag 'SCL_WF_FLAG'      
*/      
/*Code commented for the DTS id:ES_NSO_00206 ends here*/ 

 set nocount off      
end      




