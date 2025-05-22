/*$File_version=ms4.3.0.14$*/
/* VERSION NO: PPS4.1.0.001 */

/******************************************************************************************
file name 		: sopp_crmn_sp_uidochref.sql
version			: 4.0.0.0
procedure name 	: sopp_crmn_sp_uidochref
purpose  		: 
author  		: 
component name 	: ppscmqso
method name 	: sopp_crmn_m_uidochref

objects referred
 object name  object type  operation
       (insert/update/delete/select/exec)
modification details
 modified by  modified on  remarks

Sreedhar V	11 Feb 2004	design change-payterm code added as input/output parameter

Sreedhar V	03 Aug 2004	If Ref_Doc_Type = "Quotation",
				fetch the customer name separately,
				since the customer could be a "Prospect" customer
				while creating the Quotation.So, the inner join bet'
				Customer and Quotation will fail.
				against ""
Aswani K			15_Sep_05		PPSCMQSOCUMI_000049
Veangadakrishnan R	18/04/2008		DMS412AT_NSO_00030
Damodharan	R		27 May 2008		DMS412AT_NSO_00052
Veangadakrishnan R	30/12/2008		ES_NSO_00118
Veangadakrishnan R	23/03/2009		ES_PACKSLIP_00204
Thiruvengadam.S		28/06/2010		ES_NSO_00391
/*	Bharath A		08/04/2011		10H109_NSO_00002						*/
/*	Prakash V		02/03/2017		ES_NSO_01464						*/
/*  Banu M          22/09/2017      HAL-227        */
/*Sivasankari       5/03/2018       MKN-57                                              */
/*Balasubramaniyam P	22/06/2018	EBS-1362		*/
/*T.Madhu sree         21-10-2020   ILE-1428*/
/*Akash V              20/06/2022		RIMT-1112 */
	 /*Chaitanya Ch        15/11/2023          EPE-58525*/
	 /*suryakala A       22-01-2025       CU Merging-PJRMC-1252 */
	 /* Shrimalavika M	 29/03/2025		 PJRMC-1253		*/
