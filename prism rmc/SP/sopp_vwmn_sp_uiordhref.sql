/*$File_version=ms4.3.0.19$*/      
/* VERSION NO: PPS4.1.0.002 */        
/******************************************************************************************      
file name  : sopp_vwmn_sp_uiordhref.sql        
version  : 4.0.0.0        
procedure name  : sopp_vwmn_sp_uiordhref        
purpose   : UI Task in View Sale Order - Header Refresh        
author   : M. Jacob Selvakumar        
component name  : ppscmqso        
method name  : sopp_vwmn_m_uiordhref        
        
objects referred        
 object name  object type  operation        
       (insert/update/delete/select/exec)        
*******************************************************************************************      
Modification details :      
 Modified By  Modified Date Description      
 R.Anand Narayanan 18-july-05 For the trantype out parameter addition.      
 Santhosh.A  11/10/2006 PPSCMQSOPPS41_000114      
 Geetha.S  18/12/2006 PPSCMQSODMS412AT_000025      
 Anitha N  18/09/2007 NSODMS412AT_000527      
 Veangadakrishnan R 18/04/2008 DMS412AT_NSO_00030      
 Damodharan. R  01 Aug 2008 ES_NSO_00041       
 Veangadakrishnan R 30/12/2008 ES_NSO_00118      
 Veangadakrishnan R 23/03/2009 ES_NSO_00206      
 Veangadakrishnan R 23/03/2009 ES_PACKSLIP_00204      
    Indu Ram   23-Nov-2009 ES_NSO_00330      
/* Bharath A   09/04/2011 10H109_NSO_00002 */      
/* john v    01/11/2011 ES_NSO_00490        */      
/* Divyalekaa   29/11/2013 ES_Po_01439   */\      
   Banu M               22/09/2017  HAL-227      
   Sivasankari          5/03/2018        MKN-57      
/* Balasubramaniyam P 04/06/2018  EBS-1362*/      
/* Banu M               20/11/2019      AFL-284 */  
/*Lavanya N             27/11/2020      EBS-5186*/   
/*Ambrin banu S   21/04/2022  DSDE-228*/   
/*Vasantha a   30/08/2022  KPE-561 */  
 /*Chaitanya Ch        15/11/2023          EPE-58525*/   
/* Shrimalavika M  25-03-2024  RITSL/PJRMC-124 */  
******************************************************************************************/         
create    procedure sopp_vwmn_sp_uiordhref        
  @ctxt_language   udd_ctxt_language,        
     @ctxt_ouinstance  udd_ctxt_ouinstance,        
     @ctxt_service   udd_ctxt_service,        
     @ctxt_user    udd_ctxt_user,        
     @addressidml   udd_addressid,        
     @amend_no    udd_documentno,        
     @buid     udd_buid,        
     @carriercode   udd_carriercode,        
     @currency    udd_currency,        
    --@cuspono    udd_documentno,--MKN-57        
  --@cuspono               udd_cust_po_no,--MKN-57       
   @cuspono      udd_trandesc,--EPE-58525  
     @custname    udd_custname,        
     @customercode   udd_customer_id,        
     @freight_bill   udd_flag,        
     @freightamount   udd_amount,        
     @frt_currency   udd_currencycode,        
     @frtmethod    udd_desc20,        
    /*code added for HAL-227 starts here*/      
   -- @gross_volume         udd_volume ,      
      @gross_volume         udd_weight,      
   /*code added for HAL-227 ends here*/      
     @gross_weight   udd_weight,        
     @hidden_control1  udd_hiddencontrol,        
     @hidden_control2  udd_hiddencontrol,        
     @loid     udd_loid,        
     @netweight    udd_weight,        
     @num_series   udd_notypeno,        
     @ord_bas_val   udd_amount,        
     @ord_tot_val   udd_amount,        
     @ord_type    udd_documenttype,        
     @order_date   udd_date,        
     @order_no    udd_documentno,        
     @overridewt   udd_quantity,        
     @overridvol   udd_quantity,        
     @podate    udd_date,        
     @priceuom    udd_uomcode,        
     @pricingdate   udd_date,        
     @promiseddate   udd_date,        
     @reason_code   udd_identificationnumber1,        
     @reason_desc   udd_desc40,        
     @reqddate    udd_date,        
     @sale_type    udd_sales,  
     @screenid    udd_desc16,        
     @shippingpoint   udd_ouinstname,        
     @shiptoaddid   udd_id,        
     @shiptocustomer  udd_customer_id,        
  @sourcedocno   udd_documentno,        
     @sourcedocument_qso    udd_document,        
     @status1    udd_status,        
     @total_charge   udd_amount,        
     @total_discount  udd_amount,        
     @total_tax    udd_amount,        
     @total_vat    udd_amount,        
  @trans_mode   udd_identificationnumber1,        
     @volume_uom   udd_uomcode,        
     @warehouse    udd_warehouse,        
     @weight_uom   udd_uomcode,        
     /*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/       
     @salesperson   udd_saleperson_id,      
     @folder    udd_folder,       
     @saleschannel   udd_saleschannel,      
     /*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/      
 /*Code added by Damodharan. R on 01 Aug 2008 for Defect ID ES_NSO_00041 starts here*/      
 @advance    udd_amount,      
 @check_loi    udd_checkbox,      
 @paytermcode   udd_paytermcode,      
 --@contact_person   udd_customertype2, --DSDE-228  
 @contact_person   udd_remarks, -- DSDE-228      
 @exchangerate   udd_exchangerate,      
 @createdby    udd_ctxt_user,      
 @createddate   udd_date,      
 @modifiedby    udd_ctxt_user,      
 @modifieddate   udd_date,      
 /*Code added by Damodharan. R on 01 Aug 2008 for Defect ID ES_NSO_00041 ends here*/      
 @wfstatus_state   udd_wfstatename, --Added for DTS ID: ES_NSO_00206      
 /*code added for defect id : EBS-1362 starts here*/      
 @customertaxregion       udd_tcdcode,       
 @owntaxregion            udd_tcdcode,      
 @taxregnno               udd_desc40,       
 /*code added for defect id : EBS-1362 ends here*/      
 @qso_dockey          udd_desc255, --Input/Output --code added for AFL-284      
 @csou                udd_ctxt_ouinstance, --Input/Output --AFL-284       
 @reasonforamendment  udd_desc1000, --Input/Output  ---code added for EBS-5186  
    @m_errorid    udd_int output --to return execution status        
