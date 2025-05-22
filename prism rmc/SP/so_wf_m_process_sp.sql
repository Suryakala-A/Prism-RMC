/*$File_version=MS4.3.0.26$*/
/******************************************************************************************
file name	: so_wf_m_process_sp.sql
version		: 4.0.0.0
procedure name	: so_wf_m_process_sp
purpose		: 
author		: venkata ganesh
date		: 22 jan 2003
component name	: nso
method name	: 

objects referred
	object name		object type		operation
							(insert/update/delete/select/exec)	
modification details
	modified by			modified on		remarks
	Manjunatha			27 Mar 2004		NSODMS41SYTST_000071
	Appala Raju.K		8/23/2004		NSODMS41SYTST_000165
	Appala Raju.K		23 Nov 2006		NSODms412at_000412
	Damodharan. R		08 Aug 2007		NSODMS412AT_000505
	Damodharan. R		25 Oct 2007		NSODMS412AT_000546
	Anitha N			19 may 2008		DMS412AT_NSO_00048
	Veangadakrishnan R	23/03/2009		ES_NSO_00206
	Vadivukkarasi A		07-09-2009		9H123-1_NSO_00030
	Lavanya K J         29-04-2011		11H103_SLA_00001
	Lavanya				16 May 2011		ES_SOD_00018(11H103_SOD_00001)
	Indu Ram			04-Oct-2013		ES_NSO_00698
	Bharath A			22/09/2015		14H109_NSO_00014	
	Sejal N Khimani		12 Oct 2015		14H109_WFMCONFIG_00005	
	Kandavel S			18/03/2016		ES_NSO_01107	
	Sejal N Khimani		21/03/2016		ES_NSO_01107
	Abinaya G			15/02/2019		DDI-229
	Nagarajan J			21/11/2019		EBS-3634
	Vasantha a			05/09/2022		KPE-561
	Sheerapthi KR		27/03/2023		EPE-60232				
	Sheerapthi KR		27/03/2023		EPE-60232	
	Sheerapthi KR		27/03/2023		EPE-60232
	Kathiravan P		15/12/2023		RTPLE-46
	Banurekha B         30/1/2024       RCEPL-495
	Kathiravan P		30/01/2024		RCEPL-488	
	Banurekha B         21/5/2024       EPE-81819
		Shrimalavika M		07/05/2024		RMC-SAL-17
	Shrimalavika M		08/08/2024		RMC-SAL-29
	/*Shrimalavika M				21/01/2025			CU Merging-PJRMC-1252 */
	/*Narmadhadevi M   25/01/2025	CU Merging-PJRMC-1252 */
	/*Aparna M			11-03-2025		PJRMC-1436*/
	/* Shrimalavika M	20-03-2025		PJRMC-1468 */
	/*Shrimalavika M	 05/03/2025	 Pjrmc-1253	*/
	/*Shrimalavika M	30-03-2025	PJRMC-1496 */
	/*Shrimalavika M	16/04/2025	RPRMCB-1	*/
******************************************************************************************/ 

create            procedure so_wf_m_process_sp
	@ctxt_ouinstance   	udd_ctxt_ouinstance,
	@ctxt_user   		udd_ctxt_user,	
	@ctxt_language  	udd_ctxt_language,
	@ctxt_service   	udd_ctxt_service,
	@ctxt_role			udd_ctxt_role,
	@calling_service	udd_ctxt_service,
	@guid				udd_guid,
	@transactionno		udd_documentno,
	@m_errorid			udd_int	output
as
begin
	set nocount on

	select	@m_errorid = 0

	if 	@ctxt_ouinstance = -915 
	  	select @ctxt_ouinstance = null

	select 	@ctxt_user = ltrim(rtrim(@ctxt_user))
	if 	@ctxt_user = '~#~' 
	  	select @ctxt_user = null

	if 	@ctxt_language = -915 
		select @ctxt_language = null

	select 	@ctxt_service = ltrim(rtrim(@ctxt_service))
	if 	@ctxt_service = '~#~' 
	  	select @ctxt_service = null

	select 	@calling_service = ltrim(rtrim(upper(@calling_service)))
	if 	@calling_service = '~#~' 
	  	select @calling_service = null	

	select 	@ctxt_role = ltrim(rtrim(@ctxt_role))
	if 	@ctxt_role = '~#~' 
	  	select @ctxt_role = null	
	
	select 	@guid = ltrim(rtrim(@guid))
	if 	@guid = '~#~' 
	  	select @guid = null

	select 	@transactionno = ltrim(rtrim(upper(@transactionno)))
	if 	@transactionno = '~#~' 
	  	select @transactionno = null

	--Temp variables 
	declare @doc_activitycd         udd_wfactivitycode,
		@doc_taskcd					udd_wftaskname,
		@doc_parameter				udd_wfdocparameter,
		@order_date					udd_date,
		@currency					udd_currencycode,
		@bu							udd_buid,
		@num_series					udd_notypeno,
		@status						udd_metadata_code,
		@ord_tot_value				udd_amount,
		@ord_basic_value			udd_amount,
		@billtocust					udd_customer_id,
		@customercode				udd_customer_id,
		@paytermcode				udd_paytermcode,
		@company					udd_companycode,
		@sales_channel				udd_identificationnumber1,
		@folder						udd_identificationnumber1,
		@sale_order_type			udd_sotype,
		@ouinstname					udd_ouinstname,
		@workflow_status			udd_wfstatename,
		@doc_auth_flag				udd_wfflag,
		@doc_key					udd_wfdockey,
		@crt_on_auth_flag			udd_metadata_code,
		@doc_newst_todo_user		udd_wfusername,
		@doc_newst_todo_user_ou		udd_ctxt_ouinstance,
		@wf_ou						udd_ctxt_ouinstance,
		@amd_on_auth_flag			udd_metadata_code,
	/*code Added for the DTS id:8H123-3_NSO_00017 starts here*/
		@addressid					udd_id,
		@carriercode				udd_carriercode,
		@freightamount				udd_amount,
		@freightcurrency			udd_currency,
		@grossweight				udd_weight,
		@netweight					udd_weight,
		@overridevolume				udd_quantity,
		@overrideweight				udd_weight,
		@saltype					udd_metadata_code,
		@tranmode					udd_transportationmode
	/*code Added for the DTS id:8H123-3_NSO_00017 ends here*/	

		/* Code added for rtrack id: EBS-3634 begins */
		,@createdby					udd_ctxt_user
		,@modifiedby				udd_ctxt_user
		/* Code added for rtrack id: EBS-3634 ends */

/* Code added for ITS Id. : ES_NSO_00698 Begins */
	declare	@sysdate		udd_date

	--code added for  DDI-229 begins
	declare	@custname		udd_custname,
			@cust_lo		udd_loid,
			@cust_bu		udd_buid ,
			@cust_ou		udd_ctxt_ouinstance,          
			@m_errorid_tmp  udd_int
	--code added for  DDI-229 ends

	/* Code added for EPE-60232 begins */
Declare @docauthflag_tmp	udd_metadata_code,
		@isauth_service		udd_int,
		@isvalidate_service	udd_int,
		@tmpguid			udd_guid,
		@trantype			udd_transactiontype,
		--@doc_area_code		udd_flag, --Code commented for SCA validation 'SA0002'
		@exec_flag			udd_metadata_code,      
		@tran_wf_status		udd_status,      
		@error_id_tmp		udd_int ,
		--@guid_tmp			udd_guid, --Code commented for SCA validation 'SA0002'
		@lo_id				udd_loid,
		@bu_id				udd_buid,
		@CustomerName		udd_CustName
		,@ContractNo		udd_documentno	--Code added for RTPLE-46


	if @calling_service in ('APP','REJ')
	begin
		select	@calling_service	=	newcallingservice
		from	erp_cmn_notification_metadata	with(nolock)
		where   component_id		=    'SAL_CON'
		and		callingservice		=    @calling_service
		and     language_id			=    @ctxt_language
	end

	select	@sysdate			= dbo.RES_Getdate(@ctxt_ouinstance)      
	select  @docauthflag_tmp	= 'N'      
	select	@isauth_service		= 1      
	select	@isvalidate_service = 1 

	/*code commented and added for the id RCEPL-495 starts here */
--	If @calling_service in ('so_CnCrMn_Ser_Sbt','so_cnedmn_ser_sbt','so_cnedmn_ser_del','so_cneden_ser_del','so_cnauen_ser_ret','so_cnaumn_ser_ret','so_cnaumn_ser_sav','so_cnaumn_ser_sbt','so_cnauen_ser_sbt','so_cnammn_ser_sbt','so_cncrag_ser_sbt','so_cncr








--sser_sbt')
	If @calling_service in ('so_CnCrMn_Ser_Sbt','so_cnedmn_ser_sbt','so_cnedmn_ser_del','so_cneden_ser_del','so_cnauen_ser_ret','so_cnaumn_ser_ret','so_cnaumn_ser_sav','so_cnaumn_ser_sbt','so_cnauen_ser_sbt','so_cnammn_ser_sbt','so_cncrag_ser_sbt'
	,'so_cncrbs_ser_sbt')
	/*code commented and added for the id RCEPL-495 ends here */
	Begin
		Select @trantype = 'SAL_CON'
	End

if   @trantype = 'SAL_CON' 
	BEGIN
		declare 
			@ADDID					udd_id,							
			@ContractDate			udd_date,						
			--@ContractNo			udd_documentno,	--Code commented for RTPLE-46			
			@ContractType			udd_optioncode,			
			@CustCode				udd_customer_id,																
			@NumberingSeries		udd_notypeno,						
			@NumSeries				udd_notypeno,															
			@OU						udd_ctxt_ouinstance,						
			@PayTmCode				udd_paytermcode,						
			@SalCh					udd_saleschannel,
			@USER					udd_ctxt_user,
			@amendno1               udd_number,
			@doc_unique_id			udd_paramchar,
			@netwt					[weight]/* Code added by shrimalavika M againist RMC-SAL-29 */ /*  Code added  against rTrack ID : CU Merging-PJRMC-1252*/   
			
		select	@bu			=	bu_id
		from	emod_lo_bu_ou_vw with (nolock)
		where   ou_id		=	@ctxt_ouinstance 

		select	@lo_id		=	lo_id
		from	emod_lo_bu_ou_vw with (nolock)
		where   ou_id		=	@ctxt_ouinstance

		Select
			@ADDID				=	conhdr_order_from_id,
			@amendno1   =	conhdr_amend_no,
			@ContractDate		=	conhdr_contract_date,
			@ContractNo			=	conhdr_contract_no,
			@ContractType		=	conhdr_contract_type,
			@CreatedBy			=	conhdr_created_by,
			@CURRENCY			=	bsohdr_currency_no,
			@CustCode			=	conhdr_order_from_cust,
			@CustomerName		=	dbo.cu_custname_fn(@lo_id, @bu_id, @ctxt_ouinstance, conhdr_order_from_cust),
			@FOLDER				=	conhdr_folder,
			@ModifiedBy			=	conhdr_modified_by,
			@netwt				=	null,/* Code added by shrimalavika M againist RMC-SAL-29 */ /* Code added  against rTrack ID : CU Merging-PJRMC-1252*/   
			@NumberingSeries	=	conhdr_num_series,
			@NumSeries			=	conhdr_num_series,
			@OU					=	conhdr_ou,
			@PayTmCode			=	bsohdr_pay_term_code,
			@SalCh				=	bsohdr_sales_channel,
			@STATUS				=	conhdr_status,
			@USER				=	conhdr_created_by,
			@tran_wf_status		=	conhdr_workflowstatus
			from so_contract_hdr with (nolock)
			left outer join so_blanket_order_hdr with (nolock)
			on   conhdr_ou			= bsohdr_ou
			and  conhdr_contract_no = bsohdr_contract_no
			left outer join so_agreement_dtl with (nolock)
			on   conhdr_ou			= agrdet_ou
			and  conhdr_contract_no = agrdet_contract_no
			where	conhdr_contract_no	=	@transactionno
			and		conhdr_ou			=	@ctxt_ouinstance
			

		select @doc_key = 'SAL_CON' + '$~$'+ convert(nvarchar(28),@ctxt_ouinstance)+ '$~$'+ @transactionno+'$~$'+ convert(nvarchar(4),@amendno1)

		select	@doc_unique_id	= @transactionno+'$~$'+ convert(nvarchar(4),@amendno1)   

			exec	scm_get_dest_ou		@ctxt_ouinstance,
								@ctxt_language,
								@ctxt_user,
								'NSO',
								'WFMTASKBAS',
								@wf_ou out,
								@m_errorid out

			if	@m_errorid <> 0
				return


 --WF Parameter         
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ADDID', isnull(ltrim(rtrim(@ADDID)),' ')) 
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'BU', isnull(ltrim(rtrim(@BU)),' ')) 
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ContractDate', isnull(ltrim(rtrim(@ContractDate)),' ')) 
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ContractNo', isnull(ltrim(rtrim(@transactionno)),' '))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ContractType', isnull(ltrim(rtrim(@ContractType)),' '))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'CreatedBy', isnull(ltrim(rtrim(@CreatedBy)),' '))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'CURRENCY', isnull(ltrim(rtrim(@CURRENCY)),' '))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'CustCode', isnull(ltrim(rtrim(@CustCode)),' '))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'Customername', isnull(ltrim(rtrim(@CustomerName)),' '))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'FOLDER', isnull(ltrim(rtrim(@FOLDER)),' '))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ModifiedBy', isnull(ltrim(rtrim(@ModifiedBy)),' '))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'NumberingSeries', isnull(ltrim(rtrim(@NumberingSeries)),' '))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'netwt', isnull(ltrim(rtrim(@netwt)),' '))/* Code added by shrimalavika M againist RMC-SAL-29 *//*Code added  against rTrack ID : CU Merging-PJRMC-1252*/    
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'NumSeries', isnull(ltrim(rtrim(@NumSeries)),' '))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'OU', isnull(ltrim(rtrim(@OU)),' '))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'PayTmCode', isnull(ltrim(rtrim(@PayTmCode)),' '))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'SalCh', isnull(ltrim(rtrim(@SalCh)),' '))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'STATUS', isnull(ltrim(rtrim(@STATUS)),' '))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'USER', isnull(ltrim(rtrim(@USER)),' '))

	--Create      
		if @calling_service in  ('so_CnCrMn_Ser_Sbt','so_cncrbs_ser_sbt')  /* Code added by shrimalavika M againist RMC-SAL-29 */  /* Begins - Code added  against rTrack ID : CU Merging-PJRMC-1252*/  
		begin                       
			select @doc_activitycd	= 'nsoaddcon'      
			select @doc_taskcd		= 'NsoAddConTrn4'      
			select @doc_auth_flag			=  	'Y'/* Code added by shrimalavika M againist RMC-SAL-29 */    /* Begins - Code added  against rTrack ID : CU Merging-PJRMC-1252*/
		end  		

	--Edit button Main      
		if @calling_service in  ('so_cnedmn_ser_sbt')      
		begin                       
			select @doc_activitycd	= 'nsomntcon'      
			select @doc_taskcd		= 'NsoMntConSbt1'      
		end   

		if @calling_service in  ('so_cnedmn_ser_del','so_cneden_ser_del')
		begin                       
			select @doc_activitycd	= 'nsomntcon'      
			select @doc_taskcd		= 'NsoMntConTrn4'      
		end 




	--Authorize page
		if @calling_service in  ('so_cnaumn_ser_ret','so_cnauen_ser_ret')      
		begin                       
			select @doc_activitycd	= 'NsoAuCon'      
			select @doc_taskcd		= 'NSoAuConTrn5'      
		end  

		if @calling_service in  ('so_cnaumn_ser_sav')      
		begin                       
			select @doc_activitycd	= 'NsoAuCon'      
			select @doc_taskcd		= 'NsoAuConTrn2'      
		end  

		if @calling_service in  ('so_cnaumn_ser_sbt','so_cnauen_ser_sbt')      
		begin                       
			select @doc_activitycd		= 'NsoAuCon'      
			select @doc_taskcd			= 'NsoAuConSbt1' 
			select	@docauthflag_tmp	=	'Y',
					@isauth_service		=	0
    
			if @amendno1 > 0
			begin
				select @doc_activitycd	= 'NsoAuCon'
			 	select	@doc_taskcd		= 'Amend_and_Authorize'
			end
		end

		else if @calling_service in ('so_cncrag_ser_sbt','so_cncrbs_ser_sbt')
		begin
				if	   @amendno1 = 0
				begin
					select @doc_activitycd	= 'nsomntcon'    
					select @doc_taskcd		= 'NsoMntConSbt1'
				end
				else 
				begin 
					select @doc_activitycd	= 'nsoamcon'      
					select @doc_taskcd		= 'NsoAmConSbt1'
				end
		End

	--Amend Main page
		if @calling_service in ( 'so_cnammn_ser_sbt')
		begin      
			select @doc_activitycd		= 'nsoamcon'      
			select @doc_taskcd			= 'NsoAmConSbt1'
			select	@docauthflag_tmp	= 'Y',
					@isauth_service		=  0
		end    
  
  if ( exists ( select 'X'    
      from wf_doc_status_vw(nolock)      
      where doc_key    = @doc_key      
      and  doc_status    in ('FRESH','RETURNED')     
      and  wf_instance_status = 'P'      
      and  user_name   = @ctxt_user      
      and  user_closed   in( 'P' ,'C')      
      and  isnull(@tran_wf_status ,'FRESH')  in ('FRESH')   
      or   @isauth_service = 1) 
     ) and @STATUS not in ('RET')  
	 
  begin    
  
   if exists ( select 'X'      
       from so_contract_hdr_wf_backup (nolock)      
       where conhdr_contract_no	=	@transactionno
	   and   conhdr_ou      	=	@ctxt_ouinstance
      )
  	
   begin	
   
   select @error_id_tmp = 0																	

   exec nso_wf_backup_sp
		@ctxt_ouinstance	,		
		@ctxt_user			,		
		@ctxt_language		,		
		@ctxt_service		,		
		@ctxt_role			,		
		@calling_service	,		
		@guid				,		
		@trantype			,		
		@transactionno		,		
		@ctxt_ouinstance	,		    
		'D'					,		
		@error_id_tmp	output	
		
		if @error_id_tmp <> 0       
		return      
   end      
        
   select @error_id_tmp = 0 

    exec nso_wf_backup_sp
		@ctxt_ouinstance	,		
		@ctxt_user			,		
		@ctxt_language		,		
		@ctxt_service		,		
		@ctxt_role			,		
		@calling_service	,		
		@guid				,		
		@trantype			,		
		@transactionno		,		
		@ctxt_ouinstance	,		    
		'I'					,		
		@error_id_tmp	output	

		if @error_id_tmp <> 0       
		return 
	end

	if   (( select count('X')      
      from wf_doc_status_vw(nolock)      
 where doc_key    = @doc_key      
 and  doc_status  not in  ('FRESH','RETURNED')   
      and  wf_instance_status = 'P' 
      and  user_closed   = 'C') >= 1 )      
      and  (@calling_service not in('so_cnaumn_ser_ret','so_cnauen_ser_ret')) 
    and   @isvalidate_service = 0      
  begin      
   
   select @isvalidate_service = 0      
   select @error_id_tmp = 0   

    exec nso_wf_backup_sp
		@ctxt_ouinstance	,		
		@ctxt_user			,		
		@ctxt_language		,		
		@ctxt_service		,		
		@ctxt_role			,		
		@calling_service	,		
		@guid				,		
		@trantype			,		
		@transactionno		,		
		@ctxt_ouinstance	,		    
		'V'					,		
		@error_id_tmp	output	

		if @error_id_tmp <> 0       
		return      
           
  end      

	if exists ( select 'X'      
      from wf_doc_status_vw(nolock)      
      where doc_key    = @doc_key      
      and  doc_status   in ('FRESH','RETURNED')      
      and  wf_instance_status = 'P'      
      and  user_closed   in('C','P')      
     ) and  @isvalidate_service = 1      
      and  @isauth_service  = 0      
            
  begin         
   select @error_id_tmp = 0  

   exec nso_wf_backup_sp
		@ctxt_ouinstance	,		
		@ctxt_user			,		
		@ctxt_language		,		
		@ctxt_service		,		
		@ctxt_role			,		
		@calling_service	,		
		@guid				,		
		@trantype			,		
		@transactionno			,		
		@ctxt_ouinstance	,		    
		'VS'					,		
		@error_id_tmp	output	,
		@exec_flag output   

		if @exec_flag = 'F'      
		begin		

		IF @STATUS	in ('AM','FRESH')
		BEGIN
			select @doc_activitycd	=	'nsoamcon'
			select @doc_taskcd		=	'NsoAuConSbt1'
			
			IF @amendno1 > 0 
			begin			
				select	@doc_taskcd	= 'Amend_and_Authorize'
			end
		END
		end
  end 
      
	if @STATUS  IN ('FR','AM')      
	begin      
		update wf_by_mailreply_dtl      
		set  record_status  = 'C'      
		where doc_key    = @doc_key      
		AND  record_status  = 'F'      
	end      
	    
	select @tmpguid	=	newid()
         
  insert into wf_by_mailreply_hdr      
  ( wf_token,      
   wf_docou,      
   doc_key,      
   doc_unique_id,      
   created_date,      
   created_by      
  )      
  select 
	@tmpguid,       
    @ctxt_ouinstance,      
    @doc_key,    
	--@transactionno	--Code commented for EPE-60232
    @doc_unique_id,     --Code added for EPE-60232 
    @sysdate,      
    @ctxt_user      
 end       	
