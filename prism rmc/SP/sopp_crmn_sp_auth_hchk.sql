/*$File_version=MS4.3.0.44$*/
/* VERSION NO: PPS4.1.0.009*/
/*****************************************************************************************************
file name 	: sopp_crmn_sp_auth_hchk.sql
version		: 4.0.0.0
procedure name 	: sopp_crmn_sp_auth_hchk
purpose  	: 
author  	: 
component name 	: ppscmqso
method name 	: sopp_crmn_m_auth_hchk

objects referred
 object name  object type  operation
       (insert/update/delete/select/exec)
******************************************************************************************************
Modification details :
	Modified by					Modified on			Remarks
	Sreedhar V					11 Feb 2004			design change-payterm code added as input parameter
	Aswani K     				27/05/2005   		GTS Changes
	Mukesh B					04/09/2005			Code modified for PP Cross Fix - OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) 
	R.Anandnarayanan 			04/11/2005     		rowlock added for perf tunning bugid:PPSCMQSOPPS41_000054 
	ARUN RS						18-Nov-2005			Bug-Fixed For PP Cross-Fix - OTS NO : Savage_PAYTERM_000071
	Indu Ram     				12/Dec/2005  		Code merged for PP Crossfix OTS No: CUMI_PPSCMQSO_000111 (CUMI:PPSCMQSOCUMI_000055)
 	Mukesh B					06/04/2006			Code added for PP Cross Fix - OTS No COBIPPS41_000044
	Geetha.S					7/11/2006			PPSCMQSOPPS41_000082
	Aswani K					24/07/2006			ETA_nso_001067
	Indu Ram     				05/Oct/2006  		PPSCMQSOPPS41_000099
	Anitha 						08/06/2007			PPSCMQSODMS412AT_000040
	Damodharan. R				31 Aug 2007			NSODMS412AT_000507
	Damodharan. R				06 Oct 2007			NSODMS412AT_000526
	Damodharan. R				08 Oct 2007			NSODMS412AT_000526
	Anitha N					09 Oct 2007			NSODMS412AT_000533
	Damodharan. R				11 Dec 2007			DMS412AT_NSO_00002
	Veangadakrishnan R			10/04/2008			DMS412AT_NSO_00039
	Veangadakrishnan R			18/04/2008			DMS412AT_NSO_00030
	Damodharan. R				27 May 2008			DMS412AT_NSO_00052
	Damodharan. R				20 Oct 2008			ES_NSO_00074
	Damodharan. R				15 Jan 2009			ES_NSO_00135
	Vairamani C					30 Mar 2009			ES_NSO_00213
	Veangadakrishnan R			01/04/2009			ES_NSO_00206
	Damodharan. R				09/06/2009			ES_NSO_00261
	Deepti Das					04/07/2012			ES_NSO_00561
	Sujatha S					08/06/2012			ES_NSO_00549
	Prabhakaran					01 Apr 2014			ES_NSO_00748
	Vasantha A					24/01/2015			ES_NSO_00897
	Divyalekaa					21/03/2015			14H109_TCAL_00032:14H109_NSO_00005
	Pandiarajan E				05/06/2015			ES_NSO_00931
	Bharath A					09/09/2015			14H109_WFMCONFIG_00005
	vasantha a					22/12/2015			ES_NSO_01034 
	vasantha a					23/05/2016			ES_Qtn_Proc_00072
	vasantha a					11/12/2016			ES_NSO_01328
	Prakash V					11/01/2017			ES_NSO_01365
	Vasantha a					12/06/2017			VE-2766	
	Banu M                      22/09/2017			HAL-227
	Sivapriya J					02/19/2018			JAI-72
	Sivasankari                 5/03/2018           MKN-57
	Vasantha a					08/05/2018			PEPS-8 
	Balasubramaniyam P			06/06/2018			EBS-1362
	Banu M                      10/08/2018          GEO-85	
	Abinaya G					30/01/2019			KPE-13       
	Rani B						24/07/2019			AFL-227	
	Bharath A					05_Nov_2019			AFL-283
/*Vasudevan k                   29/01/2020		    EBS-3881  */
/*Basil LD						19/09/2020		    EBS-5021  */
	Abinaya G					09/08/2021			SFIE-656
	Ambrin banu S				21/04/2022			DSDE-228
	 /*Chaitanya Ch        15/11/2023          EPE-58525*/
	 Kathiravan P				12/02/2024			EBS-6186
	 Banurekha B                 17/4/2024           EPE-80436
	 Banurekha B                  21/5/2024          EPE-81819
	  Ambrin banu S    21/04/2022   DSDE-228      
 /* Shrimalavika M	27-11-2024	PJRMC-894	*/
*****************************************************************************************************/
--grant exec on sopp_crmn_sp_auth_hchk to public

create   procedure sopp_crmn_sp_auth_hchk
	--temporary store for input parameter assignment
	@addressidml   				udd_addressid  ,
	@atplevel_hdn   			udd_metadata_code  ,
	@atpsl_hdn   				udd_metadata_code  ,
	@buid   					udd_buid  ,
	@carriercode   				udd_carriercode  ,
	@ctxt_language   			udd_ctxt_language  ,
	@ctxt_ouinstance   			udd_ctxt_ouinstance  ,
	@ctxt_service   			udd_ctxt_service  ,
	@ctxt_user   				udd_ctxt_user  ,
	@currency   				udd_currency ,
	--@cuspono   					udd_documentno  ,--MKN-57
	--@cuspono                    udd_cust_po_no,--MKN-57
	 @cuspono      udd_trandesc,--EPE-58525
	@custdetails   				udd_subtitle  ,
	@custname   				udd_custname  ,
	@customercode   			udd_customer_id  ,
	@def_info   				udd_subtitle ,
	@desc255   					udd_desc255  ,
	@freight_bill_hdn   		udd_metadata_code  ,
	@freightamount 			udd_amount  ,
	@frt_currency   			udd_currencycode  ,
	@frtmethod_hdn   			udd_metadata_code  ,
	/*code added for HAL-227 starts here*/
 -- @gross_volume               udd_volume ,
    @gross_volume               udd_weight,
    /*code added for HAL-227 ends here*/
	@gross_weight   			udd_weight  ,
	@guid   					udd_guid  ,
	@hidden_control1   			udd_hiddencontrol  ,
	@hidden_control2   			udd_hiddencontrol  ,
	@itemdetail   				udd_itemcode  ,
	@loid   					udd_loid ,
	@netweight   				udd_weight  ,
	@num_series   				udd_notypeno  ,
	@ord_bas_val   				udd_amount  ,
	@ord_det   					udd_document  ,
	@ord_exempt   				udd_flag  ,
	@ord_tot_val   				udd_amount  ,
	@ord_type_hdn   			udd_metadata_code  ,
	@order_date   				udd_date  ,
	@order_no   				udd_documentno  ,
	@overridewt   				udd_quantity  ,
	@overridvol   				udd_quantity  ,
	@paytermcode   				udd_paytermcode  ,
	@podate   					udd_date  ,
	@price_const   				udd_subtitle  ,
	@pricelist   				udd_pricelist  ,
	@pricingdate   				udd_date  ,
	@promiseddate   			udd_date  ,
	@reqddate   				udd_date  ,
	@resporgunit   				udd_ouinstname  ,
	@sale_type   				udd_sales  ,
	@shippingpoint_hdn   		udd_ouinstid  ,
	@shiptoaddid   				udd_id  ,
	@shiptocustomer   			udd_customer_id  ,
	@source_doc   				udd_subtitle  ,
	@sourcedocno   				udd_documentno  ,
	@sourcedocument_qso_hdn		udd_metadata_code  ,
	@status1   					udd_status  ,
	@timestamp   				udd_timestamp  ,
	@total_charge   			udd_amount  ,
	@total_discount   			udd_amount  ,
	@total_tax   				udd_amount  ,
	@total_vat   				udd_amount  ,
	@trans_mode   				udd_identificationnumber1  ,
	@trantype   				udd_type  ,
	@vatcalc   					udd_option  ,
	@volume_uom   				udd_uomcode  ,
	@warehouse   				udd_warehouse  ,
	@weight_uom   				udd_uomcode  ,
	@wfdockey   				udd_wfdockey  ,
	@wforgunit 					udd_wforgunit  ,
	@fprowno   					udd_rowno  ,
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
	@salesperson				udd_saleperson_id,  --Input 
	@folder						udd_folder,  --Input 
	@saleschannel				udd_saleschannel,  --Input 
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/	
	/*code added for defect id : EBS-1362 starts here*/
	@customertaxregion      	udd_tcdcode,	
	@owntaxregion           	udd_tcdcode,	 
	@taxregnno              	udd_desc40,
	/*code added for defect id : EBS-1362 ends here*/
	@m_errorid  				udd_int output --to return execution status
	/*Code Added for 14H109_WFMCONFIG_00005 begin */
	,@fin_error					udd_int	=	null	output,
	@callingservice				udd_ctxt_service	=	null,

	--EBS-5021
	@orderno					udd_docuemntno	=	null output
	--EBS-5021
	/*Code Added for 14H109_WFMCONFIG_00005 end*/
