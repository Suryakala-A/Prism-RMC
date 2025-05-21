/*$File_version=MS4.3.0.10$*/
/******************************************************************************************
file name	: so_m_process_status_sp.sql
version		: 4.0.0.0
procedure name	: so_m_process_status_sp
purpose		: 
author		: venkata ganesh
date		: 23 jan 2003
component name	: nso
method name	: 

objects referred
	object name		object type		operation
							(insert/update/delete/select/exec)	
modification details
	modified by		modified on		remarks
	Manjunatha		27 Mar 2004		NSODMS41SYTST_000071
	Appala Raju.K		8/23/2004		NSODMS41SYTST_000165
	Appala Raju.K		23 Nov 2006		NSODms412at_000412
	Damodharan. R		08 Aug 2007		NSODMS412AT_000505
	Damodharan. R		25 Oct 2007		NSODMS412AT_000546
	Anitha				19 May 2007		DMS412AT_NSO_00048
	Veangadakrishnan R	23/03/2009		ES_NSO_00206
	Sejal N Khimani		21 March 2016	ES_NSO_01107
	Balaji C			20/05/2019		ILE-1134
	Vasantha a			05/09/2022		KPE-561
	Sheerapthi KR		17/04/2023		EPE-60232
	Sheerapthi KR		22/05/2023		EPE-60232
	Sheerapthi KR		15/06/2023		EPE-60232
	Sheerapthi KR		15/06/2023		EPE-68481
	Mancy Biska N       01-03-2024      RCEPL-591
	Shrimalavika M		08/08/2024		RMC-SAL-29
******************************************************************************************/ 
create   procedure so_m_process_status_sp
	@ctxt_ouinstance   		udd_ctxt_ouinstance,
	@ctxt_user   			udd_ctxt_user,	
	@ctxt_language  		udd_ctxt_language,
	@ctxt_service   		udd_ctxt_service,
	@ctxt_role			udd_ctxt_role,
	@doc_area_code                 	udd_wfareacode,
	@doc_key                       	udd_wfdockey,
	@doc_new_state                 	udd_wfstatename,
	@doc_success_flag              	udd_wfint,
	@doc_todo_systsk_flag          	udd_wfint,
	@calling_service               	udd_ctxt_service,
	@guid                          	udd_guid,
	@transactionno                 	udd_documentno,
	@m_errorid                     	udd_int   output