Else 
begin
	/* Code added for EPE-60232 ends */
	select	@sysdate	= dbo.res_getdate(@ctxt_ouinstance)
/* Code added for ITS Id. : ES_NSO_00698 Ends */
	select	@doc_auth_flag			=	'N',
			@crt_on_auth_flag		=	'N',
			@amd_on_auth_flag		=	'N',--Added for DTS ID: ES_NSO_00206
			@doc_newst_todo_user	=	null,
			@doc_newst_todo_user_ou	=	null	

	select	@crt_on_auth_flag	=	parameter_value
	from	so_sys_param_ou_vw (nolock)
	where	ouid				=	@ctxt_ouinstance	
	and		component_name		=	'NSO'
	and		parameter_code		=	'SO_CRT_AND_AUTH'	
	
	--Added for DTS ID: ES_NSO_00206 starts here
	select	@amd_on_auth_flag	=	parameter_value
	from	so_sys_param_ou_vw (nolock)
	where	ouid				=	@ctxt_ouinstance	
	and		component_name		=	'NSO'
	and		parameter_code		=	'SO_AMD_AND_AUTH'	
	--Added for DTS ID: ES_NSO_00206 ends here

	select	@transactionno	=	sohdr_order_no
	from	sotmp_order_hdr (nolock)
	where	sohdr_guid		=	@guid	

	--Added for DTS ID: ES_NSO_00206 starts here
	if (@transactionno is null)
	begin 
		select	@transactionno	=	sohdr_order_no
		from	sotmp_order_hdr (nolock)
		where	sohdr_guid	=	@guid
	end

	
	
	declare	@doc_vat_amt		udd_amount--ES_NSO_01107

	select	@order_date		=	sohdr_order_date,
			@currency		=	sohdr_currency,
			@bu				=	sohdr_bu,
			@num_series		=	sohdr_num_series,
			@status			=	sohdr_order_status,
			@ord_tot_value	=	sohdr_total_value,
			@ord_basic_value=	sohdr_basic_value,
			@billtocust		=	sohdr_bill_to_cust,
			@customercode	=	sohdr_order_from_cust,
			@paytermcode	=	sohdr_pay_term_code,
			@company		=	sohdr_company_code,
			@sales_channel	=	sohdr_sales_channel,
			@folder			=	sohdr_folder,
			@sale_order_type=	sohdr_order_type,
			@workflow_status=	sohdr_workflow_status,
			@addressid		=	sohdr_order_from_id,
			@carriercode	=	sohdr_prefered_carrier,
			@freightamount	=	sohdr_freight_amount,
			@freightcurrency =	sohdr_freight_currency,
			@grossweight	 =	sohdr_gross_weight,
			@netweight		 =	sohdr_net_weight,
			@overridevolume	 =	sohdr_overriding_volume,
			@overrideweight	 =	sohdr_overriding_weight,
			@saltype		 =  sohdr_sale_type_dflt,
			@tranmode		 =	sohdr_trnsprt_mode_dflt,
			@doc_vat_amt 	 =  sohdr_total_vat--ES_NSO_01107

			/* Code added for rtrack id: EBS-3634 begins */
			,@createdby		 =  sohdr_created_by
			,@modifiedby	 =	sohdr_modified_by
			/* Code added for rtrack id: EBS-3634 ends */
			,@CONTRACTNO	 =	sohdr_ref_doc_no --Code added for RTPLE-46
	from	so_order_hdr (nolock)
	where	sohdr_ou		=	@ctxt_ouinstance
	and		sohdr_order_no	=	@transactionno

	--code added for  DDI-229 begins
	select	@m_errorid_tmp = 0 

	exec scm_get_dest_ou	@ctxt_ouinstance,        
							@ctxt_language,        
							@ctxt_user,        
							'NSO',        
							'CU',        
							@cust_ou out,        
							@m_errorid_tmp out         
         
	if @m_errorid_tmp <> 0  
	begin        
		select @m_errorid = @m_errorid_tmp        
		return        
	end        
        
	-- begin : get lo and bu for customer ou                  
	exec  scm_get_emod_details  @cust_ou,         
								@sysdate,
								@cust_lo out,        
								@cust_bu out,         
								@m_errorid_tmp out        
         
	if @m_errorid_tmp <> 0        
	begin        
		select @m_errorid = @m_errorid_tmp        
		return        
	end        

	select @custname  = clo_cust_name        
	from cust_lo_info_vw (nolock)        
	where clo_lo   = @cust_lo        
	and clo_cust_code  = @customercode 
	--code added for DDI-229 ends

	/* Code added for ITS ID : ES_NSO_01107 Begins */
	declare/*	@total_doctax		udd_amount,
			@total_doccharg		udd_amount,
			@total_docdis		udd_amount,
			@total_ittax		udd_amount,
			@total_itcharg		udd_amount,
			@total_itdis		udd_amount*/
			@so_totaltax_tmp		udd_amount,
			@so_totalcharge_tmp		udd_amount,
			@so_totaldisc_tmp		udd_amount,
			@doc_basic_amt		udd_amount,
			@doc_frt_amt		udd_amount,
			@flag     desc20

   /*code added for notification starts */

 	if  @calling_service in (select  callingservice
					from    erp_cmn_notification_metadata
					where   component_id		=    'NSO'
					and     language_id			=    @ctxt_language)
		begin
		select @flag='MOBNOTIFY'

		select @calling_service = newcallingservice 
		from erp_cmn_notification_metadata
		where component_id='NSO'
		and callingservice=@calling_service
	end
  /*code added for notification ends*/

	if @calling_service in ('so_crdtc_ser_sbt','so_critc_ser_sbt')
	begin
	/*	select	@total_doctax		=	sum(isnull(doctcd_total_value,0))
		from	so_doc_tcd_dtl(nolock)
		where	doctcd_order_no		=	@transactionno
		and		doctcd_ou			=	@ctxt_ouinstance
		and		doctcd_tcdtype		=	'T'
		
		select	@total_doccharg		=	sum(isnull(doctcd_total_value,0))
		from	so_doc_tcd_dtl(nolock)
		where	doctcd_order_no		=	@transactionno
		and		doctcd_ou			=	@ctxt_ouinstance
		and		doctcd_tcdtype		=	'C'		
		
		select	@total_docdis		=	sum(isnull(doctcd_total_value,0))
		from	so_doc_tcd_dtl(nolock)
		where	doctcd_order_no		=	@transactionno
		and		doctcd_ou			=	@ctxt_ouinstance
		and		doctcd_tcdtype		=	'D'
		
		select	@total_ittax		=	sum(isnull(itmtcd_total_value,0))
		from	so_item_tcd_dtl(nolock)
		where	itmtcd_order_no		=	@transactionno
		and		itmtcd_ou			=	@ctxt_ouinstance
		and		itmtcd_tcdtype		=	'T'
		
		select	@total_itcharg		=	sum(isnull(itmtcd_total_value,0))
		from	so_item_tcd_dtl(nolock)
		where	itmtcd_order_no		=	@transactionno
		and		itmtcd_ou			=	@ctxt_ouinstance
		and		itmtcd_tcdtype		=	'C'		
		
		select	@total_itdis		=	sum(isnull(itmtcd_total_value,0))
		from	so_item_tcd_dtl(nolock)
		where	itmtcd_order_no		=	@transactionno
		and		itmtcd_ou			=	@ctxt_ouinstance
		and		itmtcd_tcdtype		=	'D'		

		
		select	@ord_tot_value		=	isnull(@freightamount,0) + isnull(@ord_basic_value,0) + isnull(@total_doctax,0) + ISNULL(@total_doccharg,0) - ISNULL(@total_docdis,0) + ISNULL(@total_ittax,0) + ISNULL(@total_itcharg,0) - ISNULL(@total_itdis,0)+ isnull(@doc_vat





















_




amt,0)
		*/
		select  @so_totaltax_tmp = sum(tcdamount)
		from   	tcd_calprocess_result_vw (nolock)
		where	guid 		= @guid
		and	tcdtype		= 'T'
			
		select  @so_totalcharge_tmp = sum(tcdamount)
		from   	tcd_calprocess_result_vw(nolock)
		where	guid 		= @guid
		and	tcdtype		= 'C'
			
		select  @so_totaldisc_tmp = sum(tcdamount)
		from   	tcd_calprocess_result_vw(nolock)
		where	guid 		= @guid
		and	tcdtype		= 'D'
			
		select	@doc_basic_amt 	= sohdr_basic_value,
			@doc_vat_amt 	= sohdr_total_vat,
			@doc_frt_amt 	= sohdr_freight_amount
	/* Code modified by Raju against NSODms412at_000412 ends*/
		from	so_order_hdr(nolock)
		where	sohdr_ou = @ctxt_ouinstance
	/* Code modified by Raju against NSODms412at_000412 starts*/
	-- 	and	sohdr_order_no = rtrim(upper(@transactionno))
		and	sohdr_order_no = @transactionno
			
	-- 	select	@ord_tot_val = @doc_basic_amt + isnull(@so_totaltax_tmp,0) + isnull(@so_totalcharge_tmp,0) - isnull(@so_totaldisc_tmp,0) + isnull(@doc_vat_amt,0)
		select	@ord_tot_value = @doc_basic_amt + isnull(@doc_frt_amt,0)+ isnull(@so_totaltax_tmp,0) + isnull(@so_totalcharge_tmp,0) - isnull(@so_totaldisc_tmp,0) + isnull(@doc_vat_amt,0)
	/* Code modified by Raju against NSODms412at_000412 ends*/
		
		if @ctxt_user = 'DEBUGUSER$'
		BEGIN
			select 'inside so_wf_m_process_sp'
		--	select @ord_tot_value '@ord_tot_value',isnull(@ord_basic_value,0) , isnull(@total_doctax,0) , ISNULL(@total_doccharg,0) , ISNULL(@total_docdis,0) , ISNULL(@total_ittax,0) ,ISNULL(@total_itcharg,0) , ISNULL(@total_itdis,0)
			select * 	from	so_item_tcd_dtl(nolock) where	itmtcd_order_no		=	@transactionno	and		itmtcd_ou			=	@ctxt_ouinstance
			select *	from	so_doc_tcd_dtl(nolock)where	doctcd_order_no		=	@transactionno	and		doctcd_ou			=	@ctxt_ouinstance			
		end
	end
	/* Code added for ITS ID : ES_NSO_01107 Ends */
		
	select 	@ouinstname = 	ouinstname   
	from  	fw_admin_view_ouinstance  (nolock)
	where  	ouinstid 	=	 @ctxt_ouinstance

	/* Code added for ITS ID : 14H109_WFMCONFIG_00005 Begins */
	declare	@amendno		udd_int				
	
	select	@amendno		=	sohdr_amend_no
	from	so_order_hdr (nolock)
	where	sohdr_ou		=	@ctxt_ouinstance
	and		sohdr_order_no	=	@transactionno	
	
	if @calling_service='sopp_crmn_ser_auth1'	and	@amendno	> 0
	begin
		select	@calling_service = 'sopp_AmMn_ser_Auth1'
	end
	/* Code added for ITS ID : 14H109_WFMCONFIG_00005 Ends */
		
	--code change for 11H103_sla_00001 starts
	if @calling_service='PVL_SLA_Sr_Gen'
	begin
			select @crt_on_auth_flag='Y'
			SELECT @calling_service='sopp_CrMn_ser_CrAu1'
	end
	--code change for 11H103_sla_00001 starts
	/* Code Added by Lavanya against the defect id ES_SOD_00018(11H103_SOD_00001) begins */
	if @calling_service='Sod_mnord_Ser_crso'
	begin
			declare	@so_status	udd_status

			SELECT	@so_status	=	sfp_SoStatus 
			FROM	SOD_SFP_HDR	(nolock)	
			WHERE	sfp_ouinstance	= @ctxt_ouinstance	
		
			if	(@so_status	=	'AU')
			begin
				select @crt_on_auth_flag='Y'
				SELECT @calling_service='sopp_CrMn_ser_CrAu1'
			end	
			else	
			begin
				select @crt_on_auth_flag='N'
				SELECT @calling_service='sopp_CrMn_ser_sbt1'
			end
	end
	/* Code Added by Lavanya against the defect id ES_SOD_00018(11H103_SOD_00001) ends */

	if @calling_service in ('sopp_CrMn_ser_sbt1',	'sopp_CrMn_ser_Edt1',	'sopp_CrMn_ser_CrAu1',
							'NSOmn69_serSave1',		'so_HdMn_Ser_RSbt',		'so_HdEn_Ser_RSbt',
							'NSOSER042',			'so_CrRef_Ser_Sbt',		'SO_RLCRMN_SER_GENREL', 
							'SO_RLEDMN_SER_GENREL',	'so_crdtc_ser_sbt',		'so_critc_ser_sbt' --code added for DTSid:ES_NSO_01107
							)--	code commented for 11h103_sla_00001, 'PVL_SLA_Sr_Gen') -- code changed for 11h103_sla_00001

	begin
			select 	@doc_taskcd 	= 'PPSCMQSOCRTQOTTRN1',  
					@doc_activitycd	= 'PPSCMQSOCRTQO1'	

			if (@crt_on_auth_flag ='Y' and @calling_service in('sopp_CrMn_ser_sbt1','so_CrRef_Ser_Sbt'))
				or @calling_service ='sopp_CrMn_ser_CrAu1'
			begin
				select	@doc_auth_flag			=  	'Y',
						@doc_newst_todo_user	=	@ctxt_user,
						@doc_newst_todo_user_ou	=	@ctxt_ouinstance							
			end	

			if @calling_service in('so_HdMn_Ser_RSbt','so_HdEn_Ser_RSbt') and @status = 'AM'

			begin
				select 	@doc_taskcd 	= 'PPSCMQSOAMDQOTTRN1',  
						@doc_activitycd	= 'PPSCMQSOAMDQO1'	
			end
	end

	if @calling_service ='sopp_CrMn_ser_Auth1'
	begin
		select 	@doc_taskcd 			=	'PPSCMQSOCrtQoTtrn7',  
				@doc_activitycd			=	'PPSCMQSOCRTQO1',	
				@doc_newst_todo_user	=	@ctxt_user,
				@doc_newst_todo_user_ou	=	@ctxt_ouinstance
	end

	if @calling_service in ('sopp_AmMn_ser_Sbt1','sopp_AmMn_ser_AuAm1')
	begin
		select 	@doc_taskcd 	= 'PPSCMQSOAMDQOTTRN1',  
				@doc_activitycd	= 'PPSCMQSOAMDQO1'	

		if (@amd_on_auth_flag ='Y' and @calling_service = 'sopp_AmMn_ser_Sbt1')  
			or @calling_service ='sopp_AmMn_ser_AuAm1'
		begin
			select	@doc_auth_flag			=  	'Y',
					@doc_newst_todo_user	=	@ctxt_user,
					@doc_newst_todo_user_ou	=	@ctxt_ouinstance							
		end
	end
	
	/* code added for DTSid:ES_NSO_01107 starts here */
	if @calling_service in ('so_crdtc_ser_sbt','so_critc_ser_sbt') and @amendno	> 0
	begin
			select 	@doc_taskcd 	= 'PPSCMQSOAMDQOTTRN1',  
					@doc_activitycd	= 'PPSCMQSOAMDQO1'	

			if (@amd_on_auth_flag ='Y' and @calling_service = 'so_crdtc_ser_sbt')  
				or @calling_service ='so_critc_ser_sbt'
			begin
				select	@doc_auth_flag			=  	'Y',
						@doc_newst_todo_user	=	@ctxt_user,
						@doc_newst_todo_user_ou	=	@ctxt_ouinstance							
			end
	end
	/* code added for DTSid:ES_NSO_01107 starts here */

	if @calling_service ='sopp_AmMn_ser_Auth1'
	begin
		select 	@doc_taskcd 			=	'PPSCMQSOAMDQOTTRN2',  
				@doc_activitycd			=	'PPSCMQSOAMDQO1',	
				@doc_newst_todo_user	=	@ctxt_user,
				@doc_newst_todo_user_ou	=	@ctxt_ouinstance
	end			

	if @calling_service = 'sopp_AmMn_ser_AuAm1'
	begin
		select 	@doc_taskcd 	= 'PPSCMQSOAMDQOTTRN3',  
				@doc_activitycd	= 'PPSCMQSOAMDQO1'	
	end
	else if @calling_service in ('sopp_CrMn_ser_sbt1','NSOmn69_serSave1','NSOSER042')
	begin
		select 	@doc_taskcd 	= 'PPSCMQSOCRTQOTTRN1',  
				@doc_activitycd	= 'PPSCMQSOCRTQO1'	
	end
	else if @calling_service = 'sopp_CrMn_ser_Edt1'
	begin
		select 	@doc_taskcd 	= 'PPSCMQSOCRTQOTTRN6',  
				@doc_activitycd	= 'PPSCMQSOCRTQO1'	
	end
	else if @calling_service = 'sopp_CrMn_ser_CrAu1'
	begin
		select 	@doc_taskcd 	= 'PPSCMQSOCRTQOTTRN5',  
				@doc_activitycd	= 'PPSCMQSOCRTQO1'	
	end
	else if @calling_service = 'so_CrRef_Ser_Sbt'
	begin
		select 	@doc_taskcd 	= 'NSOADDREFSBT1',  
				@doc_activitycd	= 'NSOADDREF'	
	end			
	else if @calling_service = 'SO_SCMN_SER_SBT'
	begin 
		select 	@doc_taskcd 	= 'NSOSCLSOSBT1',  
				@doc_activitycd	= 'NSOSCLSO'
	end
	else if @calling_service = 'so_ScEn_Ser_Sbt'
	begin
		select 	@doc_taskcd 	= 'NsoSclSoTrn3',  
				@doc_activitycd	= 'NSOSCLSO'	
	end			

	if @calling_service = 'NSO_Mnt_SerRet'
	begin
		select 	@doc_taskcd 	= 'NSOMAINEEPPSCMQTR',
				@doc_activitycd	= 'PPSCMQSOCRTQO1'
	end

	--Added for DTS ID: 9H123-1_NSO_00030 starts here
	if @calling_service = 'NSO_amd_Ser_ret'
	begin 
		select 	@doc_taskcd 	= 'NSOMAINSERETURNTR',  
				@doc_activitycd	= 'PPSCMQSOAMDQO1'	
	end 
	--Added for DTS ID: 9H123-1_NSO_00030 ends here

	--if activity/task id is defined as init task , then current state sending with blank
	if exists(	select 	'X'
			from 	wf_inp_area_dtl_vw(nolock) 
			where 	area_code 		=	'NSOSO'
			and		component_name	= 	'NSO'
			and		activity_name	=	@doc_activitycd		
			and		task_name		=	@doc_taskcd	
			and		initiated_task	=	'INIT' )
		select	@workflow_status = ''

	/*SELECT Doc_Parameter as above with the Parameter details as follows. The wfm_para_concat_fn takes in the Parameter Code followed by the Value and forms a String as follows 
	'CURRENCY$~$USD#~#EMPLOYEE$~$S0001#~#'*/

	/*code Modified for the DTS id:8H123-3_NSO_00017 starts here*/
	select @doc_parameter = dbo.wfm_para_concat_fn('','ADDID', @addressid)    
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'BU',@bu)    
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'CARRCODE',@carriercode)    
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'COMPANY',@company)    
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'CURRENCY', @currency)  
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'CUSTCODE',@customercode) 
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'CUSTOMERNAME',@custname) --code added for DDI-229
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'FOLDER',isnull(@folder,''))  
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'FREAMT',convert(nvarchar(28),@freightamount))  
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'FRECURR',@freightcurrency)  
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'GRWT',convert(nvarchar(28),@grossweight))  
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'NETWT',convert(nvarchar(28),@netweight))  
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'NUMSERIES',@num_series)  
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ORDERBAVAL',convert(nvarchar(28),@ord_basic_value))    
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ORDERDT',convert(nvarchar(10),@order_date, 120))  
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ORDERNO',@transactionno)      
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ORDERTOVAL',convert(nvarchar(28),@ord_tot_value))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ORDTY',@sale_order_type)   
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'OU',@ctxt_ouinstance)      
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'OVERRIDVOL',convert(nvarchar(28),@overridevolume)) 
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'OVERRIDWT',convert(nvarchar(28),@overrideweight))
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'PAYTMCODE',@paytermcode)    
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'SALCH',isnull(@sales_channel,''))    
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'SalTy',@saltype)
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'STATUS',@status) 
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'TRANCODE',@tranmode)       	  
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'USER', @ctxt_user)

	/* Code added for rtrack id: EBS-3634 begins */
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'createdby', @createdby)
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'modifiedby', @modifiedby)
	/* Code added for rtrack id: EBS-3634 ends */

	--Code added for RTPLE-46 begins
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'CONTRACTDATE',@order_date)
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'CONTRACTNO',@CONTRACTNO) 
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'CONTRACTTYPE',@sale_order_type)       	  
	select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'NUMBERINGSERIES',@num_series)
	--Code added for RTPLE-46 ends

	/*code Modified for the DTS id:8H123-3_NSO_00017 ends here*/    
	
	select	@doc_key = 'NSO' + '$~$'+ convert(nvarchar(4),@ctxt_ouinstance)+ '$~$'+ @transactionno --Modified for DTS id:8H123-3_NSO_00019
						+'$~$'+convert(nvarchar(28),@amendno) --code added for KPE-561

	exec	scm_get_dest_ou		@ctxt_ouinstance,
								@ctxt_language,
								@ctxt_user,
								'NSO',
								'WFMTASKBAS',
								@wf_ou out,
								@m_errorid out

	if	@m_errorid <> 0
		return

	
	/* code added for 14H109_NSO_00014 begins*/
	
	if	@status		IN	('FR','AM')
	begin
		update	wf_by_mailreply_dtl
		set		record_status		=	'C'
		where	doc_key				=	@doc_key
		AND		record_status		=	'F'
	end

	/* Code added by Sejal for ITS ID : ES_NSO_01107 Begins */
	if @calling_service		in (	'so_crdtc_ser_sbt',		'so_critc_ser_sbt')
	begin	
		select	@guid			=	newid()
	end
	/* Code added by Sejal for ITS ID : ES_NSO_01107 Ends */
	--if @flag not in ('MOBNOTIFY') --Code commented for RCEPL-488
	if	isnull(@flag,' ')	not in	('MOBNOTIFY')	--Code added for RCEPL-488
	begin

	delete from wf_by_mailreply_hdr where wf_token=@guid--EPE-81819

	insert into wf_by_mailreply_hdr
	(
	wf_token,wf_docou,doc_key,doc_unique_id,created_date,created_by
	)
	select
	@guid,@ctxt_ouinstance,@doc_key,@transactionno,@sysdate,@ctxt_user
	end
	