AS
BEGIN
	-- nocount should be switched on to prevent phantom rows 
	SET NOCOUNT ON

	--declare @iudmodeflag varchar(2) 
	/* Code added by Damodharan. R on 11 Dec 2007 for OTS ID DMS412AT_NSO_00002 starts here */
	DECLARE @cust_lo           udd_loid  
	DECLARE @cust_bu           udd_buid
	DECLARE @cust_ou           udd_ctxt_ouinstance
	DECLARE @trandate          udd_date
	DECLARE @m_errorid_tmp     udd_int	--INT		/*ES_NSO_00261 - SP analyser exception*/
	DECLARE @ouname_tmp        udd_oudesc
	/* Code added by Damodharan. R on 11 Dec 2007 for OTS ID DMS412AT_NSO_00002 ends here */
	/*code Added for the dts id:ES_NSO_00206 starts here*/
	DECLARE @workflow_app     udd_metadata_code,
	        @crt_on_auth_flag  udd_metadata_code 
	/*code Added for the dts id:ES_NSO_00206 ends here*/
	--code added by vasantha a for ES_NSO_01328 begins
	 declare @check_chg   udd_checkbox  ,
			 @check_disc   udd_checkbox  ,
			 @check_price   udd_checkbox  ,
			 @check_promos   udd_checkbox  ,
			 @check_tax		 udd_checkbox  ,
    --code added by vasantha a for ES_NSO_01328 ends
	/* Code added for  AFL-227 begins */
    -- @so_ctxtst_ouinstance	udd_ctxt_ouinstance,	-- commented for SCRA Validations exceptions in id EPE-80436
	 @spcodeml			udd_code  ,
	 @spou				udd_ctxt_ouinstance,
	 @status   					udd_status 
	 /* Code added for  AFL-227 ends */

	 --Code added for EBS-6186 begins
	 declare 	@count_shiptoid			udd_int, 
				@count_shiptocustomer	udd_int
	--Code added for EBS-6186 ends

	-- @m_errorid should be 0 to indicate success
	SELECT @m_errorid = 0     
	
	SELECT @addressidml = LTRIM(RTRIM(@addressidml))
	IF @addressidml = '~#~'
	    SELECT @addressidml = NULL
	
	SELECT @atplevel_hdn = LTRIM(RTRIM(@atplevel_hdn))
	IF @atplevel_hdn = '~#~'
	    SELECT @atplevel_hdn = NULL
	
	SELECT @atpsl_hdn = LTRIM(RTRIM(@atpsl_hdn))
	IF @atpsl_hdn = '~#~'
	    SELECT @atpsl_hdn = NULL
	
	SELECT @buid = LTRIM(RTRIM(@buid))
	IF @buid = '~#~'
	    SELECT @buid = NULL
	
	SELECT @carriercode = LTRIM(RTRIM(@carriercode))
	IF @carriercode = '~#~'
	    SELECT @carriercode = NULL
	
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
	
	SELECT @currency = LTRIM(RTRIM(@currency))
	IF @currency = '~#~'
	    SELECT @currency = NULL
	
	SELECT @cuspono = LTRIM(RTRIM(@cuspono))
	IF @cuspono = '~#~'
	    SELECT @cuspono = NULL
	
	SELECT @custdetails = LTRIM(RTRIM(@custdetails))
	IF @custdetails = '~#~'
	    SELECT @custdetails = NULL
	
	SELECT @custname = LTRIM(RTRIM(@custname))
	IF @custname = '~#~'
	    SELECT @custname = NULL
	
	SELECT @customercode = LTRIM(RTRIM(@customercode))
	IF @customercode = '~#~'
	    SELECT @customercode = NULL
	
	SELECT @def_info = LTRIM(RTRIM(@def_info))
	IF @def_info = '~#~'
	    SELECT @def_info = NULL
	
	SELECT @desc255 = LTRIM(RTRIM(@desc255))
	IF @desc255 = '~#~'
	    SELECT @desc255 = NULL
	
	SELECT @freight_bill_hdn = LTRIM(RTRIM(@freight_bill_hdn))
	IF @freight_bill_hdn = '~#~'
	    SELECT @freight_bill_hdn = NULL
	
	IF @freightamount = -915
	    SELECT @freightamount = NULL
	
	SELECT @frt_currency = LTRIM(RTRIM(@frt_currency))
	IF @frt_currency = '~#~'
	    SELECT @frt_currency = NULL
	
	SELECT @frtmethod_hdn = LTRIM(RTRIM(@frtmethod_hdn))
	IF @frtmethod_hdn = '~#~'
	    SELECT @frtmethod_hdn = NULL
	
	IF @gross_volume = -915
	    SELECT @gross_volume = NULL
	
	IF @gross_weight = -915
	    SELECT @gross_weight = NULL
	
	SELECT @guid = LTRIM(RTRIM(@guid))
	IF @guid = '~#~'
	    SELECT @guid = NULL
	
	SELECT @hidden_control1 = LTRIM(RTRIM(@hidden_control1))
	IF @hidden_control1 = '~#~'
	    SELECT @hidden_control1 = NULL
	
	SELECT @hidden_control2 = LTRIM(RTRIM(@hidden_control2))
	IF @hidden_control2 = '~#~'
	    SELECT @hidden_control2 = NULL
	
	SELECT @itemdetail = LTRIM(RTRIM(@itemdetail))
	IF @itemdetail = '~#~'
	    SELECT @itemdetail = NULL
	
	SELECT @loid = LTRIM(RTRIM(@loid))
	IF @loid = '~#~'
	    SELECT @loid = NULL
	
	IF @netweight = -915
	    SELECT @netweight = NULL
	
	SELECT @num_series = LTRIM(RTRIM(@num_series))
	IF @num_series = '~#~'
	    SELECT @num_series = NULL
	
	IF @ord_bas_val = -915
	    SELECT @ord_bas_val = NULL
	
	SELECT @ord_det = LTRIM(RTRIM(@ord_det))
	IF @ord_det = '~#~'
	    SELECT @ord_det = NULL
	
	SELECT @ord_exempt = LTRIM(RTRIM(@ord_exempt))
	IF @ord_exempt = '~#~'
	    SELECT @ord_exempt = NULL
	
	IF @ord_tot_val = -915
	    SELECT @ord_tot_val = NULL
	
	SELECT @ord_type_hdn = LTRIM(RTRIM(@ord_type_hdn))
	IF @ord_type_hdn = '~#~'
	    SELECT @ord_type_hdn = NULL
	
	IF @order_date = '01/01/1900'
	    SELECT @order_date = NULL
	
	SELECT @order_no = LTRIM(RTRIM(@order_no))
	IF @order_no = '~#~'
	    SELECT @order_no = NULL
	
	IF @overridewt = -915
	    SELECT @overridewt = NULL
	
	IF @overridvol = -915
	    SELECT @overridvol = NULL
	
	SELECT @paytermcode = LTRIM(RTRIM(@paytermcode))
	IF @paytermcode = '~#~'
	    SELECT @paytermcode = NULL
	
	IF @podate = '01/01/1900'
	    SELECT @podate = NULL
	
	SELECT @price_const = LTRIM(RTRIM(@price_const))
	IF @price_const = '~#~'
	    SELECT @price_const = NULL
	
	SELECT @pricelist = LTRIM(RTRIM(@pricelist))
	IF @pricelist = '~#~'
	    SELECT @pricelist = NULL
	
	IF @pricingdate = '01/01/1900'
	    SELECT @pricingdate = NULL
	
	IF @promiseddate = '01/01/1900'
	    SELECT @promiseddate = NULL
	
	IF @reqddate = '01/01/1900'
	    SELECT @reqddate = NULL
	
	SELECT @resporgunit = LTRIM(RTRIM(@resporgunit))
	IF @resporgunit = '~#~'
	    SELECT @resporgunit = NULL
	
	SELECT @sale_type = LTRIM(RTRIM(@sale_type))
	IF @sale_type = '~#~'
	    SELECT @sale_type = NULL
	
	IF @shippingpoint_hdn = -915
	    SELECT @shippingpoint_hdn = NULL
	
	SELECT @shiptoaddid = LTRIM(RTRIM(@shiptoaddid))
	IF @shiptoaddid = '~#~'
	    SELECT @shiptoaddid = NULL
	
	SELECT @shiptocustomer = LTRIM(RTRIM(@shiptocustomer))
	IF @shiptocustomer = '~#~'
	    SELECT @shiptocustomer = NULL
	
	SELECT @source_doc = LTRIM(RTRIM(@source_doc))
	IF @source_doc = '~#~'
	   SELECT @source_doc = NULL
	
	SELECT @sourcedocno = LTRIM(RTRIM(@sourcedocno))
	IF @sourcedocno = '~#~'
	    SELECT @sourcedocno = NULL
	
	SELECT @sourcedocument_qso_hdn = LTRIM(RTRIM(@sourcedocument_qso_hdn))
	IF @sourcedocument_qso_hdn = '~#~'
	    SELECT @sourcedocument_qso_hdn = NULL
	
	SELECT @status1 = LTRIM(RTRIM(@status1))
	IF @status1 = '~#~'
	    SELECT @status1 = NULL
	
	IF @timestamp = -915
	    SELECT @timestamp = NULL
	
	IF @total_charge = -915
	    SELECT @total_charge = NULL
	
	IF @total_discount = -915
	    SELECT @total_discount = NULL
	
	IF @total_tax = -915
	    SELECT @total_tax = NULL
	
	IF @total_vat = -915
	    SELECT @total_vat = NULL
	
	SELECT @trans_mode = LTRIM(RTRIM(@trans_mode))
	IF @trans_mode = '~#~'
	    SELECT @trans_mode = NULL
	
	SELECT @trantype = LTRIM(RTRIM(@trantype))
	IF @trantype = '~#~'
	    SELECT @trantype = NULL
	
	SELECT @vatcalc = LTRIM(RTRIM(@vatcalc))
	IF @vatcalc = '~#~'
	    SELECT @vatcalc = NULL
	
	SELECT @volume_uom = LTRIM(RTRIM(@volume_uom))
	IF @volume_uom = '~#~'
	    SELECT @volume_uom = NULL
	
	SELECT @warehouse = LTRIM(RTRIM(@warehouse))
	IF @warehouse = '~#~'
	    SELECT @warehouse = NULL
	
	SELECT @weight_uom = LTRIM(RTRIM(@weight_uom))
	IF @weight_uom = '~#~'
	    SELECT @weight_uom = NULL
	
	SELECT @wfdockey = LTRIM(RTRIM(@wfdockey))
	IF @wfdockey = '~#~'
	    SELECT @wfdockey = NULL
	
	IF @wforgunit = -915
	    SELECT @wforgunit = NULL
	
	IF @fprowno = -915
	    SELECT @fprowno = NULL
	/* Code added by Damodharan. R on 04 Oct 2007 for OTS ID NSODMS412AT_000526 starts here */
	IF @exchangerate = -915
	    SELECT @exchangerate = NULL  
	
	SELECT @check_loi = LTRIM(RTRIM(@check_loi))
	IF @check_loi = '~#~'
	    SELECT @check_loi = NULL  
	
	IF @advance = -915
	    SELECT @advance = NULL  
	
	SELECT @contact_person = LTRIM(RTRIM(@contact_person))
	IF @contact_person = '~#~'
	    SELECT @contact_person = NULL  
	
	SELECT @fb_doc = LTRIM(RTRIM(@fb_doc))
	IF @fb_doc = '~#~'
	    SELECT @fb_doc = NULL  
	
	SELECT @usagecccode = LTRIM(RTRIM(@usagecccode))
	IF @usagecccode = '~#~'
	    SELECT @usagecccode = NULL  
	
	SELECT @createdby = LTRIM(RTRIM(@createdby))
	IF @createdby = '~#~'
	    SELECT @createdby = NULL  
	
	IF @createddate = '01/01/1900'
	    SELECT @createddate = NULL  
	
	SELECT @modifiedby = LTRIM(RTRIM(@modifiedby))
	IF @modifiedby = '~#~'
	    SELECT @modifiedby = NULL  
	
	IF @modifieddate = '01/01/1900'
	    SELECT @modifieddate = NULL 
	/* Code added by Damodharan. R on 04 Oct 2007 for OTS ID NSODMS412AT_000526 ends here */
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/	
	SELECT @salesperson = LTRIM(RTRIM(@salesperson))
	IF @salesperson = '~#~'
	    SELECT @salesperson = NULL
	
	SELECT @folder = LTRIM(RTRIM(@folder))
	IF @folder = '~#~'
	    SELECT @folder = NULL
	
	SELECT @saleschannel = LTRIM(RTRIM(@saleschannel))   
	IF @saleschannel = '~#~'
	    SELECT @saleschannel = NULL 
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/
	/*Code added for defect id : EBS-1362 starts here*/
	Select @customertaxregion       = ltrim(rtrim(@customertaxregion))	
	IF @customertaxregion = '~#~' 
		Select @customertaxregion = null 
	Select @owntaxregion            = ltrim(rtrim(@owntaxregion))
	IF @owntaxregion = '~#~' 
		Select @owntaxregion = null 
	Select @taxregnno               = ltrim(rtrim(@taxregnno))
	IF @taxregnno = '~#~' 
		Select @taxregnno = null
	/*Code added for defect id : EBS-1362 ends here*/
	/* Code added by Damodharan. R on 11 Dec 2007 for OTS ID DMS412AT_NSO_00002 starts here */
	SELECT @trandate = dbo.RES_Getdate(@ctxt_ouinstance)
	
	SELECT @cust_ou = destinationouinstid
	FROM   fw_admin_view_comp_intxn_model(NOLOCK)
	WHERE  sourcecomponentname = 'NSO'
	AND    sourceouinstid = @ctxt_ouinstance
	AND    destinationcomponentname = 'CU'
	
	EXEC scm_get_emod_details @cust_ou,
	     @trandate,
	     @cust_lo OUT,
	     @cust_bu OUT,
	     @m_errorid_tmp OUT
	
	IF @m_errorid_tmp = 325041
	BEGIN
			select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
	    EXEC fin_german_raiserror_sp 'NSO',
	         @ctxt_language,
	         73
	    
	    RETURN
	END
	
	SELECT @ouname_tmp = LTRIM(RTRIM(ou_name))
	FROM   scm_emodel_vw(NOLOCK)
	WHERE  ou = @ctxt_ouinstance
	
	--code added for SFIE-656 begins
	IF @sourcedocno IS NULL
     SELECT @sourcedocument_qso_hdn = 'NONE'   
	--code added for SFIE-656 ends

	IF @addressidml IS NULL
	OR @addressidml = ''
	BEGIN
	    /* Code commented by Damodharan. R on 27 May 2008 for Defect ID DMS412AT_NSO_00052 starts here */ 
	    /*		select	@addressidml	=	cou_order_from_id       
	    from	cust_ou_info_vw (nolock)
	    where	cou_lo				=	@cust_lo        
	    and		cou_bu				=	@cust_bu        
	    and		cou_ou				=	@cust_ou        
	    and		cou_cust_code		=	@customercode		*/
	    /* Code commented by Damodharan. R on 27 May 2008 for Defect ID DMS412AT_NSO_00052 ends here */ 
	    
	    /* Code added by Damodharan. R on 27 May 2008 for Defect ID DMS412AT_NSO_00052 starts here */ 
	    /* Code commented by Damodharan. R on 20 Oct 2008 for Defect ID ES_NSO_00074 starts here */
	    /*
	    ;
	    WITH SQLTMP (destinationouinstid1) as ( select 	distinct sql2k51.destinationouinstid
	    from 	fw_admin_view_comp_intxn_model sql2k51 (nolock) 
	    where 	sql2k51.sourcecomponentname 	 	=	'NSO' 
	    and 	sql2k51.sourceouinstid 		 	=	@ctxt_ouinstance
	    and	sql2k51.destinationcomponentname	=	'CU' )
	    
	    
	    select	@addressidml	=	cou_order_from_id
	    from 	cust_ou_info_vw (nolock) join SQLTMP 
	    on (cou_ou = sqltmp.destinationouinstid1)
	    where	cou_cust_code   =	@customercode
	    and	cou_lo		=	@cust_lo
	    and	cou_bu		=	@cust_bu
	    */
	    /* Code commented by Damodharan. R on 20 Oct 2008 for Defect ID ES_NSO_00074 ends here */
	    
	    /* Code added by Damodharan. R on 20 Oct 2008 for Defect ID ES_NSO_00074 starts here */
	    SELECT @addressidml = cou_order_from_id
	    FROM   cust_ou_info_vw(NOLOCK)
	    WHERE  cou_cust_code = @customercode
	    AND    cou_lo = @cust_lo
	    AND    cou_bu = @cust_bu
	    AND    cou_ou = @ctxt_ouinstance
	    
	    IF @addressidml IS NULL
	    OR @addressidml = ''
	    BEGIN
	        SELECT @addressidml = addr_address_id
	        FROM   cust_addr_details_vw(NOLOCK)
	        WHERE  addr_lo = @cust_lo
	        AND    addr_cust_code = @customercode
	    END/* Code added by Damodharan. R on 20 Oct 2008 for Defect ID ES_NSO_00074 ends here */
	       
	       /* Code added by Damodharan. R on 27 May 2008 for Defect ID DMS412AT_NSO_00052 ends here */
	END
	
	/* Code commented by Damodharan. R on 20 Oct 2008 for Defect ID ES_NSO_00074 starts here */
	/*
	if exists	(	select	'x'
	from	cust_ou_info_vw (nolock)
	where	cou_lo				=	@cust_lo        
	and		cou_bu				=	@cust_bu    */
	/* Code modified by Damodharan. R on 27 May 2008 for Defect ID DMS412AT_NSO_00052 starts here */ 
	--and		cou_ou				=	@cust_ou  
	/*
	and	cou_ou		in	(	select 	destinationouinstid
	from 	fw_admin_view_comp_intxn_model (nolock) 
	where 	sourcecomponentname 	 	=	'NSO' 
	and 	sourceouinstid 		 	=	@ctxt_ouinstance
	and	destinationcomponentname	=	'CU'
	)	*/
	/* Code modified by Damodharan. R on 27 May 2008 for Defect ID DMS412AT_NSO_00052 ends here */ 
	/*
	and		cou_cust_code		=	@customercode
	and		cou_order_from_id	=	@addressidml	)	*/
	/* Code commented by Damodharan. R on 20 Oct 2008 for Defect ID ES_NSO_00074 ends here */
	
	/* Code added by Damodharan. R on 20 Oct 2008 for Defect ID ES_NSO_00074 starts here */
	IF EXISTS (
	       SELECT 'X'
	       FROM   cust_addr_details_vw(NOLOCK)
	       WHERE  addr_lo = @cust_lo
	       AND    addr_cust_code = @customercode
	       AND    addr_address_id = @addressidml
	   ) 
	   /* Code added by Damodharan. R on 20 Oct 2008 for Defect ID ES_NSO_00074 ends here */
	BEGIN
	    SELECT @ctxt_ouinstance = @ctxt_ouinstance
	END
	ELSE
	BEGIN
			select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
	    --"%a" is not valid order from Address id for the customer "%b" at "%c".
	    EXEC fin_german_raiserror_sp 'NSO',
	         @ctxt_language,
	         72,
	         @addressidml,
	         @customercode,
	         @ouname_tmp
	    
	    RETURN
	END
	/* Code added by Damodharan. R on 11 Dec 2007 for OTS ID DMS412AT_NSO_00002 ends here */
	/*code added for GEO-85	starts here*/
	--code commented for EBS-3881
	--if  exists (select 'x' from	pps_feature_list (nolock)
 --  				        where feature_id	    = 'PPS_NSO_MAINSO_validate_transport_mode'
	--				    and	  component_name	= 'NSO'
	--			        and	  flag_yes_no		= 'YES'
 --  			           )

 --code added for EBS-3881 starts here 
    	declare @PPS_flag 	udd_yesnoflag
	if exists (select	'X' 
				from	pps_feature_ou_list(nolock)
				where	feature_id		= 'PPS_NSO_MAINSO_validate_transport_mode'
				and		component_name	= 'NSO'
				and		OU_ID			=	@ctxt_ouinstance
				)
	begin 
		select  @PPS_flag	= flag_yes_no 
		from	pps_feature_ou_list(nolock)
		where	feature_id		= 'PPS_NSO_MAINSO_validate_transport_mode'
		and		component_name	= 'NSO'
		and		flag_yes_no		= 'YES'
		and		OU_ID			=	@ctxt_ouinstance
	end
	else
	begin
		select @PPS_flag	= flag_yes_no 
		from	pps_feature_list(nolock)
		where	feature_id		= 'PPS_NSO_MAINSO_validate_transport_mode'
		and		flag_yes_no		= 'YES'
		and		component_name	= 'NSO'
	end

	--code added for EBS-3881 end here 



	if @PPS_flag= 'YES'--code added for EBS-3881

   begin
	   if (@trans_mode is null )
	   begin
	     EXEC fin_german_raiserror_sp 'NSO',@ctxt_language,2033
	   end  
   end 
	/*code added for GEO-85	ends here*/

	/*Code merged by Indu for CUMI_PPSCMQSO_000111 on 12/Dec/2005 Begin*/
	/* Code Modified By Aswani K For The Bug ID : ETA_nso_000917 ON 24/07/2006 Starts */
	--	select @guid = replace(replace(@guid,'{',''),'}','')
	/* Code Modified By Aswani K For The Bug ID : ETA_nso_000917 ON 24/07/2006 Ends */
	/*Code merged by Indu for CUMI_PPSCMQSO_000111 on 12/Dec/2005 End*/
	
	/*Code modified by Indu for PPSCMQSOPPS41_000099 on 05/Oct/2006 Begins*/
	SELECT @guid = REPLACE(REPLACE(@guid, '{', ''), '}', '')
	/*Code modified by Indu for PPSCMQSOPPS41_000099 on 05/Oct/2006 Ends*/
	
	--temp variables
	DECLARE --@price_ou	udd_ctxt_ouinstance,
	        --@tc_ou		udd_ctxt_ouinstance,
	        @activity_flag  udd_metadata_code,
	        --@disc_ou	udd_ctxt_ouinstance,
	        --@prom_ou	udd_ctxt_ouinstance,
	        @status_prev    udd_metadata_code,
	        @dtl_line_no    udd_lineno,
	        --@status_tmp	udd_metadata_code,
	        --@m_error_flag	udd_metadata_code,
	        --@m_errorid_tmp	int,					--DMS412AT_NSO_00002	
	        @call_cmn_is    udd_int,	--INT,		/*ES_NSO_00261 - SP analyser exception*/
	        @req_qty        udd_quantity,
	        @sch_qty        udd_quantity,
	        @sch_type       udd_metadata_code,
	        /* Added For GTS by Aswani K*/
	        @orderdate      udd_date,
	        --@check_loi   	udd_checkbox  , --Code commented by Damodharan. R for OTS ID NSODMS412AT_000526
	        @tcal_status    udd_metadata_code,
	        @applied_flag   udd_flag,
	        @exec_flag      udd_local_flag 
	/* Added For GTS by Aswani K*/
	
	/*Code Added By ARUN For The Bug-ID : Savage_PAYTERM_000071 - Begins */ 
	/*code commented by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00039 starts here*/
	--Declare @date udd_date
	--select  @date = dbo.RES_Getdate(@ctxt_ouinstance)
	--
	--/*code modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00039 starts here*/
	----if exists (  select 'x' from  pt_sales_payterm_hdr_vw (nolock)
	----   where  pt_ou         = @ctxt_ouinstance
	----   and pt_pay_term_code = @paytermcode
	----   and isnull(pt_expiry_date,@date)< @date)
	--select @date = convert(char(10),@date,120)
	--if exists(
	--		select 'X'
	--		from	pt_sales_payterm_hdr_vw (nolock)
	--		where	pt_ou			=	@ctxt_ouinstance
	--		and	pt_pay_term_code	=	@paytermcode
	--		and	isnull(pt_expiry_date,@date) >= @date
	--		group by pt_version_no
	--		having	pt_version_no = max(pt_version_no)
	--	)
	--begin
	--	select	@ctxt_ouinstance	=	@ctxt_ouinstance
	--end
	--else
	--/*code modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00039 ends here*/
	--begin
	--/* Starts - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
	--        --raiserror('The "Effective To" date of the specified payterm should be "equal to" or "greater" than the present date',16,1)
	--        select @m_errorid = 3752526
	--/* Ends - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
	--return
	--end    
	/*code commented by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00039 ends here*/ 
	/*Code Added By ARUN For The Bug-ID : Savage_PAYTERM_000071 - Ends */    
	
	SELECT @order_no = UPPER(@order_no),
	       @customercode = UPPER(@customercode),
	       @call_cmn_is = 1 
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 starts here */
	--if rtrim(@ctxt_service)	= 'SOPP_CRMN_SER_SBT'
	IF RTRIM(@ctxt_service)	IN ('SOPP_CRMN_SER_SBT', 'SOPP_CRMN_SER_SBT1')
	    SELECT @activity_flag = 'I'
	--if rtrim(@ctxt_service)	= 'SOPP_CRMN_SER_AUTH'
	IF RTRIM(@ctxt_service)	IN ('SOPP_CRMN_SER_AUTH', 'SOPP_CRMN_SER_AUTH1')
	    SELECT @activity_flag = 'AU'
	--if rtrim(@ctxt_service)	= 'SOPP_CRMN_SER_EDT'
	IF RTRIM(@ctxt_service)	IN ('SOPP_CRMN_SER_EDT', 'SOPP_CRMN_SER_EDT1')
	    SELECT @activity_flag = 'U'
	--if rtrim(@ctxt_service)	= 'SOPP_CRMN_SER_CRAU'
	IF RTRIM(@ctxt_service)	IN ('SOPP_CRMN_SER_CRAU', 'SOPP_CRMN_SER_CRAU1')
	    SELECT @activity_flag = 'I'
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 ends here */
	
	/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 ++ Begin*/

	DECLARE @feature_flag_yes_no udd_yesnoflag
	SELECT @feature_flag_yes_no = flag_yes_no
	FROM   pps_feature_list(NOLOCK)
	       /*Code commented & added by Mukesh B for the OTS no COBIPPS41_000044 06/04/2006 Begin*/
	       --		where upper(feature_id) = 'PPS_FID_0041' and upper(component_name) = 'NSO'
	WHERE  feature_id = 'PPS_FID_0041'
	AND    component_name = 'NSO'
	/*Code commented & added by Mukesh B for the OTS no COBIPPS41_000044 06/04/2006 End*/
	
	IF ISNULL(@feature_flag_yes_no, '') = ''
	    SELECT @feature_flag_yes_no = 'NO'
	
	/* Code added for ITS ID : ES_NSO_00748 Begins */
		declare		@refdocexist		udd_metadata_code
		
		select		@refdocexist	=	'N'
		
		if exists ( select	'X'
					from	sotmp_order_hdr(nolock)
					where	sohdr_guid		=	@guid
					and		sohdr_order_no	=	@order_no
					and		sohdr_amend_no	=	0
					and		sohdr_ou		=	@ctxt_ouinstance
					and		sohdr_ref_doc_type=	'QUO'
				  )
		BEGIN
			SELECT @refdocexist = 'Y' 
		end
	/* Code added for ITS ID : ES_NSO_00748 Ends */
	
	IF @feature_flag_yes_no = 'YES'
	BEGIN
	    --CUMI Personalization : Price Override EDK - Code modified by Robbins begins 
	    DECLARE @tcd_engine_flag udd_chkflag
	    --@upd_flag		udd_chkflag
	    
	    SELECT @tcd_engine_flag = 'N'
	    
	    SELECT @tcd_engine_flag = sodtl_addnl_fld2
	    FROM sotmp_order_item_dtl(NOLOCK)
	 WHERE  sodtl_guid = @guid
	    AND    sodtl_addnl_fld2 = 'Y'
	    
	    IF @tcd_engine_flag = 'Y'
	    BEGIN
	        /* Code Modified by Vairamani C for ES_NSO_00213 Starts here */
	        IF EXISTS
	           (
	               SELECT 'X'
	               FROM   sotmp_order_tcd_dtl(NOLOCK)
	               WHERE  doctcd_guid = @guid
	           )
	        BEGIN
	            DELETE 
	            FROM   sotmp_order_tcd_dtl
	            WHERE  doctcd_guid = @guid
	        END
	        
	        --Code Commented for ITS ID : ES_NSO_00748 begins
	        --IF EXISTS
	        --   (
	        --       SELECT 'X'
	        --   FROM   so_doc_tcd_dtl(NOLOCK)
	        --       WHERE  doctcd_ou = @ctxt_ouinstance
	        --       AND    doctcd_order_no = @order_no
	        --   )
	        --BEGIN
	        --    DELETE 
	        --    FROM   so_doc_tcd_dtl
	        --    WHERE  doctcd_ou = @ctxt_ouinstance
	        --    AND    doctcd_order_no = @order_no
	        --END
	        --Code Commented for ITS ID : ES_NSO_00748 Ends

	        IF EXISTS
	           (
	               SELECT 'X'
	               FROM   sotmp_item_tcd_dtl(NOLOCK)
	               WHERE  itmtcd_guid = @guid
	           )
	        BEGIN
	            DELETE 
	            FROM   sotmp_item_tcd_dtl
	            WHERE  itmtcd_guid = @guid
	        END
	        /* Code Modified by Vairamani C for ES_NSO_00213 Ends here */

	        /*Code added by Mukesh B for the OTS no COBIPPS41_000044 06/04/2006 Begin*/
	        INSERT INTO sotmp_order_tcd_dtl
	        (doctcd_ou,doctcd_guid,doctcd_order_no,doctcd_tcdline_no,doctcd_tcdcode,doctcd_tcdvariant,
			doctcd_tcd_version_no,doctcd_tcdtype,doctcd_bill_flag,doctcd_bill_event,doctcd_basis,doctcd_tcdvalue,
			doctcd_total_value,doctcd_billing_period,doctcd_promotion_id,doctcd_deal_id,doctcd_invoiced_flag,
			doctcd_update_flag,doctcd_addnl_fld1,doctcd_addnl_fld2,doctcd_addnl_fld3,doctcd_created_by,
			doctcd_created_date,doctcd_modified_by,doctcd_modified_date,
			doctcd_rule_no,doctcd_orgsrc		--Code added for ITS ID : ES_NSO_00748
			)
	        SELECT doctcd_ou,
	               @guid,
	               doctcd_order_no,
	               doctcd_tcdline_no,
	               doctcd_tcdcode,
	               doctcd_tcdvariant,
	               doctcd_tcd_version_no,
	               doctcd_tcdtype,
	           doctcd_bill_flag,
	               doctcd_bill_event,
	               doctcd_basis,
	               doctcd_tcdvalue,
	               doctcd_total_value,
	               doctcd_billing_period,
	               doctcd_promotion_id,
	               doctcd_deal_id,
	               doctcd_invoiced_flag,
	               'N',
	               doctcd_addnl_fld1,
	               doctcd_addnl_fld2,
	               doctcd_addnl_fld3,
	               doctcd_created_by,
	               doctcd_created_date,
	               doctcd_modified_by,
	               doctcd_modified_date,
			/* Code added for ITS ID : ES_NSO_00748 begins */         
					doctcd_rule_no,
					doctcd_orgsrc
			/* Code added for ITS ID : ES_NSO_00748 ends */	               
	        FROM   so_doc_tcd_dtl(NOLOCK)
	        WHERE  doctcd_ou = @ctxt_ouinstance
	        AND    doctcd_order_no = @order_no
	        AND    doctcd_addnl_fld1 IS NULL 
	        AND    ((doctcd_orgsrc IS NULL and @refdocexist = 'N')
				OR @refdocexist = 'Y')
	        --ES_NSO_00748
	               /*Code added by Mukesh B for the OTS no COBIPPS41_000044 06/04/2006 End*/

			/* Code added for ITS ID : ES_NSO_00748 begins */
             IF @refdocexist	=	'Y'
             begin
				update	sotmp_order_tcd_dtl
				set		doctcd_update_flag	=	'N'
				where	doctcd_guid			=	@guid
             end
	                 
	        IF EXISTS
	           (
	               SELECT 'X'
	               FROM   so_doc_tcd_dtl(NOLOCK)
	               WHERE  doctcd_ou = @ctxt_ouinstance
	     AND    doctcd_order_no = @order_no
	           )
	        BEGIN
	            DELETE 
	            FROM   so_doc_tcd_dtl
	            WHERE  doctcd_ou = @ctxt_ouinstance
	            AND    doctcd_order_no = @order_no
	        END
			/* Code added for ITS ID : ES_NSO_00748 begins */	        	     
	               
	               
	               /*delete from so_item_tcd_dtl
	               where itmtcd_ou 	= @ctxt_ouinstance
	               and itmtcd_order_no	= @order_no*/
	    END
	    ELSE
	    BEGIN
	        /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 starts here */
	        
	        --if rtrim(@ctxt_service) in ('SOPP_CRMN_SER_EDT','SOPP_CRMN_SER_AUTH')     
	        IF RTRIM(@ctxt_service) IN ('SOPP_CRMN_SER_EDT',
	                        'SOPP_CRMN_SER_AUTH',
	                                    'SOPP_CRMN_SER_EDT1',
	                                    'SOPP_CRMN_SER_AUTH1') 
	           /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 ends here */
	        BEGIN
	        
	            IF EXISTS (
	                   SELECT 'y'
	                   FROM   so_order_hdr(NOLOCK)
	                   WHERE  sohdr_ou = @ctxt_ouinstance
	                   AND    sohdr_order_no = @order_no
	                   AND    (sohdr_tc_upd_flag = 'Y' OR sohdr_disc_upd_flag = 'Y')
	               )
	            OR EXISTS (
	                   SELECT 'y'
	                   FROM   so_order_item_dtl(NOLOCK)
	                   WHERE  sodtl_ou = @ctxt_ouinstance
	                   AND    sodtl_order_no = @order_no
	                   AND    (sodtl_tc_upd_flag = 'Y' OR sodtl_disc_upd_flag = 'Y')
	               )
	            BEGIN
	                /* Code Modified by Vairamani C for ES_NSO_00213 Starts here */
	                IF EXISTS
	                   (
	                       SELECT 'X'
	                  FROM   sotmp_order_tcd_dtl(NOLOCK)
	                       WHERE  doctcd_guid = @guid
	                   )
	                BEGIN
	             DELETE 
	                    FROM   sotmp_order_tcd_dtl
	                    WHERE  doctcd_guid = @guid
	                END
	                /* Code Modified by Vairamani C for ES_NSO_00213 Ends here */

	                INSERT INTO sotmp_order_tcd_dtl
	                (	doctcd_ou,doctcd_guid,doctcd_order_no,doctcd_tcdline_no,doctcd_tcdcode,doctcd_tcdvariant,
						doctcd_tcd_version_no,doctcd_tcdtype,doctcd_bill_flag,doctcd_bill_event,doctcd_basis,doctcd_tcdvalue,
						doctcd_total_value,doctcd_billing_period,doctcd_promotion_id,doctcd_deal_id,doctcd_invoiced_flag,
						doctcd_update_flag,doctcd_addnl_fld1,doctcd_addnl_fld2,doctcd_addnl_fld3,doctcd_created_by,
						doctcd_created_date,doctcd_modified_by,doctcd_modified_date,
						doctcd_rule_no,doctcd_orgsrc	--Code added for ITS ID : ES_NSO_00748
					  )
	                SELECT doctcd_ou,
	                       @guid,
	         doctcd_order_no,
	    doctcd_tcdline_no,
	                       doctcd_tcdcode,
	                       doctcd_tcdvariant,
	                       doctcd_tcd_version_no,
	                       doctcd_tcdtype,
	                       doctcd_bill_flag,
	                       doctcd_bill_event,
	                       doctcd_basis,
	                       doctcd_tcdvalue,
	                       doctcd_total_value,
	                       doctcd_billing_period,
	                       doctcd_promotion_id,
	                       doctcd_deal_id,
	                       doctcd_invoiced_flag,
	                       'Y',
	                       doctcd_addnl_fld1,
	                       doctcd_addnl_fld2,
	                       doctcd_addnl_fld3,
	                       doctcd_created_by,
	                       doctcd_created_date,
	                       doctcd_modified_by,
	                       doctcd_modified_date,
					/* Code added for ITS ID : ES_NSO_00748 begins */	                       
							doctcd_rule_no,
							doctcd_orgsrc
	                /* Code added for ITS ID : ES_NSO_00748 ends */       
	                FROM   so_doc_tcd_dtl(NOLOCK)
	                WHERE  doctcd_ou = @ctxt_ouinstance
	               AND    doctcd_order_no = @order_no
					and	   ISNULL(doctcd_orgsrc,'') <> 'NSO'--ES_NSO_00748
					
					/* Code added for ITS ID : ES_NSO_00748 begins */
	                 IF @refdocexist	=	'Y'
	                 begin
						update	sotmp_order_tcd_dtl
						set		doctcd_update_flag	=	'N'
						where	doctcd_guid			=	@guid
	                 end

					IF EXISTS
					   (
						   SELECT 'X'
						   FROM   so_doc_tcd_dtl(NOLOCK)
						   WHERE  doctcd_ou = @ctxt_ouinstance
						   AND    doctcd_order_no = @order_no
					   )
					BEGIN
						DELETE 
						FROM   so_doc_tcd_dtl
						WHERE  doctcd_ou = @ctxt_ouinstance
						AND    doctcd_order_no = @order_no
					END	                 
	               /* Code added for ITS ID : ES_NSO_00748 Ends */
	                 
	                /* Code Modified by Vairamani C for ES_NSO_00213 Starts here */
	                IF EXISTS
	                   (
	                       SELECT 'X'
	                       FROM   sotmp_item_tcd_dtl(NOLOCK)
	                       WHERE  itmtcd_guid = @guid
	                   )
	                BEGIN
	                    DELETE 
	                    FROM   sotmp_item_tcd_dtl
	                    WHERE  itmtcd_guid = @guid
	                           --and itmtcd_line_no	= @line_no
	                END
	                /* Code Modified by Vairamani C for ES_NSO_00213 Ends here */

	                INSERT INTO sotmp_item_tcd_dtl
	                  (	itmtcd_ou,itmtcd_guid,itmtcd_order_no,itmtcd_line_no,itmtcd_tcdline_no,itmtcd_tcdcode,itmtcd_tcdvariant,
						itmtcd_tcd_version_no,itmtcd_tcdtype,itmtcd_bill_flag,itmtcd_bill_event,itmtcd_basis,itmtcd_tcd_value,
						itmtcd_total_value,itmtcd_promotion_id,itmtcd_deal_id,itmtcd_update_flag,itmtcd_addnl_fld1,itmtcd_addnl_fld2,
						itmtcd_addnl_fld3,itmtcd_created_by,itmtcd_created_date,itmtcd_modified_by,itmtcd_modified_date,
						itmtcd_rule_no,itmtcd_orgsrc		--Code added for ITS ID : ES_NSO_00748
					  )
	                SELECT itmtcd_ou,
	                       @guid,
	           itmtcd_order_no,
	                       itmtcd_line_no,
	                       itmtcd_tcdline_no,
	                       itmtcd_tcdcode,
	                       itmtcd_tcdvariant,
	                       itmtcd_tcd_version_no,
	                       itmtcd_tcdtype,
	                       itmtcd_bill_flag,
	                       itmtcd_bill_event,
	        itmtcd_basis,
	                       itmtcd_tcd_value,
	                       itmtcd_total_value,
	                       itmtcd_promotion_id,
	                       itmtcd_deal_id,
	           'Y',
	                       itmtcd_addnl_fld1,
	           itmtcd_addnl_fld2,
	                       itmtcd_addnl_fld3,
	                       itmtcd_created_by,
	                       itmtcd_created_date,
	                       itmtcd_modified_by,
	                       itmtcd_modified_date,
	                /* Code added for ITS ID : ES_NSO_00748 begins */
						   itmtcd_rule_no,
						   itmtcd_orgsrc	                       
					/* Code added for ITS ID : ES_NSO_00748 ends */
	                FROM   so_item_tcd_dtl(NOLOCK)
	                WHERE  itmtcd_ou = @ctxt_ouinstance
	                AND    itmtcd_order_no = @order_no
	                and	   ISNULL(itmtcd_orgsrc,'') <> 'NSO'--ES_NSO_00748
	                       --and 	itmtcd_line_no		= 	@line_no

	               /* Code added for ITS ID : ES_NSO_00748 Begins */    
	                 IF @refdocexist	=	'Y'
	                 begin
						update	sotmp_item_tcd_dtl
						set		itmtcd_update_flag	=	'N'
						where	itmtcd_guid			=	@guid
	                 end
	                 
	               delete from so_item_tcd_dtl
	               where itmtcd_ou 	= @ctxt_ouinstance
	               and itmtcd_order_no	= @order_no
	               /* Code added for ITS ID : ES_NSO_00748 Ends */

	            END
	            ELSE
	            BEGIN
	                UPDATE sotmp_order_tcd_dtl WITH(ROWLOCK)
	                SET    doctcd_update_flag = 'Y'
	                WHERE  doctcd_guid = @guid
	                AND    doctcd_update_flag = 'N'
	                
	                UPDATE sotmp_item_tcd_dtl WITH (ROWLOCK)
	                SET  itmtcd_update_flag = 'Y'
	                WHERE  itmtcd_guid = @guid
	                AND    itmtcd_update_flag = 'N'
	            END
	        END
	    END
	    --CUMI Personalization : Price Override EDK - Code added by Robbins ends
	END 
	/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 ++ End*/
	

	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 starts here */
	--if rtrim(@ctxt_service)	in ('SOPP_CRMN_SER_AUTH','SOPP_CRMN_SER_CRAU')
	IF RTRIM(@ctxt_service)	IN ('SOPP_CRMN_SER_AUTH',
	                       	    'SOPP_CRMN_SER_CRAU',
	                       	    'SOPP_CRMN_SER_AUTH1',
	                       	    'SOPP_CRMN_SER_CRAU1')
	   /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 ends here */
	BEGIN
	    IF @fprowno = 1
	    BEGIN
	        --Enter atleast one row in multiline
	        SELECT @m_errorid = 3550337
	        RETURN
	    END 
	    
	    SELECT @sch_type = sodtl_sch_type
	    FROM   so_order_item_dtl(NOLOCK)
	    WHERE  sodtl_ou = @ctxt_ouinstance
	    AND    sodtl_order_no = @order_no
	    
	    SELECT @req_qty = ISNULL(SUM(ISNULL(sodtl_req_qty, 0)), 0)
	    FROM   so_order_item_dtl(NOLOCK)
	    WHERE  sodtl_ou = @ctxt_ouinstance
	    AND    sodtl_order_no = @order_no
	    
	    SELECT @sch_qty = ISNULL(SUM(ISNULL(sosch_sch_qty, 0)), 0)
	    FROM   so_order_sch_dtl(NOLOCK)
	    WHERE  sosch_ou = @ctxt_ouinstance
	    AND    sosch_order_no = @order_no
	    
	    IF (@sch_type = 'SG')
	    AND (@req_qty <> @sch_qty)
	    BEGIN
	        --line quantity does not equal the sum of schedule quantities
	        SELECT @m_errorid = 3550071
	        RETURN
	    END
	END
	
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 starts here */
	--if rtrim(@ctxt_service)	in ('SOPP_CRMN_SER_AUTH','SOPP_CRMN_SER_CRAU','SOPP_CRMN_SER_EDT')
	IF RTRIM(@ctxt_service)	IN ('SOPP_CRMN_SER_AUTH',
	                       	    'SOPP_CRMN_SER_CRAU',
	                       	    'SOPP_CRMN_SER_EDT',
	    	    'SOPP_CRMN_SER_AUTH1',
	                       	    'SOPP_CRMN_SER_CRAU1',
	                       	    'SOPP_CRMN_SER_EDT1')
	   /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 ends here */
	BEGIN
	   IF EXISTS(
	           SELECT dtl.sodtl_line_no
	           FROM   so_order_item_dtl dtl(NOLOCK)
	           WHERE  dtl.sodtl_ou = @ctxt_ouinstance
	           AND    dtl.sodtl_order_no = @order_no
	           AND    dtl.sodtl_free_item_flag = 'N'
	           AND    dtl.sodtl_line_no NOT IN (SELECT tem.sodtl_line_no
	                                            FROM   sotmp_order_item_dtl tem(NOLOCK)
	                                            WHERE  tem.sodtl_guid = @guid)
	       )
	    BEGIN
	        DECLARE so_cursor1 CURSOR  
	        FOR
	            WITH SQLTMP(tmpCol) AS (
	                SELECT DISTINCT tem.sodtl_line_no
	                FROM   sotmp_order_item_dtl tem(NOLOCK)
	                WHERE  tem.sodtl_guid = @guid
	            )
	        
	        SELECT dtl.sodtl_line_no
	        FROM   so_order_item_dtl dtl(NOLOCK)
	               LEFT OUTER JOIN SQLTMP
	                    ON  (dtl.sodtl_line_no = SQLTMP.tmpCol)
	        WHERE  dtl.sodtl_ou = @ctxt_ouinstance
	        AND    dtl.sodtl_order_no = @order_no
	        AND    dtl.sodtl_free_item_flag = 'N'
	        AND    SQLTMP.tmpCol IS NULL
	        --ToolComment				declare	so_cursor1 cursor for
	        --ToolComment				select	dtl.sodtl_line_no
	        --ToolComment				from	so_order_item_dtl dtl (nolock)
	        --ToolComment				where	dtl.sodtl_ou		=	@ctxt_ouinstance
	        --ToolComment				and	dtl.sodtl_order_no	=	@order_no
	        --ToolComment				and	dtl.sodtl_free_item_flag=	'N'
	        --ToolComment				and	dtl.sodtl_line_no	not in( select	tem.sodtl_line_no
	        --ToolComment									from	sotmp_order_item_dtl tem (nolock)
	        --ToolComment									where	tem.sodtl_guid		=	@guid)
	  --ToolComment
	        --ToolComment					
	        OPEN so_cursor1
	        
	        FETCH NEXT FROM so_cursor1 INTO @dtl_line_no
	        
	        WHILE @@fetch_status = 0
	        BEGIN
	            --calling the procedure to delete the detail tables
	            EXEC so_cmn_line_delete @ctxt_language,
	                 @ctxt_ouinstance,
	                 @ctxt_service,
	                 @ctxt_user,
	                 @order_no,
	                 @dtl_line_no,
	                 'Y'
	            

	            
	            FETCH NEXT FROM so_cursor1 INTO @dtl_line_no
	        END 
	        
	        CLOSE so_cursor1
	        DEALLOCATE so_cursor1
	    END
	    
	    IF EXISTS (
	           SELECT 'X'
	           FROM   so_order_hdr hdr(NOLOCK),
	                  so_order_sch_dtl sch(NOLOCK),
	                  so_order_item_dtl dtl(NOLOCK)
	           WHERE  hdr.sohdr_ou = @ctxt_ouinstance
	           AND    hdr.sohdr_order_no = @order_no
	           AND    hdr.sohdr_ou = dtl.sodtl_ou
	           AND    hdr.sohdr_order_no = dtl.sodtl_order_no
	           AND    dtl.sodtl_ou = sch.sosch_ou
	           AND    dtl.sodtl_order_no = sch.sosch_order_no
	   AND  dtl.sodtl_line_no = sch.sosch_line_no
	           AND    dtl.sodtl_sch_type = 'SG'
	           AND    sch.sosch_ship_to_cust NOT IN (SELECT relatedcust
	                                          FROM   cu_shiptocust_vw(NOLOCK)
	                              WHERE  hdr.sohdr_cust_ou = 
	 ou
	    AND    hdr.sohdr_order_from_cust = 
	                                                        custcode)
	       )
	    BEGIN
	        --Please delete the schedules in schedule page and change the customercode
	        SELECT @m_errorid = 3550343
	        RETURN
	    END
	END
	
	--calling the common procedure to do the peg6 integration, tcd calculation and
	--inserting the data from temp tables to real tables
	--code added by vasantha a forES_NSO_01328 begins
	--if @sourcedocument_qso_hdn ='QUO'--ES_NSO_01328 
	if @sourcedocument_qso_hdn ='QUO'
	and RTRIM(@ctxt_service)	IN ('sopp_crmn_ser_sbt1','sopp_crmn_ser_crau1')--ES_NSO_01365
	and  RTRIM(@ctxt_service) like 'SOPP%' --code added by vasantha a for VE-2766	
	begin
			select 	@check_chg		= 0,
					@check_disc		= 0,
					@check_price	= 0,
					@check_promos	= 0,
					@check_tax		= 0
	end
	else
	begin
			select 	@check_chg		= 1,
					@check_disc		= 1,
					@check_price	= 1,
					@check_promos	= 1,
					@check_tax		= 1
	end
	--code added by vasantha a for ES_NSO_01328 ends
	
		   
	EXEC  so_cmn_sp_sbt_hchk
	     @activity_flag,
	    --code added by vasantha a for ES_NSO_01328 begins
	     --1,
	     --1,
	     --1,
	     --1,
	     --1,
			@check_chg,	
			@check_disc,	
			@check_price,	
			@check_promos,	
			@check_tax,
	    --code added by vasantha a for ES_NSO_01328 ends
	     @ctxt_language,
		 @ctxt_ouinstance,
	     @ctxt_service,
	     @ctxt_user,
	     @guid,
	     @num_series,
	     @order_no OUT,
	     @m_errorid_tmp OUT
	

	IF @m_errorid_tmp <> 0
	BEGIN
		--code added for ES_NSO_00897 begins 
		--IF @m_errorid_tmp = '800523'
		IF @m_errorid_tmp in (800523,1265,1266,1267,1268,1004,1269,1270,1271,1272,1273,1274,1275,1276,1277,680907)--14H109_TCAL_00032:14H109_NSO_00005 --Code added for Defect Id:- JAI-72
		or  @m_errorid_tmp in (680907) --code added by vasantha a for  PEPS-8
		or  @m_errorid_tmp in (3650336) --code added by vasantha a for  KPE-13
		begin
			select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
		--RAISERROR ('ERROR IN TCAL CALCULATION',16,2)
		 EXEC	fin_german_raiserror_sp 'SPPI',
				@ctxt_language,
				18
	    
		RETURN
		end
		
		--code added by vasantha a for ES_NSO_01034 begins                     	  
		IF RTRIM(@ctxt_service)	IN ('SOPP_CRMN_SER_AUTH',
                               	    'SOPP_CRMN_SER_CRAU',
                               	    'SOPP_CRMN_SER_AUTH1',
                               	    'SOPP_CRMN_SER_CRAU1')
            
	   and  @m_errorid_tmp = 900015
		begin
			select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
			EXEC fin_german_raiserror_sp 'TSET', @ctxt_language,1264
			RETURN
		end              
		--code added by vasantha a for ES_NSO_01034 ends
		--code added for ES_NSO_00897 ends 
	    SELECT @m_errorid = @m_errorid_tmp 
	    RETURN
	END
	
	/*Code modified by Indu for PPSCMQSOPPS41_000099 on 05/Oct/2006 Begins*/	
	SELECT @status_prev = sohdr_order_status
	FROM   so_order_hdr(NOLOCK)
	WHERE  sohdr_ou = @ctxt_ouinstance
	AND    sohdr_order_no = @order_no
	/*Code modified by Indu for PPSCMQSOPPS41_000099 on 05/Oct/2006 Ends*/
	
	IF @fprowno = 1
	BEGIN
		
	    SELECT @status1 = 'DR'
	END
	ELSE 
	IF @fprowno > 1
	BEGIN

	

	    -- selecting the header status
	    IF EXISTS(
	           SELECT 'X'
	           FROM   so_order_item_dtl(NOLOCK)
	           WHERE  sodtl_ou = @ctxt_ouinstance
	           AND    sodtl_order_no = @order_no
	           AND    sodtl_line_status = 'DR'
	       )
	    BEGIN
	        SELECT @status1 = 'DR'
	    END
	    ELSE
	    BEGIN
	        /* Added For GTS by Aswani K*/
	        SELECT @tcal_status = sohdr_tcal_status
	        FROM   so_order_hdr(NOLOCK)
	        WHERE  sohdr_ou = @ctxt_ouinstance
	        AND    sohdr_order_no = @order_no
	  
	        IF @check_loi = '1'
	            SELECT @status1 = 'LI'
	        ELSE
	        BEGIN
	            IF @tcal_status = 'NA'
	                SELECT @status1 = 'DR'
	            ELSE
	           /*Code modified by Indu for PPSCMQSOPPS41_000099 on 05/Oct/2006 Begins*/
	            BEGIN
	                /*Code modified by Indu for PPSCMQSOPPS41_000099 on 05/Oct/2006 Ends*/
	                /* Added For GTS by Aswani K*/
	                /*Code modified by Indu for PPSCMQSOPPS41_000099 on 05/Oct/2006 Begins*/ 
	                /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 starts here */
	                --if rtrim(@ctxt_service)	in ('SOPP_CRMN_SER_AUTH','SOPP_CRMN_SER_CRAU')
	                IF RTRIM(@ctxt_service)	IN ('SOPP_CRMN_SER_AUTH',
	        	    'SOPP_CRMN_SER_CRAU',
	                            	    'SOPP_CRMN_SER_AUTH1',
	                                       	    'SOPP_CRMN_SER_CRAU1')
	                    /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 ends here */
	                    SELECT @status1 = 'AU'
	        ELSE
	                    /*Code modified by Indu for PPSCMQSOPPS41_000099 on 05/Oct/2006 Ends*/	
	                    SELECT @status1 = 'FR'
	            END
	            /*Code modified by Indu for PPSCMQSOPPS41_000099 on 05/Oct/2006 Begins*/
	        END 
	        /*Code modified by Indu for PPSCMQSOPPS41_000099 on 05/Oct/2006 Ends*/
	    END
	END
	

	/*Code commented by Indu for PPSCMQSOPPS41_000099 on 05/Oct/2006 Begins*/
	/*
	select 	@status_prev	=	sohdr_order_status
	from	so_order_hdr (nolock)
	where	sohdr_ou	=	@ctxt_ouinstance
	and	sohdr_order_no	=	@order_no
	*/
	/*Code commented by Indu for PPSCMQSOPPS41_000099 on 05/Oct/2006 Ends*/
	/* Code added by Damodharan. R on 08 Oct 2007 for OTS ID NSODMS412AT_000526 starts here */
	IF RTRIM(@ctxt_service)	IN ('SOPP_CRMN_SER_CRAU', 'SOPP_CRMN_SER_CRAU1')
	AND @check_loi = '1'
	BEGIN
			select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
	    --Sale order not in Fresh status. Please check.
	    EXEC fin_german_raiserror_sp 'NSO',
	         @ctxt_language,
	         54
	    
	    RETURN
	END
	/* Code added by Damodharan. R on 08 Oct 2007 for OTS ID NSODMS412AT_000526 ends here */
	
	/*Code Added for the DTS id:ES_NSO_00206 starts here*/
	/* code reverted in id  EPE-81819 starts here */
	/*code commented and added for the id EPE-80436 starts here */
	SELECT @workflow_app = dbo.workflowapp_fet_fn(@ctxt_user, @ctxt_ouinstance, 'NSO', 'NSOSO', 'CRAU')
	/*
	select @workflow_app = isnull(@workflow_app,'N')
	if @callingservice <> 'So_api_ser_cr'
	begin
	SELECT @workflow_app = dbo.workflowapp_fet_fn(@ctxt_user, @ctxt_ouinstance, 'NSO', 'NSOSO', 'CRAU')
	end
	*/
	/*code commented and added for the id EPE-80436 ends here */
	/* code reverted in id  EPE-81819 ends here */

	--code commented by vasantha a ES_Qtn_Proc_00072 begins
	--IF @workflow_app = 'Y'
	--BEGIN
	--code commented by vasantha a ES_Qtn_Proc_00072 ends
	    SELECT @crt_on_auth_flag = parameter_value
	    FROM   so_sys_param_ou_vw(NOLOCK)
	    WHERE  ouid = @ctxt_ouinstance
	    AND    component_name = 'NSO'
	    AND    parameter_code = 'SO_CRT_AND_AUTH'
	    
	    IF @crt_on_auth_flag = 'Y'
	    AND @status1 = 'FR'
	   SELECT @status1 = 'AU'
	   
	   ---EPE-81819
	   --for status going in draft
		if @ctxt_service = 'sopp_crmn_ser_sbt1' and @workflow_app ='Y'
		select @status_prev ='FR',@status1 ='AU'
		--EPE-81819

	    --code added by vasantha a ES_Qtn_Proc_00072 begins
	    if  RTRIM(@ctxt_service)	IN ('sopp_CrMn_ser_Auth1', 'sopp_CrMn_ser_CrAu1')
	     begin
			select @status_prev ='FR',@status1 ='AU'
			end
	     --code added by vasantha a ES_Qtn_Proc_00072 ends
		
	    INSERT INTO so_upd_status_tmp
	      (
	        guid,
	        order_ou,
	        order_no,
	        prev_status,
	   current_status
	      )
	    VALUES
	      (
	        @guid,
	  @ctxt_ouinstance,
	        @order_no,
	        @status_prev,
	        @status1
	      )
	--END --code commented by vasantha a ES_Qtn_Proc_00072 
    /* Code added against PJRMC-613 by Shrimalavika M Begins */
	
	if exists (
				select 'X'
				from depdb..fw_admin_usrrole with(nolock)
				where RoleName	=	'SUPER_APPROVER'
				and UserName	=	@ctxt_user
			)
			Begin
				select @workflow_app	=	'N'		
			End
			
	/* Code added against PJRMC-613 by Shrimalavika M Ends */    
	IF @ctxt_service IN ('sopp_CrMn_ser_sbt1',
	                     'sopp_CrMn_ser_Auth1',
	                     'sopp_CrMn_ser_CrAu1','sopp_crmn_ser_edt1')--ES_NSO_00549
	AND @workflow_app = 'N'
	OR @status1 IN ('DR', 'LI')
	BEGIN

	

		  /*Code Added for the DTS id:ES_NSO_00206 ends here*/
	    UPDATE so_order_hdr WITH(ROWLOCK)
	    SET    sohdr_order_status = @status1,
	           sohdr_prev_status = @status_prev
	           ,sohdr_ref_doc_type	=	@sourcedocument_qso_hdn--ES_NSO_00931
	           --code added by vasantha a for ES_Qtn_Proc_00072 begins
	 ,sohdr_ref_doc_no	=  @sourcedocno
	           ,sohdr_ref_doc_flag	= case when @sourcedocno is not null then 'Y' else  sohdr_ref_doc_flag end
	           --code added by vasantha a for ES_Qtn_Proc_00072 ends 
	    WHERE  sohdr_ou = @ctxt_ouinstance
	    AND    sohdr_order_no = @order_no
	    
	    --Added for PPSCMQSODMS412AT_000040 begins
	    /*Commented for NSODMS412AT_000533 begins
	    update 	so_order_item_dtl
	  set	sodtl_line_status	=	@status1,
	    sodtl_line_prev_status	=	@status_prev,
	    sodtl_modified_by	=	@ctxt_user,
	    sodtl_modified_date	=	dbo.RES_Getdate(@ctxt_ouinstance),
	    sodtl_timestamp		=	sodtl_timestamp+1
	    where	sodtl_ou		=	@ctxt_ouinstance
	    and	sodtl_order_no		=	@order_no
	    
	    update	so_order_sch_dtl
	    set	sosch_sch_status	=	@status1,
	    sosch_modified_by	=	@ctxt_user,
	    sosch_modified_date	=	dbo.RES_Getdate(@ctxt_ouinstance),
	    sosch_timestamp		=	sosch_timestamp + 1
	    where	sosch_ou		=	@ctxt_ouinstance
	    and	sosch_order_no		=	@order_no
	    Commented for NSODMS412AT_000533 begins*/
	    --Added for PPSCMQSODMS412AT_000040 ends
	    
	    /* Added For GTS by Aswani K*/
	    EXEC tcal_status_upd_sp @ctxt_ouinstance,
	         @ctxt_language,
	         @ctxt_user,
	         @ctxt_service,
	         @guid,
	         @ctxt_ouinstance,
	         'SAL_NSO',
	         @order_no,
	         'CREATE',
	         @orderdate,
	         'NSO',
	         @ctxt_service,
	         @order_no,
	         @status1,
	         @applied_flag OUT,
	         @exec_flag OUT,
	         @m_errorid OUT
	 
	
	    IF @m_errorid <> 0
	        RETURN 
	    /* Added For GTS by Aswani K*/
	    --update the sales order table with computed values
	    /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 starts here */
	    --if (rtrim(@ctxt_service) in ('SOPP_CRMN_SER_CRAU','SOPP_CRMN_SER_AUTH')) or @status1 <> 'DR'
	    IF (
	           RTRIM(@ctxt_service) IN ('SOPP_CRMN_SER_CRAU',
	                                    'SOPP_CRMN_SER_AUTH',
	                                    'SOPP_CRMN_SER_CRAU1',
	                                    'SOPP_CRMN_SER_AUTH1')
	       )
	    OR @status1 <> 'DR'
	       /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 ends here */
	    BEGIN
	        --calling the procedure to authorize the document on create
	        EXEC so_cmn_sp_add_on_auth 
	           @ctxt_language,
	             @ctxt_ouinstance,
	             @ctxt_service,
	             @ctxt_user,
	             @guid,
	             @order_no,
	             @call_cmn_is OUT,
	             @m_errorid_tmp OUT
	        
	        IF @m_errorid_tmp <> 0
	        BEGIN
	            SELECT @m_errorid = @m_errorid_tmp 
	            RETURN
	        END
	    END
	END/*Code Added for the DTS id:ES_NSO_00206*/
	
	/*Code added by Damodharan. R on 15 Jan 2009 for Defect ID ES_NSO_00135 starts here*/
	IF RTRIM(@ctxt_service)	IN ('SOPP_CRMN_SER_SBT',
	                       	    'SOPP_CRMN_SER_SBT1',
	                       	    'SOPP_CRMN_SER_EDT',
	                       	    'SOPP_CRMN_SER_EDT1')
	BEGIN
	    SELECT @cust_ou = sohdr_cust_ou
	    FROM   so_order_hdr(NOLOCK)
	    WHERE  sohdr_ou = @ctxt_ouinstance
	    AND    sohdr_order_no = @order_no
	    
	 --calling procedure for getting lo and bu for login ou
	    EXEC scm_get_emod_details @cust_ou,
	         @trandate,
	         @cust_lo OUT,
	         @cust_bu OUT,
	         @m_errorid_tmp OUT
	    
	    IF @m_errorid_tmp = 325041
	    BEGIN
			select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
	        --OU is Invalid for the Transaction Date. Please Check.
	        EXEC fin_german_raiserror_sp 'NSO',
	             @ctxt_language,73
	 
	        
	        RETURN
	    END
	    
	    IF EXISTS (
	           SELECT 'X'
	           FROM   cust_item_details_vw(NOLOCK),
	        so_order_item_dtl(NOLOCK),
	                  so_order_hdr(NOLOCK)
	           WHERE  item_lo = sohdr_lo
	           AND    item_bu = @cust_bu
	           AND    item_cust_code = sohdr_order_from_cust
	           AND    item_ou = sohdr_cust_ou
	           AND    sohdr_ou = @ctxt_ouinstance
	           AND    sohdr_order_no = @order_no
	           AND    sohdr_ou = sodtl_ou
	           AND    sohdr_order_no = sodtl_order_no
	           AND    sodtl_item_code = item_item_code 
	           /*Code added by Damodharan. R on 09/06/2009 for Defect ID ES_NSO_00261 starts here*/
	           AND    sodtl_item_variant = item_item_variant
	           /*Code added by Damodharan. R on 09/06/2009 for Defect ID ES_NSO_00261 ends here*/
	           AND    sodtl_cust_item_code IS NOT NULL
	           AND    sodtl_cust_item_code <> ISNULL(item_cust_item_code, '')
	       )
	    BEGIN
			select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
	        --Item Code is already mapped to another Customer Item Code.
	        EXEC fin_german_raiserror_sp 'NSO',
	             @ctxt_language,
	             32
	        
	        RETURN
	    END
	END
	/*Code added by Damodharan. R on 15 Jan 2009 for Defect ID ES_NSO_00135 ends here*/
	
	-- 	if rtrim(@ctxt_service)	= 'SOPP_CRMN_SER_AUTH'
	-- 	begin
	--
	-- 		select	@status_tmp	=	sohdr_order_status
	-- 		from	so_order_hdr (nolock)
	-- 		where	sohdr_ou	=	@ctxt_ouinstance
	-- 		and	sohdr_order_no	=	@order_no
	--
	-- 		insert into so_upd_status_tmp
	-- 		(	guid,
	-- 			order_ou,
	-- 			order_no,
	-- 			prev_status,
	-- 			current_status)
	-- 		values
	-- 		(	@guid,
	-- 			@ctxt_ouinstance,
	-- 			@order_no,
	-- 			@status_tmp,
	-- 			'AU'
	-- 		)
	-- 	end
			
	/*code added for defect id : ES_NSO_00561 starts*/

	


	IF EXISTS ( SELECT 'X'
		FROM	PPS_FEATURE_LIST	(nolock)
		WHERE	FEATURE_ID      =  'PPS_FID_0157'
		AND		COMPONENT_NAME	=	'NSO'
		AND		FLAG_YES_NO		=	'YES'
	)
	begin
		update  dtl
		set		sdtl_item_code_delv				=	qdtl_item_code_delv,
				sdtl_variant_code_delv			=	qdtl_variant_code_delv,
				sdtl_lineno_delv				=	qdtl_lineno_delv
		from	so_order_item_dtl dtl (nolock),	
				so_order_hdr hdr (nolock),
				qtn_quotation_dtl q (nolock)
		where	sodtl_ou						=	qdtl_ou
		and		sohdr_ou						=	sodtl_ou
		and		sohdr_ref_doc_type				=	'QUO'
		and		sohdr_ou						=	sodtl_ou
		and		sohdr_order_no					=	sodtl_order_no
		and		sohdr_ref_doc_no				=	qdtl_qtn_no
		and		sodtl_line_no					=	qdtl_line_no
		and 	sodtl_item_code					=	qdtl_item_code 
		and		sodtl_order_no					=	@order_no
		and		sodtl_ou						=	@ctxt_ouinstance		
	end
	/*code added for defect id : ES_NSO_00561 ends*/
				
	/*code added for defect id : AFL-227 starts*/
	IF EXISTS ( SELECT 'X'
		FROM	PPS_FEATURE_LIST	(nolock)
		WHERE	FEATURE_ID      =  'PPS_auto_upd_SPContr_during_SOAuth'
		AND		COMPONENT_NAME	=	'NSO'
		AND		FLAG_YES_NO		=	'YES'
	)

	begin

		select  @spcodeml			=	sohdr_sales_person_dflt	,
				@spou				=	sohdr_sales_person_ou,
				@status				=	sohdr_order_status
		from	so_order_hdr(nolock)
		where	sohdr_order_no		=	@order_no
		and		sohdr_ou			=	@ctxt_ouinstance	

	if (@spcodeml is not  null and @status = 'AU')
	begin
		if not exists (select 'X' from so_order_commission_dtl (nolock)
			  where	sosp_ou 			=	@ctxt_ouinstance
			  and	sosp_order_no		=	@order_no )

		begin
			insert into so_order_commission_dtl
				(	sosp_ou,     
					sosp_order_no,      
					sosp_line_no, 
					sosp_spline_no,
					sosp_sale_person_ou,         
					sosp_sale_person_no, 
					sosp_sale_person_contrib,       
					sosp_net_contrib,              
					sosp_commission_amt,          
					sosp_created_by ,   
					sosp_created_date ,  
					sosp_modified_by,  
					sosp_modified_date
				)
				values
				(
					@ctxt_ouinstance,
					rtrim(@order_no),
					1,
					1,
					@spou,
					rtrim(@spcodeml),
					100,
					0,
					0,
					@ctxt_user,
					@trandate,
					@ctxt_user,
					@trandate
				)
		 
		end
	  end
	end
	/*code added for defect id : AFL-227 ENDS*/

	/*Code Added for AFL-283 begin */

	UPDATE	so_order_hdr
	SET		sohdr_ref_doc_type	=	@sourcedocument_qso_hdn,
			sohdr_ref_doc_no	=	@sourcedocno,
	        sohdr_ref_doc_flag	=	case when @sourcedocno is not null then 'Y' else  sohdr_ref_doc_flag end
	WHERE	sohdr_order_no		=	@order_no
	AND		sohdr_ou			=	@ctxt_ouinstance

	/*Code Added for AFL-283 end */
	
	--EBS-5021
	select @orderno  = @order_no
	--EBS-5021

	--Code added for EBS-6186 begin
	Select	@count_shiptocustomer	= Count(distinct(sodtl_ship_to_cust_dflt)) ,
			@count_shiptoid			= Count(distinct(sodtl_ship_to_id_dflt)) 
	from	so_order_item_dtl(nolock)
	Where	sodtl_ou		=	@ctxt_ouinstance
	and		sodtl_order_no	=	@order_no


	if exists( select 'X'
				from	cust_ou_info (nolock)
				where	cou_ou				=	@cust_ou
				and		cou_lo				=	@cust_lo
				and		cou_bu				=	@cust_bu
				and		cou_cust_code		=	@customercode
				and		cou_cust_category	=	'ECOMM'
				and		@count_shiptocustomer		>	1	)
	begin
		EXEC fin_german_raiserror_sp 'NSO',@ctxt_language,200
		return
	end

	if exists( select 'X'
				from	cust_ou_info (nolock)
				where	cou_ou				=	@cust_ou
				and		cou_lo				=	@cust_lo
				and		cou_bu				=	@cust_bu
				and		cou_cust_code		=	@customercode
				and		cou_cust_category	=	'ECOMM'
				and		@count_shiptoid		>	1	)
	begin
		EXEC fin_german_raiserror_sp 'NSO',@ctxt_language,201
		return
	end
	--Code added for EBS-6186 ends
