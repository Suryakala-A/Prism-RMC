/*$File_version=ms4.3.0.20$*/  
/******************************************************************************************  
file name : so_crmn_sp_sbt_ml.sql  
version  : 4.0.0.0  
procedure name : so_crmn_sp_sbt_ml  
purpose  :   
author  : venkata ganesh  
date  : 01 aug 2002  
component name : nso  
method name : so_crmn_m_sbt_ml  
  
objects referred  
 object name  object type  operation  
       (insert/update/delete/select/exec)  
 sotmp_order_item_dtl table   insert  
Modification details :
	Modified by  		Modified on  	Remarks  
	Appala Raju.K  		28 Jul 2004  	NSODMS41SYTST_000159(Precision Handling)  
	Appala Raju.K  		23 Nov 2006  	NSODms412at_000412  
	Priya R   		11/07/2007  	NSODMS412AT_000498  
	Anitha N  		24/07/2007  	PACKSLIPDMS412AT_000461  
	Damodharan. R  		06 Oct 2007   	NSODMS412AT_000526  
	Damodharan. R  		17 Oct 2007   	NSODMS412AT_000548  
	Anitha N  		05 nov 2007  	NSODMS412AT_000558  
	Veangadakrishnan. R  	2/1/2008        DMS412AT_NSO_00010          
	Damodharan. R		09 June 2008	ES_NSO_00029
	Sejal N Khimani		16 Jan 2013		13H120_Supp_00004:ES_Supp_00320
	Sejal N Khimani		15 Apr 2014		ES_NSO_00748
	Rani B              23 MAY 2106     ES_NSO_01153
	/* Prakash V			25-NOV-2016		ES_NSO_01313							*/
	/* Prakash V			07-DEC-2016		ES_NSO_01321							*/
	/*Prakash V            21/02/2017       ES_NSO_01437							*/
	/*Prakash V            17/03/2017       ES_NSO_01528							*/
	/*Abinaya G			   24/01/2018		HAL-516									*/
	/*Dinesh.S			   07/02/2018		EBS-971									*/
	/*Balasubramaniyam P   01/06/2018		EBS-1362								*/
	/*	Prakash V			03-MAY-2019		YC-691									*/
	/* Sejal N Khimani		20 Apr 2020		EBS-4309								*/
	/* Gopi V				30/11/2020      EPE-27452								*/
	/* Kathiravan P			08/11/2023		JCIEU-5									*/
	/*Mancy Biska N         25/09/2024      EBS-6311  :EPE-88977                              */
	/*suryakala A			22/01/2025			CU Merging-PJRMC-1252 */
