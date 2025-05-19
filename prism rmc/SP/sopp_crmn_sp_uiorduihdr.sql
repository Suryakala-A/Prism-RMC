/*$File_version=ms4.3.0.11$*/
/* VERSION NO: PPS4.1.0.000 */

/******************************************************************************************
file name 	: sopp_crmn_sp_uiorduihdr.sql
version		: 4.0.0.0
procedure name 	: sopp_crmn_sp_uiorduihdr
purpose  	: 
author  	: 
component name 	: ppscmqso
method name 	: sopp_crmn_m_uiorduihdr

objects referred
 object name  object type  operation
       (insert/update/delete/select/exec)
modification details :-
	modified by			modified on		remarks
	Sreedhar V			11 Feb 2004		design change-payterm code added as input parameter
	Damodharan. R		11 April 2007	NSODMS412AT_000460 - CUMI Site modified objects rollin
	Damodharan. R		06 Oct 2007		NSODMS412AT_000526
	Veangadakrishnan R	18/04/2008		DMS412AT_NSO_00030	
	Anitha			19 May 2007		DMS412AT_NSO_00048
	Divyalekaa		23/09/2008		ES_NSO_00062
	Veangadakrishnan R	23/03/2009		ES_NSO_00206
	Vadivukkarasi A		07-09-2009		9H123-1_NSO_00030
	Sejal N Khimani		20 Jan 2014		13H120_Supp_00004:ES_Supp_00320
	Banu M              22/09/2017      HAL-227
	Sivasankari         5/03/2018       MKN-57
	Ambrin banu S		21/04/2022		DSDE-228
/*Chaitanya Ch        15/11/2023          EPE-58525*/
/*Shrimalavika M   22-01-2025  CU Merging-PJRMC-1252 */
******************************************************************************************/ 
create   procedure sopp_crmn_sp_uiorduihdr
     --temporary store for input parameter assignment     
     @addressidml   udd_addressid  ,
     @atplevel_hdn   udd_metadata_code  ,
     @atpsl_hdn   udd_metadata_code  ,
     @buid   udd_buid  ,
     @carriercode   udd_carriercode  ,
     @ctxt_language   udd_ctxt_language  ,
     @ctxt_ouinstance   udd_ctxt_ouinstance  ,
     @ctxt_service   udd_ctxt_service  ,
     @ctxt_user   udd_ctxt_user  ,
     @currency   udd_currency  ,
    -- @cuspono   udd_documentno  ,--MKN-57
	-- @cuspono       udd_cust_po_no,--MKN-57
	 @cuspono      udd_trandesc,--EPE-58525
     @custdetails   udd_subtitle  ,
     @custname   udd_custname  ,
     @customercode   udd_customer_id  ,
     @def_info   udd_subtitle  ,
     @freight_bill_hdn   udd_metadata_code  ,
     @freightamount   udd_amount  ,
     @frt_currency   udd_currencycode  ,
     @frtmethod_hdn   udd_metadata_code  ,
     /*code added for HAL-227 starts here*/
   -- @gross_volume   udd_volume ,
      @gross_volume    udd_weight,
    /*code added for HAL-227 ends here*/
     @gross_weight   udd_weight  ,
     @guid   udd_guid  ,
     @hidden_control1   udd_hiddencontrol  ,
     @hidden_control2   udd_hiddencontrol  ,
     @itemdetail   udd_itemcode  ,
     @loid   udd_loid  ,
     @netweight   udd_weight  ,
     @num_series   udd_notypeno  ,
     @ord_bas_val   udd_amount  ,
     @ord_det   udd_document  ,
     @ord_exempt   udd_flag  ,
     @ord_tot_val   udd_amount  ,
     @ord_type_hdn   udd_metadata_code  ,
     @order_date   udd_date  ,
     @order_no   udd_documentno  ,
     @overridewt   udd_quantity  ,
     @overridvol   udd_quantity  ,
     @paytermcode   udd_paytermcode  ,
     @podate   udd_date  ,
     @price_const   udd_subtitle  ,
     @pricelist   udd_pricelist  ,
     @pricingdate   udd_date  ,
     @promiseddate   udd_date  ,
     @reqddate   udd_date  ,
     @resporgunit   udd_ouinstname  ,
     @sale_type   udd_sales  ,
     @screenid   udd_desc16  ,
     @shippingpoint_hdn   udd_ouinstid  ,
     @shiptoaddid   udd_id  ,
     @shiptocustomer   udd_customer_id  ,
     @source_doc   udd_subtitle  ,
     @sourcedocno   udd_documentno  ,
     @sourcedocument_qso_hdn   udd_metadata_code  ,
     @status1   udd_status  ,
     @timestamp   udd_timestamp  ,
     @total_charge   udd_amount  ,
     @total_discount   udd_amount  ,
     @total_tax   udd_amount  ,
     @total_vat   udd_amount  ,
     @trans_mode   udd_identificationnumber1  ,
     @trantype   udd_type  ,
     @vatcalc   udd_option  ,
     @volume_uom   udd_uomcode  ,
     @warehouse   udd_warehouse  ,
     @weight_uom   udd_uomcode  ,
     @wfdockey   udd_wfdockey  ,
     @wforgunit   udd_wforgunit  ,
	/* Code added by Damodharan. R on 04 Oct 2007 for OTS ID NSODMS412AT_000526 starts here */
	@exchangerate           	udd_exchangerate,
	@check_loi              	udd_checkbox,
	@advance                	udd_amount,
	--@contact_person         	udd_customertype2,--DSDE-228
	@contact_person         	udd_remarks, -- DSDE-228
	@fb_doc                 	udd_financebookid,
	@usagecccode            	udd_item_usage,
	@createdby              	udd_ctxt_user,
	@createddate            	udd_date, 
	@modifiedby             	udd_ctxt_user,
	@modifieddate           	udd_date,
	/* Code added by Damodharan. R on 04 Oct 2007 for OTS ID NSODMS412AT_000526 ends here */
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/	
	@salesperson                    udd_saleperson_id,
	@folder                         udd_folder, 
	@saleschannel                   udd_saleschannel,
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/
	@m_errorid  			udd_int output --to return execution status
