/*$File_version=ms4.3.0.04$*/    
/********************************************************************************/    
/* Procedure    : Sopp_CrMn_sp_Del_href                                            */    
/* Description  :                                                               */    
/********************************************************************************/    
/* Project      :                                                               */    
/* ECR          :                                                               */    
/* Version      :                                                               */    
/********************************************************************************/    
/* Referenced   :                                                               */    
/* Tables       :                                                               */    
/********************************************************************************/    
/* Development history                                                          */    
/********************************************************************************/    
/* Author       : Veangadakrishnan R                                            */    
/* Date         : 24/Jan/2009                                                   */    
/********************************************************************************/    
/* Modification history                                                         */    
/********************************************************************************/    
/* Modified by  :                                                               */    
/* Date         :                                                               */    
/* Description  :                                                               */    
/* Meera       24 May 2011    ES_SOD_00018(11H103_SOD_00001:11H103_SOD_00009)*/    
/*if a sale order autocreated from customer portal is deleted we need to clear the so order no and rever the status as Released for recreation*/    
--Basil LD   17-09-2020  EBS-5021    
/*Chaitanya Ch        15/11/2023          EPE-58525*/    
/*suryakala A       22-01-2025       CU Merging-PJRMC-1252 */    
/********************************************************************************/    
    
create       procedure sopp_crmn_sp_del_href    
 @ctxt_language    udd_ctxt_language, --input     
 @ctxt_ouinstance  udd_ctxt_ouinstance, --input     
 @ctxt_service     udd_ctxt_service, --input     
 @ctxt_user        udd_ctxt_user, --input     
 @guid             udd_guid, --input/output    
 @wfstatus         udd_cm_docstatus, --input/output    
 @wfstatus_state   udd_state_name, --input/output    
 @order_no         udd_documentno, --input/output    
 @m_errorid        udd_int output --to return execution status    
 --code added against EBS-5021 starts here    
 ,@fin_error   udd_int    = null output,      
 @calling_service udd_ctxt_service = null    
 --code added against EBS-5021 ends here    
as    
begin    
 -- nocount should be switched on to prevent phantom rows    
 set nocount on    
 -- @m_errorid should be 0 to indicate success    
 select @m_errorid = 0    
    
 --declaration of temporary variables    
    
 --temporary and formal parameters mapping    
    
 select @ctxt_service     = ltrim(rtrim(@ctxt_service))    
 select @ctxt_user        = ltrim(rtrim(@ctxt_user))    
 select @guid             = ltrim(rtrim(@guid))    
 select @wfstatus         = ltrim(rtrim(@wfstatus))    
 select @wfstatus_state   = ltrim(rtrim(@wfstatus_state))    
 select @order_no         = ltrim(rtrim(@order_no))    
    
 --null checking    
    
 if @ctxt_language = -915    
  select @ctxt_language = null      
    
 if @ctxt_ouinstance = -915    
  select @ctxt_ouinstance = null      
    
 if @ctxt_service = '~#~'     
  select @ctxt_service = null     
    
 if @ctxt_user = '~#~'     
  select @ctxt_user = null      
    
 if @guid = '~#~'     
  select @guid = null      
    
 if @wfstatus = '~#~'     
  select @wfstatus = null      
    
 if @wfstatus_state = '~#~'     
  select @wfstatus_state = null      
    
 if @order_no = '~#~'     
  select @order_no = null      
   select @wfstatus_state ='WFState_QSO_Hid'    
    
 if exists( select 'X'     
    from so_upd_status_tmp(nolock)    
    where guid = @guid)    
 begin    
  delete from so_upd_status_tmp    
  where guid = @guid    
 end    
