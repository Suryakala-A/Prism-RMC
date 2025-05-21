/*$File_version=ms4.3.0.10$*/
/******************************************************************************************
file name	: so_cncrmn_sp_sbt_hsav.sql
version		: 4.0.0.1
procedure name	: so_cncrmn_sp_sbt_hsav
purpose		: 
author		: 
date		: 11 sep 2002
component name	: nso
method name	: so_cncrmn_m_sbt_hsav

objects referred
	object name		object type		operation
							(insert/update/delete/select/exec)
modification details
modified by		modified on			remarks
Manjunatha		27 Mar 2004			NSODMS41SYTST_000071
john			31 Mar 2004			NSODMS41SYTST_000068
john			2 APR 2004			NSODMS41SYTST_000043
Manjunatha		4/8/04				NSODMS41SYTST_000070		
John			24 Apr 2004			NSODMS41SYTST_000053*/

/****************************************************************************************/
/*Modified by		Date				Remarks				*/
/*muthukumar c		11/19/2004				NSO411UISTD_000003	*/
/*Priya R		05/08/2005			NSOBASEFIXES_000764(4.0.0.1)	*/
/*Senthil		04/10/2005			NSODMS412AT_000098(4.0.0.2)	*/
/*Niranjan		29/12/2005			NSOBGL_000020			*/
/*Veangadakrishnan R	04/03/2008	`		DMS412AT_NSO_00033		*/
/*Divyalekaa			28/01/2014			ES_PRJBDPRO_00160		*/
/*Sivasankari           05/03/2018          MKN-57                  */
/*Sheerapthi Vishnu KR  27/03/2023			EPE-60232				*/
/*Sheerapthi Vishnu KR  22/05/2023			EPE-60232				*/
/*Prakash V				11/05/2023          RTTIPL-20               */
/*Chaitanya Ch        15/11/2023          EPE-58525*/
/*suryakala A       22-01-2025       CU Merging-PJRMC-1252 */

/****************************************************************************************/
create   procedure so_cncrmn_sp_sbt_hsav
     --temporary store for input parameter assignment
     @ctxt_language   		udd_ctxt_language  ,
     @ctxt_ouinstance   		udd_ctxt_ouinstance  ,
     @ctxt_service   		udd_ctxt_service  ,
     @ctxt_user   			udd_ctxt_user  ,
     @billcustcode  			udd_customer_id  ,
     @billtoaddid   			udd_id  ,
     @chk_ref_doc   			udd_checkbox  ,
     @cont_date   			udd_date  ,
     @cont_desc   			udd_description  ,
     @cont_no   			udd_documentno  ,
     @cont_type   			udd_cont_type  ,
     @contactperson   		udd_contactperson  ,
     @contsourcedocument   		udd_contsourcedocument  ,
     @cr_by   			udd_loginid  ,
     @createddate   			udd_date  ,
    -- @cuspono   			udd_documentno  ,--MKN-57
	-- @cuspono               udd_cust_po_no,--MKN-57
	 @cuspono      udd_trandesc,--EPE-58525
     @cust_name   			udd_custname  ,
     @customeraddid   		udd_id  ,
     @customercode   		udd_customer_id  ,
     @customerpodate   		udd_date  ,
     @documentno   			udd_documentno  ,
     @folderid   			udd_identificationnumber1  ,
     @guid   				udd_guid  ,
     @hidden_control1   		udd_hiddencontrol  ,
     @hidden_control2   		udd_hiddencontrol  ,
     @num_series   			udd_notypeno  ,
     @ord_cont_status   		udd_status  ,
     @ref_doc_name  			udd_document  ,
     @refdocno   			udd_documentno  ,
     @spcode   			udd_code  ,
     @spname   			udd_name  ,
     @stcode   			udd_code  ,
     @stname1   			udd_name  ,
     @m_errorid 			udd_int output --to return execution status
	 /* Code added for EPE-60232 begins */
	 ,@workflow_status      	udd_status	=	Null--Input	
	/* Code added for EPE-60232 ends */
as
begin
     --declare @iudmodeflag nvarchar(2) 

     -- nocount should be switched on to prevent phantom rows 
     set nocount on
     -- @m_errorid should be 0 to indicate success
     select @m_errorid =0

     if @ctxt_language = -915 
     select @ctxt_language = null

     if @ctxt_ouinstance = -915 
     select @ctxt_ouinstance = null

     select @ctxt_service = ltrim(rtrim(@ctxt_service))
     if @ctxt_service = '~#~' 
     select @ctxt_service = null

     select @ctxt_user = ltrim(rtrim(@ctxt_user))
     if @ctxt_user = '~#~' 
     select @ctxt_user = null

     select @billcustcode = ltrim(rtrim(upper(@billcustcode)))
     if @billcustcode = '~#~' 
     select @billcustcode = null

     select @billtoaddid = ltrim(rtrim(upper(@billtoaddid)))
     if @billtoaddid = '~#~' 
     select @billtoaddid = null

     select @chk_ref_doc = ltrim(rtrim(upper(@chk_ref_doc)))
     if @chk_ref_doc = '~#~' 
     select @chk_ref_doc = null

     if @cont_date = '01/01/1900' 
     select @cont_date = null
     select @cont_date = @cont_date

     select @cont_desc = ltrim(rtrim(@cont_desc))
     if @cont_desc = '~#~' 
     select @cont_desc = null

     select @cont_no = ltrim(rtrim(upper(@cont_no)))
     if @cont_no = '~#~' 
     select @cont_no = null

     select @cont_type = ltrim(rtrim(upper(@cont_type)))
     if @cont_type = '~#~' 
     select @cont_type = null

     select @contactperson = ltrim(rtrim(upper(@contactperson)))
     if @contactperson = '~#~' 
     select @contactperson = null

     select @contsourcedocument = ltrim(rtrim(upper(@contsourcedocument)))
     if @contsourcedocument = '~#~' 
     select @contsourcedocument = null

     select @cr_by = ltrim(rtrim(upper(@cr_by)))
     if @cr_by = '~#~' 
     select @cr_by = null

     if @createddate = '01/01/1900' 
     select @createddate = null
     select @createddate = @createddate

     select @cuspono = ltrim(rtrim(upper(@cuspono)))
     if @cuspono = '~#~' 
     select @cuspono = null

     select @cust_name = ltrim(rtrim(upper(@cust_name)))
     if @cust_name = '~#~' 
     select @cust_name = null

     select @customeraddid = ltrim(rtrim(upper(@customeraddid)))
     if @customeraddid = '~#~' 
     select @customeraddid = null

     select @customercode = ltrim(rtrim(upper(@customercode)))
     if @customercode = '~#~' 
     select @customercode = null

     if @customerpodate = '01/01/1900' 
     select @customerpodate = null
     select @customerpodate = @customerpodate

     select @documentno = ltrim(rtrim(upper(@documentno)))
     if @documentno = '~#~' 
     select @documentno = null

     select @folderid = ltrim(rtrim(upper(@folderid)))
     if @folderid = '~#~' 
     select @folderid = null

     select @guid = ltrim(rtrim(@guid))
     if @guid = '~#~' 
     select @guid = null

     select @hidden_control1 = ltrim(rtrim(upper(@hidden_control1)))
     if @hidden_control1 = '~#~' 
     select @hidden_control1 = null

     select @hidden_control2 = ltrim(rtrim(upper(@hidden_control2)))
     if @hidden_control2 = '~#~' 
     select @hidden_control2 = null

     select @num_series = ltrim(rtrim(upper(@num_series)))
     if @num_series = '~#~' 
     select @num_series = null

     select @ord_cont_status = ltrim(rtrim(upper(@ord_cont_status)))
     if @ord_cont_status = '~#~' 
     select @ord_cont_status = null

     select @ref_doc_name = ltrim(rtrim(upper(@ref_doc_name)))
     if @ref_doc_name = '~#~' 
     select @ref_doc_name = null

     select @refdocno = ltrim(rtrim(upper(@refdocno)))
     if @refdocno = '~#~' 
     select @refdocno = null

     select @spcode = ltrim(rtrim(upper(@spcode)))
     if @spcode = '~#~' 
     select @spcode = null

     select @spname = ltrim(rtrim(upper(@spname)))
     if @spname = '~#~' 
     select @spname = null

     select @stcode = ltrim(rtrim(upper(@stcode)))
     if @stcode = '~#~' 
     select @stcode = null

     select @stname1 = ltrim(rtrim(upper(@stname1)))
     if @stname1 = '~#~' 
     select @stname1 = null

		/* Code added for EPE-60232 Begins */
	Select @workflow_status       = ltrim(rtrim(@workflow_status))
	IF @workflow_status = '~#~' 
		Select @workflow_status   = null 
	/* Code added for EPE-60232 Ends */

     

	--declaration of temp variables
	declare	@so_docouinstance_tmp	udd_ctxt_ouinstance,
			@so_custname_tmp		udd_name,
			@so_lineno_tmp		udd_lineno,
			@m_errorid_tmp		udd_int,	--Code Modified for EPE-60232
			@so_spouinstance_tmp		udd_ctxt_ouinstance,
			@so_spname_tmp		udd_name,
			@so_stname_tmp		udd_name,
			@execflag			udd_sequence,
			@currencycode			udd_currency,	
			@eratedate			udd_date,
			@erate				udd_exchangerate,
			@m_error_flag			udd_metadata_code,
			@sysparam			udd_paramcode,
			@error_msg_qualifier		udd_desc255,
			@fcc_ou			udd_ctxt_ouinstance,
			@fb_id				udd_financebookid,
			@company_code			udd_companycode,
			@comp_return_val		udd_int,	--Code Modified for EPE-60232
			@status			udd_status,
			@ptermou			udd_ctxt_ouinstance,
			@ptamenno			udd_documentno,
			@ptcode			udd_documentno,
			@qtn_ou			udd_ctxt_ouinstance,
			@sp_status			udd_status,
			@return_val			udd_int,	--Code Modified for EPE-60232
			@return_error			udd_int,	--Code Modified for EPE-60232
			@cur_return_value		udd_int,	--Code Modified for EPE-60232
			@todate			udd_date,
			@eratetype			udd_paramcode,
			@exchangerate			udd_exchangerate,
			@lo				udd_loid,
			@bu				udd_buid,
			@cust_lo			udd_loid,
			@cust_bu			udd_buid,
			@cust_ou			udd_ctxt_ouinstance,
			@trandate_tmp			udd_date,
			@ship_to_id			udd_id,
			@ship_to_cust			udd_customer_id,
			@shipping_pt			udd_ctxt_ouinstance,
			@trans_mode			udd_categorytype,
			@so_num_series   		udd_notypeno