******************************************************************************************/   
create   procedure so_crmn_sp_tmp_ins_item  
--temporary store for input parameter assignment  
 @ctxt_ouinstance   udd_ctxt_ouinstance  ,  
 @ctxt_language   udd_ctxt_language  ,      
 @ctxt_service   udd_ctxt_service  ,  
 @ctxt_user   udd_ctxt_user  ,  
 @con_forml_hdn   udd_metadata_code  , --new  
 @guid udd_guid,    
 @incoplace   udd_city  ,  
 @item_code_mul   udd_itemcode  ,  
 @item_type  udd_metadata_code,  
 @model_config_code udd_documentno, --new  
 @model_config_var udd_documentno, --new  
 @item_wt  udd_quantity,  
 @item_volume       udd_quantity,       
 @item_var_descml   udd_item_desc  ,  
 @lineno   udd_lineno  ,  
 @line_status udd_metadata_code,   
 @modeflag   udd_modeflag  ,  
 @order_no   udd_documentno  ,  
 @price_flag udd_metadata_code,  
 @tcd_cal_flag udd_metadata_code,  
 @update_flag udd_metadata_code,  
 @tcd_dflt_flag udd_metadata_code,   
 @prom_dflt_flag udd_metadata_code,   
 @price_rule_no  udd_ruleno,  --new   
 @pricelistno_ml  udd_pricelist,   
 @pricelist_amend_no udd_lineno,   --new  
 @pricingdateml   udd_date  ,       
 @processingactionml_hdn  udd_metadata_code,  
 @stock_status_hdn udd_metadata_code, --new  
 @sales_person_ou udd_ctxt_ouinstance,--new  
 @sales_person udd_saleperson_id,--new       
 @promiseddateml   udd_date  ,  
 @promotype   udd_type  ,       
 @qtyml   udd_quantity  ,  
 @stock_qty udd_quantity , --new  
 @rateml   udd_rate  ,  
 @refdoclineno   udd_lineno  ,  
 @referencescheduleno   udd_lineno  ,       
 @reqddateml   udd_date  ,  
 @reserve_dtml   udd_date  ,  
 @salepurposeml   udd_identificationnumber1,      
 @schtype_hdn   udd_metadata_code  ,       
 @shipcustcodeml   udd_customer_id  ,       
 @shippartialml_hdn   udd_metadata_code,       
 @shippingpointml_hdn   udd_ouinstid  ,       
 @shiptoaddidml   udd_id  ,  
 @so_uomml   udd_uomcode  ,      
 @to_shipdateml   udd_date  ,  
 @totalitempriceml   udd_amount  ,     
 @trans_modeml   udd_identificationnumber1  ,       
 @usagecccodeml   udd_item_usage  ,  
 @fb_docml   udd_financebookid,   --added by Damodharan R for OTS ID NSODMS412AT_000526  
 @variant_code_mul   udd_variant  ,       
 @warehouse_code_mul   udd_warehouse  ,  
 @youritemcode   udd_itemcode  ,  
/* Code modified by Raju against NSODms412at_000412 starts*/  
 @unitfrprice     udd_price,  
 @unitprice_ml      udd_price,  
 @shelf_life_unit_mul_hdn udd_metadata_code,  
 @gua_shelflife      udd_shelflife,  
 @priceuomml     udd_uomcode,   
/* Code modified by Raju against NSODms412at_000412 ends*/ 
 @remarks_manso           	udd_desc1000,--code added by EBS-971
 @hsnsacno                	udd_desc40,		-- code added for defect : EBS-1362
 @customeritemdesc			udd_desc255, -- code added for EPE-27452	 
 @m_errorid  int output --to return execution status  
 /* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Begins */
 ,@polineno			udd_int = null
 /* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Ends */ 
 , @mrp_tmp  udd_rate=null       /*  Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/
as  
begin  
 
 -- nocount should be switched on to prevent phantom rows   
 set nocount on  
 -- @m_errorid should be 0 to indicate success  
 select @m_errorid =0   
   
 if @item_type = 'M'  
  select @variant_code_mul = '##'  
  
 declare @tot_itm_price  udd_amount,  
  @date_tmp  udd_date,  
  @curr_tmp  udd_currency,  
/* Code modified by Raju against NSODms412at_000412 starts*/  
  @shippartial_flag udd_metadata_code,  
  @lo   udd_loid,  
  @bu   udd_buid,  
  @price_uom_qty  udd_quantity,             --Code commented for SCA validation --  Uncommneted for EBS-6311 
  @item_ou  udd_ctxt_ouinstance,  
  @m_errorid_tmp  udd_lineno  
/* Code modified by Raju against NSODms412at_000412 ends*/  
  
 select  @date_tmp = convert(datetime, convert(nvarchar(10), dbo.RES_Getdate(@ctxt_ouinstance), 120), 120)  
  
/* Code modified by Raju against NSODms412at_000412 starts*/  
 if @ctxt_service like 'SOPP%'  
 begin  
  select @shippartial_flag  = rtrim(sohdr_ship_partial_dflt)  
  from so_order_hdr (nolock)  
  where  sohdr_ou  = @ctxt_ouinstance  
  and sohdr_order_no  = rtrim(@order_no)  
    
  --calling procedure for getting lo and bu for login ou        
  exec  scm_get_emod_details @ctxt_ouinstance, @date_tmp, @lo out, @bu out, @m_errorid_tmp out  
  if  (@m_errorid <> 0)  
  begin  
   select @m_errorid = @m_errorid_tmp  
   return  
  end  
    
  --calling procedure for item ou        
  exec scm_get_dest_ou @shippingpointml_hdn,  
     @ctxt_language,  
     @ctxt_user,  
     'PACKSLIP',  
     'ITEMADMN',  
     @item_ou out,  
     @m_errorid_tmp out  
    
  if @m_errorid_tmp <> 0  
  begin  
   /*code modified for NSODMS412AT_000498 starts*/  