******************************************************************************************/ 
create     procedure sopp_crmn_sp_uidochref     
     @ctxt_language			udd_ctxt_language  ,
     @ctxt_ouinstance		udd_ctxt_ouinstance  ,
     @ctxt_service			udd_ctxt_service  ,
     @ctxt_user				udd_ctxt_user  ,
     @addressidml			udd_addressid  ,
     @atplevel_hdn			udd_metadata_code  ,
     @atpsl_hdn				udd_metadata_code  ,
     @buid					udd_buid  ,
     @carriercode			udd_carriercode  ,
     @currency				udd_currency  ,
    -- @cuspono				udd_documentno  ,--MKN-57
	-- @cuspono               udd_cust_po_no,--MKN-57
	 @cuspono      udd_trandesc,--EPE-58525
     @custdetails			udd_subtitle  ,
     @custname				udd_custname  ,
     @customercode			udd_customer_id  ,
     @def_info				udd_subtitle  ,
     @desc255				udd_desc255  ,
     @freight_bill_hdn		udd_metadata_code  ,
     @freightamount			udd_amount  ,
     @frt_currency			udd_currencycode  ,
     @frtmethod_hdn			udd_metadata_code  ,
     /*code added for HAL-227 starts here*/
   -- @gross_volume         udd_volume ,
      @gross_volume         udd_weight,
   /*code added for HAL-227 ends here*/
     @gross_weight			udd_weight  ,
     @guid					udd_guid  ,
     @hidden_control1		udd_hiddencontrol  ,
     @hidden_control2		udd_hiddencontrol  ,
     @itemdetail			udd_itemcode  ,
     @loid					udd_loid  ,
     @netweight				udd_weight  ,
     @num_series			udd_notypeno  ,
     @ord_bas_val			udd_amount  ,
     @ord_det				udd_document  ,
     @ord_exempt			udd_flag  ,
     @ord_tot_val			udd_amount  ,
     @ord_type_hdn			udd_metadata_code  ,
     @order_date			udd_date  ,
     @order_no				udd_documentno  ,
     @overridewt			udd_quantity  ,
     @overridvol			udd_quantity  ,
     @paytermcode			udd_paytermcode  ,
     @podate				udd_date  ,
     @price_const			udd_subtitle  ,
     @pricelist				udd_pricelist  ,
     @pricingdate			udd_date  ,
     @promiseddate			udd_date  ,
     @reqddate				udd_date  ,
     @resporgunit			udd_ouinstname  ,
     @sale_type				udd_sales  ,
     @shippingpoint_hdn		udd_ouinstid  ,
     @shiptoaddid			udd_id  ,
     @shiptocustomer		udd_customer_id  ,
     @source_doc			udd_subtitle  ,
     @sourcedocno			udd_documentno  ,
     @sourcedocument_qso_hdn udd_metadata_code  ,
     @status1				udd_status  ,
     @timestamp				udd_timestamp  ,
     @total_charge			udd_amount  ,
     @total_discount		udd_amount  ,
     @total_tax				udd_amount  ,
     @total_vat				udd_amount  ,
     @trans_mode			udd_identificationnumber1  ,
     @trantype				udd_type  ,
     @vatcalc				udd_option  ,
     @volume_uom			udd_uomcode  ,
     @warehouse				udd_warehouse  ,
     @weight_uom			udd_uomcode  ,
     @wfdockey				udd_wfdockey  ,
     @wforgunit				udd_wforgunit  ,
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/	
	@salesperson            udd_saleperson_id,  
	@folder                 udd_folder,  
	@saleschannel           udd_saleschannel,  
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/	
	@partshipment_hdn		udd_metadata_code, --Added for DTS ID: ES_NSO_00118
	/*code added for defect id : EBS-1362 starts here*/
	@customertaxregion      	udd_tcdcode, 
	@owntaxregion           	udd_tcdcode,
	@taxregnno              	udd_desc40, 
	/*code added for defect id : EBS-1362 ends here*/
    @m_errorid				udd_int output --to return execution status
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
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/	
	select @salesperson  = ltrim(rtrim(@salesperson))
	if @salesperson = '~#~'
		select @salesperson = null  
	select @folder  = ltrim(rtrim(@folder))
	if @folder = '~#~'
		select @folder = null  
	if @saleschannel = '~#~'
		select @saleschannel = null  
	select @saleschannel  = ltrim(rtrim(@saleschannel))
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/
	/*Added for DTS ID: ES_NSO_00118 starts here*/
	select @partshipment_hdn  = ltrim(rtrim(@partshipment_hdn))
	if @partshipment_hdn = '~#~'
		select @partshipment_hdn = null  
	/*Added for DTS ID: ES_NSO_00118 ends here*/
	/*code added for defect id : EBS-1362 starts here*/
	Select @customertaxregion       = ltrim(rtrim(@customertaxregion))
	IF @customertaxregion = '~#~' 
		Select @customertaxregion = null
	Select @owntaxregion            = ltrim(rtrim(@owntaxregion))
	IF @owntaxregion = '~#~' 
		Select @owntaxregion = null 
	Select @taxregnno               = ltrim(rtrim(@taxregnno))
  	IF @taxregnno = '~#~' 
		Select @taxregnno = null
	/*code added for defect id : EBS-1362 ends here*/

	--temp variables
	declare	@cust_ou 		udd_ctxt_ouinstance,
			@cust_lo		udd_loid ,
			@cust_bu		udd_buid ,
			@eratetype  	udd_paramcode,
			@exchangerate	udd_exchangerate  ,
			@trandate		udd_date ,
			@return_val 	udd_int,
			@m_error_flag	udd_metadata_code,
			@m_errorid_tmp 	udd_int,
			@error_msg_qualifier 	udd_desc255
	declare @customer_name_tmp	udd_custname,
			@customercode_tmp	udd_customer_id
	
	select	@sourcedocno 	= upper(@sourcedocno),
			@trandate		= dbo.RES_Getdate(@ctxt_ouinstance)	
	select 	@return_val		= 0
	--fecthing the minimum warehouse to the shipping point
	
	select	@warehouse		=	min(wh_code)			
	from	sa_warehouse_master_vw
	where 	wh_ou 			= 	@shippingpoint_hdn
	and		wh_status  		= 	'AC'
	
	--calling procedure to fetch the customer ou
	
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
	--calling procedure for getting lo and bu to the customer ou
	exec scm_get_emod_details @cust_ou,@trandate, @cust_lo out, @cust_bu out, @return_val out
	if 	(@return_val <> 0)
		begin
			select	@m_errorid = @return_val
			return
		end
	
	-- output fields in resultset
	
	if	@sourcedocument_qso_hdn = 'TEMP' or @sourcedocument_qso_hdn = 'NSO'
		begin

			select	rtrim(sohdr_order_from_id) 		'ADDRESSIDML',
					rtrim(sohdr_atp_opt_level)		'ATPLEVEL_HDN',
					@atpsl_hdn						'ATPSL_HDN',
					@buid 							'BUID',
					rtrim(sohdr_prefered_carrier) 	'CARRIERCODE',
					rtrim(sohdr_currency) 			'CURRENCY',
					rtrim(sohdr_cust_po_no) 		'CUSPONO',
					@custdetails					'CUSTDETAILS',
					rtrim(clo_cust_name) 			'CUSTNAME',
					rtrim(sohdr_order_from_cust) 	'CUSTOMERCODE',
					@def_info						'DEF_INFO',
					@desc255						'DESC255',
					/*rtrim(sohdr_freight_billable)*/'Y'	'FREIGHT_BILL_HDN',/*code modified against PJRMC-1253 */
					sohdr_freight_amount			'FREIGHTAMOUNT',
					rtrim(sohdr_freight_currency)	'FRT_CURRENCY',
					rtrim(sohdr_freight_method)		'FRTMETHOD_HDN',
					sohdr_gross_volume				'GROSS_VOLUME',
					sohdr_gross_weight				'GROSS_WEIGHT',
					rtrim(@guid) 					'GUID',
					rtrim(@sourcedocno) 			'HIDDEN_CONTROL1',
					rtrim(sohdr_order_no) 			'HIDDEN_CONTROL2',
					@itemdetail						'ITEMDETAIL',
					sohdr_lo						'LOID',
					sohdr_net_weight				'NETWEIGHT',
					sohdr_num_series				'NUM_SERIES',
					sohdr_basic_value 				'ORD_BAS_VAL',
					@ord_det 						'ORD_DET',
					@ord_exempt 					'ORD_EXEMPT',
					sohdr_total_value 				'ORD_TOT_VAL',
					rtrim(sohdr_order_type)			'ORD_TYPE_HDN',
					convert(nchar(10),@order_date,120) 'ORDER_DATE',
					@order_no	 					'ORDER_NO',
					sohdr_overriding_weight			'OVERRIDEWT',
					sohdr_overriding_volume			'OVERRIDVOL',
					rtrim(sohdr_pay_term_code)		'PAYTERMCODE',
					rtrim(sohdr_cust_po_date)		'PODATE',		--@podate 	--Code has been modified for ES_NSO_00391
					@price_const 					'PRICE_CONST',
					@pricelist 						'PRICELIST',
					convert(nchar(10),sohdr_pric_date_dflt,120) 'PRICINGDATE',
					convert(nchar(10),sohdr_prm_date_dflt,120)  'PROMISEDDATE',
					convert(nchar(10),sohdr_req_date_dflt,120)  'REQDDATE',
					@resporgunit 					'RESPORGUNIT',
					rtrim(sohdr_sale_type_dflt)  	'SALE_TYPE',
					sohdr_shp_pt_dflt 				'SHIPPINGPOINT_HDN',
					rtrim(sohdr_ship_to_id_dflt) 	'SHIPTOADDID',
					rtrim(sohdr_shiptocust_dflt) 	'SHIPTOCUSTOMER',
					'SOURCE DOCUMENT DETAILS'   	'SOURCE_DOC',
					@sourcedocno 					'SOURCEDOCNO',
					@sourcedocument_qso_hdn 		'SOURCEDOCUMENT_QSO_HDN',
					@status1						'STATUS1',
					@timestamp 						'TIMESTAMP',
					sohdr_total_charges 			'TOTAL_CHARGE',
					sohdr_total_discount 			'TOTAL_DISCOUNT',
					sohdr_total_tax 				'TOTAL_TAX',
					sohdr_total_vat 				'TOTAL_VAT',
					rtrim(sohdr_trnsprt_mode_dflt) 	'TRANS_MODE',
					@trantype 						'TRANTYPE',
					rtrim(sohdr_vat_class_dflt)		'VATCALC',
					rtrim(sohdr_volume_uom)			'VOLUME_UOM',
					rtrim(sohdr_wh_dflt) 			'WAREHOUSE',
					sohdr_weight_uom				'WEIGHT_UOM',
					@wfdockey 						'WFDOCKEY',
					@wforgunit 						'WFORGUNIT',
					0 								'FPROWNO',
					/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/	
					rtrim(sohdr_sales_person_dflt)	'SALESPERSON', 
					rtrim(sohdr_folder)				'FOLDER', 
					rtrim(sohdr_sales_channel)		'SALESCHANNEL',
					/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/
					sohdr_part_shipment				'PARTSHIPMENT_HDN',--Added for DTS ID: ES_NSO_00118
					/*Code removed for 10H109_NSO_00002 begin */
					/*
					--sohdr_lc_appl_flag				'LCAPPLICABLE'/*Code added for DTS ID: ES_PACKSLIP_00204*/					
					*/
					/*Code removed for 10H109_NSO_00002 end */
					/*Code Added for 10H109_NSO_00002 begin */
					case		when sohdr_lc_appl_flag = 'Y' and  sohdr_bg_appl_flag = 'N' 
								then  dbo.get_metadata_desc_fn('NSO','COMBO','BG_APPLICABLE','LC',@ctxt_language)	
								when sohdr_lc_appl_flag = 'N' and  sohdr_bg_appl_flag = 'Y' 
								then dbo.get_metadata_desc_fn('NSO','COMBO','BG_APPLICABLE','BG',@ctxt_language)		
								when sohdr_lc_appl_flag = 'Y' and  sohdr_bg_appl_flag = 'Y' 
								then dbo.get_metadata_desc_fn('NSO','COMBO','BG_APPLICABLE','LC & BG',@ctxt_language)		
								else dbo.get_metadata_desc_fn('NSO','COMBO','BG_APPLICABLE','NONE',@ctxt_language)
								end 'LCAPPLICABLE'	
					/*Code Added for 10H109_NSO_00002 end	*/
					/*code added for defect id : EBS-1362 starts here*/
				    ,sohdr_party_tax_region					'CUSTOMERTAXREGION' 
				    ,sohdr_own_tax_region					'OWNTAXREGION' 
				    ,sohdr_party_regd_no					'TAXREGNNO'
				    /*code added for defect id : EBS-1362 ends here*/
			from	cust_lo_info_vw (nolock),
					so_order_hdr (nolock)			
			where	sohdr_ou			=	@ctxt_ouinstance
			and		sohdr_order_no		=	@sourcedocno		
			and		clo_lo				=	@cust_lo
			and		clo_cust_code		=	sohdr_order_from_cust	
	end
			
	
	
	if	@sourcedocument_qso_hdn = 'QUO'
		begin
			--selecting the customer for the quotation number
		;
		WITH SQLTMP (destinationouinstid1) as (SELECT DISTINCT SQL2K51.destinationouinstid
			 FROM fw_admin_view_comp_intxn_model SQL2K51
			 WHERE SQL2K51.sourcecomponentname = 'NSO' and 
				SQL2K51.sourceouinstid = @ctxt_ouinstance and 
				SQL2K51.destinationcomponentname = 'QUOTATION' )

		SELECT @customercode_tmp = LTRIM (RTRIM ( qhdr_customercode) ),
			   @addressidml     =  LTRIM (RTRIM ( qhdr_custaddid ) )    --code added for ILE-1428
 		FROM qtn_quotation_hdr_vw JOIN 
			 SQLTMP 
			 ON ( qhdr_ouinstance = SQLTMP.destinationouinstid1 )
 		 WHERE  qhdr_quotnumber = @sourcedocno
		--ToolComment			select	@customercode_tmp	=	ltrim(rtrim(qhdr_customercode))
		--ToolComment			from	qtn_quotation_hdr_vw
		--ToolComment			where	qhdr_quotnumber		=	@sourcedocno
		--ToolComment			and	qhdr_ouinstance 	in(	select destinationouinstid
		--ToolComment								from  fw_admin_view_comp_intxn_model  
		--ToolComment								where sourcecomponentname    	= 'NSO'
		--ToolComment								and   sourceouinstid         	= @ctxt_ouinstance
		--ToolComment								and   destinationcomponentname  = 'QUOTATION')				
		--ToolComment			
		--ToolComment			--added-start
			if exists
			(
				select	'Y'
				from	cust_lo_info_vw (nolock)
				where	clo_cust_code	= @customercode_tmp
				and		clo_lo			= @cust_lo
			)
			begin
				select	@customer_name_tmp = ltrim(rtrim(clo_cust_name))
				from	cust_lo_info_vw (nolock)
				where	clo_cust_code	= @customercode_tmp
				and		clo_lo			= @cust_lo
			end
			else
			if exists
			(
				select	'Y'
				from	cust_lo_info_vw (nolock)
				where	clo_prosp_cust_code	= @customercode_tmp
				and		clo_lo				= @cust_lo
			)
			begin
				select	@customer_name_tmp = ltrim(rtrim(clo_cust_name)),
						@customercode_tmp  = ltrim(rtrim(clo_cust_code))
				from	cust_lo_info_vw (nolock)
				where	clo_prosp_cust_code	= @customercode_tmp
				and		clo_lo				= @cust_lo
			end
			else
			begin
				select	@customer_name_tmp = null,
						@customercode_tmp  = null
			end
			--added-end
				
			--selecting the default ship to customer,defailt ship to id, default bill to customer and defailt bill to id for customer code
		/* Code commented by Damodharan. R on 27 May 2008 for Defect ID DMS412AT_NSO_00052 starts here */ 
		/*
			select	@shiptocustomer		=	cou_dflt_shipto_cust,
				@shiptoaddid		=	cou_dflt_shipto_id				
			from	cust_ou_info_vw (nolock)
			where	cou_lo			=	@cust_lo
			and	cou_bu			=	@cust_bu
			and	cou_ou			=	@cust_ou
			and	cou_cust_code		=	@customercode_tmp
		*/
		/* Code commented by Damodharan. R on 27 May 2008 for Defect ID DMS412AT_NSO_00052 ends here */ 
	
