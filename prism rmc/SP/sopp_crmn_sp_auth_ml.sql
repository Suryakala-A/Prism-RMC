/*$File_version=ms4.3.0.52$*/
/* VERSION NO: PPS4.1.0.008 */
/*******************************************************************************************************************************************************
file name			: 	sopp_crmn_sp_auth_ml.sql            
version  			: 	4.0.0.0            
procedure name  	: 	sopp_crmn_sp_auth_ml            
purpose   			:             
author   			:             
component name  	: 	NSO
method name  		: 	sopp_crmn_m_auth_ml            
********************************************************************************************************************************************************
objects referred            
 object name  object type  operation            
       (insert/update/delete/select/exec)            
********************************************************************************************************************************************************
Modification details :
	Modifid by					Date				Remarks
	R.Anand Narayanan								null validation in multiline warehouse.
	Mukesh B   					04/09/2005  		Code modified for PP Cross Fix - OTS No PPSCMQSOPPS41_000040 (Cumi Personalization)   
	Mukesh B   					08/09/2005  		Code modified for PP Cross Fix - OTS No QUOTATIONPPS41_000011 (Cumi Personalization) 	          
	Indu Ram   					12/Dec/2005 		Code merged for PP Crossfix OTS No: CUMI_PPSCMQSO_000114 (CUMI:PPSCMQSOCUMI_000069)
	Mukesh B   					06/04/2006  		Code added for PP Cross Fix - OTS No COBIPPS41_000044
	Geetha.S					7/11/2006			PPSCMQSOPPS41_000082
	Suganya S					24/10/2006			PPSCMQSOPPS41_000097
	Anitha N					31/10/2006			PPSCMQSOPPS41_000129
	Damodharan. R				31 Aug 2007			NSODMS412AT_000507
	Anitha N					20 Sep 2007			NSODMS412AT_000533
	Anitha N					03 OCT 2007			MCL_PPSCMQSO_BASEFIXES_000027
	Damodharan. R				06 Sep 2007			NSODMS412AT_000526
	Anitha N					10 Oct 2007			NSODMS412AT_000539
	Anitha N					07 Nov 2007			MCL_PPSCMQSO_BASEFIXES_000027
	Damodharan R				06 Mar 2007			DMS412AT_CUCPL_00001
	Damodharan. R				10 Mar 2008			DMS412AT_NSO_00026
	Damodharan. R				08 Apr 2008			DMS412AT_NSO_00035
	Damodharan. R				12 Apr 2008			ES_NSO_00018
	Veangadakrishnan R			18/04/2008			DMS412AT_NSO_00030
	Damodharan. R				07 Aug 2008			ES_NSO_00042
	Divyalekaa					09/09/2008			DMS412AT_STKSTATUS_00003
	Jagadeesan RS				17/10/2008			ES_NSO_00080
	Thiruvengadam.S				21/10/2008			ES_NSO_00079
	Balaji Prasad P.R			30/10/2008			ES_PACKSLIP_00049 
	Jagadeesan RS				07 Nov 2008			ES_cobi_00047
	Sujatha S					17/11/2008			ES_NSO_00096
	Damodharan. R				10 Dec 2008			ES_NSO_00055
	Ananth P.					18/12/2008			ES_NSO_00113
	Veangadakrishnan R			23/12/2008			ES_NSO_00112
	Damodharan. R				12 Feb 2009			ES_NSO_00168
	Chockalingam.S				03 Mar 2009			ES_NSO_00186
	Chockalingam.S				23/03/2009			ES_NSO_00203	
	Vairamani C					Mar 30 2009			ES_NSO_00213		
	Veangadakrishnan R			01/04/2009			ES_NSO_00206  
	Damodharan. R				28 Apr 2009			ES_NSO_00211
	Divyalekaa					12/01/2010			9H123-1_NSO_00042
	John v						19/12/2011			ES_NSO_00502
	Sujatha S					25/02/2013			ES_NSO_00609
	Vivek Anand.S				16/04/2013			ES_NSO_00623
	Prabhakaran					25 Mar 2014			ES_NSO_00747
	Prabhakaran					31 Mar 2014			ES_NSO_00748
	Prabhakaran					10 Apr 2014			ES_NSO_00748:14H109_NSO_00002
	Sejal N Khimani				26 May 2014			ES_NSO_00789
	Bharath A					09/09/2015			14H109_WFMCONFIG_00005
	Vasantha a					04/01/2016			ES_NSO_01040
	Vasantha A					10/11/2016			ES_SelRes_00002
	Vasantha a					11/12/2016			ES_NSO_01328
	Vasantha a					31/01/2017			ES_NSO_01391	
	Prakash V					23/02/2017			ES_NSO_01452		
	Banu M					    22/09/2017			HAL-227
	Dinesh.S					07/02/2018			EBS-971	
	Balasubramaniyam P			01/06/2018			EBS-1362
	Abinaya G					31/01/2019			PEPS-20
	Abinaya G					09/02/2019			PEPS-116
	Banu M                      04/07/2019          MAT-685	
	Abinaya G					20/09/2019			RFBE-14
    Bharath A					24_Sep_2019			PEPS-632
	Gopi V						30/11/2020			EPE-27452 
	Ragha S						05/10/2021			EPE-38229
	Vasantha a					21/07/2022			JPE-1857
	Mugesh s                    21/11/2022          RIMT-1202
	Banurekha B                 17/4/2024           EPE-80436 
    Banurekha B                21/5/2024            EPE-81819 
	Nandhakumar B         17/12/2024               PJRMC-799

*******************************************************************************************************************************************************/

create   procedure sopp_crmn_sp_auth_ml            
	@addressidml   				udd_addressid  ,           
	@atp_ml   					udd_itemstatus  ,            
	@atplevel_hdn   			udd_metadata_code  ,            
	@atpsl_hdn   				udd_metadata_code  ,    
	@buid   					udd_buid  ,            
	@carriercode   				udd_carriercode  ,            
	@ctxt_language   			udd_ctxt_language  ,            
	@ctxt_ouinstance   			udd_ctxt_ouinstance  ,            
	@ctxt_service   			udd_ctxt_service  ,            
	@ctxt_user   				udd_ctxt_user  ,            
	@currency   				udd_currency  , 
	@custdetails   				udd_subtitle  ,            
	@customercode   			udd_customer_id  ,            
	@def_info   				udd_subtitle  ,            
	@desc255   					udd_desc255  ,            
	@ead   						udd_date  ,            
	@extprice   				udd_price  ,            
	@freight_bill_hdn   		udd_metadata_code  ,            
	@freightamount   			udd_amount  ,            
	@frt_currency   			udd_currencycode  ,            
	@frtmethod_hdn   			udd_metadata_code  ,            
   /*code added for HAL-227 starts here*/
 -- @gross_volume               udd_volume ,
    @gross_volume               udd_weight,
    /*code added for HAL-227 ends here*/            
	@gross_weight   			udd_weight , 
	

	@gua_shelflife   			udd_shelflife  ,            
	@guid   					udd_guid  ,            
	@hidden_control1   			udd_hiddencontrol  ,            
	@hidden_control2   			udd_hiddencontrol  ,            
	@item   					udd_itemcode  ,            
	@item_var_desc   			udd_item_desc  ,            
	@itemdetail   				udd_itemcode  ,            
	@line_no   					udd_lineno  ,          
	@loid   					udd_loid  ,            
	@modeflag   				udd_modeflag  ,            
	@netweight   				udd_weight, 
	
	@num_series   				udd_notypeno  ,            
	@ord_det   					udd_document  ,            
	@ord_type_hdn   			udd_metadata_code  ,            
	@order_date   				udd_date  ,            
	@order_no   				udd_documentno  ,            
	@overridewt   				udd_quantity  ,            
	@overridvol   				udd_quantity  ,            
	@price_const   				udd_subtitle  ,            
	@pricelist   				udd_pricelist  ,            
	@pricelistno   				udd_pricelist  ,            
	@priceuomml   				udd_uomcode  ,            
	@pricingdate   				udd_date  ,            
	@processingaction_hdn   	udd_code  ,            
	@processingactionml   		udd_identificationnumber1  ,            
	@promiseddate   			udd_date  ,            
	@promiseddateml   			udd_date  ,            
	@promotype   				udd_type  ,            
	@qty   						udd_quantity  ,            
	@refdoclineno   			udd_lineno  ,            
	@reqddate   				udd_date  ,            
	@reqddateml   				udd_date  ,            
	@resporgunit   				udd_ouinstname  ,            
	@sale_type   				udd_sales  ,            
	@sales_uom   				udd_uomcode  ,            
	@shelf_life_unit_mul   		udd_timeunit  ,            
	@shelf_life_unit_mul_hdn   	udd_metadata_code  ,            
	@shippingpoint_hdn   		udd_ouinstid  ,            
	@shippingpointml   			udd_ouinstname  ,            
	@shippingpointml_hdn   		udd_ouinstid  ,            
	@shiptoaddid   				udd_id  ,            
	@shiptocustomer   			udd_customer_id  ,            
	@shiptocustomercode   		udd_customer_id  ,            
	@shiptoidml   				udd_id  ,            
	@source_doc   				udd_subtitle  ,            
	@sourcedocno   				udd_documentno  ,            
	@sourcedocument_qso_hdn 	udd_metadata_code  ,            
	@timestamp   				udd_timestamp  ,            
	@to_shipdateml   			udd_date  ,            
	@trans_mode   				udd_identificationnumber1  ,            
	@unitfrprice   				udd_price  ,            
	@unititmprice   			udd_price ,            
	@unitprice_ml   			udd_price  ,            
	@variantml   				udd_variant  ,            
	@volume_uom   				udd_uomcode  ,            
	@warehouse   				udd_warehouse  ,            
	@warehousemulti   			udd_warehouse  ,   
	@weight_uom   				udd_uomcode  ,            
	@wfdockey   				udd_wfdockey  ,            
	@wforgunit   				udd_wforgunit  ,            
	@youritemcode_ml   			udd_itemcode  ,            
	@fprowno   					udd_rowno  ,
	/* Code added by Damodharan. R on 04 Oct 2007 for OTS ID NSODMS412AT_000526 starts here */
	@fb_docml               	udd_financebookid,
	@usagecccodeml          	udd_item_usage,
	@itemtype         	udd_itemtype,
	@stockstatus    	udd_status,
	@stockstatus_hdn        	udd_code,
	@shippartial            	udd_flag,
	@shippartial_hdn        	udd_metadata_code,
	@con_forcast            	udd_flag,
	@con_forcast_hdn        	udd_metadata_code,
	@fb_doc                		udd_financebookid,
	@usagecccode           		udd_item_usage,
	/* Code added by Damodharan. R on 04 Oct 2007 for OTS ID NSODMS412AT_000526 ends here */
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/	
	@salespurpose				udd_purpose,
	@salespurpose_hdn			udd_identificationnumber1,
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/
	@remarks_manso           	udd_desc1000,--code added by EBS-971
	@customeritemdesc			udd_desc255, --code added for EPE-27452 
	@m_errorid  				/*int*/udd_errorid output /* For DTS ID:ES_NSO_00203 (Sp Analyser Exception)*/
	/*Code Added for 14H109_WFMCONFIG_00005 begin */
	,@fin_error					udd_int	=	null	output,
	@callingservice				udd_ctxt_service	=	null
	/*Code Added for 14H109_WFMCONFIG_00005 end*/