--    raiserror('Packslip component to ItemAdmin component mapping is not present. Please Check',16,1)  
   exec fin_german_raiserror_sp 'NSO',@ctxt_language,28,'','','','','','',''  
   /*code modified for NSODMS412AT_000498 ends*/  
   return  
  end  
 
 --Code Uncommneted for EBS-6311 Begins   
 --/* Code commented for JCIEU-5 begins
  if @priceuomml is not null  
  begin  
   select @price_uom_qty = (dbo.itm_fn_get_uomconvfactor (@item_ou, @item_code_mul, @variant_code_mul, @so_uomml, @priceuomml) * @qtyml)    
  end 
 -- Code commented for JCIEU-5 ends */ 
  --Code Uncommneted for EBS-6311 ends  
 
 end  
 else  
 begin  
/* Code modified by Raju against NSODms412at_000412 ends*/  
  select  @curr_tmp  = sohdr_currency  
  from  sotmp_order_hdr (nolock)  
  where sohdr_ou = @ctxt_ouinstance  
  and sohdr_guid = @guid  
   
  select @tot_itm_price = @qtyml * @rateml  
    
  select  @tot_itm_price = dbo.scm_get_round_amt_fn (@ctxt_ouinstance,  
           'NSO',  
           @curr_tmp,  
           @date_tmp,  
           @tot_itm_price,  
           'UDD_AMOUNT')  
 end  

 --code added for HAL-516 begins 
 select @tot_itm_price =   dbo.scm_get_round_amt_fn (@ctxt_ouinstance,  
           'NSO',  
           @curr_tmp,  
           @date_tmp,  
           (@qtyml * isnull(@rateml,0)),  
           'UDD_AMOUNT') 
  --code added for HAL-516 ends 

 --inserting the values in temporary sales order detail table  
 insert into sotmp_order_item_dtl  
 (sodtl_ou,  
 sodtl_guid,  
 sodtl_order_no,  
 sodtl_line_no,  
 sodtl_ref_doc_line_no,  
 sodtl_ref_doc_sch_no,  
 sodtl_item_type,  
 sodtl_free_item_flag,  
 sodtl_item_code,  
 sodtl_item_variant,  
 sodtl_cust_item_code,  
 sodtl_model_config_code, -- new  
 sodtl_model_config_var, --new  
sodtl_uom,  
 sodtl_req_qty,  
 sodtl_stock_uom_qty, -- new   
 sodtl_total_item_price,  
 sodtl_item_tax,  
 sodtl_item_charge,  
 sodtl_item_discount,  
 sodtl_item_vat,  
 --sodtl_apportion_tc_amt, --new  
 --sodtl_apportion_disc_amt,--new  
 sodtl_sales_price,   
 sodtl_usage_for_cc,  
 sodtl_sch_type,  
 sodtl_promotion_type,  
 sodtl_promotion_id,  
 sodtl_deal_id,  
 sodtl_pricelist_rule_no, -- new  
 sodtl_pricelist_no,  
 sodtl_pricelist_amend_no, --new  
 sodtl_sale_purpose,  
 sodtl_ship_partial,  
 sodtl_inco_place,  
 sodtl_consume_forecast,  
 sodtl_pick_qty,  
 sodtl_issued_qty,  
 sodtl_direct_pack_qty,  
 sodtl_bill_hold_qty,  
 sodtl_rem_qty,  
 sodtl_pack_qty,  
 sodtl_shipped_qty,  
 sodtl_invoiced_qty,  
 sodtl_ship_to_cust_dflt,  
 sodtl_ship_to_id_dflt,  
 sodtl_ship_point_dflt,  
 sodtl_ship_wh_no_dflt, 
 sodtl_trans_mode_dflt,   
 sodtl_req_date_dflt,  
 sodtl_prm_date_dflt,  
 sodtl_to_ship_date_dflt,  
 sodtl_sch_date_dflt,  
 sodtl_pricing_date,  
 sodtl_proc_action_dflt,  
 sodtl_stock_status, --new  
 sodtl_sales_person_ou,--new  
 sodtl_sales_person,--new  
 sodtl_line_status,  
 sodtl_line_prev_status, --new  
 sodtl_hold_item_flag, --new  
 sodtl_price_cal_flag,  
 sodtl_tcd_cal_flag,  
 sodtl_update_flag,  
 sodtl_tcd_dflt_flag,  
 sodtl_prom_dflt_flag,  
 sodtl_reason_code,  
 sodtl_item_wt,  
 sodtl_item_volume,  
 sodtl_price_uom,  
 sodtl_pricelist_price,  
 sodtl_addnl_fld1,  
 sodtl_addnl_fld2,  
 sodtl_addnl_fld3,  
 sodtl_addnl_fld4,  
 sodtl_addnl_fld5,  
 sodtl_addnl_fld6,  
 sodtl_created_by,  
 sodtl_created_date,  
 sodtl_modified_by,  
 sodtl_modified_date,  
 sodtl_timestamp,  
 sodtl_fbdoc, --Damodharan. R added for OTS ID NSODMS412AT_000526  
/* Code modified by Raju against NSODms412at_000412 starts*/  
 sodtl_freight_price,  
 sodtl_guar_shelf_life,  
 sodtl_shelf_life_unit,  
 sodtl_unit_price,  
 sodtl_price_uom_qty, 
 sodtl_poline_no,--13H120_Supp_00004:ES_Supp_00320 
 sodtl_shelf_life_days
 ,sodtl_remarks --code added by EBS-971	
 ,sodtl_hsnsac_no	-- code added by EBS-1362 
 ,sodtl_cust_item_desc )--code added for EPE-27452   
