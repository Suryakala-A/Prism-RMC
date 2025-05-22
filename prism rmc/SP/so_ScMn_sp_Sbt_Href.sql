/*$File_version=MS4.3.0.02$*/    
/********************************************************************************/    
/* Procedure    : so_ScMn_sp_Sbt_Href                                           */    
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
/* Modified by  : Chaitanya Ch                                                  */    
/* Date         : 05/09/2023                                                    */    
/* Description  : EPE-65282                                                     */    
/* Modification history                                                         */    
/*Chaitanya Chitturi                  10/11/2023             EPE-65282_EPE-72719 */    
/*Mugesh s                       21/11/2023                      KLPHS-515      */    
/*suryakala A       22-01-2025       CU Merging-PJRMC-1252 */    
/********************************************************************************/    
    
create     procedure so_ScMn_sp_Sbt_Href    
 @ctxt_language    udd_ctxt_language, --Input     
 @ctxt_ouinstance  udd_ctxt_ouinstance, --Input     
 @ctxt_service     udd_ctxt_service, --Input     
 @ctxt_user        udd_ctxt_user, --Input     
 @guid             udd_guid, --Input/Output    
 @wfstatus         udd_cm_docstatus, --Input/Output    
 @wfstatus_state   udd_wfstatename, --Input/Output    
 @lcapplicable     udd_metadata_code, --Input/Output    
 @order_no         udd_documentno, --Input/Output    
 @m_errorid        udd_int output --To Return Execution Status    
as    
begin    
 -- nocount should be switched on to prevent phantom rows    
 set nocount on    
 -- @m_errorid should be 0 to indicate success    
 select @m_errorid = 0    
    
 --declaration of temporary variables    
 --declare @companycode udd_companycode--code commented by EPE-65282_EPE-72719    
 --temporary and formal parameters mapping    
    
 select @ctxt_service     = ltrim(rtrim(@ctxt_service))    
 select @ctxt_user        = ltrim(rtrim(@ctxt_user))    
 select @guid             = ltrim(rtrim(@guid))    
 select @wfstatus         = ltrim(rtrim(@wfstatus))    
 select @wfstatus_state   = ltrim(rtrim(@wfstatus_state))    
 select @lcapplicable     = ltrim(rtrim(@lcapplicable))    
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
    
 if @lcapplicable = '~#~'     
  select @lcapplicable = null      
    
 if @order_no = '~#~'     
  select @order_no = null      
    