End ---Code added for EPE-60232

--EPE-81819 starts
delete from so_wf_doc_dtl_tmp where guid =@guid 

if @ctxt_service in( 'So_api_ser_cr','So_api_ser_au')
begin
insert into so_wf_doc_dtl_tmp
(doc_action_combo_val,doc_activitycd,doc_area_code,doc_auth_flag,
doc_char_dummy_1,doc_char_dummy_2,doc_componentcd,doc_current_state,
doc_date,doc_float_dummy_1,doc_float_dummy_2,doc_guid,
doc_key,doc_newst_todo_user,doc_newst_todo_user_ou,doc_orguintid,
doc_parameter,doc_taskcd,doc_unique_id,
log_orguintid,log_role,log_user,wf_context_ou,guid)
values
('~#~',@doc_activitycd,case when @trantype = 'SAL_CON' then 'NSOCO' Else 'NSOSO'end,case when @trantype = 'SAL_CON' then @docauthflag_tmp else rtrim(@doc_auth_flag)end	,
'~#~','~#~','NSO',case when @trantype = 'SAL_CON' then @tran_wf_status else rtrim(@workflow_status)	end,
convert(nvarchar(10),@sysdate,120),-915 ,-915 ,case when @trantype = 'SAL_CON' then @tmpguid else @guid end,
rtrim(@doc_key)	,rtrim(upper(@doc_newst_todo_user)),@doc_newst_todo_user_ou,@ctxt_ouinstance,
rtrim(@doc_parameter),rtrim(@doc_taskcd),case when @trantype = 'SAL_CON' then @doc_unique_id else rtrim(@transactionno) end,
@ctxt_ouinstance,rtrim(@ctxt_role),rtrim(upper(@ctxt_user)),@wf_ou,@guid)

return
end
--EPE-81819 ends
/* Begins - Code added  against rTrack ID : CU Merging-PJRMC-1252*/
/*code added by krishnan start against RMC-SAL-17 */
/* Code added by shrimalavika M againist RMC-SAL-29 Begins */   


/*code added by Aparna M against PJRMC-1436 Starts*/

declare @lineno int

select @lineno=max(doc_line_no)
from  scmdb..ZRIT_QUOTATION_PAM_DETAIL a(nolock)
where DocNo = @transactionno
and 	  Parameter	=	'PAM'


declare @counter int
set @counter =1

while (@counter<=@lineno)
begin
insert  into zrit_contract_workflow_temp
	(
	guid ,
	OUID  ,
	DocNo   ,
	Amount ,
	doc_AMD_No  ,
	Create_By
	)
	select 
	@guid,
	OUID,
	DocNo,
	Amount,
	doc_AMD_No
	,Create_By
from scmdb..ZRIT_QUOTATION_PAM_DETAIL a(nolock)
where Doc_Line_no =@counter
and DocNo = @transactionno
and doc_AMD_No in (select max(doc_AMD_No)
					from scmdb..ZRIT_QUOTATION_PAM_DETAIL b (nolock)
					where a.DocNo = b.DocNo
					and Doc_Line_no =@counter
					and DocNo = @transactionno
				)
and OUID			=	@ctxt_ouinstance
and 	  Parameter	=	'PAM'
 --select * from zrit_contract_workflow_temp
  select @counter =@counter+1
 end
 /*code commented and added by Aparna M against PJRMC-1436 ends*/
if @calling_service	in	('so_cncrbs_ser_sbt','so_cnaumn_ser_sbt')
Begin

	declare   @con_pathid varchar(50) ,	@con_ruleid varchar(40)

	declare 
		@con_date							date				,
		@con_value							udd_amount			,
		@con_creator						varchar(40)			,
		@con_component						udd_process_name	,
		@con_activity						UDD_ACTIVITY_NAME	,
		@con_amd							int					,
		@max_amd							int					,
		@shipou									varchar(30)			
		
		select @shipou	=	bsodet_ship_point	
		From scmdb..so_blanket_item_dtl dtl with(nolock)
		where bsodet_contract_no	=	@transactionno
		and bsodet_ou				=	@ctxt_ouinstance

		if  @Doc_ActivityCD	=	'nsoamcon'
		Begin	
		
				Select @con_component	=	'NSO'		,
						@con_activity	=	'nsoamcon'	
/*
select	@max_amd	=	max(doc_AMD_No)
from  scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
					where  Parameter	=	'PAM'
					and DocNo = isnull(@transactionno,DocNo)
					and OUID	=	@ctxt_ouinstance
*/
/*code commented and added by Aparna M against PJRMC-1436 Starts*/
/*
				select	@con_value		=   min(Amount)			,
				--@con_date				=	Create_date			,
				@con_creator			=	Create_By				
				--@con_amd				=	max(doc_AMD_No)
				from scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
				where  Parameter	=	'PAM'
				and DocNo			=	isnull(@transactionno,DocNo)
				and OUID			=	@ctxt_ouinstance
				--and	doc_AMD_No		=	@max_amd
				group by DocNo,Create_By--,Amount--,Create_date
*/
			
select			@con_value= min(Amount)  ,
				@con_creator			=	Create_By	
				from	zrit_contract_workflow_temp a with(nolock)
				--where  Parameter	=	'PAM'
				where DocNo			=	isnull(@transactionno,DocNo)
					--and OUID			=	@ctxt_ouinstance
					and guid =@guid
					group by DocNo,Create_By--,Amount--,Create_date

delete from zrit_contract_workflow_temp where guid=@guid
/*code commented and added by Aparna M against PJRMC-1436 ends*/
				select @con_pathid	=	wfi_path	,
						@con_ruleid	=	wfi_rule
				from zrit_workflow_iedk_view with(nolock)
				where  wfi_ouid = @shipou--@ctxt_ouinstance /* Code commented and added against PJRMC-1161 */ 
				and wfi_status = 'AC'            
				and wfi_component = @con_component             
				and wfi_activity = @con_activity  
				and wfi_path like 'zrit_rconamt_path%'
				and @con_value between wfi_val_from and wfi_val_to
		End
		Else  
		Begin
	
				Select  @con_component  =	'NSO'						,
						@con_activity 	=	'NSOADDCON'




/*code commented and added by Aparna M against PJRMC-1436 Starts*/

				
select			@con_value= min(Amount)  ,
				@con_creator			=	Create_By	
				from	zrit_contract_workflow_temp a with(nolock)
				--where  Parameter	=	'PAM'
				where DocNo			=	isnull(@transactionno,DocNo)
					--and OUID			=	@ctxt_ouinstance
					and guid =@guid
					group by DocNo,Create_By--,Amount--,Create_date


delete from zrit_contract_workflow_temp where guid=@guid

					/*
				select	@con_value		=   min(Amount),
				--@con_date				=	Create_date			,
				@con_creator			=	Create_By
				from scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
				where  Parameter	=	'PAM'
				and DocNo			=	isnull(@transactionno,DocNo)
				and OUID			=	@ctxt_ouinstance
				group by DocNo,Create_By--,Create_date
				*/
/*code commented and added by Aparna M against PJRMC-1436 ends*/
				select @con_pathid	=	wfi_path	,
						@con_ruleid	=	wfi_rule
				from zrit_workflow_iedk_view with(nolock)
				where  wfi_ouid = @shipou--@ctxt_ouinstance /* Code commented and added against PJRMC-1161 */    
				and wfi_status = 'AC'            
				and wfi_component = @con_component             
				and wfi_activity = @con_activity  
				and wfi_path like 'zrit_rcont_path%'
				and @con_value between wfi_val_from and wfi_val_to
				End
			
	End
/* Code added by shrimalavika M againist RMC-SAL-29 Ends*/    
Else
Begin
	declare @Pathid varchar(50) ,@ruleid varchar(40)

	declare @so_pam				numeric(28,3)				,
		@con_pam				numeric(28,3)				,
		@contractno1			varchar(30)					,
		@DIFF					/*int*/numeric(28,3)		,/*Code Modified against RPRMCB-1*/
		@value					int							,
		@doc_date				date        
,@doc_value udd_amount 
,@creator varchar(40)
,@component udd_process_name	=	'NSO'
,@activity UDD_ACTIVITY_NAME	=	'PPSCMQSOCRTQO1'
,@credituser			varchar(50)
declare @component_aso  varchar(40),
		@activity_aso	varchar(50)
		,@so_total_price				numeric(28,3) /* Code added against Pjrmc-1253 */
		,@cust_type1			varchar(70) /*Code added against PJRMC-1496 */
select	@component_aso	=	'NSO',
		@activity_aso	=	'PPSCMQSOAMDQO1'
 /*Code Modified against CU Merging-PJRMC-1252 starts*/
if @bu /*= 'CON'*/in (SELECT VALUE BU FROM  ZRIT_PJL_SUBCOMP_MAP (NOLOCK)  CROSS APPLY STRING_SPLIT(BU, ',')  WHERE SEQNO=5 ) 
/*Code Modified against CU Merging-PJRMC-1252 Ends*/  
Begin

	select  @contractno1	= sohdr_ref_doc_no	
	from  scmdb..so_order_hdr with(nolock)
	where sohdr_order_no	=	@transactionno
	and sohdr_ou			=	@ctxt_ouinstance
	and sohdr_ref_doc_type	=	'CON'

	/*select
			@con_pam	=	min(amount)
			from  scmdb..so_order_hdr with(nolock)
			join scmdb..so_contract_hdr vw with(nolock)
			on sohdr_ref_doc_no		=	conhdr_contract_no
			and		sohdr_ou		=	conhdr_ou
			and conhdr_amend_no		=	(select max(vw1.conhdr_amend_no)
			from scmdb..so_contract_hdr vw1 with(nolock)
where vw.conhdr_contract_no = vw1.conhdr_contract_no
                                and vw.conhdr_ou = vw1.conhdr_ou)			
			join scmdb..so_blanket_item_dtl dtl with(nolock)
			on /*dtl.bsodet_ou*/dtl.bsodet_ship_point			=	vw.conhdr_ou
			and	bsodet_contract_no		=	vw.conhdr_contract_no
			join scmdb..so_order_item_dtl with(nolock)
			on sodtl_ou					=	sohdr_ou
			and sodtl_order_no			=	sohdr_order_no
			and sodtl_item_code			=	bsodet_item_code	
			and	sohdr_order_no			=	@transactionno
			and sohdr_ou				=	@ctxt_ouinstance			
			join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
			on docNo					=	sohdr_ref_doc_no
			and OUID					=	conhdr_ou
			where  doc_AMD_No			=	(select max(vw1.conhdr_amend_no)
											from scmdb..so_contract_hdr vw1 with(nolock)
											where vw.conhdr_contract_no = vw1.conhdr_contract_no
											and vw.conhdr_ou = vw1.conhdr_ou)
			and ItemCode				=	sodtl_item_code
			and sohdr_ref_doc_no		=	@contractno1		
			and conhdr_ou				=	@ctxt_ouinstance
			and parameter				=	'PAM'
*/
			select
			@con_pam	=	min(amount)
			fROM scmdb..so_order_hdr so with(nolock)		 
			 join scmdb..so_blanket_item_dtl dtl with(nolock)
			on so.sohdr_ou				=	dtl.bsodet_ship_point
			and	so.sohdr_ref_doc_no		=	dtl.bsodet_contract_no
			join  scmdb..so_contract_hdr vw with(nolock)
			on	vw.conhdr_ou				=	bsodet_ou	
			and vw.conhdr_contract_no		=	dtl.bsodet_contract_no
			and vw.conhdr_amend_no			=(select max(vw1.conhdr_amend_no)
			from scmdb..so_contract_hdr vw1 with(nolock)
			where vw.conhdr_contract_no = vw1.conhdr_contract_no
                                and vw.conhdr_ou = vw1.conhdr_ou)	
			join scmdb..so_order_item_dtl with(nolock)
			on sodtl_ou					=	sohdr_ou
			and sodtl_order_no			=	sohdr_order_no
			and sodtl_item_code			=	bsodet_item_code	
			and	sohdr_order_no			=	@transactionno
			and sohdr_ou				=	@ctxt_ouinstance
			join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
			on docNo					=	sohdr_ref_doc_no
			and OUID					=	conhdr_ou
			and  doc_AMD_No			=	(select max(vw1.conhdr_amend_no)
											from scmdb..so_contract_hdr vw1 with(nolock)
											where vw.conhdr_contract_no = vw1.conhdr_contract_no
											and vw.conhdr_ou = vw1.conhdr_ou)
			and ItemCode				=	sodtl_item_code
			AND bsodet_line_no			=	Doc_Line_no
			and docNo					=	@contractno1
			and parameter				=	'PAM'
			 where sohdr_ref_doc_no		=	@contractno1
			 and sohdr_order_no		=	@transactionno
			 and sohdr_ou			=	@ctxt_ouinstance

	select @so_pam	=	Min(amount)
	from scmdb..ZRIT_QUOTATION_PAM_DETAIL vw with(nolock)
	--join scmdb..so_order_item_dtl with(nolock)
	--	on docNo	=	sodtl_order_no
	--	and OUID	=	sodtl_ou
	--	and sodtl_item_code	=	ItemCode
	where parameter = 'PAM'
	and DocNo		= @transactionno
	and OUID		= @ctxt_ouinstance
	and  vw.doc_AMD_No	=	(select max(vw1.doc_AMD_No)
											from scmdb..ZRIT_QUOTATION_PAM_DETAIL vw1 with(nolock)
											where vw.DocNo = vw1.DocNo
											and vw.OUID = vw1.OUID
											and OUID		=	@ctxt_ouinstance
											and		DocNo		=	@transactionno)
	group by DocNo
	

	/*Code added against PJRMC-1496 Begins */
					select	@cust_type1				=	clo_noc
				from so_order_hdr with(nolock)
				join cust_lo_info with(nolock)
					on sohdr_order_from_cust	=	clo_cust_code
					and  clo_cust_code			=	@billtocust
				where  sohdr_order_no			=	isnull(@transactionno,sohdr_order_no)
				and		sohdr_ou				=	@ctxt_ouinstance
				/*Code added against PJRMC-1496 Ends */
	
/*Code added against Pjrmc-1253 Begins */
  Select @so_total_price	=	sohdr_total_value
  from so_order_hdr with(nolock)
  where sohdr_order_no	=	@transactionno
  and	sohdr_ou		=	@ctxt_ouinstance
  /* Code added against Pjrmc-1253 Ends */

select @DIFF	=	isnull(@so_pam-@con_pam,0)
				select	@creator				=	sohdr_created_by
				,		@doc_date				=	isnull(sohdr_order_date,sohdr_created_date)
				,		@doc_value				=   Amount
				 from scmdb..so_order_hdr with(nolock)
				 join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
					on sohdr_ou					=	OUID
					and sohdr_order_no			=	DocNo
				where  Parameter				=	'PAM'
					and DocNo	= isnull(@transactionno,DocNo)
					and OUID	=	@ctxt_ouinstance
			

		if exists (				select 'X'
								from	zrit_workflow_iedk_view with(nolock)
								join so_order_hdr with(nolock)
								on sohdr_ou					=	wfi_ouid
								and sohdr_sale_type_dflt	in('TRADE','DOM')
								/*Code added against PJRMC-1253 Begins */
								join cust_bu_info with(nolock)
								on sohdr_order_from_cust	=	cbu_cust_code
								and cbu_cr_term_code		<>	'ADV'
								/*Code added against PJRMC-1253 Ends */
								where	wfi_ouid			=	@ctxt_ouinstance            
								and wfi_status				=	'AC'            
								and (sohdr_ref_doc_type = 'NSO' or sohdr_ref_doc_type = 'NONE')
								and wfi_activity			=	@Doc_ActivityCD
								and wfi_component			=	@component_aso             
								and wfi_activity			=	@activity_aso    
								and wfi_addl_pm				=	'RMC ATRD'
								and	sohdr_order_no			=	@transactionno
								and sohdr_ou				=	@ctxt_ouinstance
								)
					Begin	
					declare @dayys int , @advcustomer1	varchar(200) /*Code added against PJRMC-1253 */
					select @dayys= max(datediff(d,duedate,getdate()))  from ci_drdoc_vw(nolock)  where  language_id=1
					and custcode=@billtocust
					and datediff(d,duedate,getdate())>0
					--and		ou_id	=	@ctxt_ouinstance
					/*Code added against PJRMC-1496 Begins */
					If @cust_type1 = 'IT'
					Begin
					
					select @Pathid		=	wfi_path  ,
					@ruleid				=	wfi_rule
					from zrit_workflow_iedk_view with(nolock)     
					where wfi_ouid		= @ctxt_ouinstance            
					and wfi_status		= 'AC'            
					and wfi_component	= @component_aso             
					and wfi_activity	= @activity_aso    
					and wfi_path		like	'ZRIT_RAMTSO_PATH_PAM%'
					and wfi_path		not like '%ZRIT_RAMTSO_PATH_ADV%'/*code added against PJRMC-1253 */
					and wfi_addl_pm		=	'RMC ATRD'
					and @doc_date between wfi_from_dt and wfi_to_dt 
					and @so_pam	between wfi_val_from and wfi_val_to
					
					End
					If @cust_type1 = 'ET'
					Begin /*Code added against PJRMC-1496 */