as
begin
        set nocount on

	select	@m_errorid = 0

	select    @ctxt_ouinstance               =     @ctxt_ouinstance
	select    @ctxt_user                     =     ltrim(rtrim(@ctxt_user))
	select    @ctxt_language                 =     @ctxt_language
	select    @ctxt_service                  =     ltrim(rtrim(@ctxt_service))
	select    @ctxt_role                     =     ltrim(rtrim(@ctxt_role))
	select    @doc_area_code                 =     ltrim(rtrim(@doc_area_code))
	select    @doc_key                       =     ltrim(rtrim(@doc_key))
	select    @doc_new_state                 =     ltrim(rtrim(@doc_new_state))
	select    @doc_success_flag              =     @doc_success_flag
	select    @doc_todo_systsk_flag          =     @doc_todo_systsk_flag
	select    @calling_service               =     ltrim(rtrim(upper(@calling_service)))
	select    @guid                          =     ltrim(rtrim(@guid))
	select    @transactionno                 =     ltrim(rtrim(upper(@transactionno)))
	
	-- null checking 
	if  @ctxt_ouinstance = -915
	   select  @ctxt_ouinstance=null
	
	if  @ctxt_user = '~#~'
	   select  @ctxt_user=null
	
	if  @ctxt_language = -915
	   select  @ctxt_language=null
	
	if  @ctxt_service = '~#~'
	   select  @ctxt_service=null
	
	if  @ctxt_role = '~#~'
	   select  @ctxt_role=null
	
	if  @doc_area_code = '~#~'
	   select  @doc_area_code=null
	
	if  @doc_key = '~#~'
	   select  @doc_key=null
	
	if  @doc_new_state = '~#~'
	   select  @doc_new_state=null
	
	if  @doc_success_flag = -915
	   select  @doc_success_flag=null
	
	if  @doc_todo_systsk_flag = -915
	   select  @doc_todo_systsk_flag=null
	
	if  @calling_service = '~#~'
	   select  @calling_service=null
	
	if  @guid = '~#~'
	   select  @guid=null
	
	if  @transactionno = '~#~'
	   select  @transactionno=null

	declare	--@doc_activitycd         udd_wfactivitycode,
			--@doc_taskcd             udd_wftaskname,
			@order_status			udd_metadata_code,
			--@initiated_task			udd_wfactivitycode,
			@prev_status			udd_metadata_code,	
			@order_status_tmp		udd_metadata_code,
			@prev_status_tmp		udd_metadata_code,
			@applied_flag			udd_flag,
			@call_cmn_is			udd_flag,
			@exec_flag				udd_flag,
			@sohdr_bill_to_cust		udd_customer_id,	--ILE-1134
			@m_errorid_tmp			udd_int	



	/*Code added for EPE-60232 Begins */
	declare	@errorid			udd_int,
			@amendno			udd_number,
			--@status			    udd_status,
			@trantype			udd_trantype
	/*Code added for EPE-60232 ends */

    /*Code added for EPE-60232 Begins */
	select	@calling_service	=	newcallingservice
	from	erp_cmn_notification_metadata	with(nolock)
	where   component_id		=    'SAL_CON'
	--and		@calling_service	=    @calling_service --Code commented for EPE-68481
	and		callingservice		=	@calling_service --Code added for EPE-68481
	and     language_id			=    @ctxt_language
	/*Code added for EPE-60232 Ends */

	/*Code added for EPE-60232 Begins */
	If @calling_service in ('so_CnCrMn_Ser_Sbt','so_cnedmn_ser_sbt','so_cnedmn_ser_del','so_cneden_ser_del','so_cnauen_ser_ret','so_cnaumn_ser_ret','so_cnaumn_ser_sav','so_cnaumn_ser_sbt','so_cnauen_ser_sbt','so_cnammn_ser_sbt','so_cncrag_ser_sbt','so_cncrbs_ser_sbt')
	Begin
		Select @trantype = 'SAL_CON'
	End

	if   @trantype = 'SAL_CON' 
	BEGIN
	/*Code added for EPE-60232 ends */
	select	@transactionno		=	conhdr_contract_no,
			@amendno			=	conhdr_amend_no
	from	so_contract_hdr with (nolock)
	where	conhdr_contract_no	=	@transactionno
	and		conhdr_ou			=	@ctxt_ouinstance

	if	@doc_success_flag	=	1
	begin
		if (select	count('X')
			from	wf_doc_status_vw(nolock)
			where	doc_key				= @doc_key
			and		doc_status			not in ('FRESH','RET','AMD')
			and		wf_instance_status	= 'P'
			and		user_closed			= 'C'
			) = 1
			begin
				select	@errorid = 0

			 exec nso_wf_backup_sp
				 @ctxt_ouinstance	,		
				 @ctxt_user			,		
				 @ctxt_language		,		
				 @ctxt_service		,		
				 @ctxt_role			,		
				 @calling_service	,		
				 @guid				,		
				 'SAL_CON'			,		
				 @transactionno		,		
				 @ctxt_ouinstance	,		    
				 'D'					,		
				 @errorid	output	
				 
			if @errorid <> 0 
			begin
				return   
			end

			exec nso_wf_backup_sp
				 @ctxt_ouinstance	,		
				 @ctxt_user			,		
				 @ctxt_language		,		
				 @ctxt_service		,		
				 @ctxt_role			,		
				 @calling_service	,		
				 @guid				,		
				 'SAL_CON'			,		
				 @transactionno		,		
				 @ctxt_ouinstance	,		    
				 'I'					,		
				 @errorid	output

				if	@errorid	<>	0
				begin
					return
				end
			end
	end
		if @doc_new_state in ('RET','AUTH','AUT')
		begin
			exec nso_wf_backup_sp
				 @ctxt_ouinstance	,		
				 @ctxt_user			,		
				 @ctxt_language		,		
				 @ctxt_service		,		
				 @ctxt_role			,		
				 @calling_service	,		
				 @guid				,		
				 'SAL_CON'			,		
				 @transactionno		,		
				 @ctxt_ouinstance	,		    
				 'D'					,		
				 @errorid	output

				if	@errorid	<>	0
				begin
					return
				end
		end

		update	so_contract_hdr
		set		conhdr_status			=	case	when @doc_new_state in	('AUTH','AUT')	then 'AU'  
													when @doc_new_state =	'RET'	then 'RT'
													when @amendno > 0				then 'AM'
													else 'FR'	
													end,
				conhdr_workflowstatus	=	case	when @doc_new_state in ('AUTH','AUT')	then null 													
													else @doc_new_state end
		where	conhdr_contract_no	    =	@transactionno
		and		conhdr_ou				=	@ctxt_ouinstance


	/*Code added for EPE-60232 Ends*/
	/*Code added for EPE-60232 Begins */
	End
	Else
	Begin
	/*Code added for EPE-60232 Ends*/
	if @transactionno is null
	begin
			select @transactionno=order_no
			from so_upd_status_tmp(nolock)
			where	guid		=	@guid
	end

	if @doc_success_flag = 0
	begin
		delete	so_upd_status_tmp
		where	guid		=	@guid
		and		order_no	=	@transactionno

		return
	end		
	/* Code added by Shrimalavika M against RMC-SAL-29 Begins */
	if @doc_new_state	=	'Fresh'
	Begin
		update	so_contract_hdr
		set		conhdr_workflowstatus	= 	case when @doc_new_state = 'FRESH' then 'FRESH' Else ''end
		where	conhdr_ou				=	@ctxt_ouinstance	
		and		conhdr_contract_no 			=	@transactionno
	End
	/* Code added by Shrimalavika M aganist RMC-SAL-29 Ends */
	/*code added for DTS ID: ES_NSO_00206 starts here*/
	select	@prev_status_tmp	=	prev_status,
			@order_status_tmp	=	current_status
	from	so_upd_status_tmp(nolock)
	where	guid		=	@guid
	and		order_no	=	@transactionno

	if @doc_new_state = 'AUTH' and @order_status_tmp = 'AU'
	begin
		select @order_status = 'AU'	
		select @doc_new_state = null
	end
	else if @order_status_tmp in('AU','FR','AM')
	begin
		/* Code added for ITS ID : ES_NSO_01107 Begins */		
		select	@amendno				=	sohdr_amend_no
		from	so_order_hdr(nolock)
		where	sohdr_ou				=	@ctxt_ouinstance	
		and		sohdr_order_no 			=	@transactionno
				
		--select @order_status = case when @calling_service like 'sopp_AmMn%' then  'AM' else 'FR' end
		select @order_status = case when (@calling_service like 'sopp_AmMn%') or (@amendno > 0) then  'AM' else 'FR' end
		/* Code added for ITS ID : ES_NSO_01107 Ends */		
	end	
	else if @order_status_tmp in('SC')
	begin
		select @order_status = 'SC'
		select @doc_new_state = null
	end
	
	--ILE-1134 starts
	select @sohdr_bill_to_cust	=	sohdr_bill_to_cust
	from	so_order_hdr(nolock)
	where	sohdr_ou				=	@ctxt_ouinstance	
	and		sohdr_order_no 			=	@transactionno
	--ILE-1134 ends

	select @prev_status = @prev_status_tmp

	--RCEPL-591 Begins
	select @order_status = case when (isnull(@order_status,'')= '' and @calling_service like ('nso_mnt_serret')) 
								then	@order_status_tmp
								else	@order_status
								end
	--RCEPL-591 ends
	
	
	update 	so_upd_status_tmp
	set		current_status	=	@order_status
	where	guid			=	@guid
	and		order_no		=	@transactionno

	

	if @prev_status_tmp = 'AU' and @order_status_tmp in ('AM','AU')
	begin
		update	so_order_hdr
		set		sohdr_order_status		=	@order_status,
				sohdr_prev_status		=	@prev_status,
				--sohdr_amend_no			=	(sohdr_amend_no + 1),--code commented by vasantha  a for  KPE-561
				sohdr_workflow_status	= 	@doc_new_state
		where	sohdr_ou				=	@ctxt_ouinstance	
		and		sohdr_order_no 			=	@transactionno
	end
	else
	begin
		update	so_order_hdr
		set		sohdr_order_status		=	@order_status,
				sohdr_prev_status		=	@prev_status,
				sohdr_workflow_status	= 	@doc_new_state
		where	sohdr_ou				=	@ctxt_ouinstance	
		and		sohdr_order_no 			=	@transactionno
	end

	if @calling_service in ('SOPP_CRMN_SER_SBT1','SOPP_CRMN_SER_CRAU1','SOPP_CRMN_SER_AUTH1','so_CrRef_Ser_Sbt') 
			and @order_status = 'AU'
	begin
		exec tcal_status_upd_sp  @ctxt_ouinstance,  
							 @ctxt_language,  
							 @ctxt_user,  
							 @calling_service,  
							 @guid,  
							 @ctxt_ouinstance,  
							 'SAL_NSO',  
							 @transactionno,  
							 'CREATE',  
							 null,  
							 'NSO',  
							 @calling_service,  
							 @transactionno,  
							 @order_status,  
							 @applied_flag out,  
							 @exec_flag out,  
							 @m_errorid out  
		if @m_errorid <> 0   
			return  

		exec	so_cmn_sp_add_on_auth		
				@ctxt_language,
				@ctxt_ouinstance,
				@calling_service,
				@ctxt_user,
				@guid,
				@transactionno,
				@call_cmn_is out,
				@m_errorid_tmp out

		if 	@m_errorid_tmp <> 0
		begin			
			--ILE-1134 starts
			if	@m_errorid_tmp	=	750510
			begin
				exec fin_german_raiserror_sp 'CDI',@ctxt_language,43,@sohdr_bill_to_cust
				return
			end
			else
			if	@m_errorid_tmp	=	750511	
			begin
				exec fin_german_raiserror_sp 'CDI',@ctxt_language,44,@sohdr_bill_to_cust
				return
			end
			else			
			select @m_errorid = @m_errorid_tmp			
			--ILE-1134 ends
			return
		end
	end
	
	if @calling_service like 'SOPP_AMMN%' and @order_status = 'AU'
	begin
		exec tcal_status_upd_sp @ctxt_ouinstance,  
			 @ctxt_language,  
			 @ctxt_user,  
			 @calling_service,  
			 @guid,  
			 @ctxt_ouinstance,  
			 'SAL_NSO',  
			 @transactionno,  
			 'EDIT',  
			 null,  
			 'NSO',  
			 @calling_service,  
			 @transactionno,  
			 @order_status,  
			 @applied_flag out,  
			 @exec_flag out,  
			 @m_errorid out  
		 if @m_errorid <> 0   
			return  
	   
		--calling the procedure to authorize the document based on the system parameter  
		 exec so_cmn_sp_amd_on_auth  
		  @ctxt_language,  
		  @ctxt_ouinstance,  
		  @calling_service,  
		  @ctxt_user,  
		  @guid,  
		  @transactionno,  
		  @m_errorid_tmp out  
	  
		 if @m_errorid_tmp <> 0  
		 begin  
		  select @m_errorid = @m_errorid_tmp  
		  return  
		 end 
	end
	
		
	if @order_status = 'AU' and @doc_new_state <> 'AUTH'
	begin
		delete	so_upd_status_tmp
		where	guid	=	@guid
		and		order_no=	@transactionno
	end