/* Code modified by Raju against NSODms412at_000412 ends*/ 
 values  
 (@ctxt_ouinstance,  
 @guid,  
 upper(@order_no),  
 @lineno,  
 isnull(@refdoclineno,0),--sodtl_ref_doc_line_no,  
 isnull(@referencescheduleno,0),--sodtl_ref_doc_sch_no,  
 @item_type,--sodtl_item_type,  
 'N',--sodtl_free_item_flag,   
 @item_code_mul,  
 @variant_code_mul,  
 @youritemcode,  
 @model_config_code,--sodtl_model_config_code, -- new   
 @model_config_var,--sodtl_model_config_var --new  
 @so_uomml,  
 @qtyml,   
 @stock_qty,--sodtl_stock_uom_qty, -- new  
/* Code modified by Raju against NSODms412at_000412 starts*/  
--  @tot_itm_price,
/* Code modified by Rani B against ES_NSO_01153 starts*/   
 --case  
 --when rtrim(@priceuomml) is null then (@qtyml * isnull(@rateml,0))  
-- when rtrim(@priceuomml) is not null  then (@price_uom_qty * (isnull(@unitfrprice,0) + isnull(@rateml,0))) --NSODMS412AT_000558  
 --when rtrim(@priceuomml) is not null  then (@price_uom_qty * (isnull(@rateml,0)))  
 --end,  
  @tot_itm_price ,--(@qtyml * isnull(@rateml,0)), --code modified for HAL-516
/* Code modified by Rani B against ES_NSO_01153 ENDS*/ 
/* Code modified by Raju against NSODms412at_000412 ends*/  
 0.0,--sodtl_item_tax,  
 0.0,--sodtl_item_charge,  
 0.0,--sodtl_item_discount,  
 0.0,--sodtl_item_vat,  
 --0.0,--sodtl_apportion_tc_amt, --new  
 --0.0,--sodtl_apportion_disc_amt,--new  
/* Code modified by Raju against NSODms412at_000412 starts*/  
--  @rateml,--sodtl_sales_price,  
-- (isnull(@rateml,0) + isnull(@unitfrprice,0)),--sodtl_sales_price, --NSODMS412AT_000558  
 --(isnull(@rateml,0) ),--sodtl_sales_price, --ES_NSO_01437  
 @rateml,--ES_NSO_01437
/* Code modified by Raju against NSODms412at_000412 ends*/  
/* Code modified by Damodharan. R on 09 June 2008 for Defect ID ES_NSO_00029 starts here */
-- isnull(@usagecccodeml,'SALESUSAGE1'), --PACKSLIPDMS412AT_000461  
@usagecccodeml,
/* Code modified by Damodharan. R on 09 June 2008 for Defect ID ES_NSO_00029 ends here */
 @schtype_hdn,  
 null, --@promotype,  
 null,--sodtl_promotion_id,  
 null,--sodtl_deal_id,  
 @price_rule_no,--sodtl_pricelist_rule_no, -- new  
 @pricelistno_ml,  
 @pricelist_amend_no,--sodtl_pricelist_amend_no, --new  
 @salepurposeml,  
/* Code modified by Raju against NSODms412at_000412 starts*/  
--  @shippartialml_hdn,  
/* Code modified by Damodharan. R on 17 Oct 2007 for OTS ID NSODMS412AT_000548 starts here */  
 --case when @ctxt_service like 'SOPP%' then isnull(@shippartial_flag,'Y')else @shippartialml_hdn end,  
case when @ctxt_service like 'SOPP%' then isnull(@shippartialml_hdn,'Y')else @shippartialml_hdn end, 
/* Code modified by Damodharan. R on 17 Oct 2007 for OTS ID NSODMS412AT_000548 ends here */  
/* Code modified by Raju against NSODms412at_000412 ends*/  
 @incoplace,  
/* Code modified by Raju against NSODms412at_000412 starts*/  
--  @con_forml_hdn,--sodtl_consume_forecast --new  
/* Code modified by Veangadakrishnan. R for DTS ID: DMS412AT_NSO_00010 starts here*/
-- case when @ctxt_service like 'sopp%' then 'Y' else @con_forml_hdn end,--sodtl_consume_forecast --new        
 case when @ctxt_service like 'sopp%' then isnull(@con_forml_hdn,'Y') else @con_forml_hdn end,
/* Code modified by Veangadakrishnan. R for DTS ID: DMS412AT_NSO_00010 ends here*/
/* Code modified by Raju against NSODms412at_000412 ends*/  
 0.0,--sodtl_pick_qty,  
 0.0,--sodtl_picked_qty,  
 0.0,--sodtl_direct_pack_qty,  
 0.0,--sodtl_bill_hold_qty,  
 @qtyml,--0.0,--sodtl_rem_qty,  
 0.0,--sodtl_pack_qty,  
 0.0,--sodtl_shipped_qty,  
 0.0,--sodtl_invoiced_qty,   
 @shipcustcodeml,  
 @shiptoaddidml,  
 @shippingpointml_hdn,  
 @warehouse_code_mul,  
 @trans_modeml,   
 @reqddateml,  
 @promiseddateml,  
 @to_shipdateml,  
 @reserve_dtml,  
 @pricingdateml,  
 @processingactionml_hdn,  
 @stock_status_hdn,--sodtl_stock_status, --new  
 @sales_person_ou,--sodtl_sales_person_ou,--new  
 @sales_person,--sodtl_sales_person,--new  
 @line_status,--sodtl_line_status,  
 null,--sodtl_line_prev_status, --new  
 'N',--sodtl_hold_item_flag, --new  
/* Code modified by Raju against NSODms412at_000412 starts*/  
--  @price_flag,  
 case when @ctxt_service like 'SOPP%' and @rateml is null  then 'Y' else @price_flag end,  
/* Code modified by Raju against NSODms412at_000412 ends*/  
 @tcd_cal_flag,--sodtl_tcd_cal_flag,  
 @update_flag,--sodtl_update_flag,  
 @tcd_dflt_flag,  
 @prom_dflt_flag,  
 null,--sodtl_reason_code  
 @item_wt,  
 @item_volume,  
/* Code modified by Raju against NSODms412at_000412 starts*/  
 @priceuomml, --null,--sodtl_price_uom,  
/* Code modified by Raju against NSODms412at_000412 ends*/  
 0,--null,--sodtl_price_in_price_uom,  
 null,  
 null,  
 null,  
 null,  
 null,  
 null,  
 @ctxt_user,  
 dbo.RES_Getdate(@ctxt_ouinstance),  
 @ctxt_user,  
 dbo.RES_Getdate(@ctxt_ouinstance),  
 1,  
 @fb_docml, --Damodharan. R added for OTS ID NSODMS412AT_000526  
/* Code modified by Raju against NSODms412at_000412 starts*/  
 isnull(@unitfrprice,0),  
 @gua_shelflife,  
 @shelf_life_unit_mul_hdn,  
 @rateml,  
 --@qtyml,--@price_uom_qty, --Code modified for JCIEU-5    --EBS-6311
 @price_uom_qty,                                           --EBS-6311
 @polineno,--13H120_Supp_00004:ES_Supp_00320 
 case ltrim(rtrim(@shelf_life_unit_mul_hdn))  
 when 'DD'   then  (1 * @gua_shelflife)  
 when 'YY'   then (365 * @gua_shelflife)  
 when 'WK'  then (7 *@gua_shelflife)  
 when 'MM'  then (30 * @gua_shelflife)  
 else @shelf_life_unit_mul_hdn  
 end
 ,@remarks_manso--code added by EBS-971   
 ,@hsnsacno -- code added for defect : EBS-1362
 ,@customeritemdesc)--code added for EPE-27452 