as        
        
BEGIN      
 -- declare @iudmodeflag nvarchar(2)         
       
       
 -- nocount should be switched on to prevent phantom rows         
 SET NOCOUNT ON       
       
       
 -- @m_errorid should be 0 to indicate success        
 SELECT @m_errorid = 0       
       
 --declare temp variables      
 DECLARE @workflow_app udd_metadata_code /*Code Added for the DTS id:ES_NSO_00206*/      
       
 /*Code added by Damodharan. R on 01 Aug 2008 for Defect ID ES_NSO_00041 starts here*/      
 SELECT @check_loi = LTRIM(RTRIM(@check_loi))      
 SELECT @paytermcode = LTRIM(RTRIM(@paytermcode))      
 SELECT @contact_person = LTRIM(RTRIM(@contact_person))      
 SELECT @createdby = LTRIM(RTRIM(@createdby))      
 SELECT @modifiedby = LTRIM(RTRIM(@modifiedby))      
 /*Code added by Damodharan. R on 01 Aug 2008 for Defect ID ES_NSO_00041 ends here*/             
 SELECT @wfstatus_state = LTRIM(RTRIM(@wfstatus_state)) --Added for DTS ID: ES_NSO_00206      
       
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
       
 SELECT @addressidml = UPPER(LTRIM(RTRIM(@addressidml)))        
 IF @addressidml = '~#~'      
     SELECT @addressidml = NULL        
       
 SELECT @amend_no = UPPER(LTRIM(RTRIM(@amend_no)))        
 IF @amend_no = '~#~'      
     SELECT @amend_no = NULL        
       
 SELECT @buid = UPPER(LTRIM(RTRIM(@buid)))        
 IF @buid = '~#~'      
     SELECT @buid = NULL        
       
 SELECT @carriercode = UPPER(LTRIM(RTRIM(@carriercode)))        
 IF @carriercode = '~#~'      
     SELECT @carriercode = NULL        
       
 SELECT @currency = UPPER(LTRIM(RTRIM(@currency)))        
 IF @currency = '~#~'      
     SELECT @currency = NULL        
       
 SELECT @cuspono = UPPER(LTRIM(RTRIM(@cuspono)))        
 IF @cuspono = '~#~'     
   SELECT @cuspono = NULL        
       
 SELECT @custname = UPPER(LTRIM(RTRIM(@custname)))        
 IF @custname = '~#~'      
     SELECT @custname = NULL        
       
 SELECT @customercode = UPPER(LTRIM(RTRIM(@customercode)))   
 IF @customercode = '~#~'      
     SELECT @customercode = NULL        
       
 SELECT @freight_bill = UPPER(LTRIM(RTRIM(@freight_bill)))        
 IF @freight_bill = '~#~'      
     SELECT @freight_bill = NULL        
       
 IF @freightamount = -915      
     SELECT @freightamount = NULL        
       
 SELECT @frt_currency = UPPER(LTRIM(RTRIM(@frt_currency)))        
 IF @frt_currency = '~#~'      
     SELECT @frt_currency = NULL        
       
 SELECT @frtmethod = UPPER(LTRIM(RTRIM(@frtmethod)))        
 IF @frtmethod = '~#~'     
     SELECT @frtmethod = NULL        
       
 IF @gross_volume = -915      
     SELECT @gross_volume = NULL        
       
 IF @gross_weight = -915      
     SELECT @gross_weight = NULL        
       
 SELECT @hidden_control1 = UPPER(LTRIM(RTRIM(@hidden_control1)))        
 IF @hidden_control1 = '~#~'      
     SELECT @hidden_control1 = NULL        
       
 SELECT @hidden_control2 = UPPER(LTRIM(RTRIM(@hidden_control2)))        
 IF @hidden_control2 = '~#~'      
     SELECT @hidden_control2 = NULL        
       
 SELECT @loid = UPPER(LTRIM(RTRIM(@loid)))        
 IF @loid = '~#~'      
     SELECT @loid = NULL        
       
 IF @netweight = -915      
     SELECT @netweight = NULL        
       
 SELECT @num_series = UPPER(LTRIM(RTRIM(@num_series)))        
 IF @num_series = '~#~'      
     SELECT @num_series = NULL        
       
 IF @ord_bas_val = -915      
     SELECT @ord_bas_val = NULL        
       
 IF @ord_tot_val = -915      
     SELECT @ord_tot_val = NULL        
       
 SELECT @ord_type = UPPER(LTRIM(RTRIM(@ord_type)))        
 IF @ord_type = '~#~'      
     SELECT @ord_type = NULL        
       
 IF @order_date = '01/01/1900'      
     SELECT @order_date = NULL        
       
 SELECT @order_no = UPPER(LTRIM(RTRIM(@order_no)))        
 IF @order_no = '~#~'      
     SELECT @order_no = NULL        
       
 IF @overridewt = -915      
     SELECT @overridewt = NULL        
       
 IF @overridvol = -915      
     SELECT @overridvol = NULL        
       
 IF @podate = '01/01/1900'      
     SELECT @podate = NULL        
       
 SELECT @priceuom = UPPER(LTRIM(RTRIM(@priceuom)))        
 IF @priceuom = '~#~'      
     SELECT @priceuom = NULL        
       
 IF @pricingdate = '01/01/1900'      
     SELECT @pricingdate = NULL        
       
 IF @promiseddate = '01/01/1900'      
     SELECT @promiseddate = NULL        
       
 SELECT @reason_code = UPPER(LTRIM(RTRIM(@reason_code)))        
 IF @reason_code = '~#~'      
     SELECT @reason_code = NULL        
       
 SELECT @reason_desc = UPPER(LTRIM(RTRIM(@reason_desc)))        
 IF @reason_desc = '~#~'      
     SELECT @reason_desc = NULL        
       
 IF @reqddate = '01/01/1900'      
     SELECT @reqddate = NULL        
       
 SELECT @sale_type = UPPER(LTRIM(RTRIM(@sale_type)))        
 IF @sale_type = '~#~'      
     SELECT @sale_type = NULL        
       
 SELECT @screenid = UPPER(LTRIM(RTRIM(@screenid)))        
 IF @screenid = '~#~'      
     SELECT @screenid = NULL        
       
 SELECT @shippingpoint = UPPER(LTRIM(RTRIM(@shippingpoint)))        
 IF @shippingpoint = '~#~'      
     SELECT @shippingpoint = NULL        
 
 SELECT @shiptoaddid = UPPER(LTRIM(RTRIM(@shiptoaddid)))        
 IF @shiptoaddid = '~#~'      
     SELECT @shiptoaddid = NULL        
       
 SELECT @shiptocustomer = UPPER(LTRIM(RTRIM(@shiptocustomer)))        
 IF @shiptocustomer = '~#~'      
     SELECT @shiptocustomer = NULL        
       
 SELECT @sourcedocno = UPPER(LTRIM(RTRIM(@sourcedocno)))        
 IF @sourcedocno = '~#~'      
     SELECT @sourcedocno = NULL        
       
 SELECT @sourcedocument_qso = UPPER(LTRIM(RTRIM(@sourcedocument_qso)))        
 IF @sourcedocument_qso = '~#~'      
     SELECT @sourcedocument_qso = NULL       
       
 SELECT @status1 = UPPER(LTRIM(RTRIM(@status1)))        
 IF @status1 = '~#~'      
     SELECT @status1 = NULL        
       
 IF @total_charge = -915      
     SELECT @total_charge = NULL        
       
 IF @total_discount = -915      
     SELECT @total_discount = NULL      
       
 IF @total_tax = -915      
     SELECT @total_tax = NULL        
       
 IF @total_vat = -915      
     SELECT @total_vat = NULL        
       
 SELECT @trans_mode = UPPER(LTRIM(RTRIM(@trans_mode)))        
 IF @trans_mode = '~#~'      
     SELECT @trans_mode = NULL        
       
 SELECT @volume_uom = UPPER(LTRIM(RTRIM(@volume_uom)))        
 IF @volume_uom = '~#~'      
     SELECT @volume_uom = NULL        
       
 SELECT @warehouse = UPPER(LTRIM(RTRIM(@warehouse)))        
 IF @warehouse = '~#~'      
     SELECT @warehouse = NULL        
       
 SELECT @weight_uom = UPPER(LTRIM(RTRIM(@weight_uom)))        
 IF @weight_uom = '~#~'      
     SELECT @weight_uom = NULL       
       
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
  
 /*code added for EBS-5186 starts here*/  
   
 Select @reasonforamendment  = ltrim(rtrim(@reasonforamendment))  
 IF @reasonforamendment = '~#~'   
  Select @reasonforamendment = null  
  
 /*code added for EBS-5186 ends here*/  
       
 /*Code added by Damodharan. R on 01 Aug 2008 for Defect ID ES_NSO_00041 starts here*/      
 IF @advance = -915      
     SELECT @advance = NULL        
       
 IF @check_loi = '~#~'      
     SELECT @check_loi = NULL        
       
 IF @paytermcode = '~#~'      
     SELECT @paytermcode = NULL        
       
 IF @contact_person = '~#~'      
     SELECT @contact_person = NULL        
       
 IF @exchangerate = -915      
     SELECT @exchangerate = NULL        
       
 IF @createdby = '~#~'      
     SELECT @createdby = NULL        
       
 IF @createddate = '01/01/1900'      
     SELECT @createddate = NULL        
       
 IF @modifiedby = '~#~'      
     SELECT @modifiedby = NULL        
       
 IF @modifieddate = '01/01/1900'      
     SELECT @modifieddate = NULL       
 /*Code added by Damodharan. R on 01 Aug 2008 for Defect ID ES_NSO_00041 ends here*/      
       
 --Added for DTS ID: ES_NSO_00206 starts here      
 IF @wfstatus_state = '~#~'      
     SELECT @wfstatus_state = NULL       
 --Added for DTS ID: ES_NSO_00206 ends here       
 --code added for AFL-284 starts here      
 IF @qso_dockey = '~#~'      
     SELECT @qso_dockey = NULL       
      
 IF @csou = -915      
  Select @csou = null       
 --code added for AFL-284 ends here      
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
       
 /*Code added for ES_Po_01439 begins here*/       
 declare @companycode_tmp udd_companycode,      
   @prjmgmtacc   udd_desc20,      
   @tran_date   udd_date,      
   @workflow_status udd_status,      
   @hdnrt_stcontrol udd_ctxt_state_name      
         
 select @tran_date = dbo.RES_Getdate(@ctxt_ouinstance)         
         
 select  @companycode_tmp = company_code        
 from   emod_ou_vw  (NOLOCK)      
 where  ou_id    = @ctxt_ouinstance      
 and  @tran_date between isnull(effective_from,'01/01/1900') and isnull(effective_to,'01/01/9999')       
       
 SELECT  @prjmgmtacc   = parameter_code        
 from ips_processparam_sys ips (nolock)      
 Where company_code  = @companycode_tmp       
 and  parameter_type  = 'CPSYS'      
 and  parameter_category = 'PROJECTACCTFLAG'      
 and  language_id   = @ctxt_language      
       
 if  exists(  select '*'      
     from so_order_item_dtl (nolock)      
     where sodtl_ou     = @ctxt_ouinstance      
     and  sodtl_order_no = @order_no      
     and  isnull(sodtl_projectcode,'') <> ''      
      )       
 begin      
  select @ctxt_ouinstance = @ctxt_ouinstance      
 end      
 else      
 begin      
  select @prjmgmtacc = 'N'      
 end         
 /*Code added for ES_Po_01439 ends here*/        
       
 IF RTRIM(@order_no) IS NULL      
 OR RTRIM(@order_no) = ''      
 BEGIN      
     --^orderno!<orderno> can not be null.        
     SELECT @m_errorid = 3550040       
     RETURN      
 END        
       
       
 IF EXISTS (      
        SELECT 'x'      
        FROM   so_order_hdr(NOLOCK)      
        WHERE  sohdr_ou = @ctxt_ouinstance      
        AND    sohdr_order_no = RTRIM(@order_no)      
    )      
 BEGIN      
     SELECT @order_no = @order_no      
 END      
 ELSE      
 BEGIN      
     --<^order_no!> "<%order_no%>" is not Valid.Please Check.        
     SELECT @m_errorid = 3550133       
     RETURN      
 END       
       
 --Added for DTS ID: ES_NSO_00206 starts here      
 SELECT @workflow_app = dbo.workflowapp_fet_fn(@ctxt_user, @ctxt_ouinstance, 'NSO', 'NSOSO', 'ANY')      
 --Added for DTS ID: ES_NSO_00206 ends here      
      
       
 --If amendment no is null then get amendment no from the header        
 IF RTRIM(@amend_no) IS NULL      
 BEGIN      
     SELECT @amend_no = sohdr_amend_no      
     FROM   so_order_hdr(NOLOCK)      
     WHERE  sohdr_ou = @ctxt_ouinstance      
     AND    sohdr_order_no = RTRIM(@order_no)      
 END        
       
 /*Code added for ES_Po_01439 begins here*/       
 select @workflow_status = sohdr_workflow_status      
    FROM   so_order_hdr(NOLOCK)      
    WHERE  sohdr_ou   =  @ctxt_ouinstance      
    AND    sohdr_order_no =  RTRIM(@order_no)      
    AND    sohdr_amend_no =  @amend_no       
       
      
 if @prjmgmtacc = 'Y'      
 begin      
  if @workflow_app = 'N' OR @workflow_status IS NULL      
  begin      
        select @hdnrt_stcontrol =  'wfstate_vwqso_hide_proj'      
     end      
     else      
     begin                
        select @hdnrt_stcontrol =  'wfstate_vwqso_proj'      
     end         
 end       
 else      
 begin      
 ---select 'sa'      
  if @workflow_app = 'N' OR @workflow_status IS NULL      
  begin      
        select @hdnrt_stcontrol =  'wfstate_vwqso_hide'      
     end      
     else      
  begin                
        select @hdnrt_stcontrol =  'wfstate_vwqso'      
     end                
 end      
 /*Code added for ES_Po_01439 ends here*/       
       
 IF EXISTS (      
        SELECT 'x'      
        FROM   so_order_hdr(NOLOCK)      
        WHERE  sohdr_ou = @ctxt_ouinstance      
        AND    sohdr_order_no = RTRIM(@order_no)      
        AND    sohdr_amend_no = @amend_no      
    )      
 BEGIN  
     SELECT RTRIM(h.sohdr_order_from_id) 'ADDRESSIDML',      
            h.sohdr_amend_no 'AMEND_NO',      
            RTRIM(h.sohdr_bu) 'BUID',      
            h.sohdr_prefered_carrier 'CARRIERCODE',      
            RTRIM(h.sohdr_currency) 'CURRENCY',      
            RTRIM(h.sohdr_cust_po_no) 'CUSPONO',      
            RTRIM(c.clo_cust_name) 'CUSTNAME',      
            RTRIM(h.sohdr_order_from_cust) 'CUSTOMERCODE',      
            RTRIM(m3.paramdesc) 'FREIGHT_BILL',      
            h.sohdr_freight_amount 'FREIGHTAMOUNT',      
            RTRIM(h.sohdr_freight_currency) 'FRT_CURRENCY',      
            RTRIM(m4.paramdesc) 'FRTMETHOD',      
            h.sohdr_gross_volume 'GROSS_VOLUME',      
            h.sohdr_gross_weight 'GROSS_WEIGHT',      
            'SAL_NSO' 'HIDDEN_CONTROL1',     
            NULL 'HIDDEN_CONTROL2',      
     RTRIM(h.sohdr_lo) 'LOID',      
            h.sohdr_net_weight 'NETWEIGHT',      
            RTRIM(h.sohdr_num_series) 'NUM_SERIES',      
            h.sohdr_basic_value 'ORD_BAS_VAL',      
            h.sohdr_total_value 'ORD_TOT_VAL',      
            RTRIM(m2.paramdesc) 'ORD_TYPE',      
            CONVERT(nchar(10), h.sohdr_order_date, 120) 'ORDER_DATE',      
            RTRIM(h.sohdr_order_no) 'ORDER_NO',      
            h.sohdr_overriding_weight 'OVERRIDEWT',      
            h.sohdr_overriding_volume 'OVERRIDVOL',      
            CONVERT(nchar(10), h.sohdr_cust_po_date, 120) 'PODATE',      
            NULL 'PRICEUOM',      
            CONVERT(nchar(10), h.sohdr_pric_date_dflt, 120) 'PRICINGDATE',      
            CONVERT(nchar(10), h.sohdr_prm_date_dflt, 120) 'PROMISEDDATE',      
            RTRIM(h.sohdr_reason_no) 'REASON_CODE',      
            RTRIM(r.reason_desc) 'REASON_DESC',      
            CONVERT(nchar(10), h.sohdr_req_date_dflt, 120) 'REQDDATE',      
            RTRIM(h.sohdr_sale_type_dflt) 'SALE_TYPE',      
            NULL 'SCREENID',      
            RTRIM(s.ouinstname) 'SHIPPINGPOINT',      
            RTRIM(h.sohdr_ship_to_id_dflt) 'SHIPTOADDID',      
            RTRIM(h.sohdr_shiptocust_dflt) 'SHIPTOCUSTOMER',      
            RTRIM(h.sohdr_ref_doc_no) 'SOURCEDOCNO',      
            RTRIM(m1.paramdesc) 'SOURCEDOCUMENT_QSO',      
            RTRIM(m5.paramdesc) 'STATUS1',      
            h.sohdr_total_charges 'TOTAL_CHARGE',      
            h.sohdr_total_discount 'TOTAL_DISCOUNT',      
            h.sohdr_total_tax 'TOTAL_TAX',      
            /* Starts - Code modified by Geetha.S for bug id : PPSCMQSODMS412AT_000025 */      
            --   h.sohdr_total_vat     'TOTAL_VAT',        
            h.sohdr_total_tcal_amount 'TOTAL_VAT',      
            /* Ends - Code modified by Geetha.S for bug id : PPSCMQSODMS412AT_000025 */      
            RTRIM(h.sohdr_trnsprt_mode_dflt) 'TRANS_MODE',      
            RTRIM(h.sohdr_volume_uom) 'VOLUME_UOM',      
            RTRIM(h.sohdr_wh_dflt) 'WAREHOUSE',      
            RTRIM(h.sohdr_weight_uom) 'WEIGHT_UOM',      
            1 'FPROWNO',      
            /*code modified for the pre41 design changes out parameter added- anand-begin*/      
            'SAL_NSO' 'TTYPE25',      
            @ctxt_ouinstance 'tranou', --NSODMS412AT_000527      
            /*code modified for the pre41 design changes out parameter added- anand-ends*/      
            /*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/       
            RTRIM(h.sohdr_sales_person_dflt) 'SALESPERSON',      
            RTRIM(h.sohdr_folder) 'FOLDER',      
            RTRIM(h.sohdr_sales_channel) 'SALESCHANNEL',      
            /*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/      
            /*Code added by Damodharan. R on 01 Aug 2008 for Defect ID ES_NSO_00041 starts here*/      
            sohdr_advance_amt 'ADVANCE',      
            sohdr_loi_flag 'CHECK_LOI',      
       sohdr_pay_term_code 'PAYTERMCODE',      
            sohdr_contact_person 'CONTACT_PERSON',      
            sohdr_exch_rate 'EXCHANGERATE',      
            sohdr_created_by 'CREATEDBY',      
            sohdr_created_date 'CREATEDDATE',      
            sohdr_modified_by 'MODIFIEDBY',      
            sohdr_modified_date 'MODIFIEDDATE',      
            /*Code added by Damodharan. R on 01 Aug 2008 for Defect ID ES_NSO_00041 ends here*/      
            /*Added for DTS ID: ES_NSO_00118 starts here*/      
            dbo.get_metadata_desc_fn(      
                'NSO',      
                'COMBO',      
                'PART_SHIPMENT',      
                sohdr_part_shipment,      
                @ctxt_language      
            ) 'PARTSHIPMENT',      
            /*Added for DTS ID: ES_NSO_00118 ends here*/      
            --Added for DTS ID: ES_NSO_00206 starts here      
            LTRIM(      
                RTRIM(dbo.wf_metadesc_fet_fn('NSOSO', sohdr_workflow_status))      
            ) 'WFSTATUS',      
            /*Code modified for ES_Po_01439 begins here*/       
            --CASE       
            --     WHEN @workflow_app = 'N' OR sohdr_workflow_status IS NULL THEN       
       --          'wfstate_vwqso_hide'      
            --     ELSE 'wfstate_vwqso'      
            --END 'WFSTATUS_STATE',      
           @hdnrt_stcontrol  'WFSTATUS_STATE',--test      
             /*Code modified for ES_Po_01439 ends here*/      
            --Added for DTS ID: ES_NSO_00206 ends here                 
            /*Code removed for 10H109_NSO_00002 begin */      
      /*      
     --LTRIM(      
     --         RTRIM(      
     --             dbo.get_metadata_desc_fn(      
     --                 'NSO',      
     --                 'COMBO',      
     --                 'LC_APPLICABLE',      
     --                 Sohdr_lc_appl_flag,      
     --                 @ctxt_language      
     --             )      
     --         )      
     --     )'LCAPPLICABLE'--Added for DTS ID: ES_PACKSLIP_00204      
      */      
      /*Code removed for 10H109_NSO_00002 end */      
      /*Code Added for 10H109_NSO_00002 begin */      
      case  when sohdr_lc_appl_flag = 'Y' and  sohdr_bg_appl_flag = 'N'       
      then  dbo.get_metadata_desc_fn('NSO','COMBO','BG_APPLICABLE','LC',@ctxt_language)       
      when sohdr_lc_appl_flag = 'N' and  sohdr_bg_appl_flag = 'Y'       
      then dbo.get_metadata_desc_fn('NSO','COMBO','BG_APPLICABLE','BG',@ctxt_language)        
      when sohdr_lc_appl_flag = 'Y' and  sohdr_bg_appl_flag = 'Y'       
      then dbo.get_metadata_desc_fn('NSO','COMBO','BG_APPLICABLE','LC & BG',@ctxt_language)        
      else dbo.get_metadata_desc_fn('NSO','COMBO','BG_APPLICABLE','NONE',@ctxt_language)      
      end 'LCAPPLICABLE',      
    --Code Added by john on 01/11/2011 for ES_NSO_00490 begin      
    'SAL_NSO_VW'   'Hiddentrantype'       
    --Code Added by john on 01/11/2011 for ES_NSO_00490 end       
      /*Code Added for 10H109_NSO_00002 end */      
      /*Code Added for 10H109_NSO_00002 end */      
      ,@hdnrt_stcontrol 'hdnrt_stcontrol'--ES_Po_01439      
    -- ,'wfstate_vwqso' 'hdnrt_stcontrol' --test      
      /*code added for defect id : EBS-1362 starts here*/      
      ,sohdr_party_tax_region      'CUSTOMERTAXREGION'       
      ,sohdr_own_tax_region      'OWNTAXREGION'       
      ,sohdr_party_regd_no       'TAXREGNNO'      
   ,h.reason_for_amendment       'reasonforamendment' --code added for EBS-5186  
      /*code added for defect id : EBS-1362 ends here*/      
      --code added for AFL-284 starts here      
   --code modified by vasantha a for KPE-561 begins  
      --,'NSO'+'$~$'+convert(nvarchar(28),h.sohdr_ou)+'$~$'+h.sohdr_order_no+'$~$'+convert(nvarchar(28),h.sohdr_amend_no)  'QSO_DOCKEY'        
   /* Code commented and added for RITSL/PJRMC-124 Begins */  
  -- ,'NSO'+'$~$'+convert(nvarchar(28),h.sohdr_ou)+'$~$'+h.sohdr_order_no  'QSO_DOCKEY'        
   ,'NSO'+'$~$'+convert(nvarchar(28),h.sohdr_ou)+'$~$'+h.sohdr_order_no+'$~$'+convert(nvarchar(28),sohdr_amend_no)  'QSO_DOCKEY'     
   /* Code commented and added for RITSL/PJRMC-124 Ends */  
   --code modified by vasantha a for KPE-561 ends  
            ,@ctxt_ouinstance 'CSOU'      
     
     --code added for AFL-284 ends here      
  FROM   fw_admin_view_ouinstance s(NOLOCK),      
            cust_lo_info_vw c(NOLOCK),      
            component_metadata_table m2(NOLOCK),      
            component_metadata_table m3(NOLOCK),      
            component_metadata_table m5(NOLOCK),      
            so_order_hdr h(NOLOCK)    
     
           LEFT OUTER JOIN cat_shp_reason_vw r(NOLOCK)      
                 ON  h.sohdr_reason_no = RTRIM(r.reason_code)      
     AND             h.sohdr_lo = RTRIM(r.lo)      
     AND             h.sohdr_ou = RTRIM(r.ouinstid)      
            LEFT OUTER JOIN component_metadata_table m1(NOLOCK)      
                 ON  h.sohdr_ref_doc_type = m1.paramcode      
     AND             m1.componentname = 'NSO'      
     AND             m1.paramcategory = 'TYPE'      
     AND             m1.paramtype = 'SO_REF_DOC_TYPE'      
     AND             m1.langid = @ctxt_language      
            LEFT OUTER JOIN component_metadata_table m4(NOLOCK)      
                ON    
                  h.sohdr_freight_method = m4.paramcode      
     AND             m4.componentname = 'NSO'      
     AND             m4.paramcategory = 'COMBO'      
     AND             m4.paramtype = 'SO_FRT_MET'      
     AND             m4.langid = @ctxt_language      
     WHERE  h.sohdr_ou = @ctxt_ouinstance   
     AND    h.sohdr_order_no = RTRIM(@order_no)      
     AND    h.sohdr_amend_no = @amend_no      
     AND    h.sohdr_lo = RTRIM(c.clo_lo)      
     AND    h.sohdr_order_from_cust = RTRIM(c.clo_cust_code)      
     AND    h.sohdr_ou = RTRIM(s.ouinstid)      
     AND    m2.componentname = 'NSO'      
     AND    m2.paramcategory = 'COMBO'      
     AND    m2.paramtype = 'SO_ORDER_TYPE'      
     AND    m2.paramcode = RTRIM(h.sohdr_order_type)  
     AND    m2.langid = @ctxt_language      
     AND    m3.componentname = 'NSO'      
     AND    m3.paramcategory = 'COMBO'      
     AND    m3.paramtype = 'SO_FREIGHT_BILL'      
     AND    m3.paramcode = RTRIM(SUBSTRING(h.sohdr_freight_billable, 1, 1))      
     AND    m3.langid = @ctxt_language      
     AND    m5.componentname = 'NSO'      
     AND    m5.paramcategory = 'STATUS'      
     AND    m5.paramtype = 'SO_STATUS'      
     AND    m5.paramcode = RTRIM(h.sohdr_order_status)      
     AND    m5.langid = @ctxt_language      
 END      
 ELSE      
 BEGIN      
     IF EXISTS (      
            SELECT 'x'      
            FROM   sohist_order_hdr(NOLOCK)      
            WHERE  sohdr_ou = @ctxt_ouinstance      
            AND    sohdr_order_no = RTRIM(@order_no)      
            AND    sohdr_amend_no = @amend_no      
        )      
     BEGIN      
         SELECT RTRIM(sh.sohdr_order_from_id) 'ADDRESSIDML',      
               sh.sohdr_amend_no 'AMEND_NO',      
                RTRIM(sh.sohdr_bu) 'BUID',      
                sh.sohdr_prefered_carrier 'CARRIERCODE',      
                RTRIM(sh.sohdr_currency) 'CURRENCY',      
                RTRIM(sh.sohdr_cust_po_no) 'CUSPONO',      
                RTRIM(c.clo_cust_name) 'CUSTNAME',      
                RTRIM(sh.sohdr_order_from_cust) 'CUSTOMERCODE',      
                RTRIM(m3.paramdesc) 'FREIGHT_BILL',      
                sh.sohdr_freight_amount 'FREIGHTAMOUNT',      
                RTRIM(sh.sohdr_freight_currency) 'FRT_CURRENCY',      
          RTRIM(m4.paramdesc) 'FRTMETHOD',      
                sh.sohdr_gross_volume 'GROSS_VOLUME',      
                sh.sohdr_gross_weight 'GROSS_WEIGHT',      
                'SAL_NSO' 'HIDDEN_CONTROL1',      
                NULL 'HIDDEN_CONTROL2',      
                RTRIM(sh.sohdr_lo) 'LOID',      
                sh.sohdr_net_weight 'NETWEIGHT',      
                RTRIM(sh.sohdr_num_series) 'NUM_SERIES',      
                sh.sohdr_basic_value 'ORD_BAS_VAL',      
                sh.sohdr_total_value 'ORD_TOT_VAL',      
                RTRIM(m2.paramdesc) 'ORD_TYPE',      
                CONVERT(nchar(10), sh.sohdr_order_date, 120) 'ORDER_DATE',      
                RTRIM(sh.sohdr_order_no) 'ORDER_NO',      
                sh.sohdr_overriding_weight 'OVERRIDEWT',      
                sh.sohdr_overriding_volume 'OVERRIDVOL',      
                CONVERT(nchar(10), sh.sohdr_cust_po_date, 120) 'PODATE',      
                NULL 'PRICEUOM',      
                CONVERT(nchar(10), sh.sohdr_pric_date_dflt, 120) 'PRICINGDATE',      
                CONVERT(nchar(10), sh.sohdr_prm_date_dflt, 120) 'PROMISEDDATE',      
                RTRIM(sh.sohdr_reason_no) 'REASON_CODE',      
                RTRIM(r.reason_desc) 'REASON_DESC',      
                CONVERT(nchar(10), sh.sohdr_req_date_dflt, 120) 'REQDDATE',      
                RTRIM(sh.sohdr_sale_type_dflt) 'SALE_TYPE',      
                NULL 'SCREENID',      
                RTRIM(s.ouinstname) 'SHIPPINGPOINT',      
                RTRIM(sh.sohdr_ship_to_id_dflt) 'SHIPTOADDID',      
                RTRIM(sh.sohdr_shiptocust_dflt) 'SHIPTOCUSTOMER',      
                RTRIM(sh.sohdr_ref_doc_no) 'SOURCEDOCNO',      
                RTRIM(m1.paramdesc) 'SOURCEDOCUMENT_QSO',      