as
begin
     --declare @iudmodeflag nvarchar(2) 

     -- nocount should be switched on to prevent phantom rows 
     set nocount on
     -- @m_errorid should be 0 to indicate success
     select @m_errorid =0

     /*Code Added for the DTS id:ES_NSO_00206 starts here*/	
	    declare  @workflow_app	udd_paramcode,
				 @wfstatus		udd_cm_docstatus	
      /*Code Added for the DTS id:ES_NSO_00206 ends here*/	


     select @addressidml = ltrim(rtrim(@addressidml))
     if @addressidml = '~#~' 
          select @addressidml = null
     select @atplevel_hdn = ltrim(rtrim(@atplevel_hdn))
     if @atplevel_hdn = '~#~' 
          select @atplevel_hdn = null
     select @atpsl_hdn = ltrim(rtrim(@atpsl_hdn))
     if @atpsl_hdn = '~#~' 
          select @atpsl_hdn = null
     select @buid = ltrim(rtrim(@buid))
     if @buid = '~#~' 
          select @buid = null
     select @carriercode = ltrim(rtrim(@carriercode))
     if @carriercode = '~#~' 
          select @carriercode = null
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
     select @currency = ltrim(rtrim(@currency))
     if @currency = '~#~' 
          select @currency = null
     select @cuspono = ltrim(rtrim(@cuspono))
     if @cuspono = '~#~' 
          select @cuspono = null
     select @custdetails = ltrim(rtrim(@custdetails))
     if @custdetails = '~#~' 
          select @custdetails = null
     select @custname = ltrim(rtrim(@custname))
     if @custname = '~#~' 
          select @custname = null
     select @customercode = ltrim(rtrim(@customercode))
     if @customercode = '~#~' 
          select @customercode = null
     select @def_info = ltrim(rtrim(@def_info))
     if @def_info = '~#~' 
          select @def_info = null
     select @freight_bill_hdn = ltrim(rtrim(@freight_bill_hdn))
     if @freight_bill_hdn = '~#~' 
          select @freight_bill_hdn = null
     if @freightamount = -915 
          select @freightamount = null
     select @frt_currency = ltrim(rtrim(@frt_currency))
     if @frt_currency = '~#~' 
          select @frt_currency = null
     select @frtmethod_hdn = ltrim(rtrim(@frtmethod_hdn))
     if @frtmethod_hdn = '~#~' 
          select @frtmethod_hdn = null
     if @gross_volume = -915 
          select @gross_volume = null
     if @gross_weight = -915 
          select @gross_weight = null
     select @guid = ltrim(rtrim(@guid))
     if @guid = '~#~' 
          select @guid = null
     select @hidden_control1 = ltrim(rtrim(@hidden_control1))
     if @hidden_control1 = '~#~' 
          select @hidden_control1 = null
     select @hidden_control2 = ltrim(rtrim(@hidden_control2))
     if @hidden_control2 = '~#~' 
          select @hidden_control2 = null
     select @itemdetail = ltrim(rtrim(@itemdetail))
     if @itemdetail = '~#~' 
          select @itemdetail = null
     select @loid = ltrim(rtrim(@loid))
     if @loid = '~#~' 
          select @loid = null
     if @netweight = -915 
          select @netweight = null
     select @num_series = ltrim(rtrim(@num_series))
     if @num_series = '~#~' 
          select @num_series = null
     if @ord_bas_val = -915 
          select @ord_bas_val = null
     select @ord_det = ltrim(rtrim(@ord_det))
     if @ord_det = '~#~' 
          select @ord_det = null
     select @ord_exempt = ltrim(rtrim(@ord_exempt))
     if @ord_exempt = '~#~' 
          select @ord_exempt = null
     if @ord_tot_val = -915 
          select @ord_tot_val = null
     select @ord_type_hdn = ltrim(rtrim(@ord_type_hdn))
     if @ord_type_hdn = '~#~' 
          select @ord_type_hdn = null
     if @order_date = '01/01/1900' 
          select @order_date = null
     select @order_no = ltrim(rtrim(@order_no))
     if @order_no = '~#~' 
          select @order_no = null
     if @overridewt = -915 
          select @overridewt = null
     if @overridvol = -915 
          select @overridvol = null
     select @paytermcode = ltrim(rtrim(@paytermcode))
     if @paytermcode = '~#~' 
          select @paytermcode = null
     if @podate = '01/01/1900' 
          select @podate = null
     select @price_const = ltrim(rtrim(@price_const))
     if @price_const = '~#~' 
          select @price_const = null
     select @pricelist = ltrim(rtrim(@pricelist))
     if @pricelist = '~#~' 
          select @pricelist = null
     if @pricingdate = '01/01/1900' 
          select @pricingdate = null
     if @promiseddate = '01/01/1900' 
          select @promiseddate = null
     if @reqddate = '01/01/1900' 
          select @reqddate = null
     select @resporgunit = ltrim(rtrim(@resporgunit))
     if @resporgunit = '~#~' 
          select @resporgunit = null
     select @sale_type = ltrim(rtrim(@sale_type))
     if @sale_type = '~#~' 
          select @sale_type = null
     select @screenid = ltrim(rtrim(@screenid))
     if @screenid = '~#~' 
          select @screenid = null
     if @shippingpoint_hdn = -915 
          select @shippingpoint_hdn = null
     select @shiptoaddid = ltrim(rtrim(@shiptoaddid))
     if @shiptoaddid = '~#~' 
          select @shiptoaddid = null
     select @shiptocustomer = ltrim(rtrim(@shiptocustomer))
     if @shiptocustomer = '~#~' 
          select @shiptocustomer = null
     select @source_doc = ltrim(rtrim(@source_doc))
     if @source_doc = '~#~' 
          select @source_doc = null
     select @sourcedocno = ltrim(rtrim(@sourcedocno))
     if @sourcedocno = '~#~' 
          select @sourcedocno = null
     select @sourcedocument_qso_hdn = ltrim(rtrim(@sourcedocument_qso_hdn))
     if @sourcedocument_qso_hdn = '~#~' 
          select @sourcedocument_qso_hdn = null
     select @status1 = ltrim(rtrim(@status1))
     if @status1 = '~#~' 
          select @status1 = null
     if @timestamp = -915 
          select @timestamp = null
     if @total_charge = -915 
          select @total_charge = null
     if @total_discount = -915 
          select @total_discount = null
     if @total_tax = -915 
          select @total_tax = null
     if @total_vat = -915 
          select @total_vat = null
     select @trans_mode = ltrim(rtrim(@trans_mode))
     if @trans_mode = '~#~' 
          select @trans_mode = null
     select @trantype = ltrim(rtrim(@trantype))
     if @trantype = '~#~' 
          select @trantype = null
     select @vatcalc = ltrim(rtrim(@vatcalc))
     if @vatcalc = '~#~' 
          select @vatcalc = null
     select @volume_uom = ltrim(rtrim(@volume_uom))
     if @volume_uom = '~#~' 
          select @volume_uom = null
     select @warehouse = ltrim(rtrim(@warehouse))
     if @warehouse = '~#~' 
          select @warehouse = null
     select @weight_uom = ltrim(rtrim(@weight_uom))
     if @weight_uom = '~#~' 
          select @weight_uom = null
     select @wfdockey = ltrim(rtrim(@wfdockey))
     if @wfdockey = '~#~' 
          select @wfdockey = null
     if @wforgunit = -915 
          select @wforgunit = null
