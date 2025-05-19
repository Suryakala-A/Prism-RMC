/*$File_version=MS4.3.0.68$*/
/*********************************************************************************************
file name		: 	so_cmn_sp_ml_val.sql
version			: 	4.0.0.0
procedure name	: 	so_cmn_sp_ml_val
purpose			: 
author			: 	venkata ganesh
date			: 	02 jan 2003
component name	: 	nso
method name		: 

objects referred
	object name		object type		operation
							(insert/update/delete/select/exec)
**********************************************************************************************
Modification details :
	Modified by				Modified on			Remarks
	N. Krishna				04 Aug 2003			1. Altered the Procedure Parameters to include 
							   					Order No, Sales Channel and fprowno
												2. New Implementation of Selling Restrictions
	N. Krishna				11 Aug 2003			1. Changed @so_uomml as Input / Output Parameter
	Manjunatha     	 		27 Mar 2004			NSODMS41SYTST_000071
 	Appala Raju.K			17 Apr 2004			NSODMS41SYTST_000093
	Maria Jerome Prasanna.G 24/05/2004			NSODMS41UTST_000017
	Appala Raju.K			28 Jul 2004			NSODMS41SYTST_000159(Precision Handling)
	A.Stelena				30/08/2005			NSODMS412AT_000055
	Appala Raju.K			8/23/2004			NSODMS41SYTST_000165
	Saritha					03/01/2006			NSODMS412AT_000158
	Saritha					02/08/2006			NSODMS412AT_000359
	Appala Raju.K			23 Nov 2006			NSODms412at_000412
	Appala Raju.K			24 Nov 2006			NSODms412at_000414
	Priya R					11/07/2007			NSODMS412AT_000498
	Damodharan. R			08 Aug 2007			NSODMS412AT_000505
	Anitha N				08 Aug 2007			NSODMS412AT_000501
	Damodharan. R			06 Oct 2007			NSODMS412AT_000526
	Damodharan. R			06 Oct 2007			NSODMS412AT_000548
	Damodharan. R			30 Oct 2007			NSODMS412AT_000551
	Damodharan. R			26 Nov 2007			NSODMS412AT_000589
	Damodharan. R			28 Feb 2008			DMS412AT_ppscmqso_00004
	Veangadakrishnan R		9/05/2008			DMS412AT_NSO_00041
	Veangadakrishnan R		16/05/2008			ES_NSO_00023
	Damodharan. R			08 Sep 2008			ES_NSO_00058
	Veangadakrishnan R		11/09/2008			DMS412AT_NSO_00056
	Veangadakrishnan R		29/10/2008			ES_PACKSLIP_00049
    Jagadeesan RS	     	31/10/2008	   	  	ES_NSO_00088
	Veangadakrishnan R		12/11/2008			ES_PACKSLIP_00049
	Damodharan. R			18 Nov 2008			ES_PACKSLIP_00117
	Vijayan.j				24/11/2008			ES_NSO_00102
	Damodharan. R			06 Dec 2008			ES_PACKSLIP_00125
	Veangadakrishnan R		23/12/2008			ES_NSO_00112
	Damodharan. R			19 Jan 2009			ES_NSO_00139
	Sujatha S				22/01/2009			ES_NSO_00108
	Damodharan. R			05 Feb 2009			ES_NSO_00147
	Ananth P.				10/02/2009			ES_NSO_00164
	Sujatha S				10/03/2009			ES_NSO_00185
    Vairamani C				Mar 30 2009			ES_NSO_00213
	Veangadakrishnan R		23/03/2009			ES_PACKSLIP_00204
	Sujatha S				24/03/2009			Pete_Lien_NSO_BASEFIXES_001536(7U134_UAT_NSO_00005) 
	Damodharan. R			28 Apr 2009			ES_NSO_00211
	Jagadeesan RS			29 Apr 2009			ES_NSO_00226
	Damodharan. R			12 May 2009			ES_NSO_00237
	Jagadeesan RS			29 Apr 2009			ES_NSO_00238
	Veangadakrishnan R		12/05/2009			9H123-1_DR_00001
	Sujatha S				03/06/2009			ES_NSO_00257
	Damodharan. R			12/06/2009			ES_NSO_00268
	Divyalekaa				30/09/2009			ES_NSO_00311
	Jagadeesan RS			25/11/2009			ES_NSO_00208
	Indu Ram				19-Mar-2010			ES_SOD_00005
	Jagadeesan RS			19/04/2010			ES_NSO_00353	
	Sujatha S				08/05/2012			ES_NSO_00538
	Sujatha S				24/05/2012			ES_NSO_00548
	Sujatha S				15/06/2012			ES_NSO_00549
	Indu Ram				21-01-2013			ES_NSO_00603
	Sujatha S				25/02/2013			ES_NSO_00609
	Ganga Mohan				23-09-2013			ES_NSO_00693
	Sejal N Khimani			20 Jan 2014			13H120_Supp_00004:ES_Supp_00320
	Sejal N Khimani			28 Jan 2014			13H120_Supp_00004:ES_Supp_00320[Phase II]
	Prabhakaran				05 Jun 2014			ES_SOMBL_00004
	Sumeet Soni				16 Feb 2016			ES_NSO_01073
	Vasantha a				12/04/2016			ES_NSO_01118
	Rani B					30/11/2016			ES_NSO_01309
	Rani B					25/04/2017			ES_NSO_01574 
	Vasantha a				25/10/2017			HAL-375
	Abinaya G				14/03/2018			VE-3821
	Abianaya G				26/06/2018			MKN-307	
	Nivetha L				25/10/2018			SCLRES-825	
	Jamuna D				21/11/2018			SCLRES-707
	Abinaya G				04/03/2020			BE-1123
	Vasantha a				17/03/2020			BE-1093
	Abinaya G				14/10/2020			GSE-2010
	Abinaya G				14/10/2020			GSE-2010
	Prakash V				21/09/2021			JCME-317:CUIE-542
	Vijay Shree S			18/08/2023			TIS-1515
	Chaitanya Ch			14/02/2024			EPE-75937
	 Srinivasan M           14/05/2024          EPE-85980
	 	Sai Kumar               02/07/2024			EPE-84871
	Banurekha B             14/8/2024            EPE-87134 
	Vijay shree S			20/08/2024			 EPE-87218
	 Nandhakumar B   17/12/2024   PJRMC-799
*********************************************************************************************/
create   procedure so_cmn_sp_ml_val
	@check_price   				udd_checkbox  , 
	@ctxt_language   			udd_ctxt_language  ,
	@ctxt_ouinstance   			udd_ctxt_ouinstance  ,
	@ctxt_service   			udd_ctxt_service  ,
	@ctxt_user   				udd_ctxt_user  ,
	@customercode   			udd_customer_id  ,
	@guid   					udd_guid  ,		
	@lineno   					udd_lineno  ,
	@order_no					udd_documentno ,
	@sales_channel				udd_saleschannel ,
	@fprowno					udd_lineno ,    
	@orderdate   				udd_date  ,
	@pricelistno_ml   			udd_pricelist  ,
	@pricingdate   				udd_date  ,	
	@processingaction_hdn   	udd_code  , 	
	@promiseddate   			udd_date  ,	
	@qtyml   					udd_quantity  ,	
	@reqddate   				udd_date  ,		
	@sale_ord_type   			udd_optioncode,  
	@schtype_hdn   				udd_metadata_code  ,
	@shipcustcode   			udd_customer_id  ,	
	@shippartial_hdn   			udd_metadata_code  ,	
	@shippingpoint_hdn   		udd_ouinstid  ,		
	@shiptoaddid   				udd_id  ,	
	@spcode   					udd_code  ,	
	@stocstatusml_hdn   		udd_code  ,	
	@trans_mode   				udd_identificationnumber1  ,	
	@usagecccode   				udd_item_usage  ,	
	@fb_doc						udd_financebookid,			--Damodharan added	for OTS ID NSODMS412AT_000526
	@warehouse   				udd_warehouse  ,	
	@youritemcode   			udd_itemcode  ,
	@zero_it_rate   			udd_zerorateflag  ,		
	@currency					udd_currency,
	@preffered_carrier			udd_carriercode,
	@refdoc_no					udd_documentno,
	@refdoc_ou					udd_ctxt_ouinstance,
	@refdoc_type				udd_sourcedocument,
	@refdoc_flag				udd_metadata_code,
	@refdoc_lineno				udd_lineno,
	/* Code modified by Raju against NSODms412at_000412 starts*/
	@unitfrprice				udd_price,  
	@priceuomml					udd_uomcode,  
	@gua_shelflife				udd_shelflife,  
	@shelf_life_unit_mul_hdn 	udd_metadata_code,  
	/* Code modified by Raju against NSODms412at_000412 ends*/
	@item_code_mul   			udd_itemcode out,    
	@variant_code_mul   		udd_variant  out,
	@so_uomml   				udd_uomcode  out,    
	@rateml   					udd_rate out, 
	@reserve_dtml   			udd_date out,
	@to_shipdateml   			udd_date out,       
	@pricingdateml   			udd_date out,
	@processingactionml_hdn 	udd_code out,
	@promiseddateml   			udd_date out,
	@reqddateml   				udd_date out,
	@shipcustcodeml   			udd_customer_id out,
	@shippartialml_hdn   		udd_metadata_code out,
	@shippingpointml_hdn   		udd_ouinstid  out,
	@shiptoaddidml   			udd_id  out,
	@spcodeml   				udd_code out,
	@trans_modeml   			udd_identificationnumber1 out,
	@usagecccodeml   			udd_item_usage out,
	@fb_docml					udd_financebookid out,			--damodharan added	for OTS ID NSODMS412AT_000526
	@warehouse_code_mul   		udd_warehouse out ,
	@incoplace   				udd_city out,	    
	@lo							udd_loid out,		
	@cust_bu					udd_buid out,		
	@cust_ou					udd_ctxt_ouinstance out,
	@item_ou					udd_ctxt_ouinstance out,
	@wh_ou						udd_ctxt_ouinstance out,	
	@sp_ou						udd_ctxt_ouinstance out,
	@lo_item					udd_loid out,
	@bu_item					udd_buid out,
	@item_type					udd_metadata_code out,	
	@item_wt					udd_quantity out,
	@item_volume				udd_quantity out,
	@model_config_code			udd_itemcode out,
	@model_config_var			udd_lineno out,  
	@stock_qty					udd_quantity out,
	@price_flag					udd_metadata_code out,	
	@pricelist_amend_no			udd_lineno out,
	@price_rule_no				udd_ruleno out,
	@deliveryarea 				udd_deliveryarea out,
	@line_status				udd_metadata_code out,
	@planningtype				udd_metadata_code out,
	@confactor					udd_quantity out,
	@con_forml_hdn  			udd_metadata_code out,
	@m_errorid  				udd_int OUTPUT, --to return execution status	--ES_NSO_00211 - SP analyser exception
	/* Code modified by Raju against NSODms412at_000412 starts*/
	@modeflag					udd_modeflag = null,
	/* Code modified by Raju against NSODms412at_000412 ends*/
	@errorid					udd_int	= null output	--Code added for ITS ID : ES_SOMBL_00004 