/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00033 starts here*/
		declare	@item_ou	udd_ctxt_ouinstance,
			@item_lo	udd_loid ,
			@item_bu	udd_buid ,
			@tran_date	udd_date ,
			@warehousecode	udd_warehouse,
			@item_code	udd_item_code,
			@item_variant	udd_variant
/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00033 ends here*/
			
	select 	@return_error = 1,
			@execflag = 0,
			@todate = convert(nvarchar(10), dbo.RES_Getdate(@ctxt_ouinstance), 101)

	if rtrim(@cont_no) is not null and rtrim(upper(@num_series)) <> '~MANUAL~'
	begin
		--please select numbering series as manual in the combo
		select @m_errorid = 320668
		return
	end

	if rtrim(@cont_no) is null and rtrim(upper(@num_series)) = '~MANUAL~'
	begin
		--<^cont_no!> cannot be null. enter a contract <^cont_no!> 
	  	select @m_errorid = 320208
		return
	end
	/* Code Modified By Senthil for :- NSODMS412AT_000098  */

-- 	/* OTS NO:NSODMS41SYTST_000068 START HERE */
-- 
-- 	if @cont_desc is null
-- 	begin
-- 		select @cont_desc = ''
-- 	end	

	
	if @cont_desc is null
	begin
/* Begins - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/
   select @cont_desc=addr_inco_place_ship from cust_addr_dtl (nolock)
	where addr_cust_code=@billcustcode
	and addr_address_id=@billtoaddid
  end
 if @cont_desc is null              
 begin           
 /* ENDS - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/   
		select @m_errorid = 35335719
		return
	end	
	/* Code Modified By Senthil for :- NSODMS412AT_000098  */

	/* OTS NO:NSODMS41SYTST_000068 ENDS HERE */

	if @cont_date is null
		select	@cont_date = convert(nvarchar(10), dbo.RES_Getdate(@ctxt_ouinstance), 101)

	select	@sysparam 	= parameter_value
	from	so_sys_param_ou_vw (nolock)
	where	ouid		= @ctxt_ouinstance
	and	component_name	= 'NSO'
	and    	parameter_code	= 'SO_ORD_FUTDATE'

	if rtrim(upper(@sysparam)) <> 'Y'
	begin
		if @cont_date > dbo.RES_Getdate(@ctxt_ouinstance)
		begin
			--Contract Date should not be greater than current date, Pls Check
		  	select @m_errorid = 321213
			return
		
		end
	end
	else
	begin
		--Begin:Get Company Code
		exec 	scm_get_ou_company_code @ctxt_ouinstance,@company_code out ,@comp_return_val out
		if @comp_return_val = 1
		begin
		   select @m_errorid = @comp_return_val
		   return
		end
		select	@fb_id		= fb_id 
		from 	emod_finbook_vw(nolock) 
		where	company_code 	= @company_code 
		and	fb_type 	= 'MF'
		and	@cont_date between isnull(effective_from,'01/01/1900') 
		and 	isnull(effective_to,'12/12/9999')	
	
		exec	scm_get_dest_ou		@ctxt_ouinstance,
						@ctxt_language,
						@ctxt_user,
						'NSO',
						'FCC',
						@fcc_ou	out,
						@return_val	out
		if 	(@return_val <> 0)
		begin
			select	@m_errorid = @return_val
			return
		end	
	
		exec @m_errorid_tmp =	fcc_scm_spopfptrn1 @fcc_ou, @ctxt_language, @ctxt_user,
					'NSO', @fb_id, @cont_date, @m_errorid out
		
		if @m_errorid_tmp <> 0
		begin
			--<^orderdate!> "<%orderdate%>" is an invalid date. enter a valid date in this financial  year 
 		  	select @m_errorid = @m_errorid_tmp --320491
			return
		end
	
		exec @m_errorid_tmp =   fcc_scm_spdatetran1 @fcc_ou,@ctxt_language,
					'SHIP','NSO',@ctxt_user,@fb_id,@cont_date,@status out, @m_errorid out
		
		if	@m_errorid_tmp <> 0
		begin
			--<^orderdate!> "<%orderdate%>" is an invalid date. enter a valid date  in this financial  year 
			select @m_errorid = @m_errorid_tmp --320493		
			return
		end
	end


	if @chk_ref_doc = 1
	begin
		if rtrim(upper(@documentno)) is null
		begin
			-- reference doc number is null,please enter reference doc number
			select @m_errorid = 321019
			return
		end
		
		-- Check Ref.Doc Existence

		if  rtrim(upper(@documentno)) is not null and rtrim(upper(@contsourcedocument)) = 'QUO'
		begin

			if exists (select 'X' from qtn_quotation_hdr_vw (nolock)
				  where qhdr_ouinstance	in (select destinationouinstid from fw_admin_view_comp_intxn_model(nolock)
							    where sourcecomponentname 		= 	'NSO'
							    and	sourceouinstid		=	@ctxt_ouinstance
							   and	destinationcomponentname	=	'QUOTATION')
				  and  qhdr_quotnumber = rtrim(upper(@documentno)))
			
				select @contsourcedocument = rtrim(upper(@contsourcedocument))
			else
			begin
				--<^documentno!> "<%contsourcedocument%>" does not exist. enter a valid <^documentno!>
				select @m_errorid = 325069
				return
			end
		end
		
		--check for source document is in active status
		--DMS 41-NSODMS41SYTST_000053-Starts
		if  rtrim(upper(@documentno)) is not null and rtrim(upper(@contsourcedocument)) = 'QUO'
		begin
			if  exists (select 'X' from qtn_quotation_hdr_vw (nolock)
				   where qhdr_quotnumber = rtrim(upper(@documentno))
				   and   qhdr_status     ='AU'
				   and   qhdr_ouinstance  =@ctxt_ouinstance)		
			begin
				select @ctxt_ouinstance=@ctxt_ouinstance
			end
			else
			begin
				--raiserror('SOURCE DOCUMENT IS NOT IN AUTHORIZE STATUS',16,1)
				select @m_errorid = 35368886
				return
			end
			
				
		end
		--DMS 41-NSODMS41SYTST_000053-Ends
			
		
				
		if rtrim(upper(@documentno)) is not null and rtrim(upper(@contsourcedocument)) in ('BSO','AGR')
		begin
			if exists (select 'X' from so_contract_hdr (nolock)
				  where	conhdr_ou 		= @ctxt_ouinstance
				  and	conhdr_contract_no 	= rtrim(upper(@documentno))
				  and	conhdr_contract_type 	= rtrim(upper(@contsourcedocument)))
		
				select @contsourcedocument = @contsourcedocument
			else
			begin
				--<^documentno!> "<%contsourcedocument%>" does not exist. enter a valid <^documentno!>
				select @m_errorid = 325069
				return
			end
		end
	end

	if rtrim(upper(@customercode)) is null
	begin
		--<^customercode!> cannot be null. enter a valid <^customercode!>  
	  	select @m_errorid = 320212
		return	
	end

	--Begin :Get Lo and BU for Ou

	select @trandate_tmp = dbo.RES_Getdate(@ctxt_ouinstance)

	exec	scm_get_emod_details	@ctxt_ouinstance, 
					@trandate_tmp,
					@lo		out,
					@bu 		out, 
					@return_val 	out

	if (@return_val <> 0)
	begin
		select @m_errorid = @return_val
		return
	end

	--calling procedure for customer destination ou
	
	exec	scm_get_dest_ou	@ctxt_ouinstance,
				@ctxt_language,
				@ctxt_user,
				'NSO',
				'CU',
				@cust_ou	out,
				@return_val	out
	if 	(@return_val <> 0)
	begin
		select	@m_errorid = @return_val
		return
	end

	if rtrim(upper(@customercode)) is not null 
	begin
		--calling customercode validation procedure
		exec	scm_cust_ou_val	@ctxt_ouinstance,
					@ctxt_language,
					@ctxt_user,
					@ctxt_service,
					'NSO',
					0,  --cim flag
					@lo,
					@bu,
					@cust_ou,
					@customercode,
					0,
					@m_errorid_tmp out,             
					@error_msg_qualifier out,
					@m_error_flag out  

		if @m_error_flag <> 'S'
		begin			
			select @m_errorid = @m_errorid_tmp
			return
		end    
	end	

	--calling procedure for getting lo and bu for customer ou
	exec 	scm_get_emod_details @cust_ou,@trandate_tmp, @cust_lo out, @cust_bu out, @return_val out
	if 	(@return_val <> 0)
	begin
		select	@m_errorid = @return_val
		return
	end

	--defaulting order from id from the customer master.
	if @customeraddid is null
	begin
		select 	@customeraddid  = 	cou_order_from_id,
			@ship_to_cust	=	cou_dflt_shipto_cust,
			@ship_to_id	=	cou_dflt_shipto_id,
			@shipping_pt	=	cou_dflt_ship_pt,
			@trans_mode	=	cou_transport_mode
		from	cust_ou_info_vw (nolock)
		where	cou_lo		=	@cust_lo
		and	cou_bu		=	@cust_bu
		and	cou_ou		=	@cust_ou	
		and	cou_cust_code	=	rtrim(upper(@customercode))
	end		

	--fetching the default bill to customer from customercode
	if @billcustcode is null
	begin
		select 	@billcustcode 	= 	isnull(cou_dflt_billto_cust, @customercode)
		from	cust_ou_info_vw (nolock)
		where	cou_lo		=	@cust_lo
		and	cou_bu		=	@cust_bu
		and	cou_ou		=	@cust_ou	
		and	cou_cust_code	=	rtrim(upper(@customercode))
	end

	--fetching the default bill to id from customercode
	if @billtoaddid is null
	begin
		select 	@billtoaddid 	= 	cou_dflt_billto_id
		from	cust_ou_info_vw (nolock)
		where	cou_lo		=	@cust_lo
		and	cou_bu		=	@cust_bu
		and	cou_ou		=	@cust_ou	
		and	cou_cust_code	=	rtrim(upper(@billcustcode))
	end

	--address id validation
	if @customeraddid is not null
	begin
		--calling address id validation procedure
		exec	scm_cust_add_id_val	@ctxt_ouinstance, 
						@ctxt_language,
						@ctxt_user,
						@ctxt_service, 
						'NSO', 		
						@lo,								
						@customercode,
						@customeraddid,
						0,
						@m_errorid_tmp output,								
						@error_msg_qualifier output ,
						@m_error_flag	output 

		if	@m_error_flag <> 'S'
		begin				
			select @m_errorid = @m_errorid_tmp
			return					
		end
	end

	select 	@ship_to_cust	=	isnull(cou_dflt_shipto_cust,@customercode) ,
		@ship_to_id	=	isnull(cou_dflt_shipto_id, @customeraddid),
		@shipping_pt	=	cou_dflt_ship_pt,
		@trans_mode	=	cou_transport_mode
	from	cust_ou_info_vw (nolock)
	where	cou_lo		=	@cust_lo
	and	cou_bu		=	@cust_bu
	and	cou_ou		=	@cust_ou	
	and	cou_cust_code	=	rtrim(upper(@customercode))

	if ( @shipping_pt is null )
	begin 
		select	@shipping_pt	=	parameter_value
		from	so_sys_param_ou_vw(nolock)
		where	ouid		=	@ctxt_ouinstance
		and	component_name	=	'NSO'
		and	parameter_code	=	'SO_DEF_SHP_POINT'
	end
