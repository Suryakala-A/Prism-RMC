/*$File_version=ms4.3.0.06$*/

/* VERSION NO: PPS4.1.0.000 */

/******************************************************************************************
file name 	: sopp_crmn_sp_uidocuihdr.sql
version		: 4.0.0.0
procedure name 	: sopp_crmn_sp_uidocuihdr
purpose  	: 
author  	: 
component name 	: ppscmqso
method name 	: sopp_crmn_m_uidocuihdr

objects referred
 object name  object type  operation
       (insert/update/delete/select/exec)
modification details
 modified by  modified on  remarks

Sreedhar V	11 Feb 2004	design change-payterm code added as input parameter
Anitha N	19 Sep 2007	NSODMS412AT_000532
Damodharan. R		18 Oct 2007			NSODMS412AT_000546
Anitha N	05 Nov 2007		NSODMS412AT_000561
Banu M              22/09/2017      HAL-227
Sivasankari         5/03/2018       MKN-57
	 /*Chaitanya Ch        15/11/2023          EPE-58525*/
/* Sejal N Khimani	20 Dec 2023		EPE-70259			*/
/*RITSL                    10/09/2024     PJRMC-566    */
******************************************************************************************/ 
create   procedure sopp_crmn_sp_uidocuihdr
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
     @desc255   udd_desc255  ,
     @freight_bill_hdn   udd_metadata_code  ,
     @freightamount   udd_amount  ,
     @frt_currency   udd_currencycode  ,
     @frtmethod_hdn   udd_metadata_code  ,
    /*code added for HAL-227 starts here*/
   -- @gross_volume   udd_volume ,
      @gross_volume   udd_weight,
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
     @m_errorid  int output --to return execution status