/* Code added by Damodharan. R on 04 Oct 2007 for OTS ID NSODMS412AT_000526 starts here */
	if @exchangerate = -915
		select @exchangerate = null  

	select @check_loi = ltrim(rtrim(@check_loi))
	if @check_loi = '~#~' 
		select @check_loi = null  

	if @advance = -915
		select @advance = null  

	select @contact_person = ltrim(rtrim(@contact_person))
	if @contact_person = '~#~' 
		select @contact_person = null  

	select @fb_doc = ltrim(rtrim(@fb_doc))
	if @fb_doc = '~#~' 
		select @fb_doc = null  
	
	select @usagecccode = ltrim(rtrim(@usagecccode))
	if @usagecccode = '~#~' 
		select @usagecccode = null  

	select @createdby               = ltrim(rtrim(@createdby))
	if @createdby = '~#~' 
		select @createdby = null  

	if @createddate = '01/01/1900' 
		select @createddate = null  
	
	select @modifiedby              = ltrim(rtrim(@modifiedby))
	if @modifiedby = '~#~' 
		select @modifiedby = null  

	if @modifieddate = '01/01/1900' 
		select @modifieddate = null  
/* Code added by Damodharan. R on 04 Oct 2007 for OTS ID NSODMS412AT_000526 ends here */
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/	
	select @salesperson  = ltrim(rtrim(@salesperson))
	if @salesperson = '~#~'
		select @salesperson = null
	select @folder  = ltrim(rtrim(@folder))
	if @folder = '~#~'
		select @folder = null
	select @saleschannel  = ltrim(rtrim(@saleschannel))   
	if @saleschannel = '~#~'
		select @saleschannel = null 
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/	

	
	select	@order_no = upper(@order_no)		 

	if 	@order_no is null 
		begin
			--order no cannot be null. enter a valid order no
  			select @m_errorid = 3550216
			return
		end
		
	if exists (	select 'X' 
			/* Code modified by Damodharan. R on 11 April 2007 for OTS ID NSODMS412AT_000460 starts here */
			from 	so_order_hdr  (nolock)
			/* Code modified by Damodharan. R on 11 April 2007 for OTS ID NSODMS412AT_000460 ends here */
			where 	sohdr_ou	=	@ctxt_ouinstance
			and  	sohdr_order_no	=	@order_no)
		begin
						
			if exists ( 	select 	'X' 	
					/* Code modified by Damodharan. R on 11 April 2007 for OTS ID NSODMS412AT_000460 starts here */
					from 	so_order_hdr (nolock)
					/* Code modified by Damodharan. R on 11 April 2007 for OTS ID NSODMS412AT_000460 ends here */
					where 	sohdr_ou		=	@ctxt_ouinstance
					and  	sohdr_order_no		=	@order_no
					/*Code Modified for ES_NSO_00062 starts*/
					/*Code Modified for 9H123-1_NSO_00030 starts*/
-- 					and	sohdr_order_status not in ('DR','FR','LI','PA','RT'))--Modified for DTS ID: DMS412AT_NSO_00048
					and  sohdr_order_status not in ('DR','FR','LI','PA','RT')) --OR (sohdr_order_status  ='RT' and sohdr_amend_no>0))) --Modified for DTS ID: DMS412AT_NSO_00048
					/*Code Modified for 9H123-1_NSO_00030 ends*/
					/*Code Modified for ES_NSO_00062 ends*/	
				
				begin
					--order no not in either fresh or draft status. please check
  					select @m_errorid = 3550217
					return		
				end

				/*Code  added for 9H123-1_NSO_00037 starts here*/ 
				if exists ( 	select 	'X' 						
					from 	so_order_hdr (nolock)					
					where 	sohdr_ou		=	@ctxt_ouinstance
					and  	sohdr_order_no		=	@order_no					
					and     sohdr_order_status  	='RT' 
					and     sohdr_amend_no>0)
				begin
				exec fin_german_raiserror_sp 'NSO',@ctxt_language,1206
				return
				end
				/*Code  added for 9H123-1_NSO_00037 ends here*/ 
		end
	else
		begin
			--order no does not exist
  			select @m_errorid = 3550218			
			return		
		end

	/*Code Added for the DTS id :ES_NSO_00206 starts here*/	
	select @workflow_app = dbo.workflowapp_fet_fn(@ctxt_user,@ctxt_ouinstance,'NSO','NSOSO','CRAU')

	/* Code added by Shrimalavika M starts */ 
 if	Exists (
			select 'X'
			 from depdb..fw_admin_usrrole with(nolock)
			 where 
			 UserName = @ctxt_user
			 and RoleName = 'SUPER_APPROVER'
			 )
			 Begin
				select	 @workflow_app ='N'  
			 End

			 update a
			 set wf_instance_status	=	'C'
			 from wfm40..wf_mypage_todo a with(nolock)
			 where doc_key like @order_no
			 and ou_code	=	@ctxt_ouinstance