/*code commented and added by  EPE-65282_EPE-72719 begins*/    
 /*   update qtn    
    set    qdtl_ordered_qty     = qdtl_ordered_qty - sodtl_req_qty    
 FROM   qtn_quotation_dtl qtn  with(nolock)    
 join   so_order_hdr           with(nolock)    
 on     qdtl_qtn_no          = sohdr_ref_doc_no     
 and    qdtl_ou              = sohdr_ou    
 join   so_order_item_dtl   with(nolock)    
 on     qdtl_item_code        = sodtl_item_code    
 and    qdtl_variant_code     = sodtl_item_variant    
 and    sohdr_order_no        = sodtl_order_no    
 and    sohdr_ou              = sodtl_ou    
 WHERE  sohdr_ou        = @ctxt_ouinstance    
 AND    sohdr_order_no   = @order_no    
 AND    sohdr_ref_doc_type  = 'QUO'    
 AND    sohdr_ref_doc_no IS NOT NULL    
 AND    sohdr_ou        = sodtl_ou    
 AND    sohdr_order_no   = sodtl_order_no    
 AND    sohdr_ref_doc_flag  = 'Y'    
    
 declare @qdtl_orded_qty  udd_quantity    
    
 select @qdtl_orded_qty       =  sum(qdtl_ordered_qty)    
 FROM   qtn_quotation_dtl qtn  with(nolock)    
 join   so_order_hdr           with(nolock)    
 on     qdtl_qtn_no           = sohdr_ref_doc_no     
 and    qdtl_ou               = sohdr_ou    
 where  sohdr_ou        = @ctxt_ouinstance    
 AND    sohdr_order_no   = @order_no    
    
 if @qdtl_orded_qty = 0 or @qdtl_orded_qty is null    
 begin    
  update qtn1    
  set    qhdr_status           = 'AU'    
  from   qtn_quotation_hdr qtn1 with(nolock)    
  join   so_order_hdr           with(nolock)    
  on     qhdr_qtn_no           = sohdr_ref_doc_no     
  and    qhdr_ou               = sohdr_ou    
  where  sohdr_ou        = @ctxt_ouinstance    
  AND    sohdr_order_no   = @order_no    
 end*/    
    
              declare @qtn_ou_tmp               udd_ctxt_ouinstance,    
                      @qtn_no_tmp               udd_documentno    
    
     if exists (  select    'X'    
                  from      so_order_hdr (nolock)    
                  where     sohdr_ou             =    @ctxt_ouinstance    
                  and       sohdr_order_no       =    @order_no    
                  and       sohdr_ref_doc_type   =    'QUO'    
                  and       sohdr_ref_doc_no    is not null    
                )    
     begin    
           update    qd    
           set       qdtl_ordered_qty          =    qdtl_ordered_qty    -     sodtl_req_qty    
           from      qtn_quotation_dtl qd(nolock)    
           JOIN      so_order_hdr (nolock)    
           on        sohdr_ref_doc_ou          =    qdtl_ou    
           and       sohdr_ref_doc_no          =    qdtl_qtn_no    
           JOIN      so_order_item_dtl   (nolock)    
           on        sohdr_ou                  =    sodtl_ou    
           and       sohdr_order_no            =    sodtl_order_no    
           and       sodtl_ref_doc_line_no     =    qdtl_line_no    
           where     sohdr_ou                  =    @ctxt_ouinstance    
           and       sohdr_order_no            =    @order_no    
           and       sohdr_ref_doc_no    is not null    
    
           select    @qtn_ou_tmp    =    sohdr_ref_doc_ou,    
                     @qtn_no_tmp    =    sohdr_ref_doc_no    
           from      so_order_hdr (nolock)    
           where     sohdr_ou                 =    @ctxt_ouinstance    
           and       sohdr_order_no           =    @order_no    
    
           if exists (    select    'X'    
                          from      qtn_quotation_dtl (nolock)    
                          where      qdtl_ou             =    @qtn_ou_tmp         
                          and       qdtl_qtn_no          =    @qtn_no_tmp    
                          and       qdtl_ordered_qty    <>   0    
                     )    
           begin    
                select    @ctxt_ouinstance    =    @ctxt_ouinstance    
           end    
           else    
       begin    
                update    qtn_quotation_hdr    
                set       qhdr_status    =    'AU'    
                where      qhdr_ou         =    @qtn_ou_tmp    
                AND       qhdr_qtn_no    =    @qtn_no_tmp    
           end    
     end    
    
    
/*code commented and added by EPE-65282_EPE-72719 ends*/    
    
 select @wfstatus_state ='WF_Status_Mn_Sh'    
 --code added for KLPHS-515 begins    
 Declare @amendno   udd_lineno    
   SELECT  @amendno = sohdr_amend_no from  so_order_hdr (nolock) Where sohdr_order_no = @order_no    
    
 exec NSO_prjcust_sp    
    @ctxt_language,                    
    @ctxt_ouinstance ,                
    @ctxt_service  ,                   
    @ctxt_user   ,                   
    @order_no ,                         
    @ctxt_ouinstance ,                         
    @amendno  ,                    
    @m_errorid   output     
    
   If @m_errorid >0    
 Begin    
  select @m_errorid = @m_errorid    
 End    
 --code added for KLPHS-515 ends    
     
     