/*
					select @credituser	=	WFuser from scmdb..zrit_workflow_iedk_view with(nolock)
					where  wfi_ouid		=	@ctxt_ouinstance            
					and wfi_status		=	'AC'            
					and wfi_path		=	'ZRIT_RAMTSO_PATH_7'
					and WFLevel			=	'auth'
					and @dayys	between wfi_addl_1 and 	wfi_addl_2
*/					
					select @credituser		=	WFuser
					from scmdb..zrit_workflow_iedk_view with(nolock)
					join zrit_rmc_wkfflow_cd	with(nolock)
					on wfi_component		=	Comp_name
					and wfi_activity		=	Activity_name
					where  wfi_component	=	@component_aso             
					and wfi_activity		=	@activity_aso
					and wfi_addl_pm			=	'RMC ACD'
					and wfi_path			=	Path_CD
					and wfi_ouid			=	@ctxt_ouinstance         
					and wfi_status			=	'AC'   
					and @dayys	between wfi_addl_1 and 	wfi_addl_2
		
				if @credituser is null
				Begin				
					select @Pathid		=	wfi_path  ,
					@ruleid				=	wfi_rule
					from zrit_workflow_iedk_view with(nolock)     
					where wfi_ouid		= @ctxt_ouinstance            
					and wfi_status		= 'AC'            
					and wfi_component	= @component_aso             
					and wfi_activity	= @activity_aso    
					and wfi_path		like	'ZRIT_RAMTSO_PATH_PAM%'
					and wfi_path not like '%ZRIT_RAMTSO_PATH_ADV%'/*code added against PJRMC-1253 */
					and wfi_addl_pm		=	'RMC ATRD'
					and @doc_date between wfi_from_dt and wfi_to_dt 
					and @so_pam	between wfi_val_from and wfi_val_to
					
				End
				Else if @credituser is not null
				Begin				
					select /*top 1*/ @Pathid			=	wfi_path  
					from zrit_workflow_iedk_view with(nolock)            
					where wfi_ouid					= @ctxt_ouinstance            
					and wfi_status					= 'AC'            
					and wfi_component				= @component_aso             
					and wfi_activity				= @activity_aso  		
					--and wfi_path		like	'ZRIT_RAMTSO_PATH_PAM%'
					and wfi_path		like	'ZRIT_RAMTSO_PATH_CRDT%' /*Code changed against Shrimalavika M on 170425*/
					and wfi_path		not like '%ZRIT_RAMTSO_PATH_ADV%'/*code added against PJRMC-1253 */
					and wfi_addl_pm					= 'RMC ATRD'
					--and wfi_path  not like 'ZRIT_RAMTSO_PATH%'
					and @so_pam between wfi_val_from and wfi_val_to
					and @doc_date between wfi_from_dt and wfi_to_dt  					
				End
				End		
				End /*Code added against PJRMC-1496 */	
				Else if exists (
								select 'X' from	zrit_workflow_iedk_view with(nolock)
								join so_order_hdr with(nolock)
								on sohdr_ou					=	wfi_ouid
								and sohdr_sale_type_dflt	in('TRADE','DOM')
								and sohdr_ref_doc_type	=	'CON'
								join cust_bu_info with(nolock)
								on sohdr_order_from_cust	=	cbu_cust_code
								and cbu_cr_term_code		<>	'ADV'
								where	wfi_ouid			=	@ctxt_ouinstance            
								and wfi_status				=	'AC'            
								and wfi_activity			=	@Doc_ActivityCD
								and wfi_component			=	@component_aso             
								and wfi_activity			=	@activity_aso    
								and wfi_addl_pm				<>	'RMC ATRD'
								and	sohdr_order_no			=	@transactionno
								and sohdr_ou				=	@ctxt_ouinstance
									/*select 'X'
								from zrit_workflow_iedk_view with(nolock)
								where wfi_component	=	'NSO'             
								and wfi_activity	=	'PPSCMQSOAMDQO1'
								and @doc_activitycd	=	'PPSCMQSOAMDQO1'
								and wfi_addl_pm		not like	'RMC ATRD%'*/
								)
				Begin			
						declare @days int 
						select @days	= max(datediff(d,duedate,getdate()))  from ci_drdoc_vw(nolock)  where  language_id=1
						and custcode	=	@billtocust
						and datediff(d,duedate,getdate())>0					
						/*Code added against PJRMC-1496 */
						If @cust_type1 = 'IT'
						Begin 
						if isnull(@DIFF,0) >-25  
						Begin		
							select @Pathid			=	'ZRIT_RAMTSO_PATH_PAM_1'
						End
					 ELse if isnull(@DIFF,0) <-25  and @doc_value>800
					 Begin
						select @Pathid			=	'ZRIT_RAMTSO_PATH_PAM_2'
					 End
					 Else
						Begin				
							select  @Pathid				=	wfi_path  ,
									@ruleid				=	wfi_rule
							from zrit_workflow_iedk_view with(nolock)            
							where wfi_ouid				= @ctxt_ouinstance            
							and wfi_status				= 'AC'            
							and wfi_component			= @component_aso             
							and wfi_activity			= @activity_aso    
							and wfi_path	like 'ZRIT_RAMTSO_PATH_PAM%'
							and wfi_path not like '%ZRIT_RAMTSO_PATH_ADV%'/*code added against PJRMC-1253 */
							and @doc_value between wfi_val_from and wfi_val_to
							--and @DIFF between wfi_val_from and wfi_val_to
							and @doc_date between wfi_from_dt and wfi_to_dt					
						End
						End
				/*		
					select @credituser	=	WFuser from scmdb..zrit_workflow_iedk_view with(nolock)
					where  wfi_ouid		=	@ctxt_ouinstance            
					and wfi_status		=	'AC'            
					and wfi_path		=	'ZRIT_RAMTSO_PATH_7'
					and WFLevel			=	'auth'
					and @days		between wfi_addl_1 and 	wfi_addl_2
				*/			
				If @cust_type1 = 'ET'
				Begin
				
				 /*Code added against PJRMC-1496 Ends */
					select @credituser		=	WFuser
					from scmdb..zrit_workflow_iedk_view with(nolock)
					join zrit_rmc_wkfflow_cd	with(nolock)
					on wfi_component		=	Comp_name
					and wfi_activity		=	Activity_name
					where  wfi_component	=	@component_aso             
					and wfi_activity		=	@activity_aso
					and wfi_addl_pm			=	'RMC ACD'
					and wfi_path			=	Path_CD
					and wfi_ouid			=	@ctxt_ouinstance            
					and wfi_status			=	'AC'    
					and @days	between wfi_addl_1 and 	wfi_addl_2

					if @credituser is null
					Begin				
						if isnull(@DIFF,0) >-25  
					Begin		
						select @Pathid	=	'ZRIT_RAMTSO_PATH_PAM_1'	
			/*select @Pathid			=	Path_Dauth
							from scmdb..zrit_workflow_iedk_view with(nolock)
							join zrit_rmc_wkfflow_cd	with(nolock)
							on wfi_component		=	Comp_name
							and wfi_activity		=	Activity_name
							where  wfi_component	=	@component_aso             
							and wfi_activity		=	@activity_aso
							and wfi_addl_pm			=	'RMC ASO'
							and wfi_ouid			=	@ctxt_ouinstance            
							and wfi_status			=	'AC'     
							and @doc_date between wfi_from_dt and wfi_to_dt*/  
					/*
							select @Pathid					=	wfi_path  ,
									@ruleid					=	wfi_rule
							from zrit_workflow_iedk_view with(nolock)            
							where wfi_ouid					=  @ctxt_ouinstance            
							and wfi_status					=  'AC'            
							and wfi_component				=  @component_aso             
							and wfi_activity				=  @activity_aso    
							and wfi_path					=  'ZRIT_RAMTSO_PATH_PAM_1'
							--and @DIFF		between wfi_val_from and wfi_val_to
							and @doc_date	between wfi_from_dt and wfi_to_dt  
					*/
					End
					ELse if isnull(@DIFF,0) <-25  and @doc_value>800
						Begin					
								select @Pathid					=	'ZRIT_RAMTSO_PATH_PAM_2'
						End
					Else
						Begin				
							select  @Pathid				=	wfi_path  ,
									@ruleid				=	wfi_rule
							from zrit_workflow_iedk_view with(nolock)            
							where wfi_ouid				= @ctxt_ouinstance            
							and wfi_status				= 'AC'            
							and wfi_component			= @component_aso             
							and wfi_activity			= @activity_aso    
							and wfi_path	like 'ZRIT_RAMTSO_PATH_PAM%'
							and wfi_path not like '%ZRIT_RAMTSO_PATH_ADV%'/*code added against PJRMC-1253 */
							and @doc_value between wfi_val_from and wfi_val_to
							--and @DIFF between wfi_val_from and wfi_val_to
							and @doc_date between wfi_from_dt and wfi_to_dt					
						End
					End
				
					if @credituser is not null
					Begin
						if isnull(@DIFF,0) >-25  
						Begin	
							select @Pathid			=	Path_Dauth
							from scmdb..zrit_workflow_iedk_view with(nolock)
							join zrit_rmc_wkfflow_cd	with(nolock)
							on wfi_component		=	Comp_name
							and wfi_activity		=	Activity_name
							where  wfi_component	=	@component_aso             
							and wfi_activity		=	@activity_aso
							and wfi_addl_pm			=	'RMC ASO'
							and wfi_ouid			=	@ctxt_ouinstance
							--and wfi_path	like 'ZRIT_RAMTSO_PATH_PAM%'
							and wfi_path	like	'ZRIT_RAMTSO_PATH_CRDT%'/*code added by Shrimalavika M againt RPRMCB-1 on 170425*/							and wfi_path not like '%ZRIT_RAMTSO_PATH_ADV%'/*code added against PJRMC-1253 */
							and wfi_status			=	'AC'     
							and @doc_date between wfi_from_dt and wfi_to_dt  
						/*
						select @Pathid		=	wfi_path  ,
						@ruleid				=	wfi_rule
						from zrit_workflow_iedk_view with(nolock)            
						where wfi_ouid		= @ctxt_ouinstance            
						and wfi_status		= 'AC'            
						and wfi_component	= @component_aso             
						and wfi_activity	= @activity_aso    
						and wfi_path		=	'ZRIT_RAMTSO_PATH_1'
						and @doc_date between wfi_from_dt and wfi_to_dt  
						*/
						End
						Else
						Begin
							select /*top 1*/ @Pathid		=	wfi_path  
							from zrit_workflow_iedk_view with(nolock)            
							where wfi_ouid				=	@ctxt_ouinstance            
							and wfi_status				=	'AC'            
							and wfi_component			=	@component_aso             
							and wfi_activity			=	@activity_aso  
							--and wfi_path	like 'ZRIT_RAMTSO_PATH%'
							/*Code added against RPRMCB-1 on 17-04-2025 Begins */
							and wfi_addl_pm			=	'RMC ASO'
							and wfi_path	like	'ZRIT_RAMTSO_PATH_CRDT%'/*code added by Shrimalavika M againt RPRMCB-1 on 170425*/
							/*Code added against RPRMCB-1 on  17-04-2025 Ends */
							and wfi_path not like '%ZRIT_RSO_PATH_ADV%'/*code added against PJRMC-1253 */
							and @doc_value	between wfi_val_from and wfi_val_to
							and @doc_date	between wfi_from_dt and wfi_to_dt  
							End
						End
						End
						End /*Code added against PJRMC-1496 */
						/* Code added by Shrimalavika M for PJRMC-712 Begins */
						If exists(select 'X' from scmdb..so_order_hdr with(nolock)
						where sohdr_ou				=	@ctxt_ouinstance
						and sohdr_order_no			=	@transactionno
						AND sohdr_sale_type_dflt	in('SERV','SAMP','SCRAP','EXP')	
						)
						Begin
							Select @Pathid	=	'ZRIT_RAMTSO_PATH_PAM_7'
						End
						/* Code added by Shrimalavika M for PJRMC-712 Ends */
						--End
 /* code added by Shrimalavika M against PJRMC-1253 Begins */
						  if exists (
								select 'X'
								from zrit_workflow_iedk_view with(nolock)
								where wfi_component	=	'NSO'             
								and wfi_activity	=	'PPSCMQSOAMDQO1'
								and @doc_activitycd	=	'PPSCMQSOAMDQO1'
								)
								Begin
								
	If Exists (
				select 'X'	from so_order_hdr with(nolock)
							join cust_bu_info with(nolock)
								on sohdr_order_from_cust	=	cbu_cust_code
								where cbu_cr_term_code	=	'ADV'
								and sohdr_freight_billable ='Y'
								and sohdr_order_no			=	@transactionno
								and  sohdr_ou					=	@ctxt_ouinstance
								and sohdr_sale_type_dflt		in	('TRADE','DOM')
			  )
			  Begin
			
						If Exists (select 'X' from scmdb..so_order_hdr with(nolock)
							where  sohdr_order_no			=	@transactionno
							and sohdr_ou					=	@ctxt_ouinstance
							and (sohdr_ref_doc_type			=	'NSO' or sohdr_ref_doc_type='NONE')
							)
							Begin		
							
							 select @Pathid			= wfi_path  ,  
								@ruleid				= wfi_rule  
								from zrit_workflow_iedk_view with(nolock)              
								where wfi_ouid		= @ctxt_ouinstance              
								and wfi_status		= 'AC'              
								and wfi_component	= @component_aso               
								and wfi_activity	= @activity_aso      
								--and wfi_path  like 'ZRIT_RAMTSO_PATH_ADV%' 
								and wfi_path like 'ZRIT_RAMTSO_PATH_PAM%'
								and wfi_addl_pm		= 'RMC ATRD'
								and @doc_date between wfi_from_dt and wfi_to_dt   
								and @so_pam between wfi_val_from and wfi_val_to  
							End
			Else if exists (
								select 'X' from zrit_workflow_iedk_view with(nolock)
								join so_order_hdr with(nolock)
								on sohdr_ou					=	wfi_ouid
								and	sohdr_order_no			=	@transactionno
								and sohdr_ref_doc_no		=	@contractno1
								and sohdr_sale_type_dflt	=	'DOM'
								and sohdr_ref_doc_type		=	'CON'
								where	wfi_ouid			=	@ctxt_ouinstance            
								and wfi_status				= 'AC'        
								and wfi_activity			= @Doc_ActivityCD
								and wfi_component			= @component_aso             
								and wfi_activity			= @activity_aso    
								and wfi_addl_pm				= 'RMC ASO'
								and	sohdr_order_no			= @transactionno
					)
					Begin
					
					if isnull(@DIFF,0) >-25 
					Begin			
							select @Pathid					=	 'ZRIT_RAMTSO_PATH_PAM_1'
					End
						ELse if isnull(@DIFF,0) <-25  and @doc_value>800
						Begin
						
								select @Pathid					=	'ZRIT_RAMTSO_PATH_PAM_2'
						End
						Else
						Begin
						
								select  @Pathid				=	wfi_path  ,
										@ruleid				=	wfi_rule
								from zrit_workflow_iedk_view with(nolock)            
								where wfi_ouid				= @ctxt_ouinstance            
								and wfi_status				= 'AC'            
								and wfi_component			= @component_aso       
								and wfi_activity			= @activity_aso    
								and wfi_path	like 'ZRIT_RAMTSO_PATH_PAM%'
								and @doc_value between wfi_val_from and wfi_val_to
								and @doc_date between wfi_from_dt and wfi_to_dt 
								
						End
					End
					End
			  
			select @advcustomer1 = WFuser  
						from scmdb..zrit_workflow_iedk_view with(nolock)  
						where  wfi_component		= 'NSO'               
						and wfi_activity			= 'PPSCMQSOAMDQO1'  
						and wfi_addl_pm				= 'RMC AADV' 
						and WFLevel					= 'auth'
						and	@so_total_price			between wfi_val_from and  wfi_val_to  

			If exists (Select 'X' from scmdb..so_order_hdr with(nolock)
						join scmdb..cust_bu_info with(nolock)
							on sohdr_order_from_cust	=	cbu_cust_code
							and cbu_cr_term_code		=	'ADV'
						where sohdr_order_no			=	@transactionno
						and  sohdr_ou					=	@ctxt_ouinstance
						and sohdr_sale_type_dflt		in	('TRADE','DOM')
						and sohdr_freight_billable		=	'N' --aparna
					)
					Begin
					
						If Exists (select 'X' from scmdb..so_order_hdr with(nolock)
							where  sohdr_order_no			=	@transactionno
							and sohdr_ou					=	@ctxt_ouinstance
							and (sohdr_ref_doc_type			=	'NSO' or sohdr_ref_doc_type='NONE')
							)
							Begin
							
							if exists (
								select 'X'
								from	zrit_workflow_iedk_view with(nolock)
								join so_order_hdr with(nolock)
								on sohdr_ou					=	wfi_ouid
								and		sohdr_order_no		=	@transactionno
								--and sohdr_sale_type_dflt	=	'TRADE'	
								and sohdr_sale_type_dflt	in	('TRADE','DOM')---899
								where	wfi_ouid = @ctxt_ouinstance            
								and wfi_status		= 'AC'        
								and wfi_activity	= @Doc_ActivityCD
								and wfi_component	= @component_aso             
								and wfi_activity	= @activity_aso    
								and wfi_addl_pm		= 'RMC ATRD'
								and	sohdr_order_no	= @transactionno
			)
					Begin						
							 select @Pathid			= wfi_path  ,  
								@ruleid				= wfi_rule  
								from zrit_workflow_iedk_view with(nolock)              
								where wfi_ouid		= @ctxt_ouinstance              
								and wfi_status		= 'AC'              
								and wfi_component	= @component_aso               
								and wfi_activity	= @activity_aso      
								and wfi_path  like 'ZRIT_RAMTSO_PATH_ADV%' 
								and wfi_addl_pm		= 'RMC ATRD'
								and @doc_date between wfi_from_dt and wfi_to_dt 
								and @so_pam between wfi_val_from and wfi_val_to  
					End
					End
					 if exists (
								select 'X' from zrit_workflow_iedk_view with(nolock)
								join so_order_hdr with(nolock)
								on sohdr_ou					=	wfi_ouid
								and	sohdr_order_no			=	@transactionno
								and sohdr_ref_doc_no		=	@contractno1
								and sohdr_sale_type_dflt	=	'DOM'
								and sohdr_ref_doc_type		=	'CON'
								where	wfi_ouid = @ctxt_ouinstance            
								and wfi_status				= 'AC'        
								and wfi_activity			= @Doc_ActivityCD
								and wfi_component			= @component_aso             
								and wfi_activity			= @activity_aso    
								and wfi_addl_pm				<> 'RMC ATRD'
								and	sohdr_order_no			= @transactionno
					)
					Begin
					
					if isnull(@DIFF,0) >-25 
					Begin
				
							select @Pathid					=	wfi_path ,
									@ruleid					=	wfi_rule
							from zrit_workflow_iedk_view with(nolock)            
							where wfi_ouid					=  @ctxt_ouinstance            
							and wfi_status					=  'AC'      
							and wfi_component				=  @component_aso             
							and wfi_activity				=  @activity_aso   
							and wfi_path					=  'ZRIT_RAMTSO_PATH_ADV_1'
							and wfi_addl_pm					= 'RMC ASO'
							and @doc_date between wfi_from_dt and wfi_to_dt  
					End
						ELse if isnull(@DIFF,0) <-25  and @doc_value>800
						Begin
						
								select @Pathid					=	wfi_path  ,
										@ruleid					=	wfi_rule
								from zrit_workflow_iedk_view with(nolock)            
								where wfi_ouid					= @ctxt_ouinstance            
								and wfi_status					=  'AC'            
								and wfi_component				=  @component_aso             
								and wfi_activity				=  @activity_aso    
								and wfi_path					=  'ZRIT_RAMTSO_PATH_ADV_2'
								and wfi_addl_pm					= 'RMC ASO'
								and @doc_date between wfi_from_dt and wfi_to_dt  
						End
						Else
						Begin
						
								select  @Pathid				=	wfi_path  ,
										@ruleid				=	wfi_rule
								from zrit_workflow_iedk_view with(nolock)            
								where wfi_ouid				= @ctxt_ouinstance            
								and wfi_status				= 'AC'            
								and wfi_component			= @component_aso       
								and wfi_activity			= @activity_aso    
								and wfi_path	like 'ZRIT_RAMTSO_PATH_ADV%'
								and wfi_addl_pm					= 'RMC ASO'
								and @doc_value between wfi_val_from and wfi_val_to
								and @doc_date between wfi_from_dt and wfi_to_dt  

							
						End
					End
				End
				End
 		  /* code added by Shrimalavika M against PJRMC-1253 Ends */
						
						
			Else
			Begin
			
declare @days1 int 
,@advcustomer	varchar(200) /*Code added against PJRMC-1253 */
select @days1	=	max(datediff(d,duedate,getdate()))  from ci_drdoc_vw(nolock)  where  language_id=1
and custcode	=	@billtocust
and datediff(d,duedate,getdate())>0
/*Code added against PJRMC-1496 Begins */
If @cust_type1	=	'IT'
Begin
	select @Pathid		=	wfi_path  ,
					@ruleid				=	wfi_rule
					from zrit_workflow_iedk_view with(nolock)            
					where wfi_ouid		= @ctxt_ouinstance            
					and wfi_status		= 'AC'            
					and wfi_component	= @component             
					and wfi_activity	= @activity    
					and wfi_path		like 'ZRIT_RSO_PATH_PAM%'
					and wfi_path not like '%ZRIT_RSO_PATH_ADV%'/*code added against PJRMC-1253 */
					and wfi_addl_pm		='Trd'
					and @doc_date between wfi_from_dt and wfi_to_dt 
					and @so_pam	between wfi_val_from and wfi_val_to