RTRIM(m5.paramdesc) 'STATUS1',      
    sh.sohdr_total_charges 'TOTAL_CHARGE',      
                sh.sohdr_total_discount 'TOTAL_DISCOUNT',      
                sh.sohdr_total_tax 'TOTAL_TAX',      
                /* Starts - Code modified by Geetha.S for bug id : PPSCMQSODMS412AT_000025 */      
                --       sh.sohdr_total_vat     'TOTAL_VAT',        
                sh.sohdr_total_tcal_amount 'TOTAL_VAT',      
                /* Ends - Code modified by Geetha.S for bug id : PPSCMQSODMS412AT_000025 */      
                RTRIM(sh.sohdr_trnsprt_mode_dflt) 'TRANS_MODE',      
                RTRIM(sh.sohdr_volume_uom) 'VOLUME_UOM',      
                RTRIM(sh.sohdr_wh_dflt) 'WAREHOUSE',      
                RTRIM(sh.sohdr_weight_uom) 'WEIGHT_UOM',      
                1 'FPROWNO',      
                /*code modified for the pre41 design changes out parameter added- anand-begin*/      
                /*Code added by Santhosh.A for PPSCMQSOPPS41_000114  on 11/10/2006 Starts*/      
                'SAL_NSO' 'TTYPE25',      
                @ctxt_ouinstance 'tranou',      
                /*Code added by Santhosh.A for PPSCMQSOPPS41_000114  on 11/10/2006 Ends*/      
                /*code modified for the pre41 design changes out parameter added- anand-ends*/      
                /*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 starts here*/       
                RTRIM(sh.sohdr_sales_person_dflt) 'SALESPERSON',      
                RTRIM(sh.sohdr_folder) 'FOLDER',      
                RTRIM(sh.sohdr_sales_channel) 'SALESCHANNEL',      
                /*code added by Veangadakrishnan R for DTS ID: DMS412AT_NSO_00030 ends here*/      
                /*Code added by Damodharan. R on 01 Aug 2008 for Defect ID ES_NSO_00041 starts here*/      
                sohdr_advance_amt 'ADVANCE',      
                sohdr_loi_flag 'CHECK_LOI',      
                sohdr_pay_term_code 'PAYTERMCODE',      
                sohdr_contact_person 'CONTACT_PERSON',      
                sohdr_exch_rate 'EXCHANGERATE',      
                sohdr_created_by 'CREATEDBY',      
                sohdr_created_date 'CREATEDDATE',      
                sohdr_modified_by 'MODIFIEDBY',      
                sohdr_modified_date 'MODIFIEDDATE',      
                /*Code added by Damodharan. R on 01 Aug 2008 for Defect ID ES_NSO_00041 ends here*/      
                /*Added for DTS ID: ES_NSO_00118 starts here*/      
                dbo.get_metadata_desc_fn(      
                    'NSO',      
                    'COMBO',      
                    'PART_SHIPMENT',      
                    sohdr_part_shipment,      
                    @ctxt_language      
                ) 'PARTSHIPMENT',      
                /*Added for DTS ID: ES_NSO_00118 ends here*/      
                --Added for DTS ID: ES_NSO_00206 starts here      
                LTRIM(      
                    RTRIM(dbo.wf_metadesc_fet_fn('NSOSO', sohdr_workflow_status))      
                ) 'WFSTATUS',      
                /*Code modified for ES_Po_01439 begins here*/      
                --CASE       
                --     WHEN @workflow_app = 'N' OR sohdr_workflow_status IS       
                --          NULL THEN 'wfstate_vwqso_hide'      
                --     ELSE 'wfstate_vwqso'      
                --END 'WFSTATUS_STATE',      
                @hdnrt_stcontrol 'WFSTATUS_STATE',--test      
                /*Code modified for ES_Po_01439 ends here*/      
                --Added for DTS ID: ES_NSO_00206 ends here                      
                 /*Code removed for 10H109_NSO_00002 begin */      
 /*      
     --LTRIM(      
     --    RTRIM(      
     --     dbo.get_metadata_desc_fn(      
     --      'NSO',      
     --      'COMBO',      
     --      'LC_APPLICABLE',      
     --      ISNULL(sohdr_lc_appl_flag, 'N'),      
     --      @ctxt_language      
     --     )      
     --    )      
     --   )'LCAPPLICABLE'--Added for DTS ID: ES_PACKSLIP_00204      
*/      
     /*Code removed for 10H109_NSO_00002 end */      
     /*Code Added for 10H109_NSO_00002 begin */      
       case  when sohdr_lc_appl_flag = 'Y' and  sohdr_bg_appl_flag = 'N'       
       then  dbo.get_metadata_desc_fn('NSO','COMBO','BG_APPLICABLE','LC',@ctxt_language)       
       when sohdr_lc_appl_flag = 'N' and  sohdr_bg_appl_flag = 'Y'     
       then dbo.get_metadata_desc_fn('NSO','COMBO','BG_APPLICABLE','BG',@ctxt_language)        
       when sohdr_lc_appl_flag = 'Y' and  sohdr_bg_appl_flag = 'Y'       
       then dbo.get_metadata_desc_fn('NSO','COMBO','BG_APPLICABLE','LC & BG',@ctxt_language)        
       else dbo.get_metadata_desc_fn('NSO','COMBO','BG_APPLICABLE','NONE',@ctxt_language)      
       end 'LCAPPLICABLE',      
     --Code Added by john on 01/11/2011 for ES_NSO_00490 begin      
    'SAL_NSO_VW'   'Hiddentrantype'       
    ----Code Added by john on 01/11/2011 for ES_NSO_00490 end       
       /*Code Added for 10H109_NSO_00002 end */      
       /*code added for defect id : EBS-1362 starts here*/      
       ,@customertaxregion     'CUSTOMERTAXREGION'       
       ,@owntaxregion      'OWNTAXREGION'       
       ,@taxregnno       'TAXREGNNO',      
    RTRIM(sh.reason_for_amendment) 'reasonforamendment', ----/*code added for EBS-5186*/  
       /*code added for defect id : EBS-1362 ends here*/      
       --code added for AFL-284 starts here      
     --code modified by vasantha a for KPE-561 begins  
      -- 'NSO'+'$~$'+convert(nvarchar(28),sh.sohdr_ou)+'$~$'+sh.sohdr_order_no+'$~$'+convert(nvarchar(28),sh.sohdr_amend_no)  'QSO_DOCKEY',        
  /* Code commented and added for RITSL/PJRMC-124 Begins */  
   -- 'NSO'+'$~$'+convert(nvarchar(28),sh.sohdr_ou)+'$~$'+sh.sohdr_order_no 'QSO_DOCKEY',        
   'NSO'+'$~$'+convert(nvarchar(28),sh.sohdr_ou)+'$~$'+sh.sohdr_order_no+'$~$'+convert(nvarchar(28),sh.sohdr_amend_no)  'QSO_DOCKEY'  ,  
   /* Code commented and added for RITSL/PJRMC-124 Ends */  
     --code modified by vasantha a for KPE-561 ends  
                 @ctxt_ouinstance 'CSOU'      
      --code added for AFL-284 ends here      
   FROM   fw_admin_view_ouinstance s(NOLOCK),      
                cust_lo_info_vw c(NOLOCK),      
                component_metadata_table m2(NOLOCK),      
                component_metadata_table m3(NOLOCK),      
                component_metadata_table m5(NOLOCK),      
                sohist_order_hdr sh(NOLOCK)      
                LEFT OUTER JOIN cat_shp_reason_vw r(NOLOCK)      
                     ON  sh.sohdr_reason_no = RTRIM(r.reason_code)      
         AND             sh.sohdr_lo = RTRIM(r.lo)      
         AND             sh.sohdr_ou = RTRIM(r.ouinstid)      
              LEFT OUTER JOIN component_metadata_table m1(NOLOCK)      
                     ON  sh.sohdr_ref_doc_type = m1.paramcode      
         AND             m1.componentname = 'NSO'      
         AND             m1.paramcategory = 'TYPE'      
         AND             m1.paramtype = 'SO_REF_DOC_TYPE'      
         AND             m1.langid = @ctxt_language      
               LEFT OUTER  JOIN component_metadata_table m4(NOLOCK)      
                     ON  sh.sohdr_freight_method = m4.paramcode      
         AND             m4.componentname = 'NSO'      
         AND             m4.paramcategory = 'COMBO'      
         AND             m4.paramtype = 'SO_FRT_MET'      
         AND             m4.langid = @ctxt_language      
         WHERE  sh.sohdr_ou = @ctxt_ouinstance      
         AND    sh.sohdr_order_no = RTRIM(@order_no)      
         AND    sh.sohdr_amend_no = @amend_no      
         AND    sh.sohdr_lo = RTRIM(c.clo_lo)      
      AND    sh.sohdr_order_from_cust = RTRIM(c.clo_cust_code)      
         AND   sh.sohdr_ou = RTRIM(s.ouinstid)      
         AND    m2.componentname = 'NSO'      
         AND    m2.paramcategory = 'COMBO'      
         AND    m2.paramtype = 'SO_ORDER_TYPE'      
         AND    m2.paramcode = RTRIM(sh.sohdr_order_type)      
         AND    m2.langid = @ctxt_language      
         AND    m3.componentname = 'NSO'      
         AND    m3.paramcategory = 'COMBO'      
         AND    m3.paramtype = 'SO_FREIGHT_BILL'      
         AND    m3.paramcode = RTRIM(SUBSTRING(sh.sohdr_freight_billable, 1, 1))      
         AND    m3.langid = @ctxt_language      
         AND    m5.componentname = 'NSO'      
         AND    m5.paramcategory = 'STATUS'      
         AND    m5.paramtype = 'SO_STATUS'    
                /*Code modified by Indu on 23-Nov-2009 for ES_NSO_00330 Begins*/       
                --and   m5.paramcode   =  rtrim(sh.sohdr_order_status)      
         AND    m5.paramcode = 'AD'       
                /*Code modified by Indu on 23-Nov-2009 for ES_NSO_00330 Ends*/      
         AND  m5.langid = @ctxt_language      
     END      
     ELSE      
     BEGIN      
 --<^order_no!> "<%order_no%>" is not Valid.Please Check.        
  SELECT @m_errorid = 3550133       
         RETURN      
     END      
 END       
       
 /*        
 template select statement for selecting data to app layer        
 select         
 @addressidml 'ADDRESSIDML',@amend_no 'AMEND_NO',@buid 'BUID',        
 @carriercode 'CARRIERCODE',@currency 'CURRENCY',@cuspono 'CUSPONO',        
 @custname 'CUSTNAME',@customercode 'CUSTOMERCODE',@freight_bill 'FREIGHT_BILL',       
 @freightamount 'FREIGHTAMOUNT',@frt_currency 'FRT_CURRENCY',@frtmethod 'FRTMETHOD',        
 @gross_volume 'GROSS_VOLUME',@gross_weight 'GROSS_WEIGHT',@hidden_control1 'HIDDEN_CONTROL1',        
 @hidden_control2 'HIDDEN_CONTROL2',@loid 'LOID',@netweight 'NETWEIGHT',        
 @num_series 'NUM_SERIES',@ord_bas_val 'ORD_BAS_VAL',@ord_tot_val 'ORD_TOT_VAL',        
 @ord_type 'ORD_TYPE',@order_date 'ORDER_DATE',@order_no 'ORDER_NO',        
 @overridewt 'OVERRIDEWT',@overridvol 'OVERRIDVOL',@podate 'PODATE',        
 @priceuom 'PRICEUOM',@pricingdate 'PRICINGDATE',@promiseddate 'PROMISEDDATE',        
 @reason_code 'REASON_CODE',@reason_desc 'REASON_DESC',@reqddate 'REQDDATE',        
 @sale_type 'SALE_TYPE',@screenid 'SCREENID',@shippingpoint 'SHIPPINGPOINT',        
 @shiptoaddid 'SHIPTOADDID',@shiptocustomer 'SHIPTOCUSTOMER',@sourcedocno 'SOURCEDOCNO',        
 @sourcedocument_qso 'SOURCEDOCUMENT_QSO',@status1 'STATUS1',@total_charge 'TOTAL_CHARGE',        
 @total_discount 'TOTAL_DISCOUNT',@total_tax 'TOTAL_TAX',@total_vat 'TOTAL_VAT',        
 @trans_mode 'TRANS_MODE',@volume_uom 'VOLUME_UOM',@warehouse 'WAREHOUSE',        
 @weight_uom 'WEIGHT_UOM',@fprowno 'FPROWNO'        
 from  ***        
 */        
 SET NOCOUNT OFF --ES_NSO_00041      
END        
        
      
      
      
      
      
      
      
  
  
  

