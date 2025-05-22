/*$File_version=ms4.3.0.38$*/
/* VERSION NO: PPS4.1.0.011 */

/******************************************************************************************
file name 	: sopp_ammn_sp_auam_ml.sql
version		: 4.0.0.0
procedure name 	: sopp_ammn_sp_auam_ml
purpose  	: 
author  	: 
component name 	: ppscmqso
method name 	: 
sopp_ammn_m_auam_ml

objects referred
 object name  object type  operation
       (insert/update/delete/select/exec)
modification details
 modified by  modified on  remarks

Modified by		: Mohamed Sheik S.N.
Modified Date	: 22/Aug/2005
Remarks			: Code modified for PP Cross Fix - OTS No PPSCMQSOPPS41_000030

Modified by		: Mukesh B
Modified Date	: 04/Sep/2005
Remarks			: Code modified for PP Cross Fix - OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) 

Modified by		: Mukesh B
Modified Date	: 12/Dec/2005
Remarks			: Code modified for PP Cross Fix - OTS No CUMI_PPSCMQSO_000116 (CUMI Ref:PPSCMQSOCUMI_000070) 
Modified by		: Indu Ram
Modified Date		: 12/Dec/2005
Remarks			: Code modified for PP Cross Fix - OTS No CUMI_PPSCMQSO_000112
******************************************************************************************/ 

/*Modified by			Date					Remarks					*/
/*Geetha.S				7/11/2006				PPSCMQSOPPS41_000082	*/
/* Aswani K				24/07/2006				ETA_nso_000917			*/
/*Indu Ram     			06/Oct/2006  			QUKSHIPPPS41_000071		*/
/*Indu Ram     			09/Oct/2006  			PPSCMQSOPPS41_000096	*/
/*Anitha N     			12/Oct/2006  			PPSCMQSOPPS41_000109	*/
/*Suganya S     		12/Oct/2006  			PPSCMQSOPPS41_000107	*/
/*Suganya S				24/10/2006				PPSCMQSOPPS41_000097	*/
/*Damodharan. R			06 Oct 2007				NSODMS412AT_000526		*/
/*Anitha N				11 Oct 2007				NSODMS412AT_000533		*/
/*Veangadakrishnan R	19/02/2008				DMS412AT_NSO_00024		*/
/*Damodharan R			06 Mar 2007				DMS412AT_CUCPL_00001 	*/
/*Damodharan R			10 Mar 2008				DMS412AT_NSO_00026		*/
/*Anitha N				03 Apr 2008				DMS412AT_NSO_00034		*/
/*Veangadakrishnan R	18/04/2008				DMS412AT_NSO_00030		*/
/*Damodharan. R			07 Aug 2008				ES_NSO_00042			*/
/*Divyalekaa			09/09/2008				DMS412AT_STKSTATUS_00003*/		
/*Jagadeesan RS			17/10/2008				ES_NSO_00080			*/
/*Balaji Prasad P.R		30/10/2008				ES_PACKSLIP_00049		*/
/*Jagadeesan RS			07/11/2008				ES_cobi_00047		    */
/*Veangadakrishnan R	23/12/2008				ES_NSO_00112			*/
/*Ananth P.				06/01/2009				ES_NSO_00129			*/
/*Sujatha S				22/01/2009				ES_NSO_00108			*/
/*Damodharan. R			12 Feb 2009				ES_NSO_00168			*/
/*Veangadakrishnan R	23/03/2009				ES_NSO_00206			*/
/*Sujatha S				08/06/2009				ES_NSO_00260			*/
/*Divyalekaa			04/08/2009				9H123-1_NSO_00022		*/
/*Divyalekaa			12/01/2010				9H123-1_NSO_00042		*/
/*Chockalingam.S		28/06/2010				ES_NSO_00392	  */
/*Deepti Das			04/07/2012				ES_NSO_00565 		*/
/*Rajkumar.S			20/07/2012				ES_NSO_00558			*/
/*Divyalekaa			29/11/2013				ES_Po_01439				*/
/*Prabhakaran			25 Mar 2014				ES_NSO_00747			*/
/*Prabhakaran			01 Apr 2014				ES_NSO_00748			*/
/*Prabhakaran			10 Apr 2014				ES_NSO_00748:14H109_NSO_00002	*/
/*Bharath A				09/09/2015				14H109_WFMCONFIG_00005	*/
/*Dinesh.S				07/02/2018				EBS-971							*/
/*Balasubramaniyam P	14/06/2018				EBS-1362*/
/*Abinaya G				31/01/2019				PEPS-20						*/
/*Abinaya G				09/02/2019				PEPS-116					*/
/*Prakash V				07/03/2019				GSE-780									*/
/*Banu M                04/07/2019              MAT-685	*/
/*Abinaya G				20/09/2019				RFBE-14									*/
/*Bharath A				24_Sep_2019				PEPS-632								*/
/* Gopi V				30/11/2020				EPE-27452					*/ 
/*Vasantha a			21/07/2022				JPE-1857					*/
/*Vijay Shree			19/08/2024				EPE-87219					*/
/*Nandhakumar B         17/12/2024               PJRMC-799*/
/******************************************************************************************/
create   procedure sopp_ammn_sp_auam_ml
--temporary store for input parameter assignment
	@amendno					udd_number ,
	@atp_ml						udd_itemstatus ,
	@buid						udd_buid ,                 
	@ctxt_language				udd_ctxt_language ,
	@ctxt_ouinstance			udd_ctxt_ouinstance ,
	@ctxt_service				udd_ctxt_service ,
	@ctxt_user					udd_ctxt_user ,
	@ead						udd_date ,
	@extprice					udd_price ,
	@gua_shelflife				udd_shelflife ,
	@guid						udd_guid ,
	@hidden_control1			udd_hiddencontrol ,
	@hidden_control2			udd_hiddencontrol ,
	@item						udd_itemcode ,
	@item_var_desc				udd_item_desc ,
	@line_no					udd_lineno ,
	@loid						udd_loid ,
	@modeflag					udd_modeflag ,
	@ord_type_hdn				udd_metadata_code ,
	@order_no					udd_documentno ,
	@pricelist					udd_pricelist ,
	@pricelistno				udd_pricelist ,
	@priceuomml					udd_uomcode ,
	@pricingdate				udd_date ,
	@processingactionml			udd_identificationnumber1 ,
	@promiseddate				udd_date ,
	@promiseddateml				udd_date ,
	@promotype					udd_type ,
	@qty						udd_quantity ,
	@reqddate					udd_date ,
	@reqddateml					udd_date ,
	@resporgunit				udd_ouinstname ,
	@sale_uomcode				udd_uomcode ,
	@shelf_life_unit_mul		udd_timeunit ,
	@shelf_life_unit_mul_hdn	udd_metadata_code ,
	@shippingpointml			udd_ouinstname ,
	@shippingpointml_hdn		udd_ouinstid ,
	@shiptoaddid				udd_id ,
	@shiptocustomer				udd_customer_id ,
	@shiptocustomercode			udd_customer_id ,
	@shiptoidml					udd_id ,
	@timestamp					udd_timestamp ,
	@to_shipdateml				udd_date ,
	@unitfrprice				udd_price ,
	@unititmprice				udd_price ,
	@unitprice_ml				udd_price ,
	@variantml					udd_variant ,
	@warehouse					udd_warehouse ,
	@warehousemulti				udd_warehouse ,
	@wfdockey					udd_wfdockey ,
	@wforgunit					udd_wforgunit ,
	@youritemcode_ml			udd_itemcode ,
	@fprowno					udd_rowno ,
	 /*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/
	@fb_docml					udd_financebookid, --Input
	@usagecccodeml				udd_item_usage, --Input
	@itemtype					udd_itemtype, --Input
	@stockstatus				udd_status, --Input
	@stockstatus_hdn			udd_code, --Input
	@shippartial				udd_flag, --Input
	@shippartial_hdn			udd_metadata_code, --Input
	@con_forcast				udd_flag, --Input
	@con_forcast_hdn			udd_metadata_code, --Input
	@salespurpose				udd_purpose, --Input
	@salespurpose_hdn			udd_identificationnumber1, --Input
	 /*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/
	 /*Code added by Ananth P. against: ES_NSO_00129 Begins*/
	@fb_doc						udd_financebookid,
	@usagecccode				udd_item_usage,
	@delivery_line_description 	udd_text255, --Input -- added for ES_NSO_00565 
	 /*Code added by Ananth P. against: ES_NSO_00129 Ends*/
	/*Code added for ES_Po_01439 begins here*/	
	@so_projou					udd_ouinstname,
	@so_projcode				udd_unitcode,
	@so_projdesc				udd_txt150,
	@so_wbsid					udd_unitcode,
	@so_taskcode				udd_unitcode,
	@so_taskdesc				udd_prj_taskdesc,
	/*Code added for ES_Po_01439 ends here*/
	@remarks_amnso           	udd_desc1000,--code added by EBS-971
	@customeritemdesc           udd_desc255,--code added for EPE-27452 		 
	@m_errorid					udd_INT OUTPUT --to return execution status
	/*Code Added for 14H109_WFMCONFIG_00005 begin */
	,@fin_error					udd_int	=	null	output,
	@callingservice				udd_ctxt_service	=	null
	/*Code Added for 14H109_WFMCONFIG_00005 end*/