End
/*Code added against PJRMC-1496 Ends */
/* Code commented and added by shrimalavika M for RMC-SAL-37 Begins */
	/*	select @credituser	=	WFuser from scmdb..zrit_workflow_iedk_view with(nolock)
		where  wfi_ouid		=	@ctxt_ouinstance        
		and wfi_status		=	'AC'            
		and wfi_path		=	'ZRIT_RSO_PATH_18'
		and WFLevel			=	'auth'
		and @days1	between wfi_addl_1 and 	wfi_addl_2
*/
If @cust_type1	=	'ET'
Begin /*Code added against PJRMC-1496 */
select @credituser	= WFuser
from scmdb..zrit_workflow_iedk_view with(nolock)
join zrit_rmc_wkfflow_cd	with(nolock)
on wfi_component	=	Comp_name
and wfi_activity	=	Activity_name
where  wfi_component	= @component             
and wfi_activity	= @activity
and wfi_addl_pm  = 'CD'
and wfi_path = Path_CD
and wfi_ouid		=	@ctxt_ouinstance            
and wfi_status		=	'AC'    
and @days1	between wfi_addl_1 and 	wfi_addl_2
/* Code commented and added by shrimalavika M for RMC-SAL-37 Ends */


if exists (
			select 'X'
			from	zrit_workflow_iedk_view with(nolock)
			join so_order_hdr with(nolock)
			on sohdr_ou					=	wfi_ouid
			and		sohdr_order_no		=	@transactionno
			--and sohdr_sale_type_dflt	=	'TRADE'	
			and sohdr_sale_type_dflt	in('TRADE','DOM')---899
			where	wfi_ouid = @ctxt_ouinstance            
					and wfi_status		= 'AC'        
					and wfi_activity	= @Doc_ActivityCD
					and wfi_component	= @component             
					and wfi_activity	= @activity    
					and wfi_addl_pm		= 'Trd'
					and	sohdr_order_no	= @transactionno
			)
			Begin	
				
				if @credituser is null
				Begin	
						
					select @Pathid		=	wfi_path  ,
					@ruleid				=	wfi_rule
					from zrit_workflow_iedk_view with(nolock)            
					where wfi_ouid		= @ctxt_ouinstance            
					and wfi_status		= 'AC'            
					and wfi_component	= @component             
					and wfi_activity	= @activity    
					and wfi_path		like 'ZRIT_RSO_PATH_PAM%'
					and wfi_path not like '%ZRIT_RSO_PATH_ADV%'/*code added against PJRMC-1253 */
					and wfi_addl_pm		='Trd'
					and @doc_date between wfi_from_dt and wfi_to_dt 
					and @so_pam	between wfi_val_from and wfi_val_to
		
				End
				Else if @credituser is not null
				Begin
					select @Pathid			=	wfi_path  ,
							@ruleid			=	wfi_rule
					from zrit_workflow_iedk_view with(nolock)            
					where wfi_ouid			= @ctxt_ouinstance            
					and wfi_status			= 'AC'            
					and wfi_component		= @component             
					and wfi_activity		= @activity  
					and wfi_path not like 'ZRIT_RSO_PATH_PAM%'
					and @so_pam between wfi_val_from and wfi_val_to
					and @doc_date between wfi_from_dt and wfi_to_dt  
					/*code added against PJRMC-1253 Begins */
					 and wfi_path not like '%ZRIT_RSO_PATH_ADV%'
					 and wfi_addl_pm ='Trd'
					 /*code added against PJRMC-1253 Ends */
				End
				End	
				End /*Code added against PJRMC-1496 */
 if exists (
			select 'X' from zrit_workflow_iedk_view with(nolock)
			join so_order_hdr with(nolock)
			on sohdr_ou					=	wfi_ouid
			and	sohdr_order_no			=	@transactionno
			and sohdr_ref_doc_no		=	@contractno1---newly added by shri---
			--and sohdr_sale_type_dflt	=	'TRADE'	
			and sohdr_sale_type_dflt	=	'DOM'---899
			where	wfi_ouid = @ctxt_ouinstance            
					and wfi_status		= 'AC'        
					and wfi_activity	= @Doc_ActivityCD
					and wfi_component	= @component             
					and wfi_activity	= @activity    
					and wfi_addl_pm		= 'RMC SO'
					and	sohdr_order_no	= @transactionno
					)
Begin
 If @cust_type1	=	'IT' /*Code added against PJRMC-1496 Begins */
 Begin
		if isnull(@DIFF,0) >-25  
		Begin
				
			select @Pathid					=	wfi_path  ,
					@ruleid					=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)            
			where wfi_ouid					=  @ctxt_ouinstance            
			and wfi_status					=  'AC'            
			and wfi_component				=  @component             
			and wfi_activity				=  @activity    
			and wfi_path					=  'ZRIT_RSO_PATH_PAM_1'
			and @doc_date between wfi_from_dt and wfi_to_dt  
		End
		ELse if isnull(@DIFF,0) <-25  and @doc_value>800
		Begin
		select @Pathid					=	wfi_path  ,
				@ruleid					=	wfi_rule
		from zrit_workflow_iedk_view with(nolock)     
		where wfi_ouid					=  @ctxt_ouinstance            
		and wfi_status					=  'AC'            
		and wfi_component				=  @component             
		and wfi_activity				=  @activity    
		and wfi_path					=  'ZRIT_RSO_PATH_PAM_2'
		and @doc_date between wfi_from_dt and wfi_to_dt  
		End
		Else
		Begin
		select  @Pathid				=	wfi_path  ,
				@ruleid				=	wfi_rule
		from zrit_workflow_iedk_view with(nolock)            
		where wfi_ouid				= @ctxt_ouinstance            
		and wfi_status				= 'AC'            
		and wfi_component			= @component     
		and wfi_activity			= @activity    
		and wfi_path	like 'ZRIT_RSO_PATH_PAM%'
		and wfi_path not like '%ZRIT_RSO_PATH_ADV%'/*code added against PJRMC-1253 */
		and wfi_addl_pm		= 'RMC SO'
		and @doc_value between wfi_val_from and wfi_val_to
		and @doc_date between wfi_from_dt and wfi_to_dt  
		End
 ENd---/*Code added against PJRMC-1496 Ends */
 If @cust_type1	=	'ET' /*Code added against PJRMC-1496 Begins */
 Begin
if @credituser is null
Begin
	if isnull(@DIFF,0) >-25  
		Begin
				
			select @Pathid					=	wfi_path  ,
					@ruleid					=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)      
			where wfi_ouid					=  @ctxt_ouinstance            
			and wfi_status					=  'AC'            
			and wfi_component				=  @component             
			and wfi_activity				=  @activity    
			and wfi_path					=  'ZRIT_RSO_PATH_PAM_1'
			and @doc_date between wfi_from_dt and wfi_to_dt  
		End
ELse if isnull(@DIFF,0) <-25  and @doc_value>800
Begin

		select @Pathid					=	wfi_path  ,
				@ruleid					=	wfi_rule
		from zrit_workflow_iedk_view with(nolock)            
		where wfi_ouid					= @ctxt_ouinstance            
		and wfi_status					=  'AC'            
		and wfi_component				=  @component     
		and wfi_activity				=  @activity    
		and wfi_path					=  'ZRIT_RSO_PATH_PAM_2'
		and @doc_date between wfi_from_dt and wfi_to_dt  
End
Else
Begin
		select  @Pathid				=	wfi_path  ,
				@ruleid				=	wfi_rule
		from zrit_workflow_iedk_view with(nolock)            
		where wfi_ouid				= @ctxt_ouinstance            
		and wfi_status				= 'AC'            
		and wfi_component			= @component       
		and wfi_activity			= @activity    
		and wfi_path	like 'ZRIT_RSO_PATH_PAM%'
		and wfi_path not like '%ZRIT_RSO_PATH_ADV%'/*code added against PJRMC-1253 */
		and wfi_addl_pm		= 'RMC SO'
		and @doc_value between wfi_val_from and wfi_val_to
		and @doc_date between wfi_from_dt and wfi_to_dt  
End
End
if @credituser is not null
Begin

 if isnull(@DIFF,0) >-25  
Begin
/* Code commented and added by shrimalavika M for RMC-SAL-37 Begins */
	select @Pathid			=	Path_Dauth
	from scmdb..zrit_workflow_iedk_view with(nolock)
	join zrit_rmc_wkfflow_cd	with(nolock)
	on wfi_component		=	Comp_name
	and wfi_activity		=	Activity_name
	where  wfi_component	=	@component             
	and wfi_activity		=	@activity
	and wfi_addl_pm			=	'RMC SO'
	and wfi_ouid			=	@ctxt_ouinstance            
	and wfi_path not like '%ZRIT_RSO_PATH_ADV%'/*code added against PJRMC-1253 */
	and wfi_status			=	'AC'     
	and @doc_date between wfi_from_dt and wfi_to_dt  
/*
select @Pathid		=	wfi_path  ,
@ruleid				=	wfi_rule
from zrit_workflow_iedk_view with(nolock)            
where wfi_ouid		= @ctxt_ouinstance            
and wfi_status		= 'AC'            
and wfi_component	= @component             
and wfi_activity	= @activity    
and wfi_path		=	'ZRIT_RSO_PATH_11'
and @doc_date between wfi_from_dt and wfi_to_dt  
*/
End
ELse if isnull(@DIFF,0) <-25  and @doc_value>800
Begin

		select @Pathid					=	wfi_path  ,
				@ruleid					=	wfi_rule
		from zrit_workflow_iedk_view with(nolock)            
		where wfi_ouid					=  @ctxt_ouinstance            
		and wfi_status					=  'AC'            
		and wfi_component				=  @component             
		and wfi_activity				=  @activity    
		and wfi_path					=  'ZRIT_RSO_PATH_CRDT_2'
		and @doc_date between wfi_from_dt and wfi_to_dt  
End
Else
Begin
	select 
	@Pathid				=	wfi_path  ,
	@ruleid				=	wfi_rule
	from zrit_workflow_iedk_view with(nolock)            
	where wfi_ouid		= @ctxt_ouinstance            
	and wfi_status		= 'AC'  
	and wfi_component	= @component             
	and wfi_activity	= @activity  
	and wfi_path not like 'ZRIT_RSO_PATH_PAM%'
	and wfi_path not like '%ZRIT_RSO_PATH_ADV%'/*code added against PJRMC-1253 */
	and wfi_addl_pm			=	'RMC SO'
	and @doc_value between wfi_val_from and wfi_val_to
	and @doc_date between wfi_from_dt and wfi_to_dt  
/* Code commented and added by shrimalavika M for RMC-SAL-37 Ends */
End
End
End
End /*Code added against PJRMC-1496 */					
/* Code added by Shrimalavika M for PJRMC-712 Begins */
If exists(select 'X' from scmdb..so_order_hdr with(nolock)
			where sohdr_ou				=	@ctxt_ouinstance
			and sohdr_order_no			=	@transactionno
			AND sohdr_sale_type_dflt	in('SERV','SAMP','SCRAP','EXP')	
			)
			Begin
				Select @Pathid	=	'ZRIT_RSO_PATH_PAM_7'
			End
/* Code added by Shrimalavika M for PJRMC-712 Ends */
/* code added by Shrimalavika M against PJRMC-1253 Begins */

	If Exists (
				select 'X'	from so_order_hdr with(nolock)
							join cust_bu_info with(nolock)
								on sohdr_order_from_cust		=	cbu_cust_code
								where cbu_cr_term_code			=	'ADV'
								and sohdr_freight_billable		=	'Y'
								and sohdr_order_no				=	@transactionno
								and  sohdr_ou					=	@ctxt_ouinstance
								and sohdr_sale_type_dflt		in	('TRADE','DOM')
			  )
			  Begin
			 
						If Exists (select 'X' from scmdb..so_order_hdr with(nolock)
							where  sohdr_order_no			=	@transactionno
							and sohdr_ou					=	@ctxt_ouinstance
							and (sohdr_ref_doc_type			=	'NSO' or sohdr_ref_doc_type='NONE')
							)
							Begin						
							 select @Pathid			= wfi_path  ,  
								@ruleid				= wfi_rule  
								from zrit_workflow_iedk_view with(nolock)              
								where wfi_ouid		= @ctxt_ouinstance              
								and wfi_status		= 'AC'              
								and wfi_component	= @component               
								and wfi_activity	= @activity      
								and wfi_path  like 'ZRIT_RSO_PATH_PAM%' 
								and wfi_addl_pm		= 'Trd'
								and @doc_date between wfi_from_dt and wfi_to_dt   
								and @so_pam between wfi_val_from and wfi_val_to  
							End
				ELse if exists (
								select 'X' from zrit_workflow_iedk_view with(nolock)
								join so_order_hdr with(nolock)
								on sohdr_ou					=	wfi_ouid
								and	sohdr_order_no			=	@transactionno
								and sohdr_ref_doc_no		=	@contractno1
								and sohdr_sale_type_dflt	=	'DOM'
								and sohdr_ref_doc_type		=	'CON'
								where	wfi_ouid = @ctxt_ouinstance            
								and wfi_status				= 'AC'        
								and wfi_activity			= @Doc_ActivityCD
								and wfi_component			= @component             
								and wfi_activity			= @activity    
								and wfi_addl_pm				= 'RMC SO'
								and	sohdr_order_no			= @transactionno
					)
					Begin
					if isnull(@DIFF,0) >-25 
					Begin			
							select @Pathid					=	wfi_path ,
									@ruleid					=	wfi_rule
							from zrit_workflow_iedk_view with(nolock)            
							where wfi_ouid					=  @ctxt_ouinstance            
							and wfi_status					=  'AC'            
							and wfi_component				=  @component             
							and wfi_activity				=  @activity    
							and wfi_path					=  'ZRIT_RSO_PATH_PAM_1'
							and @doc_date between wfi_from_dt and wfi_to_dt  
					End
						ELse if isnull(@DIFF,0) <-25  and @doc_value>800
						Begin
						
								select @Pathid					=	wfi_path  ,
										@ruleid					=	wfi_rule
								from zrit_workflow_iedk_view with(nolock)            
								where wfi_ouid					= @ctxt_ouinstance            
								and wfi_status					=  'AC'            
								and wfi_component				=  @component             
								and wfi_activity				=  @activity    
								and wfi_path					=  'ZRIT_RSO_PATH_PAM_2'
								and @doc_date between wfi_from_dt and wfi_to_dt  
						End
						Else
						Begin
								select  @Pathid				=	wfi_path  ,
										@ruleid				=	wfi_rule
								from zrit_workflow_iedk_view with(nolock)            
								where wfi_ouid				= @ctxt_ouinstance            
								and wfi_status				= 'AC'            
								and wfi_component			= @component       
								and wfi_activity			= @activity    
								and wfi_path	like 'ZRIT_RSO_PATH_PAM%'
								and @doc_value between wfi_val_from and wfi_val_to
								and @doc_date between wfi_from_dt and wfi_to_dt  
						End
					End
					End
				-----------------
			select @advcustomer = WFuser  
						from scmdb..zrit_workflow_iedk_view with(nolock)  
						where  wfi_component		= 'NSO'               
						and wfi_activity			= 'PPSCMQSOCRTQO1'  
						and wfi_addl_pm				= 'RMC ADV' 
						and WFLevel					= 'auth'
						and	@so_total_price			between wfi_val_from and  wfi_val_to  

			if isnull(@advcustomer,'') <>''
			Begin
						If exists (Select 'X' from scmdb..so_order_hdr with(nolock)
						join scmdb..cust_bu_info with(nolock)
							on sohdr_order_from_cust	=	cbu_cust_code
							and cbu_cr_term_code		=	'ADV'
						where sohdr_order_no			=	@transactionno
						and  sohdr_ou					=	@ctxt_ouinstance
						and sohdr_sale_type_dflt		in	('TRADE','DOM')
						and sohdr_freight_billable		=	'N' --aparna
					)
					Begin
				
						If Exists (select 'X' from scmdb..so_order_hdr with(nolock)
							where  sohdr_order_no			=	@transactionno
							and sohdr_ou					=	@ctxt_ouinstance
							and (sohdr_ref_doc_type			=	'NSO' or sohdr_ref_doc_type='NONE')
							)
							Begin

							if exists (
								select 'X'
								from	zrit_workflow_iedk_view with(nolock)
								join so_order_hdr with(nolock)
								on sohdr_ou					=	wfi_ouid
								and		sohdr_order_no		=	@transactionno
								--and sohdr_sale_type_dflt	=	'TRADE'	
								and sohdr_sale_type_dflt	in('TRADE','DOM')---899
								where	wfi_ouid = @ctxt_ouinstance            
								and wfi_status		= 'AC'        
								and wfi_activity	= @Doc_ActivityCD
								and wfi_component	= @component             
								and wfi_activity	= @activity    
								and wfi_addl_pm		= 'Trd'
								and	sohdr_order_no	= @transactionno
			)
					Begin						
							 select @Pathid			= wfi_path  ,  
								@ruleid				= wfi_rule  
								from zrit_workflow_iedk_view with(nolock)              
								where wfi_ouid		= @ctxt_ouinstance              
								and wfi_status		= 'AC'              
								and wfi_component	= @component               
								and wfi_activity	= @activity      
								and wfi_path  like 'ZRIT_RSO_PATH_ADV%' 
								and wfi_addl_pm		= 'Trd'
								and @doc_date between wfi_from_dt and wfi_to_dt   
								and @so_pam between wfi_val_from and wfi_val_to  
					End
					End
						
					 if exists (
								select 'X' from zrit_workflow_iedk_view with(nolock)
								join so_order_hdr with(nolock)
								on sohdr_ou					=	wfi_ouid
								and	sohdr_order_no			=	@transactionno
								and sohdr_ref_doc_no		=	@contractno1
								and sohdr_sale_type_dflt	=	'DOM'
								and sohdr_ref_doc_type		=	'CON'
								where	wfi_ouid = @ctxt_ouinstance            
								and wfi_status				= 'AC'        
								and wfi_activity			= @Doc_ActivityCD
								and wfi_component			= @component             
								and wfi_activity			= @activity    
								and wfi_addl_pm				= 'RMC SO'
								and	sohdr_order_no			= @transactionno
					)
					Begin	
				
						if isnull(@DIFF,0) >-25 
							Begin
				
							select @Pathid					= 'ZRIT_RSO_PATH_ADV_1'/*	wfi_path ,
									@ruleid					=	wfi_rule
							from zrit_workflow_iedk_view with(nolock)            
							where wfi_ouid					=  @ctxt_ouinstance            
							and wfi_status					=  'AC'            
							and wfi_component				=  @component             
							and wfi_activity				=  @activity    
							and wfi_path					=  'ZRIT_RSO_PATH_ADV_1'
							and wfi_addl_pm				= 'RMC SO'
							and @doc_date between wfi_from_dt and wfi_to_dt  */
					End
						ELse if isnull(@DIFF,0) <-25  and @doc_value>800
						Begin
						
								select @Pathid					=	'ZRIT_RSO_PATH_ADV_2' /*wfi_path  ,
										@ruleid					=	wfi_rule
								from zrit_workflow_iedk_view with(nolock)            
								where wfi_ouid					= @ctxt_ouinstance            
								and wfi_status					=  'AC'            
								and wfi_component				=  @component             
								and wfi_activity				=  @activity    
								and wfi_path					=  'ZRIT_RSO_PATH_ADV_2'
								and wfi_addl_pm				= 'RMC SO'
								and @doc_date between wfi_from_dt and wfi_to_dt  */
						End
						Else
						Begin
						
								select  @Pathid				=	wfi_path  ,
										@ruleid				=	wfi_rule
								from zrit_workflow_iedk_view with(nolock)            
								where wfi_ouid				= @ctxt_ouinstance            
								and wfi_status				= 'AC'          
								and wfi_component			= @component       
								and wfi_activity			= @activity    
								and wfi_path	like 'ZRIT_RSO_PATH_ADV%'
								and wfi_path	not like 'ZRIT_RSO_PATH_PAM%'
								and wfi_addl_pm				= 'RMC SO'
								and @doc_value between wfi_val_from and wfi_val_to
								and @doc_date between wfi_from_dt and wfi_to_dt  
								
						End
					End
				
 		  /* code added by Shrimalavika M against PJRMC-1253 Ends */
End
End
End
End
 /*Code Modified against CU Merging-PJRMC-1252 starts*/
if @bu /*= 'AGG'*/in (SELECT VALUE BU FROM  ZRIT_PJL_SUBCOMP_MAP (NOLOCK)  CROSS APPLY STRING_SPLIT(BU, ',')  WHERE SEQNO=3 )   
/*Code Modified against CU Merging-PJRMC-1252 Ends*/
Begin

declare @category	varchar(50),
		@component2	varchar(50)