/*code added for DTS ID: ES_NSO_00206 ends here*/
/*Commented for DTS ID: ES_NSO_00206 starts here
/* Code modified by Raju against NSODms412at_000412 starts*/
	if @calling_service like 'SOPP_%'
	begin
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in( 'SOPP_CRMN_SER_SBT')
		if @calling_service in ('SOPP_CRMN_SER_SBT','SOPP_CRMN_SER_SBT1')
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin  		
			select	@transactionno	=	sohdr_order_no
			from	sotmp_order_hdr (nolock)
			where	sohdr_guid	=	@guid		
		end  
	
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in ('SOPP_CRMN_SER_SBT') -- this will be called from 'CREATE SO' 
		if @calling_service in ('SOPP_CRMN_SER_SBT','SOPP_CRMN_SER_SBT1') -- this will be called from 'CREATE SO' 
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin  
			/*code commented and added for DTS ID: DMS412AT_NSO_00048 starts here*/
			select 	@doc_taskcd 	= 'NSOADDSOSBT2',
				@doc_activitycd	= 'NSOADDSO'		

--			select 	@doc_taskcd 	= 'PPSCMQSOCRTQOTTRN1',
--				@doc_activitycd	= 'PPSCMQSOCRTQO'
			/*code commented and added for DTS ID: DMS412AT_NSO_00048 ends here*/
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
			select 	@doc_taskcd 	= 'PPSCMQSOCRTQOTTRN5',  
				@doc_activitycd	= 'PPSCMQSOCRTQO'		
		end  
	
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in ('SOPP_CRMN_SER_AUTH')
		if @calling_service in ('SOPP_CRMN_SER_AUTH','SOPP_CRMN_SER_AUTH1')
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin 
			select 	@doc_taskcd 	= 'PPSCMQSOCRTQOTTRN7',  
				@doc_activitycd	= 'PPSCMQSOCRTQO'		
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
/* Code modified by Raju against NSODms412at_000412 ends*/
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in( 'SO_CRMN_SER_SBT','SO_CRREF_SER_SBT', 'SO_CRMN_SER_COPY')
		if @calling_service in ('SO_CRMN_SER_SBT','SO_CRREF_SER_SBT', 'SO_CRMN_SER_COPY','SO_CRMN_SER_SBT1','SO_CRREF_SER_SBT1', 'SO_CRMN_SER_COPY1')
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin  		
	
			select	@transactionno	=	sohdr_order_no
			from	sotmp_order_hdr (nolock)
			where	sohdr_guid	=	@guid		
		end  
	
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service in ('SO_CRMN_SER_SBT', 'SO_CRMN_SER_COPY', 'NSOSER042', 'SO_RLCRMN_SER_GENREL', 'SO_RLEDMN_SER_GENREL', 'SO_CRSCH_SER_SBT') -- this will be called from 'CREATE SO' 
		if @calling_service in ('SO_CRMN_SER_SBT', 'SO_CRMN_SER_COPY', 'NSOSER042', 'SO_RLCRMN_SER_GENREL', 'SO_RLEDMN_SER_GENREL', 'SO_CRSCH_SER_SBT','SO_CRMN_SER_SBT1', 'SO_CRMN_SER_COPY1', 'NSOSER0421', 'SO_RLCRMN_SER_GENREL1', 'SO_RLEDMN_SER_GENREL1', 'SO_






C

RSCH_SER_SBT1') -- this will be called from 'CREATE SO'
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin  
			select 	@doc_taskcd 	= 'NSOADDSOSBT2',
				@doc_activitycd	= 'NSOADDSO'		
		end  
	
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service = 'SO_CRREF_SER_SBT' -- this will be called from 'CREATE REFERENCE SO' 
		if @calling_service in ('SO_CRREF_SER_SBT','SO_CRREF_SER_SBT1') -- this will be called from 'CREATE REFERENCE SO' 
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin  
			select 	@doc_taskcd 	= 'NSOADDREFSBT1',
				@doc_activitycd	= 'NSOADDREF'		
		end  
	
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service = 'SO_EDMN_SER_SBT' -- this will be called from 'EDIT SO '
		if @calling_service in ('SO_EDMN_SER_SBT','SO_EDMN_SER_SBT1') -- this will be called from 'EDIT SO '
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin  
			select 	@doc_taskcd 	= 'NSOMNTSOSBT1',
				@doc_activitycd	= 'NSOMNTSO'		
		end  
	
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
		--if @calling_service = 'SO_AUMN_SER_SAV' 
		if @calling_service in ('SO_AUMN_SER_SAV','SO_AUMN_SER_SAV1')
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
		begin
			if exists ( 	select 	'*'
					from 	so_order_hdr(nolock)
					where	sohdr_order_no 	= @transactionno
					and 	sohdr_ou 	= @ctxt_ouinstance
					and 	sohdr_order_status = 'AM' )
			begin
				select 	@doc_taskcd 	= 'NSOAMSOSBT1',  
					@doc_activitycd	= 'NSOAMSO'
			end
			else
			begin
				select 	@doc_taskcd 	= 'NSOMNTSOSBT1',
					@doc_activitycd	= 'NSOMNTSO'		
			end
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
		--if @calling_service in ('SO_AUMN_SER_RET', 'SO_AUEN_SER_SAV')
		if @calling_service in ('SO_AUMN_SER_RET', 'SO_AUEN_SER_SAV','SO_AUMN_SER_RET1', 'SO_AUEN_SER_SAV1')
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
	end
	
	if @doc_success_flag = 0
	begin
		delete	so_upd_status_tmp
		where	guid		=	@guid
		and	order_no	=	@transactionno

		-- Work flow Failed. Please check		
		raiserror('Work flow Failed. Please check.',16,1)--Added for DTS ID: DMS412AT_NSO_00048
		--select	@m_errorid = 325282
		return
	end		

	/* Added for Hold and Release Calls */
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
	--if @calling_service in ('SO_HDEN_SER_HSBT','SO_HDMN_SER_HSBT','SO_HDEN_SER_RSBT','SO_HDMN_SER_RSBT') 
	if @calling_service in ('SO_HDEN_SER_HSBT','SO_HDMN_SER_HSBT','SO_HDEN_SER_RSBT','SO_HDMN_SER_RSBT','SO_HDEN_SER_HSBT1','SO_HDMN_SER_HSBT1','SO_HDEN_SER_RSBT1','SO_HDMN_SER_RSBT1') 
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
	begin 
		if 	@doc_success_flag = 1  
		begin  	
			select @transactionno = @transactionno
			-- Donot Update the Workflow Status for Hold and Release
/*			update	so_order_hdr
			set 	sohdr_workflow_status	=	rtrim(@doc_new_state)
			where 	sohdr_order_no		= 	@transactionno
			and  	sohdr_ou 		= 	@ctxt_ouinstance */
		end
	end
	else if @doc_success_flag = 1  /* For Init / Authorize tasks */
	begin  	
		--checking the order status 
		select	@order_status	=	current_status		
		from	so_upd_status_tmp	(nolock)
		where	guid		=	@guid
		and	order_no	=	@transactionno				
			
		if @order_status = 'AU' and @doc_new_state <> 'AUTH'
		begin
			delete	so_upd_status_tmp
			where	guid		=	@guid
			and	order_no	=	@transactionno
		end
		--check if new workflow status is defined as the end state for the task/activity

		/* Logic for status updation to PA */					
		/* Check if New Status exists in the Table for the Task Code and Activity Code */
		/* If Not Exists, Get the Task Type */
		/* If the Task Type is INIT, Check if the New Status exists for Authorization Activity */
		/* If Not Exists, Update Status to PA */

		update	so_order_hdr
		set 	sohdr_workflow_status 	= 	@doc_new_state
		where 	sohdr_order_no		= 	@transactionno
		and  	sohdr_ou 		= 	@ctxt_ouinstance
			
		if exists (select 'X' from wf_inp_appstate_dtl_vw(nolock)
/* Code modified by Raju against NSODms412at_000412 starts*/
-- 			  where area_code 	= 	'NSOSO'
/* Code modified by Damodharan. R on 25 Oct 2007 for OTS ID NSODMS412AT_000546 starts here */
			  where area_code 	= 	case when @calling_service like 'SOPP_%' then 'NSOSO' else 'NSOSO' end --Modified for DTS ID: DMS412AT_NSO_00048
 			  and	component_name	=	'NSO'
			  --where area_code 	= 	case when @calling_service like 'SOPP_%' then 'PPSCMQSO' else 'NSOSO' end
			 --and	component_name	=	case when @calling_service like 'SOPP_%' then 'PPSCMQSO' else 'NSO' end
/* Code modified by Damodharan. R on 25 Oct 2007 for OTS ID NSODMS412AT_000546 ends here */
/* Code modified by Raju against NSODms412at_000412 ends*/
			  and	activity_name	=	@doc_activitycd
			  and	task_name	=	@doc_taskcd
			  and	state_name	=	@doc_new_state)
		begin
			select	@doc_new_state	=	@doc_new_state
		end
		else
		begin	
			select	@initiated_task	=	initiated_task	
			from 	wf_inp_area_dtl_vw(nolock) 
/* Code modified by Raju against NSODms412at_000412 starts*/
-- 			where 	area_code 	= 	'NSOSO'
/* Code modified by Damodharan. R on 25 Oct 2007 for OTS ID NSODMS412AT_000546 starts here */
			where 	area_code 	= 	case when @calling_service like 'SOPP_%' then 'NSOSO' else 'NSOSO' end --Modified for DTS ID: DMS412AT_NSO_00048
			and	component_name	= 	'NSO'
			--where 	area_code 	= 	case when @calling_service like 'SOPP_%' then 'PPSCMQSO' else 'NSOSO' end
			--and	component_name	= 	case when @calling_service like 'SOPP_%' then 'PPSCMQSO' else 'NSO' end
/* Code modified by Damodharan. R on 25 Oct 2007 for OTS ID NSODMS412AT_000546 ends here */
/* Code modified by Raju against NSODms412at_000412 ends*/
			and	activity_name	=	@doc_activitycd		
			and	task_name	=	@doc_taskcd

			if @initiated_task = 'INIT' and @doc_new_state = 'AUTH'
			begin
				select	@doc_new_state	=	@doc_new_state						
			end
			else
			begin
				update	so_order_hdr
				set 	sohdr_order_status	=	'PA'
				where 	sohdr_order_no		= 	@transactionno
				and  	sohdr_ou 		= 	@ctxt_ouinstance
			end
		end		
	end
Commented for DTS ID: ES_NSO_00206 ends here*/

	End		--Code added for EPE-60232				
	set nocount off
end