--ES_SOD_00018(11H103_SOD_00001:11H103_SOD_00009)    
 DECLARE @tran_date UDD_DATE,    
   @sohdr_order_from_cust udd_customer_id ,    
   --@sohdr_cust_po_no udd_documentno    
   @sohdr_cust_po_no udd_trandesc--EPE-58525    
    
   SELECT @tran_date=dbo.RES_Getdate(@ctxt_ouinstance)    
   select @sohdr_order_from_cust=sohdr_order_from_cust,    
     @sohdr_cust_po_no=sohdr_cust_po_no    
   from so_sales_order_hdr_vw (nolock)    
   where sohdr_ou    = @ctxt_ouinstance    
   and  sohdr_order_no   = @order_no    
  if (@sohdr_cust_po_no is not null)    
  begin    
    if exists(select 'x' from  cprt_po_hdr(nolock)    
         where (cprt_pohdr_custcode = @sohdr_order_from_cust or cprt_pohdr_dealercode=@sohdr_order_from_cust)    
         and cprt_pohdr_orgunit  = @ctxt_ouinstance    
         and cprt_pohdr_pono   = @sohdr_cust_po_no    
         and  cprt_pohdr_sono  =   @order_no)    
    begin    
      update  po    
      SET  cprt_pohdr_status = 'RL',    
        cprt_pohdr_sono  =    NULL,    
        cprt_pohdr_timestamp = cprt_pohdr_timestamp + 1,    
        cprt_pohdr_modifiedby = @ctxt_user,    
        cprt_pohdr_modifieddate = @tran_date     
      from cprt_po_hdr   po    
      where (cprt_pohdr_custcode = @sohdr_order_from_cust or cprt_pohdr_dealercode=@sohdr_order_from_cust)    
      and cprt_pohdr_orgunit  = @ctxt_ouinstance    
      and cprt_pohdr_pono   = @sohdr_cust_po_no    
      and  cprt_pohdr_sono  =   @order_no    
    
    
    end      
    end    
/* Begins - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/    
  declare @ordertype varchar(100),@contract_no varchar(40),@contype varchar(100)  ,@bso_qty numeric(28,3),@so_qty numeric(28,3)                                                                        
                                                                          
SELECT @ordertype = sohdr_ref_doc_type,                                                                            
        @contract_no = sohdr_ref_doc_no                      
 FROM   so_order_hdr(NOLOCK)                                                       
 WHERE  sohdr_ou = @ctxt_ouinstance                                  
 AND    sohdr_order_no = RTRIM(UPPER(@order_no))                                                                            
                                                                          
                                                             
  IF RTRIM(UPPER(@ordertype)) = 'CON'                                                     
BEGIN       
      UPDATE so_blanket_item_dtl                         
      SET bsodet_ordered_qty = bsodet_ordered_qty- (                                                                     
 SELECT ISNULL(SUM(ISNULL(sodtl_req_qty, 0)), 0)                                                                            
                    FROM   so_order_item_dtl(NOLOCK),                                                                            
             so_order_hdr(NOLOCK) ,                                                                    
         Zrit_so_blanket_item_dtl(nolock),                                 
         zrit_recepe_code_tbl_iedk(nolock)                                  
                                                                   
WHERE  sodtl_ou    = @ctxt_ouinstance                                                                            
                                                  
 AND    sodtl_item_code  = bsodet_item_code                                                              
                    AND    sodtl_item_variant = bsodet_item_variant                                        
                                    
       and bsodet_line_no=sodet_line_no                                                                    
     and sodet_item_code=bsodet_item_code                          
     and so_contract_no=bsodet_contract_no                  
     and RECEIPE_CODE=sodet_receipe_code                                           
     and OUTPUT_ITEM=sodet_item_code                                           
     and sodtl_item_code=OUTPUT_ITEM                                            
     and sodtl_line_no=Line_no                                  
     and order_no=sodtl_order_no         
     and sodet_method=Method--sasi   
   and bsodet_sales_price=sodtl_sales_price--sasi    
  
   and bsodet_line_no=bso_line                          
     AND    sohdr_ref_doc_no  = RTRIM(@contract_no)                                                          
  --  AND    sohdr_order_no  = RTRIM(@order_no)--AA-619                  
             AND    sohdr_order_status  in ( 'DL')                                       
          AND    sodtl_order_no  = sohdr_order_no                                                                            
            AND    sohdr_ref_doc_type = 'CON'      
   and sohdr_order_no=@order_no    
              )                                                                            
         FROM   so_blanket_item_dtl(NOLOCK)                                                                            
         WHERE bsodet_ship_point=@ctxt_ouinstance                                                                          
                                                                                
         AND    UPPER(RTRIM(bsodet_contract_no)) = UPPER(RTRIM(@contract_no))         
  end    
/* Ends - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/    
--ES_SOD_00018(11H103_SOD_00001:11H103_SOD_00009)    
 --OutputList    
 --EBS-5021    
 if @calling_service is null    
 begin    
--EBS-5021    
  select    
  newid()             'GUID',     
  ltrim(rtrim(dbo.wf_metadesc_fet_fn('NSOSO',@wfstatus))) 'WFSTATUS',     
  @wfstatus_state           'WFSTATUS_STATE',     
  @order_no            'ORDER_NO'     
 end ----EBS-5021    
    
     
set nocount off    
    
end    