--Code added for RIMT-1112 starts 

		Declare						@lo_id   udd_loid,      
									@company_code1 udd_companycode,      
									@cust_ou1  udd_ctxt_ouinstance,      
									@m_errorid_tmp1 udd_int      
         
	EXEC scm_get_dest_ou		    
									@ctxt_ouinstance,      
									@ctxt_language,      
									@ctxt_user,      
									'pur_qtn',     
									'CU',      
									@cust_ou1 OUT,      
									@m_errorid_tmp1 OUT      
       
   IF								(@m_errorid_tmp1 <> 0)      
   begin      
   return      
   end        
      
Select								@lo_id   = lo_id,      
									@company_code1 = company_code       
   From								emod_lo_bu_ou_vw (nolock)        
   Where								ou_id   = @cust_ou1        
    
 If Exists							( Select 'X'      
    From							cust_tds_info(nolock)        
    Where	ctds_lo					=	@lo_id      
    And		ctds_comp_code			=	@company_code1       
    And		ctds_cust_code			=	@customercode_tmp        
    And		ctds_tax_type			=	'GST'      
    And		ctds_tax_community		=	'INDIA'      
    and		ctds_default			=	'Y'      
    )      
 Begin            
  Select  @customertaxregion		= ctds_region_code,      
          @taxregnno				= ctds_regd_no      
 From cust_tds_info(nolock)        
	Where		ctds_lo				= @lo_id      
	And		ctds_comp_code			= @company_code1       
	And		ctds_cust_code			= @customercode_tmp        
	And		ctds_tax_type           = 'GST'      
	And		ctds_tax_community      = 'INDIA'      
	and       ctds_default =   'Y'      
 End      
		Else      
 Begin      
		Select @customertaxregion	=		'',      
               @taxregnno			=		''      
 End     
--Code added for RIMT-1112 ends