/* Code added by Shrimalavika M Ends */

	declare	@pono	  udd_documentno --13H120_Supp_00004:ES_Supp_00320
	
	select	@wfstatus = sohdr_workflow_status
			,@pono	  = sohdr_po_no--13H120_Supp_00004:ES_Supp_00320
	from	so_order_hdr(nolock)
	where	sohdr_ou		= @ctxt_ouinstance
	and		sohdr_order_no	= @order_no
	
	/* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Begins */
	if @pono is not null
	begin
		--Sale Order No. "%s" generated from Purchase Order company cannot be fetched.
		exec fin_german_raiserror_sp 'PO',@ctxt_language,2019,@order_no
		return		
	end
	/* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Ends */
		
	if @workflow_app ='Y' and @wfstatus is not null
	begin
		if exists (select '*' from wf_mypage_todo_vw  wf (nolock)  
			where   wf.doc_unique_id  = @order_no
			and wf.ou_code   =  @ctxt_ouinstance     
			and  wf.area_code    =  'NSOSO'  
			and  wf.component_name   =  'NSO'  
			and (( wf.my_name = @ctxt_user and wf.ou_code = @ctxt_ouinstance)  
			or ( wf.proxy_user = @ctxt_user and wf.ou_code = @ctxt_ouinstance)  
			or ( wf.my_name = 'ALL'  and wf.ou_code = @ctxt_ouinstance))  )

		begin
			select @order_no =@order_no
		end
		else
		begin
			exec fin_german_raiserror_sp 'NSO',@ctxt_language,1001
			return
		end
	end
	/*Code Added for the DTS id :ES_NSO_00206 ends here*/	
		
	select 1 'FPROWNO'

/*
template select statement for selecting data to app layer
select 
@fprowno 'FPROWNO'
 from  ***
*/
end