,		@activity2	varchar(50)
if exists (
			select 'X'
			from zrit_workflow_iedk_view with(nolock)
			where wfi_component	=	'NSO'             
			and wfi_activity	=	'PPSCMQSOAMDQO1'
			and @Doc_ActivityCD	=	'PPSCMQSOAMDQO1'
			and wfi_addl_pm		=	'AMAGGItm'
			)
			Begin
			/* Code added for PJRMC-516 Begins */
					if exists (select 'X' from
								scmdb..so_order_hdr with(nolock)
								join so_order_item_dtl with(nolock)
									on sohdr_ou					=	sodtl_ou
									and sohdr_order_no			=	sodtl_order_no
								join item_var_bu_vw with(nolock)
									on item_code	=	sodtl_item_code
									and bu			=	@bu
								where sohdr_order_no					=		isnull(@transactionno,sohdr_order_no)
								and sodtl_ou							=		@ctxt_ouinstance
								and category						not	in		('100010','100016','100017','100088')/* Code changed as per FC Request */	--('100024','100032','100030','100126')
				)
				Begin
						select @Pathid		=	'ZRIT_AAMTSO_PATH_13'					
				End
				/* Code added for PJRMC-516 Ends */
			Else
			Begin
				select				@creator					=		sohdr_created_by
				,		@doc_date								=		sohdr_created_date
				--,		@doc_value								=		Amount
				,		@workflow_status						=		sohdr_workflow_status
				--,		@category								=		category
				,@component2									=		'NSO'
				,@activity2										=		'PPSCMQSOAMDQO1'
				
				 from scmdb..so_order_hdr with(nolock)
				 join so_order_item_dtl with(nolock)
					on sohdr_ou					=	sodtl_ou
					and sohdr_order_no			=	sodtl_order_no
				join item_var_bu_vw with(nolock)
				on item_code	=	sodtl_item_code 
				 join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
					on sohdr_ou					=		OUID
					and sohdr_order_no			=		DocNo
				where  Parameter				=		'PAM'
					and DocNo					=		isnull(@transactionno,DocNo)
					and OUID					=		@ctxt_ouinstance
					and category				in ('100010','100016','100017','100088')/* Code changed as per FC Request */--('100024','100032','100030','100126')--('BOULD','AGG','CRLMST','SCALP')/* Code commented and added as per the FC request */
					
				select @doc_value	=	min(Amount)
				,	@category		=	category
				from scmdb..so_order_hdr with(nolock)
				join so_order_item_dtl with(nolock)
					on sohdr_ou					=	sodtl_ou
					and sohdr_order_no			=	sodtl_order_no
				join item_var_bu_vw with(nolock)
				on item_code	=	sodtl_item_code 
				 join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
					on sohdr_ou					=		OUID
					and sohdr_order_no			=		DocNo
				where  Parameter				=		'PAM'
					and DocNo					=		isnull(@transactionno,DocNo)
					and OUID					=		@ctxt_ouinstance
					and category				in ('100010','100016','100017','100088')/* Code changed as per FC Request */--('100024','100032','100030','100126')
				group by DocNo,category
	
			select @Pathid		=	wfi_path  ,
			       @ruleid		=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)            
			where wfi_ouid		= @ctxt_ouinstance            
			and wfi_status		= 'AC'            
			and wfi_component	= @component2             
			and wfi_activity	= @activity2    
			and @category		=	wfi_addl_1
			and wfi_addl_pm		=	'AMAGGItm'
			and @doc_value between wfi_val_from and wfi_val_to
			--and @doc_date between wfi_from_dt and wfi_to_dt 
			
			End
			End
	
			if exists (
			select 'X'
			from zrit_workflow_iedk_view with(nolock)
			where wfi_component	=	'NSO'             
			and wfi_activity	=	'PPSCMQSOCRTQO1'
			and @Doc_ActivityCD	=	'PPSCMQSOCRTQO1'
			and wfi_addl_pm		<>	'AMAGGItm'
			)
			Begin
			
				If exists(
						select 'X' from scmdb..so_order_hdr with(nolock)
						join so_order_item_dtl with(nolock)
							on sohdr_ou					=	sodtl_ou
							and sohdr_order_no			=	sodtl_order_no
						join item_var_bu_vw with(nolock)
							on item_code	=	sodtl_item_code 
						join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
							on sohdr_ou					=		OUID
							and sohdr_order_no			=		DocNo
						where  Parameter				=		'PAM'
							and DocNo					=		isnull(@transactionno,DocNo)
							and OUID					=		@ctxt_ouinstance
							and category				in ('100010','100016','100017','100088')/* Code changed as per FC Request */--('100024','100032','100030','100126')
							)
					Begin

						select					@creator				=		sohdr_created_by
										,		@doc_date				=		sohdr_created_date
										--,		@doc_value				=		Amount
										,		@workflow_status		=		sohdr_workflow_status
										--,@category	=category
						from scmdb..so_order_hdr with(nolock)
						join so_order_item_dtl with(nolock)
							on sohdr_ou					=	sodtl_ou
							and sohdr_order_no			=	sodtl_order_no
						join item_var_bu_vw with(nolock)
							on item_code	=	sodtl_item_code 
						join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
							on sohdr_ou					=		OUID
							and sohdr_order_no			=		DocNo
						where  Parameter				=		'PAM'
							and DocNo					=		isnull(@transactionno,DocNo)
							and OUID					=		@ctxt_ouinstance
							and category				in ('100010','100016','100017','100088')/* Code changed as per FC Request */--('100024','100032','100030','100126')--('BOULD','AGG','CRLMST','SCALP')/* Code commented and added as per the FC request */

					select @doc_value	=	min(Amount)
					,	@category		=	category
					from scmdb..so_order_hdr with(nolock)
					join so_order_item_dtl with(nolock)
						on sohdr_ou					=	sodtl_ou
						and sohdr_order_no			=	sodtl_order_no
					join item_var_bu_vw with(nolock)
						on item_code	=	sodtl_item_code 
					join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
						on sohdr_ou					=		OUID
						and sohdr_order_no			=		DocNo
					where  Parameter				=		'PAM'
					and DocNo					=		isnull(@transactionno,DocNo)
					and OUID					=		@ctxt_ouinstance
					and category				in ('100010','100016','100017','100088')/* Code changed as per FC Request */--('100024','100032','100030','100126')
					group by DocNo ,category
					

select @Pathid		=	wfi_path  ,
       @ruleid		=	wfi_rule
from zrit_workflow_iedk_view with(nolock)            
where wfi_ouid		= @ctxt_ouinstance            
and wfi_status		= 'AC'            
and wfi_component	= @component             
and wfi_activity	= @activity    
and wfi_addl_1	=	@category
and @doc_value between wfi_val_from and wfi_val_to
and @doc_date between wfi_from_dt and wfi_to_dt  

End
/* Code added for PJRMC-516 Begins */
				Else	 if exists (select 'X' from
								scmdb..so_order_hdr with(nolock)
								join so_order_item_dtl with(nolock)
									on sohdr_ou					=	sodtl_ou
									and sohdr_order_no			=	sodtl_order_no
								join item_var_bu_vw with(nolock)
									on item_code	=	sodtl_item_code
									and bu			=	@bu
								where sohdr_order_no					=		isnull(@transactionno,sohdr_order_no)
								and sodtl_ou							=		@ctxt_ouinstance
								and category						not	in	('100010','100016','100017','100088')/* Code changed as per FC Request */--('100024','100032','100030','100126')
				)
				Begin

						select @Pathid		=	'ZRIT_ASO_PATH_13'					
				End

				/* Code added for PJRMC-516 Ends */

End

End
 /*Code Modified against CU Merging-PJRMC-1252 starts*/
if @bu /*= 'NPV' */in (SELECT VALUE BU FROM  ZRIT_PJL_SUBCOMP_MAP (NOLOCK)  CROSS APPLY STRING_SPLIT(BU, ',')  WHERE SEQNO=4 )  
/*Code Modified against CU Merging-PJRMC-1252 Ends*/
Begin
	declare @uom			varchar(50),
			@component4		varchar(50),
			@activity4		varchar(50)
			,@customer_type		varchar(60) /*Code added against PJRMC-1496  */

			select @component4	=	'NSO'
			,@activity4			=	'PPSCMQSOAMDQO1'
--------
if exists (
			select 'X'
			from zrit_workflow_iedk_view with(nolock)
			where wfi_component	= 'NSO'             
			and wfi_activity	= 'PPSCMQSOAMDQO1'
			and @Doc_ActivityCD	=	'PPSCMQSOAMDQO1'
			and wfi_addl_pm		like	'NPVAmd%'
			)
			Begin 			
				select	@creator				=		sohdr_created_by
				,		@doc_date				=		sohdr_created_date
				--,		@doc_value				=		Amount
				,		@workflow_status		=		sohdr_workflow_status
				,		@billtocust				=		sohdr_order_from_cust
				,		@uom					=		sodtl_uom
				,@component4					=		'NSO'
				,@activity4						=		'PPSCMQSOAMDQO1'
				 from scmdb..so_order_hdr with(nolock)
				 join so_order_item_dtl with(nolock)
					on sohdr_ou					=	sodtl_ou
					and	sohdr_order_no			=	sodtl_order_no
				 join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
					on sohdr_ou					=		OUID
					and sohdr_order_no			=		DocNo
				where  Parameter				=		'PAM'
					and DocNo					=		isnull(@transactionno,DocNo)
					and OUID					=		@ctxt_ouinstance

				select @doc_value				=	min(Amount)
					from scmdb..so_order_hdr with(nolock)
				 join so_order_item_dtl with(nolock)
					on sohdr_ou					=	sodtl_ou
					and	sohdr_order_no			=	sodtl_order_no
				 join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
					on sohdr_ou					=		OUID
					and sohdr_order_no			=		DocNo
				where  Parameter				=		'PAM'
					and DocNo					=		isnull(@transactionno,DocNo)
					and OUID					=		@ctxt_ouinstance
					group by DocNo

				/*Code added against PJRMC-1496 Begins */
					select	@customer_type				=	clo_noc
				from so_order_hdr with(nolock)
				join cust_lo_info with(nolock)
					on sohdr_order_from_cust	=	clo_cust_code
					and  clo_cust_code			=	@billtocust
				where  sohdr_order_no			=	isnull(@transactionno,sohdr_order_no)
				and		sohdr_ou				=	@ctxt_ouinstance
				/*Code added against PJRMC-1496 Ends */

declare @dayys4 int 
declare @credituser4 varchar(50) 
select @dayys4= max(datediff(d,duedate,getdate()))  from ci_drdoc_vw(nolock) 
where  language_id=1
and custcode=@billtocust
and datediff(d,duedate,getdate())>0
--select round(@doc_value,1)	'@doc_value'
/*Code added against PJRMC-1496 Begins */
If @customer_type	=	'IT'
Begin
	select		@Pathid					=	wfi_path  ,
				@ruleid					=	wfi_rule
	from zrit_workflow_iedk_view with(nolock)         
	where wfi_ouid						=	@ctxt_ouinstance            
	and wfi_status						=	'AC'            
	and wfi_component					=	@component4             
	and wfi_activity					=	@activity4    
	and wfi_addl_1						=	@uom	
	and wfi_path						like 'ZRIT_NPVAMTSO_PATH_PAM%'
	and @doc_value						between wfi_val_from and wfi_val_to
	and @doc_date						between wfi_from_dt and wfi_to_dt  

End

If @customer_type	=	'ET'
Begin/*Code added against PJRMC-1496 Ends */
if @dayys4 >90
Begin

		select @credituser4	=	WFuser from scmdb..zrit_workflow_iedk_view with(nolock)
		where  wfi_ouid = @ctxt_ouinstance            
		and wfi_status = 'AC'            
		and wfi_path='ZRIT_NPVAMTSO_PATH_CREDIT_6'
		and WFLevel='auth'
		and @dayys4 between wfi_addl_1 and 	wfi_addl_2
END
if @credituser4 is not null
Begin
	select @Pathid				=	wfi_path  ,
	       @ruleid				=	wfi_rule
	from zrit_workflow_iedk_view with(nolock)            
	where wfi_ouid				= @ctxt_ouinstance            
	and wfi_status				= 'AC'            
	and wfi_component			= @component4             
	and wfi_activity			= @activity4    
	and wfi_addl_1				= @uom		
	and wfi_path				like 'ZRIT_NPVAMTSO_PATH_CREDIT%'
	and @doc_value				between wfi_val_from and wfi_val_to
	and @doc_date				between wfi_from_dt and wfi_to_dt  
	
End
else
begin

		select  @Pathid					=	wfi_path  ,
				@ruleid					=	wfi_rule
	from zrit_workflow_iedk_view with(nolock)         
	where wfi_ouid						=	@ctxt_ouinstance            
	and wfi_status						=	'AC'            
	and wfi_component					=	@component4             
	and wfi_activity					=	@activity4    
	and wfi_addl_1						=	@uom	
	and wfi_path						like 'ZRIT_NPVAMTSO_PATH_PAM%'
	and @doc_value						between wfi_val_from and wfi_val_to
	and @doc_date						between wfi_from_dt and wfi_to_dt  
End
End
/* code added for PJRMC-516 Begins */
If not Exists (
				 Select 'X'	
				 from scmdb..so_order_hdr with(nolock)
				 join so_order_item_dtl with(nolock)
				 on		sohdr_ou				=	sodtl_ou
				 and	sohdr_order_no			=	sodtl_order_no
				 join  zrit_workflow_iedk_view with(nolock)
				 on		wfi_addl_1				=	sodtl_uom
				 and	wfi_component			=	@component4
				 and 	wfi_activity			=	@activity4
				 and	@Doc_ActivityCD			=	'PPSCMQSOAMDQO1'
				 and	wfi_addl_1				=	@uom
				 where  sohdr_order_no			=	isnull(@transactionno,sohdr_order_no)
					and sohdr_ou				=	@ctxt_ouinstance
				 )
				 Begin
				 if @credituser4	is not null
				 Begin
						select @Pathid	=	'ZRIT_NPVAMTSO_PATH_CREDIT_7'
				 End
				 Else
				 Begin
						select @Pathid	=	'ZRIT_NPVAMTSO_PATH_PAM_6'
				 End
				 End
				 /* code added for PJRMC-516 Ends */
End
Else if exists (
			select 'X'
			from zrit_workflow_iedk_view with(nolock)
			where wfi_component	= 'NSO'             
			and wfi_activity	= 'PPSCMQSOCRTQO1'
			and @Doc_ActivityCD	=	'PPSCMQSOCRTQO1'
			and wfi_addl_pm		not like	'NPVAmd%'
			)
Begin

	select				@creator				=		sohdr_created_by
				,		@doc_date				=		sohdr_created_date
			--	,		@doc_value				=		min(Amount)
				,		@workflow_status		=		sohdr_workflow_status
				,		@billtocust				=		sohdr_order_from_cust
				,		@uom					=		sodtl_uom
				 from scmdb..so_order_hdr with(nolock)
				 join so_order_item_dtl with(nolock)
				 on sohdr_ou					=	sodtl_ou
				 and	sohdr_order_no			=	sodtl_order_no
				 join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
					on sohdr_ou					=		OUID
					and sohdr_order_no			=		DocNo
				where  Parameter				=		'PAM'
					and DocNo					=		isnull(@transactionno,DocNo)
					and OUID					=		@ctxt_ouinstance
			--	Group by DocNo,sohdr_created_by,sohdr_created_date,sohdr_workflow_status,sohdr_order_from_cust,sodtl_uom

			select @doc_value	=	min(Amount)
			from scmdb..so_order_hdr with(nolock)
				 join so_order_item_dtl with(nolock)
				 on sohdr_ou					=	sodtl_ou
				 and	sohdr_order_no			=	sodtl_order_no
				 join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
					on sohdr_ou					=		OUID
					and sohdr_order_no			=		DocNo
				where  Parameter				=		'PAM'
					and DocNo					=		isnull(@transactionno,DocNo)
					and OUID					=		@ctxt_ouinstance
				Group by DocNo

				/*Code added against PJRMC-1496 Begins */
					select	@customer_type				=	clo_noc
				from so_order_hdr with(nolock)
				join cust_lo_info with(nolock)
					on sohdr_order_from_cust	=	clo_cust_code
					and  clo_cust_code			=	@billtocust
				where  sohdr_order_no			=	isnull(@transactionno,sohdr_order_no)
				and		sohdr_ou				=	@ctxt_ouinstance
				/*Code added against PJRMC-1496 Ends */


declare @dayys1 int 
declare @credituser1 varchar(50) 
select @dayys1= max(datediff(d,duedate,getdate()))  from ci_drdoc_vw(nolock) 
where  language_id=1
and custcode=@billtocust
and datediff(d,duedate,getdate())>0
/*Code added against PJRMC-1496 Begins */
If @customer_type	=		'IT'
Begin
select @Pathid					=	wfi_path  ,
	       @ruleid					=	wfi_rule
	from zrit_workflow_iedk_view with(nolock)       
	where wfi_ouid					=	@ctxt_ouinstance   
	and wfi_status					=	'AC'            
	and wfi_component				=	@component             
	and wfi_activity				=	@activity    
	and wfi_addl_1					=		@uom	
	and wfi_path					like 'ZRIT_NPVSO_PATH_PAM%'
	and @doc_value					between wfi_val_from and wfi_val_to
	and @doc_date					between wfi_from_dt and wfi_to_dt  
End
If @customer_type	=			'ET'
Begin/*Code added against PJRMC-1496 Ends */
if @dayys1 >90 
Begin

IF @workflow_status='FRESH'  or @workflow_status is null or isnull(@workflow_status,'')=''
BEGIN
	select @credituser1	=	WFuser from scmdb..zrit_workflow_iedk_view with(nolock)
		where  wfi_ouid = @ctxt_ouinstance            
		and wfi_status = 'AC'            
		and wfi_path='ZRIT_NPVSO_PATH_CREDIT_6'
		and WFLevel='auth'
		and @dayys1 between wfi_addl_1 and 	wfi_addl_2

End
if @credituser1 is not null
Begin

	select @Pathid				=	wfi_path  ,
	       @ruleid				=	wfi_rule
	from zrit_workflow_iedk_view with(nolock)            
	where wfi_ouid				= @ctxt_ouinstance            
	and wfi_status				= 'AC'            
	and wfi_component			= @component             
	and wfi_activity			= @activity    
	and wfi_addl_1				= @uom		
	and wfi_path				like 'ZRIT_NPVSO_PATH_CREDIT%'
	and @doc_value				between wfi_val_from and wfi_val_to
	and @doc_date				between wfi_from_dt and wfi_to_dt  	
End
End
else
begin
		select @Pathid					=	wfi_path  ,
	       @ruleid					=	wfi_rule
	from zrit_workflow_iedk_view with(nolock)       
	where wfi_ouid					=	@ctxt_ouinstance   
	and wfi_status					=	'AC'            
	and wfi_component				=	@component             
	and wfi_activity				=	@activity    
	and wfi_addl_1					=		@uom	
	and wfi_path					like 'ZRIT_NPVSO_PATH_PAM%'
	and @doc_value					between wfi_val_from and wfi_val_to
	and @doc_date					between wfi_from_dt and wfi_to_dt  

End
If not Exists (
				 Select 'X'	
				 from scmdb..so_order_hdr with(nolock)
				 join so_order_item_dtl with(nolock)
				 on		sohdr_ou				=	sodtl_ou
				 and	sohdr_order_no			=	sodtl_order_no
				 join  zrit_workflow_iedk_view with(nolock)
				 on		wfi_addl_1				=	sodtl_uom
				 and	wfi_component			=	@component
				 and 	wfi_activity			=	@activity
				 and	wfi_addl_1				=	@uom
				 where  sohdr_order_no			=		isnull(@transactionno,sohdr_order_no)
				and sohdr_ou					=		@ctxt_ouinstance
				 )
				 Begin
				 if @credituser1	is not null
				 Begin
						select @Pathid	=	'ZRIT_NPVSO_PATH_CREDIT_7'
				 End
				 Else
				 Begin
						select @Pathid	=	'ZRIT_NPVSO_PATH_PAM_6'
				 End
				 End

End
End/*Code added against PJRMC-1496 Ends */	
End
 /*Code Modified against CU Merging-PJRMC-1252 starts*/
If @bu /*= 'CCB'  */in (SELECT VALUE BU FROM  ZRIT_PJL_SUBCOMP_MAP (NOLOCK)  CROSS APPLY STRING_SPLIT(BU, ',')  WHERE SEQNO=2 ) 
/*Code Modified against CU Merging-PJRMC-1252 Ends*/
Begin