/* Begins - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/
 if @cuspono is null
 begin 
	raiserror('Customer PO is Mandatory',16,1)
	return

 end
/* ENDS - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/
	if rtrim(upper(@cuspono)) is not null
	begin
		if @customerpodate is null
		begin
			--enter the <^customerpodate!> 
		  	select @m_errorid = 320214
			return
		end
	end

	if @customerpodate is not null
	begin
		if rtrim(upper(@cuspono)) is  null
		begin
			--enter the <^cuspono!> 
	  		select @m_errorid = 320215
			return
		end
	end
	
	--DMS 41-OTS NO:NSODMS41SYTST_000043 STARTS HERE
	--To check whether customerpo date is greater than the contract creation date
	if @customerpodate is not null
	begin
		if(@customerpodate > @trandate_tmp)
		begin
			
                        --raiserror('customerpodate less than creation date',16,1)
                        select @m_errorid = 35368885
			   return
		end
	end
	--DMS 41 OTS NO:NSODMS41SYTST_000043 Ends HERE

	if rtrim(upper(@spcode)) is not null
	begin
;
WITH SQLTMP (destinationouinstid1) as (SELECT DISTINCT SQL2K51.destinationouinstid
 	 FROM fw_admin_view_comp_intxn_model SQL2K51 (NOLOCK) 
 	 WHERE SQL2K51.sourcecomponentname = 'NSO' and 
		SQL2K51.sourceouinstid = @ctxt_ouinstance and 
		SQL2K51.destinationcomponentname = 'SP' )

	SELECT @sp_status =  sp_status
 	 FROM sp_salesperson_vw (NOLOCK) JOIN 
		 SQLTMP 
		 ON ( sp_ou = SQLTMP.destinationouinstid1 )
 	 WHERE RTRIM (UPPER ( sp_code) ) = RTRIM (UPPER (@spcode) ) and 
		 sp_status = 'AC'
--ToolComment		select	@sp_status = sp_status
--ToolComment		from	sp_salesperson_vw (nolock)
--ToolComment		where	sp_ou 	in 	(select destinationouinstid from fw_admin_view_comp_intxn_model(nolock)  
--ToolComment					where	sourcecomponentname      	='NSO'  
--ToolComment					and   	sourceouinstid          	= @ctxt_ouinstance
--ToolComment					and   	destinationcomponentname  	= 'SP')
--ToolComment		and	rtrim(upper(sp_code))		= rtrim(upper(@spcode))
--ToolComment		and	sp_status			= 'AC'
--ToolComment
		if rtrim(upper(@sp_status)) is null
		begin
			--<^spcode!> "<%spcode%>" does not exist. enter a valid <^spcode!> 
  			select @m_errorid = 320211
			return
		end
		if rtrim(upper(@sp_status)) <> 'AC'
		begin
			--Sales Person code is not in Active status, Please Check
			select @m_errorid = 325159
			return
		end

;
WITH SQLTMP (destinationouinstid1) as (SELECT DISTINCT SQL2K51.destinationouinstid
 	 FROM fw_admin_view_comp_intxn_model SQL2K51 (NOLOCK) 
 	 WHERE SQL2K51.sourcecomponentname = 'NSO' and 
		SQL2K51.sourceouinstid = @ctxt_ouinstance and 
		SQL2K51.destinationcomponentname = 'SP' )

	SELECT @so_spname_tmp = ISNULL ( sp_firstname , '') 
 	 FROM sp_salesperson_vw (NOLOCK) JOIN 
		 SQLTMP 
		 ON ( sp_ou = SQLTMP.destinationouinstid1 )
 	 WHERE  sp_code = RTRIM (UPPER (@spcode) ) and 
		 sp_status = 'AC'
--ToolComment		select	@so_spname_tmp = isnull(sp_firstname,'') 
--ToolComment		from	sp_salesperson_vw (nolock)
--ToolComment		where	sp_ou in (select destinationouinstid from fw_admin_view_comp_intxn_model(nolock)
--ToolComment				 where  sourcecomponentname 		= 'NSO'
--ToolComment				 and	sourceouinstid			= @ctxt_ouinstance
--ToolComment				 and	destinationcomponentname	= 'SP')
--ToolComment		and	sp_code		= rtrim(upper(@spcode))
--ToolComment		and	sp_status	= 'AC'
	end

	if rtrim(upper(@stcode)) is not null
	begin
;
WITH SQLTMP (destinationouinstid1) as (SELECT DISTINCT SQL2K51.destinationouinstid
 	 FROM fw_admin_view_comp_intxn_model SQL2K51 (NOLOCK) 
 	 WHERE SQL2K51.sourcecomponentname = 'NSO' and 
		SQL2K51.sourceouinstid = @ctxt_ouinstance and 
		SQL2K51.destinationcomponentname = 'SP' )

	SELECT @sp_status =  st_status
 	 FROM sp_salesteam_vw (NOLOCK) JOIN 
		 SQLTMP 
		 ON ( st_ou = SQLTMP.destinationouinstid1 )
 	 WHERE RTRIM (UPPER ( st_code) ) = RTRIM (UPPER (@stcode) ) and 
		
		 st_status = 'AC'
--ToolComment		select	@sp_status = st_status
--ToolComment		from	sp_salesteam_vw (nolock)  
--ToolComment		where 	rtrim(upper(st_code)) = rtrim(upper(@stcode))			    	
--ToolComment		and 	st_ou in (select destinationouinstid from fw_admin_view_comp_intxn_model(nolock)  
--ToolComment				  where	sourcecomponentname = 'NSO'
--ToolComment				  and  	sourceouinstid   = @ctxt_ouinstance
--ToolComment				  and  	destinationcomponentname= 'SP')
--ToolComment		and	st_status = 'AC'
--ToolComment	
		if rtrim(upper(@sp_status)) is null
		begin
			--<^stcode!> "<%stcode%>" does not exist. enter a valid <^stcode!> 
  			select @m_errorid = 320210
			return
		end
			
		if rtrim(upper(@sp_status)) <> 'AC'
		begin
			--Sales Team code is not in Active status, Please Check
			select @m_errorid = 325160
			return
		end
			
;
WITH SQLTMP (destinationouinstid1) as (SELECT DISTINCT SQL2K51.destinationouinstid
 	 FROM fw_admin_view_comp_intxn_model SQL2K51 (NOLOCK) 
 	 WHERE SQL2K51.sourcecomponentname = 'NSO' and 
		SQL2K51.sourceouinstid = @ctxt_ouinstance and 
		SQL2K51.destinationcomponentname = 'SP' )

	SELECT @so_stname_tmp = ISNULL ( st_desc , '') 
 	 FROM sp_salesteam_vw (NOLOCK) JOIN 
		 SQLTMP 
		 ON ( st_ou = SQLTMP.destinationouinstid1 )
 	 WHERE  st_code = RTRIM (UPPER (@stcode) ) and 
		 st_status = 'AC'
--ToolComment		select	@so_stname_tmp = isnull(st_desc,'')
--ToolComment		from	sp_salesteam_vw (nolock)
--ToolComment		where	st_ou 	in (select destinationouinstid from 	fw_admin_view_comp_intxn_model(nolock)
--ToolComment				   where   sourcecomponentname 		= 	'NSO'
--ToolComment				   and	   sourceouinstid		=	@ctxt_ouinstance
--ToolComment				   and	   destinationcomponentname	=	'SP')
--ToolComment			and	st_code	= rtrim(upper(@stcode))
--ToolComment			and	st_status		= 'AC'
	end

	if(@cont_no is null)
	begin
		exec dnm_gen_tranno_sp @ctxt_language,@ctxt_ouinstance,@ctxt_service,
		@ctxt_user,'NSO','SAL_CON',@num_series,@cont_date,@cont_no out,@m_errorid_tmp out,@execflag out
	
		select @cont_no = rtrim(upper(@cont_no))
		if @m_errorid_tmp <> 0
		begin
			select @m_errorid = @m_errorid_tmp
			return
		end
	end

	if exists (select 'X' from so_contract_hdr (nolock)
		  where	conhdr_ou 		= @ctxt_ouinstance
		  and	conhdr_contract_no	= @cont_no)
	begin
		--Contract No. Already exists, pls Check
		select @m_errorid =  321220
		return
	end

	select	@currencycode	=	cbu_dflt_currency
	from	cust_bu_info_vw(nolock)
	where	cbu_lo		=	@lo
	and	cbu_bu		=       @bu
	and	cbu_cust_code	=	rtrim(upper(@customercode))

	select	@eratetype	=	parameter_value
	from	so_sys_param_ou_vw(nolock)
	where	ouid		=	@ctxt_ouinstance
	and	component_name	=	'NSO'
	and	parameter_code	=	'SO_EXRATE_TYPE'


	if @currencycode is null
	begin
		exec scm_get_compbasecur @ctxt_ouinstance,@todate,@company_code,@currencycode out,@Cur_return_value out
		if @cur_return_value = 1
 		begin
			select @m_errorid = @cur_return_value
			return
   		end
	end
	
	--Fetching the exchange rate for currency
	execute scm_sale_exch_rate @ctxt_ouinstance,@ctxt_language,@ctxt_user,@ctxt_service,'NSO',@currencycode,@todate,@eratetype,0,@exchangerate out,@return_val  out,@error_msg_qualifier out,@m_error_flag out
	if (@return_val <> 0)
	begin
		select	@m_errorid = @return_val
		return
	end

	insert into so_contract_hdr
		(conhdr_ou,
		conhdr_contract_no,
		conhdr_amend_no,
		conhdr_contract_type,
		conhdr_contract_date,
		conhdr_num_series,
		conhdr_status,
		conhdr_prev_status,
		conhdr_folder,
		conhdr_contract_desc,
		conhdr_cust_ou,
		conhdr_order_from_cust,
		conhdr_order_from_id,
		conhdr_bill_to_cust,
		conhdr_bill_to_id,
		conhdr_cust_po_no,
		conhdr_cust_po_date,
		conhdr_contact_person,
		conhdr_ref_doc_type,
		conhdr_ref_doc_no,
		conhdr_sales_person,
		conhdr_sales_team,
		conhdr_reason_code,
		conhdr_authorize_by,
		conhdr_authorize_date,
		conhdr_amended_by,
		conhdr_amended_date,
		conhdr_addln_fld1,
		conhdr_addln_fld2,
		conhdr_addln_fld3,
		conhdr_created_by,
		conhdr_created_date,
		conhdr_modified_by,
		conhdr_modified_date,
		conhdr_timestamp
		/* Code added for EPE-60232 Begins */
		,conhdr_resasonforreturn
		--conhdr_workflowstatus	--Code commented for EPE-60232
		)	
		/* Code added for EPE-60232 Ends */
	
	values 
		(@ctxt_ouinstance,
		 rtrim(upper(@cont_no)),
		 0,
		 rtrim(upper(@cont_type)),
		 @cont_date,
		 rtrim(upper(@num_series)),
		 'DR',
		 NULL,
		 rtrim(upper(@folderid )),
		 rtrim(@cont_desc),
		 @cust_ou,
		 rtrim(@customercode),
		 rtrim(@customeraddid),
	         rtrim(@billcustcode) ,
	         rtrim(@billtoaddid),
	 	 rtrim(@cuspono),
	 	 @customerpodate,
	 	 rtrim(@contactperson),
		 rtrim(@contsourcedocument),
		 case @chk_ref_doc 
		 when 1 then rtrim(@documentno)
		 else null	
		 end ,
		 rtrim(@spcode),
	         rtrim(@stcode),
		 NULL,
		 NULL,
		 NULL,
		 NULL,
		 NULL,
		 NULL,
		 NULL,
		 NULL,
		 rtrim(@ctxt_user),
		 dbo.RES_Getdate(@ctxt_ouinstance),
		 rtrim(@ctxt_user),
		 dbo.RES_Getdate(@ctxt_ouinstance),
		 1
		 /* Code added for EPE-60232 Begins */
		 ,Null
		 --null		--Code Commented for 60232
		 )
		 /* Code added for EPE-60232 Ends */
	
	-- Check if the Reference Document is BSO and the Current Contract Type is also BSO.
	-- If BSO, Copy BSO Header / Item / Schedule Details 
	-- From Reference Document Onto the Current Document

	if @chk_ref_doc = 1
	begin
		if rtrim(upper(@contsourcedocument)) = 'BSO' and rtrim(upper(@cont_type)) = 'BSO'
		begin
			insert into  so_blanket_order_hdr
				(bsohdr_ou,
				bsohdr_contract_no,
				bsohdr_bso_type,
				bsohdr_so_num_series,
				bsohdr_sales_channel,
				bsohdr_currency_no,
				bsohdr_exch_rate,
				bsohdr_payterm_ou,
				bsohdr_pay_term_code,
				bsohdr_payterm_amend_no,
				bsohdr_effective_date,
				bsohdr_expiry_date,
				bsohdr_pricing_date,
				bsohdr_bso_value,
				bsohdr_value_ordered,
				bsohdr_num_orders,
				bsohdr_req_date_dflt,
				bsohdr_prm_date_dflt,
				bsohdr_trans_mode_dflt,
				bsohdr_ship_point_dflt,
				bsohdr_wh_no_dflt,
				bsohdr_ship_to_cust_dflt,
				bsohdr_ship_to_id_dflt,
				bsohdr_addln_fld1,
				bsohdr_addln_fld2,
				bsohdr_addln_fld3,
				bsohdr_created_by,
				bsohdr_created_date,
				bsohdr_modified_by,
				bsohdr_modified_date)

			select	@ctxt_ouinstance,
				upper(@cont_no),
				bsohdr_bso_type,
				bsohdr_so_num_series,
				bsohdr_sales_channel,
				bsohdr_currency_no,
				bsohdr_exch_rate,
				bsohdr_payterm_ou,
				bsohdr_pay_term_code,
				bsohdr_payterm_amend_no,
				bsohdr_effective_date,
				bsohdr_expiry_date,
				bsohdr_pricing_date,
				bsohdr_bso_value,
				0.00,
				0,
				bsohdr_req_date_dflt,
				bsohdr_prm_date_dflt,
				bsohdr_trans_mode_dflt,
				bsohdr_ship_point_dflt,
				bsohdr_wh_no_dflt,
				bsohdr_ship_to_cust_dflt,
				bsohdr_ship_to_id_dflt,
				bsohdr_addln_fld1,
				bsohdr_addln_fld2,
				bsohdr_addln_fld3,
				rtrim(upper(@ctxt_user)),
				dbo.RES_Getdate(@ctxt_ouinstance),
				rtrim(upper(@ctxt_user)),
				dbo.RES_Getdate(@ctxt_ouinstance)
			from	so_blanket_order_hdr(nolock)
			where	bsohdr_ou		= @ctxt_ouinstance
			and	bsohdr_contract_no	= rtrim(upper(@documentno))

			insert into so_blanket_item_dtl
				(bsodet_ou,
				bsodet_contract_no,
				bsodet_line_no,
				bsodet_ref_doc_line_no,
				bsodet_sch_type,
				bsodet_item_type,
				bsodet_item_code,
				bsodet_item_variant,
				bsodet_cust_item_code,
				bsodet_model_config_code,
				bsodet_model_config_var,
				bsodet_uom,
				bsodet_bso_qty,
				bsodet_ordered_qty,
				bsodet_sales_price,
				bsodet_total_item_price,
				bsodet_ship_point,
				bsodet_ship_to_cust,
				bsodet_ship_to_id,
				bsodet_wh_no,
				bsodet_req_date,
				bsodet_prm_date,
				bsodet_trans_mode,
				bsodet_line_status,
				bsodet_addln_fld1,
				bsodet_addln_fld2,
				bsodet_addln_fld3,
				bsodet_created_by,
				bsodet_created_date,
				bsodet_modified_by,
				bsodet_modified_date)
		
			select	@ctxt_ouinstance,
				rtrim(upper(@cont_no)),
				bsodet_line_no,	
				bsodet_ref_doc_line_no,
				bsodet_sch_type,
				bsodet_item_type,
				bsodet_item_code,
				bsodet_item_variant,
				bsodet_cust_item_code,
				bsodet_model_config_code,
				bsodet_model_config_var,
				bsodet_uom,
				bsodet_bso_qty,
				0,
				bsodet_sales_price,
				bsodet_total_item_price,
				bsodet_ship_point,
				bsodet_ship_to_cust,
				bsodet_ship_to_id,
				bsodet_wh_no,
				bsodet_req_date,
				bsodet_prm_date,
				bsodet_trans_mode,
				bsodet_line_status,
				bsodet_addln_fld1,
				bsodet_addln_fld2,
				bsodet_addln_fld3,
				rtrim(@ctxt_user),
				dbo.RES_Getdate(@ctxt_ouinstance),
				@ctxt_user,
				dbo.RES_Getdate(@ctxt_ouinstance)
			from	so_blanket_item_dtl(nolock)	
			where	bsodet_ou		= @ctxt_ouinstance
			and	bsodet_contract_no	= rtrim(upper(@documentno))	

			insert into so_blanket_sch_dtl
				(bsosch_ou,
				bsosch_contract_no,
				bsosch_line_no,
				bsosch_sch_no,
				bsosch_item_type,
				bsosch_item_code,
				bsosch_item_variant,
				bsosch_uom,
				bsosch_bso_qty,
				bsosch_ordered_qty,
				bsosch_req_date,
				bsosch_prm_date,
				bsosch_ship_point,
				bsosch_wh_no,
				bsosch_ship_to_cust,
				bsosch_ship_to_id,
				bsosch_trans_mode,
				bsosch_sch_status,
				bsosch_addln_fld1,
				bsosch_addln_fld2,
				bsosch_addln_fld3,
				bsosch_created_by,
				bsosch_created_date,
				bsosch_modified_by,
				bsosch_modified_date)	

			select	@ctxt_ouinstance,
				rtrim(upper(@cont_no)),
				bsosch_line_no,
				bsosch_sch_no,
				bsosch_item_type,
				bsosch_item_code,
				bsosch_item_variant,
				bsosch_uom,
				bsosch_bso_qty,
				0,
				bsosch_req_date,
				bsosch_prm_date,
				bsosch_ship_point,
				bsosch_wh_no,
				bsosch_ship_to_cust,
				bsosch_ship_to_id,
				bsosch_trans_mode,
				bsosch_sch_status,
				bsosch_addln_fld1,
				bsosch_addln_fld2,
				bsosch_addln_fld3,
				rtrim(upper(@ctxt_user)),
				dbo.RES_Getdate(@ctxt_ouinstance),
				rtrim(upper(@ctxt_user)),
				dbo.RES_Getdate(@ctxt_ouinstance)
			from 	so_blanket_sch_dtl(nolock)
			where	bsosch_ou		= @ctxt_ouinstance
			and	bsosch_contract_no	= rtrim(upper(@documentno))
		end

		select	@qtn_ou  = qhdr_ouinstance
		from	qtn_quotation_hdr_vw (nolock)
		where	qhdr_quotnumber = rtrim(upper(@documentno))
	
		select	@ptermou = qhdr_payterm_ou,
			@ptcode  = qhdr_payterm
		from	qtn_quotation_hdr_new_vw (nolock)
		where	qhdr_ou		= @qtn_ou
		and	qhdr_qtn_no	= rtrim(upper(@documentno))
		
		select	@ptamenno = max(pt_version_no)
		from	pt_payterm_header_vw (nolock)
		where	pt_ouinstance = @ptermou
		and	pt_paytermcode = rtrim(upper(@ptcode))
	
		if rtrim(upper(@contsourcedocument)) = 'QUO' and rtrim(upper(@cont_type)) = 'BSO'
		begin
			select 	@so_num_series = rtrim(no_type) 
			from	dnm_trans_notype_vw (nolock)
			where 	ouinstance      = @ctxt_ouinstance
			and 	trantype_code 	= 'SAL_NSO'
			and 	no_type 	<> '~MANUAL~'
			and 	default_type	= 'Y'

		/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00033 starts here*/	
			select	@tran_date = dbo.RES_Getdate(@ctxt_ouinstance)
			
			select	@warehousecode	= qdtl_warehouse,
				@item_code	= qdtl_item_code,
				@item_variant	= qdtl_variant_code,
				@item_ou	= qdtl_item_ou		
			from	qtn_quotation_dtl_new_vw (nolock)
			where	qdtl_ou     	= @qtn_ou
			and	qdtl_qtn_no	= rtrim(upper(@documentno))

			--calling procedure for getting lo and bu to the customer ou
			exec 	scm_get_emod_details	@item_ou, 
							@tran_date,
							@item_lo out, 
							@item_bu out, 
							@return_val out
			if 	(@return_val <> 0)
			begin
				exec fin_german_raiserror_sp 'NSO',@ctxt_language,83
				return
			end

			if (@warehousecode is null)
			begin
				if exists(	select	'X'
						from	item_var_ou_vw(nolock)
						where	lo		=	@item_lo
						and	bu		=	@item_bu
					--	and	ou		=	@item_ou /* Begins - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/
						and	item_code	=	@item_code
						and	variant_code	=	@item_variant
						and	status_code	=	'AC'
					 )
				begin
					select	@warehousecode	=	std_wh_code 
					from	item_var_ou_vw(nolock)
					where	lo		=	@item_lo
					and	bu		=	@item_bu
					--and	ou		=	@item_ou /* Begins - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/
					and	item_code	=	@item_code
					and	variant_code	=	@item_variant
					and	status_code	=	'AC'
				end
				else
				begin
					--Standard warehouse not in active status. Please check
					exec fin_german_raiserror_sp 'NSO',@ctxt_language,86
					return
				end
			end
		/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00033 ends here*/
			
			insert into  so_blanket_order_hdr
				(bsohdr_ou,
				bsohdr_contract_no,
				bsohdr_bso_type,
				bsohdr_so_num_series,
				bsohdr_sales_channel,
				bsohdr_currency_no,
				bsohdr_exch_rate,
				bsohdr_payterm_ou,
				bsohdr_pay_term_code,
				bsohdr_payterm_amend_no,
				bsohdr_effective_date,
				bsohdr_expiry_date,
				bsohdr_pricing_date,
				bsohdr_bso_value,
				bsohdr_value_ordered,
				bsohdr_num_orders,
				bsohdr_req_date_dflt,
				bsohdr_prm_date_dflt,
				bsohdr_trans_mode_dflt,
				bsohdr_ship_point_dflt,
				bsohdr_wh_no_dflt,
				bsohdr_ship_to_cust_dflt,
				bsohdr_ship_to_id_dflt,
				bsohdr_addln_fld1,
				bsohdr_addln_fld2,
				bsohdr_addln_fld3,
				bsohdr_created_by,
				bsohdr_created_date,
				bsohdr_modified_by,
				bsohdr_modified_date)
	
			select	@ctxt_ouinstance,
				rtrim(upper(@cont_no)),
				'NSO',
				@so_num_series,
				qhdr_sales_channel,
				qhdr_currency,
				qhdr_exchange_rate,
				@ptermou,
				@ptcode,
				@ptamenno, --bsohdr_payterm_amend_no
				qhdr_qtn_valid_till, --bsohdr_effective_date
				null, --bsohdr_expiry_date
				dbo.RES_Getdate(@ctxt_ouinstance), --bsohdr_pricing_date
				qhdr_total_value,--bsohdr_bso_value 
				0,--bsohdr_value_ordered
				0,--bsohdr_num_orders
				null, --bsohdr_req_date_dflt
				null, --bsohdr_prm_date_dflt
				qhdr_shipment_mode, --bsohdr_trans_mode_dflt
				null,--bsohdr_ship_point_dflt
				null, --bsohdr_wh_no_dflt
				null, --bsohdr_ship_to_cust_dflt 
				null,--bsohdr_ship_to_id_dflt
				null,
				null,
				null,
				@ctxt_user,
				dbo.RES_Getdate(@ctxt_ouinstance),
				@ctxt_user,
				dbo.RES_Getdate(@ctxt_ouinstance)
			from	qtn_quotation_hdr_new_vw(nolock)
			where	qhdr_ou	 	= @qtn_ou
			and	qhdr_qtn_no	= rtrim(upper(@documentno))
	
			insert into  so_blanket_item_dtl
				(bsodet_ou,
				bsodet_contract_no,
				bsodet_line_no,
				bsodet_ref_doc_line_no,
				bsodet_sch_type,
				bsodet_item_type,
				bsodet_item_code,
				bsodet_item_variant,
				bsodet_cust_item_code,
				bsodet_model_config_code,
				bsodet_model_config_var,
				bsodet_uom,
				bsodet_bso_qty,
				bsodet_ordered_qty,
				bsodet_sales_price,
				bsodet_total_item_price,
				bsodet_ship_point,
				bsodet_ship_to_cust,
				bsodet_ship_to_id,
				bsodet_wh_no,
				bsodet_req_date,
				bsodet_prm_date,
				bsodet_trans_mode,
				bsodet_line_status,
				bsodet_addln_fld1,
				bsodet_addln_fld2,
				bsodet_addln_fld3,
				bsodet_created_by,
				bsodet_created_date,
				bsodet_modified_by,
				bsodet_modified_date)
	
			select	@ctxt_ouinstance,
				rtrim(upper(@cont_no)),
				qdtl_line_no,
				qdtl_line_no,
				qdtl_sch_type,
				qdtl_item_type,
				qdtl_item_code,
				case qdtl_item_type
					when 'M' then '##'
					else qdtl_variant_code
				end,
				qdtl_cust_prod_code,
				qdtl_item_code,
				case qdtl_item_type
					when 'M' then qdtl_variant_code
					else null
				end,
				qdtl_sale_uom,
				qdtl_quoted_qty,
				0.00,
				qdtl_quoted_price,
				isnull(qdtl_per_item_price,0),
				isnull(qdtl_shipping_point,@shipping_pt),
				isnull(qdtl_ship_to_customer,rtrim(@ship_to_cust)),
				isnull(qdtl_ship_to_addid,@ship_to_id),
				isnull(qdtl_warehouse,@warehousecode),--Modified for DTS ID: DMS412AT_NSO_00033
				qdtl_sch_date,
				qdtl_promised_date,
				@trans_mode,	
				qdtl_status,
				null,
				null,
				null,
				@ctxt_user,
				dbo.RES_Getdate(@ctxt_ouinstance),
				@ctxt_user,
				dbo.RES_Getdate(@ctxt_ouinstance)
			from	qtn_quotation_dtl_new_vw (nolock)
			where	qdtl_ou     	= @qtn_ou
			and	qdtl_qtn_no	= rtrim(upper(@documentno))
	
			insert into so_blanket_sch_dtl
				(bsosch_ou,
				bsosch_contract_no,
				bsosch_line_no,
				bsosch_sch_no,
				bsosch_item_type,
				bsosch_item_code,
				bsosch_item_variant,
				bsosch_uom,
				bsosch_bso_qty,
				bsosch_ordered_qty,
				bsosch_req_date,
				bsosch_prm_date,
				bsosch_ship_point,
				bsosch_wh_no,
				bsosch_ship_to_cust,
				bsosch_ship_to_id,
				bsosch_trans_mode,
				bsosch_sch_status,
				bsosch_addln_fld1,
				bsosch_addln_fld2,
				bsosch_addln_fld3,
				bsosch_created_by,
				bsosch_created_date,
				bsosch_modified_by,
				bsosch_modified_date)	
	
			select	@ctxt_ouinstance,
				rtrim(upper(@cont_no)),
				qsch_line_no,
				qsch_sch_line_no,
				qsch_item_type,
				qsch_item_code,
				case qsch_item_type
				when 'M' then '##'
				else qsch_variant_code
				end,
				qsch_sale_uom,
				qsch_required_qty, 
				0.0,
				isnull(qsch_required_date, @todate),
				case	when isnull(qdtl_promised_date, '01/01/1900') > @todate then qdtl_promised_date
					else @todate
				end,

				isnull(qsch_shipping_point,@shipping_pt),
				isnull(qsch_warehouse,@warehousecode), --Modified for DTS ID: DMS412AT_NSO_00033
				isnull(qsch_ship_to_customer,rtrim(@ship_to_cust)),
				isnull(qsch_ship_to_addid,@ship_to_id),
				@trans_mode, 
				qsch_status,
				null,--bsosch_addln_fld1,
				null,--bsosch_addln_fld2,
				null,--bsosch_addln_fld3,
				@ctxt_user,
				dbo.RES_Getdate(@ctxt_ouinstance),
				@ctxt_user,
				dbo.RES_Getdate(@ctxt_ouinstance)	
			from	qtn_sch_dtl_vw (nolock),
				qtn_quotation_dtl_new_vw (nolock)
			where	qsch_ou     	= @qtn_ou
			and	qsch_qtn_no	= rtrim(upper(@documentno))
			and	qdtl_ou		=	qsch_ou
			and	qdtl_qtn_no	=	qsch_qtn_no
			and	qdtl_line_no	=	qsch_line_no
			
		end

		if rtrim(upper(@contsourcedocument)) = 'AGR' and rtrim(upper(@cont_type)) = 'AGR'
		begin
/*Modification starts here for the issue NSOBGL_000020*/
			insert into so_agreement_dtl
				(agrdet_ou,
				agrdet_contract_no,
				agrdet_line_no,
				agrdet_effective_date,
				agrdet_expiry_date,
				agrdet_currency,
				agrdet_price_list_no,
				agrdet_pay_term_code,
				agrdet_addln_fld1,
				agrdet_addln_fld2,
				agrdet_addln_fld3,
				agrdet_created_by,
				agrdet_created_date,
				agrdet_modified_by,
				agrdet_modified_date,
				agrdet_pricelist_amend_no,
				agrdet_payterm_amend_no,
				agrdet_payterm_ou )
	
			select	@ctxt_ouinstance,
				rtrim(upper(@cont_no)),
				agrdet_line_no,
				agrdet_effective_date,
				agrdet_expiry_date,
				agrdet_currency,
				agrdet_price_list_no,
				agrdet_pay_term_code,
				agrdet_addln_fld1,
				agrdet_addln_fld2,
				agrdet_addln_fld3,
				agrdet_created_by,
				agrdet_created_date,
				agrdet_modified_by,
				agrdet_modified_date,
				agrdet_pricelist_amend_no,
				agrdet_payterm_amend_no,
				agrdet_payterm_ou 
			from	so_agreement_dtl (nolock)
			where	agrdet_ou 		= @ctxt_ouinstance
			and	agrdet_contract_no	= rtrim(upper(@documentno)) 
/*Modification ends here for the issue NSOBGL_000020*/
		end	  
	end

	if rtrim(upper(@cont_type)) = 'BSO'
	begin
		if  exists (select 'X' from so_blanket_order_hdr(nolock)
			   where bsohdr_ou = @ctxt_ouinstance
			   and   bsohdr_contract_no = rtrim(upper(@cont_no)))
	
			  select @cont_no = @cont_no
		else
		begin
			insert into  so_blanket_order_hdr
				(bsohdr_ou,
				bsohdr_contract_no,
				bsohdr_bso_type,
				bsohdr_sales_channel,
				bsohdr_currency_no,
				bsohdr_exch_rate,
				bsohdr_pay_term_code,
				bsohdr_effective_date,
				bsohdr_expiry_date,
				bsohdr_pricing_date,
				bsohdr_bso_value,
				bsohdr_value_ordered,
				bsohdr_num_orders,
				bsohdr_addln_fld1,
				bsohdr_addln_fld2,
				bsohdr_addln_fld3,
				bsohdr_created_by,
				bsohdr_created_date,
				bsohdr_modified_by,
				bsohdr_modified_date,
				bsohdr_trans_mode_dflt)  --code added for RTTIPL-20
			values	(@ctxt_ouinstance,
				rtrim(upper(@cont_no)),
				'NSO',
				null,
				@currencycode,
				@exchangerate,
				null,
				null,
				null,
				null,
				0,
				0,
				0,
				null,
				null,
				null,
				@ctxt_user,
				dbo.RES_Getdate(@ctxt_ouinstance),
				@ctxt_user,
				dbo.RES_Getdate(@ctxt_ouinstance),
				@trans_mode) --code added for RTTIPL-20
		end
	end



	select	@so_custname_tmp = clo_cust_name
	from	cust_lo_info_vw (nolock)
	where	clo_lo 		= @lo
	and	clo_cust_code	= rtrim(upper(@customercode))

	/*Code added for ES_PRJBDPRO_00160 begins here*/
	if	@ctxt_service	=	'bpr_mntpr_ser_genq'
	begin
		update	prjproposal_hdr
		set		mtrrp_contractno	=	@cont_no
		where	mtprp_proposalid	=	@hidden_control1
		and		mtprp_ouid			=	@ctxt_ouinstance	
	
		return
	end

	/*Code added for ES_PRJBDPRO_00160 ends here*/

	--the follwoing success message is is added by muthukumar c on 19/11/2004
	--for the bug id NSO411UISTD_000003
        --raiserror ('Contract Saved Successfully',10,1)
        select @m_errorid = 325331

	select 	rtrim(conhdr_bill_to_cust)		'BILLCUSTCODE', 
		rtrim(conhdr_bill_to_id)      		'BILLTOADDID', 
		rtrim(@chk_ref_doc)			'CHK_REF_DOC',
		conhdr_contract_date      		'CONT_DATE',
		rtrim(conhdr_contract_desc)      	'CONT_DESC',
		rtrim(conhdr_contract_no)      		'CONT_NO',
		rtrim(conhdr_contract_type)      	'CONT_TYPE',
		rtrim(conhdr_contact_person)      	'CONTACTPERSON',
		rtrim(conhdr_ref_doc_type)      	'CONTSOURCEDOCUMENT',
		rtrim(conhdr_created_by)      		'CR_BY',
		conhdr_created_date      		'CREATEDDATE',
		rtrim(conhdr_cust_po_no)    		'CUSPONO',
		rtrim(@cust_name)     			'CUST_NAME',
		rtrim(conhdr_order_from_id)      	'CUSTOMERADDID',
		rtrim(conhdr_order_from_cust)      	'CUSTOMERCODE',
		conhdr_cust_po_date      		'CUSTOMERPODATE',
		rtrim(@documentno)     			'DOCUMENTNO',
		rtrim(conhdr_folder)		      	'FOLDERID',
		rtrim(@guid)				'GUID',
		''					'HIDDEN_CONTROL1',
		''      				'HIDDEN_CONTROL2',
		rtrim(conhdr_num_series)	      	'NUM_SERIES',
		rtrim(paramdesc)	      		'ORD_CONT_STATUS',
		rtrim(@ref_doc_name)      		'REF_DOC_NAME',
		rtrim(conhdr_ref_doc_no)      		'REFDOCNO',
		rtrim(conhdr_sales_person)      	'SPCODE',
		rtrim(@so_spname_tmp)      		'SPNAME',
		rtrim(conhdr_sales_team)      		'STCODE',
		rtrim(@so_stname_tmp)      		'STNAME1',
		0      					'FPROWNO'	
		 /* Code added for EPE-60232 Begins */
		 ,conhdr_resasonforreturn   'reason_for_return',
		 /* Code commented for EPE-60232 Begins */
		 --case when 
		 --conhdr_workflowstatus <> 'AMD' then conhdr_workflowstatus
		 -- else	
		 -- dbo.wf_metadesc_fet_fn('NSOCO',null) 
		 -- end	'workflow_status'
		  /* Code commented for EPE-60232 ends */
		  dbo.wf_metadesc_fet_fn('NSOCO',null) 'workflow_status'
		/* Code added for EPE-60232 Ends*/

	from	so_contract_hdr (nolock),
		so_comp_metadata_vw (nolock)
	where	conhdr_ou 		= @ctxt_ouinstance
	and	conhdr_contract_no    	= rtrim(upper(@cont_no))
	and	componentname 		= 'NSO'
	and     paramcategory		= 'STATUS'
	and	paramtype		= 'SO_STATUS'
	and	paramcode		= conhdr_status
	and	langid			= @ctxt_language


/*code added by Priya R  for the defect id  NSOBASEFIXES_000764 on 05/08/2005 begins here*/
	SELECT  @m_errorid =   325331 
/*code added by Priya R  for the defect id  NSOBASEFIXES_000764 on 05/08/2005 ends here*/
end