AS
BEGIN
	-- nocount should be switched on to prevent phantom rows 
	SET NOCOUNT ON
	-- @m_errorid should be 0 to indicate success
	SELECT @m_errorid = 0

	select	@item_code_mul	=	convert(nvarchar(50),@item_code_mul)--CUIE-542 --nvarchar(50) for TIS-1515
	
	DECLARE @m_errorid_tmp         udd_int,	--ES_NSO_00211 - SP analyser exception
	        @val_cus_item          udd_paramcode,
	        @item_code_tmp     udd_itemcode,
	        @variant_code_tmp      udd_variant,
	        @uom_ou                udd_ctxt_ouinstance,
	        @stk_ou                udd_ctxt_ouinstance,
	        @peg2_ou               udd_ctxt_ouinstance,
	        --@sha_ou				udd_ctxt_ouinstance,	--Code commented for Defect ID ES_NSO_00211 - SP analyser exception
	        @trandate              udd_date,
	        /* Code modified by Raju against NSODms412at_000412 starts*/
	        @shelf_life_period     udd_shelflife,
	        @convfactor            udd_conversion,
	        @convert_type          udd_metadata_code,
	        @sales_usage           udd_sequence,
	        /* Code modified by Raju against NSODms412at_000412 ends*/
	        @m_error_flag          udd_metadata_code,
	        @flag                  udd_sequence,
	        @frac_allowed          udd_sequence,
	        @qty_c                 udd_quantity,
	        @stockableflag         udd_sequence,
	        @execflag              udd_sequence,
	        @sp_name               udd_name,
	        /*Code modified for Defect ID ES_NSO_00211 - SP analyser exception - begins*/
	        /*
	        @prodn_usage			int,
	        @purch_source			int,
	        */
	        @prodn_usage           udd_sequence,
	        @purch_source          udd_sequence,
	        /*Code modified for Defect ID ES_NSO_00211 - SP analyser exception - ends*/
	        @stock_uom_tmp         udd_uom,
	        @error_msg_qualifier   udd_desc255,
	        @frac_allowed_stkuom   udd_sequence,	-- code added for NSODMS412AT_000359
	        @var_allwd             udd_sequence --NSODMS412AT_000501
	                                --Code added by Damodharan. R on 28 Feb 2008 for DTS ID DMS412AT_ppscmqso_00004 starts here
	DECLARE @item_type_tmp         udd_metadata_code
	DECLARE @itemvar_mul		   udd_name --Code added for ES_NSO_00208 
	--Code added by Damodharan. R on 28 Feb 2008 for DTS ID DMS412AT_ppscmqso_00004 ends here
	/*code added for DTS ID: DMS412AT_NSO_00056 starts here*/
	/*Code commented for Defect ID ES_NSO_00211 - SP analyser exception - begins*/
	/*
	declare	@company_tmp			udd_companycode,
	@excise_flag					udd_flag,
	@def_calc_flag					udd_flag
	*/
	/*Code commented for Defect ID ES_NSO_00211 - SP analyser exception - ends*/
	/*code added for DTS ID: DMS412AT_NSO_00056 ends here*/
	DECLARE @count_kitconstituent  udd_int,	--Added by Veangadakrishnan R for DTS ID: ES_PACKSLIP_00049
	        @chk_kitconstituent    udd_int --Added by Veangadakrishnan R for DTS ID: ES_PACKSLIP_00049
	/*Code added by Damodharan. R on 06 Dec 2008 for Defect ID ES_PACKSLIP_00125 starts here*/
	DECLARE @con_item_code         udd_itemcode,
	        @con_variant_code      udd_variant,
	        @con_item_variant      udd_desc50
	/*Code added by Damodharan. R on 06 Dec 2008 for Defect ID ES_PACKSLIP_00125 ends here*/
	/*Code added by Damodharan. R on 12/06/2009 for Defect ID ES_NSO_00268 starts here*/
	DECLARE @sale_con_cnt_tmp      udd_count,
	        @kit_con_cnt_tmp       udd_count
	/*Code added by Damodharan. R on 12/06/2009 for Defect ID ES_NSO_00268 ends here*/
	    ,@ordship			   udd_flag			--code added for SCLRES-707

	declare @tran_type	udd_paramcode	--code added for VE-3821
	--MKN-307	begins
	declare @ShiptolerancePst_tmp	udd_quantity  
	declare @ShiptoleranceNeg_tmp	udd_quantity  
   	DECLARE	@precision_out			udd_lineno
	--MKN-307 ends
		
	IF @ctxt_service LIKE 'SOPP_%'
	BEGIN
	    DECLARE @feature_flag_yes_no udd_yesnoflag
	    
	    SELECT @feature_flag_yes_no = flag_yes_no
	    FROM   pps_feature_list(NOLOCK)
	    WHERE  feature_id = 'PPS_FID_0014'
	    AND    component_name = 'NSO'
	    
	    IF ISNULL(@feature_flag_yes_no, '') = ''
	        SELECT @feature_flag_yes_no = 'NO'
	END
	
	SELECT @m_errorid_tmp = 0,
	       @m_error_flag = 'S',
	       @trandate = CONVERT(nCHAR(10),  dbo.res_getdate(@ctxt_ouinstance), 120),--ES_SOD_00005
	       @error_msg_qualifier = NULL,
	       @flag = 0,
	       @sales_usage = 0,
	       @errorid		= 0				--Code added for ITS ID : ES_SOMBL_00004 
	
	--calling procedure for customer destination ou
	EXEC scm_get_dest_ou @ctxt_ouinstance,
	     @ctxt_language,
	     @ctxt_user,
	     'NSO',
	     'CU',
	     @cust_ou OUT,
	     @m_errorid_tmp OUT
	
	IF @m_errorid_tmp <> 0
	BEGIN
	    --Normal Sale Order component to Customer component mapping is not present. Please Check
	    SELECT @m_errorid = 325092
	    RETURN
	END


	
	
	--if customer item code is not null checking if it is valid.
	--if it is valid,  fetching the valid item code and variant code, item variant description
	IF @youritemcode IS NOT NULL
	BEGIN
	    SELECT @val_cus_item = parameter_value
	    FROM   so_sys_param_ou_vw(NOLOCK)
	    WHERE  ouid = @ctxt_ouinstance
	    AND    component_name = 'NSO'
	    AND    parameter_code = 'VAL_CUST_ITEM'			
	    
	    IF @val_cus_item = 'Y'
	    BEGIN
	        IF EXISTS (
	               SELECT 'X'
	               FROM   cust_item_details_vw(NOLOCK)
	               WHERE  item_ou = @cust_ou
	               AND    item_cust_code = @customercode
	               AND    item_cust_item_code = @youritemcode
	           )
	        BEGIN
	            SELECT @item_code_tmp = item_item_code,
	                   @variant_code_tmp = item_item_variant
	            FROM   cust_item_details_vw(NOLOCK)
	            WHERE  item_ou = @cust_ou
	            AND    item_cust_code = @customercode
	            AND    item_cust_item_code = @youritemcode	
	            
	            IF @item_code_mul IS NULL
	                SELECT @item_code_mul = @item_code_tmp
	            
	            IF @variant_code_mul IS NULL
	                SELECT @variant_code_mul = @variant_code_tmp
	            
	            IF @item_code_mul <> @item_code_tmp
	            BEGIN
					EXEC fin_german_raiserror_sp 'NSO',@ctxt_language,11260606,@fprowno   --code added for EPE-84871 
	                --item code and item code for your item code are different. please check
	               -- SELECT @m_errorid = 320687   --code commented for EPE-84871 
	                RETURN
	                RETURN
	            END
	            
	            IF @variant_code_mul <> @variant_code_tmp
	            BEGIN
					EXEC fin_german_raiserror_sp 'NSO',@ctxt_language,11260607,@fprowno   --code added for EPE-84871 
	                --variant code and variant code for your item code are different. please check
	                --SELECT @m_errorid = 320688  --code commented for EPE-84871 
	                RETURN
	            END
	        END
	        ELSE
	        BEGIN
	            --<^youritemcode!> "<%youritemcode%>" is not valid. enter a valid <^youritemcode!>  
	            SELECT @m_errorid = 320505
	            RETURN
	        END
	    END
	END 
	
	--itemcode null check
	IF @item_code_mul IS NULL
	BEGIN
	    --itemcode cannot be null. enter valid itemcode
	    SELECT @m_errorid = 320689
	    RETURN
	END
	--code added by vasantha a for BE-1093 begins
	if  @youritemcode IS NOT NULL 
	and (exists (SELECT 'X'
	               FROM   cust_item_details_vw(NOLOCK)
	               WHERE  item_ou = @cust_ou
	            AND    item_cust_code		= @customercode
				   and	  item_item_code		=@item_code_mul
				   and   item_item_variant = @variant_code_mul  --code added for EPE-84871
	               AND    item_cust_item_code	<> @youritemcode	
				   
				)
	or
	exists  (  SELECT 'X'
	           FROM   so_order_item_dtl(NOLOCK),
					  so_order_hdr(nolock)
	           WHERE  sodtl_order_no = @order_no
			   and	  sohdr_ou		= sodtl_ou
				and	  sohdr_order_no= sodtl_order_no
	           AND    sodtl_ou = @ctxt_ouinstance
			    AND    sohdr_order_from_cust		= @customercode
				   and	  sodtl_item_code		=@item_code_mul
				   and sodtl_item_variant = @variant_code_mul     --code added for EPE-84871
	               AND    sodtl_cust_item_code	<> @youritemcode	
	         
			
		)
	)
	begin
		--raiserror('item code %s & customer code %s at line no %d already mapped with different customer item code ',16,1,@item_code_mul,@customercode,@lineno)
		  EXEC fin_german_raiserror_sp 'NSO',
	         @ctxt_language,
	         11260508,
			 @item_code_mul,
			 @customercode,
	         @fprowno
	    select @errorid	=	1	
	    RETURN
		return
	end
	--code added by vasantha a for BE-1093 ends

	
	--code added for NSODMS412AT_000158 starts
	IF @shippingpointml_hdn IS NULL
	    SELECT @shippingpointml_hdn = @shippingpoint_hdn
	
	EXEC scm_get_dest_ou @shippingpointml_hdn,
	     @ctxt_language,
	     @ctxt_user,
	     'PACKSLIP',
	     'ITEMADMN',
	     @item_ou OUT,
	     @m_errorid_tmp OUT
	
	EXEC scm_get_emod_details @item_ou,
	     @trandate,
	     @lo_item OUT,
	     @bu_item OUT,
	     @m_errorid_tmp OUT
	
	IF @m_errorid_tmp <> 0
	    RETURN
	
	--/* Code modified for TTS Id. : ES_NSO_00603 Begins */
	/*Code added by Damodharan. R on 18 Nov 2008 for Defect ID ES_PACKSLIP_00117 starts here*/
	SELECT @wh_ou = destinationouinstid
	FROM   fw_admin_view_comp_intxn_model(NOLOCK)
	WHERE  sourcecomponentname = 'PACKSLIP'
	AND    sourceouinstid = @shippingpointml_hdn
	AND    destinationcomponentname = 'STORAGE_ADMIN'
	AND    destinationouinstid = @shippingpointml_hdn
	
	IF @wh_ou IS NULL
	BEGIN
	    /*Code added by Damodharan. R on 18 Nov 2008 for Defect ID ES_PACKSLIP_00117 ends here*/
	    --calling procedure for  to get warehouse ou
	    EXEC scm_get_dest_ou @shippingpointml_hdn,
	         @ctxt_language,
	         @ctxt_user,
	         'PACKSLIP',
	         'STORAGE_ADMIN',
	         @wh_ou OUT,
	         @m_errorid_tmp OUT	
	    
	    IF @m_errorid_tmp <> 0
	    BEGIN
	        --Packslip component to Storage Administration component mapping is not present. Please Check
	        SELECT @m_errorid = 325096
	        RETURN
	  END/*Code added by Damodharan. R on 18 Nov 2008 for Defect ID ES_PACKSLIP_00117 starts here*/
	END
	/*Code added by Damodharan. R on 18 Nov 2008 for Defect ID ES_PACKSLIP_00117 ends here*/    
	--/* Code modified for TTS Id. : ES_NSO_00603 ends */
	
	IF @variant_code_mul IS NULL
	    SELECT @variant_code_mul = '##'
	
	--Code added by Damodharan. R on 28 Feb 2008 for DTS ID DMS412AT_ppscmqso_00004 starts here
	SELECT @item_type_tmp = LTRIM(RTRIM(item_type_code))
	FROM   item_var_bu_vw(NOLOCK)
	WHERE  lo = @lo_item
	AND    bu = @bu_item
	AND    item_code = @item_code_mul
	AND    variant_code = ISNULL(@variant_code_mul, '##')
	
	IF @item_type_tmp = 'CP'
	BEGIN
	    EXEC fin_german_raiserror_sp 'NSO',
	         @ctxt_language,
	         80,
	         @fprowno
	    select @errorid	=	1	--Code added for ITS ID : ES_SOMBL_00004 
	    RETURN
	END
	--Code added by Damodharan. R on 28 Feb 2008 for DTS ID DMS412AT_ppscmqso_00004 ends here
	--code added for ES_NSO_00538 starts
	declare @FID udd_metadata_code
	
	select	@FID		= FLAG_YES_NO
	from	PPS_FEATURE_LIST (nolock)
	where	FEATURE_ID	= 'PPS_FID_3PLCUBESOVAL'
	

	if @FID = 'YES'
	begin 
	--ES_NSO_00548 starts
		if @customercode <> @variant_code_mul and @item_type_tmp <> 'KT'
		begin
			EXEC fin_german_raiserror_sp 'NSO',@ctxt_language,1227,@fprowno
			select @errorid	=	1		--Code added for ITS ID : ES_SOMBL_00004 
			RETURN
	    end
	 --ES_NSO_00548 ends
	end
	else
	begin
	--code added for ES_NSO_00538 ends
	/*Code added by Damodharan. R on 06 Dec 2008 for Defect ID ES_PACKSLIP_00125 starts here*/
		IF @item_type_tmp = 'KT'
		BEGIN
			/*Code added by Damodharan. R on 12/06/2009 for Defect ID ES_NSO_00268 starts here*/
			SELECT @sale_con_cnt_tmp = COUNT('X')
			FROM   item_ou_sales_info_vw sa(NOLOCK),
				   item_ou_kitinfo_vw kit(NOLOCK)
			WHERE  sa.lo = @lo_item
			AND    sa.bu = @bu_item
			AND    sa.ou = @item_ou
			AND    sa.item_code = kit.item_code
			AND    sa.variant_code = kit.variant_code
			AND    kit.lo = @lo_item
			AND    kit.bu = @bu_item
			AND    kit.ou = @item_ou
			AND  kit.kit_code = @item_code_mul
		    
			SELECT @kit_con_cnt_tmp = COUNT('X')
			FROM   item_ou_kitinfo_vw kit(NOLOCK)
			WHERE  lo = @lo_item
			AND    bu = @bu_item
			AND    ou = @item_ou
			AND    kit_code = @item_code_mul
		    
			IF @sale_con_cnt_tmp = @kit_con_cnt_tmp
			BEGIN
				SELECT @ctxt_language = @ctxt_language
			END
			ELSE
			BEGIN
				--Sale information is not available for the constituents of the Kit "%a" at line No. %b
				EXEC fin_german_raiserror_sp 'NSO',
					 @ctxt_language,
					 150,
					 @item_code_mul,
					 @fprowno
		        
				SELECT @m_errorid = 150
				RETURN
			END
			/*Code added by Damodharan. R on 12/06/2009 for Defect ID ES_NSO_00268 ends here*/
		    
			IF EXISTS (
				   SELECT 'X'
				   FROM   item_ou_sales_info_vw a(NOLOCK),
						  item_ou_kitinfo_vw b(NOLOCK)
				   WHERE  b.ou = @item_ou
				   AND    b.bu = @bu_item
				   AND    b.lo = @lo_item
				   AND    b.kit_code = @item_code_mul
				   AND    a.ou = @item_ou
				   AND    a.bu = @bu_item
				   AND    a.lo = @lo_item
				   AND    a.item_code = b.item_code
				   AND    a.variant_code = b.variant_code
				   AND    ISNULL(a.std_sales_price, 0) = 0
			   )
			BEGIN
				SELECT @con_item_code = a.item_code,
					   @con_variant_code = a.variant_code
				FROM   item_ou_sales_info_vw a(NOLOCK),
					   item_ou_kitinfo_vw b(NOLOCK)
				WHERE  b.ou = @item_ou
				AND    b.bu = @bu_item
				AND    b.lo = @lo_item
				AND    b.kit_code = @item_code_mul
				AND    a.ou = @item_ou
				AND    a.bu = @bu_item
				AND    a.lo = @lo_item
				AND    a.item_code = b.item_code
				AND    a.variant_code = b.variant_code
				AND    ISNULL(a.std_sales_price, 0) = 0
		        
				IF @con_variant_code = '##'
					SELECT @con_item_variant = @con_item_code
				ELSE
					SELECT @con_item_variant = @con_item_code + '-' + @con_variant_code
		        
				--Sales price of the Item constituent "%a" should be greater than Zero.
				EXEC fin_german_raiserror_sp 'NSO',
					 @ctxt_language,
					 137,
					 @con_item_variant
		        
				SELECT @m_errorid = 1001
				RETURN
			END
		END
	/*Code added by Damodharan. R on 06 Dec 2008 for Defect ID ES_PACKSLIP_00125 ends here*/
	end--ES_NSO_00538 
	
	/*code added for DTS ID: DMS412AT_NSO_00056 starts here*/
	--Commented & Modified for DTS ID : ES_NSO_00112 starts here
	--if @item_type_tmp in('KT','ML')
	IF @item_type_tmp = 'KT'
	BEGIN
	    /*select	@company_tmp = company_code
	    from	emod_lo_bu_ou_vw (nolock)
	    where	ou_id = @ctxt_ouinstance	
	    
	    select	@excise_flag	= default_taxtype,
	    @def_calc_flag	= default_calculation_flag
	    from	cps_taxparam_vw (nolock)
	    where	tax_community	= 'INDIA'
	    and		tax_type		= 'EXCISE'
	    and		company_code	= @company_tmp*/
	    --Commented & Modified for DTS ID : ES_NSO_00112 ends here
	    
	    /*Code commented by vijayan.j for the bugid:ES_NSO_00102 starts here*/
	    /*
	    if(@excise_flag ='Y' or @def_calc_flag = 'Y')
	    begin
	    exec fin_german_raiserror_sp 'NSO',@ctxt_language,126
	    return
	 end
	    */
	    /*Code commented by vijayan.j for the bugid:ES_NSO_00102 ends here*/
	    
	    --Added by Veangadakrishnan R for DTS ID: ES_PACKSLIP_00049
	    /* code commented for ES_NSO_01574 begins */
	    --IF (@warehouse_code_mul IS NULL OR @warehouse_code_mul = '')
	    --AND @processingactionml_hdn != 'DROP'-- Modified for DTS ID : ES_NSO_00112
	    --BEGIN
	    --    EXEC fin_german_raiserror_sp 'NSO',
	    --         @ctxt_language,
	    --         127
	    --    select @errorid	=	1		--Code added for ITS ID : ES_SOMBL_00004 
	    --    RETURN
	    --END
	    /* code commented for ES_NSO_01574 ends */
	    IF @sale_ord_type IN ('CSO', 'COD')
	    BEGIN
	        EXEC fin_german_raiserror_sp 'NSO',
	             @ctxt_language,
	             131
	        select @errorid	=	1		--Code added for ITS ID : ES_SOMBL_00004 
	        RETURN
	    END
	    
	  ;
	    WITH itemcim(itemou) AS (
	        SELECT destinationouinstid
	        FROM   fw_admin_view_comp_intxn_model(NOLOCK)
	        WHERE  sourcecomponentname = 'PACKSLIP'
	        AND    sourceouinstid = @shippingpointml_hdn
	        AND    destinationcomponentname = 'ITEMADMN'
	    )	
	    SELECT @count_kitconstituent = COUNT('X')
	    FROM   item_ou_kitinfo_vw(NOLOCK)
	           JOIN itemcim
	                ON  (ou = itemou)
	    WHERE  lo = @lo_item
	    AND    bu = @bu_item
	    AND    kit_code = @item_code_mul
	    
	    IF @count_kitconstituent = 0
	    BEGIN
	        EXEC fin_german_raiserror_sp 'NSO',
	             @ctxt_language,
	             128
	        select @errorid	=	1			--Code added for ITS ID : ES_SOMBL_00004 
	        RETURN
	    END
	    
	    ;
	    WITH itemcim(itemou) AS (
	        SELECT destinationouinstid
	        FROM   fw_admin_view_comp_intxn_model(NOLOCK)
	        WHERE  sourcecomponentname = 'PACKSLIP'
	        AND    sourceouinstid = @shippingpointml_hdn
	        AND    destinationcomponentname = 'ITEMADMN'
	    )	
	    SELECT @chk_kitconstituent = COUNT('X')
	    FROM   item_var_ou_vw a(NOLOCK),
	           item_ou_kitinfo_vw b(NOLOCK),
	           itemcim
	    WHERE  a.lo = @lo_item
	    AND    a.bu = @bu_item
	    AND    a.ou = itemou
	    AND    b.lo = @lo_item
	    AND    b.bu = @bu_item
	    AND  b.ou = itemou
	    AND    kit_code = @item_code_mul
	    AND    a.item_code = b.item_code
	    AND    a.variant_code = b.variant_code--ES_NSO_00538 
	    AND    a.status_code = 'AC'
	    AND    @trandate BETWEEN ISNULL(a.effective_from, @trandate) AND ISNULL(a.effective_to, @trandate)
	    
	    IF @chk_kitconstituent != @count_kitconstituent
	    BEGIN
	        EXEC fin_german_raiserror_sp 'NSO',
	             @ctxt_language,
	             129
	        select @errorid	=	1		--Code added for ITS ID : ES_SOMBL_00004 
	        RETURN
	    END--Added by Veangadakrishnan R for DTS ID: ES_PACKSLIP_00049
	END
	/*code added for DTS ID: DMS412AT_NSO_00056 ends here*/
	
	--NSODMS412AT_000501 begins
	--Fetching the Variant allowed flag
	SELECT @var_allwd = loi_variantallowd
	FROM   itm_loi_itemhdr(NOLOCK)
	WHERE  loi_lo = @lo_item
	AND    loi_itemcode = @item_code_mul
	
	IF (@var_allwd = '1')
	BEGIN
	    /*code added & modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00041 starts here*/
	    IF (
	           SELECT COUNT(variant_code)
	           FROM   item_var_ou_vw(NOLOCK)
	           WHERE  lo = @lo_item
	           AND    bu = @bu_item
	           AND    ou = @item_ou
	           AND    item_code = @item_code_mul
	           AND    variant_code IS NOT NULL
	           AND    @trandate BETWEEN ISNULL(effective_from, @trandate) AND 
	                  ISNULL(effective_to, @trandate)
	       ) >= 1
	    BEGIN
	        IF @variant_code_mul IS NULL
	        OR @variant_code_mul = '##'
	        OR @variant_code_mul = ''
	      BEGIN
	       EXEC fin_german_raiserror_sp 'NSO',
	                 @ctxt_language,
	  92
	            select @errorid	=	1			--Code added for ITS ID : ES_SOMBL_00004 
	            RETURN
	        END
	        /*Code added for ES_NSO_00311 begins*/
	        IF (@item_type_tmp != 'ML')
	        BEGIN
	            /*Code added for ES_NSO_00311 ends*/
	            
	            IF EXISTS (
	                   SELECT 'X'
	                   FROM   item_var_ou_vw(NOLOCK)
	                   WHERE  lo = @lo_item
	                   AND    bu = @bu_item
	                   AND    ou = @item_ou
	                   AND    item_code = @item_code_mul
	                   AND    variant_code = @variant_code_mul
	                   AND    @trandate BETWEEN ISNULL(effective_from, @trandate) 
	                          AND ISNULL(effective_to, @trandate)
	               )
	            BEGIN
	                /* Code Modified by Vairamani C for ES_NSO_00213 Starts here */
	                /*
	                if  not exists (	select	'X'
	                from	item_var_ou_vw(nolock)
	                where	lo				=	@lo_item
	                and		bu				=	@bu_item
	                and     ou 				=	@item_ou
	                and		item_code		=	@item_code_mul
	                and		variant_code	=	@variant_code_mul
	                and		status_code		=	'AC'
	                and		@trandate  between isnull(effective_from,@trandate) and isnull(effective_to,@trandate))
	                */
	                IF EXISTS 
	                   (
	                       SELECT 'X'
	                       FROM   item_var_ou_vw(NOLOCK)
	                       WHERE  lo = @lo_item
	                       AND    bu = @bu_item
	                       AND    ou = @item_ou
	                       AND    item_code = @item_code_mul
	                       AND    variant_code = @variant_code_mul
	                       AND    status_code = 'AC'
	                       AND    @trandate BETWEEN ISNULL(effective_from, @trandate) 
	                              AND ISNULL(effective_to, @trandate)
	                   )
	                BEGIN
	                    SELECT @ctxt_user = @ctxt_user
	                END
	                ELSE
	         /* Code Modified by Vairamani C for ES_NSO_00213 Ends here */
	                BEGIN
	           SELECT @m_errorid = 1372028
	                    RETURN
	                END
	            END
	            ELSE
	            BEGIN
	                /*Code modified by Damodharan. R on 08 Sep 2008 for Defect ID ES_NSO_00058 starts here*/
	                --exec fin_german_raiserror_sp 'NSO',@ctxt_language,93
	                --raiserror('Item variant combination is not Active or Effective.',16,1)
	                /*Code modified by Damodharan. R on 19 Jan 2009 for Defect ID ES_NSO_00139 starts here*/
	               --exec fin_german_raiserror_sp 'NSO',@ctxt_language,119
	                --Item variant combination at row no. %a is not Active or Effective.
	                EXEC fin_german_raiserror_sp 'NSO',
	                     @ctxt_language,
	                     143,
	                     @fprowno
	                /*Code modified by Damodharan. R on 19 Jan 2009 for Defect ID ES_NSO_00139 ends here*/
	                /*Code modified by Damodharan. R on 08 Sep 2008 for Defect ID ES_NSO_00058 ends here*/
	                select @errorid	=	1			--Code added for ITS ID : ES_SOMBL_00004 
	                RETURN
	            END
	        END--ES_NSO_00311
	    END--Count
	END--Var allowed
	ELSE
	BEGIN
	    /*Code added for ES_NSO_00311 begins*/
	    IF (@item_type_tmp != 'ML')
	    BEGIN
	        /*Code added for ES_NSO_00311 ends*/
	        IF EXISTS (
	               SELECT 'X'
	               FROM   item_var_ou_vw(NOLOCK)
	               WHERE  lo = @lo_item
	               AND    bu = @bu_item
	               AND    ou = @item_ou
	               AND    item_code = @item_code_mul
	               AND    variant_code = ISNULL(@variant_code_mul, '##')
	               AND    @trandate BETWEEN ISNULL(effective_from, @trandate) 
	                      AND ISNULL(effective_to, @trandate)
	           )
	        BEGIN
	            --select @m_errorid = 0
	            /* Code Modified by Vairamani C for ES_NSO_00213 Starts here */
	            /*
	            if not exists(	select	'X'
	            from	item_var_ou_vw(nolock)
	            where	lo				=	@lo_item
	            and		bu				=	@bu_item
	            and     ou 				=	@item_ou
	            and		item_code		=	@item_code_mul
	       and		variant_code	=	isnull(@variant_code_mul,'##')
	            and		status_code		=	'AC'
	            and		@trandate  between isnull(effective_from,@trandate) and isnull(effective_to,@trandate))
	            */
	            IF EXISTS
	               (
	                   SELECT 'X'
	                FROM   item_var_ou_vw(NOLOCK)
	                   WHERE  lo = @lo_item
	                   AND    bu = @bu_item
	                   AND    ou = @item_ou
	                   AND    item_code = @item_code_mul
	                   AND    variant_code = ISNULL(@variant_code_mul, '##')
	                   AND   status_code = 'AC'
	                   AND    @trandate BETWEEN ISNULL(effective_from, @trandate) 
	                          AND ISNULL(effective_to, @trandate)
	               )
	            BEGIN
	                SELECT @ctxt_user = @ctxt_user
	            END
	            ELSE
	                /* Code Modified by Vairamani C for ES_NSO_00213 Ends here */
	 BEGIN
	                SELECT @m_errorid = 1372028
	                RETURN
	            END
	   END
	        ELSE
	        BEGIN
	            /*Code modified by Damodharan. R on 08 Sep 2008 for Defect ID ES_NSO_00058 starts here*/
	            --exec fin_german_raiserror_sp 'NSO',@ctxt_language,93
	            --raiserror('Item variant combination is not Active or Effective.',16,1)
	            /*Code modified by Damodharan. R on 19 Jan 2009 for Defect ID ES_NSO_00139 starts here*/
	            --exec fin_german_raiserror_sp 'NSO',@ctxt_language,119
	            --Item variant combination at row no. %a is not Active or Effective.
	            EXEC fin_german_raiserror_sp 'NSO',
	                 @ctxt_language,
	                 143,
	                 @fprowno
	            /*Code modified by Damodharan. R on 19 Jan 2009 for Defect ID ES_NSO_00139 ends here*/
	            /*Code modified by Damodharan. R on 08 Sep 2008 for Defect ID ES_NSO_00058 ends here*/
	            select @errorid	=	1		--Code added for ITS ID : ES_SOMBL_00004 
	            RETURN
	        END
	    END--ES_NSO_00311
	       /*code added & modified by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00041 ends here*/
	END
	
	--NSODMS412AT_000501 ends
	--code added for NSODMS412AT_000158 ends
	-- defaulting shipping point from header
	IF @shippingpointml_hdn IS NULL
	    SELECT @shippingpointml_hdn = @shippingpoint_hdn
	
	--calling procedure for item ou
	EXEC scm_get_dest_ou @shippingpointml_hdn,
	     @ctxt_language,
	     @ctxt_user,
	     'PACKSLIP',
	     'ITEMADMN',
	     @item_ou OUT,
	     @m_errorid_tmp OUT
	
	IF @m_errorid_tmp <> 0
	BEGIN
	    --Packslip component to ItemAdmin component mapping is not present. Please Check
	    SELECT @m_errorid = 325093
	    RETURN
	END
	
	--calling procedure for getting lo and bu for item ou
	EXEC scm_get_emod_details @item_ou,
	     @trandate,
	     @lo_item OUT,
	     @bu_item OUT,
	     @m_errorid_tmp OUT
	
	IF @m_errorid_tmp <> 0
	BEGIN
	    SELECT @m_errorid = @m_errorid_tmp
	    RETURN
	END
	
	--Item existence check
	IF EXISTS (
	       SELECT 'X'
	       FROM   item_var_bu_vw(NOLOCK)
	       WHERE  lo = @lo_item
	       AND    bu = @bu_item
	       AND    item_code = @item_code_mul
	   )
	BEGIN
	  SELECT @item_code_mul = @item_code_mul
	           --dummy select
	END
	ELSE
	BEGIN
	    --<^item_code_mul!> "<%item_code_mul%>" does not exist. enter a valid <^item_code_mul!>
	    SELECT @m_errorid = 320506
	    RETURN
	END
	--fetching the item type, item weight and volume
	SELECT @item_type = CASE item_type_code
	                         WHEN 'KT' THEN 'K'
	                         WHEN 'SR' THEN 'S'
	                         WHEN 'ML' THEN 'M'
	                         ELSE 'I'
	                    END,
	       @item_wt = gross_wt,
	       @item_volume = volume
	FROM   item_var_bu_vw(NOLOCK)
	WHERE  lo = @lo_item
	AND    bu = @bu_item
	AND    item_code = @item_code_mul	
	
	/* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Begins */
	declare	@pono		udd_documentno
	
	select	@pono			=	sohdr_po_no
	from	so_order_hdr(nolock)
	where	sohdr_order_no	=	@order_no
	and		sohdr_ou		=	@ctxt_ouinstance
	
	if @pono is not null
	begin
		if @item_type in ('K','M')
		begin
			--Item code of type "Kit" or "Model" cannot be entered at Row No. "%d" as inter company transaction is applicable.
			exec fin_german_raiserror_sp 'PO',@ctxt_language,2024,@fprowno
			select @errorid	=	1			--Code added for ITS ID : ES_SOMBL_00004 
			return				
		end
		--13H120_Supp_00004:ES_Supp_00320[Phase II] Begins 
		if	@processingactionml_hdn = 'DROP'		
		begin
			-- Processing action at Row No. "%d" cannot be selected as "Drop" as inter company transaction is applicable.
			exec fin_german_raiserror_sp 'PO',@ctxt_language,2047,@fprowno
			select @errorid	=	1			--Code added for ITS ID : ES_SOMBL_00004 
			return			
		end
		
		if @qtyml <=0
		begin
			-- Quantity cannot be Zero at Row No. "%d" as Intercompany transaction is applicable.
			exec fin_german_raiserror_sp 'PO',@ctxt_language,2055,@fprowno
			select @errorid	=	1		--Code added for ITS ID : ES_SOMBL_00004 
			return				
		end
		--13H120_Supp_00004:ES_Supp_00320[Phase II] Ends
	end
	/* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Ends */
	
	IF @variant_code_mul IS NULL
	    --begin
	    SELECT @variant_code_mul = '##' 
	/*Code added for ES_NSO_00208 begins here*/
	IF @variant_code_mul IS NULL OR @variant_code_mul = '##' 
	BEGIN
		SELECT @itemvar_mul = @item_code_mul 
	END
	ELSE
	BEGIN
		SELECT @itemvar_mul = @item_code_mul + '-' + @variant_code_mul 
	END
	/*Code added for ES_NSO_00208 ends here*/
	-- 			if exists (	select 	'x'
	-- 					from	item_var_lo_vw (nolock)
	-- 					where	lo 			=	@lo_item
	-- 					and	item_code		=	@item_code_mul
	-- 					and	variant_alwd		=	1)
	-- 				begin
	-- 					--<^variant_code_mul!> cannot be null for <^item_code_mul!> "<%item_code_mul%>"
	--   					select @m_errorid = 320335
	-- 					return
	-- 				end
	--
	-- 		end
	-- 	else
	-- 		begin
	-- 			if	@item_type <> 'M'
	-- 				begin
	-- 					if(	select 	count('*')
	-- 						from	item_var_ou_vw (nolock)
	-- 						where	lo 			=	@lo_item
	-- 						and	bu			=	@bu_item
	-- 						and	ou			=	@item_ou
	-- 						and	item_code		=	@item_code_mul
	-- 						and	variant_code		=	@variant_code_mul
	-- 						and	@trandate between effective_from and isnull(effective_to,@trandate)) =0
	--
	-- 						begin
	-- 							--Invalid item & variant combination
	-- 							select @m_errorid = 321085
	-- 							return
	-- 						end
	-- 				end
	-- 		end
	
	IF @so_uomml IS NULL
	BEGIN
	    SELECT @so_uomml = sales_uom
	    FROM   item_ou_sales_info_vw(NOLOCK)
	    WHERE  ou = @item_ou
	    AND    item_code = @item_code_mul
	    AND    variant_code = @variant_code_mul
	    
	    --Added by Veangadakrishnan R for DTS ID: ES_PACKSLIP_00049 starts here
	    IF @item_type = 'K'
	        SELECT @so_uomml = 'KIT'
	    --Added by Veangadakrishnan R for DTS ID: ES_PACKSLIP_00049 ends here
	    
	    IF ISNULL(@so_uomml, '') = ''
	    BEGIN
	        SELECT @so_uomml = stock_uom
	        FROM   item_var_lo_vw(NOLOCK)
	        WHERE  lo = @lo
	        AND    item_code = @item_code_mul
	    END
	END
	
	-- uom null check
	IF @so_uomml IS NULL
	BEGIN
	    --<^so_uomml!> is null 
	    SELECT @m_errorid = 320509
	    RETURN
	END 
	
	--quantity null check
	/* Code modified by Raju against NSODms412at_000412 starts*/
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
	--if @ctxt_service in ('SO_AMMN_SER_SBT','SOPP_AMMN_SER_SBT','SOPP_AMMN_SER_AMAU','SOPP_AMMN_SER_AUTH','SOPP_AMMN_SER_AUAM') 
	IF @ctxt_service IN ('SO_AMMN_SER_SBT', 'SOPP_AMMN_SER_SBT', 
	                    'SOPP_AMMN_SER_AMAU', 'SOPP_AMMN_SER_AUTH', 
	                    'SOPP_AMMN_SER_AUAM', 'SO_AMMN_SER_SBT1', 
	                    'SOPP_AMMN_SER_SBT1', 'SOPP_AMMN_SER_AMAU1', 
	                    'SOPP_AMMN_SER_AUTH1', 'SOPP_AMMN_SER_AUAM1') 
	   /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
	BEGIN
	    SELECT @qtyml = ISNULL(@qtyml, 0)
	END
	ELSE
	BEGIN
	    /* Code modified by Raju against NSODms412at_000412 ends*/
	    IF @qtyml IS NULL
	    BEGIN
	        --<^qtyml!> = zero 
	        SELECT @m_errorid = 320507
	        RETURN
	    END
	END
	
	/* Code modified by Raju against NSODms412at_000412 starts*/
	IF @ctxt_service LIKE 'SOPP_%'
	BEGIN
	    IF EXISTS (
	           SELECT 'X'
	           FROM   so_order_item_dtl(NOLOCK)
	           WHERE sodtl_order_no = @order_no
	           AND    sodtl_line_no = @lineno
	           AND    sodtl_ou = @ctxt_ouinstance
	           AND    sodtl_req_qty <> @qtyml
	           AND    sodtl_uom = @so_uomml
	           AND    sodtl_pack_qty <> sodtl_invoiced_qty
	       )
	    AND ISNULL(@modeflag, 'I') <> 'I'
	    BEGIN
	        /*Code modified for Defect ID ES_NSO_00211 - SP analyser exception - begins*/
	        /*
	        declare @inc 			int
	        declare @packslipno 	udd_document
	        declare @pscount 		int
	        declare @sretcount 		int 
	        declare @line 			int
	        */
	        DECLARE @inc         udd_lineno
	        DECLARE @packslipno  udd_document
	        DECLARE @pscount     udd_int
	        DECLARE @sretcount   udd_int 
	        DECLARE @line        udd_lineno
	        /*Code modified for Defect ID ES_NSO_00211 - SP analyser exception - ends*/
	        
	        INSERT INTO so_ps_tmp
	        (psno,line,guid)
	        SELECT psd_pkslipno,
	               1,
	               @guid
	        FROM   ps_pack_slip_dtl(NOLOCK)
	        WHERE  psd_ordernumber = @order_no
	        AND    psd_ou = @ctxt_ouinstance
	        
	        UPDATE so_ps_tmp WITH (ROWLOCK)
	        SET    line = @lineno,
	         @lineno = @lineno + 1
	      WHERE  guid = @guid
	        
	        SELECT @inc = 1
	        
	        WHILE @inc <= @line
	        BEGIN
	            SELECT @packslipno = psno
	            FROM   so_ps_tmp(NOLOCK)
	            WHERE  line = @inc
	            AND    guid = @guid
	            
	            SELECT @pscount = COUNT('x')
	            FROM   ps_pack_slip_dtl(NOLOCK)
	            WHERE  psd_pkslipno = @packslipno
	            AND    psd_ou = @ctxt_ouinstance
	            
	            SELECT @sretcount = COUNT('x')
	            FROM   sret_return_item_dtl(NOLOCK)
	            WHERE  srdtl_pack_slip_no = @packslipno
	            AND    srdtl_ou = @ctxt_ouinstance
	            
	            IF @pscount <> @sretcount
	            BEGIN
	                /*code modified for NSODMS412AT_000498 starts*/
	                --raiserror('Amendment cannot be done as shipping is in progress for the item "%s" variant "%s"',16,1,@item_code_mul,@variant_code_mul) 
					/*Code modified for ES_NSO_00208 begins here*/
					/*
	                EXEC fin_german_raiserror_sp 'NSO',
	                     @ctxt_language,
	                     36, 
	                     @item_code_mul,
	                     @variant_code_mul,
	                     '',
	                     '',
	            '',
	                     '',
	         ''
					*/
	  EXEC fin_german_raiserror_sp 'NSO',
	     @ctxt_language,
						 1220,
						 @itemvar_mul
					/*Code modified for ES_NSO_00208 ends here*/				
	                /*code modified for NSODMS412AT_000498 ends*/
	                select @errorid	=	1			--Code added for ITS ID : ES_SOMBL_00004 
	                RETURN
	            END
	            
	            SELECT @inc = @inc + 1
	        END
	    END
	    
	    --code commented for Pete_Lien_NSO_BASEFIXES_001536 starts
	    --		if exists (select 'x' from so_order_item_dtl (nolock)
	    --			   where sodtl_order_no = @order_no
	    --			   and sodtl_line_no = @lineno
	    --			   and sodtl_ou = @ctxt_ouinstance
	    --			   and sodtl_req_qty <> @qtyml
	    --			   and sodtl_uom = @so_uomml
	    --			   and sodtl_req_qty = sodtl_invoiced_qty)  and isnull(@modeflag,'I') <> 'I'
	    --		begin
	    --			/*code modified for NSODMS412AT_000498 starts*/
	    ---- 			raiserror('Amendment cannot be done as for the line having item "%s" variant "%s" is closed',16,1,@item_code_mul,@variant_code_mul)
	    --			exec fin_german_raiserror_sp 'NSO',@ctxt_language,37,@item_code_mul,@variant_code_mul,'','','','',''
	    --			/*code modified for NSODMS412AT_000498 ends*/
	    --			return
	    --		end
	    --code commented for Pete_Lien_NSO_BASEFIXES_001536 ends

		--MKN-307	begins
		 select  @ShiptolerancePst_tmp	= (((@qtyml *	isnull(SOHdr_ship_tol_pos,0))/100)) ,  
				@ShiptoleranceNeg_tmp	= (((@qtyml *	isnull(sohdr_ship_tol_neg,0))/100))            
		from    so_order_hdr(nolock)    ,  so_order_item_dtl (nolock)
		where	sohdr_ou		=	@ctxt_ouinstance
		and		sohdr_order_no	=	@order_no  
		and		sodtl_ou		=	sohdr_ou 
		and		sodtl_order_no	=	sohdr_order_no
		and		sodtl_line_no	=	@lineno

		EXEC scm_sp_precisiontype_rtr
				'PACKSLIP',
				'UDD_QUANTITY',
				@precision_out OUTPUT,
				@ctxt_ouinstance
		
		select	@ShiptolerancePst_tmp	=	ROUND(@ShiptolerancePst_tmp, @precision_out)
		select	@ShiptoleranceNeg_tmp	=	ROUND(@ShiptoleranceNeg_tmp, @precision_out)
		--MKN-307	ends
	    
	    IF EXISTS (
	           SELECT 'X'
	           FROM   so_order_item_dtl(NOLOCK)
	           WHERE  sodtl_order_no = @order_no
	           AND    sodtl_line_no = @lineno
	           AND    sodtl_ou = @ctxt_ouinstance
	           --AND    sodtl_pick_qty > @qtyml --code commented for MKN-307
			   AND    sodtl_pick_qty > (@qtyml	+	isnull(@ShiptolerancePst_tmp,0))--Code added for MKN-307
	       )
	    AND ISNULL(@modeflag, 'I') <> 'I'
	    BEGIN
	        /*code modified for NSODMS412AT_000498 starts*/
	        --raiserror('The required quantity for the item "%s" variant "%s" cannot be less than the original picked quantity since it has been already picked.',16,1,@item_code_mul,@variant_code_mul) 
			/*Code modified for ES_NSO_00208 begins here*/
			/*
	        EXEC fin_german_raiserror_sp 'NSO',
	             @ctxt_language,
	             38,
	             @item_code_mul,
	             @variant_code_mul,
	             '',
	             '',
	             '',
	             '',
	             ''
			*/
	        EXEC fin_german_raiserror_sp 'NSO',
	             @ctxt_language,
				 1221,
				 @itemvar_mul
			/*Code modified for ES_NSO_00208 ends here*/
	        /*code modified for NSODMS412AT_000498 ends*/
	        select @errorid	=	1			--Code added for ITS ID : ES_SOMBL_00004 
	        RETURN
	    END
	    
	    IF EXISTS (
	           SELECT 'X'
	           FROM   so_order_item_dtl(NOLOCK)
	           WHERE  sodtl_order_no = @order_no
	           AND    sodtl_line_no = @lineno
	           AND   sodtl_ou = @ctxt_ouinstance
	        --AND    sodtl_invoiced_qty > @qtyml	--code commented for MKN-307
			   AND    sodtl_invoiced_qty > (@qtyml	+	isnull(@ShiptolerancePst_tmp,0))--Code added for MKN-307
	       )
	    AND ISNULL(@modeflag, 'I') <> 'I'
	    BEGIN
	        /*code modified for NSODMS412AT_000498 starts*/
	        --raiserror('The required quantity for the item "%s" variant "%s" cannot be less than the original packslip quantity since it has been already invoiced.',16,1,@item_code_mul,@variant_code_mul) 
			/*Code modified for ES_NSO_00208 begins here*/
			/*
	   EXEC fin_german_raiserror_sp 'NSO',
	             @ctxt_language,
	             39,
	             @item_code_mul,
	             @variant_code_mul,
	             '',
	             '',
	             '',
	             '',
	             ''
			*/
	        EXEC fin_german_raiserror_sp 'NSO',
	             @ctxt_language,
				 1222,
				 @itemvar_mul
			/*Code modified for ES_NSO_00208 ends here*/
	        /*code modified for NSODMS412AT_000498 ends*/
	        select @errorid	=	1				--Code added for ITS ID : ES_SOMBL_00004 
	  RETURN
	    END
	END
	/* Code modified by Raju against NSODms412at_000412 ends*/
	
	-- defaulting from header and null check for required date
	IF @reqddateml IS NULL
	BEGIN
	    SELECT @reqddateml = @reqddate
	    --if	upper(@ctxt_service)	<> 'SO_CPCR_SBT_SER'
	    --begin
	    IF @reqddateml IS NULL
	    BEGIN
			--ES_NSO_00602 starts
			if exists(Select 'Y' 
						from	pps_feature_list (nolock)
						where	feature_id		= 'PPS_TRIG_FID_004'
						and		flag_yes_no	= 'YES')
				select	@reqddateml	=	@orderdate
			else
			begin
			--ES_NSO_00602 ends
				--<^reqddateml!> cannot be null. enter a valid <^reqddateml!>
				SELECT @m_errorid = 320497
				RETURN
			end--ES_NSO_00602
	    END--end
	END 
	
	---- defaulting from header and null check for promised date
	IF @promiseddateml IS NULL
	BEGIN
	    SELECT @promiseddateml = @promiseddate
	    --if	upper(@ctxt_service)	<> 'SO_CPCR_SBT_SER'
	    --begin
	    IF @promiseddateml IS NULL
	    BEGIN
			--ES_NSO_00602 starts
			if exists(Select 'Y' 
						from	pps_feature_list (nolock)
						where	feature_id		= 'PPS_TRIG_FID_004'
						and		flag_yes_no	= 'YES')
				select	@promiseddateml	=	@orderdate
			else
			begin
			--ES_NSO_00602 ends
				--<^promiseddateml!> cannot be null. enter a valid <^promiseddateml!>
				SELECT @m_errorid = 320499
				RETURN
			end--ES_NSO_00602
	    END--end
	END 
	-- defaulting from header and null check for pricing date
	IF @pricingdateml IS NULL
	BEGIN
	    SELECT @pricingdateml = @pricingdate
	    IF @pricingdateml IS NULL
	        SELECT @pricingdateml = @orderdate
	END 
	
	-- defaulting transportation mode from header
	IF @trans_modeml IS NULL
	    SELECT @trans_modeml = @trans_mode 
	-- defaulting  ship to customercode from header
	IF @shipcustcodeml IS NULL
	    SELECT @shipcustcodeml = @shipcustcode 
	-- defaulting  ship to address id from header
	IF @shiptoaddidml IS NULL
	    SELECT @shiptoaddidml = @shiptoaddid 
	--defaulting warehouse from header
	IF @warehouse_code_mul IS NULL
	AND @processingactionml_hdn <> 'DROP'
	    --ES_NSO_00257
	    SELECT @warehouse_code_mul = @warehouse
	--Code  Added for NSODMS412AT_000055 begins here
	IF @item_type IN ('S', 'M')
	    SELECT @warehouse_code_mul = ''
	
	--Commented for DTS ID: ES_NSO_00112 starts here
	--	if @processingactionml_hdn = 'DROP'
	--		select	@warehouse_code_mul = ''
	--Commented for DTS ID: ES_NSO_00112 ends here
	
	--Code Commented And Added for NSODMS412AT_000055 ends here
	--defaulting usagecccode from header
	IF @usagecccodeml IS NULL
	    SELECT @usagecccodeml = @usagecccode 
	--defaulting sales person code from header 
	IF @spcodeml IS NULL
	    SELECT @spcodeml = @spcode
	
	--Damodharan added for OTS ID NSODMS412AT_000526 begins
	IF @fb_docml IS NULL
	AND @fb_doc IS NOT NULL
	    --NSODMS412AT_000551
	    SELECT @fb_docml = @fb_doc
	--Damodharan added for OTS ID NSODMS412AT_000526 ends	
	
	/* Code added by Damodharan. R on 30 Oct 2007 for OTS ID NSODMS412AT_000551 starts here */
	IF @fb_docml IS NULL
	AND @fb_doc IS NULL
	BEGIN
	    SELECT @fb_docml = wh_finance_book
	    FROM   sa_warehouse_master_vw(NOLOCK)
	    WHERE  wh_ou = @ctxt_ouinstance
	    AND    wh_code = @warehouse_code_mul
	END
	/* Code added by Damodharan. R on 30 Oct 2007 for OTS ID NSODMS412AT_000551 ends here */
	
	/* Code added for ES_NSO_01073 starts here */
	if @fb_docml is not null
	begin
			if exists (	select	'X'
				from	emod_fb_user_mapping (nolock)
				where	bfg_code	= 'SHIP'
				and		component_id= 'NSO'
				and		ou_id		= @ctxt_ouinstance
				and	    isnull(effective_from,@trandate)	<=	@trandate
				and	    isnull(effective_to,@trandate)	>=	@trandate )
			begin
				if exists (	select	'X'
								from	emod_fb_user_mapping (nolock)
								where	userid		= @ctxt_user	
								and		fbid		= @fb_docml
								and		bfg_code	= 'SHIP'
								and		component_id= 'NSO'
								and		ou_id		= @ctxt_ouinstance
								and	    isnull(effective_from,@trandate)	<=	@trandate
								and	    isnull(effective_to,@trandate)	>=	@trandate )
				BEGIN
					SELECT @fb_docml = @fb_docml
				END
				ELSE
				BEGIN
					exec fin_german_raiserror_sp 'NSO',@ctxt_language,2028,@fprowno
					--raiseerror('FINANCE BOOK NOT MAPPED TO USER AT ROW No. <>')
				END	
			end
	end
	/* Code added for ES_NSO_01073 ends here */
	
	--calling procedure for getting lo and bu for customer ou
	EXEC scm_get_emod_details @cust_ou,
	     @trandate,
	     @lo OUT,
	     @cust_bu OUT,
	     @m_errorid_tmp OUT
	
	IF @m_errorid_tmp <> 0
	BEGIN
	    SELECT @m_errorid = @m_errorid_tmp
	    RETURN
	END
	
	IF @item_type <> 'M'
	BEGIN
	    -- calling item validation procedure     
	    EXEC scm_item_shp_point_val @ctxt_ouinstance,
	         @ctxt_language,
	         @ctxt_user,
	         @ctxt_service,
	         'NSO',
	         @shippingpointml_hdn,
	         @item_code_mul,
	         @variant_code_mul,
	         @processingactionml_hdn,
	         0,
	      @m_errorid_tmp OUTPUT,
	         @error_msg_qualifier OUTPUT,
	         @m_error_flag OUTPUT
	    
	    
	    IF @m_errorid_tmp <> 0
	    BEGIN
	        SELECT @m_errorid = @m_errorid_tmp
	        RETURN
	    END
	END 
	--model item and varaint combination validtion
	IF @item_type = 'M'
	BEGIN
	    SELECT @flag = 1 
	    -- calling item validation procedure     
	    EXEC scm_model_item_var_val @ctxt_ouinstance,
	         @ctxt_language,
	         @ctxt_user,
	         @ctxt_service,
	         'NSO',
	         @lo,
	         @item_code_mul,
	         @variant_code_mul,
	         0,
	         @m_errorid_tmp OUTPUT,
	         @error_msg_qualifier OUTPUT,
	         @m_error_flag OUTPUT
	    
	    
	    IF @m_errorid_tmp <> 0
	    BEGIN
	        SELECT @m_errorid = @m_errorid_tmp
	        RETURN
	    END
	END
	
	--code for model items
	IF @item_type = 'M'
	BEGIN
	    SELECT @model_config_code = @item_code_mul,
	           @model_config_var = @variant_code_mul
	           --from
	END
	ELSE
	BEGIN
	    SELECT @model_config_code = NULL,
	           @model_config_var = NULL
	END 
	
	--calling procedure for uom ou
	EXEC scm_get_dest_ou @ctxt_ouinstance,
	     @ctxt_language,
	     @ctxt_user,
	     'NSO',
	     'UOMADMIN',
	     @uom_ou OUT,
	     @m_errorid_tmp OUT	
	
	
	IF @m_errorid_tmp <> 0
	BEGIN
	    --Normal Sale Order component to UomAdmin component mapping is not present. Please Check
	    SELECT @m_errorid = 325094
	    RETURN
	END
	
	IF @item_type NOT IN ('K', 'M')
	BEGIN
	    -- calling uom validation procedure
	    EXEC scm_sale_uom_val @uom_ou,
	         @ctxt_language,
	         @ctxt_user,
	         @ctxt_service,
	         'NSO',
	         @uom_ou,
	         @so_uomml,
	         0,
	         @m_errorid_tmp OUTPUT,
	         @error_msg_qualifier OUTPUT,
	         @m_error_flag OUTPUT 
	    
	   IF @m_errorid_tmp <> 0
	    BEGIN
	        SELECT @m_errorid = @m_errorid_tmp
	        RETURN
	    END
	END
	
	SELECT @frac_allowed = uom_fraction_allowed
	FROM   uom_master_vw(NOLOCK)
	WHERE  uom_ou = @uom_ou
	AND    uom_code = @so_uomml			
	
	IF @frac_allowed = 0
	BEGIN
	    SELECT @qty_c = CEILING(@qtyml)
	    SELECT @qty_c = @qty_c - @qtyml
	    
	    IF @qty_c > 0
	    BEGIN
	        --UOM code does not allow the fractions
	        SELECT @m_errorid = 321087
	        RETURN
	    END
	END 
	-----------------------------------------------------------
	--quantity validation
	IF @qtyml < 0
	BEGIN
	    --quantity should not be less than zero
	    /* Code modified by Damodharan. R on 26 Nov 2007 for OTS ID NSODMS412AT_000589 starts here */
	    --select @m_errorid = 320697
	    EXEC fin_german_raiserror_sp 'NSO',
	         @ctxt_language,
	         69
	    /* Code modified by Damodharan. R on 26 Nov 2007 for OTS ID NSODMS412AT_000589 ends here */
	    select @errorid	=	1				--Code added for ITS ID : ES_SOMBL_00004 
	    RETURN
	END 
	/* Code modified by Raju against NSODms412at_000412 starts*/
	-- 	if	@qtyml = 0 and upper(@ctxt_service) <>'SO_AMMN_SER_SBT' and isnull(@line_status,'') <> 'AM'
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
	--if	@qtyml = 0 and @ctxt_service not in ('SO_AMMN_SER_SBT','SOPP_AMMN_SER_SBT','SOPP_AMMN_SER_AMAU','SOPP_AMMN_SER_AUTH','SOPP_AMMN_SER_AUAM') and isnull(@line_status,'') not in ('AM', 'AU') --<> 'AM' --NSODms412at_000414
	IF @qtyml = 0
	AND @ctxt_service NOT IN ('SO_AMMN_SER_SBT', 'SOPP_AMMN_SER_SBT', 
	                         'SOPP_AMMN_SER_AMAU', 'SOPP_AMMN_SER_AUTH', 
	                         'SOPP_AMMN_SER_AUAM', 'SO_AMMN_SER_SBT1', 
	                         'SOPP_AMMN_SER_SBT1', 'SOPP_AMMN_SER_AMAU1', 
	                         'SOPP_AMMN_SER_AUTH1', 'SOPP_AMMN_SER_AUAM1')
	AND ISNULL(@line_status, '') NOT IN ('AM', 'AU') --<> 'AM' --NSODms412at_000414
	    /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
	    /* Code modified by Raju against NSODms412at_000412 ends*/
	BEGIN
	    --quantity should not be less than zero
	    /* Code modified by Damodharan. R on 26 Nov 2007 for OTS ID NSODMS412AT_000589 starts here */
	    --select @m_errorid = 320697
	    EXEC fin_german_raiserror_sp 'NSO',
	         @ctxt_language,
	         69
	 /* Code modified by Damodharan. R on 26 Nov 2007 for OTS ID NSODMS412AT_000589 ends here */
	    select @errorid	=	1			--Code added for ITS ID : ES_SOMBL_00004 
	    RETURN
	END 
	
	/*code added for EPE-87134 starts*/
	IF @qtyml = 0 and @ctxt_service in( 'SOPP_AMMN_SER_SBT1', 'SOPP_AMMN_SER_AUAM1','sopp_ammn_ser_auth1')--amend and amend &authorize auth
	begin
	--Quantity should be greater than zero.
		EXEC fin_german_raiserror_sp 'ServSal',@ctxt_language,1033
		return
	end
	/*code added for EPE-87134 ends*/
	
	-- 	if	@lineno is null and upper(@ctxt_service) = 'SO_AMMN_SER_SBT' and @qtyml <=0
	/* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 starts here */
	--if	@lineno is null and @ctxt_service in ('SO_AMMN_SER_SBT','SOPP_AMMN_SER_SBT','SOPP_AMMN_SER_AMAU','SOPP_AMMN_SER_AUAM') and @qtyml <=0 and isnull(@modeflag,'I') <> 'I'
	IF @lineno IS NULL
	AND @ctxt_service IN ('SO_AMMN_SER_SBT', 'SOPP_AMMN_SER_SBT', 
	                     'SOPP_AMMN_SER_AMAU', 'SOPP_AMMN_SER_AUAM', 
	                     'SO_AMMN_SER_SBT1', 'SOPP_AMMN_SER_SBT1', 
	                     'SOPP_AMMN_SER_AMAU1', 'SOPP_AMMN_SER_AUAM1')
	AND @qtyml <= 0
	AND ISNULL(@modeflag, 'I') <> 'I'
	    
	    
	    
	    
	    /* Code modified by Damodharan. R on 08 Aug 2007 for OTS ID NSODMS412AT_000505 ends here */
	BEGIN
	    --quantity should not be less than zero
	    /* Code modified by Damodharan. R on 26 Nov 2007 for OTS ID NSODMS412AT_000589 starts here */
	    --select @m_errorid = 320697
	    EXEC fin_german_raiserror_sp 'NSO',
	         @ctxt_language,
	         69
	    /* Code modified by Damodharan. R on 26 Nov 2007 for OTS ID NSODMS412AT_000589 ends here */
	    select @errorid	=	1				--Code added for ITS ID : ES_SOMBL_00004 
	    RETURN
	END  
	
	IF @rateml < 0
	BEGIN
	    --^RateML! cannot be Null or negative at row : <fprowno>
	    SELECT @m_errorid = 320339
	    RETURN
	END 
	
	-- defaulting   processing action  from header
	IF @processingactionml_hdn IS NULL
	    SELECT @processingactionml_hdn = @processingaction_hdn
	 
	--Code commented for DTS ID: 9H123-1_DR_00001 starts here
	/*code added for DTS ID: ES_PACKSLIP_00204 starts here*/
	--	if @processingactionml_hdn = 'DROP' and (((	select	sohdr_lc_appl_flag
	--												from	sotmp_order_hdr(nolock)
	--												where	sohdr_ou	= @ctxt_ouinstance
	--												and		sohdr_guid	= @guid) = 'Y') or
	--											 ((	select	sohdr_lc_appl_flag
	--												from	so_order_hdr(nolock)
	--												where	sohdr_ou		= @ctxt_ouinstance
	--												and		sohdr_order_no	= @order_no) = 'Y'))
	--	begin
	--		exec fin_german_raiserror_sp 'NSO',@ctxt_language,1036
	--		return
	--	end
	/*code added for DTS ID: ES_PACKSLIP_00204 ends here*/
	--Code commented for DTS ID: 9H123-1_DR_00001 ends here
	
	--code added for ES_NSO_00108 starts
	IF @ctxt_service IN ('sopp_AmMn_ser_AuAm1', 'sopp_AmMn_ser_Auth1', 
	                    'sopp_AmMn_ser_Sbt1')                
	BEGIN
	    DECLARE @soprevstatus  udd_statuscode,
	            @solinestatus  udd_statuscode
				,@qty_prev	   udd_quantity--13H120_Supp_00004:ES_Supp_00320
				
	    SELECT @soprevstatus = sodtl_line_prev_status,
	           @solinestatus = sodtl_line_status
	    FROM   so_order_item_dtl(NOLOCK)
	    WHERE  sodtl_ou = @ctxt_ouinstance
	    AND    sodtl_order_no = @order_no
	    AND    sodtl_line_no = @lineno
	    
	    /* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Begins */
	    select	@qty_prev	 = sodtl_req_qty
	    from	sohist_order_item_dtl(nolock),
				so_order_hdr(nolock)
	    where	sodtl_order_no=	@order_no
	    and		sodtl_amend_no= sohdr_amend_no - 1
	    and		sodtl_line_no = @lineno
	    and		sodtl_ou	  = @ctxt_ouinstance
	    and		sodtl_order_no=	sohdr_order_no
	    and		sodtl_ou	  = sohdr_ou
	    
	    if @pono is not null
	    begin
			if @qty_prev <> @qtyml
			begin
				--Quantity cannot be modified at Row No. "%d" as intercompany transaction is applicable.
				exec fin_german_raiserror_sp 'PO',@ctxt_language,2025,@fprowno
				select @errorid	=	1			--Code added for ITS ID : ES_SOMBL_00004 
				return					
			end
	    end
	    /* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Ends */
	    IF @solinestatus = 'FR'
	    AND @soprevstatus IS NULL
	    BEGIN
	        SELECT @ctxt_ouinstance = @ctxt_ouinstance
	    END
	    ELSE
	    BEGIN
	        IF EXISTS (
	               SELECT 'X'
	               FROM   so_order_item_dtl(NOLOCK)
	               WHERE  sodtl_order_no = @order_no
	               AND    sodtl_line_no = @lineno
	               AND    sodtl_ou = @ctxt_ouinstance
	               AND    sodtl_proc_action_dflt <> @processingactionml_hdn
	               AND    (sodtl_pick_qty + sodtl_bill_hold_qty + sodtl_pack_qty) > 0 -- code added for ITS ID: ES_NSO_00693
	           )
	        BEGIN
	            --raiserror('Processing Action Cannot be changed at row no.%d',16,1,@fprowno)
	            EXEC fin_german_raiserror_sp 'NSO',
	                 @ctxt_language,
	                 147,
	                 @fprowno
	            select @errorid	=	1		--Code added for ITS ID : ES_SOMBL_00004 
	            RETURN
	      END
	    END
	END

	--code added for ES_NSO_00108 ends
	
	IF @item_type IN ('M', 'K', 'S')
	BEGIN
	    IF @processingactionml_hdn = 'DROP'
	    BEGIN
	        IF @ctxt_service NOT LIKE 'SOPP_%'
	        BEGIN
	            --Model, Kit and Service Items Cannot have Drop Ship as the Processing Action. Please Check
	            SELECT @m_errorid = 325263
	            RETURN
	        END
	        ELSE
	  BEGIN
	            --Kit, Service and Model Items cannot have Drop Ship as the processing action. Please check
	            SELECT @m_errorid = 3550336
	            RETURN
	        END
	    END
	END
	
	--Added for DTS ID: ES_NSO_00112 starts here
	IF @processingactionml_hdn = 'DROP'
	--code commented and added for SCLRES-707
	--AND DATALENGTH(ISNULL(@warehouse_code_mul, '')) != 0
	AND LEN(ISNULL(@warehouse_code_mul, '')) != 0
	--code commented and added for SCLRES-707
	BEGIN
	    --raiserror('Warehouse code should be blank for Process Action "DROP" at row no.%d',16,1,@fprowno)
	    EXEC fin_german_raiserror_sp 'NSO',
	         @ctxt_language,
	         125,
	         @fprowno
	    select @errorid	=	1			--Code added for ITS ID : ES_SOMBL_00004 
	    RETURN
	END
	--Added for DTS ID: ES_NSO_00112 ends here
	
	-- If Sale Order Type = "Consignment" and if the Item Type on any data row = "Model" or "Kit" or "Service" display error
	IF @sale_ord_type = 'CSO'
	BEGIN
	    IF @item_type = 'K'
	    OR @item_type = 'S'
	    OR @item_type = 'M'
	    BEGIN
	        --<^sale_ord_type!> "<%sale_ord_type%>" cannot ship models 
	        SELECT @m_errorid = 320061
	        RETURN
	  END
	    
	    IF @processingactionml_hdn = 'DROP'
	    BEGIN
	        --<^sale_ord_type!> "<%sale_ord_type%>" cannot have <^processingactionml!> "<%processingactionml%>"
	        SELECT @m_errorid = 320451
	        RETURN
	    END
	END
	
	--If the item type is a Model or a Kit, Quantity cannot contain decimal values. If it has display Error
	IF @item_type = 'K'
	OR @item_type = 'M'
	BEGIN
	    SELECT @qty_c = CEILING(@qtyml)
	    SELECT @qty_c = @qty_c - @qtyml
	    
	    IF @qty_c > 0
	    BEGIN
	        --<^item_type_mul!> model or kit cannot contain decimal values
	        SELECT @m_errorid = 320337
	        RETURN
	    END
	END 
	
	--fetching the production usage and purchage usage
	SELECT --@planning_type	=	planning_type,
	       @prodn_usage = prodn_usage,
	       @purch_source = purch_source,
	       @stockableflag = stockable_flag,
	       @sales_usage = sales_usage
	FROM   item_var_ou_vw(NOLOCK)
	WHERE  ou = @item_ou
	AND    item_code = @item_code_mul
	AND    variant_code = CASE @flag
	                           WHEN 1 THEN '##'
	                           ELSE @variant_code_mul
	                      END
	                      
	--code added for ES_NSO_00538 starts
	if exists(select '*' from ops_processparam_sys (nolock) 
				where ou_id = @ctxt_ouinstance
				and parameter_type		= 'INVSYS'
				and parameter_category	= 'CMN_FIN_INSTAL'
				and parameter_code		= 'N') and @FID = 'YES'
	begin
		select @ctxt_ouinstance = @ctxt_ouinstance --dummy statement
	end
	else
	begin
	--code added for ES_NSO_00538 ends
		IF @ctxt_service LIKE 'SOPP_%'
		BEGIN
			IF (@sales_usage <> '1')
			BEGIN
				--<^item_code_mul!> "<%item_code_mul%>" is not saleable item
				/*Code modified for ES_NSO_00208 begins here*/
				--select @m_errorid = 3550382
				EXEC fin_german_raiserror_sp 'NSO',
					 @ctxt_language,
					 1219,
					 @itemvar_mul,
					 @fprowno
				/*Code modified for ES_NSO_00208 ends here*/
				select @errorid	=	1				--Code added for ITS ID : ES_SOMBL_00004 
				RETURN
			END
		END
	end--code added for ES_NSO_00538
	
	--fetching the stock uom
	SELECT @stock_uom_tmp = stock_uom
	       --@stockableflag		=	stockable
	FROM   item_var_lo_vw(NOLOCK)
	WHERE  lo = @lo
	AND    item_code = @item_code_mul
	AND    variant_code = CASE @flag
	                           WHEN 1 THEN '##'
	                           ELSE @variant_code_mul
	                      END
	
	--fetching the stock quantity
	--	if	@stock_uom_tmp is not null
	IF @item_type = 'M'
	BEGIN
	    EXEC scm_uom_conversion_fet @ctxt_language,
	         @shippingpointml_hdn,
	         @ctxt_service,
	         @ctxt_user,
	         @item_code_mul,
	  '##',
	         @so_uomml,
	   'PACKSLIP',
	         @confactor OUT,
	         @execflag OUT,
	         @m_errorid_tmp OUT
	    
		--code added for BE-1123 begins
		IF @m_errorid_tmp =1261261
	    BEGIN
	        EXEC fin_german_raiserror_sp 'ProductConversion',@ctxt_language,1007,@item_code_mul
	        RETURN
	    END
		--code added for BE-1123 ends

	    IF @m_errorid_tmp <> 0
	    BEGIN
	        SELECT @m_errorid = @m_errorid_tmp 
	        RETURN
	    END
	END
	ELSE
	BEGIN
	    EXEC scm_uom_conversion_fet @ctxt_language,
	         @shippingpointml_hdn,
	         @ctxt_service,
	     @ctxt_user,
	         @item_code_mul,
	         @variant_code_mul,
	         @so_uomml,
	         'PACKSLIP',
	         @confactor OUT,
	         @execflag OUT,
	         @m_errorid_tmp OUT
	    
		--code added for BE-1123 begins
		IF @m_errorid_tmp =1261261
	    BEGIN
	        EXEC fin_german_raiserror_sp 'ProductConversion',@ctxt_language,1007,@item_code_mul
	        RETURN
	    END
		--code added for BE-1123 ends

	    IF @m_errorid_tmp <> 0
	    BEGIN
	        SELECT @m_errorid = @m_errorid_tmp 
	        RETURN
	    END
	END 
	
	-- 	if @so_uomml <> @stock_uom_tmp
	-- 		begin
	-- 			exec	 uom_sp_get_convfactor	@ctxt_ouinstance,
	-- 							@so_uomml,
	-- 							@stock_uom_tmp,
	-- 							@confactor out,
	-- 							@execflag out,
	-- 							@m_errorid_tmp out
	--
	--
	-- 		end
	
	/*Code added by Damodharan. R on 12 May 2009 for Defect ID ES_NSO_00237 starts here*/
	IF EXISTS (
	       SELECT 'X'
	       FROM   item_var_ou_vw(NOLOCK)
	       WHERE  lo = @lo_item
	       AND    bu = @bu_item
	       AND    ou = @item_ou
	       AND    item_code = @item_code_mul
	       AND    variant_code = ISNULL(@variant_code_mul, '##')
	       AND    stockable_flag = 1
	   )
	BEGIN
	    /*Code added by Damodharan. R on 12 May 2009 for Defect ID ES_NSO_00237 ends here*/
	    /*Code added by Damodharan. R on 27 Apr 2009 for Defect ID ES_NSO_00211 starts here*/
	    IF @ctxt_service IN ('SOPP_CRMN_SER_SBT1', 'SOPP_CRMN_SER_CRAU1', 
	                        'SOPP_CRMN_SER_EDT1', 'SOPP_CRMN_SER_AUTH1')
	    BEGIN
	        IF @so_uomml <> @stock_uom_tmp
	        BEGIN
			--code added for ES_NSO_00353 starts
				select @variant_code_mul = isnull(@variant_code_mul,'##')
	            /*if uom conversion is not available in item, then take from uom*/                        
	            EXEC itm_sp_get_uomconvfactor 
	                 @item_ou,
	               @item_code_mul,
	                 @variant_code_mul,
	                 @so_uomml,
	                 @stock_uom_tmp,
	                 @confactor OUT,
	                 @execflag OUT,
	                 @m_errorid_tmp OUT  

				IF @execflag <> 0
				BEGIN
			--code added for ES_NSO_00353 ends
	            EXEC uom_sp_get_convfactor @ctxt_ouinstance,
	                 @so_uomml,
	                 @stock_uom_tmp,
	                 @confactor OUT,
	                 @execflag OUT,
	        @m_errorid_tmp OUT
	            
	            IF @m_errorid_tmp <> 0
	            AND @confactor IS NULL
	            BEGIN
	                /*Code modified by Damodharan. R on 28 Apr 2009 for Defect ID ES_NSO_00211 starts here*/
	                --UOM conversion does not exist
	                --select @m_errorid = 3550379
	                --UOM conversion does not exist between Sales UOM and Stock UOM in line no. %a
	                SELECT @m_errorid = 3550380
	                /*Code modified by Damodharan. R on 28 Apr 2009 for Defect ID ES_NSO_00211 ends here*/
	                RETURN
	            END
			END--code added for ES_NSO_00353	
	        END
	    END/*Code added by Damodharan. R on 27 Apr 2009 for Defect ID ES_NSO_00211 ends here*/
	END --Code added by Damodharan. R on 12 May 2009 for Defect ID ES_NSO_00237
	
	IF @confactor IS NULL
	    SELECT @stock_qty = @qtyml
	ELSE
	    SELECT @stock_qty = dbo.scm_uom_get_round_qty_fn (
	       @ctxt_ouinstance,
	               'NSO',
	               @so_uomml,
	               @trandate,
	               @qtyml * @confactor,
	               'UDD_QUANTITY'
	           )
	--code added for NSODMS412AT_000359 starts
	SELECT @frac_allowed_stkuom = uom_fraction_allowed
	FROM   uom_master_vw(NOLOCK)
	WHERE  uom_ou = @uom_ou
	AND    uom_code = @stock_uom_tmp	
	
	IF @frac_allowed_stkuom = 0
	BEGIN
		--code added by vasantha a for ES_NSO_01118 begins 
		if @confactor is not null 
			SELECT @stock_qty =ROUND(@stock_qty,0) 
		--code added by vasantha a for ES_NSO_01118 ends 
		
	    IF @stock_qty <> CEILING(ISNULL(@stock_qty, 0))
	    BEGIN
	        --raiserror('stock uom does not allow fractions',16,1)
	        SELECT @m_errorid = 1261261
	        RETURN
	    END
	END
	--code added for NSODMS412AT_000359 ends
	
	/*Code added by Ananth P. against: ES_NSO_00164 Begins*/
	IF @ctxt_service IN ('sopp_crmn_ser_sbt1', 'sopp_crmn_ser_crau1', 
	                    'sopp_crmn_ser_edt1', 'sopp_crmn_ser_auth1', 
						/*Code modified by Indu on 19-Mar-2010 for ES_SOD_00005 Begins*/						
	                    --'so_rledmn_ser_genrel', 'so_rlcrmn_ser_genrel')--ES_NSO_00185
						'so_rledmn_ser_genrel', 'so_rlcrmn_ser_genrel','SOD_MNORD_SER_CRSO',
						'sopp_ammn_ser_sbt1','sopp_ammn_ser_auam1','sopp_ammn_ser_auth1','sopp_crmn_ser_edt1' )--code added for ES_NSO_01309 
						/*Code modified by Indu on 19-Mar-2010 for ES_SOD_00005 Ends*/
	BEGIN
	    IF @processingactionml_hdn IS NULL
	    BEGIN
	        IF @prodn_usage = 1
	            SELECT @processingactionml_hdn = 'MAKE'
	        ELSE 
	        IF @purch_source = 1
	            SELECT @processingactionml_hdn = 'BUY'
	        ELSE
	            SELECT @processingactionml_hdn = 'MAKE'
	    END
	END
	/*Code added by Ananth P. against: ES_NSO_00164 Ends*/
	
	--code modified for ES_NSO_00108 starts
	/* code commented for ES_NSO_01309 begins */
	--IF @ctxt_service IN ('sopp_AmMn_ser_AuAm1', 'sopp_AmMn_ser_Auth1', 
	--                    'sopp_AmMn_ser_Sbt1')
	--BEGIN
	--    IF @processingactionml_hdn IS NULL
	--    BEGIN
	--        --raiserror('Processing Action Cannot be blank at row no.%d',16,1,@fprowno)
	--        EXEC fin_german_raiserror_sp 'NSO',
	--             @ctxt_language,
	--             146,
	--             @fprowno
	--        select @errorid	=	1			--Code added for ITS ID : ES_SOMBL_00004 
	--        RETURN
	--        /*if	@prodn_usage = 1
	--        select	@processingactionml_hdn = 'MAKE'
	--        else if	@purch_source = 1
	--        select	@processingactionml_hdn = 'BUY'
	--        else
	--        select	@processingactionml_hdn = 'MAKE'*/
	--    END
	--END
	/* code commented for ES_NSO_01309 ends */
	--code modified for ES_NSO_00108 ends	
	
	--usage code to be validated
	/*exec crd_ser_sale_tcdcc @ou_id, @finance_book, @account_code, @tran_date, @cust_code, 
	@usage_id, @ship_to_id, @sale_type, @sale_order_type, @processing_action, @number_series, 
	@item_code, @item_variant, @folder, @ship_to_point, @delivery_area_code, @order_point, @item_group, 
	@cust_group, @cost_center out, @cost_centerdesc out, @m_errorid out, @m_errordesc out
	*/
	/* Code commented and added by Damodharan. R on 17 Oct 2007 for OTS ID NSODMS412AT_000548 starts here */
	/*
	--ship partial validation
	if	@shippartial_hdn = 'N' and @shippartialml_hdn = 'Y'
	begin
	--order level <^shippartialml!> flag is set to "no" while <^lineno!> "<%lineno%>"   <^shippartialml!> flag is set to "yes" 
	select @m_errorid = 320340
	return
	end
	*/
	/* Code commented and added by Damodharan. R on 17 Oct 2007 for OTS ID NSODMS412AT_000548 ends here */
	
	-- Defaulting Price 
	SELECT @price_flag = 'N'
	/*check if zero pricing is allowed. if the zero pricing is not allowed,
	if the rate column is blank or 0.00, call the price engine to default the price.
	*/ 	
	IF @zero_it_rate = 'Y'
	BEGIN
	    IF @rateml IS NULL
	    AND @check_price = 1
	        SELECT @price_flag = 'Y'
	END
	ELSE 
	IF @zero_it_rate = 'N'
	BEGIN
	    IF @rateml = 0.0
	    OR @rateml IS NULL
	    BEGIN
	        IF @check_price = 1
	            SELECT @price_flag = 'Y'
	        ELSE
	        BEGIN
	        --<^rateml!> cannot be null 
	            SELECT @m_errorid = 320339
	            RETURN
	        END
	    END
	END 
	
	--If reference document is quotation , order is creating/created from reference sale order table
	--price is picking up from quotation price break table
	IF @refdoc_flag = 'Y'
	AND @refdoc_type = 'QUO'
	BEGIN
	    IF @price_flag = 'Y'
	    BEGIN
	        SELECT 
				   --Code modified for TIS-1515 begins
				   --@rateml = qpb_rate 
				   @rateml = dbo.scm_get_round_amt_fn (@ctxt_ouinstance,
											'NSO',
											null,
											@trandate,
											qpb_rate,
											'UDD_RATE')
				   --Code modified for TIS-1515 ends
	        FROM  qtn_price_break_dtl(NOLOCK)
	        WHERE  qpb_ou = @refdoc_ou
	        AND    qpb_qtn_no = @refdoc_no
	        AND    qpb_line_no = @refdoc_lineno
	        AND    @qtyml BETWEEN qpb_min_qty AND ISNULL(qpb_max_qty, @qtyml)
	    END
	    
	    IF @rateml IS NULL
	    BEGIN
	        --<^rateml!> cannot be null 
	        SELECT @m_errorid = 320339
	       RETURN
	    END
	    
	    SELECT @pricelistno_ml = NULL,
	           @price_flag = 'N'
	END
	ELSE
	    -- Not Ref Doc Based
	BEGIN
	    --pricelist validation
	    IF @pricelistno_ml IS NOT NULL
	    BEGIN
	        EXEC price_list_date_val_sp @ctxt_ouinstance,
	             @ctxt_language,
	             @ctxt_user,
	             @ctxt_service,
	             'NSO',
	             @pricelistno_ml,
	             @currency,
	             @pricingdateml,
	             @m_errorid_tmp OUTPUT,
	             @m_error_flag OUTPUT
	        
	        IF @m_errorid_tmp <> 0
	        BEGIN
	            SELECT @m_errorid = @m_errorid_tmp 
	            RETURN
	        END	
	        
	        IF @price_flag = 'Y'
	        BEGIN
	            SELECT @pricelist_amend_no = plhdr_amend_no,
	                   @peg2_ou = plhdr_ou
	            FROM   price_list_hdr_vw(NOLOCK)
	            WHERE  plhdr_price_list_no = @pricelistno_ml
	            
	          SELECT @price_rule_no = NULL
	            
	            --fetching the rate for specified pricelist	
	            SELECT 
					--Code modified for TIS-1515 begins
					--@rateml = pldtl_computed_rate 
					rateml = dbo.scm_get_round_amt_fn (@ctxt_ouinstance,
									'NSO',
									null,
									@trandate,
									pldtl_computed_rate,
									'UDD_RATE')
					--Code modified for TIS-1515 ends
	            FROM   price_list_dtl_vw(NOLOCK)
	            WHERE  pldtl_ou = @peg2_ou
	            AND    pldtl_price_list_no = @pricelistno_ml
	            AND    pldtl_item_type = CASE @item_type
	                                          WHEN 'I' THEN 'IT'
	                                          WHEN 'K' THEN 'KT'
	                                          WHEN 'M' THEN 'ML'
	                                          ELSE 'IT'
	                                     END
	            AND    pldtl_item_code = @item_code_mul
	            AND    pldtl_item_variant = CASE @flag
	                                             WHEN 1 THEN '##'
	                                             ELSE @variant_code_mul
	                                        END
	            AND @qtyml BETWEEN pldtl_min_qty AND ISNULL(pldtl_max_qty, @qtyml)
	            AND    pldtl_uom = @so_uomml
	        END
	    END
	END	
	

	--code commented by vasantha a for HAL-375 begins
	--IF @rateml IS NULL
	--    SELECT @rateml = 0.0 
	--code commented by vasantha a for HAL-375 ends

  /*									--code commented by Nandhakumar B on 17 Dec 2024 for PJRMC-799 begins
	--required date validation
	IF @reqddateml < @orderdate
	BEGIN
	    --<^reqddateml!> should not be less than the "<%orderdate%>" 
	    SELECT @m_errorid = 320504
	    RETURN
	END
 */										--code commented by Nandhakumar B on 17 Dec 2024 for PJRMC-799 ends  
	
	IF @ctxt_service = 'SOPP_%'
	BEGIN
	    IF @feature_flag_yes_no = 'YES'
	    BEGIN
	        IF CONVERT(nCHAR(10), @reqddateml, 120) < CONVERT(nCHAR(10),  dbo.res_getdate(@ctxt_ouinstance), 120)--ES_SOD_00005
	        BEGIN
	            /*code modified for NSODMS412AT_000498 starts*/ 
	            --raiserror('Required Date should not be less than system date',16,1)
	        EXEC fin_german_raiserror_sp 'NSO',
	                 @ctxt_language,
	                 22,
	                 '',
	                 '',
	                 '',
	                 '',
	                 '',
	                 '',
	                 ''
	            /*code modified for NSODMS412AT_000498 ends*/
	            select @errorid	=	1			--Code added for ITS ID : ES_SOMBL_00004 
	            RETURN
	        END
	    END
	END
	
  /*									--code commented by Nandhakumar B on 17 Dec 2024 for PJRMC-799 begins
	--promised date validation
	IF @promiseddateml < @orderdate
	BEGIN
	  --promised date should not be less than the order date
	    SELECT @m_errorid = 320704
	    RETURN
	END
  */								--code commented by Nandhakumar B on 17 Dec 2024 for PJRMC-799 ends
	/*Code added by EPE-75937 begins*/
	DECLARE @Qtn_accp_feature_flag_yes_no udd_yesnoflag,
			@accepdate			udd_date,
			@accstatus			udd_status,
			@amendnoqcr			udd_lineno

	if isnull(@refdoc_no,'') <> ''--EPE-75937:EPE-77600
	begin

	select @amendnoqcr     =	qhdr_amd_no
	from   qtn_quotation_hdr with(nolock)
	where  qhdr_ou	    =	@ctxt_ouinstance
	and	   qhdr_qtn_no	=	@refdoc_no 

	if exists (	Select 'X'
           		from 	cmn_addl_fn_param_metadata_ou with(nolock)
           		where   cmn_addl_id        	=    'PPS_block_SO_nonaccepted_lineitems '
           		and     cmn_addl_comp_name  =    'NSO'  
           		and     cmn_addl_ou         =   @ctxt_ouinstance
               )
    Begin
    	Select @Qtn_accp_feature_flag_yes_no		= cmn_addl_flag
		from   cmn_addl_fn_param_metadata_ou with (nolock)
		where  cmn_addl_ou							= @ctxt_ouinstance
		and    cmn_addl_id							= 'PPS_block_SO_nonaccepted_lineitems'
		and    cmn_addl_comp_name					= 'NSO'
    End        
	Else
    Begin
        select  @Qtn_accp_feature_flag_yes_no    =  cmn_addl_flag 
        from    cmn_addl_fn_param_metadata with (nolock)
        where   cmn_addl_id        				 = 'PPS_block_SO_nonaccepted_lineitems '
        and     cmn_addl_comp_name 				 = 'NSO'
    End

   if @refdoc_type  = 'QUO'
   begin

	if  isnull(@Qtn_accp_feature_flag_yes_no,'') = 'YES'
	begin 
	    if exists ( Select 'X'
				    from	qacp_quoaccp_ln_dtl with (nolock)--code(qacp_quoaccp_dtl) removed and added by EPE-75937_1
					where	qacp_ou			=	@ctxt_ouinstance
					and		qacp_refdocno   =	@refdoc_no
					and		qacp_amendno	=	@amendnoqcr
					and     qacp_lineno		=	@refdoc_lineno
				  )
	    begin 
			Select	@accepdate		= qacp_oadate,
					@accstatus      = qacp_status
			 from	qacp_quoaccp_ln_dtl with (nolock)--code(qacp_quoaccp_dtl) removed and added by EPE-75937_1
			 where	qacp_ou			=	@ctxt_ouinstance
			 and	qacp_refdocno   =	@refdoc_no
			 and	qacp_amendno	=	@amendnoqcr
			 and    qacp_lineno		=	@refdoc_lineno 
			 
			 if isnull(@orderdate,'') <  isnull(@accepdate,'') and @ctxt_service = 'sopp_crmn_ser_auth1'
			 begin
			 	--raiserror('Order should not be less than Acceptance Date. Delete the  documenttoprocced.',16,1)
			 	exec fin_german_raiserror_sp 'NSO',@ctxt_language,11260605
			 	return
			 end
	
			if isnull(@orderdate,'') <  isnull(@accepdate,'') and @ctxt_service <> 'sopp_crmn_ser_auth1'
			begin
				--raiserror('Order should not be less than Acceptance Date',16,1)
				exec fin_german_raiserror_sp 'NSO',@ctxt_language,11260590
				return
			end
		
			if @accstatus in ('N') and @ctxt_service = 'sopp_crmn_ser_edt1'
			begin
				--raiserror('SO modification should not be allowed for Rejected line items %d.',16,1)
				exec fin_german_raiserror_sp 'NSO',@ctxt_language,11260591,@refdoc_lineno
				return
			end
			if @accstatus in ('N') and @ctxt_service <> 'sopp_crmn_ser_edt1'
			begin
				--raiserror('SO modification should not be allowed for Rejected line items %d.',16,1)
				exec fin_german_raiserror_sp 'NSO',@ctxt_language,11260600,@refdoc_lineno
				return
			end
			
		end
		else
		begin
			if @ctxt_service in ('sopp_crmn_ser_auth1')
			begin
			   if exists ( Select 'X'
							from	qacp_quoaccp_ln_dtl with (nolock)--code(qacp_quoaccp_dtl) removed and added by EPE-75937_1
							where	qacp_ou			=	@ctxt_ouinstance
							and		qacp_refdocno   =	@refdoc_no
							and		qacp_amendno	=	@amendnoqcr
					  )
				begin
					Select @ctxt_ouinstance = @ctxt_ouinstance
				end
				else
				begin
					--raiserror('Quotation line level  Acceptance details has not been recorded.Delete the document to proceed',16,1)
					exec fin_german_raiserror_sp 'nso',@ctxt_language,11260593
					return
				end
			end
			else
			begin
				if exists ( Select 'X'
							from	qacp_quoaccp_dtl with (nolock)--code(qacp_quoaccp_dtl) removed and added by EPE-75937_1
							where	qacp_ou			=	@ctxt_ouinstance
							and		qacp_refdocno   =	@refdoc_no
							and		qacp_amendno	=	@amendnoqcr
					  )
				begin
					Select @ctxt_ouinstance = @ctxt_ouinstance
				end
				else
				begin
					--raiserror('Order level Acceptance details has not been recorded',16,1)
					exec fin_german_raiserror_sp 'nso',@ctxt_language,11260592
					return
				end
			end
	   end
	end
 end
 end
	/*code added by EPE-75937 ends*/
	
	--code added for GSE-2010 begins
	if	@refdoc_type	=	'CON' and @ctxt_service in ('so_rlcrmn_ser_genrel','so_rledmn_ser_genrel','sopp_crmn_ser_crau1','sopp_crmn_ser_auth1','sopp_ammn_ser_auth1','sopp_ammn_ser_auam1')
	begin
		declare	@cont_effectiveto_date		udd_date

		select 	@cont_effectiveto_date	=	bsohdr_expiry_date	
		from	so_blanket_order_hdr (nolock)
		where	bsohdr_ou			= @refdoc_ou
		and		bsohdr_contract_no	= @refdoc_no
		
		if @cont_effectiveto_date is not null
		begin
			if	@reqddateml  >  @cont_effectiveto_date
			begin
				--raiserror('Required date should not be greater than Contract Effective to date in row no. %d',16,1,@fprowno)
				exec fin_german_raiserror_sp 'NSO',@ctxt_language,11260509,@fprowno
				return
			end	

			if	@promiseddateml  >  @cont_effectiveto_date
			begin
				--raiserror('Promised date should not be greater than Contract Effective to date in row no. %d',16,1,@fprowno)
				exec fin_german_raiserror_sp 'NSO',@ctxt_language,11260510,@fprowno
				return
			end	
		end
	end
	--code added for GSE-2010 ends

	/*Code Modified for EPE-87218 begins*/
	/*code  starts added by EPE-85980*/
	/*	IF @shipcustcodeml IS not NULL  and (isnull(@shipcustcodeml,'') <>isnull(@customercode,''))
	BEGIN
	    SELECT @shipcustcodeml = cou_dflt_shipto_cust
	    FROM   cust_ou_info_vw(NOLOCK)
	    WHERE  cou_lo = @lo
	    AND    cou_bu = @cust_bu
	    AND    cou_ou = @cust_ou
	    AND    cou_cust_code = @customercode
	END  */
	/*code  added  ends by EPE-85980*/
	IF @shipcustcodeml IS not NULL
	begin
		;  
         with SQLTMP(destinationouinstid1) as (  
			 select  distinct SQL2K51.destinationouinstid  
             from    fw_admin_view_comp_intxn_model SQL2K51(nolock)  
             where SQL2K51.sourcecomponentname		 =  'NSO'  
             and  SQL2K51.sourceouinstid			 =  @ctxt_ouinstance  
             and  SQL2K51.destinationcomponentname	 =  'CU'  
         )  
           
         select  @ordship = 'x'  
         from    cust_shiptocust_vw(nolock) join   
           SQLTMP  
         on   (crl_ou				=   SQLTMP.destinationouinstid1)  
         where crl_cust_code		=	@CustomerCode  
         and  crl_rel_cust_code		=	@shipcustcodeml  

		if  @ordship is null  
		begin  
			SELECT @shipcustcodeml = cou_dflt_shipto_cust
			FROM   cust_ou_info_vw(NOLOCK)
			WHERE  cou_lo = @lo
			AND    cou_bu = @cust_bu
			AND    cou_ou = @cust_ou
			AND    cou_cust_code = @customercode		  
		end 
	end
	/*Code Modified for EPE-87218 ends*/

	--defaulting the ship to customercode and ship to id from customer
	IF @shipcustcodeml IS NULL
	BEGIN
	    SELECT @shipcustcodeml = cou_dflt_shipto_cust
	    FROM   cust_ou_info_vw(NOLOCK)
	    WHERE  cou_lo = @lo
	    AND    cou_bu = @cust_bu
	    AND    cou_ou = @cust_ou
	    AND    cou_cust_code = @customercode
	END 
	
	IF @shiptoaddidml IS NULL
	BEGIN
	    SELECT @shiptoaddidml = cou_dflt_shipto_id
	    FROM   cust_ou_info_vw(NOLOCK)
	    WHERE  cou_lo = @lo
	    AND    cou_bu = @cust_bu
	    AND    cou_ou = @cust_ou
	    AND    cou_cust_code = @shipcustcodeml
	END
	
	--	ship to customer code null check
	IF @shipcustcodeml IS NULL
	BEGIN
	    --ship to customer cannot be null. enter valid ship to customer
	    SELECT @m_errorid = 320690
	    RETURN
	END
	
	--	ship to customer address id null check
	IF @shiptoaddidml IS NULL
	BEGIN
	    --<^shiptoaddidml!> cannot be null
	    SELECT @m_errorid = 320514
	    RETURN
	END
	
		----code added for SCLRES-707 begins
		;  
         with SQLTMP(destinationouinstid1) as (  
			 select  distinct SQL2K51.destinationouinstid  
             from    fw_admin_view_comp_intxn_model SQL2K51(nolock)  
             where SQL2K51.sourcecomponentname		 =  'NSO'  
             and  SQL2K51.sourceouinstid			 =  @ctxt_ouinstance  
             and  SQL2K51.destinationcomponentname	 =  'CU'  
         )  
           
         select  @ordship = 'x'  
         from    cust_shiptocust_vw(nolock) join   
           SQLTMP  
         on   (crl_ou				=   SQLTMP.destinationouinstid1)  
         where crl_cust_code		=	@CustomerCode  
         and  crl_rel_cust_code		=	@shipcustcodeml  

		if  @ordship is null  
		begin  
			  exec 	fin_german_raiserror_sp 'QUOTATION',@ctxt_language,26,@CustomerCode,@fprowno
			  return  
		end  
		----code added for SCLRES-707  ends

	--calling ship to customer validation procedure
	EXEC scm_ship_to_cust_val @ctxt_ouinstance,
	     @ctxt_language,
	     @ctxt_user,
	     @ctxt_service,
	     'NSO',
	     @lo,
	     @customercode,
	     @shipcustcodeml,
	     0,
	     @m_errorid_tmp OUTPUT,
	     @error_msg_qualifier OUTPUT,
	     @m_error_flag OUTPUT 
	
	
	IF @m_error_flag <> 'S'
	BEGIN
	    --ship to customer is not valid. enter a valid ship to customer
	    SELECT @m_errorid = @m_errorid_tmp --320705
	    RETURN
	END
	
	/*Code added for EPE-87218 begins*/
	if @shiptoaddidml is not null
	begin
		select @ordship = null
		;  
         with SQLTMP(destinationouinstid1) as (  
			 select  distinct SQL2K51.destinationouinstid  
             from    fw_admin_view_comp_intxn_model SQL2K51(nolock)  
             where SQL2K51.sourcecomponentname		 =  'NSO'  
             and  SQL2K51.sourceouinstid			 =  @ctxt_ouinstance  
             and  SQL2K51.destinationcomponentname	 =  'CU'  
         )  

		select @ordship= 'x' 
		from	cust_addr_details_vw ad(nolock), 
				cust_shiptocust_vw sh(nolock) 
		where	sh.crl_lo			=	@lo
		and	sh.crl_cust_code		=	@customercode
		and	sh.crl_rel_cust_code		=	@shipcustcodeml
		and	sh.crl_rel_type			in	('SH','BO')
		and	sh.crl_lo			=	ad.addr_lo
		and	ad.addr_cust_code		=	@shipcustcodeml
		and	ad.addr_address_id		=	@shiptoaddidml

		if  @ordship is null  
		begin
			select  @shiptoaddidml =cou_dflt_shipto_id
			from   cust_ou_info_vw (nolock)
			where   cou_ou		    = (select  distinct SQL2K51.destinationouinstid  
										 from    fw_admin_view_comp_intxn_model SQL2K51(nolock)  
										 where SQL2K51.sourcecomponentname		 =  'NSO'  
										 and  SQL2K51.sourceouinstid			 =  @ctxt_ouinstance  
										 and  SQL2K51.destinationcomponentname	 =  'CU')
			and    cou_cust_code        = ltrim(rtrim(@customercode))
			--and    cou_dflt_shipto_cust = ltrim(rtrim(@shipcustcodeml))
		end
	end
	/*Code added for EPE-87218 ends*/

	--calling ship to id validation procedure
	EXEC scm_cust_ship_id_val @ctxt_ouinstance,
	  @ctxt_language,
	     @ctxt_user,
	     @ctxt_service,
	     'NSO',
	     @lo,
	     @customercode,
	     @shipcustcodeml,
	     @shiptoaddidml,
	 '0',
	     @m_errorid_tmp OUTPUT,
	     @error_msg_qualifier OUTPUT,
	     @m_error_flag OUTPUT 
	
	
	IF @m_error_flag <> 'S'
	BEGIN
	    --ship to id is not valid. enter a valid ship to id
	    SELECT @m_errorid = @m_errorid_tmp --320706         
	    RETURN
	END
	
	--Delivaryareacode fetchingfor the ship to customer and id
	SELECT @deliveryarea = addr_del_area_code
	FROM   cust_addr_details_vw(NOLOCK)
	WHERE  addr_lo = @lo
	AND    addr_cust_code = @shipcustcodeml
	AND    addr_address_id = @shiptoaddidml
	
	--code added for SCLRES-825 starts here
	if @deliveryarea is not null or @deliveryarea <> ''
	begin
		if exists(
			select 'x' from da_del_area_master(nolock) 
			where da_delarea_code=@deliveryarea
			and da_lo=@lo
			and da_status='IA'
			)
		begin
			--raiserror('Delivery area code is not in active. Please check',16,1)
			exec fin_german_raiserror_sp 'NSO', @ctxt_language, 11260505
			return
		end
	end
	---code added for SCLRES-825 ends here

	--Checking for CIM interaction with Selling Restriction Component
	IF EXISTS (
	       SELECT 'Y'
	       FROM   fw_admin_view_comp_intxn_model(NOLOCK)
	       WHERE  sourceouinstid = @ctxt_ouinstance
	       AND    sourcecomponentname = 'NSO'
	       AND    destinationcomponentname = 'SELRES'
	   )
	BEGIN
	    --Selling Restrictions Validation
	    EXEC selres_validation_sp @ctxt_ouinstance,
	         @ctxt_language,
	         @ctxt_user,
	         @ctxt_service,
	         'NSO',
	         @customercode,
	         @deliveryarea,
	         @item_code_mul,
	         @variant_code_mul,
	         @sales_channel,
	         @orderdate,
	         @fprowno,
	         @m_errorid_tmp OUT
	    
	    IF @m_errorid_tmp <> 0
	    BEGIN
	        --select @m_errorid = @m_errorid_tmp
	        EXEC srsr_err_sp @item_code_mul,
	             @variant_code_mul,
	             @fprowno,
	             @customercode,
	             @deliveryarea,
	             @m_errorid_tmp
	        
	        
	        SELECT @m_errorid = @m_errorid_tmp --Code added for DTS ID:ES_NSO_00023
	        RETURN
	    END
	END -- End of Selling Restrictions Validation
	
	--calling procedure to fetch the stock status ou
	EXEC scm_get_dest_ou @ctxt_ouinstance,
	     @ctxt_language,
	     @ctxt_user,
	     'NSO',
	     'STKSTATUS',
	     @stk_ou OUT,
	     @m_errorid_tmp OUT
	
	IF (@m_errorid_tmp <> 0)
	BEGIN
	    --Normal Sale Order component to Stock Status component mapping is not present. Please Check
	    SELECT @m_errorid = 325095
	    RETURN
	END 
	
	IF @stockableflag = 1
	BEGIN
	    /*	NSODMS41UTST_000017 -langid included*/
	    -- Check if Stock Status is Valid For NSO or Not.
	    IF EXISTS (
	           SELECT '*'
	           FROM   ssd_tran_status_vw(NOLOCK)
	           WHERE  ou = @stk_ou
	           AND    trantype = 'NSO'
	           AND    applicable = 'Y'
	           AND   code = @stocstatusml_hdn
	           AND    ssd_langid = @ctxt_language
	       )
	    BEGIN
	        -- Dummy Select
	        SELECT @stocstatusml_hdn = RTRIM(@stocstatusml_hdn)
	    END
	    ELSE
	    BEGIN
	        --Stock Status is not valid. Please check
	        SELECT @m_errorid = 325285
	        RETURN
	    END
	    
	    EXEC ssd_sp_chk_stockable @ctxt_language,
	         @stk_ou,
	         @ctxt_user,
	        @ctxt_service,
	         'NSO',
	         @stocstatusml_hdn,
	         NULL,
	         @execflag OUT,
	        @m_errorid_tmp OUT
	    
	    IF @execflag = 0
	    BEGIN
	        EXEC ssd_sp_chk_allocable @ctxt_language,
	             @stk_ou,
	             @ctxt_user,
	             @ctxt_service,
	             'NSO',
	            @stocstatusml_hdn,
	             NULL,
	             @execflag OUT,
	             @m_errorid_tmp OUT
	      
	      IF @execflag = 0
	        BEGIN
	            /*Code modified for ES_NSO_00088 begins here*/
	            --if	@warehouse_code_mul is null
	            IF @warehouse_code_mul IS NULL
	            AND @processingactionml_hdn <> 'DROP' 
	                /*Code modified for ES_NSO_00088 ends here*/
	            BEGIN
	                /*--Warehouse code cannot be null
	                select @m_errorid = 321086
	                return*/
	                --To Fetch the standard warehouse
	                SELECT @warehouse_code_mul = std_wh_code
	                FROM   item_var_ou_vw(NOLOCK)
	           WHERE  ou = @item_ou
	                AND    item_code = @item_code_mul
	                AND    variant_code = CASE @flag
	                                           WHEN 1 THEN '##'
	                                           ELSE @variant_code_mul
	                                      END
	            END
	        END
	        ELSE
	        BEGIN
	            SELECT @m_errorid = @m_errorid_tmp
	            RETURN
	        END
	    END
	END 
	
	--warehouse code validation
	--Code Commented And Added for NSODMS412AT_000055 begins here
	--if	@warehouse_code_mul is not null
	/*Code modified for ES_NSO_00088 begins here*/
	-- if	@warehouse_code_mul is not null and  @item_type not in ('M', 'S')
	IF @warehouse_code_mul IS NOT NULL
	AND @item_type NOT IN ('M', 'S')
	AND @processingactionml_hdn <> 'DROP' 
	    /*Code modified for ES_NSO_00088 ends here*/
	    --Code Commented And Added for NSODMS412AT_000055 ends here
	BEGIN
	    --calling the procedure to validate the warehouse code 
	    EXEC scm_wh_shp_point_val @ctxt_ouinstance,
	         @ctxt_language,
	         @ctxt_user,
	         @ctxt_service,
	         'NSO',
	         @shippingpointml_hdn,
	         @warehouse_code_mul,
	         0,
	         @m_errorid_tmp OUTPUT,
	         @error_msg_qualifier OUTPUT,
	         @m_error_flag OUTPUT	
	    
	    IF @m_errorid_tmp <> 0
	    BEGIN
	        SELECT @m_errorid = @m_errorid_tmp
	        RETURN
	    END
	    
		--code added for VE-3821 begins
		if	@processingactionml_hdn = 'BUY'
			select	@tran_type	=	'PORC'

		if	@processingactionml_hdn = 'MAKE'
			select	@tran_type	=	'SMIS'

		 EXEC sa_sp_chk_transaction @wh_ou,
	        @ctxt_language,
	        @ctxt_user,
	        @ctxt_service,
	        'NSO',
	        @warehouse_code_mul,
	        @tran_type,
	        @execflag OUT,
			@m_errorid_tmp OUT                                                      
	        
	 IF @execflag <> 0
	        BEGIN
	            IF @m_errorid_tmp = 2261000
	            BEGIN
	               exec fin_german_raiserror_sp 'OMRO', @ctxt_language, 46, @warehouse_code_mul
					select @errorid	=	@m_errorid_tmp		
	                RETURN
	            END                                                      
	            
	            IF @m_errorid_tmp = 2261009
	            BEGIN
	                exec fin_german_raiserror_sp 'PRJDET', @ctxt_language, 22069, @fprowno, @warehouse_code_mul
					select @errorid	=	@m_errorid_tmp			
	                RETURN
	            END
	        END 
		--code added for VE-3821 ends

	    /* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Begins */
	    if exists ( select	'X'
					from	ict_po_so_tmp(nolock)
					where	tmp_guid	=	@guid
					and		tmp_pono	is not null
				  )
		begin
			select	@ctxt_ouinstance	=	@ctxt_ouinstance
		end				  
		else
		begin
	    /* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Ends */		
	    --code added for ES_NSO_00549 starts
	    --to check if the login user has been mapped to the Warehouse.
			exec sa_sp_chk_wh_user
			/*Code modified by Indu on 21-01-2013 for ES_NSO_00603 Begins */		
				--@ctxt_ouinstance,
				@wh_ou,
			/*Code modified by Indu on 21-01-2013 for ES_NSO_00603 Ends */
				@ctxt_language,
				@ctxt_user,
				@ctxt_service,
				'NSO',
				@warehouse_code_mul,
				@ctxt_user,
				null,
				@m_errorid_tmp out
			
			if @m_errorid_tmp <> 0 
			begin 
				exec fin_german_raiserror_sp 'NSO', @ctxt_language, 1228, @fprowno
				select @errorid	=	@m_errorid_tmp			--Code added for ITS ID : ES_SOMBL_00004 
				return 
			end
		end--13H120_Supp_00004:ES_Supp_00320
		--code added for ES_NSO_00549 ends
	END 
	
	--Transportmode validation
	IF @ctxt_service NOT LIKE 'SOPP_%'
	BEGIN
	    IF @preffered_carrier IS NOT NULL
	    AND @trans_modeml IS NOT NULL
	    BEGIN

	        IF EXISTS (
	               SELECT 'X'
	               FROM   carrier_trans_details_vw(NOLOCK)
	 WHERE  sha_dtr_lo = @lo
	               AND    sha_dtr_carrier_code = @preffered_carrier
	               AND    sha_dtr_transport_mode = @trans_modeml
	           )
	        BEGIN
	            SELECT @preffered_carrier = @preffered_carrier
	                   --return
	        END
	        ELSE
	        BEGIN
	            --<^preferredcarrier !> "<%preferredcarrier%>" <^trans_mode!> "<%trans_mode%>" combination does not exist 
	         SELECT @m_errorid = 320334
	            RETURN
	        END
	    END
	END
	
	--sales person code validation
	IF @spcodeml IS NOT NULL
	BEGIN
	    EXEC scm_sales_person_val @ctxt_ouinstance,
	         @ctxt_language,
	         @ctxt_user,
	         @ctxt_service,
	         'NSO',
	         1,	--cimfalg
	         @sp_ou,
	         @spcodeml,
	         0,
	         @m_errorid_tmp OUTPUT,
	         --@error_msg_qualifier output,  
	         @m_error_flag OUTPUT,
	         @sp_name OUTPUT
	    
	    IF @m_errorid_tmp <> 0
	    BEGIN
	      SELECT @m_errorid = @m_errorid_tmp
	        RETURN
	    END	
	    
	    SELECT @sp_ou = sp_ou
	    FROM   sp_salesperson_vw(NOLOCK)
	    WHERE  sp_code = @spcodeml
	    AND    sp_lo = @lo
	END
	
	-- 	--calling procedure for item ou
	-- 	exec	scm_get_dest_ou	@ctxt_ouinstance,
	-- 				@ctxt_language,
	-- 				@ctxt_user,
	-- 				'NSO',
	-- 				'SHIPPING_ADMIN',
	-- 				@sha_ou	out,
	-- 				@m_errorid_tmp	out
	-- 	if	@m_errorid_tmp <> 0
	-- 		begin
	-- 			select	@m_errorid = @m_errorid_tmp
	-- 			return
	-- 		end	
	/*Code rolled back for ES_NSO_00238 begins here*/
	/*Code modified for ES_NSO_00226 begins here*/
	--	--if @to_shipdateml is null
	--	if	 @to_shipdateml is null or @reserve_dtml is null
	/*Code modified for ES_NSO_00226 ends here*/
	IF @to_shipdateml IS NULL
	   /*Code rolled back for ES_NSO_00238 ends here*/
	BEGIN
	    /* Code modified by Raju against NSODms412at_000412 starts*/
	    IF @ctxt_service LIKE 'SOPP_%'
	    BEGIN
	        IF @item_type = 'M'
	        BEGIN
	            --calling procedure for fetch the to ship date  
	            EXEC sopp_to_ship_date_fet @lo,
	                 @cust_bu,
	                 @ctxt_ouinstance,
	          @item_code_mul,
	                 '##',
	                 @reqddateml,
	                 @promiseddateml,
	                 @preffered_carrier,
	                 @deliveryarea,
	                 @shippingpointml_hdn,
	                 @warehouse_code_mul,
	   @trans_modeml,
	                 @to_shipdateml OUT,
	                 @reserve_dtml OUT
	        END
	        ELSE 
	        IF @item_type <> 'M'
	        BEGIN
	            --calling procedure for fetch the to ship date  
	            EXEC sopp_to_ship_date_fet @lo,
	                 @cust_bu,
	                 @ctxt_ouinstance,
	                 @item_code_mul,
	                 @variant_code_mul,
	                 @reqddateml,
	                 @promiseddateml,
	                 @preffered_carrier,
	                 @deliveryarea,
	                 @shippingpointml_hdn,
	                 @warehouse_code_mul,
	                 @trans_modeml,
	                 @to_shipdateml OUT,
	                 @reserve_dtml OUT
	        END
	    END
	    ELSE
	    BEGIN
	        IF @item_type = 'M'
	        BEGIN
	      --calling procedure for fetch the to ship date
	            EXEC so_to_ship_date_fet @lo,
	                 @cust_bu,
	                 @ctxt_ouinstance,
	                 @item_code_mul,
	                 '##',
	                 @reqddateml,
	                 @promiseddateml,
	                 @preffered_carrier,
	                 @deliveryarea,
	                 @shippingpointml_hdn,
	           @warehouse_code_mul,
	                 @trans_modeml,
	                 @to_shipdateml OUT,
	                 @reserve_dtml OUT
	        END
	        ELSE 
	        IF @item_type <> 'M'
	        BEGIN
	            --calling procedure for fetch the to ship date
	            EXEC so_to_ship_date_fet @lo,
	                 @cust_bu,
	                 @ctxt_ouinstance,
	                 @item_code_mul,
	                 @variant_code_mul,
	                 @reqddateml,
	                 @promiseddateml,
	                 @preffered_carrier,
	                 @deliveryarea,
	                 @shippingpointml_hdn,
	                 @warehouse_code_mul,
	           @trans_modeml,
	                 @to_shipdateml OUT,
	                 @reserve_dtml OUT
	        END
	    END
	END
	ELSE
	BEGIN
	    IF @ctxt_service LIKE 'SOPP_%'
	    BEGIN
	        IF @feature_flag_yes_no = 'YES'
	        BEGIN
	            IF @to_shipdateml < CONVERT(nCHAR(10),  dbo.res_getdate(@ctxt_ouinstance), 120)--ES_SOD_00005
	            BEGIN
	                /*code modified for NSODMS412AT_000498 starts*/
	                --raiserror('To ship date should not be less than system date',16,1)
	                EXEC fin_german_raiserror_sp 'NSO',
	                     @ctxt_language,
	                     23,
	                     '',
	                     '',
	                     '',
	                     '',
	                     '',
	  '',
	                     ''
	                /*code modified for NSODMS412AT_000498 ends*/
	                select @errorid	=	1				--Code added for ITS ID : ES_SOMBL_00004 
	                RETURN
	            END
	        END
	    END
	END
	/* Code modified by Raju against NSODms412at_000412 ends*/	
	IF @reserve_dtml IS NULL
	    SELECT @reserve_dtml = @to_shipdateml		
	
	IF @schtype_hdn = 'SI'
	BEGIN
	    SELECT @line_status = 'FR'
	END
	ELSE 
	IF @schtype_hdn = 'SG'
	    SELECT @line_status = 'DR' 
	
	--availabele date validation
	IF @reserve_dtml IS NOT NULL
	BEGIN
	    -- 			if	@reserve_dtml > @promiseddateml
	    -- 				begin
	    -- 					select	@m_errorid	= 100
	    -- 					return
	    -- 				end
	    IF @reserve_dtml > @to_shipdateml
	    BEGIN
	        --available date cannot be greater than to-ship date date.please check
	        SELECT @m_errorid = 320710
	        RETURN
	    END
	END
	
	--to ship date validation
	IF @to_shipdateml IS NOT NULL
	BEGIN
	    IF @to_shipdateml > @promiseddateml
	 BEGIN
	       --to-ship date cannot be greater than the promised date.please check
	        SELECT @m_errorid = 320711
	        RETURN
	    END
	END	
	
	--/* Code modified for TTS Id. : ES_NSO_00603 Begins */
	--/*Code added by Damodharan. R on 18 Nov 2008 for Defect ID ES_PACKSLIP_00117 starts here*/
	--SELECT @wh_ou = destinationouinstid
	--FROM   fw_admin_view_comp_intxn_model(NOLOCK)
	--WHERE  sourcecomponentname = 'PACKSLIP'
	--AND    sourceouinstid = @shippingpointml_hdn
	--AND    destinationcomponentname = 'STORAGE_ADMIN'
	--AND    destinationouinstid = @shippingpointml_hdn
	
	--IF @wh_ou IS NULL
	--BEGIN
	--    /*Code added by Damodharan. R on 18 Nov 2008 for Defect ID ES_PACKSLIP_00117 ends here*/
	--    --calling procedure for  to get warehouse ou
	--    EXEC scm_get_dest_ou @shippingpointml_hdn,
	--         @ctxt_language,
	--         @ctxt_user,
	--         'PACKSLIP',
	--         'STORAGE_ADMIN',
	--         @wh_ou OUT,
	--         @m_errorid_tmp OUT	
	    
	--    IF @m_errorid_tmp <> 0
	--    BEGIN
	-- --Packslip component to Storage Administration component mapping is not present. Please Check
	--        SELECT @m_errorid = 325096
	--        RETURN
	--    END/*Code added by Damodharan. R on 18 Nov 2008 for Defect ID ES_PACKSLIP_00117 starts here*/
	--END
	--/*Code added by Damodharan. R on 18 Nov 2008 for Defect ID ES_PACKSLIP_00117 ends here*/    
	--/* Code modified for TTS Id. : ES_NSO_00603 ends */
	
	SELECT @planningtype = ISNULL(planning_type, 0)
	FROM   item_ou_planning_info_vw(NOLOCK)
	WHERE  ou = @item_ou
	AND    item_code = @item_code_mul
	AND    variant_code = CASE @flag
	           WHEN 1 THEN '##'
	                           ELSE @variant_code_mul
	                      END
	
	IF @incoplace IS NULL
	BEGIN
	    EXEC scm_incoplace_fet 'NSO',
	         @ctxt_ouinstance,
	         @ctxt_language,
	         @ctxt_user,
	         @lo,
	         @cust_bu,
	         @ctxt_ouinstance,
	         @trans_modeml,
	         @shipcustcodeml,
	         @shiptoaddidml,
	         @incoplace OUT,
	         @m_errorid_tmp OUT,
	     @m_error_flag OUT
	    
	    IF @m_errorid_tmp <> 0
	    BEGIN
	        SELECT @m_errorid = @m_errorid_tmp
	        RETURN
	    END
	END 
	
	/* Code modified by Raju against NSODms412at_000412 starts*/
	IF @ctxt_service LIKE 'SOPP_%'
	BEGIN
	    IF @unitfrprice < 0.0
	    AND @unitfrprice IS NOT NULL
	    BEGIN
	        SELECT @m_errorid = 3550158
	        RETURN
	    END
	    
	    /*Code modified by Damodharan. R on 05 Feb 2009 for Defect ID ES_NSO_00147 starts here*/
	    --if @priceuomml is not null
	    IF @priceuomml IS NOT NULL
	    AND @item_type_tmp <> 'KT'
	        /*Code modified by Damodharan. R on 05 Feb 2009 for Defect ID ES_NSO_00147 ends here*/
	    BEGIN
	        -- calling uom validation procedure
	        EXEC scm_sale_uom_val @uom_ou,
	  @ctxt_language,
	             @ctxt_user,
	             @ctxt_service,
	             'NSO',
	             @uom_ou,
	             @priceuomml,
	             0,
	             @m_errorid_tmp OUTPUT,
	             @error_msg_qualifier OUTPUT,
	             @m_error_flag OUTPUT
	        
	        IF @m_errorid_tmp <> 0
	        BEGIN
	            SELECT @m_errorid = @m_errorid_tmp
	            RETURN
	        END
	        
	        IF @priceuomml <> @so_uomml
	        BEGIN
	            EXEC itm_sp_get_uomconvfactor @item_ou,
	                 @item_code_mul,
	                 @variant_code_mul,
	                 @priceuomml,
	                 @so_uomml,
	                 @convfactor OUT,
	                 @execflag OUT,
	                 @m_errorid OUT,
	                 @convert_type OUTPUT
	            
	            IF @convfactor IS NULL
	            BEGIN
	                EXEC uom_sp_get_convfactor @ctxt_ouinstance,
	                     @priceuomml,
	                     @so_uomml,
	                     @convfactor OUT,
	                     @execflag OUT,
	                     @m_errorid OUT,
	                     @convert_type OUTPUT
	         
	                IF @m_errorid <> 0
	                OR @convfactor IS NULL
	                BEGIN
	             --UOM conversion does not exist between Sales UOM and Pricing UOM in line no. %a
	                    SELECT @m_errorid = 3550379
	                    RETURN
	                END
	  END
	        END
	        
	        IF @priceuomml IS NULL
	            SELECT @priceuomml = @so_uomml
	        
	        IF @gua_shelflife IS NOT NULL
	        BEGIN
	            SELECT @shelf_life_period = shelf_life_period
	            FROM   item_var_bu_vw(NOLOCK)
	            WHERE  lo = @lo_item
	            AND    bu = @bu_item
	            AND    item_code = @item_code_mul
	            AND    variant_code = @variant_code_mul
	            
	            IF @shelf_life_period = 0
	            BEGIN
	                --Guaranteed shelf life can be given  to items for which shelf life is specified in inventory.
	                SELECT @m_errorid = 3550006
	                RETURN
	            END
	        END
	        
	        IF @gua_shelflife IS NULL
	        BEGIN
	          IF @shelf_life_unit_mul_hdn IS NOT NULL
	            BEGIN
	                --Shelf life unit can be defined only if the guaranteed shelf life is given.
	                SELECT @m_errorid = 3550008
	                RETURN
	            END
	        END
	    END
	END

	/* Code modified by Raju against NSODms412at_000412 ends*/
	SET NOCOUNT OFF --Code added for Defect ID ES_NSO_00211 - SP analyser exception
END