declare @Receip_code	varchar(60),
@productype				varchar(60),
@Grade					varchar(30),
@type					varchar(30),
@cust_type				varchar(30),
@selling_rate			numeric(28,2),
@total					numeric(28,2),
@custtype				varchar(20)

	select @Receip_code	=	ReceipeCode
	from scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
	where  DocNo	 =  isnull(@transactionno,DocNo)
	and		OUID	 =	@ctxt_ouinstance
	and Amount	=	(select min(Amount)
					from scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
					where  DocNo	 =  isnull(@transactionno,DocNo)
					and		OUID	 =	@ctxt_ouinstance
					)

	select @productype			=	Product_type
	,@Grade						=	Grade	
	from Zrit_Formula_Model_tl with(nolock)
	where Formula_No			=	@Receip_code
	and		OU					=	@ctxt_ouinstance

declare 
@component3	varchar(50)
,@activity3	varchar(50)

	if exists (select 'X'
				from Zrit_Formula_Model_tl with(nolock)
				where
				Product_type		=	'AD'
				and
				OU					=	@ctxt_ouinstance
				and  Formula_No			=	@Receip_code
				)
				Begin
					select	@type						=	/*concat(paramdesc,@Grade)*/concat(paramcode,@Grade)
					from Zrit_Formula_Model_tl with(nolock)
					join component_metadata_table with(nolock)  
					on Product_type				=	paramcode
						and componentname		=	'MFMX'  
						and paramcategory		=	'COMBO'  
						and paramtype			=	'ProductType' 
						and optionvalue			=	'CCB'
						and	sequenceno			in (1,2,3)
					where Formula_No			=	@Receip_code
					and		OU					=	@ctxt_ouinstance
					and		sequenceno			in (1,2,3)
				End

	If @productype	in ('CG','WR')
	Begin
		select @type	= paramdesc
		from Zrit_Formula_Model_tl with(nolock)
		join component_metadata_table with(nolock)  
			on Product_type				=	paramcode
			and componentname		=	'MFMX'  
			and paramcategory		=	'COMBO'  
			and paramtype			=	'ProductType' 
			and optionvalue			=	'CCB'
			and		sequenceno			in (1,2,3)
	where Formula_No			=	@Receip_code
	and		OU					=	@ctxt_ouinstance
	End

	select	@cust_type=clo_noc--paramdesc--	ctds_tax_option
	from so_order_hdr with(nolock)
	join cust_lo_info with(nolock)
	on sohdr_order_from_cust	=	clo_cust_code
	and  clo_cust_code	=	@customercode
	where  sohdr_order_no	= isnull(@transactionno,sohdr_order_no)
	and		sohdr_ou		=	@ctxt_ouinstance

	if exists (
			select 'X'
			from zrit_workflow_iedk_view with(nolock)
			where wfi_component	= 'NSO'  
			and wfi_activity	= 'PPSCMQSOAMDQO1'
			and wfi_addl_pm		like	'CCBAmd%'
			and @Doc_ActivityCD	=	'PPSCMQSOAMDQO1'
			)
			Begin
				select	@creator			=	Create_By
				,		@doc_date			=	Create_date
				--,		@doc_value			=   min(Amount)
				,	@billtocust				=		sohdr_order_from_cust
				,@component3				=	'NSO'
				,@activity3					=	'PPSCMQSOAMDQO1'
				 from scmdb..so_order_hdr with(nolock)
				 join so_order_item_dtl with(nolock)
				 on sohdr_ou					=	sodtl_ou
				 and	sohdr_order_no			=	sodtl_order_no
				 join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
					on sohdr_ou					=		OUID
					and sohdr_order_no			=		DocNo
				where  Parameter				=		'Contribution Margin'--'PAM'/* parameter changed as per the FC request for CCB BU */
					and DocNo					=		isnull(@transactionno,DocNo)
					and OUID					=		@ctxt_ouinstance
				 and ReceipeCode is not null
				 group by DocNo,Create_By,Create_date,sohdr_order_from_cust

				 select @selling_rate	=	isnull(min(amount),0)
				 from scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
				 where  DocNo			=	isnull(@transactionno,DocNo)
				 and	OUID			=	@ctxt_ouinstance
				 and	parameter		=	'SELLING RATE'
				 group by DocNo

				 select @doc_value			=   min(Amount)
				 from scmdb..so_order_hdr with(nolock)
				 join so_order_item_dtl with(nolock)
				 on sohdr_ou					=	sodtl_ou
				 and	sohdr_order_no			=	sodtl_order_no
				 join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
					on sohdr_ou					=		OUID
					and sohdr_order_no			=		DocNo
				where  Parameter				=		'Contribution Margin'--'PAM'/* parameter changed as per the FC request for CCB BU */
					and DocNo					=		isnull(@transactionno,DocNo)
					and OUID					=		@ctxt_ouinstance
				 and ReceipeCode is not null
				 group by DocNo,OUID

				 select	@total			= 	 isnull((@doc_value/nullif(@selling_rate,0)),0)*100

declare @dayys3 int 
declare @credituser3 varchar(50) 
select @dayys3			=	max(datediff(d,duedate,getdate()))  from ci_drdoc_vw(nolock) 
where   language_id		=	1
and		custcode		=	@billtocust
and datediff(d,duedate,getdate())>0	
/*code added against PJRMC-1468 Begins */
If @cust_type	=	'IT'
Begin
		if @productype	in ('CG','WR')
Begin

select @Pathid	=	wfi_path	,
					@ruleid	=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)
			where  wfi_ouid = @ctxt_ouinstance            
			and wfi_status = 'AC'            
			and wfi_component = @component3           
			and wfi_activity = @activity3  
			and wfi_path like 'ZRIT_CAMTSO_PATH_PAM%'
			and @total between wfi_val_from and wfi_val_to
			--and @doc_date between wfi_from_dt and wfi_to_dt  
			and wfi_addl_1	=	@type
			--and wfi_addl_2	=	@cust_type

End

Else
Begin
select				@Pathid	=	wfi_path	,
					@ruleid	=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)
			where  wfi_ouid = @ctxt_ouinstance     
			and wfi_status = 'AC'        
			and wfi_component = @component3             
			and wfi_activity = @activity3  
			and wfi_path like 'ZRIT_CAMTSO_PATH_PAM%'
			and @total between wfi_val_from and wfi_val_to
			--and @doc_date between wfi_from_dt and wfi_to_dt  
			and wfi_addl_1	=	@type
			and wfi_addl_2	=	@cust_type
End
End

If @cust_type	=	'ET'
Begin
/*code added against PJRMC-1468 Ends */
if @dayys3 > 90
Begin
IF @workflow_status='FRESH'  or @workflow_status is null  or isnull(@workflow_status,'')=''
BEGIN
		select @credituser3=WFuser from scmdb..zrit_workflow_iedk_view with(nolock)
		where  wfi_ouid = @ctxt_ouinstance         
		and wfi_status = 'AC'   
		and wfi_path='ZRIT_CAMTSO_PATH_CREDIT_11'
		and WFLevel='auth'
		and @dayys3 between wfi_addl_1 and 	wfi_addl_2
END
End

if @credituser3 is not null
Begin
if @productype	in ('CG','WR')
Begin
select @Pathid	=	wfi_path	,
					@ruleid	=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)
			where  wfi_ouid = @ctxt_ouinstance            
			and wfi_status = 'AC'            
			and wfi_component = @component3          
			and wfi_activity = @activity3  
			and wfi_path like 'ZRIT_CAMTSO_PATH_CREDIT%'
			and @total between wfi_val_from and wfi_val_to
			--and @doc_date between wfi_from_dt and wfi_to_dt  
			and wfi_addl_1	=	@type
End
Else
Begin
			select @Pathid	=	wfi_path	,
					@ruleid	=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)
			where  wfi_ouid = @ctxt_ouinstance            
			and wfi_status = 'AC'   
			and wfi_component = @component3            
			and wfi_activity = @activity3
			and wfi_path like 'ZRIT_CAMTSO_PATH_CREDIT%'
			and @total between wfi_val_from and wfi_val_to
			and @doc_date between wfi_from_dt and wfi_to_dt  
			and wfi_addl_1	=@type
			and wfi_addl_2	=	@cust_type


End
End
Else if  @credituser3 is  null
Begin
if @productype	in ('CG','WR')
Begin
select				@Pathid	=	wfi_path	,
					@ruleid	=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)
			where  wfi_ouid = @ctxt_ouinstance            
			and wfi_status = 'AC'            
			and wfi_component = @component3             
			and wfi_activity = @activity3  
			and wfi_path like 'ZRIT_CAMTSO_PATH_PAM%'
			and @total between wfi_val_from and wfi_val_to
			--and @doc_date between wfi_from_dt and wfi_to_dt  
			and wfi_addl_1	=	@type
			--and wfi_addl_2	=	@cust_type
End
Else
Begin
select @Pathid	=	wfi_path	,
					@ruleid	=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)
			where  wfi_ouid = @ctxt_ouinstance            
			and wfi_status = 'AC'            
			and wfi_component = @component3             
			and wfi_activity = @activity3  
			and wfi_path like 'ZRIT_CAMTSO_PATH_PAM%'
			and @total between wfi_val_from and wfi_val_to
			--and @doc_date between wfi_from_dt and wfi_to_dt  
			and wfi_addl_1	=@type
			and wfi_addl_2	=	@cust_type
End

End
End /* code added against PJRMC-1468 */
If Exists
	(	
		select 'X' from Zrit_Formula_Model_tl with(nolock)
		join component_metadata_table with(nolock)  
			on Product_type			=	paramcode
			and componentname		=	'MFMX'  
			and paramcategory		=	'COMBO'  
			and paramtype			=	'ProductType' 
			and optionvalue			=	'CCB'
			and		sequenceno		not	in (1,2,3)
	where Formula_No			=	@Receip_code
	and		OU					=	@ctxt_ouinstance

	)
Begin 
	if @credituser3 is not null
	Begin
		select @Pathid	=	'ZRIT_CAMTSO_PATH_CREDIT_12'
	End
	Else
	Begin
		select @Pathid	=	'ZRIT_CAMTSO_PATH_PAM_11'
	End

End
/* Code added aganist PJRMC-712 Begins */
If Exists(select 'X'	from 
			so_order_hdr with(nolock)
			where sohdr_ou				=	@ctxt_ouinstance
			and sohdr_order_no			=	@transactionno
			AND sohdr_sale_type_dflt	in('TRADE','SERV','SAMP','SCRAP','EXP')	
			)
			Begin
				select @Pathid	=	'ZRIT_CAMTSO_PATH_PAM_11'

				End
/* Code added aganist PJRMC-712 Ends  */
End
		Else
		
				Begin
				select	@creator		=	sohdr_created_by--Create_By
				,		@doc_date		=	cast(sohdr_created_date as date)--Create_date
				--,		@doc_value		=   min(Amount)
				,	@billtocust			=		sohdr_order_from_cust
				 from scmdb..so_order_hdr with(nolock)
				 join so_order_item_dtl with(nolock)
				 on sohdr_ou					=	sodtl_ou
				 and	sohdr_order_no			=	sodtl_order_no
				 join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
					on sohdr_ou					=		OUID
					and sohdr_order_no			=		DocNo
				where  Parameter				=		'Contribution Margin'--'PAM'/* parameter changed as per the FC request for CCB BU */
					and DocNo					=		isnull(@transactionno,DocNo)
					and OUID					=		@ctxt_ouinstance
				 and ReceipeCode is not null
				-- group by DocNo,sohdr_created_by,sohdr_created_date,sohdr_order_from_cust

				 select @selling_rate	=	isnull(min(amount),0)
				 from scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
				 where  DocNo			=	isnull(@transactionno,DocNo)
				 and	OUID			=	@ctxt_ouinstance
				 and	parameter		=	'SELLING RATE'
				 group by DocNo

				 select @doc_value		=   min(Amount)
				 from scmdb..so_order_hdr with(nolock)
				 join so_order_item_dtl with(nolock)
				 on sohdr_ou					=	sodtl_ou
				 and	sohdr_order_no			=	sodtl_order_no
				 join scmdb..ZRIT_QUOTATION_PAM_DETAIL with(nolock)
					on sohdr_ou					=		OUID
					and sohdr_order_no			=		DocNo
				where  Parameter				=		'Contribution Margin'--'PAM'/* parameter changed as per the FC request for CCB BU */
					and DocNo					=		isnull(@transactionno,DocNo)
					and OUID					=		@ctxt_ouinstance
				 and ReceipeCode is not null
				 group by DocNo,OUID

				 select	@total			= 	 isnull((@doc_value/nullif(@selling_rate,0)),0)*100

declare @dayys2 int 
declare @credituser2 varchar(50) 
select @dayys2			=	max(datediff(d,duedate,getdate()))  from ci_drdoc_vw(nolock) 
where   language_id		=	1
and		custcode		=	@billtocust
and datediff(d,duedate,getdate())>0	
/*code added against PJRMC-1468 Begins */
If @cust_type	=	'IT'
Begin
		if @productype	in ('CG','WR')
Begin

select @Pathid	=	wfi_path	,
					@ruleid	=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)
			where  wfi_ouid = @ctxt_ouinstance            
			and wfi_status = 'AC'            
			and wfi_component = @component             
			and wfi_activity = @activity  
			and wfi_path like 'ZRIT_CSO_PATH_PAM%'
			and @total between wfi_val_from and wfi_val_to
			--and @doc_date between wfi_from_dt and wfi_to_dt  
			and wfi_addl_1	=	@type
			--and wfi_addl_2	=	@cust_type

End

Else
Begin

select				@Pathid	=	wfi_path	,
					@ruleid	=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)
			where  wfi_ouid = @ctxt_ouinstance     
			and wfi_status = 'AC'            
			and wfi_component = @component             
			and wfi_activity = @activity  
			and wfi_path like 'ZRIT_CSO_PATH_PAM%'
			and @total between wfi_val_from and wfi_val_to
			--and @doc_date between wfi_from_dt and wfi_to_dt  
			and wfi_addl_1	=@type
			and wfi_addl_2	=	@cust_type
End
End

If @cust_type	=	'ET'
Begin
/*code added against PJRMC-1468 Ends */
if @dayys2 >90
Begin
IF @workflow_status='FRESH'  or @workflow_status is null  or isnull(@workflow_status,'')=''
BEGIN
		select @credituser2=WFuser from scmdb..zrit_workflow_iedk_view with(nolock)
		where  wfi_ouid = @ctxt_ouinstance            
		and wfi_status = 'AC'            
		and wfi_path='ZRIT_CSO_PATH_CREDIT_11'
		and WFLevel='auth'
		and @dayys2 between wfi_addl_1 and 	wfi_addl_2
END
End

if @credituser2 is not null
Begin
	if @productype	in ('CG','WR')
		Begin
			select  @Pathid	=	wfi_path	,
					@ruleid	=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)
			where  wfi_ouid = @ctxt_ouinstance 
			and wfi_status = 'AC'            
			and wfi_component = @component             
			and wfi_activity = @activity  
			and wfi_path like 'ZRIT_CSO_PATH_CREDIT%'
			and @total between wfi_val_from and wfi_val_to
			--and @doc_date between wfi_from_dt and wfi_to_dt  
			and wfi_addl_1	=	@type
End
Else
Begin

			select  @Pathid	=	wfi_path	,
					@ruleid	=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)
			where  wfi_ouid = @ctxt_ouinstance      
			and wfi_status = 'AC'            
			and wfi_component = @component             
			and wfi_activity = @activity  
			--and wfi_path like 'ZRIT_CSO_PATH_CREDIT%'
			and @total between wfi_val_from and wfi_val_to
			--and @doc_date between wfi_from_dt and wfi_to_dt  
			and wfi_addl_1	=@type
			and wfi_addl_2	=	@cust_type


End
End
Else if  @credituser2 is  null
Begin

if @productype	in ('CG','WR')
Begin

select @Pathid	=	wfi_path	,
					@ruleid	=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)
			where  wfi_ouid = @ctxt_ouinstance            
			and wfi_status = 'AC'            
			and wfi_component = @component             
			and wfi_activity = @activity  
			and wfi_path like 'ZRIT_CSO_PATH_PAM%'
			and @total between wfi_val_from and wfi_val_to
			--and @doc_date between wfi_from_dt and wfi_to_dt  
			and wfi_addl_1	=	@type
			--and wfi_addl_2	=	@cust_type

End

Else
Begin

select				@Pathid	=	wfi_path	,
					@ruleid	=	wfi_rule
			from zrit_workflow_iedk_view with(nolock)
			where  wfi_ouid = @ctxt_ouinstance     
			and wfi_status = 'AC'            
			and wfi_component = @component             
			and wfi_activity = @activity  
			and wfi_path like 'ZRIT_CSO_PATH_PAM%'
			and @total between wfi_val_from and wfi_val_to
			--and @doc_date between wfi_from_dt and wfi_to_dt  
			and wfi_addl_1	=@type
			and wfi_addl_2	=	@cust_type
End
End		
End/*code added against PJRMC-1468 Ends */
 If Exists
	(	
		select 'X' from Zrit_Formula_Model_tl with(nolock)
		join component_metadata_table with(nolock)  
			on Product_type			=	paramcode
			and componentname		=	'MFMX'  
			and paramcategory		=	'COMBO'  
			and paramtype			=	'ProductType' 
			and optionvalue			=	'CCB'
			and		sequenceno		not	in (1,2,3)
	where Formula_No			=	@Receip_code
	and		OU					=	@ctxt_ouinstance

	)
Begin 
	if @credituser2 is not null
	Begin
		select @Pathid	=	'ZRIT_CSO_PATH_CREDIT_12'
	End
	Else
	Begin
		select @Pathid	=	'ZRIT_CSO_PATH_PAM_11'
	End

End
/* Code added aganist PJRMC-712 Begins */
If Exists(select 'X'	from 
			so_order_hdr with(nolock)
			where sohdr_ou				=	@ctxt_ouinstance
			and sohdr_order_no			=	@transactionno
			AND sohdr_sale_type_dflt	in('TRADE','SERV','SAMP','SCRAP','EXP')	
			)
			Begin
				select @Pathid	=	'ZRIT_CSO_PATH_PAM_11'
				End
/* Code added aganist PJRMC-712 Ends */
End
End
END

/* Ends - Code added  against rTrack ID : CU Merging-PJRMC-1252*/

	/* code added for 14H109_NSO_00014 ends*/
	select	 '~#~'						'DOC_ACTION_COMBO_VAL',
	rtrim(@doc_activitycd)				'DOC_ACTIVITYCD',      
	--NSOSO								'DOC_AREA_CODE' --Code commented for EPE-60232
	case when @trantype = 'SAL_CON' then 'NSOCO' Else 'NSOSO'end		'DOC_AREA_CODE',	--Code added for EPE-60232
	--rtrim(@doc_auth_flag)				'DOC_AUTH_FLAG',	--Code commented for EPE-60232
	case when @trantype = 'SAL_CON' then @docauthflag_tmp else rtrim(@doc_auth_flag)end				'DOC_AUTH_FLAG',	--Code added for EPE-60232
	isnull(@Pathid,@con_pathid)			'DOC_CHAR_DUMMY_1',	/* Begins - Code added  against rTrack ID : CU Merging-PJRMC-1252*/
	'~#~'								'DOC_CHAR_DUMMY_2',
	'NSO'								'DOC_COMPONENTCD',
	case when @trantype = 'SAL_CON' then @tran_wf_status
	else rtrim(@workflow_status)				end 'DOC_CURRENT_STATE',	--Code added for EPE-60232
/* Code modified for ITS Id. : ES_NSO_00698 Begins */
	--convert(nvarchar(10),@order_date,120)	'DOC_DATE',
	convert(nvarchar(10),@sysdate,120)	'DOC_DATE',
/* Code modified for ITS Id. : ES_NSO_00698 Ends */
	-915  								'DOC_FLOAT_DUMMY_1',
	-915  								'DOC_FLOAT_DUMMY_2',
	--@guid								'DOC_GUID',		--Code commented for EPE-60232
	case when @trantype = 'SAL_CON' then @tmpguid else @guid end 'DOC_GUID',	--Code added for EPE-60232
	rtrim(@doc_key)						'DOC_KEY',
	rtrim(upper(@doc_newst_todo_user))	'DOC_NEWST_TODO_USER',
	@doc_newst_todo_user_ou				'DOC_NEWST_TODO_USER_OU',	
	@ctxt_ouinstance					'DOC_ORGUNITID',
	rtrim(@doc_parameter)				'DOC_PARAMETER',
	rtrim(@doc_taskcd)					'DOC_TASKCD',	
	--rtrim(@transactionno)				'DOC_UNIQUE_ID',	--Code Commented for EPE-60232
	case when @trantype = 'SAL_CON' then @doc_unique_id else rtrim(@transactionno) end 'DOC_UNIQUE_ID',	--Code added for 60232
	@ctxt_ouinstance					'LOG_ORGUNITID',
	rtrim(@ctxt_role)					'LOG_ROLE',
	rtrim(upper(@ctxt_user))			'LOG_USER',
	@wf_ou								'WF_CONTEXT_OU'
	--Added for DTS ID: ES_NSO_00206 ends here