-----------code commeneted in outiedk SP and put it here to fix the workflow Start ----------------      
      
       
        
        
IF @ctxt_service IN ('sopp_CrMn_ser_sbt1','sopp_CrMn_ser_CrAu1')           
 BEGIN           
 declare @count1 int          
 drop table if exists #C          
          
 select *,row_number() over (order by RECEIPE) as 'slno'           
 into #C          
 from zrit_receipe_code_tbl_tmp(nolock)           
 where guid=@guid                
 AND  OU=@ctxt_ouinstance                
 --AND ORDER_no=@order_no          
          
 select @count1 =(select count(*)            
 from #C          
 where guid=@guid                
 AND  OU=@ctxt_ouinstance)                
 --AND ORDER_no=@order_no)          
    
   
DECLARE @Counter1 INT           
declare @recipe_code1 varchar(100)          
          
SET @Counter1=1   
WHILE ( @Counter1 <= @count1)          
BEGIN          
           
 select @recipe_code1 = ( select RECEIPE from #C where slno = @Counter1)          
           
  exec zrit_maintain_sale_recipe_iedk           
              
                
 @ctxt_user       =@ctxt_user     
 ,@ctxt_service    =@ctxt_service                
 ,@ctxt_ouinstance =@ctxt_ouinstance                
 ,@ctxt_language   =@ctxt_language                
 ,@guid            =@guid                
 ,@order_no        =@order_no                
 ,@amend_no        = 0                
 ,@recipe_code     =  @recipe_code1              
             
            
    SET @Counter1  = @Counter1  + 1          
END              
          
          
END          
          
          
          
          
          
 IF @ctxt_service IN ('sopp_CrMn_ser_Edt1')          
 BEGIN           
 declare @count int          
           
--set @count =(select count(RECEIPE)  from zrit_receipe_code_tbl_tmp           
--where guid=@guid                
-- and OU=@ctxt_ouinstance                
-- AND ORDER_no=@order_no)          
          
          
          
drop table if exists #b          
          
 select *,row_number() over (order by RECEIPE_CODE) as 'slno'           
 into #b          
 from zrit_recepe_code_tbl_iedk (nolock)          
 --where guid=@guid                
 where  ORDER_OU=@ctxt_ouinstance                
 AND ORDER_no=@order_no          
          
 select @count =count(*)  from #b           
           
           
           
DECLARE @Counter INT           
declare @recipe_code varchar(100)          
          
SET @Counter=1          
WHILE ( @Counter <= @count)          
BEGIN          
          
           
 select @recipe_code = ( select RECEIPE_CODE from #b where slno = @Counter)          
           
            
          
          
          
          
          
exec zrit_maintain_sale_recipe_iedk          
           
               
 @ctxt_user       =@ctxt_user                
 ,@ctxt_service    =@ctxt_service                
 ,@ctxt_ouinstance =@ctxt_ouinstance                
 ,@ctxt_language   =@ctxt_language                
 ,@guid            =@guid                
 ,@order_no        =@order_no                
 ,@amend_no        = 0            
 ,@recipe_code     =  @recipe_code            
           
                
            
    SET @Counter  = @Counter  + 1          
END             
          
end          
       
      
      
      
      
      
     /*Code Added by Arunkumar J on 23-11-2023 for RMC_SAL_15_24_30A : Start */           
    
--print @ctxt_user  
--print @ctxt_service  
--print  @ctxt_ouinstance  
--print  @ctxt_language  
--print  @order_no  
--print  @guid  
                      
 exec Zrit_Create_PAM_Calculation_Wrapper                    
@ctxt_user                           
,@ctxt_service                        
,''                           
,@ctxt_ouinstance                     
,@ctxt_language                      
,@order_no                              
,''                      
,@guid                      
              
                
 /*Code Added by Arunkumar J on 23-11-2023 for RMC_SAL_15_24_30A : End */         
       
-----------code commeneted in outiedk SP and put it here to fix the workflow Start ----------------      
      

	/*Code Added for 14H109_WFMCONFIG_00005 begin */
	if	@callingservice	is	null
	begin
	/*Code Added for 14H109_WFMCONFIG_00005 end */
	
	/*code commented and added for defect id : EBS-1362 starts here */
	--SELECT @fprowno 		'FPROWNO'
	--OutputList
		
	Select	@hidden_control1							'hidden_control1', 
			isnull(@order_no,@hidden_control1)			'order_no', 
			@fprowno									'fprowno'
	/*code commented and added for defect id : EBS-1362 ends here */

	end	--Code Added for 14H109_WFMCONFIG_00005
	       
   /*
   template select statement for selecting data to app layer
   select 
   @fprowno 'FPROWNO'
   from  ***
   */
	
	SET NOCOUNT ON	/*ES_NSO_00261 - SP analyser exception*/
END