as
begin
     declare @iudmodeflag nvarchar(2) 

     -- nocount should be switched on to prevent phantom rows 
     set nocount on
     -- @m_errorid should be 0 to indicate success
 select @m_errorid =0

     

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
     select @desc255 = ltrim(rtrim(@desc255))
     if @desc255 = '~#~' 
          select @desc255 = null
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

	declare @contract_type 	udd_metadata_code,
		@status 	udd_metadata_code

	/* Code added for EPE-70259 Begins */
	declare	@qtn_ref_doc_no		udd_documentno,
			@qtn_ref_doc_type	udd_metadata_code,
			@qtn_ou				udd_ctxt_ouinstance
	/* Code added for EPE-70259 Ends */

	select	@sourcedocno = upper(@sourcedocno)
	
	--null check for sourcedocument

	if	(@sourcedocument_qso_hdn is null or @sourcedocument_qso_hdn = 'NONE') --NSODMS412AT_000561
		begin
			--SourceDocument cannot be null,Please check
			select @m_errorid = 3550352
			return
		end
	--null check for documentno
	if	@sourcedocno is null
		begin
			--<^sourcedocno!>"<%sourcedocno%>" cannot be null
			select @m_errorid = 3550016
			return
		end 	
	-- code for template  source document 
	if	@sourcedocument_qso_hdn = 'TEMP'
		begin
			if exists (	select	'X'
					from	so_order_hdr (nolock)
					where	sohdr_ou		=	@ctxt_ouinstance
					and	sohdr_order_no		=	@sourcedocno
					--and	sohdr_order_status	=	'AU'
					and	sohdr_order_type	=	'TEMP'	)
	
				begin
					select	@sourcedocno	=	@sourcedocno	
				end	
			else
				begin
					--<^sourcedocno!>"<%sourcedocno%>" is not valid
  					select @m_errorid = 3550017
					return
				end
		end
	-- code for sales order source document 
	if	@sourcedocument_qso_hdn = 'NSO'
		begin
			if exists (	select	'X'
					from	so_order_hdr (nolock)
					where	sohdr_ou		=	@ctxt_ouinstance
					and	sohdr_order_no		=	@sourcedocno
					--and	sohdr_order_status	in('AU','AM','FR','SC','CL')
					and	sohdr_order_type	in('NSO','COD','CSO'))
	
				begin
					select	@sourcedocno	=	@sourcedocno	
				end
			else
				begin
					--<^sourcedocno!>"<%sourcedocno%>" is not valid
					select @m_errorid = 3550017
					return
				end
		end

	-- code for quotation source document 
	
	if	@sourcedocument_qso_hdn = 'QUO'
		begin
			if exists (	select	'X'
					from	qtn_quotation_hdr_vw
					where	qhdr_quotnumber		=	@sourcedocno
					and	qhdr_status		in('AU','OR')
					and	qhdr_ouinstance 	in(	select destinationouinstid
							   			from  fw_admin_view_comp_intxn_model  
							   			where sourcecomponentname    	= 'NSO'
							   			and   sourceouinstid         	= @ctxt_ouinstance
							   			and   destinationcomponentname  = 'QUOTATION'))				
	
				begin
					select	@sourcedocno	=	@sourcedocno	
				end
			else
				begin				
					--<^sourcedocno!>"<%sourcedocno%>" is not valid
					select @m_errorid = 3550017
					return
				end
         
			/* Code added for EPE-70259 Begins */
			select	@qtn_ref_doc_type		=	qhdr_refdoctypeen,
					@qtn_ref_doc_no			=	qhdr_documentno,
					@qtn_ou					=	qhdr_ouinstance
			from	qtn_quotation_hdr_vw with (nolock)
			where	qhdr_quotnumber			=	@sourcedocno
			and		qhdr_status				in	('AU','OR')
			and		qhdr_ouinstance 		in	(	select destinationouinstid
							   						from  fw_admin_view_comp_intxn_model  with(nolock)
							   						where sourcecomponentname    	= 'NSO'
							   						and   sourceouinstid         	= @ctxt_ouinstance
							   						and   destinationcomponentname  = 'QUOTATION'
												)

			if @qtn_ref_doc_type = 'CS'
			begin
				if exists ( select	'X'
							from	fms_servsal_cost_sht_hdr with(nolock)
							where	cost_hdr_cost_sht_no	=	@qtn_ref_doc_no
							and		cost_hdr_ou				=	@qtn_ou
							and		cost_hdr_status			in	('AM','RT')
						  )
				begin
					--Quotation No. ''%s'' auto created for the Cost Sheet No. ''%s'' is in Under Amendment Status. Sale Order cannot be created.
					EXEC fin_german_raiserror_sp 'SERVSAL',@ctxt_language,2015,@sourcedocno,@qtn_ref_doc_no
					return
				end
			end
			/* Code added for EPE-70259 Ends */
		end	

	
	if	@sourcedocument_qso_hdn = 'CON'
	begin
		/*Code added by krishnan start*/            
  		  if exists ( select 'X'   from so_contract_hdr            
     		              where conhdr_contract_no  = @sourcedocno            
    			     --and qhdr_status  in('AU','OR')            
   			      and conhdr_ou  in( select destinationouinstid            
             					from  fw_admin_view_comp_intxn_model              
             					where sourcecomponentname     = 'NSO'            
           					and   sourceouinstid          = @ctxt_ouinstance            
      						and   destinationcomponentname  = 'nso'))             
            
            
 	      --/*Code added by krishnan start*/  
		select	@contract_type 	= conhdr_contract_type,
			@status 	= conhdr_status
		from	so_contract_hdr (nolock)
 		 where-- conhdr_ou  = @ctxt_ouinstance and             
  		 conhdr_ou  in( select destinationouinstid            
             			from  fw_admin_view_comp_intxn_model              
             			where sourcecomponentname     = 'NSO'            
             			and   sourceouinstid          = @ctxt_ouinstance            
   			and   destinationcomponentname  = 'nso')
	     			and    conhdr_contract_no  = @sourcedocno            
	

		if (@status is null)
		begin
			--<^sourcedocno!>"<%sourcedocno%>" is not valid
			select @m_errorid = 3550017
			return
		end
 --CODE added for RITSL/PJRMC-566 starts here
  if @status ='SC'
  begin
  raiserror('This Contract is in "Short Closed" Status, Please Check',16,1) 
   return
  end
  --CODE added for RITSL/PJRMC-566 ends here
		if (@status <> 'AU')
		begin
			--^sourcedocno!  "<sourcedocno>"   not in "Active" status. Enter a valid ^sourcedocno!
			--select @m_errorid = 3550351
			exec fin_german_raiserror_sp 'NSO',@ctxt_language,58,@sourcedocno,'','','','','','' --NSODMS412AT_000546
			return
		end

		if (@pricingdate is null)
			select  @pricingdate = convert(datetime, convert(nchar(10), dbo.RES_Getdate(@ctxt_ouinstance), 120), 120)


		-- if Agreement Check if the Agreement is valid for the Order Date
		if ( @contract_type = 'AGR')
		begin
			if exists ( 	select '*'
					from 	so_agreement_dtl (nolock)
					where 	agrdet_ou   		=	@ctxt_ouinstance 	
					and 	agrdet_contract_no 	=	@sourcedocno
					and 	@pricingdate between agrdet_effective_date and isnull(agrdet_expiry_date, @pricingdate)
				 )
			begin
				select @contract_type = @contract_type
			end
			else
			begin
				--^sourcedocno!  "<sourcedocno>"   Invalid for the OrderDate. Enter a valid ^sourcedocno!
				select @m_errorid = 3550350
				return
			end
		end
		else if ( @contract_type = 'BSO')
		begin
			if exists ( 	select '*'
					from 	so_blanket_order_hdr (nolock)
 				        where -- bsohdr_ou     = @ctxt_ouinstance and              
     					bsohdr_ou  in( select destinationouinstid            
             						from  fw_admin_view_comp_intxn_model              
            						 where sourcecomponentname     = 'NSO'            
             						 and   sourceouinstid          = @ctxt_ouinstance            
             						 and   destinationcomponentname  = 'nso')             
             						 and   bsohdr_contract_no  = @sourcedocno            
	     						 and 	@pricingdate between bsohdr_effective_date and isnull(bsohdr_expiry_date, @pricingdate)
				 )
			begin
				select @contract_type = @contract_type
			end
			else
			begin
				--^sourcedocno!  "<sourcedocno>"   Invalid for the OrderDate. Enter a valid ^sourcedocno!
   				 --select @m_errorid = 3550350    --code commented for RITSL/PJRMC-566   
 			raiserror('This Contract is "Expired" Please Check',16,1)--code added for RITSL/PJRMC-566   
    			return      
   			end      
  		end      
end       
       
 -- output fields in resultset      
 select 1 'FPROWNO'      
      
--<^sourcedocno!>"<%sourcedocno%>" cannot be null.      
  --select @m_errorid = 3550015      
--<^sourcedocno!>"<%sourcedocno%>" cannot be null      
  --select @m_errorid = 3550016      
--<^sourcedocno!>"<%sourcedocno%>" is not valid      
  --select @m_errorid = 3550017      
/*      
template select statement for selecting data to app layer      
select       
@fprowno 'FPROWNO'      
 from  ***      
*/      
end      
      