AS
BEGIN
	--declare @iudmodeflag nvarchar(2) 
	/* Code added by Damodhara. R on 10 Mar 2008 for DTS ID DMS412AT_NSO_00026 starts here */
	DECLARE @quoted_qty_tmp   udd_quantity
	DECLARE @tot_ord_qty_tmp  udd_quantity
	/* Code added by Damodhara. R on 10 Mar 2008 for DTS ID DMS412AT_NSO_00026 ends here */
	
	-- nocount should be sw
	--itched on to prevent phantom rows 
	SET NOCOUNT ON
	-- @m_errorid should be 0 to indicate success
	SELECT @m_errorid = 0
	
	
	
	IF @amendno = -915
	    SELECT @amendno = NULL
	
	SELECT @atp_ml = LTRIM(RTRIM(@atp_ml))
	IF @atp_ml = '~#~'
	    SELECT @atp_ml = NULL
	
	SELECT @buid = LTRIM(RTRIM(@buid))
	IF @buid = '~#~'
	    SELECT @buid = NULL
	
	IF @ctxt_language = -915
	    SELECT @ctxt_language = NULL
	
	IF @ctxt_ouinstance = -915
	    SELECT @ctxt_ouinstance = NULL
	
	SELECT @ctxt_service = LTRIM(RTRIM(@ctxt_service))
	IF @ctxt_service = '~#~'
	    SELECT @ctxt_service = NULL
	
	SELECT @ctxt_user = LTRIM(RTRIM(@ctxt_user))
	IF @ctxt_user = '~#~'
	    SELECT @ctxt_user = NULL
	
	IF @ead = '01/01/1900'
	    SELECT @ead = NULL
	
	IF @extprice = -915
	    SELECT @extprice = NULL
	
	IF @gua_shelflife = -915
	    SELECT @gua_shelflife = NULL
	
	SELECT @guid = LTRIM(RTRIM(@guid))
	IF @guid = '~#~'
	    SELECT @guid = NULL
	
	SELECT @hidden_control1 = LTRIM(RTRIM(@hidden_control1))
	IF @hidden_control1 = '~#~'
	    SELECT @hidden_control1 = NULL
	
	SELECT @hidden_control2 = LTRIM(RTRIM(@hidden_control2))
	IF @hidden_control2 = '~#~'
	    SELECT @hidden_control2 = NULL
	
	SELECT @item = LTRIM(RTRIM(@item))
	IF @item = '~#~'
	    SELECT @item = NULL
	
	SELECT @item_var_desc = LTRIM(RTRIM(@item_var_desc))
	IF @item_var_desc = '~#~'
	    SELECT @item_var_desc = NULL
	
	IF @line_no = -915
	    SELECT @line_no = NULL
	
	SELECT @loid = LTRIM(RTRIM(@loid))
	IF @loid = '~#~'
	    SELECT @loid = NULL
	
	SELECT @modeflag = LTRIM(RTRIM(@modeflag))
	IF @modeflag = '~#~'
	    SELECT @modeflag = NULL
	
	SELECT @ord_type_hdn = LTRIM(RTRIM(@ord_type_hdn))
	IF @ord_type_hdn = '~#~'
	    SELECT @ord_type_hdn = NULL
	
	SELECT @order_no = LTRIM(RTRIM(UPPER(@order_no)))
	IF @order_no = '~#~'
	    SELECT @order_no = NULL
	
	SELECT @pricelist = LTRIM(RTRIM(UPPER(@pricelist)))
	IF @pricelist = '~#~'
	    SELECT @pricelist = NULL
	
	SELECT @pricelistno = LTRIM(RTRIM(UPPER(@pricelistno)))
	IF @pricelistno = '~#~'
	    SELECT @pricelistno = NULL
	
	SELECT @priceuomml = LTRIM(RTRIM(UPPER(@priceuomml)))
	IF @priceuomml = '~#~'
	    SELECT @priceuomml = NULL
	
	IF @pricingdate = '01/01/1900'
	    SELECT @pricingdate = NULL
	
	SELECT @processingactionml = LTRIM(RTRIM(UPPER(@processingactionml)))
	IF @processingactionml = '~#~'
	    SELECT @processingactionml = NULL
	
	IF @promiseddate = '01/01/1900'
	    SELECT @promiseddate = NULL
	
	IF @promiseddateml = '01/01/1900'
	    SELECT @promiseddateml = NULL
	
	SELECT @promotype = LTRIM(RTRIM(@promotype))
	IF @promotype = '~#~'
	    SELECT @promotype = NULL
	
	IF @qty = -915
	    SELECT @qty = NULL
	
	IF @reqddate = '01/01/1900'
	    SELECT @reqddate = NULL
	
	IF @reqddateml = '01/01/1900'
	    SELECT @reqddateml = NULL
	
	SELECT @resporgunit = LTRIM(RTRIM(@resporgunit))
	IF @resporgunit = '~#~'
	    SELECT @resporgunit = NULL
	
	SELECT @sale_uomcode = LTRIM(RTRIM(UPPER(@sale_uomcode)))
	IF @sale_uomcode = '~#~'
	    SELECT @sale_uomcode = NULL
	
	SELECT @shelf_life_unit_mul_hdn = LTRIM(RTRIM(UPPER(@shelf_life_unit_mul_hdn)))
	IF @shelf_life_unit_mul_hdn = '~#~'
	    SELECT @shelf_life_unit_mul_hdn = NULL
	
	IF @shippingpointml_hdn = -915
	    SELECT @shippingpointml_hdn = NULL
	
	SELECT @shiptoaddid = LTRIM(RTRIM(UPPER(@shiptoaddid)))
	IF @shiptoaddid = '~#~'
	    SELECT @shiptoaddid = NULL
	
	SELECT @shiptocustomer = LTRIM(RTRIM(UPPER(@shiptocustomer)))
	IF @shiptocustomer = '~#~'
	    SELECT @shiptocustomer = NULL
	
	SELECT @shiptocustomercode = LTRIM(RTRIM(UPPER(@shiptocustomercode)))
	IF @shiptocustomercode = '~#~'
	    SELECT @shiptocustomercode = NULL
	
	SELECT @shiptoidml = LTRIM(RTRIM(UPPER(@shiptoidml)))
	IF @shiptoidml = '~#~'
	    SELECT @shiptoidml = NULL
	
	IF @timestamp = -915
	    SELECT @timestamp = NULL
	
	IF @to_shipdateml = '01/01/1900'
	    SELECT @to_shipdateml = NULL
	
	IF @unitfrprice = -915
	    SELECT @unitfrprice = NULL
	
	IF @unititmprice = -915
	    SELECT @unititmprice = NULL
	
	IF @unitprice_ml = -915
	    SELECT @unitprice_ml = NULL
	
	SELECT @variantml = LTRIM(RTRIM(@variantml))
	IF @variantml = '~#~'
	    SELECT @variantml = NULL
	
	SELECT @warehouse = LTRIM(RTRIM(UPPER(@warehouse)))
	IF @warehouse = '~#~'
	    SELECT @warehouse = NULL
	
	SELECT @warehousemulti = LTRIM(RTRIM(UPPER(@warehousemulti)))
	IF @warehousemulti = '~#~'
	    SELECT @warehousemulti = NULL
	
	SELECT @wfdockey = LTRIM(RTRIM(UPPER(@wfdockey)))
	IF @wfdockey = '~#~'
	    SELECT @wfdockey = NULL
	
	IF @wforgunit = -915
	    SELECT @wforgunit = NULL
	
	SELECT @youritemcode_ml = LTRIM(RTRIM(UPPER(@youritemcode_ml)))
	IF @youritemcode_ml = '~#~'
	    SELECT @youritemcode_ml = NULL
	
	IF @fprowno = -915
	 SELECT @fprowno = NULL
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/	
	SELECT @fb_docml = LTRIM(RTRIM(@fb_docml))
	IF @fb_docml = '~#~'
	    SELECT @fb_docml = NULL
	
	SELECT @usagecccodeml = LTRIM(RTRIM(@usagecccodeml)) 
	IF @usagecccodeml = '~#~'
	    SELECT @usagecccodeml = NULL
	
	SELECT @itemtype = LTRIM(RTRIM(@itemtype))
	IF @itemtype = '~#~'
	    SELECT @itemtype = NULL
	
	SELECT @stockstatus = LTRIM(RTRIM(@stockstatus))
	IF @stockstatus = '~#~'
	    SELECT @stockstatus = NULL
	
	SELECT @stockstatus_hdn = LTRIM(RTRIM(@stockstatus_hdn))
	IF @stockstatus_hdn = '~#~'
	    SELECT @stockstatus_hdn = NULL
	
	SELECT @shippartial = LTRIM(RTRIM(@shippartial))
	IF @shippartial = '~#~'
	    SELECT @shippartial = NULL
	
	SELECT @shippartial_hdn = LTRIM(RTRIM(@shippartial_hdn))  
	IF @shippartial_hdn = '~#~'
	    SELECT @shippartial_hdn = NULL
	
	SELECT @con_forcast = LTRIM(RTRIM(@con_forcast)) 
	IF @con_forcast = '~#~'
	    SELECT @con_forcast = NULL
	
	SELECT @con_forcast_hdn = LTRIM(RTRIM(@con_forcast_hdn)) 
	IF @con_forcast_hdn = '~#~'
	    SELECT @con_forcast_hdn = NULL
	
	SELECT @salespurpose = LTRIM(RTRIM(@salespurpose))  
	IF @salespurpose = '~#~'
	    SELECT @salespurpose = NULL
	
	SELECT @salespurpose_hdn = LTRIM(RTRIM(@salespurpose_hdn)) 
	IF @salespurpose_hdn = '~#~'
	    SELECT @salespurpose_hdn = NULL 
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/ 
	/*Code added by Ananth P. against: ES_NSO_00129 Begins*/
	SELECT @fb_doc = LTRIM(RTRIM(@fb_doc))
	IF @fb_doc = '~#~'
	    SELECT @fb_doc = NULL
	
	SELECT @usagecccode = LTRIM(RTRIM(@usagecccode))
	IF @usagecccode = '~#~'
	    SELECT @usagecccode = NULL
	/*Code added by Ananth P. against: ES_NSO_00129 Ends*/
	
	/*code added for defect id : ES_NSO_00565  starts*/
	Select @delivery_line_description  = ltrim(rtrim(@delivery_line_description))
	IF @delivery_line_description = '~#~' 
		Select @delivery_line_description = null  
	/*code added for defect id : ES_NSO_00565  ends*/	
	
		/*code added for EBS-971 starts here*/
	select @remarks_amnso  = ltrim(rtrim(@remarks_amnso)) 
	if @remarks_amnso = '~#~' 
		select @remarks_amnso = null  	
	/*code added for EBS-971 ends here*/
	 /*code added for EBS-5187/EPE-27452 starts here*/ 
	select @customeritemdesc = ltrim(rtrim(@customeritemdesc))  
	IF @customeritemdesc = '~#~'    
		Select @customeritemdesc = null   
 /*code added for EBS-5187/EPE-27452 starts here*/  
  

	/*Code added for ES_Po_01439 begins here*/	
	select @so_projou	= ltrim(rtrim(@so_projou))  
	select @so_projcode = ltrim(rtrim(@so_projcode))  
	select @so_projdesc = ltrim(rtrim(@so_projdesc))  
	select @so_wbsid	= ltrim(rtrim(@so_wbsid))  
	select @so_taskcode = ltrim(rtrim(@so_taskcode))  
	select @so_taskdesc = ltrim(rtrim(@so_taskdesc)) 
	
	if @so_projou = '~#~'
		select @so_projou = null
	if @so_projcode = '~#~'
		select @so_projcode = null		
	if @so_projdesc = '~#~'
		select @so_projdesc = null
	if @so_wbsid = '~#~'
		select @so_wbsid = null	
	if @so_taskcode = '~#~'
		select @so_taskcode = null
	if @so_taskdesc = '~#~'
		select @so_taskdesc = null						 							
	/*Code added for ES_Po_01439 ends here*/		
		
	/*
	template select statement for selecting data to app layer
	select 
	@fprowno 'FPROWNO'
	from  ***
	*/
	
	--temp variable
	DECLARE @cust_ou               udd_ctxt_ouinstance,
	        @cust_bu               udd_buid,
	        @item_ou               udd_ctxt_ouinstance,
	   @sp_ou                 udd_ctxt_ouinstance,
	        @wh_ou                 udd_ctxt_ouinstance,
	        @lo                    udd_loid,
	        @lo_item               udd_loid,
	        --@con_forml_hdn		udd_metadata_code,--commented for DTS ID: DMS412AT_NSO_00030
	        @bu_item               udd_buid,
	        @deliveryarea          udd_deliveryarea,
	        @item_type             udd_metadata_code,
	        @line_status           udd_metadata_code,
	        @line_status_tmp       udd_metadata_code,
	        @price_flag udd_metadata_code,
	        @customercode          udd_customer_id,
	        @item_wt               udd_quantity,
	        @item_volume           udd_quantity,
	        @orderdate             udd_date,
	        @order_status          udd_metadata_code,
	        @salepurposeml         udd_category_code,
	        @tcd_cal_flag          udd_flag,
	        @update_flag           udd_flag,
	        @tcd_dflt_flag         udd_flag,
	        @confactor             udd_quantity,
	        @stock_qty             udd_quantity,
	        @model_config_code     udd_documentno,
	        @model_config_var      udd_documentno,
	        @planningtype          udd_metadata_code,
	        @trans_mode            udd_metadata_code,
	        @line_no_tmp           udd_lineno,
	        @m_errorid_tmp         udd_INT,
	        @pricelist_amend_no    udd_lineno,
	        @prom_dflt_flag        udd_metadata_code,
	        @reserve_dtml          udd_date,
	        @preffered_carrier     udd_carriercode,
	        @sale_ord_type         udd_optioncode,
	        @sale_type             udd_metadata_code,
	        @spcodeml              udd_saleperson_id,
	        @currency              udd_currencycode,
	        @ref_doc_flag          udd_metadata_code,
	        @schtype_hdn           udd_metadata_code,
	        @processingaction_hdn  udd_metadata_code,
	        @sales_chan            udd_saleschannel,
	        @number_series         udd_notypeno,
	        @documentno            udd_documentno,
	        @documentouid          udd_ctxt_ouinstance,
	        @folder                udd_folder,
	        @sourcedocument        udd_sourcedocument,
	        @refdoclineno          udd_lineno,
	        @zero_it_rate          udd_optioncode,
	        @price_rule_no         udd_documentno,
	        @referencescheduleno   udd_lineno,
	        --@usagecccodeml		udd_item_usage,
	        @sale_account          udd_accountcode,
	        @analysiscode_out      udd_analysiscode,
	        @subanalysiscode_out   udd_subanalysiscode,
	        --@shippartial_hdn	udd_metadata_code,
	        @frt_method            udd_metadata_code,
	        @incoplace             udd_city,
	        @pricingdateml         udd_date,
	        @cost_center           udd_maccost,
	        @promotionid           udd_desc40,
	        @reasoncode            udd_desc40,
	        @receipttype           udd_desc40,
	        @shelf_life_period     udd_shelflife,
	        @shelf_life_unit       udd_timeunit,
	        @packqty               udd_quantity,
	        @pickqty               udd_quantity,
	        @bhqty                 udd_quantity,
	        @sch_qty               udd_quantity,
	        /*Code Added for the DTS id:ES_NSO_00206 starts here*/
	        @activity_flag         udd_metadata_code,
	        @wfstatus_code         udd_metadata_code,
	        @workflow_app          udd_metadata_code,
	        @wfstatus              udd_cm_docstatus
	/*Code Added for the DTS id:ES_NSO_00206 ends here*/
	
	/*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 starts here*/
	DECLARE @analysiscode_tmp      udd_analysiscode,
	        @subanalysiscode_tmp   udd_subanalysiscode,
	        @fb_doc_tmp            udd_financebookid
	/*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 ends here*/
	
	--@stock_status	udd_code --DMS412AT_NSO_00034
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/ 
	--declare @fb_docml		udd_financebookid		--Damodharan added for OTS ID NSODMS412AT_000526
	----Damodharan added for OTS ID NSODMS412AT_000526 begins
	--		select	@fb_docml		=	sodtl_fbdoc
	--		from	so_order_item_dtl nolock
	--		where	sodtl_ou		=	@ctxt_ouinstance
	--		and		sodtl_order_no	=	@order_no
	--		and		sodtl_line_no	=	@line_no
	----Damodharan added for OTS ID NSODMS412AT_000526 ends
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/	
	
	SELECT @salepurposeml = @salespurpose_hdn --Added for DTS ID: DMS412AT_NSO_00030
	
	/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 + Begin*/
	
	DECLARE @feature_flag_yes_no udd_yesnoflag
	SELECT	@feature_flag_yes_no = flag_yes_no
	FROM	pps_feature_list(NOLOCK)
	WHERE  	UPPER(feature_id) = 'PPS_FID_0041'
	AND 	UPPER(component_name) = 'NSO'
	
	IF ISNULL(@feature_flag_yes_no, '') = ''
	    SELECT @feature_flag_yes_no = 'NO'
	
	/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 + End*/
	
	--select @con_forml_hdn = 'Y' --DMS412AT_NSO_00034
	/*Code merged by Indu for CUMI_PPSCMQSO_000112 on 12/Dec/2005 Begin*/
	/* Code Modified By Aswani K For The Bug ID : ETA_nso_000917 ON 24/07/2006 Starts */
	--	select @guid = replace(replace(@guid,'{',''),'}','')
	/* Code Modified By Aswani K For The Bug ID : ETA_nso_000917 ON 24/07/2006 Ends */
	/*Code merged by Indu for CUMI_PPSCMQSO_000112 on 12/Dec/2005 End*/
	
	/*Code modified by Indu for QUKSHIPPPS41_000071 on 06/Oct/2006 Begins*/
	SELECT @guid = REPLACE(REPLACE(@guid, '{', ''), '}', '')
	/*Code modified by Indu for QUKSHIPPPS41_000071 on 06/Oct/2006 Ends*/
	
	/* Code added for ITS ID : ES_NSO_00748	 Begins */
	declare	@refdocexist		udd_metadata_code
	
	select @refdocexist		=	'N'	
	
	select 	@refdocexist = case	when	sohdr_ref_doc_type in ('CON','QUO')	then	'Y'
									else	'N'
							end
	from	so_order_hdr (nolock)
	where  	sohdr_ou		=	@ctxt_ouinstance
	and		sohdr_order_no	=	@order_no
	and		sohdr_amend_no	=	@amendno	
	/* Code added for ITS ID : ES_NSO_00748	 Ends */	
	--code added and modified for ES_NSO_00108 starts
	

	IF @modeflag = 'D'   AND @line_no IS NOT NULL
	BEGIN
	    DECLARE @soprevstatus  udd_statuscode,
	            @solinestatus  udd_statuscode
		--Code added for EPE-87219 begins
				,@sopackqty		udd_quantity
				,@sodirpackqty	udd_quantity
				,@sobillholdqty udd_quantity
				,@sopickqty		udd_quantity
				,@soinvoiceqty	udd_quantity
		--Code added for EPE-87219 ends	    
	    SELECT	@soprevstatus = sodtl_line_prev_status,
				@solinestatus = sodtl_line_status
				--Code added for EPE-87219 begins
				,@sopackqty		=	sodtl_pack_qty
				,@sodirpackqty	=	sodtl_direct_pack_qty
				,@sopickqty		=	sodtl_pick_qty 
				,@sobillholdqty =	sodtl_bill_hold_qty
				,@soinvoiceqty	 =  sodtl_invoiced_qty
				--Code added for EPE-87219 ends
	    FROM	so_order_item_dtl(NOLOCK)
	    WHERE  	sodtl_ou = @ctxt_ouinstance
	    AND 	sodtl_order_no = @order_no
	    AND 	sodtl_line_no = @line_no
	    
		--Code modified for EPE-87219 begins
	    --IF @soprevstatus IS NULL   AND @solinestatus = 'FR'
		if (@soprevstatus IS NULL   AND @solinestatus = 'FR') or 
		(isnull(@sopackqty,0) = 0 and isnull(@sodirpackqty,0) = 0 and isnull(@sopickqty,0) = 0 and isnull(@sobillholdqty,0) = 0 and isnull(@soinvoiceqty,0)=0)
		--Code modified for EPE-87219 ends
	    BEGIN
		
	        --calling the procedure to delete the detail tables            
	        EXEC so_cmn_line_delete @ctxt_language,
	             @ctxt_ouinstance,
	             @ctxt_service,
	             @ctxt_user,
	             @order_no,
	             @line_no,
	             'Y'
	    END
	    ELSE    
	    BEGIN
	        --Items can not be deleted ,Please check
	        SELECT @m_errorid = 3550344
	        RETURN
	    END
	    
	    
		/*Code Added for 14H109_WFMCONFIG_00005 begin */
		if	@callingservice	is	null
		begin
		/*Code Added for 14H109_WFMCONFIG_00005 end */
		
	    SELECT @fprowno 'FPROWNO'
	    RETURN
	    
	    end	--Code Added for 14H109_WFMCONFIG_00005
	END
	--code added and modified for ES_NSO_00108 ends
	
	/*Code Added for the DTS id:ES_NSO_00206 starts here*/
	SELECT	@wfstatus		= ISNULL(sohdr_workflow_status, '')
	FROM	so_order_hdr(NOLOCK)
	WHERE  	sohdr_ou		= @ctxt_ouinstance
	AND 	sohdr_order_no	= @order_no
	
	SELECT @workflow_app = dbo.workflowapp_fet_fn(@ctxt_user, @ctxt_ouinstance, 'NSO', 'NSOSO', 'AMAU')
	
	SELECT @wfstatus_code = ISNULL(dbo.wf_metacode_fet_fn('NSOSO', @wfstatus), 'AMD')
	
	IF @ctxt_service = 'SOPP_AMMN_SER_AUTH1'
	    SELECT @activity_flag = 'AU'   
	
	IF @activity_flag = 'AU'   AND @wfstatus_code NOT IN ('AMD', '')   AND @workflow_app 
	   = 'Y'
	BEGIN
	    IF @modeflag NOT IN ('S', 'Z')
	    BEGIN
			select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
	        --'Document has moved to next level.Hence Cannot make modifications to the Document.'
	        EXEC fin_german_raiserror_sp 'NSO',
	             @ctxt_language,
	             1005
	        
	        RETURN
	    END
	END 
	/*Code Added for the DTS id:ES_NSO_00206 ends here*/ 

	
	SELECT @m_errorid_tmp = 0,
	       @m_errorid = 0,
	      @refdoclineno = NULL,
	       @referencescheduleno = NULL 
	
	--get the header information
	SELECT @preffered_carrier		= sohdr_prefered_carrier,
	       @sale_type				= sohdr_sale_type_dflt,
	       @sales_chan				= sohdr_sales_channel,
	       @number_series			= sohdr_num_series,
	       @folder					= sohdr_folder,
	       @currency				= sohdr_currency,
	       @ref_doc_flag			= sohdr_ref_doc_flag,
	       @documentno				= sohdr_ref_doc_no,
	       @documentouid			= sohdr_ref_doc_ou,
	       @sourcedocument			= sohdr_ref_doc_type,
	       @orderdate				= sohdr_order_date,
	       @zero_it_rate			= sohdr_zero_item_rate,
	       @receipttype				= sohdr_receipt_method,
	       @processingaction_hdn	= sohdr_proc_actn_dflt,
	       @order_status			= sohdr_order_status,
	       @customercode			= sohdr_order_from_cust,
	       --@shippartial_hdn   =	sohdr_ship_partial_dflt, --commented for DTS ID: DMS412AT_NSO_00030
	       @trans_mode				= sohdr_trnsprt_mode_dflt,
	       @frt_method				= sohdr_freight_method,
	       @sale_ord_type			= sohdr_order_type--ES_NSO_00260
	FROM   so_order_hdr(NOLOCK)
	WHERE  	sohdr_ou = @ctxt_ouinstance
	AND 	sohdr_order_no = @order_no 
	
	IF RTRIM(@frt_method) IN ('FA', 'NONE')
	    SELECT @unitfrprice = 0

	/*Code added for 9H123-1_NSO_00042 begins here*/
	declare	@exp_item_group		udd_metadata_code	--9H123-1_NSO_00042  

	IF	rtrim(@ctxt_service) in ('sopp_ammn_ser_auam1','sopp_ammn_ser_auth1')
	BEGIN

		select	@exp_item_group  = isnull(sosys_parameter_value,'N')
		from	so_system_param_dtl	(nolock)
		where	sosys_ou		=	@ctxt_ouinstance
		and		sosys_parameter_code	=	'EXP_ITEM_GROUP'

		if @sale_type  = 'EXP'	and	@exp_item_group	=	'Y' 	
		begin

			if exists (	select 	'X' 
						from 	item_group_master_vw(nolock) 
						where 	lo_id 		= 	@loid
						AND 	group_type 	= 	'SALES'
						AND 	category 	= 	'S'
						AND 	usage 		= 	'SL'
						and 	item_code 	=   	@item
					)
			begin
				select 	@ctxt_ouinstance = @ctxt_ouinstance
			end 
			else
			begin
				select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
				exec fin_german_raiserror_sp 'NSO',@ctxt_language,59
				return
			end
		end
	END
	/*Code added for 9H123-1_NSO_00042 ends here*/	
	
	--Commented for DTS ID: ES_NSO_00112 starts here             
	/*Code modified for ES_NSO_00080 begins here*/
	/*if @processingactionml = 'DROP' and @warehousemulti is not null
	begin
	--	    raiserror('Warehouse code should be blank for Process Action "DROP" at row no.%d',16,1,@fprowno)
	exec fin_german_raiserror_sp 'NSO',@ctxt_language,125,@fprowno
	return
	end*/
	/*Code modified for ES_NSO_00080 ends here*/
	--Commented for DTS ID: ES_NSO_00112 ends here             
	
	--get the reference document lineno and line status
	--code modified by Anitha N for PPSCMQSOPPS41_000109 on 12/10/2006 begins
	-- 	if	@line_no is not null 
	IF @line_no IS NOT NULL   AND (@modeflag NOT IN ('I', 'X'))
	   --code modified by Anitha N for PPSCMQSOPPS41_000109 on 12/10/2006 ends
	BEGIN
	    SELECT @refdoclineno		= sodtl_ref_doc_line_no,
	           @line_status			= sodtl_line_status,
	           @schtype_hdn			= sodtl_sch_type,
	           --@processingactionml 	=   	sodtl_proc_action_dflt,--commented for ES_NSO_00108
	           --@usagecccodeml		=	sodtl_usage_for_cc, --commented for DTS ID: DMS412AT_NSO_00030
	           @shelf_life_unit		= sodtl_shelf_life_unit,
	           @shelf_life_period	= sodtl_guar_shelf_life,
	    @packqty				= sodtl_pack_qty,
	           @pickqty				= sodtl_pick_qty,
	           @bhqty				= sodtl_bill_hold_qty,
	           /* code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00024 starts here*/
	           @spcodeml = sodtl_sales_person
	           --@salepurposeml	= sodtl_sale_purpose, --commented for DTS ID: DMS412AT_NSO_00030
	    -- @salepurposeml	= sodtl_sale_purpose --code uncommented for the bug id:-ES_NSO_00558--GSE-780
	           --@con_forml_hdn  = sodtl_consume_forecast, --DMS412AT_NSO_00034 --commented for DTS ID: DMS412AT_NSO_00030
	           --@stock_status	= sodtl_stock_status--commented for DTS ID: DMS412AT_NSO_00030
	           /* code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00024 ends here*/
	    FROM   so_order_item_dtl NOLOCK
	    WHERE  	sodtl_ou = @ctxt_ouinstance
	    AND 	sodtl_order_no = @order_no
	    AND 	sodtl_line_no = @line_no
	    
	    SELECT @line_status_tmp = @line_status
	END
	/* Code added for ITS Id : 14H109_NSO_00002 begins */
	ELSE if @modeflag IN ('I', 'X') and @feature_flag_yes_no	=	'YES'
    begin
		--Order Details are modified. Please use "Compute Price & Date" button to fetch the system price
		select @m_errorid = 3752510
		return
	end	
	/* Code added for ITS Id : 14H109_NSO_00002 ends */
	
	/* Code added by Damodhara. R on 10 Mar 2008 for DTS ID DMS412AT_NSO_00026 starts here */
	IF RTRIM(@ctxt_service) IN ('SOPP_AMMN_SER_AUTH', 'SOPP_AMMN_SER_AUTH1', 
	                           'SOPP_AMMN_SER_AUAM', 'SOPP_AMMN_SER_AUAM1')
	BEGIN
	    IF @sourcedocument = 'QUO'
	    BEGIN
	        SELECT	@quoted_qty_tmp = qdtl_quantityqtd
	        FROM	qtn_quotation_dtl_vw(NOLOCK)
	        WHERE  	qdtl_quotnumber		= @documentno
	        AND 	qdtl_ouinstance		= @documentouid
	        AND 	qdtl_lineno			= @refdoclineno
	        
	        IF RTRIM(@ctxt_service) IN ('SOPP_AMMN_SER_AUTH', 'SOPP_AMMN_SER_AUTH1')
	        BEGIN
	            SELECT @tot_ord_qty_tmp = SUM(sodtl_req_qty) + @qty
	            FROM   so_order_hdr(NOLOCK),
	                   so_order_item_dtl(NOLOCK)
	            WHERE  	sohdr_order_no		= sodtl_order_no
	            AND 	sohdr_ou			= sodtl_ou
	            AND 	sodtl_ou			= @ctxt_ouinstance
	            AND 	sohdr_ref_doc_ou	= @documentouid
	            AND 	sohdr_ref_doc_type	= @sourcedocument
	            AND 	sohdr_ref_doc_no	= @documentno
	            AND 	sodtl_ref_doc_line_no = @refdoclineno
	            AND 	sohdr_order_status	= 'AU'
	            
	            IF @tot_ord_qty_tmp > @quoted_qty_tmp
	            BEGIN
					select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
	                --raiserror('Total Ordered quantity exceeds Quoted quantity in line no. %d',16,1,@refdoclineno)
	                EXEC fin_german_raiserror_sp 'NSO',
	                     @ctxt_language,
	                     82,
	                     @refdoclineno
	                
	                RETURN
	            END
	        END
	        ELSE     
	 IF RTRIM(@ctxt_service) IN ('SOPP_AMMN_SER_AUAM', 'SOPP_AMMN_SER_AUAM1')
	        BEGIN
	            SELECT @tot_ord_qty_tmp = sodtl_req_qty
	            FROM   so_order_item_dtl(NOLOCK)
	            WHERE  	sodtl_ou			= @ctxt_ouinstance
	            AND 	sodtl_order_no		= @order_no
	            AND 	sodtl_line_no		= @line_no
	            
	            SELECT @tot_ord_qty_tmp = (@quoted_qty_tmp - @tot_ord_qty_tmp + @qty)
	            
	            IF @tot_ord_qty_tmp > @quoted_qty_tmp
	            BEGIN
					select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
	                --raiserror('Total Ordered quantity exceeds Quoted quantity in line no. %d',16,1,@refdoclineno)
	                EXEC fin_german_raiserror_sp 'NSO',
	                     @ctxt_language,
	                     82,
	                     @refdoclineno
	                
	                RETURN
	        END
	        END
	    END
	END
	/* Code added by Damodhara. R on 10 Mar 2008 for DTS ID DMS412AT_NSO_00026 ends here */
	
	/*Code modified by Indu for PPSCMQSOPPS41_000096  on 09/Oct/2006 Begins*/	
	SELECT @qty = ISNULL(@qty, 0)
	/*Code modified by Indu for PPSCMQSOPPS41_000096  on 09/Oct/2006 Ends*/
	--calling the common multi validation sp	
	/*code modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/		
	
	EXEC so_cmn_sp_ml_val
	     1,
	     @ctxt_language,
	     @ctxt_ouinstance,
	     @ctxt_service,
	     @ctxt_user,
	     @customercode,
	    @guid,
	     @line_no,
	     @order_no,
	     NULL,
	     @fprowno,
	     @orderdate,
	     @pricelistno,
	     @pricingdate,
	     @processingaction_hdn,
	     @promiseddate,
	     @qty,
	     @reqddate,
	     @sale_ord_type,
	     @schtype_hdn,
	     @shiptocustomercode,
	     @shippartial_hdn,
	     @shippingpointml_hdn,
	     @shiptoaddid,
	     NULL,
	     @stockstatus_hdn,	--'ACC',
	                      	--@trans_mode,		null,			@warehouse,		@youritemcode_ml,
	                      	--@trans_mode,		null,@fb_docml,			@warehouse,		@youritemcode_ml, --NSODMS412AT_000526
	     /*Code commented and added by Ananth P. against: ES_NSO_00129 Begins*/
	     --	@trans_mode,		@usagecccodeml,		@fb_docml,		@warehouse,		@youritemcode_ml, --NSODMS412AT_000526
	     @trans_mode,
	     @usagecccode,
	     @fb_doc,
	     @warehouse,
	     @youritemcode_ml,
	     /*Code commented and added by Ananth P. against: ES_NSO_00129 Ends*/
	     @zero_it_rate,
	     @currency,
	     @preffered_carrier,
	     @documentno,
	     @documentouid,
	     @sourcedocument,
	     @ref_doc_flag,
	     @refdoclineno,
	     @unitfrprice,
	     @priceuomml,
	     @gua_shelflife,
	     @shelf_life_unit_mul_hdn,
	     @item OUT,
	     @variantmL OUT,
	     @sale_uomcode OUT,
	     @unititmprice OUT,
	     @reserve_dtml OUT,
	     @to_shipdateml OUT,
	     @pricingdateml OUT,
	     @processingactionml OUT,
	     @promiseddateml OUT,
	     @reqddateml OUT,
	     @shiptocustomercode OUT,
	     @shippartial_hdn OUT,
	     @shippingpointml_hdn OUT,
	     --@shiptoidml out,	@spcodeml out,		@trans_mode out,	@usagecccodeml out,
	     @shiptoidml OUT,
	     @spcodeml OUT,
	     @trans_mode OUT,
	     @usagecccodeml OUT,
	     @fb_docml OUT,	--NSODMS412AT_000526
	     @warehousemulti OUT,
	     @incoplace OUT,
	     @lo OUT,
	     @cust_bu OUT,
	     @cust_ou OUT,
	     @item_ou OUT,
	     @wh_ou OUT,
	     @sp_ou OUT,
	     @lo_item OUT,
	     @bu_item OUT,
	     @item_type OUT,
	     @item_wt OUT,
	     @item_volume OUT,
	     @model_config_code OUT,
	     @model_config_var OUT,
	     @stock_qty OUT,
	     @price_flag OUT,
	     @pricelist_amend_no OUT,
	     @price_rule_no OUT,
	     @deliveryarea OUT,
	     --@line_status_tmp out,	@planningtype out,	@confactor out,		@con_forml_hdn out,
	     @line_status_tmp OUT,
	     @planningtype OUT,
	     @confactor OUT,
	     @con_forcast_hdn OUT,
	     /*Code modified by Indu for PPSCMQSOPPS41_000096  on 09/Oct/2006 Begins*/ 
	     --@m_errorid_tmp out
	     @m_errorid_tmp OUT,
	     @modeflag
	/*Code modified by Indu for PPSCMQSOPPS41_000096  on 09/Oct/2006 Ends*/
	/*code modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/ 
	
	/*Code added by Divyalekaa for DMS412AT_STKSTATUS_00003 starts here*/
	IF @m_errorid_tmp = 2400005
	BEGIN
		select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
	    EXEC fin_german_raiserror_sp 'NSO',
	         @ctxt_language,
	         120
	    
	    RETURN
	END 
	/*Code added by Divyalekaa for DMS412AT_STKSTATUS_00003 ends here*/
	
	IF @m_errorid_tmp <> 0
	BEGIN
	    SELECT @m_errorid = @m_errorid_tmp
	    RETURN
	END 
	
	/*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 starts here*/
	IF RTRIM(@ctxt_service) IN ('SOPP_AMMN_SER_AUTH', 'SOPP_AMMN_SER_AUTH1', 
	                           'SOPP_AMMN_SER_AUAM', 'SOPP_AMMN_SER_AUAM1')   AND 
	   @item_type = 'S'   AND (@fb_docml IS NULL OR @fb_docml = '')
	BEGIN
		select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
	    --raiserror('Finance book is mandatory for service item at row no. %d',16,1,@fprowno)
	    EXEC fin_german_raiserror_sp 'NSO',
	         @ctxt_language,
	      106,
	         @fprowno
	    
	    RETURN
	END
	/*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 ends here*/
	
	/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 + Begin*/
	IF @feature_flag_yes_no = 'YES'
	BEGIN
	   --CUMI Personalization : Price Override EDK : Modified by Robbins starts
	    DECLARE @price_override        udd_chkflag,
	            @disc_override         udd_chkflag,
	            @tc_override           udd_chkflag,
	            @sodtl_item_code       udd_itemcode,
	            @sodtl_item_variant    udd_variant,
	            @sodtl_cust_item_code  udd_itemcode,
	            @sodtl_req_qty         udd_quantity,
	            @sodtl_unit_price      udd_rate,
	            @sodtl_pricelist_no    udd_prilistcode,
	            @sodtl_price_uom       udd_uomcode,
	            @sodtl_req_date        udd_date,
	            @sodtl_prm_date        udd_date,
	            @sodtl_to_ship_date    udd_date,
	            @sodtl_ship_to_cust    udd_customer_id,
	            @sodtl_ship_to_id      udd_id,
	            @sodtl_ship_point      udd_ctxt_ouinstance,
	            @sodtl_ship_wh_no      udd_warehouse,
	            @hdr_change            udd_chkflag,
	            @price_engine_flag     udd_chkflag,
	            @tcd_engine_flag       udd_chkflag
	    
	    /*Code added by Mukesh B for the OTS no CUMI_PPSCMQSO_000116 12/12/2005 Begin*/
	    SELECT @hdr_change = 'N'
	    /*Code added by Mukesh B for the OTS no CUMI_PPSCMQSO_000116 12/12/2005 End*/
	    
	    /* Code commented by Damodharan. R for DTS ID DMS412AT_CUCPL_00001 starts here */
	    /*
	    select 	@price_override	= price_override,
	    @disc_override	= disc_override,
	    @tc_override	= tc_override
	    from user_so_price_tcd_mod (nolock)
	    where ouinstid 	= @ctxt_ouinstance
	    */
	    /* Code commented by Damodharan. R for DTS ID DMS412AT_CUCPL_00001 ends here */
	    /* Code modified for ITS Id : ES_NSO_00748 begins */
	    --SELECT @price_override = ISNULL(@price_override, 'N'),
	    --       @disc_override = ISNULL(@disc_override, 'N'),
	    --       @tc_override = ISNULL(@tc_override, 'N')
	    SELECT @price_override	=	ISNULL(@price_override, 'Y'),
	           @disc_override	=	ISNULL(@disc_override, 'Y'),
	           @tc_override		=	ISNULL(@tc_override, 'Y')
		/* Code modified for ITS Id : ES_NSO_00748 ends */
	           
		/* Code added by Prabhakaran for ITS Id : ES_NSO_00747 begins */
		if exists (	select	'x'
					from 	sotmp_order_item_dtl 	(nolock)
					where 	sodtl_guid			= 	@guid
					and 	sodtl_line_no		= 	@line_no
				  )
		begin				 
		/* Code added by Prabhakaran for ITS Id : ES_NSO_00747 ends */
				SELECT @sodtl_item_code			= sodtl_item_code,
					   @sodtl_item_variant		= sodtl_item_variant,
					   @sodtl_cust_item_code	= sodtl_cust_item_code,
					   @sodtl_req_qty			= sodtl_req_qty,
					   @sodtl_unit_price		= sodtl_unit_price,
					   @sodtl_pricelist_no		= sodtl_pricelist_no,
					   @sodtl_price_uom			= sodtl_price_uom,
					   @sodtl_req_date			= sodtl_req_date_dflt,
					   @sodtl_prm_date			= sodtl_prm_date_dflt,
					   @sodtl_to_ship_date		= sodtl_to_ship_date_dflt,
					   @sodtl_ship_to_cust		= sodtl_ship_to_cust_dflt,
					   @sodtl_ship_to_id		= sodtl_ship_to_id_dflt,
					   @sodtl_ship_point		= sodtl_ship_point_dflt,
					   @sodtl_ship_wh_no		= sodtl_ship_wh_no_dflt
				FROM   sotmp_order_item_dtl(NOLOCK)
				WHERE  	sodtl_guid = @guid
				AND 	sodtl_line_no = @line_no
	    /* Code added by Prabhakaran for ITS Id : ES_NSO_00747 begins */
	    end
	    else	--Code added for ITS Id : 14H109_NSO_00002
	    begin
				select 	@sodtl_item_code			= sodtl_item_code,
					   	@sodtl_item_variant		= sodtl_item_variant,
					   	@sodtl_cust_item_code	= sodtl_cust_item_code,
					   	@sodtl_req_qty			= sodtl_req_qty,
					   	@sodtl_unit_price		= sodtl_unit_price,
					   	@sodtl_pricelist_no		= sodtl_pricelist_no,
					   	@sodtl_price_uom		= sodtl_price_uom,
					   	@sodtl_req_date			= sodtl_req_date_dflt,
					   	@sodtl_prm_date			= sodtl_prm_date_dflt,
					   	@sodtl_to_ship_date		= sodtl_to_ship_date_dflt,
					   	@sodtl_ship_to_cust		= sodtl_ship_to_cust_dflt,
					   	@sodtl_ship_to_id		= sodtl_ship_to_id_dflt,
					   	@sodtl_ship_point		= sodtl_ship_point_dflt,
					   	@sodtl_ship_wh_no		= sodtl_ship_wh_no_dflt
				from	so_order_item_dtl(nolock)
				where  	sodtl_order_no			= @order_no
				and		sodtl_line_no			= @line_no
				and		sodtl_ou				= @ctxt_ouinstance
	    end
	    /* Code added by Prabhakaran for ITS Id : ES_NSO_00747 ends */
	    
	    SELECT @hdr_change = RTRIM(sohdr_addnl_fld1)
	    FROM   sotmp_order_hdr(NOLOCK)
	    WHERE  	sohdr_guid = @guid
	    
		/* Code added for ITS Id : ES_NSO_00748 begins */
		if 	isnull(@sodtl_unit_price,0) <> @unititmprice or isnull(@sodtl_req_qty,0) <> @qty or isnull(@sodtl_pricelist_no,'') <> isnull(@pricelistno,'') or	
			isnull(@sodtl_price_uom,'') <> isnull(@priceuomml,'') or isnull(@sodtl_ship_to_cust,'') <> isnull(@shiptocustomercode,'') or	
			isnull(@sodtl_ship_to_id,'') <> isnull(@shiptoidml,'') or isnull(@sodtl_ship_point,0) <> isnull(@shippingpointml_hdn,'') or	
			isnull(@sodtl_ship_wh_no,'') <> isnull(@warehousemulti,'') or @hdr_change = 'Y' 
		begin
			--Order Details are modified. Please use "Compute Price & Date" button to fetch the system price
			select @m_errorid = 3752510
			return
		end						
		/* Code added for ITS Id : ES_NSO_00748 ends */
	    
	    IF @unititmprice IS NULL   OR @unititmprice = 0.0
	    BEGIN
	        IF @price_override = 'N'
	        BEGIN
	            /* Starts - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
	            --raiserror('Price is not computed. Please use "Compute Price & Date" button to fetch the system price',16,1)
	            SELECT @m_errorid = 3752509
	            /* Ends - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
	            RETURN
	        END
	        ELSE     
	        IF @price_override = 'Y'
	        BEGIN
	            SELECT @price_engine_flag = 'Y',
	                   @tcd_engine_flag = 'Y'
	        END
	    END
	    ELSE     
	    IF @unititmprice IS NOT NULL
	    BEGIN
	        /*select	isnull(@sodtl_unit_price,0) , @unititmprice , isnull(@sodtl_req_qty,0) , @qty , isnull(@sodtl_pricelist_no,'') , isnull(@pricelistno,'')  
	        select	isnull(@sodtl_price_uom,'') , isnull(@priceuomml,'') , isnull(@sodtl_ship_to_cust,'') , isnull(@shiptocustomercode,'')  
	        select	isnull(@sodtl_ship_to_id,'') , isnull(@shiptoidml,'') , isnull(@sodtl_ship_point,0) , isnull(@shippingpointml_hdn,'')  
	        select	isnull(@sodtl_ship_wh_no,'') , isnull(@warehousemulti,'') , isnull(@sodtl_item_code,'') , @item  
	        select	isnull(@sodtl_item_variant,'') , isnull(@variantml,'') , isnull(@sodtl_cust_item_code,'') , isnull(@youritemcode_ml,'')  
	        select @hdr_change	*/
	        
	        IF ISNULL(@sodtl_unit_price, 0) <> @unititmprice   OR ISNULL(@sodtl_req_qty, 0) 
	           <> @qty   OR ISNULL(@sodtl_pricelist_no, '') <> ISNULL(@pricelistno, '')   OR 
	           ISNULL(@sodtl_price_uom, '') <> ISNULL(@priceuomml, '')   OR 
	           ISNULL(@sodtl_ship_to_cust, '') <> ISNULL(@shiptocustomercode, '')   OR 
	           ISNULL(@sodtl_ship_to_id, '') <> ISNULL(@shiptoidml, '')   OR 
	           ISNULL(@sodtl_ship_point, 0) <> ISNULL(@shippingpointml_hdn, '')   OR 
	   ISNULL(@sodtl_ship_wh_no, '') <> ISNULL(@warehousemulti, '')   OR 
	           ISNULL(@sodtl_item_code, '') <> @item   OR ISNULL(@sodtl_item_variant, '') 
	           <> ISNULL(@variantml, '')   OR ISNULL(@sodtl_cust_item_code, '') 
	           <> ISNULL(@youritemcode_ml, '')   OR --isnull(@sodtl_to_ship_date,'01/01/1900') <> @to_shipdateml 
	           @hdr_change = 'Y'
	        BEGIN
	            IF @price_override = 'N'
	      BEGIN
	                /* Starts - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
	                --raiserror('Order Details are modified. Please use "Compute Price & Date" button to fetch the system price',16,1)
	         SELECT @m_errorid = 3752510
	                /* Ends - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
	                RETURN
	            END
	            ELSE     
	            IF @price_override = 'Y'
	            BEGIN
	                IF (
	                       ISNULL(@sodtl_unit_price, 0) <> @unititmprice
	                       OR ISNULL(@sodtl_req_qty, 0) <> @qty
	                       OR ISNULL(@sodtl_pricelist_no, '') <> ISNULL(@pricelistno, '')
	                       OR ISNULL(@sodtl_price_uom, '') <> ISNULL(@priceuomml, '')
	                       OR ISNULL(@sodtl_ship_to_cust, '') <> ISNULL(@shiptocustomercode, '')
	                       OR ISNULL(@sodtl_ship_to_id, '') <> ISNULL(@shiptoidml, '')
	                       OR ISNULL(@sodtl_ship_point, 0) <> ISNULL(@shippingpointml_hdn, '')
	                       OR ISNULL(@sodtl_ship_wh_no, '') <> ISNULL(@warehousemulti, '')
	                       OR ISNULL(@sodtl_item_code, '') <> @item
	                       OR @hdr_change = 'Y'
	                   )   AND (
	                       ISNULL(@sodtl_item_code, '') <> @item
	                       OR ISNULL(@sodtl_item_variant, '') <> @variantml
	                   )
	                BEGIN
	                    SELECT @price_engine_flag = 'Y',
	                           @tcd_engine_flag = 'Y',
	                           @unititmprice = NULL,
	                           @pricelistno = NULL
	                END
	                ELSE    
	                BEGIN
	                    SELECT @price_engine_flag = 'N',
	                           @tcd_engine_flag = 'Y'
	                END
	            END
	        END
	        ELSE    
	        BEGIN
	            IF @price_override = 'N'
	            BEGIN
	                SELECT @price_engine_flag = 'N',
	                       @tcd_engine_flag = 'N'
	            END
	            ELSE     
	            IF @price_override = 'Y'
	            BEGIN
	            /* Code modified for ITS Id : 14H109_NSO_00002 begins */
	                --SELECT @price_engine_flag = 'N',
	                --       @tcd_engine_flag = 'N'
	                SELECT @price_engine_flag = 'Y',
	                       @tcd_engine_flag = 'Y'
				/* Code modified for ITS Id : 14H109_NSO_00002 ends */	                       
	            END
	        END
	    END
	    
	    DELETE 
	    FROM   sotmp_order_item_dtl
	    WHERE  sodtl_guid = @guid
	           AND sodtl_line_no = @line_no
	    
	    /* Code commented for ITS ID : ES_NSO_00748 Begins *//*
	    IF @tcd_engine_flag = 'Y'
	    BEGIN
	        /*delete from sotmp_item_tcd_dtl
	        where itmtcd_guid 	= @guid
	        and itmtcd_line_no	= @line_no*/
	        
	        DELETE 
	        FROM   so_item_tcd_dtl
	        WHERE  itmtcd_ou = @ctxt_ouinstance
	               AND itmtcd_order_no = @order_no
	               AND itmtcd_line_no = @line_no
	    END--CUMI Personalization : Price Override EDK : Modified by Robbins ends
	    *//* Code commented for ITS ID : ES_NSO_00748 Ends */
	END
	/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 + End*/
	IF @priceuomml IS NULL
	    SELECT @priceuomml = @sale_uomcode
	
	--Code for existing lines
	--code modified by Anitha N for PPSCMQSOPPS41_000109 on 12/10/2006 begins
	-- 	if	@line_no is not null
	IF @line_no IS NOT NULL   AND (@modeflag NOT IN ('I', 'X'))
	   --code modified by Anitha N for PPSCMQSOPPS41_000109 on 12/10/2006 ends
	BEGIN
	    SELECT @tcd_cal_flag = 'Y',
	           @update_flag = 'N',
	           @tcd_dflt_flag = 'N',
	           @prom_dflt_flag = 'Y'	--'N'--code modified for PEPS-20

		--code added for PEPS-20 begins
		if exists ( select 'X' from 
					so_order_item_dtl (nolock) 
					where 	sodtl_ou  			= 	@ctxt_ouinstance    
					and 	sodtl_order_no  	= 	@order_no 
					--and 	sodtl_line_no 		= @line_no	--code commented for PEPS-116 
					and 	sodtl_ref_doc_line_no 		= @line_no	--code added for PEPS-116
					and		sodtl_promotion_id	is not null
					)
		begin
			
			/*Code Added for PEPS-632 begin */
			delete	a
			from	so_po_pool_dtl	a
			join	so_order_item_dtl b(NOLOCK) 
			on		a.sopo_order_no		=	b.sodtl_order_no
			and		a.sopo_line_no		=	b.sodtl_line_no
			and		a.sopo_ou			=	b.sodtl_ou
			where	b.sodtl_order_no 			=	@order_no 
			and 	b.sodtl_ref_doc_line_no 	=	@line_no 
			and		b.sodtl_ou 					=	@ctxt_ouinstance 
			and 	b.sodtl_free_item_flag		=	'Y' 

			delete	a
			from	so_model_kit_sch_dtl	a
			join	so_order_item_dtl b(NOLOCK) 
			on		a.mdlsch_order_no	=	b.sodtl_order_no
			and		a.mdlsch_line_no	=	b.sodtl_line_no
			and		a.mdlsch_ou			=	b.sodtl_ou
			where	b.sodtl_order_no 			=	@order_no 
			and 	b.sodtl_ref_doc_line_no 	=	@line_no 
			and		b.sodtl_ou 					=	@ctxt_ouinstance 
			and 	b.sodtl_free_item_flag		=	'Y' 
			
			delete	a
			from	so_customer_item_dtl	a
			join	so_order_item_dtl b(NOLOCK) 
			on		a.cusitm_order_no	=	b.sodtl_order_no
			and		a.cusitm_line_no	=	b.sodtl_line_no
			and		a.cusitm_ou			=	b.sodtl_ou
			where	b.sodtl_order_no 			=	@order_no 
			and 	b.sodtl_ref_doc_line_no 	=	@line_no 
			and		b.sodtl_ou 					=	@ctxt_ouinstance 
			and 	b.sodtl_free_item_flag		=	'Y' 

			delete	a
			from	so_export_order_dtl	a
			join	so_order_item_dtl b(nolock) 
			on		a.soexd_order_no	=	b.sodtl_order_no
			and		a.soexd_line_no	=	b.sodtl_line_no
			and		a.soexd_ou			=	b.sodtl_ou
			where	b.sodtl_order_no 			=	@order_no 
			and 	b.sodtl_ref_doc_line_no 	=	@line_no 
			and		b.sodtl_ou 					=	@ctxt_ouinstance 
			and 	b.sodtl_free_item_flag		=	'Y' 
			
			delete	a
			from	so_item_attribute_dtl	a
			join	so_order_item_dtl b(nolock) 
			on		a.soatt_order_no	=	b.sodtl_order_no
			and		a.soatt_line_no	=	b.sodtl_line_no
			and		a.soatt_ou			=	b.sodtl_ou
			where	b.sodtl_order_no 			=	@order_no 
			and 	b.sodtl_ref_doc_line_no 	=	@line_no 
			and		b.sodtl_ou 					=	@ctxt_ouinstance 
			and 	b.sodtl_free_item_flag		=	'Y' 
			
			delete	a
			from	so_item_tcd_dtl	a
			join	so_order_item_dtl b(nolock) 
			on		a.itmtcd_order_no	=	b.sodtl_order_no
			and		a.itmtcd_line_no	=	b.sodtl_line_no
			and		a.itmtcd_ou			=	b.sodtl_ou
			where	b.sodtl_order_no 			=	@order_no 
			and 	b.sodtl_ref_doc_line_no 	=	@line_no 
			and		b.sodtl_ou 					=	@ctxt_ouinstance 
			and 	b.sodtl_free_item_flag		=	'Y' 
			
			delete	a
			from	so_model_kit_item_dtl	a
			join	so_order_item_dtl b(nolock) 
			on		a.mdlitm_order_no	=	b.sodtl_order_no
			and		a.mdlitm_line_no	=	b.sodtl_line_no
			and		a.mdlitm_ou			=	b.sodtl_ou
			where	b.sodtl_order_no 			=	@order_no 
			and 	b.sodtl_ref_doc_line_no 	=	@line_no 
			and		b.sodtl_ou 					=	@ctxt_ouinstance 
			and 	b.sodtl_free_item_flag		=	'Y' 

			delete	a
			from	so_order_commission_dtl	a
			join	so_order_item_dtl b(nolock) 
			on		a.sosp_order_no	=	b.sodtl_order_no
			and		a.sosp_line_no	=	b.sodtl_line_no
			and		a.sosp_ou		=	b.sodtl_ou
			where	b.sodtl_order_no 			=	@order_no 
			and 	b.sodtl_ref_doc_line_no 	=	@line_no 
			and		b.sodtl_ou 					=	@ctxt_ouinstance 
			and 	b.sodtl_free_item_flag		=	'Y' 

			/*Code Added for PEPS-632 end */

			;
			WITH SQLTMP (sodtl_line_no1) as 
			(
				SELECT DISTINCT SQL2K51.sodtl_line_no
				FROM 	so_order_item_dtl SQL2K51 (NOLOCK) 
				WHERE 	SQL2K51.sodtl_ou 				= @ctxt_ouinstance 
				and 	SQL2K51.sodtl_order_no 			= @order_no 
				and 	SQL2K51.sodtl_ref_doc_line_no 	= @line_no 
				and 	SQL2K51.sodtl_free_item_flag 	= 'Y' 
			)

			DELETE 	so_order_sch_dtl
			FROM 	so_order_sch_dtl 
					JOIN 
					SQLTMP 
					ON ( sosch_line_no = SQLTMP.sodtl_line_no1 )
			WHERE  	sosch_ou 				= @ctxt_ouinstance 
			and 	sosch_order_no 			= @order_no 
			and 	sosch_free_item_flag 	= 'Y'

			delete	from 	so_order_item_dtl		           
			where 	sodtl_ou  				= 	@ctxt_ouinstance            
			and 	sodtl_order_no  		= 	@order_no             
			and 	sodtl_free_item_flag	= 	'Y' 
			and		sodtl_ref_doc_line_no	=  @line_no
		end
		--code added for PEPS-20 ends

	    --Calling the amend validation procedure
	    --code modified by Anitha N for PPSCMQSOPPS41_000109 on 12/10/2006 begins
	    IF EXISTS(
	           SELECT 'x'
	           FROM   so_order_item_dtl(NOLOCK)
	           WHERE  	sodtl_ou = @ctxt_ouinstance
	           AND 	sodtl_order_no = @order_no
	           AND 	sodtl_line_no = @line_no
	       )
	    BEGIN
	    	/*Code added for 9H123-1_NSO_00022 begins*/

	    	IF	@processingactionml = 'DROP' AND (@modeflag NOT IN ('S','Z'))
	    	BEGIN

				IF EXISTS (
							SELECT	'*'
							FROM	cobi_invoice_hdr a(nolock),
									cobi_item_dtl b(nolock)
							WHERE	a.tran_no		=	b.tran_no
							and		a.tran_ou		=	b.tran_ou
							and		a.tran_type		=	b.tran_type
							and		b.so_no			=	@order_no
							AND		so_ou			=	@ctxt_ouinstance
							and		tran_status		not in	('RVD','DEL')
							and		b.so_line_no	=	@line_no	
							and		b.ref_doc_type	=	'DR'
							)
				BEGIN
					select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
					--Row no <>, cannot be amended as Drop ship Receipt happened.
					EXEC fin_german_raiserror_sp 'NSO',
						 @ctxt_language,
						 1200,
						 @line_no
					RETURN
				END
					    		
	    	END				
			/*Code added for 9H123-1_NSO_00022 ends*/

	        --code modified by Anitha N for PPSCMQSOPPS41_000109 on 12/10/2006 ends
	        EXEC so_cmn_sp_am_ml_val 
	             @ctxt_language,
	             @ctxt_ouinstance,
	             @ctxt_service,
	             @ctxt_user,
	             @customercode,
	             @line_no,
	             @order_no,
	             @item,
	             @variantml,
	             @item_type,
	             @qty,
	             @unititmprice,
	             @pricelistno,
	             @to_shipdateml,
	             @reserve_dtml,
	             @promiseddateml,
	             @shippingpointml_hdn,
	             @trans_mode,
	             @schtype_hdn,
	             @warehousemulti,
	             @processingactionml,
	             /*code modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/ 
	             --@shiptocustomercode,	@shiptoidml,		@stock_status,			@sale_uomcode, --DMS412AT_NSO_00034
	             @shiptocustomercode,
	             @shiptoidml,
	             @stockstatus_hdn,
	             @sale_uomcode,	--DMS412AT_NSO_00034
	                           	--@shippartial_hdn,	@con_forml_hdn,		@m_errorid_tmp out --DMS412AT_NSO_00034
	             @shippartial_hdn,
	             @con_forcast_hdn,
	             @m_errorid_tmp OUT
	        /*code modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/	
	        
	        IF @m_errorid_tmp <> 0
	        BEGIN
	            SELECT @m_errorid = @m_errorid_tmp
	            RETURN
	        END 
	       
	        IF ((@packqty + @pickqty + @bhqty) > 0)
	        BEGIN
	            IF (@shelf_life_unit <> @shelf_life_unit_mul_hdn)
	            BEGIN
	                /* Starts - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
	                --raiserror('Item has already been Picked/Packed.Hence Shelf Life Unit cannot be amended',16,1)
	          SELECT @m_errorid = 3752511
	                /* Ends - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
	                RETURN
	            END
	            
	            IF (@shelf_life_period <> @gua_shelflife)
	            BEGIN
	                /* Starts - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
	                --raiserror('Item has already been Picked/Packed.Hence Shelf Life Period cannot be amended',16,1)
	                SELECT @m_errorid = 3752512
	                /* Ends - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
	                RETURN
	            END
	        END
	        -- Check for Price Engine Runs
	        -- If User Selected a row and Pressed submit deleting the default information and Defaulting the Price , Tax , Promotions 
	        /*Code merged by Indu for CUMI_PPSCMQSO_000112 on 12/Dec/2005 Begin*/
	        IF @feature_flag_yes_no = 'NO'
	        BEGIN
	            /*Code merged by Indu for CUMI_PPSCMQSO_000112 on 12/Dec/2005 End*/
	            --code modified by Suganya S for PPSCMQSOPPS41_000107 on 12/10/2006 begins
	            -- 			if 	@modeflag in ('X', 'Y', 'Z')  --NSODMS412AT_000533
	            --			if 	@modeflag in ('X', 'Y','Z')
	            --code modified by Suganya S for PPSCMQSOPPS41_000107 on 12/10/2006 ends
	            --			begin --NSODMS412AT_000533
	            --Code modified by Suganya S for PPSCMQSOPPS41_000097 on 24/10/2006 begins
	            -- 				select	@tcd_dflt_flag	= 'Y',
	            -- 	-- 				@prom_dflt_flag = 'Y',
	            -- 					@price_flag	= 'Y',
	            -- 					@unititmprice	= 0.00
	            --Code modified by Suganya S for PPSCMQSOPPS41_000097 on 24/10/2006 ends
	            --deleting the so price param detail table
	            DELETE so_price_param_dtl
	            WHERE  sopr_ou = @ctxt_ouinstance
	                   AND sopr_orderno = @order_no
	                   AND sopr_lineno = @line_no
	            
	            /*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 + Begin*/
	            IF @feature_flag_yes_no = 'YES'
	                SELECT @feature_flag_yes_no = @feature_flag_yes_no
	                       --Commented by Robbins
	                       /*--deleting the values from item tcd table
	                       delete	so_item_tcd_dtl
	                       where	itmtcd_ou	=	@ctxt_ouinstance
	                       and	itmtcd_order_no	=	@order_no
	                       and	itmtcd_line_no	=	@line_no
	                       and	itmtcd_deal_id is null*/
	            ELSE    
	            BEGIN
	                /*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 + End*/
	                --deleting the values from item tcd table
    	                IF EXISTS(
	                       SELECT 'x'
	                       FROM   so_order_item_dtl(NOLOCK)
	                       WHERE  	sodtl_ou = @ctxt_ouinstance
	                 AND 	sodtl_order_no = @order_no
	    AND 	sodtl_line_no = @line_no
	                       AND 	(
	    	    ISNULL(sodtl_tc_upd_flag, 'N') = 'N'
	                           	    OR ISNULL(sodtl_disc_upd_flag, 'N') = 'N'
	                           	)
	                   )
	                BEGIN
	                    DELETE so_item_tcd_dtl
	                    WHERE  itmtcd_ou = @ctxt_ouinstance
	                    AND itmtcd_order_no = @order_no
	                           AND itmtcd_line_no = @line_no
	        --AND itmtcd_deal_id IS NULL --code commented for JPE-1857
	                END
	            END
	        END
	        /* Code added for ITS ID : ES_NSO_00748 Begins */--Sejal
	        IF @feature_flag_yes_no = 'YES'
	        begin
	          	delete	so_item_tcd_dtl	
				where	itmtcd_ou 				= 		@ctxt_ouinstance
				and 	itmtcd_order_no			= 		@order_no
				and		itmtcd_line_no			= 		@line_no
				--and		itmtcd_deal_id			is null --code commented for JPE-1857
				and		isnull(itmtcd_orgsrc,'')=		'NSO'
			end
	        /* Code added for ITS ID : ES_NSO_00748 Ends */--Sejal			
	        /*Code merged by Indu for CUMI_PPSCMQSO_000112 on 12/Dec/2005 Begin*/
	        --		end --NSODMS412AT_000533
	        /*Code merged by Indu for CUMI_PPSCMQSO_000112 on 12/Dec/2005 End*/
	        
	        -- If line details changed , changing the line status to amended
	        /*code modified for DTS ID: ES_NSO_00206 starts here*/
	        --if	@order_status = 'AU'
	        IF @order_status IN ('AU', 'AM')
	        BEGIN
	            /*code modified for DTS ID: ES_NSO_00206 ends here*/		 
	            IF EXISTS(
	                   SELECT 'X'
	                   FROM   so_order_item_dtl
	                   WHERE  	sodtl_ou = @ctxt_ouinstance
	                   AND 	sodtl_order_no = @order_no
	                   AND 	sodtl_line_no = @line_no
	                   AND 	((ISNULL(sodtl_cust_item_code, '') <> ISNULL(@youritemcode_ml, ''))
	    	    OR (ISNULL(sodtl_item_code, '') <> ISNULL(@item, ''))
	                       	    OR (ISNULL(sodtl_item_variant, '') <> CASE @item_type WHEN 'M' THEN '##' ELSE @variantml END)
	                       	    OR (ISNULL(sodtl_uom, '') <> ISNULL(@sale_uomcode, ''))
	                       	    OR (sodtl_req_qty <> @qty)
	                       	    OR (ISNULL(sodtl_pricelist_no, '') <> ISNULL(@pricelistno, ''))
	                       	    OR (sodtl_sales_price <> @unititmprice)
	                       	    OR (ISNULL(sodtl_req_date_dflt, '01/01/1900')  <> ISNULL(@reqddateml, '01/01/1900'))
	                       	    OR (ISNULL(sodtl_prm_date_dflt, '01/01/1900')<> ISNULL(@promiseddateml, '01/01/1900'))
	                       	    OR (ISNULL(sodtl_proc_action_dflt, '') <> ISNULL(@processingactionml, ''))
	                       	    OR (ISNULL(sodtl_sch_type, '') <> ISNULL(@schtype_hdn, ''))
	                       	    OR (ISNULL(sodtl_ship_to_cust_dflt, '') <> ISNULL(@shiptocustomercode, ''))
	                       	    OR (ISNULL(sodtl_ship_to_id_dflt, '') <> ISNULL(@shiptoidml, ''))
	                       	    OR (ISNULL(sodtl_ship_point_dflt, -915) <> ISNULL(@shippingpointml_hdn, -915))
	                       	    OR (ISNULL(sodtl_ship_wh_no_dflt, '') <> ISNULL(@warehousemulti, ''))
	                       	    OR (ISNULL(sodtl_to_ship_date_dflt, '01/01/1900') <> ISNULL(@to_shipdateml, '01/01/1900'))
	                       	    OR (ISNULL(sodtl_sch_date_dflt, '01/01/1900') <> ISNULL(@reserve_dtml, '01/01/1900'))
	                       	    OR (ISNULL(sodtl_pricing_date, '01/01/1900')  <> ISNULL(@pricingdateml, '01/01/1900')))
	               )
	            BEGIN
	                SELECT @line_status = 'AM'
	            END
	        END
	        --calling the procedure for inserting the multi line values into temporary tabel
	        EXEC so_crmn_sp_tmp_ins_item @ctxt_ouinstance,
	             @ctxt_language,
	     @ctxt_service,
	             @ctxt_user,
	           @con_forcast_hdn,	--'N',--Modified for DTS ID_DMS412AT_NSO_00030
	             @guid,
	             @incoplace,
	             @item,
	             @item_type,
	             @model_config_code,
	             @model_config_var,
	             @item_wt,
	             @item_volume,
	             @item_var_desc,
	             @line_no,
	             @line_status,
	             @modeflag,
	             @order_no,
	           @price_flag,
	  @tcd_cal_flag,
	          @update_flag,
	             @tcd_dflt_flag,
	             @prom_dflt_flag,
	             @price_rule_no,
	             @pricelistno,
	             @pricelist_amend_no,
	             @pricingdateml,
	             @processingactionml,
	             @stockstatus_hdn,	--'ACC',--Modified for DTS ID_DMS412AT_NSO_00030
	             @sp_ou,
	             @spcodeml,
	             @promiseddateml,
	      @promotype,
	             @qty,
	             @stock_qty,
	             @unititmprice,
	             @refdoclineno,
	           @referencescheduleno,
	             @reqddateml,
	             @reserve_dtml,
	             @salepurposeml,
	             @schtype_hdn,
	             @shiptocustomercode,
	             @shippartial_hdn,
	        @shippingpointml_hdn,
	             @shiptoidml,
	             @sale_uomcode,
	             @to_shipdateml,
	             @extprice,
	             --Damodharan modified for OTS ID NSODMS412AT_000526 begins
	             --@trans_mode,@usagecccodeml,@variantml,@warehousemulti,@youritemcode_ml,@unitfrprice,
	             @trans_mode,
	             @usagecccodeml,
	             @fb_docml,
	             @variantml,
	             @warehousemulti,
	             @youritemcode_ml,
	             @unitfrprice,
	             --Damodharan modified for OTS ID NSODMS412AT_000526 ends
	             @unitprice_ml,
	             @shelf_life_unit_mul_hdn,
	  @gua_shelflife,
	             @priceuomml,
				 @remarks_amnso,--code added by EBS-971
				 null, -- EBS-1362
				 @customeritemdesc ,-- code added for EPE-27452
	             @m_errorid_tmp OUTPUT
	        
	        IF @m_errorid_tmp <> 0
	        BEGIN
	            SELECT @m_errorid = @m_errorid_tmp
	            RETURN
	        END
	        
	        IF @schtype_hdn = 'SG'	--'ST'--code modified for RFBE-14
	        BEGIN
	            SELECT	@sch_qty = SUM(ISNULL(sosch_sch_qty, 0))
	            FROM	so_order_sch_dtl(NOLOCK)
	            WHERE  	sosch_ou = @ctxt_ouinstance
	            AND 	sosch_order_no = @order_no
	            AND 	sosch_line_no = @line_no
	            
	            IF (@qty <> @sch_qty)
					and	rtrim(@ctxt_service) in ('sopp_ammn_ser_auam1','sopp_ammn_ser_auth1')--code added for RFBE-14
	            BEGIN
	                /* Starts - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
	                --raiserror('Quantity cannot be changed since there are staggered schedules for this line.',16,1)
	                --SELECT @m_errorid = 3752513 --code commented for RFBE-14
					--raiserror('Cannot authorise SO due to quantity mismatch for line no."%d" between Main page & Sch page',16,1,@fprowno)--code added for RFBE-14           
					EXEC fin_german_raiserror_sp 'NSO',@ctxt_language,11260507,@fprowno--code added for RFBE-14 
	                /* Ends - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
	                RETURN
	            END
	        END
	
		/*												--code commented by Nandhakumar B on 17 Dec 2024 for PJRMC-799 begins
	     /*code added for MAT-685 starts here */
       if @orderdate> @to_shipdateml
		   begin
		        EXEC fin_german_raiserror_sp 'NSO',@ctxt_language,1270,@fprowno
			    return
		    end     
	   /*code added for MAT-685 ends here */
	   */												--code commented by Nandhakumar B on 17 Dec 2024 for PJRMC-799
	        
	        IF @schtype_hdn = 'SI'
	        BEGIN
	            IF EXISTS(
	                   SELECT 'X'
	                   FROM		so_order_sch_dtl(NOLOCK)
	                   WHERE  	sosch_ou		= @ctxt_ouinstance
	                   AND 		sosch_order_no	= @order_no
	                   AND 		sosch_line_no	= @line_no
	       )
	            BEGIN
	                SELECT	@promotionid = sodtl_promotion_id
	                FROM	sotmp_order_item_dtl
	                WHERE  	sodtl_guid		= @guid
	                AND 	sodtl_line_no	= @line_no					
	                
	                SELECT @reasoncode = NULL
	                
	                /*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 starts here*/
	                IF @item_type = 'S'
	                BEGIN
	                    --calling the procedure to fetch the account details
	                    EXEC so_service_getacctcode_sp
	                         @ctxt_language,
	                         @ctxt_ouinstance,
	                         @ctxt_service,
	                         @ctxt_user,
	                         'NSO',
	         @guid,
	                         @item,
	                      @variantml,
	                         @sale_ord_type,
	                         @sale_type,
	                         @sales_chan,
	                         @deliveryarea,
	                         @cust_ou,
	                         @customercode,
	 @salepurposeml,--NULL, --code commented for the bug id:-ES_NSO_00558
	                         @shippingpointml_hdn,
	                         @shiptoidml,
	                         @promotionid,
	                         @receipttype,
	                         @processingactionml,
	                         @reasoncode,
	                         @fb_docml,
	                         @usagecccodeml,
	                         @number_series,
	                         @folder,
	                         @sale_account OUT,
	                         @analysiscode_out OUT,
	                         @subanalysiscode_out OUT,
	                         @cost_center OUT,
	                         @m_errorid_tmp OUT
	                    
	                    IF @m_errorid_tmp <> 0
	                    BEGIN
	                        SELECT @m_errorid = @m_errorid_tmp
	                        RETURN
	                    END	
	                    
	                    SELECT	@analysiscode_tmp		= sosch_analysis_code,
								@subanalysiscode_tmp	= sosch_sub_analysis_code,
								@fb_doc_tmp				= RTRIM(sosch_fbdoc)
	                    FROM	so_order_sch_dtl(NOLOCK)
	                    WHERE  	sosch_ou				= @ctxt_ouinstance
	                    AND 	sosch_order_no			= @order_no
	                    AND 	sosch_line_no			= @line_no 
	                    
	                IF @fb_doc_tmp = @fb_docml
	                    BEGIN
	                        IF @analysiscode_out IS NULL   OR @analysiscode_out 
	                           = ''
	                            SELECT @analysiscode_out = @analysiscode_tmp
	                        
	                        IF @subanalysiscode_out IS NULL   OR @subanalysiscode_out 
	                           = ''
	                            SELECT @subanalysiscode_out = @subanalysiscode_tmp
	                    END
	                END
	                ELSE    
	                BEGIN
	                    /*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 ends here*/
	                    --calling the procedure to fetch the account details
	                    EXEC so_cmn_getacctcode_sp
	                         @ctxt_language,
	                         @ctxt_ouinstance,
	                         @ctxt_service,
	                         @ctxt_user,
	                         'NSO',
	                         @guid,
	                         @item,
	                         @variantml,
	                         @sale_ord_type,
	       @sale_type,
	                         @sales_chan,
	                         @deliveryarea,
	                         @cust_ou,
	                         @customercode,
	  @salepurposeml,--NULL,/*Modified for DTS ID:ES_NSO_00392*/
	               @shippingpointml_hdn,
	                         @shiptoidml,
	                         @promotionid,
	                         @receipttype,
	                         @processingactionml,
	                         @reasoncode,
	                         @warehousemulti,
	                         @usagecccodeml,
	                         @number_series,
	           @folder,
	                         @sale_account OUT,
	                         @analysiscode_out OUT,
	                         @subanalysiscode_out OUT,
	                         @cost_center OUT,
	                         @m_errorid_tmp OUT
	                         /*Code added for ES_cobi_00047 begins here*/,
	 @fb_docml
	                    /*Code added for ES_cobi_00047 ends here*/
	                    
	         IF @m_errorid_tmp <> 0
	                    BEGIN
	                        SELECT @m_errorid = @m_errorid_tmp
	                        RETURN
	                    END/*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 starts here*/
	    END 
	                /*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 ends here*/
	                --code for single schedule
	                --updating the schedule table
	
	
	                
	                /* Code added by Balaji Prasad P.R for the defect id : ES_PACKSLIP_00049 begins */
	                IF (
	                       (@item_ou IS NULL)
	                       OR (@item_type IS NULL)
	                       OR (@item IS NULL)
	                       OR (@item_type IS NULL)
	                       OR (@variantml IS NULL)
	                       OR (@sale_uomcode IS NULL)
	                       OR (@qty IS NULL)
	                       OR (@stock_qty IS NULL)
	                       OR (@shippingpointml_hdn IS NULL)
	                       OR (@planningtype IS NULL)
	                       OR (@shiptocustomercode IS NULL)
	                       OR (@shiptoidml IS NULL)
	                       OR (@reserve_dtml IS NULL)
	                       OR (@reqddateml IS NULL)
	                       OR (@promiseddateml IS NULL)
	                       OR (@to_shipdateml IS NULL)
	                       OR (@processingactionml IS NULL)
	                   )
	                    RETURN
	                /* Code added by Balaji Prasad P.R for the defect id : ES_PACKSLIP_00049 ends */
	                
	         UPDATE so_order_sch_dtl
	                SET    sosch_item_ou			= @item_ou,
	                       sosch_item_type			= @item_type,
	                       sosch_item_code			= @item,
	                       sosch_item_variant		= CASE @item_type
	                                                 WHEN 'M' THEN '##'
	                                                 ELSE @variantml
	                                            END,
	                       sosch_uom				= @sale_uomcode,
	                       sosch_sch_qty			= @qty,
	                       sosch_shipping_pt		= @shippingpointml_hdn,
	                       /*Code added by Mohamed Sheik S.N. for OTS No PPSCMQSOPPS41_000030 on 22/Aug/2005 + Begin*/
	                       --sosch_wh_ou		=	@wh_ou,
	                       --sosch_wh_no		=	@warehousemulti,
	                       sosch_wh_ou = @wh_ou,	--NSODMS412AT_000533
	                       sosch_wh_no = ISNULL(@warehousemulti, '##'),
	                       /*Code added by Mohamed Sheik S.N. for OTS No PPSCMQSOPPS41_000030 on 22/Aug/2005 + End*/
	                       sosch_ship_to_cust		= @shiptocustomercode,
	                       sosch_ship_to_id			= @shiptoidml,
	                       /*Code added by Damodharan. R on 12 Feb 2009 for Defect ID ES_NSO_00168 starts here*/
	                       sosch_delivery_area		= @deliveryarea,
	                       /*Code added by Damodharan. R on 12 Feb 2009 for Defect ID ES_NSO_00168 ends here*/
	    sosch_sch_date			= @reserve_dtml,
	                       sosch_req_date			= @reqddateml,
	                       sosch_prm_date			= @promiseddateml,
	                       sosch_to_ship_date		= @to_shipdateml,
	                       sosch_rem_qty			= CASE WHEN @qty -(ISNULL(sosch_pick_qty, 0) + ISNULL(sosch_direct_pack_qty, 0)
	                                        + ISNULL(sosch_bill_hold_qty, 0)) < 0 THEN 0
														ELSE @qty -(ISNULL(sosch_pick_qty, 0) + ISNULL(sosch_direct_pack_qty, 0)
	                                                     + ISNULL(sosch_bill_hold_qty, 0)) END,
	                       sosch_stock_uom_qty		= @stock_qty,
	                       sosch_proc_action		= @processingactionml,
	                       sosch_trans_mode			= @trans_mode,
	                  sosch_planning_type		= @planningtype,
	                       sosch_acc_code			= @sale_account,
	                       sosch_cost_center		= @cost_center,
	                       sosch_analysis_code		= @analysiscode_out,
	                       sosch_sub_analysis_code	= @subanalysiscode_out,
	                       sosch_sch_status			= @line_status,
	      sosch_modified_by		= @ctxt_user,
	                       sosch_modified_date		= dbo.RES_Getdate(@ctxt_ouinstance),
	                       sosch_timestamp			= sosch_timestamp + 1
	                WHERE	sosch_ou		= @ctxt_ouinstance
					AND		sosch_order_no	= @order_no
					AND		sosch_line_no	= @line_no
	            END
	        END--code modified by Anitha N for PPSCMQSOPPS41_000109 on 12/10/2006 begins
	    END-- if line exists
	    ELSE    
	    BEGIN
	        SELECT @schtype_hdn = 'SI'
	        --computing the line no
	        SELECT	@line_no = MAX(ISNULL(sodtl_line_no, 0)) + 1
	        FROM	sotmp_order_item_dtl
	        WHERE  	sodtl_guid = @guid
	        --and	sodtl_order_no	=	@order_no	
	        
	        SELECT	@line_no_tmp = MAX(ISNULL(sodtl_line_no, 0)) + 1
	        FROM	so_order_item_dtl
	        WHERE  	sodtl_ou = @ctxt_ouinstance
	        AND 	sodtl_order_no = @order_no
	        AND 	sodtl_free_item_flag = 'N'

	
	        
	        IF @line_no_tmp > @line_no
	            SELECT @line_no = @line_no_tmp	
	        
	        IF (@schtype_hdn = 'SI')
	        BEGIN
	            SELECT @line_status = 'FR'
	        END
	        ELSE    -- For Staggered Lines, Default Status to DR
	        BEGIN
	    SELECT @line_status = 'DR'
	        END
	        --calling the procedure to insert the new rows
	        EXEC so_cmn_sp_line_insert
	             /*code modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/ 
	             --1,			'N',			@ctxt_language,		@ctxt_ouinstance,
	             1,
	             @con_forcast_hdn,
	             @ctxt_language,
	             @ctxt_ouinstance,
	             /*code modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/ 
	             @ctxt_service,
	             @ctxt_user,
	             @customercode,
	             @cust_ou,
	             @cust_bu,
	             @guid,
	             @documentno,
	             @incoplace,
	             @item,
	             @item_var_desc,
	             @item_type,
	             @item_ou,
	             @item_wt,
	             @item_volume,
	             @line_no,
	             @lo,
	             @bu_item,
	             @line_status,
	             @price_flag,
	             @price_rule_no,
	             @pricelist_amend_no,
	             @planningtype,
	             @wh_ou,
	             @sp_ou,
	             @deliveryarea,
	             @stock_qty,
	             @model_config_code,
	             @model_config_var,
	             @modeflag,
	             @order_no,
	          @pricelistno,
	             @pricingdateml,
	             @processingactionml,
	             @promiseddateml,
	             @promotype,
	             @qty,
	    @unititmprice,
	             @refdoclineno,
	             @referencescheduleno,
	             @reqddateml,
	             @reserve_dtml,
	             @salepurposeml,
	             @schtype_hdn,
	             @shiptocustomercode,
	             @shippartial_hdn,
	             @shippingpointml_hdn,
	             @shiptoidml,
	             @sale_uomcode,
	             /*code modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/ 
	             --@sourcedocument,	@spcodeml,		'ACC',			@to_shipdateml,
	             @sourcedocument,
	             @spcodeml,
	             @stockstatus_hdn,
	             @to_shipdateml,
	             /*code modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/ 
	             --Damodharan modified for OTS ID NSODMS412AT_000526 begins
	             --@extprice,		@trans_mode,		@usagecccodeml,		@variantml,
	             @extprice,
	             @trans_mode,
	             @usagecccodeml,
	             @fb_docml,
	             @variantml,
	             --Damodharan modified for OTS ID NSODMS412AT_000526 ends
	             @warehousemulti,
	             @youritemcode_ml,
	             @unitfrprice,
	    @unitprice_ml,
	             @shelf_life_unit_mul_hdn,
	             @gua_shelflife,
	             @priceuomml,
				 @remarks_amnso,--code added by EBS-971
				 null, -- EBS-1362
	             @m_errorid_tmp OUT,
				 null,
				 null,
				  @customeritemdesc --code added for EPE-27452
	        
	        IF @m_errorid_tmp <> 0
	        BEGIN
	            SELECT @m_errorid = @m_errorid_tmp
	            RETURN
	        END
	    END -- new line
	END--if line is not null
	ELSE     --Line no is null
	         -- 	if((@line_no is not null
	IF (
	       (@line_no IS NOT NULL AND @modeflag IN ('I', 'X'))
	       OR @line_no IS NULL
	   )
	   --code modified by Anitha N for PPSCMQSOPPS41_000109 on 12/10/2006 ends
	BEGIN
	    SELECT	@schtype_hdn = 'SI'
	    --computing the line no
	    SELECT	@line_no = MAX(ISNULL(sodtl_line_no, 0)) + 1
	    FROM	sotmp_order_item_dtl
	    WHERE  	sodtl_guid = @guid
	    --and	sodtl_order_no	=	@order_no	
	    
	    SELECT	@line_no_tmp = MAX(ISNULL(sodtl_line_no, 0)) + 1
	    FROM	so_order_item_dtl
	    WHERE  	sodtl_ou = @ctxt_ouinstance
	    AND 	sodtl_order_no = @order_no
	    AND 	sodtl_free_item_flag = 'N'
	 
	
	    
	    IF @line_no_tmp > @line_no
	        SELECT @line_no = @line_no_tmp	
	    
	    IF (@schtype_hdn = 'SI')
	    BEGIN
	        SELECT @line_status = 'FR'
	    END
	    ELSE    -- For Staggered Lines, Default Status to DR
	    BEGIN
	        SELECT @line_status = 'DR'
	    END

	    --calling the procedure to insert the new rows
	    EXEC so_cmn_sp_line_insert
	         /*code modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/ 
	         --1,			'N',			@ctxt_language,		@ctxt_ouinstance,
	         1,
	         @con_forcast_hdn,
	         @ctxt_language,
	         @ctxt_ouinstance,
	         /*code modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/
	         @ctxt_service,
	         @ctxt_user,
	         @customercode,
	         @cust_ou,
	         @cust_bu,
	         @guid,
	         @documentno,
	         @incoplace,
	         @item,
	         @item_var_desc,
	         @item_type,
	         @item_ou,
	         @item_wt,
	         @item_volume,
	         @line_no,
	         @lo,
	         @bu_item,
	         @line_status,
	         @price_flag,
	         @price_rule_no,
	         @pricelist_amend_no,
	         @planningtype,
	         @wh_ou,
	         @sp_ou,
	         @deliveryarea,
	         @stock_qty,
	         @model_config_code,
	         @model_config_var,
	         @modeflag,
	 @order_no,
	         @pricelistno,
	         @pricingdateml,
	         @processingactionml,
	         @promiseddateml,
	         @promotype,
	         @qty,
	  @unititmprice,
	         @refdoclineno,
	  @referencescheduleno,
	         @reqddateml,
	         @reserve_dtml,
	         @salepurposeml,
	         @schtype_hdn,
	         @shiptocustomercode,
	         @shippartial_hdn,
	         @shippingpointml_hdn,
	         @shiptoidml,
	         @sale_uomcode,
	         /*code modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/ 
	         --@sourcedocument,	@spcodeml,		'ACC',			@to_shipdateml,
	         @sourcedocument,
	         @spcodeml,
	         @stockstatus_hdn,
	         @to_shipdateml,
	         /*code modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/
	         --Damodharan modified for OTS ID NSODMS412AT_000526 begins
	     --@extprice,		@trans_mode,		@usagecccodeml,		@variantml,
	         @extprice,
	         @trans_mode,
	         @usagecccodeml,
	         @fb_docml,
	         @variantml,
	         --Damodharan modified for OTS ID NSODMS412AT_000526 ends
	         @warehousemulti,
	         @youritemcode_ml,
	         @unitfrprice,
	         @unitprice_ml,
	         @shelf_life_unit_mul_hdn,
	         @gua_shelflife,
	    @priceuomml,
			 @remarks_amnso,--code added by EBS-971
			 null, -- EBS-1362
	         @m_errorid_tmp OUT,
			 null,
			 null,
			 @customeritemdesc -- code added for EPE-27452 
	    
	    IF @m_errorid_tmp <> 0
	    BEGIN
	        SELECT @m_errorid = @m_errorid_tmp
	        RETURN
	    END
	END --Line no is null	
	
	/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 + Begin*/
	/* Code commented and added for ITS ID : ES_NSO_00748 Begins */
	--IF @feature_flag_yes_no = 'YES'
		IF @feature_flag_yes_no = 'YES' and @refdocexist	=	'N'
	/* Code commented and added for ITS ID : ES_NSO_00748 Ends */
	    --Code added by Robbins
	    UPDATE sotmp_order_item_dtl
	    SET    sodtl_addnl_fld1			= @price_engine_flag,
	           sodtl_addnl_fld2			= @tcd_engine_flag,
	           sodtl_stock_uom_qty		= @stock_qty,
	           sodtl_to_ship_date_dflt	= @to_shipdateml
			   ,sodtl_remarks			= @remarks_amnso--code added by EBS-971
	    WHERE	sodtl_guid		= @guid
	    AND		sodtl_line_no	= @line_no
	/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 + End*/
	
	 
	 
	/*Code Added for 14H109_WFMCONFIG_00005 begin */
	if	@callingservice	is	null
	begin
	/*Code Added for 14H109_WFMCONFIG_00005 end */
	
	SELECT @fprowno + 1 'FPROWNO'
	
	end	--Code Added for 14H109_WFMCONFIG_00005
	SET NOCOUNT OFF
END