as            
begin            
	-- nocount should be switched on to prevent phantom rows
	set nocount on

	-- @m_errorid should be 0 to indicate success            
	select @m_errorid =0  
	
	/* Code added by Damodhara. R on 10 Mar 2008 for DTS ID DMS412AT_NSO_00026 starts here */
	declare @quoted_qty_tmp		udd_quantity
	declare @tot_ord_qty_tmp	udd_quantity
	/* Code added by Damodhara. R on 10 Mar 2008 for DTS ID DMS412AT_NSO_00026 ends here */  
	declare	@exp_item_group		udd_metadata_code	--9H123-1_NSO_00042      
	declare @line_no_tmp			udd_lineno	--ES_NSO_00623                
            
	select @addressidml = ltrim(rtrim(upper(@addressidml)))  
	
	
          
	if 	@addressidml = '~#~'             
		select @addressidml = null           

	select @atp_ml = ltrim(rtrim(upper(@atp_ml)))            
	if 	@atp_ml = '~#~'             
		select @atp_ml = null            

	select @atplevel_hdn = ltrim(rtrim(upper(@atplevel_hdn)))            
	if @atplevel_hdn = '~#~'             
		select @atplevel_hdn = null            

	select @atpsl_hdn = ltrim(rtrim(upper(@atpsl_hdn)))            
	if @atpsl_hdn = '~#~'             
		select @atpsl_hdn = null            

	select @buid = ltrim(rtrim(@buid))            
	if @buid = '~#~'             
		select @buid = null 

	select @carriercode = ltrim(rtrim(upper(@carriercode)))            
	if @carriercode = '~#~'             
		select @carriercode = null            

	if @ctxt_language = -915             
		select @ctxt_language = null            

	if @ctxt_ouinstance = -915             
		select @ctxt_ouinstance = null            

	select @ctxt_service = ltrim(rtrim(upper(@ctxt_service)))            
	if @ctxt_service = '~#~'             
		select @ctxt_service = null            

	select @ctxt_user = ltrim(rtrim(upper(@ctxt_user)))            
	if @ctxt_user = '~#~'             
		select @ctxt_user = null            

	select @currency = ltrim(rtrim(upper(@currency)))            
	if @currency = '~#~'             
		select @currency = null            

	select @custdetails = ltrim(rtrim(@custdetails))         
	if @custdetails = '~#~'      
		select @custdetails = null       

	select @customercode = ltrim(rtrim(upper(@customercode)))            
	if @customercode = '~#~'             
		select @customercode = null            

	select @def_info = ltrim(rtrim(@def_info))          
	if @def_info = '~#~'             
		select @def_info = null            

	select @desc255 = ltrim(rtrim(@desc255))            
	if @desc255 = '~#~'             
		select @desc255 = null            

	if @ead = '01/01/1900'             
		select @ead = null            

	if @extprice = -915             
		select @extprice = null            

	select @freight_bill_hdn = ltrim(rtrim(upper(@freight_bill_hdn))) 
	if @freight_bill_hdn = '~#~'          
		select @freight_bill_hdn = null            

	if @freightamount = -915             
		select @freightamount = null           

	select @frt_currency = ltrim(rtrim(upper(@frt_currency)))            
	if @frt_currency = '~#~'        
		select @frt_currency = null            

	select @frtmethod_hdn = ltrim(rtrim(upper(@frtmethod_hdn)))            
	if @frtmethod_hdn = '~#~'             
		select @frtmethod_hdn = null            

	if @gross_volume = -915             
		select @gross_volume = null            

	if @gross_weight = -915             
		select @gross_weight = null            

	if @gua_shelflife = -915             
		select @gua_shelflife = null            

	select @guid = ltrim(rtrim(@guid))  
	if @guid = '~#~'             
		select @guid = null            

	select @hidden_control1 = ltrim(rtrim(upper(@hidden_control1)))            
	if @hidden_control1 = '~#~'             
		select @hidden_control1 = null            

	select @hidden_control2 = ltrim(rtrim(upper(@hidden_control2)))            
	if @hidden_control2 = '~#~'             
		select @hidden_control2 = null            

	select @item = ltrim(rtrim(upper(@item)))            
	if @item = '~#~'             
		select @item = null            

	select @item_var_desc = ltrim(rtrim(@item_var_desc))            
	if @item_var_desc = '~#~'             
		select @item_var_desc = null            

	select @itemdetail = ltrim(rtrim(@itemdetail))            
	if @itemdetail = '~#~'             
		select @itemdetail = null            

	if @line_no = -915             
		select @line_no = null            

	select @loid = ltrim(rtrim(upper(@loid)))            
	if @loid = '~#~'             
		select @loid = null            

	select @modeflag = ltrim(rtrim(@modeflag))            
	if @modeflag = '~#~'             
		select @modeflag = null            

	if @netweight = -915             
		select @netweight = null     

	select @num_series = ltrim(rtrim(@num_series))            
	if @num_series = '~#~'             
		select @num_series = null            

	select @ord_det = ltrim(rtrim(@ord_det))            
	if @ord_det = '~#~'             
		select @ord_det = null            

	select @ord_type_hdn = ltrim(rtrim(upper(@ord_type_hdn)))            
	if @ord_type_hdn = '~#~'             
		select @ord_type_hdn = null            

	if @order_date = '01/01/1900'             
		select @order_date = null            

	select @order_no = ltrim(rtrim(upper(@order_no)))            
	if @order_no = '~#~'             
		select @order_no = null            

	if @overridewt = -915             
		select @overridewt = null            

	if @overridvol = -915             
		select @overridvol = null            

	select @price_const = ltrim(rtrim(@price_const))            
	if @price_const = '~#~'             
		select @price_const = null            

	select @pricelist = ltrim(rtrim(upper(@pricelist)))            
	if @pricelist = '~#~'    
		select @pricelist = null      

	select @pricelistno = ltrim(rtrim(upper(@pricelistno)))            
	if @pricelistno = '~#~'             
		select @pricelistno = null            

	select @priceuomml = ltrim(rtrim(upper(@priceuomml)))            
	if @priceuomml = '~#~'             
		select @priceuomml = null            

	if @pricingdate = '01/01/1900'             
		select @pricingdate = null            

	select @processingaction_hdn = ltrim(rtrim(upper(@processingaction_hdn)))            
	if @processingaction_hdn = '~#~'             
		select @processingaction_hdn = null            

	if @promiseddate = '01/01/1900'             
		select @promiseddate = null            

	if @promiseddateml = '01/01/1900'             
		select @promiseddateml = null            

	select @promotype = ltrim(rtrim(upper(@promotype)))            
	if @promotype = '~#~'             
		select @promotype = null   

	if @qty = -915             
		select @qty = null            

	if @refdoclineno = -915             
		select @refdoclineno = null            

	if @reqddate = '01/01/1900'             
		select @reqddate = null            

	if @reqddateml = '01/01/1900'             
		select @reqddateml = null            

	select @resporgunit = ltrim(rtrim(@resporgunit))            
	if @resporgunit = '~#~'             
		select @resporgunit = null            

	select @sale_type = ltrim(rtrim(upper(@sale_type)))            
	if @sale_type = '~#~'             
		select @sale_type = null            

	select @sales_uom = ltrim(rtrim(upper(@sales_uom)))            
	if @sales_uom = '~#~'     
		select @sales_uom = null            

	select @shelf_life_unit_mul_hdn = ltrim(rtrim(upper(@shelf_life_unit_mul_hdn)))            
	if @shelf_life_unit_mul_hdn = '~#~'             
		select @shelf_life_unit_mul_hdn = null            

	if @shippingpoint_hdn = -915             
		select @shippingpoint_hdn = null            

	if @shippingpointml_hdn = -915             
		select @shippingpointml_hdn = null            

	select @shiptoaddid = ltrim(rtrim(upper(@shiptoaddid)))            
	if @shiptoaddid = '~#~'             
		select @shiptoaddid = null            

	select @shiptocustomer = ltrim(rtrim(upper(@shiptocustomer)))            
	if @shiptocustomer = '~#~'             
		select @shiptocustomer = null            

	select @shiptocustomercode = ltrim(rtrim(upper(@shiptocustomercode)))            
	if @shiptocustomercode = '~#~'        
		select @shiptocustomercode = null            

	select @shiptoidml = ltrim(rtrim(upper(@shiptoidml)))            
	if @shiptoidml = '~#~'             
		select @shiptoidml = null            

	select @source_doc = ltrim(rtrim(upper(@source_doc)))            
	if @source_doc = '~#~'             
		select @source_doc = null            

	select @sourcedocno = ltrim(rtrim(upper(@sourcedocno)))            
	if @sourcedocno = '~#~'             
		select @sourcedocno = null            

	select @sourcedocument_qso_hdn = ltrim(rtrim(upper(@sourcedocument_qso_hdn)))            
	if @sourcedocument_qso_hdn = '~#~'             
		select @sourcedocument_qso_hdn = null            

	if @timestamp = -915             
		select @timestamp = null            

	if @to_shipdateml = '01/01/1900'             
		select @to_shipdateml = null            

	select @trans_mode = ltrim(rtrim(upper(@trans_mode)))       
	if @trans_mode = '~#~'     
		select @trans_mode = null  

	if @unitfrprice = -915             
		select @unitfrprice = null            

	if @unititmprice = -915             
		select @unititmprice = null            

	if @unitprice_ml = -915             
		select @unitprice_ml = null            

	select @variantml = ltrim(rtrim(@variantml))            
	if @variantml = '~#~'             
		select @variantml = null            

	select @volume_uom = ltrim(rtrim(upper(@volume_uom)))            
	if @volume_uom = '~#~'             
		select @volume_uom = null            

	select @warehouse = ltrim(rtrim(upper(@warehouse)))            
	if @warehouse = '~#~'   
		select @warehouse = null            

	select @warehousemulti = ltrim(rtrim(upper(@warehousemulti)))            
	if @warehousemulti = '~#~'             
		select @warehousemulti = null            

	select @weight_uom = ltrim(rtrim(upper(@weight_uom)))            
	if @weight_uom = '~#~'             
		select @weight_uom = null            

	select @wfdockey = ltrim(rtrim(upper(@wfdockey)))          
	if @wfdockey  = '~#~'             
		select @wfdockey  = null            

	select @youritemcode_ml= ltrim(rtrim(upper(@youritemcode_ml)))            
	if @youritemcode_ml  = '~#~'             
		select @youritemcode_ml  = null            

	if @wforgunit = -915             
		select @wforgunit = null

	/* Code added by Damodharan. R on 04 Oct 2007 for OTS ID NSODMS412AT_000526 starts here */
	select @fb_docml                 = ltrim(rtrim(@fb_docml))
	if @fb_docml = '~#~' 
		select @fb_docml = null  
	
	select @usagecccodeml            = ltrim(rtrim(@usagecccodeml))
	if @usagecccodeml = '~#~' 
		select @usagecccodeml = null  
	
	select @itemtype                 = ltrim(rtrim(@itemtype))
	if @itemtype = '~#~' 
		select @itemtype = null  
	
	select @stockstatus  = ltrim(rtrim(@stockstatus))
	if @stockstatus = '~#~' 
		select @stockstatus = null  
	
	select @stockstatus_hdn          = ltrim(rtrim(@stockstatus_hdn))
	if @stockstatus_hdn = '~#~' 
		select @stockstatus_hdn = null  
	
	select @shippartial              = ltrim(rtrim(@shippartial))
	if @shippartial = '~#~' 
		select @shippartial = null  
	
	select @shippartial_hdn          = ltrim(rtrim(@shippartial_hdn))
	if @shippartial_hdn = '~#~' 
		select @shippartial_hdn = null  
	
	select @con_forcast              = ltrim(rtrim(@con_forcast))
	if @con_forcast = '~#~' 
		select @con_forcast = null  
	
	select @con_forcast_hdn          = ltrim(rtrim(@con_forcast_hdn))
	if @con_forcast_hdn = '~#~' 
		select @con_forcast_hdn = null  	
	
	select @fb_doc                 = ltrim(rtrim(@fb_doc))
	if @fb_doc = '~#~' 
		select @fb_doc = null  
	
	select @usagecccode            = ltrim(rtrim(@usagecccode))
	if @usagecccode = '~#~' 
		select @usagecccode = null  
	/* Code added by Damodharan. R on 04 Oct 2007 for OTS ID NSODMS412AT_000526 ends here */
	
	

	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/	
	select @salespurpose  = ltrim(rtrim(@salespurpose))
	if @salespurpose = '~#~'
		select @salespurpose = null 

	select @salespurpose_hdn   = ltrim(rtrim(@salespurpose_hdn))
	if @salespurpose_hdn = '~#~'
		select @salespurpose_hdn = null  
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/
	/*code added for EBS-971 starts here*/ 
	select @remarks_manso   = ltrim(rtrim(@remarks_manso)) 
		if @remarks_manso = '~#~' 
		select @remarks_manso = null
	/*code added for EBS-971 ends here*/ 
	/* Code added for EPE-27452 begins */
	select  @customeritemdesc    = ltrim(rtrim(@customeritemdesc))     
	IF @customeritemdesc = '~#~'   
		Select @customeritemdesc = null    