/*code commented for DTS ID: DMS412AT_NSO_00048 starts here
/* Code modified by Raju against NSODms412at_000412 starts*/
	if @calling_service like 'SOPP_%'
	begin
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in ('SOPP_CRMN_SER_SBT','NSOSER042','SOPP_CRSCH_SER_SBT') -- this will be called from 'CREATE SO' 
		if @calling_service in ('SOPP_CRMN_SER_SBT','NSOSER042','SOPP_CRSCH_SER_SBT','SOPP_CRMN_SER_SBT1','NSOSER0421','SOPP_CRSCH_SER_SBT1') -- this will be called from 'CREATE SO' 
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin  
	/*code modified for DTS ID: DMS412AT_NSO_00048 starts here*/ 
			select 	@doc_taskcd 	= 'NSOADDSOSBT2',
				@doc_activitycd	= 'NSOADDSO'

--			select 	@doc_taskcd 	= 'PPSCMQSOCRTQOTTRN5',  
--				@doc_activitycd	= 'PPSCMQSOCRTQO'		
	/*code modified for DTS ID: DMS412AT_NSO_00048 ends here*/ 
	
			/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
			--if @calling_service <> 'SOPP_CRSCH_SER_SBT'
			if @calling_service <> 'SOPP_CRSCH_SER_SBT' or @calling_service <> 'SOPP_CRSCH_SER_SBT1'
			/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
			begin
				if	@crt_on_auth_flag = 'Y' or @old_status = 'FR'--Modified for DTS ID: DMS412AT_NSO_00048
				begin
					select	@doc_auth_flag		=  	'Y',
						@doc_newst_todo_user	=	@ctxt_user,
						@doc_newst_todo_user_ou	=	@ctxt_ouinstance
				end		
		
				select	@transactionno	=	sohdr_order_no
				from	sotmp_order_hdr (nolock)
				where	sohdr_guid	=	@guid
			end
		end  
	
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in('SOPP_CRMN_SER_EDT') -- this will be called from 'EDIT SO '
		if @calling_service in('SOPP_CRMN_SER_EDT','SOPP_CRMN_SER_EDT1') -- this will be called from 'EDIT SO '
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin  
			select 	@doc_taskcd 	= 'PPSCMQSOCRTQOTTRN6',
				@doc_activitycd	= 'PPSCMQSOCRTQO'	
		end  
		
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in ( 'SOPP_CRMN_SER_CRAU')  -- this will be called from 'AUTHORIZE SO '
		if @calling_service in ( 'SOPP_CRMN_SER_CRAU','SOPP_CRMN_SER_CRAU1')  -- this will be called from 'AUTHORIZE SO '
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin 

--DMS412AT_NSO_00048 begins
			select 	@doc_taskcd 	= 'NSOADDSOSBT2',
				@doc_activitycd	= 'NSOADDSO'
				/*code added for DTS ID: DMS412AT_NSO_00048 starts here*/
					select	@doc_auth_flag		=  	'Y',
						@doc_newst_todo_user	=	@ctxt_user,
						@doc_newst_todo_user_ou	=	@ctxt_ouinstance
				/*code added for DTS ID: DMS412AT_NSO_00048 ends here*/

--			select 	@doc_taskcd 	= 'PPSCMQSOCRTQOTTRN5',  
--				@doc_activitycd	= 'PPSCMQSOCRTQO'		
--DMS412AT_NSO_00048 ends
		end  
	
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in ('SOPP_CRMN_SER_AUTH')
		if @calling_service in ('SOPP_CRMN_SER_AUTH','SOPP_CRMN_SER_AUTH1')
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin 
--DMS412AT_NSO_00048 begins
			select 	@doc_taskcd 	= 'NSOAUSOSBT1',  
				@doc_activitycd	= 'NSOAUSO'	
					/*code added for DTS ID: DMS412AT_NSO_00048 starts here*/	
					select	@doc_auth_flag		=  	'Y',
						@doc_newst_todo_user	=	@ctxt_user,
						@doc_newst_todo_user_ou	=	@ctxt_ouinstance
					/*code added for DTS ID: DMS412AT_NSO_00048 ends here*/

--			select 	@doc_taskcd 	= 'PPSCMQSOCRTQOTTRN7',  
--				@doc_activitycd	= 'PPSCMQSOCRTQO'		
-- DMS412AT_NSO_00048 ends
		end 
	
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in ('SOPP_AMMN_SER_AUTH')
		if @calling_service in ('SOPP_AMMN_SER_AUTH','SOPP_AMMN_SER_AUTH1')
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin 
			select 	@doc_taskcd 	= 'PPSCMQSOAMDQOTTRN2',  
				@doc_activitycd	= 'PPSCMQSOAMDQO'		
		end 

		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in ( 'SOPP_AMMN_SER_AUAM')  
		if @calling_service in ( 'SOPP_AMMN_SER_AUAM','SOPP_AMMN_SER_AUAM1')  
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin 
			select 	@doc_taskcd 	= 'PPSCMQSOAMDQOTTRN3',  
				@doc_activitycd	= 'PPSCMQSOAMDQO'		
		end 

		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service = 'SOPP_AMMN_SER_SBT'  
		if @calling_service in ('SOPP_AMMN_SER_SBT','SOPP_AMMN_SER_SBT1')
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin 
			select 	@doc_taskcd 	= 'PPSCMQSOAMDQOTTRN1',  
				@doc_activitycd	= 'PPSCMQSOAMDQO'
			
		end 
	end
	else
	begin
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in ('SO_CRMN_SER_SBT', 'SO_CRMN_SER_COPY', 'NSOSER042', 'SO_RLCRMN_SER_GENREL', 'SO_RLEDMN_SER_GENREL', 'SO_CRSCH_SER_SBT') -- this will be called from 'CREATE SO' 
		if @calling_service in ('SO_CRMN_SER_SBT', 'SO_CRMN_SER_COPY', 'NSOSER042', 'SO_RLCRMN_SER_GENREL', 'SO_RLEDMN_SER_GENREL', 'SO_CRSCH_SER_SBT','SO_CRMN_SER_SBT1', 'SO_CRMN_SER_COPY1', 'NSOSER0421', 'SO_RLCRMN_SER_GENREL1', 'SO_RLEDMN_SER_GENREL1', 'SO_



























































CRSCH_SER_SBT1') -- this will be called from 'CREATE SO' 
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin  
			select 	@doc_taskcd 	= 'NSOADDSOSBT2',
				@doc_activitycd	= 'NSOADDSO'
	
			/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
			--if @calling_service <> 'SO_CRSCH_SER_SBT'
			if @calling_service <> 'SO_CRSCH_SER_SBT' or @calling_service <> 'SO_CRSCH_SER_SBT1'
			/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
			begin
				if	@crt_on_auth_flag = 'Y'
				begin
					select	@doc_auth_flag		=  	'Y',
						@doc_newst_todo_user	=	@ctxt_user,
						@doc_newst_todo_user_ou	=	@ctxt_ouinstance
				end		
		
				select	@transactionno	=	sohdr_order_no
				from	sotmp_order_hdr (nolock)
				where	sohdr_guid	=	@guid
			end
		end  
	
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service = 'SO_CRREF_SER_SBT' -- this will be called from 'CREATE REFERENCE SO' 
		if @calling_service in ('SO_CRREF_SER_SBT','SO_CRREF_SER_SBT1') -- this will be called from 'CREATE REFERENCE SO' 
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin  
			select 	@doc_taskcd 	= 'NSOADDREFSBT1',
				@doc_activitycd	= 'NSOADDREF'
	
			if @crt_on_auth_flag = 'Y'
			begin
				select	@doc_auth_flag		=  	'Y',
					@doc_newst_todo_user	=	@ctxt_user,
					@doc_newst_todo_user_ou	=	@ctxt_ouinstance
			end	
	
			select	@transactionno	=	sohdr_order_no
			from	sotmp_order_hdr (nolock)
			where	sohdr_guid	=	@guid		
		end  
	
	
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in('SO_EDMN_SER_SBT','SO_AUMN_SER_SAV') -- this will be called from 'EDIT SO '
		if @calling_service in('SO_EDMN_SER_SBT','SO_AUMN_SER_SAV','SO_EDMN_SER_SBT1','SO_AUMN_SER_SAV1') -- this will be called from 'EDIT SO '
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin  
			select 	@doc_taskcd 	= 'NSOMNTSOSBT1',
				@doc_activitycd	= 'NSOMNTSO'	
		end  
	
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in ('SO_AUMN_SER_SBT', 'SO_AUEN_SER_SBT')  -- this will be called from 'AUTHORIZE SO '
		if @calling_service in ('SO_AUMN_SER_SBT', 'SO_AUEN_SER_SBT','SO_AUMN_SER_SBT1', 'SO_AUEN_SER_SBT1')  -- this will be called from 'AUTHORIZE SO '
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin 
			select 	@doc_taskcd 	= 'NSOAUSOSBT1',  
				@doc_activitycd	= 'NSOAUSO'		
		end  
	
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in('SO_AUMN_SER_RET','SO_AUEN_SER_SAV')  
		if @calling_service in('SO_AUMN_SER_RET','SO_AUEN_SER_SAV','SO_AUMN_SER_RET1','SO_AUEN_SER_SAV1')  
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin 
			select 	@doc_taskcd 	= 'NSOAUSOTRN6',  
				@doc_activitycd	= 'NSOAUSO'		
		end 
	
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service = 'SO_AMMN_SER_SBT'  
		if @calling_service in ('SO_AMMN_SER_SBT','SO_AMMN_SER_SBT1')
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin 
			select 	@doc_taskcd 	= 'NSOAMSOSBT1',  
				@doc_activitycd	= 'NSOAMSO'
			
		end 
	
		/* Added for Hold and Release Calls */
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in ('SO_HDEN_SER_HSBT','SO_HDMN_SER_HSBT') 
		if @calling_service in ('SO_HDEN_SER_HSBT','SO_HDMN_SER_HSBT','SO_HDEN_SER_HSBT1','SO_HDMN_SER_HSBT1') 
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin 
			select 	@doc_taskcd 	= 'NSOHLDSOSBT1',  
				@doc_activitycd	= 'NSOHLDSO'
		end
	
		/* Added for Hold and Release Calls */
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in ('SO_HDEN_SER_RSBT','SO_HDMN_SER_RSBT')
		if @calling_service in ('SO_HDEN_SER_RSBT','SO_HDMN_SER_RSBT','SO_HDEN_SER_RSBT1','SO_HDMN_SER_RSBT1')
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin 
			select 	@doc_taskcd 	= 'NSOHLDSOTRN2',  
				@doc_activitycd	= 'NSOHLDSO'
		end
	end
/* Code modified by Raju against NSODms412at_000412 ends*/
--DMS412AT_NSO_00048 begins
	if (@transactionno is null)
	begin 
		select	@transactionno	=	sohdr_order_no
		from	sotmp_order_hdr (nolock)
		where	sohdr_guid	=	@guid
	end
--DMS412AT_NSO_00048 ends
	select	@order_date	=	sohdr_order_date,
		@currency	=	sohdr_currency,
		@bu		=	sohdr_bu,
		@num_series	=	sohdr_num_series,
		@status		=	sohdr_order_status,
		@ord_tot_value	=	sohdr_total_value,
		@ord_basic_value=	sohdr_basic_value,
		@billtocust	=	sohdr_bill_to_cust,
		@customercode	=	sohdr_order_from_cust,
		@paytermcode	=	sohdr_pay_term_code,
		@company	=	sohdr_company_code,
		@sales_channel	=	sohdr_sales_channel,
		@folder		=	sohdr_folder,
		@sale_order_type=	sohdr_order_type,
		@workflow_status=	sohdr_workflow_status
	from	so_order_hdr (nolock)
	where	sohdr_ou	=	@ctxt_ouinstance
	and	sohdr_order_no	=	@transactionno

	select 	@ouinstname 	= 	ouinstname   
	from  	fw_admin_view_ouinstance  (nolock)
	where  	ouinstid 	=	 @ctxt_ouinstance

	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
	--if (@status = 'AM' and @calling_service = 'SO_AUMN_SER_SAV')
	if (@status = 'AM' and @calling_service in ('SO_AUMN_SER_SAV','SO_AUMN_SER_SAV1'))
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
	begin
		select 	@doc_taskcd 	= 'NSOAMSOSBT1',  
			@doc_activitycd	= 'NSOAMSO'
	end

/* Code modified by Raju against NSODms412at_000412 starts*/
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
	--if (@status = 'AM' and @calling_service = 'SOPP_AMMN_SER_AUTH')
	if (@status = 'AM' and @calling_service in ('SOPP_AMMN_SER_AUTH','SOPP_AMMN_SER_AUTH1'))
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
	begin
		select 	@doc_taskcd 	= 'PPSCMQSOAMDQOTTRN2',  
			@doc_activitycd	= 'PPSCMQSOAMDQO'
	end
/* Code modified by Raju against NSODms412at_000412 ends*/

	--if activity/task id is defined as init task , then current state sending with blank
	if exists(	select 	'X'
			from 	wf_inp_area_dtl_vw(nolock) 
-- 			where 	area_code 	= 	'NSOSO'
-- 			and	component_name	= 	'NSO'
			where 	area_code 	in  	('NSOSO', 'NSO')
--Modified by Damodharan. R for OTS ID NSODMS412AT_000546 begins
			--and	component_name	in 	('NSO', 'PPSCMQSO')
			and	component_name	= 	'NSO'
--Modified by Damodharan. R for OTS ID NSODMS412AT_000546 ends
			and	activity_name	=	@doc_activitycd		
			and	task_name	=	@doc_taskcd	
			and	initiated_task	=	'INIT' )
		select	@workflow_status = ''

	

/*SELECT Doc_Parameter as above with the Parameter details as follows. The wfm_para_concat_fn takes in the Parameter Code followed by the Value and forms a String as follows 
'CURRENCY$~$USD#~#EMPLOYEE$~$S0001#~#'
*/
/* Code modified by Raju against NSODms412at_000412 starts*/
	if @calling_service like 'SOPP_%'
	begin
		select @doc_parameter = dbo.wfm_para_concat_fn('','SO_NO', @transactionno)    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'LOGIN_LANGUAGE',@ctxt_language)    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'LOGIN_USER',@ctxt_user)    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'LOGIN_ROLE',@ctxt_role)    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'LOGIN_OU',@ctxt_ouinstance)    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ORDER_VALUE',convert(nvarchar(28),@ord_tot_value))    

	end
	else
	begin
		select @doc_parameter = dbo.wfm_para_concat_fn('','CURRENCY', @currency)    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'OU',@ouinstname)  
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'BU',@bu)    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ORDER DATE',convert(nvarchar(10),@order_date, 120))    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'NUMBERING SERIES',@num_series)    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'USER', @ctxt_user)    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'STATUS',@status)    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ORDER TOTAL VALUE',convert(nvarchar(28),@ord_tot_value))    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ORDER BASIC VALUE',convert(nvarchar(28),@ord_basic_value))    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'BILL TO CUSTOMER CODE',isnull(@billtocust,''))    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'CUSTOMER CODE',@customercode) 
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'PAYTERM CODE',@paytermcode)    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'COMPANY',@company)    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'ORDER NO.',@transactionno)    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'SALES CHANNEL',isnull(@sales_channel,''))    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'FOLDER',isnull(@folder,''))    
		select @doc_parameter = dbo.wfm_para_concat_fn(@doc_parameter,'SALE ORDER TYPE',@sale_order_type)    
	end     

	/* Added for Hold and Release Calls */
	if @calling_service LIKE 'SOPP%'
	begin
		select	@doc_key = 'NSO' + '$~$'+ convert(nvarchar(4),@ctxt_ouinstance)+ '$~$'+ @transactionno 
	end
	else
	begin
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in ('SO_HDEN_SER_HSBT','SO_HDMN_SER_HSBT') 
		if @calling_service in ('SO_HDEN_SER_HSBT','SO_HDMN_SER_HSBT','SO_HDEN_SER_HSBT1','SO_HDMN_SER_HSBT1') 
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin 
			select	@doc_key = 'NSO' + '$~HOLD~$'+ convert(nvarchar(4),@ctxt_ouinstance)+ '$~$'+ @transactionno
		end
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--else if @calling_service in ('SO_HDEN_SER_RSBT','SO_HDMN_SER_RSBT')
		else if @calling_service in ('SO_HDEN_SER_RSBT','SO_HDMN_SER_RSBT','SO_HDEN_SER_RSBT1','SO_HDMN_SER_RSBT1')
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin 
			select	@doc_key = 'NSO' + '$~REL~$'+ convert(nvarchar(4),@ctxt_ouinstance)+ '$~$'+ @transactionno
		end
		else
		begin
			select	@doc_key = 'NSO' + '$~$'+ convert(nvarchar(4),@ctxt_ouinstance)+ '$~$'+ @transactionno 
		end
	end
/* Code modified by Raju against NSODms412at_000412 ends*/

	exec	scm_get_dest_ou
		@ctxt_ouinstance,
		@ctxt_language,
		@ctxt_user,
		'NSO',
		'WFMTASKBAS',
		@wf_ou out,
		@m_errorid out

	if	@m_errorid <> 0
		return

/* Code modified by Raju against NSODms412at_000412 starts*/
	if @calling_service like 'SOPP%'
	begin
		select	 '~#~'				'DOC_ACTION_COMBO_VAL',
			rtrim(@doc_activitycd)		'DOC_ACTIVITYCD',  
			'NSOSO'			'DOC_AREA_CODE',		--Modified for DTS ID: DMS412AT_NSO_00048
			rtrim(@doc_auth_flag)		'DOC_AUTH_FLAG',
			'~#~'				'DOC_CHAR_DUMMY_1',	
			'~#~'				'DOC_CHAR_DUMMY_2',
			'NSO'			'DOC_COMPONENTCD',
			rtrim(@workflow_status)		'DOC_CURRENT_STATE',	 --isnull(current Work flow status, '')
			convert(nvarchar(10),@order_date,120)'DOC_DATE',
			-915  				'DOC_FLOAT_DUMMY_1',
			-915  				'DOC_FLOAT_DUMMY_2',
			@guid				'DOC_GUID',
			rtrim(@doc_key)			'DOC_KEY',
			rtrim(upper(@doc_newst_todo_user))'DOC_NEWST_TODO_USER',
			@doc_newst_todo_user_ou		'DOC_NEWST_TODO_USER_OU',	
			@ctxt_ouinstance		'DOC_ORGUNITID',
			rtrim(@doc_parameter)		'DOC_PARAMETER',
			rtrim(@doc_taskcd)		'DOC_TASKCD',	
			rtrim(@transactionno)		'DOC_UNIQUE_ID',
			@ctxt_ouinstance		'LOG_ORGUNITID',
			rtrim(@ctxt_role)		'LOG_ROLE',
			rtrim(upper(@ctxt_user))	'LOG_USER',
			@wf_ou				'WF_CONTEXT_OU'
	end	
	else
	begin
		select	 '~#~'				'DOC_ACTION_COMBO_VAL',
			rtrim(@doc_activitycd)		'DOC_ACTIVITYCD',        
			'NSOSO'				'DOC_AREA_CODE',		
			rtrim(@doc_auth_flag)		'DOC_AUTH_FLAG',
			'~#~'				'DOC_CHAR_DUMMY_1',	
			'~#~'				'DOC_CHAR_DUMMY_2',
			'NSO'				'DOC_COMPONENTCD',
			rtrim(@workflow_status)		'DOC_CURRENT_STATE',	 --isnull(current Work flow status, '')
			convert(nvarchar(10),@order_date,120)'DOC_DATE',
			-915  				'DOC_FLOAT_DUMMY_1',
			-915  				'DOC_FLOAT_DUMMY_2',
			@guid				'DOC_GUID',
			rtrim(@doc_key)			'DOC_KEY',
			rtrim(upper(@doc_newst_todo_user))'DOC_NEWST_TODO_USER',
			@doc_newst_todo_user_ou		'DOC_NEWST_TODO_USER_OU',	
			@ctxt_ouinstance		'DOC_ORGUNITID',
			rtrim(@doc_parameter)		'DOC_PARAMETER',
			rtrim(@doc_taskcd)		'DOC_TASKCD',	
			rtrim(@transactionno)		'DOC_UNIQUE_ID',
			@ctxt_ouinstance		'LOG_ORGUNITID',
			rtrim(@ctxt_role)		'LOG_ROLE',
			rtrim(upper(@ctxt_user))	'LOG_USER',
			@wf_ou				'WF_CONTEXT_OU'
	end
/* Code modified by Raju against NSODms412at_000412 ends*/
code commented for DTS ID: DMS412AT_NSO_00048 ends here*/

	set nocount off
end