/* Code added by Damodharan. R on 27 May 2008 for Defect ID DMS412AT_NSO_00052 starts here */
      ;
		WITH SQLTMP (destinationouinstid1) as ( select 	distinct sql2k51.destinationouinstid
							from 	fw_admin_view_comp_intxn_model sql2k51 (nolock) 
							where 	sql2k51.sourcecomponentname 	 	=	'NSO' 
							and 	sql2k51.sourceouinstid 		 	=	@ctxt_ouinstance
							and	sql2k51.destinationcomponentname	=	'CU' )
		
		
		select	@shiptocustomer		=	cou_dflt_shipto_cust,
				@shiptoaddid		=	cou_dflt_shipto_id	
		from 	cust_ou_info_vw (nolock) join SQLTMP 
		    on (cou_ou = sqltmp.destinationouinstid1)
		where	cou_cust_code   =	@customercode_tmp
		and		cou_lo			=	@cust_lo
		and		cou_bu			=	@cust_bu
		/* Code added by Damodharan. R on 27 May 2008 for Defect ID DMS412AT_NSO_00052 ends here */ 


		;
		WITH SQLTMP (destinationouinstid1) as (SELECT DISTINCT SQL2K51.destinationouinstid
 			 FROM fw_admin_view_comp_intxn_model SQL2K51
 			 WHERE SQL2K51.sourcecomponentname = 'NSO' and 
				SQL2K51.sourceouinstid = @ctxt_ouinstance and 
				SQL2K51.destinationcomponentname = 'QUOTATION' )

		SELECT	Distinct --ES_NSO_01464
				@addressidml as				'ADDRESSIDML' , 
				@atplevel_hdn as			'ATPLEVEL_HDN' , 
				@atpsl_hdn as				'ATPSL_HDN' , 
				@buid as					'BUID' , 
				@carriercode as				'CARRIERCODE' , 
				RTRIM ( qhdr_currency) as	'CURRENCY' , 
				@cuspono as					'CUSPONO' , 
				@custdetails as				'CUSTDETAILS' , 
				@customer_name_tmp as		'CUSTNAME' , 
				@customercode_tmp as		'CUSTOMERCODE' , 
				@def_info as				'DEF_INFO' , 
				@desc255 as					'DESC255' , 
				/*@freight_bill_hdn*/'Y' as		'FREIGHT_BILL_HDN' ,/*code modified against PJRMC-1253 */ 
				@freightamount as			'FREIGHTAMOUNT' , 
				@frt_currency as			'FRT_CURRENCY' , 
				@frtmethod_hdn as			'FRTMETHOD_HDN' , 
				@gross_volume as			'GROSS_VOLUME' , 
				@gross_weight as			'GROSS_WEIGHT' , 
				@guid as					'GUID' , 
				@hidden_control1 as			'HIDDEN_CONTROL1' , 
				RTRIM ( qhdr_quotnumber) as 'HIDDEN_CONTROL2' , 
				@itemdetail as				'ITEMDETAIL' , 
				@loid as					'LOID' , 
				@netweight as				'NETWEIGHT' , 
				@num_series as				'NUM_SERIES' , 
				qhdr_basicvalue as			'ORD_BAS_VAL' , 
				@ord_det as					'ORD_DET' , 
				@ord_exempt as				'ORD_EXEMPT' , 
				qhdr_totalvalue as			'ORD_TOT_VAL' , 
				@ord_type_hdn as			'ORD_TYPE_HDN' , 
				@order_date as				'ORDER_DATE' , 
				@order_no as				'ORDER_NO' , 
				@overridewt as				'OVERRIDEWT' , 
				@overridvol as				'OVERRIDVOL' , 
				RTRIM ( qhdr_payterm) as	'PAYTERMCODE' , 
				@podate as					'PODATE' , 
				@price_const as				'PRICE_CONST' , 
				@pricelist as				'PRICELIST' , 
				@pricingdate as				'PRICINGDATE' , 
				@promiseddate as			'PROMISEDDATE' , 
				@reqddate as				'REQDDATE' , 
				@resporgunit as				'RESPORGUNIT' , 
				@sale_type as				'SALE_TYPE' , 
				@shippingpoint_hdn as		'SHIPPINGPOINT_HDN' , 
				@shiptoaddid as				'SHIPTOADDID' , 
				@shiptocustomer as			'SHIPTOCUSTOMER' , 
				'SOURCE DOCUMENT DETAILS' as 'SOURCE_DOC' , 
				@sourcedocno as				'SOURCEDOCNO' , 
				@sourcedocument_qso_hdn as	'SOURCEDOCUMENT_QSO_HDN' , 
				@status1 as					'STATUS1' , 
				@timestamp as				'TIMESTAMP' , 
				qhdr_totalcharge as			'TOTAL_CHARGE' , 
				qhdr_totaldiscount as		'TOTAL_DISCOUNT' , 
				qhdr_totaltax as			'TOTAL_TAX' , 
				@total_vat as				'TOTAL_VAT' , 
				@trans_mode as				'TRANS_MODE' , 
				@trantype as				'TRANTYPE' , 
				@vatcalc as					'VATCALC' , 
				@volume_uom as				'VOLUME_UOM' , 
				qdtl.qdtl_warehouse as		'WAREHOUSE' , 
				@weight_uom as				'WEIGHT_UOM' , 
				@wfdockey as				'WFDOCKEY' , 
				@wforgunit as				'WFORGUNIT' , 
				0 as						'FPROWNO',
				/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/	
				rtrim(qhdr_spcode)			'SALESPERSON', 
				null						'FOLDER', 
				rtrim(qhdr_saleschannel1)	'SALESCHANNEL',
				/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/
				@partshipment_hdn			'PARTSHIPMENT_HDN',--Added for DTS ID: ES_NSO_00118
				/*Code Removed for 10H109_NSO_00002 begin*/
				/*
				--'N'							'LCAPPLICABLE'/*Code added for DTS ID: ES_PACKSLIP_00204*/
				*/
				/*Code Removed for 10H109_NSO_00002 end*/
				/*Code Added for 10H109_NSO_00002 begin*/	
				dbo.get_metadata_desc_fn('NSO','COMBO','BG_APPLICABLE','NONE',@ctxt_language)'LCAPPLICABLE'
				/*Code Added for 10H109_NSO_00002 end*/	 
				/*code added for defect id : EBS-1362 starts here*/
				,@customertaxregion					'CUSTOMERTAXREGION' 
				,@owntaxregion						'OWNTAXREGION' 
				,@taxregnno							'TAXREGNNO'
				/*code added for defect id : EBS-1362 ends here*/
		FROM	qtn_quotation_dtl_vw qdtl , 
				qtn_quotation_hdr_vw (NOLOCK) JOIN 
				SQLTMP 
					ON ( qhdr_ouinstance = SQLTMP.destinationouinstid1 )
 		WHERE	qhdr_ouinstance = qdtl.qdtl_ouinstance and 
				qhdr_quotnumber = @sourcedocno and 
				qhdr_quotnumber = qdtl.qdtl_quotnumber
		--ToolComment			select	@addressidml 		'ADDRESSIDML',
		--ToolComment				@atplevel_hdn 		'ATPLEVEL_HDN',
		--ToolComment				@atpsl_hdn 		'ATPSL_HDN',
		--ToolComment     				@buid 			'BUID',
		--ToolComment				@carriercode 		'CARRIERCODE',
		--ToolComment				rtrim(qhdr_currency) 	'CURRENCY',
		--ToolComment     				@cuspono 		'CUSPONO',
		--ToolComment				@custdetails 		'CUSTDETAILS',
		--ToolComment				--rtrim(clo_cust_name) 	'CUSTNAME',
		--ToolComment				@customer_name_tmp	'CUSTNAME',
		--ToolComment     				--rtrim(qhdr_customercode) 'CUSTOMERCODE',
		--ToolComment				@customercode_tmp	'CUSTOMERCODE',
		--ToolComment				@def_info 		'DEF_INFO',
		--ToolComment				@desc255 		'DESC255',
		--ToolComment     				@freight_bill_hdn 	'FREIGHT_BILL_HDN',
		--ToolComment				@freightamount 		'FREIGHTAMOUNT',
		--ToolComment     				@frt_currency 		'FRT_CURRENCY',
		--ToolComment				@frtmethod_hdn 		'FRTMETHOD_HDN',
		--ToolComment				@gross_volume 		'GROSS_VOLUME',
		--ToolComment     				@gross_weight 		'GROSS_WEIGHT',
		--ToolComment				@guid 			'GUID',
		--ToolComment				@hidden_control1 	'HIDDEN_CONTROL1',
		--ToolComment     				rtrim(qhdr_quotnumber) 	'HIDDEN_CONTROL2',
		--ToolComment				@itemdetail 		'ITEMDETAIL',
		--ToolComment				@loid 			'LOID',
		--ToolComment     				@netweight 		'NETWEIGHT',
		--ToolComment				@num_series 		'NUM_SERIES',
		--ToolComment				qhdr_basicvalue 	'ORD_BAS_VAL',
		--ToolComment     				@ord_det 		'ORD_DET',
		--ToolComment				@ord_exempt 		'ORD_EXEMPT',
		--ToolComment				qhdr_totalvalue 	'ORD_TOT_VAL',
		--ToolComment     				@ord_type_hdn 		'ORD_TYPE_HDN',
		--ToolComment				@order_date 		'ORDER_DATE',
		--ToolComment				@order_no 		'ORDER_NO',
		--ToolComment     				@overridewt 		'OVERRIDEWT',
		--ToolComment				@overridvol 		'OVERRIDVOL',
		--ToolComment				rtrim(qhdr_payterm)	'PAYTERMCODE',
		--ToolComment				@podate 		'PODATE',
		--ToolComment     				@price_const 		'PRICE_CONST',
		--ToolComment				@pricelist 		'PRICELIST',
		--ToolComment				@pricingdate 		'PRICINGDATE',
		--ToolComment     				@promiseddate 		'PROMISEDDATE',
		--ToolComment				@reqddate 		'REQDDATE',
		--ToolComment				@resporgunit 		'RESPORGUNIT',
		--ToolComment     				@sale_type 		'SALE_TYPE',
		--ToolComment				@shippingpoint_hdn 	'SHIPPINGPOINT_HDN',
		--ToolComment     				@shiptoaddid 		'SHIPTOADDID',
		--ToolComment				@shiptocustomer 	'SHIPTOCUSTOMER',
		--ToolComment				'SOURCE DOCUMENT DETAILS'  'SOURCE_DOC',
		--ToolComment     				@sourcedocno 		'SOURCEDOCNO',
		--ToolComment				@sourcedocument_qso_hdn 'SOURCEDOCUMENT_QSO_HDN',
		--ToolComment     				@status1 		'STATUS1',
		--ToolComment				@timestamp 		'TIMESTAMP',
		--ToolComment				qhdr_totalcharge 	'TOTAL_CHARGE',
		--ToolComment     				qhdr_totaldiscount 	'TOTAL_DISCOUNT',
		--ToolComment				qhdr_totaltax 		'TOTAL_TAX',
		--ToolComment				@total_vat 		'TOTAL_VAT',
		--ToolComment     				@trans_mode 		'TRANS_MODE',
		--ToolComment				@trantype 		'TRANTYPE',
		--ToolComment				@vatcalc 		'VATCALC',
		--ToolComment     				@volume_uom 		'VOLUME_UOM',
		--ToolComment		/* Code Modified By Aswani K For The Bug ID : PPSCMQSOCUMI_000049 Begins */
		--ToolComment				--@warehouse 		'WAREHOUSE',
		--ToolComment				qdtl.qdtl_warehouse		'WAREHOUSE',
		--ToolComment		/* Code Modified By Aswani K For The Bug ID : PPSCMQSOCUMI_000049 Ends */
		--ToolComment				@weight_uom 		'WEIGHT_UOM',
		--ToolComment     				@wfdockey 		'WFDOCKEY',
		--ToolComment				@wforgunit 		'WFORGUNIT',
		--ToolComment				0 			'FPROWNO'
		--ToolComment			from	qtn_quotation_hdr_vw(nolock),
		--ToolComment		/* Code Added By Aswani K For The Bug ID : PPSCMQSOCUMI_000049 Begins */
		--ToolComment				qtn_quotation_dtl_vw qdtl
		--ToolComment				--cust_lo_info_vw (nolock)
		--ToolComment			where	qhdr_ouinstance		=	qdtl.qdtl_ouinstance
		--ToolComment			and	qhdr_quotnumber		=	@sourcedocno
		--ToolComment			and 	qhdr_quotnumber		=	qdtl.qdtl_quotnumber
		--ToolComment		/* Code Added By Aswani K For The Bug ID : PPSCMQSOCUMI_000049 Ends */
		--ToolComment			--and	clo_lo			=	@cust_lo
		--ToolComment			--and	clo_cust_code		=	qhdr_customercode
		--ToolComment			and	qhdr_ouinstance 	in(	select 	destinationouinstid
		--ToolComment								from  	fw_admin_view_comp_intxn_model  
		--ToolComment								where 	sourcecomponentname    	= 'NSO'
		--ToolComment								and   	sourceouinstid         	= @ctxt_ouinstance
		--ToolComment								and   	destinationcomponentname= 'QUOTATION')
		end

		if	@sourcedocument_qso_hdn = 'CON'
		begin
			declare @contract_type		udd_metadata_code,
					@order_from_cust	udd_customer_id

			select	@contract_type		= conhdr_contract_type,
					@order_from_cust	= conhdr_order_from_cust
			from	so_contract_hdr (nolock)
   		/* Begins - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/
			where --conhdr_ou   = @ctxt_ouinstance and         
   			conhdr_ou  in( select destinationouinstid        
            		 from  fw_admin_view_comp_intxn_model          
             		 where sourcecomponentname     = 'NSO'        
           		  and   sourceouinstid          = @ctxt_ouinstance        
            		 and   destinationcomponentname  = 'nso')       
			and		conhdr_contract_no 	=	@sourcedocno
		/* ends - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/
			if ( @contract_type = 'BSO' )
			begin	
			
		/* Code added by Damodharan. R on 30 May 2008 for Defect ID DMS412AT_NSO_00052 starts here */ 	
		;
		WITH SQLTMP (destinationouinstid1) as ( select 	distinct sql2k51.destinationouinstid
							from 	fw_admin_view_comp_intxn_model sql2k51 (nolock) 
							where 	sql2k51.sourcecomponentname 	 	=	'NSO' 
							and 	sql2k51.sourceouinstid 		 	=	@ctxt_ouinstance
							and	sql2k51.destinationcomponentname	=	'CU' )
		/* Code added by Damodharan. R on 30 May 2008 for Defect ID DMS412AT_NSO_00052 ends here */ 	

				select	@addressidml 			'ADDRESSIDML',
						@atplevel_hdn 			'ATPLEVEL_HDN',
						@atpsl_hdn 				'ATPSL_HDN',
						@buid 					'BUID',
						@carriercode 			'CARRIERCODE',
						rtrim(bsohdr_currency_no) 		'CURRENCY',
						rtrim(conhdr_cust_po_no) 		'CUSPONO',
						rtrim(conhdr_order_from_id)		'CUSTDETAILS',
						rtrim(cou_cust_name) 			'CUSTNAME',
						rtrim(conhdr_order_from_cust)	'CUSTOMERCODE',
						@def_info 				'DEF_INFO',
						@desc255 				'DESC255',
						/*@freight_bill_hdn*/'Y' 		'FREIGHT_BILL_HDN',/*code modified against PJRMC-1253 */
						@freightamount 			'FREIGHTAMOUNT',
						@frt_currency 			'FRT_CURRENCY',
						@frtmethod_hdn 			'FRTMETHOD_HDN',
						@gross_volume 			'GROSS_VOLUME',
						@gross_weight 			'GROSS_WEIGHT',
						@guid 					'GUID',
						@hidden_control1 		'HIDDEN_CONTROL1',
						rtrim(conhdr_contract_no)	'HIDDEN_CONTROL2',
						@itemdetail 			'ITEMDETAIL',
						@loid 					'LOID',
						@netweight 				'NETWEIGHT',
						@num_series 			'NUM_SERIES',
						bsohdr_bso_value 		'ORD_BAS_VAL',
						@ord_det 				'ORD_DET',
						@ord_exempt 			'ORD_EXEMPT',
						bsohdr_bso_value 		'ORD_TOT_VAL',
						@ord_type_hdn 			'ORD_TYPE_HDN',
						convert(nchar(10),@order_date,120) 'ORDER_DATE',
						@order_no 				'ORDER_NO',
						@overridewt 			'OVERRIDEWT',
						@overridvol 			'OVERRIDVOL',
						rtrim(bsohdr_pay_term_code) 	'PAYTERMCODE',
						@podate 				'PODATE',
						@price_const 			'PRICE_CONST',
						@pricelist 				'PRICELIST',
						convert(nchar(10),bsohdr_pricing_date,120)  'PRICINGDATE',
						convert(nchar(10),bsohdr_prm_date_dflt,120) 'PROMISEDDATE',
						convert(nchar(10),bsohdr_req_date_dflt,120) 'REQDDATE',
						@resporgunit 				'RESPORGUNIT',
						rtrim(@sale_type)			'SALE_TYPE',
						bsohdr_ship_point_dflt 		'SHIPPINGPOINT_HDN',
						@shiptoaddid 				'SHIPTOADDID',
						@shiptocustomer 			'SHIPTOCUSTOMER',
						'SOURCE DOCUMENT DETAILS'  	'SOURCE_DOC',
						@sourcedocno 				'SOURCEDOCNO',
						@sourcedocument_qso_hdn 	'SOURCEDOCUMENT_QSO_HDN',
						@status1 					'STATUS1',
						@timestamp 					'TIMESTAMP',
						0.0 						'TOTAL_CHARGE',
						0.0		 					'TOTAL_DISCOUNT',
						0.0 						'TOTAL_TAX',
						@total_vat 					'TOTAL_VAT',
						rtrim(bsohdr_trans_mode_dflt) 	'TRANS_MODE',
						@trantype 					'TRANTYPE',
						@vatcalc 					'VATCALC',
						@volume_uom 				'VOLUME_UOM',
   						 null    'WAREHOUSE',--code added RITSL    
    					      --rtrim(bsohdr_wh_no_dflt)  'WAREHOUSE',    --code commented RITSL             
						@weight_uom 				'WEIGHT_UOM',
						@wfdockey 					'WFDOCKEY',
						@wforgunit 					'WFORGUNIT',
						0 							'FPROWNO',
						/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/	
						rtrim(conhdr_sales_person)	'SALESPERSON', 
						rtrim(conhdr_folder)		'FOLDER', 
						rtrim(bsohdr_sales_channel)	'SALESCHANNEL',
						@partshipment_hdn			'PARTSHIPMENT_HDN',--Added for DTS ID: ES_NSO_00118
						/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/
						/*Code Removed for 10H109_NSO_00002 begin*/
						/*
						--'N'							'LCAPPLICABLE'/*Code added for DTS ID: ES_PACKSLIP_00204*/
						*/
						/*Code Removed for 10H109_NSO_00002 end*/
						/*Code Added for 10H109_NSO_00002 begin*/	
						dbo.get_metadata_desc_fn('NSO','COMBO','BG_APPLICABLE','NONE',@ctxt_language)'LCAPPLICABLE'
						/*Code Added for 10H109_NSO_00002 end*/	 
					    /*code added for defect id : EBS-1362 starts here*/
				        ,@customertaxregion					'CUSTOMERTAXREGION' 
				        ,@owntaxregion						'OWNTAXREGION' 
				        ,@taxregnno							'TAXREGNNO'
				        /*code added for defect id : EBS-1362 ends here*/
				from	so_blanket_order_hdr (nolock),
				/* Code modified by Damodharan. R on 30 May 2008 for Defect ID DMS412AT_NSO_00052 starts here */ 	
					--cust_ou_info_vw (nolock),	
						cust_ou_info_vw (nolock) join SQLTMP
				  on	(cou_ou	=	sqltmp.destinationouinstid1),
				/* Code modified by Damodharan. R on 30 May 2008 for Defect ID DMS412AT_NSO_00052 ends here */ 	
						so_contract_hdr(nolock),					
						fw_admin_view_ouinstance  (nolock)						
	/* Begins - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/
			where --conhdr_ou   = @ctxt_ouinstance and         
   			conhdr_ou  in( select destinationouinstid        
            		 from  fw_admin_view_comp_intxn_model          
             		 where sourcecomponentname     = 'NSO'        
           		  and   sourceouinstid          = @ctxt_ouinstance        
            		 and   destinationcomponentname  = 'nso')       
		/* ends - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/
				and		ouinstid			=	conhdr_ou
				and		conhdr_contract_no	=	@sourcedocno
				and		conhdr_ou			=	bsohdr_ou
				and		conhdr_contract_no	=	bsohdr_contract_no
				and		cou_lo				=	@cust_lo
				and		cou_bu				=	@cust_bu		
				/* Code commented by Damodharan. R on 30 May 2008 for Defect ID DMS412AT_NSO_00052 starts here */ 	
				--and	cou_ou			=	@cust_ou  
				/* Code commented by Damodharan. R on 30 May 2008 for Defect ID DMS412AT_NSO_00052 ends here */ 	
				and		cou_cust_code		=	conhdr_order_from_cust			
				
			end
			else -- If Contract Type = Agreement
			begin
					
				if (@pricingdate is null)
					select  @pricingdate = convert(datetime, convert(nchar(10), dbo.RES_Getdate(@ctxt_ouinstance), 120), 120)
		/* Code commented by Damodharan. R on 27 May 2008 for Defect ID DMS412AT_NSO_00052 starts here */ 
		/*
				select 	@shiptocustomer	= 	cou_dflt_shipto_cust
				from	cust_ou_info_vw
				where	cou_lo		=	@cust_lo
				and	cou_bu		=	@cust_bu
				and	cou_ou		=	@cust_ou			
				and	cou_cust_code	=	@order_from_cust

				select	@shiptoaddid	=	cou_dflt_shipto_id
				from	cust_ou_info_vw
				where	cou_lo		=	@cust_lo
				and	cou_bu		=	@cust_bu
				and	cou_ou		=	@cust_ou	
				and	cou_cust_code	=	@shiptocustomer
		*/
		/* Code commented by Damodharan. R on 27 May 2008 for Defect ID DMS412AT_NSO_00052 ends here */ 

		/* Code added by Damodharan. R on 27 May 2008 for Defect ID DMS412AT_NSO_00052 starts here */ 
		;
		WITH SQLTMP (destinationouinstid1) as ( select 	distinct sql2k51.destinationouinstid
							from 	fw_admin_view_comp_intxn_model sql2k51 (nolock) 
							where 	sql2k51.sourcecomponentname 	 	=	'NSO' 
							and 	sql2k51.sourceouinstid 		 	=	@ctxt_ouinstance
							and	sql2k51.destinationcomponentname	=	'CU' )
		
		
		select 	@shiptocustomer	= 	cou_dflt_shipto_cust	
		from 	cust_ou_info_vw (nolock) join SQLTMP 
		    on (cou_ou = sqltmp.destinationouinstid1)
		where	cou_cust_code   =	@order_from_cust
		and		cou_lo		=	@cust_lo
		and		cou_bu		=	@cust_bu

		;
		WITH SQLTMP (destinationouinstid1) as ( select 	distinct sql2k51.destinationouinstid
							from 	fw_admin_view_comp_intxn_model sql2k51 (nolock) 
							where 	sql2k51.sourcecomponentname 	 	=	'NSO' 
							and 	sql2k51.sourceouinstid 		 	=	@ctxt_ouinstance
							and	sql2k51.destinationcomponentname	=	'CU' )
		
		
		select	@shiptoaddid	=	cou_dflt_shipto_id
		from 	cust_ou_info_vw (nolock) join SQLTMP 
		    on (cou_ou = sqltmp.destinationouinstid1)
		where	cou_cust_code   =	@shiptocustomer
		and	cou_lo		=	@cust_lo
		and	cou_bu		=	@cust_bu
		/* Code added by Damodharan. R on 27 May 2008 for Defect ID DMS412AT_NSO_00052 ends here */ 

				select 	@currency = agrdet_currency,
					@pricelist = agrdet_price_list_no 
				from 	so_agreement_dtl (nolock)
				where 	agrdet_ou   		=	@ctxt_ouinstance 	
				and 	agrdet_contract_no 	=	@sourcedocno
				and 	@pricingdate between agrdet_effective_date and isnull(agrdet_expiry_date, @pricingdate)

				select	@eratetype	=	parameter_value
				from	so_sys_param_ou_vw
				where	ouid		=	@ctxt_ouinstance
				and	component_name	=	'NSO'
				and	parameter_code	=	'SO_EXRATE_TYPE'

				--calling the procedure to get exchange rate
				exec 	scm_sale_exch_rate @ctxt_ouinstance,@ctxt_language,@ctxt_user,@ctxt_service,'NSO',@currency,@order_date,@eratetype,0,@exchangerate out,@m_errorid_tmp  out, @error_msg_qualifier out,@m_error_flag out
				     
				if 	@m_error_flag <> 'S'
				begin
					--calling the procedure to store the error messages in error log table
					--exec	cm_errlogsys_sp	@doctypein,@docid,@doc_ouname,'E:',@error_msg_qualifier
					select	@m_errorid	= @m_errorid_tmp
					return
				end

		/* Code added by Damodharan. R on 30 May 2008 for Defect ID DMS412AT_NSO_00052 starts here */ 	
		;
		WITH SQLTMP (destinationouinstid1) as ( select 	distinct sql2k51.destinationouinstid
							from 	fw_admin_view_comp_intxn_model sql2k51 (nolock) 
							where 	sql2k51.sourcecomponentname 	 	=	'NSO' 
							and 	sql2k51.sourceouinstid 		 	=	@ctxt_ouinstance
							and	sql2k51.destinationcomponentname	=	'CU' )
		/* Code added by Damodharan. R on 30 May 2008 for Defect ID DMS412AT_NSO_00052 ends here */ 	
					
				select	@addressidml 			'ADDRESSIDML',
						@atplevel_hdn 			'ATPLEVEL_HDN',
						@atpsl_hdn 				'ATPSL_HDN',
						@buid 					'BUID',
						@carriercode 			'CARRIERCODE',
						@currency 				'CURRENCY',
						rtrim(conhdr_cust_po_no) 	'CUSPONO',
						rtrim(conhdr_order_from_id)	'CUSTDETAILS',
						rtrim(cou_cust_name) 		'CUSTNAME',
						rtrim(conhdr_order_from_cust)	'CUSTOMERCODE',
						@def_info 				'DEF_INFO',
						@desc255 				'DESC255',
						/*@freight_bill_hdn*/'Y' 		'FREIGHT_BILL_HDN',/*code modified against PJRMC-1253 */
						@freightamount 			'FREIGHTAMOUNT',
						@frt_currency 			'FRT_CURRENCY',
						@frtmethod_hdn 			'FRTMETHOD_HDN',
						@gross_volume 			'GROSS_VOLUME',
						@gross_weight 			'GROSS_WEIGHT',
						@guid 					'GUID',
						@hidden_control1 		'HIDDEN_CONTROL1',
						rtrim(conhdr_contract_no)	'HIDDEN_CONTROL2',
						@itemdetail 			'ITEMDETAIL',
						@loid 					'LOID',
						@netweight 				'NETWEIGHT',
						@num_series 			'NUM_SERIES',
						0.0		 				'ORD_BAS_VAL',
						@ord_det 				'ORD_DET',
						@ord_exempt 			'ORD_EXEMPT',
						0.0		 				'ORD_TOT_VAL',
						@ord_type_hdn 			'ORD_TYPE_HDN',
						convert(nchar(10),@order_date,120) 'ORDER_DATE',
						@order_no 				'ORDER_NO',
						@overridewt 			'OVERRIDEWT',
						@overridvol 			'OVERRIDVOL',
						rtrim(@paytermcode)		'PAYTERMCODE',
						@podate 				'PODATE',
						@price_const 			'PRICE_CONST',
						@pricelist 				'PRICELIST',
						convert(nchar(10),@pricingdate,120)  'PRICINGDATE',
						convert(nchar(10),@promiseddate,120) 'PROMISEDDATE',
						convert(nchar(10),@reqddate,120) 'REQDDATE',
						@resporgunit 				'RESPORGUNIT',
						rtrim(@sale_type)			'SALE_TYPE',
						rtrim(@shippingpoint_hdn)	'SHIPPINGPOINT_HDN',
						@shiptoaddid 				'SHIPTOADDID',
						@shiptocustomer 			'SHIPTOCUSTOMER',
						'SOURCE DOCUMENT DETAILS'  	'SOURCE_DOC',
						@sourcedocno 				'SOURCEDOCNO',
						@sourcedocument_qso_hdn 	'SOURCEDOCUMENT_QSO_HDN',
						@status1 					'STATUS1',
						@timestamp 					'TIMESTAMP',
						0.0 						'TOTAL_CHARGE',
						0.0		 					'TOTAL_DISCOUNT',
						0.0 						'TOTAL_TAX',
						@total_vat 					'TOTAL_VAT',
						rtrim(@trans_mode)	 		'TRANS_MODE',
						@trantype 					'TRANTYPE',
						@vatcalc 					'VATCALC',
						@volume_uom 				'VOLUME_UOM',
						rtrim(@warehouse)  			'WAREHOUSE',
						@weight_uom 				'WEIGHT_UOM',
						@wfdockey 					'WFDOCKEY',
						@wforgunit 					'WFORGUNIT',
						0 							'FPROWNO',
						/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/	
						rtrim(conhdr_sales_person)	'SALESPERSON', 
						rtrim(conhdr_folder)		'FOLDER', 
						rtrim(cou_sales_chnl)		'SALESCHANNEL',
						@partshipment_hdn			'PARTSHIPMENT_HDN',--Added for DTS ID: ES_NSO_00118
						/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/
						/*Code removed for 10H109_NSO_00002 begin */
						/*
						--'N'							'LCAPPLICABLE'/*Code added for DTS ID: ES_PACKSLIP_00204*/
						*/
						/*Code removed for 10H109_NSO_00002 end */
						/*Code Added for 10H109_NSO_00002 begin */
						dbo.get_metadata_code_fn
								(
								 'NSO',	    
								 'COMBO',
								 'BG_APPLICABLE',				     
								 'NONE',				     
								 @ctxt_language	)			'LCAPPLICABLE' 
						/*Code Added for 10H109_NSO_00002 end	*/
						/* Code modified by Damodharan. R on 30 May 2008 for Defect ID DMS412AT_NSO_00052 starts here */ 
						--from	cust_ou_info_vw (nolock),
						/*code added for defect id : EBS-1362 starts here*/
				        ,@customertaxregion					'CUSTOMERTAXREGION' 
				        ,@owntaxregion						'OWNTAXREGION' 
				        ,@taxregnno							'TAXREGNNO'
				        /*code added for defect id : EBS-1362 ends here*/
				from	cust_ou_info_vw (nolock) join SQLTMP
				  on	(cou_ou	=	sqltmp.destinationouinstid1),
				/* Code modified by Damodharan. R on 30 May 2008 for Defect ID DMS412AT_NSO_00052 ends here */ 
						fw_admin_view_ouinstance  (nolock),	
						so_contract_hdr(nolock) 	
				where	conhdr_ou			=	@ctxt_ouinstance 	
				and		ouinstid			=	conhdr_ou
				and		conhdr_contract_no	=	@sourcedocno
				and		cou_lo				=	@cust_lo
				and		cou_bu				=	@cust_bu		
				/* Code commented by Damodharan. R on 30 May 2008 for Defect ID DMS412AT_NSO_00052 starts here */ 
				--and	cou_ou			=	@cust_ou  
				/* Code commented by Damodharan. R on 30 May 2008 for Defect ID DMS412AT_NSO_00052 ends here */ 
				and		cou_cust_code		=	conhdr_order_from_cust	
				
			end
							
		end