/* Code added for EPE-27452 ends */
	            
	-- --<^item!> "<%item%>" is not a catch weight item. so, invoicing uom should be null.            
	--   select @m_errorid = 3550002            
	-- --invoicing uom can be either order uom< so_uomml> or  alternate uom <ppaltuom> of the item.            
	--   select @m_errorid = 3550004            
	-- --guaranteed shelf life can be given  to items for which shelf life is specified in inventory.            
	--   select @m_errorid = 3550006            
	-- --shelf life unit can be defined only if the guaranteed shelf life is given.            
	--   select @m_errorid = 3550008            
	-- --pack substitution rule can be given only for items where the pack substitution rule is allowed in the item administration component            
	--   select @m_errorid = 3550010            
	-- --<^item!> "<%item%>" does not exist. enter a valid <^item!>           
	--   select @m_errorid = 3550067            
	-- --<^variantml!> cannot be null for <^item!> "<%item%>"            
	--   select @m_errorid = 3550068            
	-- --<^item!> "<%item%>" is not valid for< ^shippingpointml!>  and <^warehousemulti!>             
	--   select @m_errorid = 3550069            
	-- --stock status        is not nettable. cannot post into disposition            
	--   select @m_errorid = 3550073            
	-- --<^qty!> on line number "<%line_no%>" does not equal the sum of schedule quantities            
	--   select @m_errorid = 3550072            
	-- --<^line_no!> "<%line_no%>" contains same data as <^line_no!> "<%line_no%>"             
	--   select @m_errorid = 3550075            
	-- --<^promiseddateml!> cannot be null. enter a valid <^promiseddateml!>            
	--   select @m_errorid = 320499            
	-- --<^reqddateml!> should not be less than the "<%order_date%>"              
	--   select @m_errorid = 320504            
	-- --<^promiseddateml!> should not be less than the "<%order_date%>"            
	--   select @m_errorid = 320704            
	-- --<^youritemcode_ml!> "<%youritemcode_ml%>" is not valid. enter a valid <^youritemcode_ml!>             
	--   select @m_errorid = 320505            
	-- --<^qty!> = zero             
	--   select @m_errorid = 320507            
	-- --<^sales_uom!> is null    
	--   select @m_errorid = 320509            
	-- --<^shiptoidml!> cannot be null            
	--   select @m_errorid = 320514            
	-- --consignment order cannot ship models            
	--   select @m_errorid = 320061          
	-- --order type "consignment" cannot have  processing action dropship            
	--   select @m_errorid = 320451          
	
	

	/*Code Added by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 Begin*/
	select @guid = replace(replace(@guid,'{',''),'}','')
	/*Code Added by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 End*/
             
	declare	@schedule_type  		udd_metadata_code,            
			@shippartial_flag 		udd_metadata_code,            
			@zero_item_rate  		udd_optioncode,            
			@documentouid  			udd_ctxt_ouinstance,            
			@incoplace     			udd_city,              
			@ref_doc_flag  			udd_metadata_code,                 
			@spcodeml  				udd_code,              
			@reserve_dtml  			udd_date,            
			--@usagecccodeml  		udd_item_usage,     --Commented by Damodharan. R  for OTS ID NSODMS412AT_000526       
			@cust_ou    			udd_ctxt_ouinstance,            
			@item_ou  				udd_ctxt_ouinstance,            
			@wh_ou   				udd_ctxt_ouinstance,              
			@sp_ou   				udd_ctxt_ouinstance,             
			--@sha_ou   				udd_ctxt_ouinstance,      /* For DTS ID:ES_NSO_00203 (Sp Analyser Exception)*/       
			@lo   					udd_loid,    
			@cust_bu  				udd_buid,              
			@lo_item  				udd_loid,            
			@bu_item 				udd_buid,            
			@deliveryarea   		udd_deliveryarea,            
			@preffered_carrier 		udd_carriercode,       
			--@return_val  			int,  /* For DTS ID:ES_NSO_00203 (Sp Analyser Exception)*/          
			@con_forml_hdn  		udd_metadata_code, 
			@m_errorid_tmp  		/*int*/ udd_errorid,/* For DTS ID:ES_NSO_00203 (Sp Analyser Exception)*/
			@item_type  			udd_metadata_code,            
			@line_status  			udd_metadata_code,            
			@price_flag  			udd_metadata_code,           
			--@error_msg_qualifier  	udd_desc255,              /* For DTS ID:ES_NSO_00203 (Sp Analyser Exception)*/    
			@model_config_code 		udd_documentno,            
			@pricingdateml  		udd_date,            
			@model_config_var 		udd_documentno,            
			@referencescheduleno 	udd_lineno,            
			@insert_line 			udd_metadata_code ,            
			@item_wt  				udd_quantity ,         
			@item_volume  			udd_quantity ,            
			@salepurposeml  		udd_identificationnumber1,            
			@price_rule_no  		udd_ruleno,            
			@pricelist_amend_no 	udd_lineno,            
			@stock_qty  			udd_quantity,              
			@companycode  			udd_companycode,             
			@planningtype  			udd_metadata_code,            
			@prom_dflt_flag  		udd_metadata_code,            
			@lineno1  				udd_lineno,                
			@promotionid  			udd_desc40,            
			@receipttype  			udd_desc40,             
			@reasoncode  			udd_desc40,            
			@confactor  			udd_quantity,             
			@sale_account  			udd_accountcode,             
			@sales_chan  			udd_saleschannel,            
			@number_series  		udd_notypeno,            
			@folder   				udd_folder,            
			@cost_center     		udd_maccost,             
			@analysiscode_out 		udd_analysiscode,            
			@subanalysiscode_out 	udd_subanalysiscode,            
			@sch_type_hdn_old  		udd_metadata_code,            
			@total_sch_qty_tmp  	udd_quantity,            
			@item_old     			udd_itemcode,              
			@variant_old     		udd_variant,            
			@qty_old     			udd_quantity            
	declare @feature_flag_yes_no1 	udd_yesnoflag
	declare @feature_flag_yes_no 	udd_yesnoflag	

	/*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 starts here*/
	declare	@analysiscode_tmp		udd_analysiscode,
			@subanalysiscode_tmp	udd_subanalysiscode,
			@fb_doc_tmp				udd_financebookid,
	/*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 ends here*/
	/*Code Added for the DTS id:ES_NSO_00206 starts here*/
	 	   @activity_flag  			udd_metadata_code,
		   @wfstatus_code 			udd_metadata_code,
 		   @workflow_app	  		udd_metadata_code,
		   @wfstatus	   			udd_cm_docstatus
	/*Code Added for the DTS id:ES_NSO_00206 ends here*/

	select	@con_forml_hdn	=	'Y'         
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/	
	select	@salepurposeml	= 	@salespurpose_hdn
	
	/* Code added for ITS ID : ES_NSO_00748	 Begins */
	declare	@refdocexist		udd_metadata_code
	
	select @refdocexist		=	'N'	
	
	/* Code added for ITS ID : ES_NSO_00748	 Ends */
	
	select 	@spcodeml 	= 	sohdr_sales_person_dflt
	/* Code added for ITS ID : ES_NSO_00748 Begins */
			,@refdocexist = case	when	sohdr_ref_doc_type in ('CON','QUO')	then	'Y'
									else	'N'
							end
	/* Code added for ITS ID : ES_NSO_00748 Ends */							
	from	sotmp_order_hdr (nolock)
	where  	sohdr_ou	=	@ctxt_ouinstance
	and		sohdr_guid	=	@guid
	/*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/	
	
	/*Code added by Mukesh B for OTS No QUOTATIONPPS41_000011 (Cumi Personalization) on 08/SEP/2005 -+ Begin*/
	select 	@feature_flag_yes_no1	=	flag_yes_no 
	from 	pps_feature_list 			(nolock)
	/*Code commented & added by Mukesh B for the OTS no COBIPPS41_000044 06/04/2006 Begin*/
	--where upper(feature_id) 		= 	'PPS_FID_0038' and upper(component_name) = 'NSO'
	where 	upper(feature_id) 		= 	'PPS_FID_0038' 
	and 	upper(component_name) 	= 	'NSO'
	/*Code commented & added by Mukesh B for the OTS no COBIPPS41_000044 06/04/2006 End*/
	
	if isnull(@feature_flag_yes_no1,'')	=	''
		select @feature_flag_yes_no1 	= 	'NO'    
	/*Code added by Mukesh B for OTS No QUOTATIONPPS41_000011 (Cumi Personalization) on 08/SEP/2005 -+ End*/
	
	/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 -+ Begin*/
	select 	@feature_flag_yes_no 	= 	flag_yes_no 
	from 	pps_feature_list (nolock)
	/*Code commented & added by Mukesh B for the OTS no COBIPPS41_000044 06/04/2006 Begin*/
	-- where upper(feature_id) 		= 	'PPS_FID_0041' and upper(component_name) = 'NSO'
	where 	upper(feature_id) 		= 	'PPS_FID_0041' 
	and 	upper(component_name) 	= 	'NSO'
	/*Code commented & added by Mukesh B for the OTS no COBIPPS41_000044 06/04/2006 End*/
	
	if isnull(@feature_flag_yes_no,'') 	= 	''
		select @feature_flag_yes_no 	= 	'NO'
	/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 -+ End*/

	/*Code added by Damodharan. R on 10 Dec 2008 for Defect ID ES_NSO_00055 starts here*/
	if 	@frtmethod_hdn = 'FA' and @unitfrprice is not null
	and @unitfrprice <> 0.00 --code added by vasantha a for ES_NSO_01040
	begin
		select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
		--Unit Freight Price should be blank at row no. %d, when Freight Method is "Freight Added".
		exec fin_german_raiserror_sp 'NSO',@ctxt_language,140,@fprowno
		return
	end

	if 	@frtmethod_hdn = 'DP' and @unitfrprice is null
	begin
		select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
		--Unit Freight Price should not be blank at row no. %d, when Freight Method is "Delivered Pricing".
		exec fin_german_raiserror_sp 'NSO',@ctxt_language,141,@fprowno
		return
	end
	/*Code added by Damodharan. R on 10 Dec 2008 for Defect ID ES_NSO_00055 ends here*/

	if rtrim(@frtmethod_hdn) in ('FA','NONE')            
		select @unitfrprice	=	0  
		--Commented for DTS ID: ES_NSO_00112 starts here             
		/*Code modified for ES_NSO_00080 begins here*/
		 /*    if @processingactionml = 'DROP' and @warehousemulti is not null
		     begin
		--	    raiserror('Warehouse code should be blank for Process Action "DROP" at row no.%d',16,1,@fprowno)
			    exec fin_german_raiserror_sp 'NSO',@ctxt_language,125,@fprowno
			    return
		     end*/
		/*Code modified for ES_NSO_00080 ends here*/
		--Commented for DTS ID: ES_NSO_00112 ends here   
    
	/*code commented in id EPE-81819 starts here */
	/*
	/* code starts here EPE-80436 */ 
	--sopp_crmn_ser_sbt1 --for api transaction workflow bypassed even when workflow is enabled
	Select @workflow_app = isnull(@workflow_app,'N')
	if @callingservice <> 'So_api_ser_cr'
	begin
	/* code ends here EPE-80436 */ 
	*/
	/*code commented in id EPE-81819 ends here */
	/*Code Added for the DTS id:ES_NSO_00206 starts here*/
	select 	@wfstatus 		=	isnull(sohdr_workflow_status,'')
	from 	so_order_hdr(nolock)
	where 	sohdr_ou 		=	@ctxt_ouinstance
	and 	sohdr_order_no 	=	@order_no
	
	select @workflow_app = dbo.workflowapp_fet_fn(@ctxt_user,@ctxt_ouinstance,'NSO','NSOSO','CRAU')

	select @wfstatus_code  = isnull(dbo.wf_metacode_fet_fn('NSOSO',@wfstatus),'Fresh')
	
	if rtrim(@ctxt_service) in ('SOPP_CRMN_SER_AUTH','SOPP_CRMN_SER_AUTH1')
	 select @activity_flag = 'AU'   
	
	if @activity_flag = 'AU' and @wfstatus not in('Fresh','As per workflow','') and @workflow_app = 'Y'
	begin
		if @modeflag not in('S','Z')
		begin		
			select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
			--'Document has moved to next level.Hence Cannot make modifications to the Document.'
			exec fin_german_raiserror_sp 'NSO',@ctxt_language,1005
			return
		end
	end	
	--end --EPE-80436 --EPE-81819 
	/*Code Added for the DTS id:ES_NSO_00206 ends here*/
	 
		
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 starts here */
		--if rtrim(@ctxt_service) in ('SOPP_CRMN_SER_SBT','SOPP_CRMN_SER_CRAU')
	if 	rtrim(@ctxt_service) in ('SOPP_CRMN_SER_SBT','SOPP_CRMN_SER_CRAU','SOPP_CRMN_SER_SBT1','SOPP_CRMN_SER_CRAU1')
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 ends here */
	begin            
		if @modeflag = 'D'            
		return            
	end            
	
	
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 starts here */
	--if rtrim(@ctxt_service) in ('SOPP_CRMN_SER_EDT','SOPP_CRMN_SER_AUTH')
	if 	rtrim(@ctxt_service) in ('SOPP_CRMN_SER_EDT','SOPP_CRMN_SER_AUTH','SOPP_CRMN_SER_EDT1','SOPP_CRMN_SER_AUTH1')
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 ends here */
	begin            
		if 	@modeflag = 'D'    
		begin            
			if 	@line_no is not null            
			begin            
				--calling the procedure to delete the detail tables            
				exec 	so_cmn_line_delete @ctxt_language,@ctxt_ouinstance,@ctxt_service, @ctxt_user,@order_no,@line_no,'Y'            
		
				/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 -+ Begin*/
				if 	@feature_flag_yes_no = 'YES'
				begin
					/* Code Modified by Vairamani C for ES_NSO_00213 Starts here */
					if exists
					(
						select	'X'
						from	sotmp_order_hdr (nolock)
						where	sohdr_guid			= 	@guid
					)
					begin
						update 	sotmp_order_hdr with (rowlock) --COBIPPS41_000044
						set 	sohdr_addnl_fld1	= 	'Y'
						where 	sohdr_guid			= 	@guid       
					end

					if exists
					(
						select	'X'
						from	sotmp_order_item_dtl (nolock)
						where 	sodtl_guid 			= 	@guid
						and 	sodtl_line_no		= 	@line_no 
					)
					begin																					
						delete 	from sotmp_order_item_dtl
						where 	sodtl_guid 			= 	@guid
						and 	sodtl_line_no		= 	@line_no     
					end
					
					if exists
					(
						select	'X'
						from	sotmp_item_tcd_dtl (nolock)
						where 	itmtcd_guid 		= 	@guid
						and 	itmtcd_line_no		= 	@line_no
					)
					begin
						delete 	from sotmp_item_tcd_dtl
						where 	itmtcd_guid 		= 	@guid
						and 	itmtcd_line_no		= 	@line_no
					end
					
					if exists
					(
						select	'X'
						from	so_item_tcd_dtl (nolock)
						where 	itmtcd_ou 			= 	@ctxt_ouinstance
						and 	itmtcd_order_no		= 	@order_no
						and 	itmtcd_line_no		= 	@line_no
					)
					begin															
						delete 	from so_item_tcd_dtl
						where 	itmtcd_ou 			= 	@ctxt_ouinstance
						and 	itmtcd_order_no		= 	@order_no
						and 	itmtcd_line_no		= 	@line_no
					end
					
					
					/* Code Modified by Vairamani C for ES_NSO_00213 Ends here */
				end
				/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 -+ End*/
			end            
			/*Code Added for 14H109_WFMCONFIG_00005 begin */
			if	@callingservice	is	null
			begin
			/*Code Added for 14H109_WFMCONFIG_00005 end */

			select @fprowno 'FPROWNO'            
			return            
			
			end	--Code Added for 14H109_WFMCONFIG_00005
			
		end            
	end    
	
	   
	/* Code added by Chockalingam.S for DTS ID:ES_NSO_00203 begins*/          
	-- --  If LINE TCD is not saved in the TCD page then delete the records in the main table  which will automatically 
	-- --  get defaulted as per engine logic and inserted into main table again.
	if @feature_flag_yes_no = 'YES'
	begin
		delete	so_item_tcd_dtl	
		where	itmtcd_ou 		= 	@ctxt_ouinstance
		and 	itmtcd_order_no	= 	@order_no
		and		itmtcd_line_no	= 	@line_no
		--and		itmtcd_deal_id	is null --code commented for JPE-1857
		and		isnull(itmtcd_orgsrc,'')	=	'NSO'--ES_NSO_00748 Sejal	
	end
	--ES_NSO_01452 Code Uncommented starts 
	--code commented by vasantha a for ES_NSO_01391 begins
	
	ELSE
	BEGIN	
		/* Code added for ITS ID :ES_NSO_00748 Ends */	
	--code added by EPE-38229 begins
	if not exists(select 1 from so_api_hdr_tmp with(nolock) where guid =@guid)
	begin
	--code added by EPE-38229 ends
		if exists ( 	select 'x' 
						from	so_order_item_dtl (nolock) 
						where	sodtl_ou		=  	@ctxt_ouinstance 
						and	sodtl_order_no		= 	@order_no 
						and	(isnull(sodtl_tc_upd_flag,'N')= 'N' or isnull(sodtl_disc_upd_flag,'N')= 'N' )
						and	sodtl_line_no		=	@line_no
					)
		begin
			delete	so_item_tcd_dtl	
			where	itmtcd_ou 		= 	@ctxt_ouinstance
			and 	itmtcd_order_no	= 	@order_no
			and		itmtcd_line_no	= 	@line_no
		--	and		itmtcd_deal_id	is null		 --code commented for JPE-1857			
		end
	end--EPE-38229
	END--ES_NSO_00748
	
	--code commented by vasantha a for ES_NSO_01391 ends
	--ES_NSO_01452 Code Uncommented Ends
	 /* Code added by Chockalingam.S for DTS ID:ES_NSO_00203 begins*/          

	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 starts here */
	--if rtrim(@ctxt_service) in ('SOPP_CRMN_SER_SBT','SOPP_CRMN_SER_CRAU') or @line_no is null
	if 	rtrim(@ctxt_service) in ('SOPP_CRMN_SER_SBT','SOPP_CRMN_SER_CRAU','SOPP_CRMN_SER_SBT1','SOPP_CRMN_SER_CRAU1') or @line_no is null
		/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 ends here */
 	begin 
             
				select  @preffered_carrier  =  	sohdr_prefered_carrier,      
						@companycode 		= 	sohdr_company_code,            
						@currency  			= 	sohdr_currency ,            
						@documentouid  		= 	sohdr_ref_doc_ou,            
						@shippartial_flag 	= 	rtrim(sohdr_ship_partial_dflt),            
						@zero_item_rate  	= 	rtrim(sohdr_zero_item_rate),            
						@ref_doc_flag     	= 	sohdr_ref_doc_flag,            
						@sales_chan			=	sohdr_sales_channel /* Added for DTS ID:ES_NSO_00186*/
				from 	sotmp_order_hdr 		(nolock)             
				where 	sohdr_ou  			= 	@ctxt_ouinstance            
				and 	sohdr_guid  		= 	@guid
						
				select  @schedule_type 		= 	'SI',            
						@ref_doc_flag 		= 	'N',            
						@insert_line 		= 	'Y'  
				
				if 	@shippartial_flag is null          
					begin            
						select 	@shippartial_flag	=	rtrim(sohdr_ship_partial_dflt)            
						from 	so_order_hdr 			(nolock)      
						where 	sohdr_ou  			= 	@ctxt_ouinstance            
						and 	sohdr_order_no  	= 	@order_no             
					end            
	end            
	else            
	begin            
				select  @preffered_carrier	=  	sohdr_prefered_carrier,            
						@companycode  		= 	sohdr_company_code,            
						@currency  			= 	sohdr_currency ,            
						@documentouid  		= 	sohdr_ref_doc_ou,            
						@shippartial_flag 	= 	rtrim(sohdr_ship_partial_dflt),            
						@zero_item_rate  	= 	rtrim(sohdr_zero_item_rate),            
						@ref_doc_flag     	= 	sohdr_ref_doc_flag  ,          
						@sales_chan			=	sohdr_sales_channel /* Added for DTS ID:ES_NSO_00186*/
				from 	so_order_hdr 			(nolock)             
				where 	sohdr_ou  			= 	@ctxt_ouinstance            
				and 	sohdr_order_no  	= 	@order_no             
			--code modified by Anitha N for PPSCMQSOPPS41_000129 on 31/10/2006 begins     
	end              
	--code modified by Anitha N for PPSCMQSOPPS41_000129 on 31/10/2006 ends
	if 	@line_no is not null   
	begin
		--code modified by Anitha N for PPSCMQSOPPS41_000129 on 31/10/2006 begins
		if	(@modeflag in ('X', 'I'))
		begin
					select 	@line_no_tmp 		= 	@line_no  --ES_NSO_00623
					select 	@line_no 		= 	null            
					select  @schedule_type 	= 	'SI',            
							@ref_doc_flag 	= 	'N',            
							@insert_line 	= 	'Y'  
						
		/* Code modified for ITS Id : 14H109_NSO_00002 begins */
					if	@feature_flag_yes_no	=	'YES'		
					begin
							--raiserror('Order Details are modified. Please use "Compute Price & Date" button to fetch the system price',16,1)
							select @m_errorid = 3752529
							return					
					end
		/* Code modified for ITS Id : 14H109_NSO_00002 ends */
		end	
		else
		begin
			--code modified by Anitha N for PPSCMQSOPPS41_000129 on 31/10/2006 ends
			if exists (	select 	'X'            
						from 	so_order_item_dtl (nolock)             
						where 	sodtl_ou 		= 	@ctxt_ouinstance            
						and 	sodtl_order_no 	= 	rtrim(@order_no)             
						and 	sodtl_line_no 	= 	@line_no	
					)            
			begin            
				select 	@line_no 				= 	@line_no            
				select 	@refdoclineno  			= 	sodtl_ref_doc_line_no,            
						@referencescheduleno 	= 	sodtl_ref_doc_sch_no,            
						@schedule_type  		=	rtrim(sodtl_sch_type),            
						@incoplace  			= 	rtrim(sodtl_inco_place),            
						@spcodeml  				= 	rtrim(sodtl_sales_person)
				/* Code commented by Damodharan. R on 12 Apr 2008 for DTS ID ES_NSO_00018 starts here */            
				--@usagecccodeml  	= 	rtrim(sodtl_usage_for_cc),            
				/* Code commented by Damodharan. R on 12 Apr 2008 for DTS ID ES_NSO_00018 ends here */            
				-- @salepurposeml  	= 	rtrim(sodtl_sale_purpose)  --commented for DTS ID: DMS412AT_NSO_00030          
				from 	so_order_item_dtl			(nolock)             
				where 	sodtl_ou  				= 	@ctxt_ouinstance            
				and 	sodtl_order_no  		= 	@order_no 
				and 	sodtl_line_no  			= 	@line_no
			end            
			else            
			begin           
				select  @line_no_tmp = @line_no --ES_NSO_00623 
				select 	@line_no 	= 	null            
				select  @schedule_type 	= 	'SI',            
						@ref_doc_flag 	= 	'N',            
						@insert_line 	= 	'Y'            
			end            
		end
	end

	--code added for ES_NSO_00609 starts
	if exists (select '1' from PPS_FEATURE_LIST (nolock)
				where	FEATURE_ID	=	'PPS_TRIG_FID_004'
				and		FLAG_YES_NO	=	'YES')
	begin
		if	@reqddateml	is	null and @reqddate is null
			select	@reqddateml	=	@order_date
			
		if	@promiseddateml	is	null and @promiseddate is null
			select	@promiseddateml	=	@order_date
	end
	--code added for ES_NSO_00609 ends  
	
	
     		   
	exec so_cmn_sp_ml_val	1,				@ctxt_language,				@ctxt_ouinstance,			@ctxt_service,            
				@ctxt_user,  				@customercode,  			@guid,   					@line_no,       
				 --code modified by vasantha a  for  ES_SelRes_00002     begins
				--@order_no,  				null,   					@fprowno,            		@order_date,  
				@order_no,  				@sales_chan,   					@fprowno,            		@order_date,
				--code modified by vasantha a  for  ES_SelRes_00002     ends
				@pricelistno,  				@pricingdate,  				null,            			@promiseddate,  
				@qty,   					@reqddate,  				@ord_type_hdn, 
				/* Code modified by Damodharan. R on 06 Sep 2007 for OTS ID NSODMS412AT_000526 starts here */           
				--@schedule_type,  			@shiptocustomer, 			@shippartial_flag, 			@shippingpoint_hdn,            
				--@shiptoaddid,				null,   					'ACC',       
				@schedule_type,  			@shiptocustomer, 			@shippartial_hdn, 			@shippingpoint_hdn,                 
				@shiptoaddid,  				null,   					@stockstatus_hdn,            
				--@trans_mode,  			null,   					@warehouse,  				@youritemcode_ml,            
				@trans_mode, 				@usagecccode,   			@fb_doc,					@warehouse,  
				@youritemcode_ml,       	@zero_item_rate, 			@currency,  				@carriercode,  
				@sourcedocno,           	@documentouid,  			@sourcedocument_qso_hdn,	@ref_doc_flag , 
				@refdoclineno,      		@unitfrprice,  				@priceuomml,  				@gua_shelflife,  
				@shelf_life_unit_mul_hdn,   @item out,  				@variantml out,  			@sales_uom out,  
				@unititmprice out, 			@reserve_dtml out,      	@to_shipdateml out, 		@pricingdateml out, 
				@processingaction_hdn out, 	@promiseddateml out,        @reqddateml out, 			@shiptocustomercode out,
				@shippartial_flag out, 		@shippingpointml_hdn out,            
				--@shiptoidml out, 			@spcodeml out,  			@trans_mode out, 			@usagecccodeml out,            
				@shiptoidml out, 			@spcodeml out,  			@trans_mode out, 			@usagecccodeml out, 
				@fb_docml out,            	@warehousemulti out, 		@incoplace out,  			@lo out,  
				@cust_bu out,            	@cust_ou out,  				@item_ou out,  				@wh_ou out,  
				@sp_ou out,            		@lo_item out,  				@bu_item out,  				@item_type out,  
				@item_wt out,            	@item_volume out, 			@model_config_code out, 	@model_config_var out, 
				@stock_qty out,            	@price_flag out, 			@pricelist_amend_no out,	@price_rule_no out, 
				@deliveryarea out,            
				--@line_status out, 		@planningtype out, 			@confactor out,  			@con_forml_hdn out,            
				@line_status out, 			@planningtype out, 			@confactor out,  			@con_forcast_hdn out,  
				/* Code modified by Damodharan. R on 06 Sep 2007 for OTS ID NSODMS412AT_000526 ends here */                     
				@m_errorid_tmp out 
		/* Code Added for ES_NSO_00502 begin */ 		
			if isnull(@deliveryarea,'')=''
				select @deliveryarea = null           
		/* Code Added for ES_NSO_00502 end */ 
		
			
	 	
	/*Code added by Divyalekaa for DMS412AT_STKSTATUS_00003 starts here*/
	if	@m_errorid_tmp = 2400005
	begin
		select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
		exec fin_german_raiserror_sp 'NSO',@ctxt_language,120
		return 
	end 
	/*Code added by Divyalekaa for DMS412AT_STKSTATUS_00003 ends here*/	

	/*Code added by Damodharan. R on 28 Apr 2009 for Defect ID ES_NSO_00211 starts here*/
	if	@m_errorid_tmp = 3550379
	begin
		select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
		--UOM conversion does not exist between Sales UOM and Pricing UOM in line no. %a
		exec fin_german_raiserror_sp 'NSO',@ctxt_language,1037,@fprowno
		return 
	end

	if	@m_errorid_tmp = 3550380
	begin
		select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
		--UOM conversion does not exist between Sales UOM and Stock UOM in line no. %a
		exec fin_german_raiserror_sp 'NSO',@ctxt_language,1038,@fprowno
		return 
	end
	/*Code added by Damodharan. R on 28 Apr 2009 for Defect ID ES_NSO_00211 ends here*/

	if 	@m_errorid_tmp <> 0    
	begin            
		select @m_errorid = @m_errorid_tmp            
		return             
	end  
	

	
	/*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 starts here*/
	if 	rtrim(@ctxt_service) in ('SOPP_CRMN_SER_AUTH','SOPP_CRMN_SER_AUTH1','SOPP_CRMN_SER_CRAU','SOPP_CRMN_SER_CRAU1') and @item_type = 'S' and (@fb_docml is null or @fb_docml = '')
	begin
		select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
		--raiserror('Finance book is mandatory for service item at row no. %d',16,1,@fprowno)
		exec fin_german_raiserror_sp 'NSO',@ctxt_language,106,@fprowno		
		return
	end
	/*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 ends here*/

	/* Code added by Damodhara. R on 10 Mar 2008 for DTS ID DMS412AT_NSO_00026 starts here */
	--code added and commented  for RIMT-1202 begins
	if 	rtrim(@ctxt_service) in ('SOPP_CRMN_SER_AUTH','SOPP_CRMN_SER_AUTH1','SOPP_CRMN_SER_CRAU','SOPP_CRMN_SER_CRAU1','sopp_ammn_ser_sbt1','sopp_ammn_ser_auth1','sopp_crmn_ser_sbt1','sopp_crmn_ser_edt1')
	
	--if 	rtrim(@ctxt_service) in ('SOPP_CRMN_SER_AUTH','SOPP_CRMN_SER_AUTH1')
	--code added and commented  for RIMT-1202 ends
	begin
		if 	@sourcedocument_qso_hdn	=	'QUO'
		begin
			select	@quoted_qty_tmp		=	qdtl_quantityqtd,
					@tot_ord_qty_tmp	=	qdtl_orderqty + @qty
			from	qtn_quotation_dtl_vw 	(nolock)
			where	qdtl_quotnumber		=	@sourcedocno
			and		qdtl_ouinstance		=	@documentouid
			and		qdtl_lineno			=	@refdoclineno
					
			if 	@tot_ord_qty_tmp > @quoted_qty_tmp
			begin
				select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
				--raiserror('Total Ordered quantity exceeds Quoted quantity in line no. %d',16,1,@refdoclineno)
				exec fin_german_raiserror_sp 'NSO',@ctxt_language,82,@refdoclineno
				return
			end
		end
	end
	/* Code added by Damodhara. R on 10 Mar 2008 for DTS ID DMS412AT_NSO_00026 ends here */ 

	/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 -+ Begin*/                 
	if 	@feature_flag_yes_no = 'YES'
	begin              
		--CUMI Personalization : Price Override EDK : Modified by Robbins starts
		declare @price_override			udd_chkflag,
				@disc_override			udd_chkflag,
				@tc_override			udd_chkflag,
				@sodtl_item_code		udd_itemcode,
				@sodtl_item_variant		udd_variant,
				@sodtl_cust_item_code	udd_itemcode,
				@sodtl_req_qty			udd_quantity,
				@sodtl_unit_price		udd_rate,
				@sodtl_pricelist_no		udd_prilistcode,
				@sodtl_price_uom		udd_uomcode,
				@sodtl_req_date			udd_date,
				@sodtl_prm_date			udd_date,
				@sodtl_to_ship_date		udd_date,
				@sodtl_ship_to_cust		udd_customer_id,
				@sodtl_ship_to_id		udd_id,
				@sodtl_ship_point		udd_ctxt_ouinstance,
				@sodtl_ship_wh_no		udd_warehouse,
				@hdr_change				udd_chkflag,
				@price_engine_flag		udd_chkflag,
				@tcd_engine_flag		udd_chkflag
	
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
		--select	@price_override		= 	isnull(@price_override,'N'),
		--		@disc_override		= 	isnull(@disc_override,'N'),
		--		@tc_override		= 	isnull(@tc_override,'N')
		select	@price_override		= 	'Y',
				@disc_override		= 	'Y',
				@tc_override		= 	'Y'
		/* Code modified for ITS Id : ES_NSO_00748 ends */
		
		/* Code added for ITS Id : ES_NSO_00747 begins */
		if exists (	select	'x'
					from 	sotmp_order_item_dtl 	(nolock)
					where 	sodtl_guid			= 	@guid
					and 	sodtl_line_no		= 	isnull(@line_no,@line_no_tmp)
				  )
		begin				  
		/* Code added for ITS Id : ES_NSO_00747 ends */
				select 	@sodtl_item_code	=	sodtl_item_code,
						@sodtl_item_variant	=	sodtl_item_variant,
						@sodtl_cust_item_code	=	sodtl_cust_item_code,
						@sodtl_req_qty		=	sodtl_req_qty,
						@sodtl_unit_price	=	sodtl_unit_price,
						@sodtl_pricelist_no	=	sodtl_pricelist_no,
						@sodtl_price_uom	=	sodtl_price_uom,
						@sodtl_req_date		=	sodtl_req_date_dflt,
						@sodtl_prm_date		=	sodtl_prm_date_dflt,
						@sodtl_to_ship_date	=	sodtl_to_ship_date_dflt,
						@sodtl_ship_to_cust	=	sodtl_ship_to_cust_dflt,
						@sodtl_ship_to_id	=	sodtl_ship_to_id_dflt,
						@sodtl_ship_point	=	sodtl_ship_point_dflt,
						@sodtl_ship_wh_no	=	sodtl_ship_wh_no_dflt
				from 	sotmp_order_item_dtl 	(nolock)
				where 	sodtl_guid			= 	@guid
				--Code modified for ES_NSO_00623 begins here
				--and 	sodtl_line_no		= 	@line_no 
		/* Code modified for ITS Id : 14H109_NSO_00002 begins */
				--and 	sodtl_line_no		= 	case when @feature_flag_yes_no = 'Yes' then isnull(@line_no,@line_no_tmp) else @line_no end
				and 	sodtl_line_no		= 	isnull(@line_no,@line_no_tmp)
		/* Code modfied for ITS Id : 14H109_NSO_00002 ends */
				--Code modified for ES_NSO_00623  ends here
		/* Code added for ITS Id : ES_NSO_00747 begins */		
		end
		else
		begin
				select 	@sodtl_item_code	=	sodtl_item_code,
						@sodtl_item_variant	=	sodtl_item_variant,
						@sodtl_cust_item_code	=	sodtl_cust_item_code,
						@sodtl_req_qty		=	sodtl_req_qty,
						@sodtl_unit_price	=	sodtl_unit_price,
						@sodtl_pricelist_no	=	sodtl_pricelist_no,
						@sodtl_price_uom	=	sodtl_price_uom,
						@sodtl_req_date		=	sodtl_req_date_dflt,
						@sodtl_prm_date		=	sodtl_prm_date_dflt,
						@sodtl_to_ship_date	=	sodtl_to_ship_date_dflt,
						@sodtl_ship_to_cust	=	sodtl_ship_to_cust_dflt,
						@sodtl_ship_to_id	=	sodtl_ship_to_id_dflt,
						@sodtl_ship_point	=	sodtl_ship_point_dflt,
						@sodtl_ship_wh_no	=	sodtl_ship_wh_no_dflt
				from 	so_order_item_dtl 	(nolock)
				where 	sodtl_order_no		=	@order_no
				and		sodtl_line_no		=	@line_no
				and		sodtl_ou			=	@ctxt_ouinstance
		end
		/* Code added for ITS Id : ES_NSO_00747 ends */
		
		select 	@hdr_change 		= 	rtrim(sohdr_addnl_fld1)
		from 	sotmp_order_hdr 		(nolock)
		where 	sohdr_guid			= 	@guid
		
	
		/* Code added for ITS Id : ES_NSO_00748 begins */
		if 	isnull(@sodtl_unit_price,0) <> @unititmprice or isnull(@sodtl_req_qty,0) <> @qty or isnull(@sodtl_pricelist_no,'') <> isnull(@pricelistno,'') or	
			isnull(@sodtl_price_uom,'') <> isnull(@priceuomml,'') or isnull(@sodtl_ship_to_cust,'') <> isnull(@shiptocustomercode,'') or	
			isnull(@sodtl_ship_to_id,'') <> isnull(@shiptoidml,'') or isnull(@sodtl_ship_point,0) <> isnull(@shippingpointml_hdn,'') or	
			/* Code commented and added for ITS ID : ES_NSO_00789 Begins */
			--isnull(@sodtl_ship_wh_no,'') <> isnull(@warehousemulti,'') or @hdr_change = 'Y' or 
			((isnull(@sodtl_ship_wh_no,'') <> isnull(@warehousemulti,'')and @ProcessingAction_hdn <> 'DROP') )or @hdr_change = 'Y' or 			
			/* Code commented and added for ITS ID : ES_NSO_00789 Ends */			
			isnull(@sodtl_item_code,'') <> @item or isnull(@sodtl_item_variant,'') <> isnull(@variantml,'') --sejal
		begin
			--Order Details are modified. Please use "Compute Price & Date" button to fetch the system price
			select @m_errorid = 3752529
			return
		end							
		/* Code added for ITS Id : ES_NSO_00748 ends */	
	
		if 	@unititmprice is null or @unititmprice = 0.0
		begin
			if @price_override	= 	'N'
			begin
				/* Starts - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
		        --raiserror('Price is not computed. Please use "Compute Price & Date" button to fetch the system price',16,1)
		        select @m_errorid = 3752528
				/* Ends - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
				return
			end
			else if @price_override	=	'Y'
			begin 
				select	@price_engine_flag 	= 	'Y',
						@tcd_engine_flag 	= 	'Y'
			end
		end
		else if @unititmprice is not null
		begin				
			/*select	isnull(@sodtl_unit_price,0) , @unititmprice , isnull(@sodtl_req_qty,0) , @qty , isnull(@sodtl_pricelist_no,'') , isnull(@pricelistno,'')  
			select	isnull(@sodtl_price_uom,'') , isnull(@priceuomml,'') , isnull(@sodtl_ship_to_cust,'') , isnull(@shiptocustomercode,'')  
			select	isnull(@sodtl_ship_to_id,'') , isnull(@shiptoidml,'') , isnull(@sodtl_ship_point,0) , isnull(@shippingpointml_hdn,'')  
			select	isnull(@sodtl_ship_wh_no,'') , isnull(@warehousemulti,'') , isnull(@sodtl_item_code,'') , @item  
			select	isnull(@sodtl_item_variant,'') , isnull(@variantml,'') , isnull(@sodtl_cust_item_code,'') , isnull(@youritemcode_ml,'')  
			select @hdr_change	*/
	
			if 	isnull(@sodtl_unit_price,0) <> @unititmprice or isnull(@sodtl_req_qty,0) <> @qty or isnull(@sodtl_pricelist_no,'') <> isnull(@pricelistno,'') or 
				isnull(@sodtl_price_uom,'') <> isnull(@priceuomml,'') or isnull(@sodtl_ship_to_cust,'') <> isnull(@shiptocustomercode,'') or 
				isnull(@sodtl_ship_to_id,'') <> isnull(@shiptoidml,'') or isnull(@sodtl_ship_point,0) <> isnull(@shippingpointml_hdn,'') or 
				/* Code commented and added for ITS ID : ES_NSO_00789 Begins */				
				--isnull(@sodtl_ship_wh_no,'') <> isnull(@warehousemulti,'') or isnull(@sodtl_item_code,'') <> @item or 
				(isnull(@sodtl_ship_wh_no,'') <> isnull(@warehousemulti,'')and @ProcessingAction_hdn <> 'DROP') or isnull(@sodtl_item_code,'') <> @item or 				
				/* Code commented and added for ITS ID : ES_NSO_00789 Ends */
				isnull(@sodtl_item_variant,'') <> isnull(@variantml,'') or isnull(@sodtl_cust_item_code,'') <> isnull(@youritemcode_ml,'') or 
				--isnull(@sodtl_to_ship_date,'01/01/1900') <> @to_shipdateml 
				@hdr_change = 'Y'
			begin		
				/*Code added by Mukesh B for OTS No QUOTATIONPPS41_000011 (Cumi Personalization) on 08/SEP/2005 -+ Begin*/
				if 	@feature_flag_yes_no1 = 'YES'
					--Code added by Robbins QUOTATIONCUMI_000006 begins
					if 	@sourcedocument_qso_hdn = 'QUO' and @sourcedocno is not null
					begin
						if 	@hdr_change = 'Y'
						begin	
							/* Starts - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
							--raiserror('Order Details are modified. Please use "Compute Price & Date" button to fetch the system price',16,1)
							select @m_errorid = 3752529
							/* Ends - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
							return
						end
					end
				/*Code added by Mukesh B for OTS No QUOTATIONPPS41_000011 (Cumi Personalization) on 08/SEP/2005 -+ End*/
	
				if 	@price_override = 'N'
				begin
					/* Starts - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
					--raiserror('Order Details are modified. Please use "Compute Price & Date" button to fetch the system price',16,1)
					select @m_errorid = 3752529
					/* Ends - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
					return
				end
				/*Code added by Mukesh B for OTS No QUOTATIONPPS41_000011 (Cumi Personalization) on 08/SEP/2005 -+ Begin*/
				/* Code modified for ITS Id : ES_NSO_00748 begins */
				--else if @price_override = 'Y' and @feature_flag_yes_no1 = 'YES'
				else if @price_override = 'Y'
				/* Code modified for ITS Id : ES_NSO_00748 ends */
				begin 
					--Code modified by Robbins on 23rd Aug
					/*Code commented and merged by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 Begin*/				
					--if 	(isnull(@sodtl_item_code,'') <> @item or isnull(@sodtl_item_variant,'') <> @variantml)
	 				--begin 
					/*Code merged by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 End*/
					select	@price_engine_flag 	= 'Y',
							@tcd_engine_flag 	= 'Y',
							@unititmprice		= null,
							@pricelistno		= NULL
						/*Code commented and merged by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 Begin*/
					--end
					--else if isnull(@sodtl_unit_price,0) <> @unititmprice and isnull(@sodtl_pricelist_no,'') = isnull(@pricelistno,'')
					if 	(isnull(@sodtl_unit_price,0) = @unititmprice and isnull(@sodtl_req_qty,0) = @qty or isnull(@sodtl_pricelist_no,'') = isnull(@pricelistno,'') and 
						isnull(@sodtl_price_uom,'') = isnull(@priceuomml,'') and isnull(@sodtl_ship_to_cust,'') = isnull(@shiptocustomercode,'') and 
						isnull(@sodtl_ship_to_id,'') = isnull(@shiptoidml,'') and isnull(@sodtl_ship_point,0) = isnull(@shippingpointml_hdn,'') and 
						isnull(@sodtl_ship_wh_no,'') = isnull(@warehousemulti,'') and @hdr_change = 'Y') and 
				   		(isnull(@sodtl_unit_price,0) <> @unititmprice and isnull(@sodtl_pricelist_no,'') = isnull(@pricelistno,''))
					/*Code commented and merged by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 End*/	
					begin 
						select	@price_engine_flag 	= 'N',
								@tcd_engine_flag 	= 'Y',
								@pricelistno		= null
					end
					--Code modified by Robbins on 23rd Aug
					/*Code commented and merged by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 Begin*/		
					--end
					--/*Code added by Mukesh B for OTS No QUOTATIONPPS41_000011 (Cumi Personalization) on 08/SEP/2005 -+ End*/
					--else if @price_override = 'Y' and @feature_flag_yes_no1 = 'NO'
					if 	(isnull(@sodtl_unit_price,0) = @unititmprice and isnull(@sodtl_req_qty,0) = @qty or isnull(@sodtl_pricelist_no,'') = isnull(@pricelistno,'') and 
						isnull(@sodtl_price_uom,'') = isnull(@priceuomml,'') and isnull(@sodtl_ship_to_cust,'') = isnull(@shiptocustomercode,'') and 
						isnull(@sodtl_ship_to_id,'') = isnull(@shiptoidml,'') and isnull(@sodtl_ship_point,0) = isnull(@shippingpointml_hdn,'') and 
						isnull(@sodtl_ship_wh_no,'') = isnull(@warehousemulti,'') and @hdr_change = 'Y') and 
			   			(isnull(@sodtl_unit_price,0) <> @unititmprice and isnull(@sodtl_pricelist_no,'') <> isnull(@pricelistno,''))
					/*Code commented and merged by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 End*/
					begin
						/*Code commented and merged by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 Begin*/	
						-- 					if 	(isnull(@sodtl_unit_price,0) <> @unititmprice or isnull(@sodtl_req_qty,0) <> @qty or isnull(@sodtl_pricelist_no,'') <> isnull(@pricelistno,'') or 
						-- 					isnull(@sodtl_price_uom,'') <> isnull(@priceuomml,'') or isnull(@sodtl_ship_to_cust,'') <> isnull(@shiptocustomercode,'') or 
						-- 					isnull(@sodtl_ship_to_id,'') <> isnull(@shiptoidml,'') or isnull(@sodtl_ship_point,0) <> isnull(@shippingpointml_hdn,'') or 
						-- 					isnull(@sodtl_ship_wh_no,'') <> isnull(@warehousemulti,'') or isnull(@sodtl_item_code,'') <> @item or 
						-- 					@hdr_change = 'Y') and 
						-- 				   	(isnull(@sodtl_item_code,'') <> @item or isnull(@sodtl_item_variant,'') <> @variantml)
						-- 					begin 
						--						select	@price_engine_flag 	= 'Y',
						select	@price_engine_flag 	= 'N',	
						/*Code commented and merged by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 End*/		
								@tcd_engine_flag 	= 'Y',
								@unititmprice		= null,
								@pricelistno		= null
						/*Code commented and merged by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 Begin*/
						--					end
						-- 					else
						-- 					begin
						-- 						select	@price_engine_flag 	= 'N',
						-- 							@tcd_engine_flag 	= 'Y'
						/*Code commented and merged by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 End*/
					end
				end
			end
			else
			begin
				if 	@price_override = 'N'
				begin
					select	@price_engine_flag 	= 'N',
							@tcd_engine_flag 	= 'N'
				end
				else if @price_override = 'Y'
				begin
				/* Code modified for ITS Id : ES_NSO_00748 begins */
					--select	@price_engine_flag 	= 'N',
					--		@tcd_engine_flag 	= 'N'
					select	@price_engine_flag 	= 'Y',
							@tcd_engine_flag 	= 'y'
				/* Code modified for ITS Id : ES_NSO_00748 ends */
				end	
			end
		end
	      
		/* Code Modified by Vairamani C for ES_NSO_00213 Starts here */
		if exists
		(
			select	'X'
			from	sotmp_order_item_dtl (nolock)
			where	sodtl_guid 		= 	@guid
			and 	sodtl_line_no	= 	@line_no
		)
		begin
			delete 	
			from 	sotmp_order_item_dtl
			where 	sodtl_guid 		= 	@guid
			and 	sodtl_line_no	= 	@line_no
		end
		/* Code Modified by Vairamani C for ES_NSO_00213 Ends here */
	
		/* Code commented for ITS ID : ES_NSO_00748 Begins */
		--if 	@tcd_engine_flag = 'Y'
		--begin	
		--	/*delete from sotmp_item_tcd_dtl
		--	where itmtcd_guid 	= @guid
		--	and itmtcd_line_no	= @line_no*/
		--	/* Code Modified by Vairamani C for ES_NSO_00213 Starts here */
		--	if exists
		--	(
		--		select	'X'
		--		from	so_item_tcd_dtl (nolock)	
		--		where 	itmtcd_ou 		= @ctxt_ouinstance
		--		and 	itmtcd_order_no	= @order_no
		--		and 	itmtcd_line_no	= @line_no	
		--	)
		--	begin		
		--		delete 
		--		from 	so_item_tcd_dtl
		--		where 	itmtcd_ou 		= @ctxt_ouinstance
		--		and 	itmtcd_order_no	= @order_no
		--		and 	itmtcd_line_no	= @line_no
		--	end
		--		/* Code Modified by Vairamani C for ES_NSO_00213 Ends here */
		--end
		/* Code commented for ITS ID : ES_NSO_00748 Ends */
		--CUMI Personalization : Price Override EDK : Modified by Robbins ends      
	end
	/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 -+ End*/
	
	--if @priceuomml is null/*modified for the TC fix*/    
	if isnull(@priceuomml,'') = ''       
		select @priceuomml = @sales_uom            
 
	if 	rtrim(@ctxt_service) in ('SOPP_CRMN_SER_AUTH' ,'SOPP_CRMN_SER_AUTH1','SOPP_CRMN_SER_CRAU','SOPP_CRMN_SER_CRAU1')
	begin    

		/*Code added for 9H123-1_NSO_00042 begins here*/
		select	@exp_item_group  = isnull(sosys_parameter_value,'N')
		from	so_system_param_dtl	(nolock)
		where	sosys_ou		=	@ctxt_ouinstance
		and		sosys_parameter_code	=	'EXP_ITEM_GROUP'

		   