/* Code modified by Raju against NSODms412at_000412 ends*/  
 
 /* Code commented and added for EBS-4309 Begins */
 --if @ctxt_service like 'SOPP%'  
 if @ctxt_service like 'SOPP%'  or (@ctxt_service in ('eso_crmn_ser_crau','eso_crmn_ser_auth'))
 /* Code commented and added for EBS-4309 Ends */
 begin  
  --First initialising the orginal tcd default flag as Null  
  update  dtl  
  set sodtl_tcd_dflt_flag  = null  
  from	sotmp_order_item_dtl dtl (nolock)--YC-691
  where sodtl_guid   = @guid  
  and  sodtl_order_no   = @order_no  
  and sodtl_ou   = @ctxt_ouinstance  
  and sodtl_line_no   = @lineno  
  and  isnull(sodtl_tcd_dflt_flag,'N') = 'N'  
    
--ES_NSO_01313 Starts
--ES_NSO_01321 Uncommented Starts 
  --Updating the TCD updated flag from the main table to temp table  
  --if there has not been any changes in the main fields  

  --ES_NSO_01528 if TCD is not manually updated then Delete from main table and call the pricing for TCD. 
  If Exists	
 (
	  select	'X'
	  from sotmp_order_item_dtl tmp,  
	   so_order_item_dtl    dtl (nolock)  
	  where  tmp.sodtl_guid   = @guid  
	  and  tmp.sodtl_order_no  = @order_no  
	  and tmp.sodtl_ou   = @ctxt_ouinstance  
	  and tmp.sodtl_line_no  = @lineno
	  and dtl.sodtl_order_no  = tmp.sodtl_order_no  
	  and dtl.sodtl_ou   = tmp.sodtl_ou   
	  and  tmp.sodtl_line_no  = dtl.sodtl_line_no  
	  and  tmp.sodtl_item_code  = dtl.sodtl_item_code  
	  and  tmp.sodtl_item_variant  = dtl.sodtl_item_variant 
	  and  tmp.sodtl_price_uom  = dtl.sodtl_price_uom  
	  and tmp.sodtl_price_uom_qty  = dtl.sodtl_price_uom_qty  
	  and tmp.sodtl_pricing_date  = dtl.sodtl_pricing_date  
	  and tmp.sodtl_ship_to_cust_dflt = dtl.sodtl_ship_to_cust_dflt  
	  and  tmp.sodtl_ship_to_id_dflt  = dtl.sodtl_ship_to_id_dflt
  )
  Begin   
		update tmp  
		set tmp.sodtl_tcd_dflt_flag  =   
			case isnull(dtl.sodtl_tc_upd_flag,'N')  
			when 'Y' then 'N'  
			else 'Y'  
			end  
		from sotmp_order_item_dtl tmp(NOlock),  
		so_order_item_dtl    dtl (nolock)  
		where  tmp.sodtl_guid   = @guid  
		and  tmp.sodtl_order_no  = @order_no  
		and tmp.sodtl_ou   = @ctxt_ouinstance  
		and tmp.sodtl_line_no  = @lineno
		and dtl.sodtl_order_no  = tmp.sodtl_order_no  
		and dtl.sodtl_ou   = tmp.sodtl_ou   
		and  tmp.sodtl_line_no  = dtl.sodtl_line_no  
		and  tmp.sodtl_item_code  = dtl.sodtl_item_code  
		and  tmp.sodtl_item_variant  = dtl.sodtl_item_variant 
		and  tmp.sodtl_price_uom  = dtl.sodtl_price_uom  
		and tmp.sodtl_price_uom_qty  = dtl.sodtl_price_uom_qty  
		and tmp.sodtl_pricing_date  = dtl.sodtl_pricing_date  
		and tmp.sodtl_ship_to_cust_dflt = dtl.sodtl_ship_to_cust_dflt  
		and  tmp.sodtl_ship_to_id_dflt  = dtl.sodtl_ship_to_id_dflt
	End
	Else
	Begin  
		
		Update Tmp
		Set		tmp.sodtl_tcd_dflt_flag  =   'Y'
		from	sotmp_order_item_dtl tmp(Nolock),  
				so_order_item_dtl    dtl (nolock)  
		where tmp.sodtl_guid	= @guid  
		and	tmp.sodtl_order_no  = @order_no  
		and	tmp.sodtl_ou		= @ctxt_ouinstance  
		and	tmp.sodtl_line_no   = @lineno
		and	dtl.sodtl_order_no  = tmp.sodtl_order_no  
		and	dtl.sodtl_ou		= tmp.sodtl_ou   
		and	tmp.sodtl_line_no   = dtl.sodtl_line_no
		and	isnull(dtl.sodtl_tc_upd_flag,'N')  =	'N'
	End
	--ES_NSO_01528 if TCD is not manually updated then Delete from main table and call the pricing for TCD.   
  
  --ES_NSO_01313 Ends
  --ES_NSO_01321  Uncommented Ends

  /* Code added for ITS ID : ES_NSO_00748 Begins */
 declare @feature_flag_yes_no	udd_yesnoflag
 
 select  @feature_flag_yes_no	=	flag_yes_no
 from    pps_feature_list(nolock)
 where   feature_id				=	'PPS_FID_0041'
 and     component_name			=	'NSO'
 
 if	@feature_flag_yes_no = 'Yes'
 begin 
	  update tmp
	  set	 tmp.sodtl_tcd_dflt_flag  = 'Y'
	  from   sotmp_order_item_dtl tmp(nolock)--YC-691
	  where	 tmp.sodtl_guid		      = @guid  
	  and    tmp.sodtl_order_no       = @order_no  
	  and    tmp.sodtl_ou		      = @ctxt_ouinstance  
	  and    tmp.sodtl_line_no        = @lineno
	  --and	 tmp.sodtl_tcd_dflt_flag  is null
 end --if	@feature_flag_yes_no = 'Yes'
  /* Code added for ITS ID : ES_NSO_00748 Ends */
  
 end  
  
   
if  @@error <> 0  
 return  
end