/*
Template Select Statement for Selecting data to App Layer
select 
     @addressidml 'ADDRESSIDML',@atplevel_hdn 'ATPLEVEL_HDN',@atpsl_hdn 'ATPSL_HDN',
     @buid 'BUID',@carriercode 'CARRIERCODE',@currency 'CURRENCY',
     @cuspono 'CUSPONO',@custdetails 'CUSTDETAILS',@custname 'CUSTNAME',
     @customercode 'CUSTOMERCODE',@def_info 'DEF_INFO',@desc255 'DESC255',
     @freight_bill_hdn 'FREIGHT_BILL_HDN',@freightamount 'FREIGHTAMOUNT',
     @frt_currency 'FRT_CURRENCY',@frtmethod_hdn 'FRTMETHOD_HDN',@gross_volume 'GROSS_VOLUME',
     @gross_weight 'GROSS_WEIGHT',@guid 'GUID',@hidden_control1 'HIDDEN_CONTROL1',
     @hidden_control2 'HIDDEN_CONTROL2',@itemdetail 'ITEMDETAIL',@loid 'LOID',
     @netweight 'NETWEIGHT',@num_series 'NUM_SERIES',@ord_bas_val 'ORD_BAS_VAL',
     @ord_det 'ORD_DET',@ord_exempt 'ORD_EXEMPT',@ord_tot_val 'ORD_TOT_VAL',
     @ord_type_hdn 'ORD_TYPE_HDN',@order_date 'ORDER_DATE',@order_no 'ORDER_NO',
     @overridewt 'OVERRIDEWT',@overridvol 'OVERRIDVOL',@paytermcode 'PAYTERMCODE',
     @podate 'PODATE',@price_const 'PRICE_CONST',@pricelist 'PRICELIST',
     @pricingdate 'PRICINGDATE',@promiseddate 'PROMISEDDATE',@reqddate 'REQDDATE',
     @resporgunit 'RESPORGUNIT',@sale_type 'SALE_TYPE',@shippingpoint_hdn 'SHIPPINGPOINT_HDN',
     @shiptoaddid 'SHIPTOADDID',@shiptocustomer 'SHIPTOCUSTOMER',@source_doc 'SOURCE_DOC',
     @sourcedocno 'SOURCEDOCNO',@sourcedocument_qso_hdn 'SOURCEDOCUMENT_QSO_HDN',
     @status1 'STATUS1',@timestamp 'TIMESTAMP',@total_charge 'TOTAL_CHARGE',
     @total_discount 'TOTAL_DISCOUNT',@total_tax 'TOTAL_TAX',@total_vat 'TOTAL_VAT',
     @trans_mode 'TRANS_MODE',@trantype 'TRANTYPE',@vatcalc 'VATCALC',
     @volume_uom 'VOLUME_UOM',@warehouse 'WAREHOUSE',@weight_uom 'WEIGHT_UOM',
     @wfdockey 'WFDOCKEY',@wforgunit 'WFORGUNIT',@fprowno 'FPROWNO',
 from  ***
*/
end