/* Begins - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/    
   declare @ordertype varchar(100),@contract_no varchar(40),@contype varchar(100)  ,@bso_qty numeric(28,3),@so_qty numeric(28,3)                        
                          
SELECT @ordertype = sohdr_ref_doc_type,                            
        @contract_no = sohdr_ref_doc_no                            
 FROM   so_order_hdr(NOLOCK)                            
 WHERE  sohdr_ou = @ctxt_ouinstance                            
 AND    sohdr_order_no = RTRIM(UPPER(@order_no))                            
                          
          
  IF RTRIM(UPPER(@ordertype)) = 'CON'                            
 BEGIN                            
                          
               
            
     SELECT @contype    = conhdr_contract_type                            
     FROM   so_contract_hdr(NOLOCK)                            
     WHERE  conhdr_ou    in( select destinationouinstid                          
             from  fw_admin_view_comp_intxn_model                            
             where sourcecomponentname     = 'NSO'                          
             and   sourceouinstid          = @ctxt_ouinstance                          
             and   destinationcomponentname  = 'nso') and                          
         conhdr_contract_no = RTRIM(@contract_no)             
            
         
            
     IF RTRIM(@contype) = 'BSO'                            
     BEGIN                            
     --to update the bso quantity released till date into the bso schedule detail table                            
         UPDATE so_blanket_sch_dtl                    
         SET    bsosch_ordered_qty = bsosch_ordered_qty-(                    
                    SELECT ISNULL(SUM(ISNULL(sosch_rem_qty, 0)), 0)                    
                    FROM   so_order_sch_dtl(NOLOCK)            
     join            
                           so_order_hdr(NOLOCK)                    
                  
                    on    sosch_order_no = sohdr_order_no                    
                    AND    sohdr_ref_doc_no = RTRIM(@contract_no)                    
                    AND    sohdr_ou = @ctxt_ouinstance                    
                    AND    sohdr_order_status <> 'DL'                    
                    AND    sohdr_ref_doc_type = 'CON'                    
                      AND    sohdr_order_no  = RTRIM(@order_no)--AA-619      
          
         join   so_blanket_sch_dtl(NOLOCK)              
  on bsosch_contract_no=sohdr_ref_doc_no     
            
         WHERE  bsosch_ou = @ctxt_ouinstance                    
         AND    RTRIM(bsosch_contract_no) = RTRIM(@contract_no)             
   -- and bsosch_item_code=@item_code_mul     
 --and bsosch_line_no=@lineno    
 )          
                                     
         --to update the bso quantity released till date into the bso detail table   
         UPDATE so_blanket_item_dtl                            
         SET    bsodet_ordered_qty = bsodet_ordered_qty -(                     
    SELECT ISNULL(SUM(ISNULL(sodtl_rem_qty, 0)), 0)                            
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
     AND    sohdr_order_no  = RTRIM(@order_no)--AA-619                            
                    AND    sohdr_order_status <> 'DL'                                        
     AND    sodtl_order_no  = sohdr_order_no                            
                    AND    sohdr_ref_doc_type = 'CON'                            
                                            
                             
                               
                )                            
    FROM   so_blanket_item_dtl(NOLOCK)                            
         WHERE bsodet_ship_point=@ctxt_ouinstance                          
                                
         AND    UPPER(RTRIM(bsodet_contract_no)) = UPPER(RTRIM(@contract_no))                            
                -- and bsodet_item_code=@item_code_mul     
     --and bsodet_line_no=@lineno    
    
  End                            
 end         
     
 --/* Ends - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/    
     
    
 --OutputList    
 Select    
 @guid             'GUID',     
 ltrim(rtrim(dbo.wf_metadesc_fet_fn('NSOSO',@wfstatus))) 'WFSTATUS',     
 @wfstatus_state           'WFSTATUS_STATE',     
 @lcapplicable           'LCAPPLICABLE',    
 @order_no            'ORDER_NO'     
      
set nocount off    
    
end    
    
    