--		if @sale_type  = 'EXP'  
		if @sale_type  = 'EXP'	and	@exp_item_group	=	'Y'  	
		/*Code added for 9H123-1_NSO_00042 ends here*/		 
		begin
			if exists (	select 	'X' 
						from 	item_group_master_vw(nolock) 
						where 	lo_id 		= 	@lo
						AND 	group_type 	= 	'SALES'
						AND 	category 	= 	'S'
						AND 	usage 		= 	'SL'
						and 	item_code 	=   	@item
					)
					--and group_code 	= 	'EXPORTS') --MCL_PPSCMQSO_BASEFIXES_000027	
			begin
				select 	@ctxt_ouinstance = @ctxt_ouinstance
			end 
			else
			begin
				select	@fin_error	=	1	--Code Added for 14H109_WFMCONFIG_00005 
				/* Code modified by Damodharan. R on 08 Apr 2008 for DTS ID DMS412AT_NSO_00035 starts here */
				--exec fin_german_raiserror_sp 'NSO',@ctxt_language,4,@fprowno  --MCL_PPSCMQSO_BASEFIXES_000027
				exec fin_german_raiserror_sp 'NSO',@ctxt_language,59
				/* Code modified by Damodharan. R on 08 Apr 2008 for DTS ID DMS412AT_NSO_00035 ends here */
				return
			end
		end
	end	
   
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 starts here */
	--if rtrim(@ctxt_service) in ('SOPP_CRMN_SER_EDT','SOPP_CRMN_SER_AUTH')
	if rtrim(@ctxt_service) in ('SOPP_CRMN_SER_EDT','SOPP_CRMN_SER_AUTH','SOPP_CRMN_SER_EDT1','SOPP_CRMN_SER_AUTH1')
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000507 ends here */
	begin   
		declare @tcd_cal_flag  	udd_metadata_code,            
				@update_flag   	udd_metadata_code,            
				@tcd_dflt_flag  udd_metadata_code          
            
		select 	@tcd_cal_flag  	= 	'Y', 
				@update_flag   	= 	'N',            
				@tcd_dflt_flag 	= 	'N',            
				@prom_dflt_flag = 	'Y',  --'N',--code modified for PEPS-20          
				@insert_line 	= 	'Y'             
		
		if 	( @schedule_type = 'SI' )            
		begin            
			select @line_status = 'FR' 
		end            
		else /* For Staggered Lines, Default Status to DR */            
		begin            
			select @line_status = 'DR'            
		end  
      	
		--code for updated multi rows            
		if 	@line_no is not null            
		begin
			--code modified by Anitha N for PPSCMQSOPPS41_000129 on 31/10/2006 begins
			if	(@modeflag not in ('X','I'))        
			begin    
				--code modified by Anitha N for PPSCMQSOPPS41_000129 on 31/10/2006 ends  
				select 	@sch_type_hdn_old  	=  	sodtl_sch_type,            
						@item_old    		=  	sodtl_item_code,            
						@variant_old   		=  	case sodtl_item_type             
												when 'M'then sodtl_model_config_var            
												else sodtl_item_variant            
												end,            
						@qty_old  			= 	sodtl_req_qty                  
				-- Get Item / Variant Also Here  
				from 	so_order_item_dtl (nolock)            
				where 	sodtl_ou  			= 	@ctxt_ouinstance            
				and 	sodtl_order_no  	= 	@order_no             
				and 	sodtl_line_no  		= 	@line_no            
						
				select 	@insert_line  		=  	'N'            
             
				--If item code and variant code changes            
				if (@item_old  <> @item or @variant_old <> @variantml) 
				begin            
					--calling the procedure to delete the detail tables    
					exec so_cmn_line_delete @ctxt_language,@ctxt_ouinstance,@ctxt_service,            
					@ctxt_user,@order_no,@line_no,'N'            
				
					-- Mark Line to be considered for Insertion            
					select @insert_line =  'Y'            
				end       
				
	
				--code added for PEPS-20 begins
				if exists ( select 'X' from 
							so_order_item_dtl (nolock)            
							where 	sodtl_ou  			= 	@ctxt_ouinstance            
							and 	sodtl_order_no  	= 	@order_no 
							--and 	sodtl_line_no 		= @line_no	--code commented for PEPS-116
							and		sodtl_ref_doc_line_no	= @line_no		--code added for PEPS-116
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
				     
   			end
  		end  
	--code modified by Anitha N for PPSCMQSOPPS41_000129 on 31/10/2006 begins      
	end  
	--code modified by Anitha N for PPSCMQSOPPS41_000129 on 31/10/2006 ends  


	-- Line is Updated            
	if 	@line_no is not null and @insert_line = 'N'            
	begin            
		if 	(@schedule_type <> @sch_type_hdn_old )            
		begin            
			-- Changed from Staggered to Single            
			if 	(@sch_type_hdn_old = 'SG' and @schedule_type = 'SI' )            
			begin             
				if exists (	select  'X'     
							from 	so_order_sch_dtl (nolock)            
							where 	sosch_ou 		= 	@ctxt_ouinstance            
							and 	sosch_order_no 	= 	@order_no            
							and 	sosch_line_no 	= 	@line_no	
							)            
				begin            
					--Please delete the schedules in schedule page and change the schedule type from staggered to single            
					select @m_errorid = 3550342            
					return            
				end            
			end            
	
			-- Changed from  Single to Staggered    
			if (@sch_type_hdn_old = 'SI' and @schedule_type = 'SG' )            
			begin  
				/* Code Modified by Vairamani C for ES_NSO_00213 Starts here */
				if exists
				(
					select	'X'
					from 	so_order_sch_dtl   (nolock)         
					where 	sosch_ou 	= 	@ctxt_ouinstance            
					and 	sosch_order_no 	= 	@order_no            
					and 	sosch_line_no 	= 	@line_no 
				)
				begin 
					delete 	from so_order_sch_dtl      
					where 	sosch_ou 	= 	@ctxt_ouinstance            
					and 	sosch_order_no 	= 	@order_no            
					and 	sosch_line_no 	= 	@line_no            
				end
				/* Code Modified by Vairamani C for ES_NSO_00213 Ends here */

					select @line_status = 'DR'            
			end             
		end             

		-- To Check if Status of Staggered Line should be FR or DR             
		if 	@schedule_type = 'SG'             
		begin            
			select 	@line_status 		= 'FR',            
					@total_sch_qty_tmp 	= 0.00            


			select  @total_sch_qty_tmp 	= 	isnull(sum(isnull( sosch_sch_qty,0)),0)            
			from 	so_order_sch_dtl 		(nolock)            
			where 	sosch_ou 			= 	@ctxt_ouinstance            
			and 	sosch_order_no 		= 	@order_no            
			and 	sosch_line_no 		= 	@line_no      

			if  	(@total_sch_qty_tmp <> @qty)    
					and rtrim(@ctxt_service) in ('SOPP_CRMN_SER_AUTH','SOPP_CRMN_SER_AUTH1')  --code added for RFBE-14      
			begin            
				--select @line_status = 'DR'            
				--Staggered Schedule cannot change the Quantity,Please check            
				--select @m_errorid = 3550302  --code commented for RFBE-14
				--raiserror('Cannot authorise SO due to quantity mismatch for line no."%d" between Main page & Sch page',16,1,@fprowno)--code added for RFBE-14   
				EXEC fin_german_raiserror_sp 'NSO',@ctxt_language,11260507,@fprowno--code added for RFBE-14         
				return            
			end            
		end            
     
 		-- Check for Price Engine Runs            
		-- If User Selected a row and Pressed submit deleting the default information and Defaulting the Price , Tax , Promotions             
		/*Code merged by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 Begin*/

		if 	@feature_flag_yes_no = 'NO'	
		begin
			/*Code merged by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 End*/
			--   if  @modeflag in ('X', 'Y', 'Z')   --NSODMS412AT_000539           
			--   begin  
			--Code modified by Suganya S for PPSCMQSOPPS41_000097 on 24/10/2006 begins
			--    select @tcd_dflt_flag = 'Y',            
			--     @prom_dflt_flag = 'Y' ,
			-- 	@price_flag = 'Y'  
			-- 	, @unititmprice = 0.00                        
			--Code modified by Suganya S for PPSCMQSOPPS41_000097 on 24/10/2006 ends
				
			--deleting the so price param detail table
			/* Code Modified by Vairamani C for ES_NSO_00213 Starts here */
			if exists
			(
				select	'X'
				from	so_price_param_dtl (nolock)    
				where 	sopr_ou  		= 	@ctxt_ouinstance  
				and 	sopr_orderno 	= 	@order_no            
				and 	sopr_lineno 	= 	@line_no 
			)
			begin                 
				delete 	so_price_param_dtl            
				where 	sopr_ou  		= 	@ctxt_ouinstance  
				and 	sopr_orderno 	= 	@order_no            
				and 	sopr_lineno 	= 	@line_no            
			end
			/* Code Modified by Vairamani C for ES_NSO_00213 Ends here */
    
						/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 -+ Begin*/
						/*Code commented by Ananth P. against: ES_NSO_00113 Begins*/
			--			if @feature_flag_yes_no = 'YES'
			--				select @feature_flag_yes_no = @feature_flag_yes_no
			--				--Commented by Robbins
			--				/*--deleting the values from item tcd table            
			--				delete so_item_tcd_dtl            
			--				where itmtcd_ou = @ctxt_ouinstance            
			--				and itmtcd_order_no = @order_no            
			--				and itmtcd_line_no = @line_no*/
			--			else
			--				/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 -+ End*/
			--				--deleting the values from item tcd table            
			--				delete 	so_item_tcd_dtl            
			--				where 	itmtcd_ou 	= 	@ctxt_ouinstance            
			--				and 	itmtcd_order_no = 	@order_no            
			--				and 	itmtcd_line_no 	= 	@line_no            
			--				and 	exists	(	select 	'x' --NSODMS412AT_000539
			--							from 	so_order_item_dtl (nolock)
			--							where 	sodtl_ou  	= 	@ctxt_ouinstance            
			--							and 	sodtl_order_no  = 	@order_no             
			--							and 	sodtl_line_no  	= 	@line_no   
			--							and 	(isnull(sodtl_tc_upd_flag,'N') = 'N' AND isnull(sodtl_tc_upd_flag,'N') = 'N'))
			--           
			--   				--deleting the schedule promotional items            
			--			;
			--			WITH SQLTMP (sodtl_line_no1) as (	SELECT 	DISTINCT SQL2K51.sodtl_line_no
			--								FROM 	so_order_item_dtl SQL2K51 (NOLOCK) 
			--								WHERE 	SQL2K51.sodtl_ou 		= 	@ctxt_ouinstance
			--								and	SQL2K51.sodtl_order_no 		= 	@order_no
			--								and	SQL2K51.sodtl_ref_doc_line_no 	= 	@line_no
			--								and	SQL2K51.sodtl_free_item_flag 	= 	'Y' )
			--			
			--			DELETE 	so_order_sch_dtl
			--			FROM 	so_order_sch_dtl JOIN SQLTMP 
			--			ON 	( sosch_line_no 	= 	SQLTMP.sodtl_line_no1 )
			--			WHERE  	sosch_ou 		= 	@ctxt_ouinstance
			--			and	sosch_order_no 		= 	@order_no
			--			and	sosch_free_item_flag 	= 	'Y'
			--
			--			--ToolComment   delete so_order_sch_dtl            
			--			--ToolComment   where sosch_ou  = @ctxt_ouinstance            
			--			--ToolComment   and sosch_order_no  = @order_no            
			--			--ToolComment   and sosch_line_no  in( select sodtl_line_no            
			--			--ToolComment        from so_order_item_dtl(nolock)             
			--			--ToolComment        where sodtl_ou  = @ctxt_ouinstance                 
			--			--ToolComment        and sodtl_order_no  = @order_no                 
			--			--ToolComment        and sodtl_ref_doc_line_no = @line_no            
			--			--ToolComment        and sodtl_free_item_flag  =  'Y' )            
			--			--ToolComment   and sosch_free_item_flag = 'Y'            
			--			--ToolComment   --deleting the promotional items 
			--			delete  so_order_item_dtl            
			--			where 	sodtl_ou  		= 	@ctxt_ouinstance                 
			--			and 	sodtl_order_no  	= 	@order_no                 
			--			and 	sodtl_ref_doc_line_no 	= 	@line_no            
			--			and 	sodtl_free_item_flag  	=  	'Y'             
						/*Code commented by Ananth P. against: ES_NSO_00113 Ends*/
						--  end             -NSODMS412AT_000539
					/*Code merged by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 Begin*/
		end            
		/*Code merged by Indu for CUMI_PPSCMQSO_000114 on 12/Dec/2005 End*/
   
		   
		--calling the procedure for inserting the multi line values into temporary tabel   
		/* Code modified by Damodharan. R on 06 Sep 2007 for OTS ID NSODMS412AT_000526 starts here */        
		
	 
		exec 	so_crmn_sp_tmp_ins_item	
				@ctxt_ouinstance, 			@ctxt_language,				@ctxt_service ,
				@ctxt_user,					@con_forcast_hdn,			--@con_forml_hdn,            
				@guid,						@incoplace,					@item,
				@item_type,					@model_config_code,			@model_config_var,
				@item_wt,					@item_volume,    		@item_var_desc,
				@line_no,					@line_status,				@modeflag,
				@order_no,					@price_flag,				@tcd_cal_flag,
				@update_flag,				@tcd_dflt_flag,				@prom_dflt_flag,            
				--@price_rule_no,@pricelistno,@pricelist_amend_no,@pricingdateml,@processingaction_hdn,'ACC',@sp_ou,@spcodeml,            
				@price_rule_no,				@pricelistno,				@pricelist_amend_no,
				@pricingdateml,				@processingaction_hdn,		@stockstatus_hdn,
				@sp_ou,@spcodeml,       	@promiseddateml,			@promotype,
				@qty,@stock_qty,			@unititmprice,				@refdoclineno,
				@referencescheduleno,		@reqddateml,				@reserve_dtml,		@salepurposeml,            
				--@schedule_type,@shiptocustomercode,@shippartial_flag,@shippingpointml_hdn,@shiptoidml,@sales_uom,@to_shipdateml,@extprice,            
				@schedule_type,				@shiptocustomercode,		@shippartial_hdn,
				@shippingpointml_hdn,		@shiptoidml,@sales_uom,		@to_shipdateml,		@extprice,            
				--@trans_mode,@usagecccodeml,@variantml,@warehousemulti,@youritemcode_ml,@unitfrprice,@unitprice_ml,            
				@trans_mode,				@usagecccodeml,				@fb_docml,			@variantml,		
				@warehousemulti,			@youritemcode_ml,			@unitfrprice,		@unitprice_ml,            
				@shelf_life_unit_mul_hdn,	@gua_shelflife,				@priceuomml,		
				@remarks_manso,--code added by EBS-971
				null, -- EBS-1362
				@customeritemdesc, -- code added for EPE-27452
				@m_errorid_tmp output            
		/* Code modified by Damodharan. R on 06 Sep 2007 for OTS ID NSODMS412AT_000526 ends here */   
		
		if 	@m_errorid_tmp <> 0            
		begin            
			select @m_errorid = @m_errorid_tmp            
			return             
		end                  

		--code for single schedule             
		if 	@schedule_type = 'SI'             
		begin                  
			if exists ( 	select  'X'            
							from 	so_order_sch_dtl 	(nolock)            
							where 	sosch_ou 		= 	@ctxt_ouinstance            
							and 	sosch_order_no 	= 	@order_no            
							and 	sosch_line_no 	= 	@line_no	
					)            
			begin             
				select 	@promotionid 	= 	sodtl_promotion_id             
				from 	sotmp_order_item_dtl (nolock)          
				where 	sodtl_guid 	= 	@guid            
				and 	sodtl_line_no 	= 	@line_no                 
							
				select @reasoncode = null            
	
				/*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 starts here*/
				if 	@item_type = 'S'
				begin
				
					--calling the procedure to fetch the account details            
					exec so_service_getacctcode_sp
					@ctxt_language,  	@ctxt_ouinstance, 		@ctxt_service,  		@ctxt_user,            
					'NSO',   			@guid,   				@item,   				@variantml,          
					@ord_type_hdn,  	@sale_type,  			@sales_chan,  			@deliveryarea,            
					@cust_ou,  			@customercode,  		@salepurposeml,  		@shippingpointml_hdn,       
					@shiptoidml,  		@promotionid,  			@receipttype,  			@processingaction_hdn,            
					@reasoncode,  		@fb_docml, 				@usagecccodeml,  		@number_series,            
					@folder,  			@sale_account out, 		@analysiscode_out out, 	@subanalysiscode_out out,   
					@cost_center out, 	@m_errorid_tmp out            
					
					if 	@m_errorid_tmp <> 0   
					begin            
						select @m_errorid = @m_errorid_tmp            
						return            
					end  

					select 	@analysiscode_tmp		=	sosch_analysis_code,
							@subanalysiscode_tmp	=	sosch_sub_analysis_code,
							@fb_doc_tmp				=	rtrim(sosch_fbdoc)
					from	so_order_sch_dtl 			(nolock)
					where 	sosch_ou  				= 	@ctxt_ouinstance            
					and 	sosch_order_no  		= 	@order_no            
					and 	sosch_line_no  			= 	@line_no 

					if 	@fb_doc_tmp = @fb_docml
					begin
						if 	@analysiscode_out is null or @analysiscode_out = ''
							select	@analysiscode_out	=	@analysiscode_tmp
					
						if 	@subanalysiscode_out is null or @subanalysiscode_out = ''
							select @subanalysiscode_out	=	@subanalysiscode_tmp
					end				            
				end
				else
				begin 
				
				 
					/*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 ends here*/
					--calling the procedure to fetch the account details    
					       
					exec so_cmn_getacctcode_sp            
						@ctxt_language,  	@ctxt_ouinstance, 		@ctxt_service,  		@ctxt_user,            
						'NSO',   			@guid,   				@item,   				@variantml,          
						@ord_type_hdn,  	@sale_type,  			@sales_chan,  			@deliveryarea,      
						@cust_ou,  			@customercode,  		@salepurposeml,  		@shippingpointml_hdn,             
						@shiptoidml,  		@promotionid,  			@receipttype,  			@processingaction_hdn,            
						@reasoncode,  		@warehousemulti, 		@usagecccodeml,  		@number_series,            
						@folder,  			@sale_account out, 		@analysiscode_out out, 	@subanalysiscode_out out,            
						@cost_center out, 	@m_errorid_tmp out            
					    /*Code added for ES_cobi_00047 begins here*/
						,@fb_docml
		
					    /*Code added for ES_cobi_00047 ends here*/
						if 	@m_errorid_tmp <> 0            
						begin            
							select @m_errorid = @m_errorid_tmp         
							return            
						end  
					/*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 starts here*/ 
				end      
				/*Code added by Damodharan. R on 07 Aug 2008 for Defect ID ES_NSO_00042 ends here*/
					--updating the schedule table    
					
         

				/* Code added by Balaji Prasad P.R for the defect id : ES_PACKSLIP_00049 begins */
				if (	(@item_ou				is null ) or
						(@item_type				is null ) or
						(@item					is null ) or
						(@item_type				is null ) or
						(@variantml				is null ) or
						(@sales_uom				is null ) or
						(@qty					is null ) or
						(@stock_qty				is null ) or
						(@shippingpointml_hdn	is null ) or
						(@planningtype			is null ) or
						(@shiptocustomercode	is null ) or
						(@shiptoidml			is null ) or
						(@reserve_dtml			is null ) or
						(@reqddateml			is null ) or
						(@promiseddateml		is null ) or
						(@to_shipdateml			is null ) or
						(@processingaction_hdn	is null )	)
				return
				/* Code added by Balaji Prasad P.R for the defect id : ES_PACKSLIP_00049 ends */

				update 	so_order_sch_dtl with (rowlock) --COBIPPS41_000044           
				set 	sosch_item_ou  			= 	@item_ou,            
						sosch_item_type  		= 	@item_type,            
						sosch_item_code  		= 	@item,            
						sosch_item_variant 		= 	case 	@item_type 	
															when 'M' then '##' 
															else @variantml             
															end ,             
						sosch_uom  				= 	@sales_uom,            
						sosch_sch_qty  			= 	@qty,            
						sosch_rem_qty  			= 	case            
													when @qty-(isnull(sosch_pick_qty,0)+isnull(sosch_direct_pack_qty,0)+isnull(sosch_bill_hold_qty,0)) < 0 then 0            
													else @qty-(isnull(sosch_pick_qty,0)+isnull(sosch_direct_pack_qty,0)+isnull(sosch_bill_hold_qty,0))            
													end,            
						sosch_stock_uom_qty 	= 	@stock_qty,            
						sosch_shipping_pt 		= 	@shippingpointml_hdn,
						/*code modified for the base fix as on 28/06/2005- anand begins*/            
						sosch_wh_ou  			= 	@wh_ou	,            --NSODMS412AT_000533
						sosch_wh_no  			= 	isnull(@warehousemulti,'##'),   
						/*code modified for the base fix as on 28/06/2005- anand ends*/       
						sosch_ship_to_cust 		= 	@shiptocustomercode,            
						sosch_ship_to_id 		= 	@shiptoidml,            
						/*Code added by Damodharan. R on 12 Feb 2009 for Defect ID ES_NSO_00168 starts here*/
						sosch_delivery_area		=	@deliveryarea,
						/*Code added by Damodharan. R on 12 Feb 2009 for Defect ID ES_NSO_00168 ends here*/
						sosch_sch_date  		= 	@reserve_dtml,            
						sosch_req_date  		= 	@reqddateml,            
						sosch_prm_date  		= 	@promiseddateml,      
						sosch_to_ship_date 		= 	@to_shipdateml,            
						/*Code has been Modified for ES_NSO_00079 Begins*/
						sosch_proc_action 		= 	@processingaction_hdn,
            					/*Code has been Modified for ES_NSO_00079 ends*/
						sosch_trans_mode 		= 	@trans_mode,            
						sosch_planning_type 		= 	@planningtype,            
						sosch_acc_code  		= 	@sale_account,            
						sosch_cost_center 		= 	@cost_center,       
--code modified ES_NSO_00096 starts     
						sosch_analysis_code 	= 	isnull(sosch_analysis_code,@analysiscode_out),            
						sosch_sub_analysis_code = 	case when sosch_analysis_code = @analysiscode_out
														then isnull(sosch_sub_analysis_code,@subanalysiscode_out)
														else sosch_sub_analysis_code end,            
--code modified ES_NSO_00096 ends
						sosch_modified_by 		= 	@ctxt_user,     
						sosch_modified_date 	= 	dbo.RES_Getdate(@ctxt_ouinstance),            
						sosch_timestamp  		= 	sosch_timestamp + 1            						
					where 	sosch_ou  			= 	@ctxt_ouinstance            
					and 	sosch_order_no  	= 	@order_no            
					and 	sosch_line_no  		= 	@line_no             
				end            
				else            
	    		begin            
					exec so_crmn_sp_tmp_ins_sch @ctxt_ouinstance, @ctxt_language,@ctxt_service ,@ctxt_user,@con_forcast_hdn,--@con_forml_hdn,            
						@guid,@item_ou,@item,@item_type,@model_config_code,@model_config_var,@item_var_desc,@line_no,            
						@modeflag,@order_no,@pricingdateml,@processingaction_hdn,@promiseddateml,@qty,@stock_qty,@deliveryarea,            
						@refdoclineno,@referencescheduleno,@reqddateml,@reserve_dtml,@salepurposeml,@shiptocustomercode,@shippingpointml_hdn,@shiptoidml,            
						/* Code modified by Damodharan. R on 06 Sep 2007 for OTS ID NSODMS412AT_000526 starts here */
						--@sales_uom,@to_shipdateml,@extprice,@trans_mode,@variantml,@warehousemulti,@wh_ou,@planningtype,@m_errorid_tmp output            
						@sales_uom,@to_shipdateml,@extprice,@trans_mode,@variantml,@warehousemulti,@wh_ou,@planningtype,@fb_docml,@m_errorid_tmp output
						/* Code modified by Damodharan. R on 06 Sep 2007 for OTS ID NSODMS412AT_000526 ends here */
			            
					if 	@m_errorid_tmp <> 0            
					begin            
						select @m_errorid = @m_errorid_tmp            
						return             
					end                 
	   		 	end            
	  		end   
		end            

		--code for newly entered rows     
		--Code added for ES_NSO_00623 begins here

	
		 if 	@feature_flag_yes_no = 'Yes'
		 BEGIN
			if exists
			(
				select	'X'
				from	sotmp_order_item_dtl (nolock)
				where 	sodtl_guid 			= 	@guid
				and 	sodtl_line_no		= 	@line_no_tmp 
			)
			begin																					
				delete 	from sotmp_order_item_dtl
				where 	sodtl_guid 			= 	@guid
				and 	sodtl_line_no		= 	@line_no_tmp     
			end
				
			if  @insert_line =  'Y'             
			begin            
				if 	@line_no is null             
				begin    
					
					select 	@line_no   			= 	isnull(max(isnull(sodtl_line_no,0)),0) +1            
					from 	so_order_item_dtl		(nolock)             
					where 	sodtl_ou  			= 	@ctxt_ouinstance            
					and 	sodtl_order_no  	= 	@order_no             
					and 	sodtl_free_item_flag = 	'N'    
				
					if  @line_no   < @line_no_tmp         
						select @line_no = @line_no_tmp
					
				end 
			eND
		 End
	----Code added for ES_NSO_00623 ends here	
	
   /*												--code commented by Nandhakumar B on 17 Dec 2024 for PJRMC-799 begins
	    /*code added for MAT-685 starts here */
       if @order_date> @to_shipdateml
		   begin
		        EXEC fin_german_raiserror_sp 'NSO',@ctxt_language,1270,@fprowno
			    return
		    end     
	   /*code added for MAT-685 ends here */	
	*/												--code commented by Nandhakumar B on 17 Dec 2024 for PJRMC-799 ends
		         
		if  @insert_line =  'Y'             
		begin            
			if 	@line_no is null             
			begin             
				--computing the line no  
				select 	@line_no  			= 	isnull(max(isnull(sodtl_line_no,0)),0) +1            
				from 	sotmp_order_item_dtl 	(nolock)             
				where 	sodtl_guid 			= 	@guid            
		
				select 	@lineno1   			= 	isnull(max(isnull(sodtl_line_no,0)),0) +1    
				from 	so_order_item_dtl		(nolock)             
				where 	sodtl_ou  			= 	@ctxt_ouinstance  
				and 	sodtl_order_no  	= 	@order_no             
				and 	sodtl_free_item_flag = 	'N'            
		
				if @lineno1 > @line_no            
					select @line_no = @lineno1
			end     
			

			--calling the procedure to insert the new rows            
			/* Code modified by Damodharan. R on 06 Sep 2007 for OTS ID NSODMS412AT_000526 starts here */
			exec so_cmn_sp_line_insert            
				--1,   @con_forml_hdn,  	@ctxt_language,  		@ctxt_ouinstance,            
				1,   						@con_forcast_hdn,  		@ctxt_language,  		@ctxt_ouinstance,            
				@ctxt_service,  			@ctxt_user,  			@customercode,  		@cust_ou,         
				@cust_bu,  					@guid,   				@sourcedocno,  			@incoplace,            
				@item,   					@item_var_desc,  		@item_type,  			@item_ou,            
				@item_wt,  					@item_volume, 			@line_no,  				@lo,            
				@bu_item,  					@line_status,  			@price_flag,  			@price_rule_no,       
				@pricelist_amend_no, 		@planningtype,  		@wh_ou, 				@sp_ou,            
				@deliveryarea,  			@stock_qty,  			@model_config_code, 	@model_config_var,            
				@modeflag,  				@order_no,  			@pricelistno,  			@pricingdateml,   
				@processingaction_hdn, 		@promiseddateml, 		@promotype,  			@qty,            
				@unititmprice,  			@refdoclineno,  		@referencescheduleno, 	@reqddateml,            
				@reserve_dtml,  			@salepurposeml,  		@schedule_type,  		@shiptocustomercode,            
				/* Code modified by Damodharan starts */
				--@shippartial_flag, 		@shippingpointml_hdn, 	@shiptoidml,  			@sales_uom,            
				--@sourcedocument_qso_hdn,	@spcodeml,  			'ACC',   				@to_shipdateml,
				@shippartial_hdn, 			@shippingpointml_hdn, 	@shiptoidml,  			@sales_uom,            
				@sourcedocument_qso_hdn,	@spcodeml,  			@stockstatus_hdn,   	@to_shipdateml,            	
				--@extprice,  				@trans_mode,  			@usagecccodeml,  		@variantml,            
				@extprice, 				@trans_mode,  			@usagecccodeml,  		@fb_docml,	@variantml,            
				/* Code modified by Damodharan ends*/
				@warehousemulti, 			@youritemcode_ml, 		@unitfrprice,  			@unitprice_ml,     
				@shelf_life_unit_mul_hdn,	@gua_shelflife, 		@priceuomml,  			
				@remarks_manso,--code added by EBS-971
				null, -- EBS-1362
				@m_errorid_tmp out ,
				null,
				null,
				@customeritemdesc-- code added for EPE-27452   
			/* Code modified by Damodharan. R on 06 Sep 2007 for OTS ID NSODMS412AT_000526 ends here */        
	        	  
			if 	@m_errorid_tmp <> 0            
			begin            
				select @m_errorid = @m_errorid_tmp            
				return             
			end   
			
			--code added by vasantha a for ES_NSO_01328 begins
			if @sourcedocument_qso_hdn ='QUO' and @order_no is null
			begin
				exec	so_crref_sp_qtn_dflt_sbt
				@ctxt_language,@ctxt_ouinstance,@ctxt_service,	@ctxt_user,@sourcedocno,
				@ctxt_ouinstance,@refdoclineno,@order_no,@fprowno,@guid,@con_forcast_hdn,@processingaction_hdn,
				@stockstatus_hdn,@spcodeml,@sp_ou,@line_status,@reqddateml,@salepurposeml,@shippartial_hdn,
				@trans_mode,@to_shipdateml,@pricingdateml,@usagecccodeml,@planningtype,@deliveryarea,@confactor,
				@schedule_type,@lo_item,@bu_item,
				@remarks_manso,--code added by EBS-971
				null, --EBS-1362
				@m_errorid_tmp out
			
				if	@m_errorid_tmp <> 0
					begin
						select	@m_errorid = @m_errorid_tmp
						return
					end	
			end           
		 --code added by vasantha a for ES_NSO_01328 ends            
 		end      
	/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 -+ Begin*/
	/* Code commented and added for ITS ID : ES_NSO_00748 Begins */
	--if 	@feature_flag_yes_no = 'YES'
	if 	@feature_flag_yes_no = 'YES' and @refdocexist	=	'N'
	/* Code commented and added for ITS ID : ES_NSO_00748 Ends */	
		--Code added by Robbins
		update  sotmp_order_item_dtl with (rowlock) --COBIPPS41_000044
		set  	sodtl_addnl_fld1		= 	@price_engine_flag,
				sodtl_addnl_fld2		= 	@tcd_engine_flag,
				sodtl_stock_uom_qty		= 	@stock_qty,				
				sodtl_to_ship_date_dflt	= 	@to_shipdateml
				,sodtl_remarks			=   @remarks_manso--code added by EBS-971
		where 	sodtl_guid 				= 	@guid
		and 	sodtl_line_no			=	 @line_no
	/*Code added by Mukesh B for OTS No PPSCMQSOPPS41_000040 (Cumi Personalization) on 04/SEP/2005 -+ End*/
  	select @fprowno = @fprowno+1             

	/*Code Added for 14H109_WFMCONFIG_00005 begin */
	if	@callingservice	is	null
	begin
	/*Code Added for 14H109_WFMCONFIG_00005 end */
		
	select @fprowno  	'FPROWNO'
	
	end	--Code Added for 14H109_WFMCONFIG_00005

	set nocount off		--ES_NSO_00042
end










