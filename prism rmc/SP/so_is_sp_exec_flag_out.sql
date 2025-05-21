/*$File_version=MS4.3.0.07$*/  
/******************************************************************************************  
file name : so_is_sp_exec_flag_out.sql  
version  : 4.0.0.0  
procedure name : so_is_sp_exec_flag_out  
purpose  :   
author  : venkata ganesh  
date  :   
component name : nso  
method name : so_is_m_exec_flag_out  
  
objects referred  
 object name  object type  operation  
       (insert/update/delete/select/exec)  
modification details  
 modified by  modified on  remarks  
  
******************************************************************************************/   
  
/*  
Modified By  : Appala Raju.K  
Modified Date: 8/23/2004  
Remarks      : NSODMS41SYTST_000165  
*/  
/* Modified By     Date    Desc     
 Lavanya K J     May 10 2011  10H109_SLA_00001      */   
/*  Sejal N Khimani    20 Jan 2014  13H120_Supp_00004:ES_Supp_00320   */  
/*  Basil LD     21 SEP 2020  EB-5021         */  
/*  Ragha S      29 SEP 2021  EPE-38083        */  
/* Abinaya G     19/04/2022  TCTC-628        */  
/* Sejal N Khimani    20 March 2024 EPE-78318        */  
/*krishnan    14-01-2024  RITSL/RMC-SAL-34B    */          
 /* paulesakki 11-03-2024 prism_IDS_Inte*/        
 /*suryakala A 22-01-2025 CU Merging-PJRMC-1252*/  
 /* Deepak R	09-05-2025		RPJRB-789 */ 
CREATE   procedure so_is_sp_exec_flag_out                                                
 @ctxt_language             udd_ctxt_language,  
 @ctxt_ouinstance           udd_ctxt_ouinstance,    
 @ctxt_service              udd_ctxt_service,  
 @ctxt_user                 udd_ctxt_user,  
 @guid                 udd_guid,   
 @m_errorid                 udd_int output  
as  
begin  
  
 set nocount on  
   
 /* Code added for EPE-78318 Begins */  
 declare @opportunity_id  udd_documentno,   
   @error_id   udd_int  
 /* Code added for EPE-78318 Ends */  
  
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
  
 declare @ins_flag udd_execflag,  
  @upd_flag udd_execflag,  
  @del_flag udd_execflag,  
  @call_crnote udd_execflag,  
  @call_cust udd_execflag,   
  @call_quotation udd_execflag,  
  @crnote_ou udd_ctxt_ouinstance,  
  @cust_ou udd_ctxt_ouinstance,   
  @quotation_ou udd_ctxt_ouinstance,  
  @dp_dest_ouid udd_ctxt_ouinstance,  
  @return_error udd_metadata_code,  
  @order_no udd_documentno,  
  @current_status udd_status,  
  @m_errorid_tmp int  
  
 --code starts for 10H109_sla_00001  
 if (@ctxt_service = 'PVL_SLA_Sr_Gen')  
 begin  
  select @ctxt_ouinstance = destinationouinstid  
   FROM fw_admin_view_comp_intxn_model with (NOLOCK) --EPE-38083  
   WHERE sourcecomponentname = 'EAMPREP'  
  and     sourceouinstid  = @ctxt_ouinstance   
  and     destinationcomponentname = 'NSO'   
 end  
 --code ends for 10H109_sla_00001   
 declare order_cursor cursor for  
 select order_no,  
  current_status  
 from so_upd_status_tmp with (nolock)--EPE-38083  
 where guid  = @guid  
 and current_status in ('AU','SC')  
  
 open  order_cursor   
  
 fetch next from order_cursor into @order_no,@current_status  
  
 while @@fetch_status = 0  
 begin   
    
   Declare @customercode udd_customercode                
/* Begins - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/  
  select @customercode=sohdr_order_from_cust from so_order_hdr  where sohdr_order_no=@order_no                
  if @current_status = 'AU'  
  begin  
update interfacedb.dbo.zrit_IDS_Sales_order_master_post_table        
set IDS_STATUS=1      
,Updated_datetime=getdate()        
from interfacedb..zrit_IDS_Sales_order_master_post_table        
Join interfacedb.dbo.zrit_ids_ou_vw        
on ouid=plant        
where SALESID=@order_no        
and OUInstId=@ctxt_ouinstance        
and IDS_STATUS='0'        
        
        
 Update tmp               
  set sotran_amt = isnull(amt,0 )                
  from  tran_crchk_tbl tmp                
          left join                
              (                
              select      sohdr_bill_to_cust,sum( (sohdr_total_value/ sodtl_stock_uom_qty ) * (sodtl_req_qty-isnull(sodtl_invoiced_qty,0)))amt,sohdr_ou                
       from  so_order_hdr(nolock) , so_order_item_dtl (nolock)                
              where      sohdr_order_status = 'AU'                
              and         sohdr_ou = sodtl_ou                
              and         sohdr_order_no = sodtl_order_no                
              group by sohdr_bill_to_cust,sohdr_ou )so_dtl                
              on tran_cust = sohdr_bill_to_cust                
  and    sotran_amt > 0                
  --and   isnull(sotran_amt,0) <>  isnull(amt,0 )                
  and   sohdr_ou =tran_ou                
  where    tran_cust = @customercode                
              
 declare @bu varchar(100) ,@saletype varchar(100)       
 select @bu=bu_id from emod_ou_bu_map(nolock)        
 where ou_id=@ctxt_ouinstance        
  
 select @saletype =sohdr_sale_type_dflt from so_order_hdr(nolock)  
 where sohdr_order_no=@order_no  
 and sohdr_ou=@ctxt_ouinstance  
        
 --if  (@bu='AGG')  or (  @bu='CCB' and @saletype <> 'DOM') --Code Commented by Deepak for RPJRB-789 on 09-05-2025 
 if  (@bu='AGG')  or (  @bu='CCB' and @saletype NOT IN ('DOM','SAMP','SERV','SCRAP'))--Code added by Deepak for RPJRB-789 on 09-05-2025
   and exists(select 'x' from cust_lo_info with (nolock) where clo_cust_code=   @customercode and CLO_NOC='ET')--code added for PJRMC-1369 

begin        
                
if exists(              
select '*' from ci_doc_balance (nolock) where cust_code in(              
select ctds_cust_code from  cust_tds_info (nolock) where ctds_regd_no in(              
select ctds_regd_no from cust_tds_info (nolock) where ctds_tax_type='TCS'              
and ctds_cust_code =@customercode ))              
and term_no='0'              
and unadjusted_amt>0              
and datediff(d,posting_date,getdate()) >90)              
begin              
Raiserror('Credit Days for the %s is exceeding the Due Days. Please check.',16,1,@customercode)              
return              
end               
end              
/* Ends - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/  
   exec so_au_updstatus @ctxt_ouinstance,@ctxt_language,@ctxt_service,  
    @ctxt_user,@order_no,@guid,@m_errorid_tmp out  
   
    if @m_errorid_tmp <> 0  
     begin  
      select @m_errorid = @m_errorid_tmp  
      close order_cursor  
      deallocate order_cursor   
      return  
     end   
   /* Code added for EPE-78318 Begins */  
   select @opportunity_id  = sohdr_Opp_ID  
   from so_order_hdr with (nolock)  
   where sohdr_order_no  = @order_no  
   and  sohdr_ou   = @ctxt_ouinstance  
     
   if isnull(@opportunity_id,'') <> ''  
   begin  
    exec lm_chklst_compl_auto_upd_sp  
      @ctxt_language,  
      @ctxt_ouinstance,  
      @ctxt_service,  
      @ctxt_user,  
      @guid,  
      @order_no,--@tran_no,  
      @ctxt_ouinstance,--@tran_ou,  
      'SAL_NSO',--@tran_type,  
      @opportunity_id,  
      @ctxt_ouinstance,--@opportunity_ou,  
      'AUT',--@tran_mode,  
      @error_id output  
  
    if @error_id <> 0  
    begin  
     return  
    end  
   end  
   /* Code added for EPE-78318 Ends */  
  end  
  else if @current_status = 'SC'   
  begin  
   --calling the procedure is for updating the status and calling the   
   --so_disposition_postings procedure   
   exec so_sc_updstatus @ctxt_ouinstance,@ctxt_language,@ctxt_service,  
      @ctxt_user,@order_no,@guid,@m_errorid out  
/*code added by  krishnan start RITSL/RMC-SAL-34B*/                
           
 update interfacedb.dbo.zrit_IDS_Sales_order_master_post_table       
set IDS_STATUS=1        
,Updated_datetime=getdate()        
from interfacedb..zrit_IDS_Sales_order_master_post_table        
Join interfacedb.dbo.zrit_ids_ou_vw        
on ouid=plant        
where SALESID=@order_no        
and OUInstId=@ctxt_ouinstance        
and IDS_STATUS='0'        
        
               
  Update tmp               
  set sotran_amt = isnull(amt,0 )                
  from  tran_crchk_tbl tmp                
          left join                
              (                
              select      sohdr_bill_to_cust,sum( (sohdr_total_value/ sodtl_stock_uom_qty ) * (sodtl_req_qty-isnull(sodtl_invoiced_qty,0)))amt,sohdr_ou                
       from  so_order_hdr(nolock) , so_order_item_dtl (nolock)                
              where      sohdr_order_status = 'AU'                
              and         sohdr_ou = sodtl_ou                
 and sohdr_order_no = sodtl_order_no                
              group by sohdr_bill_to_cust,sohdr_ou )so_dtl                
              on tran_cust = sohdr_bill_to_cust                
  and    sotran_amt > 0                
  --and   isnull(sotran_amt,0) <>  isnull(amt,0 )                
  and   sohdr_ou =tran_ou                
  where    tran_cust = @customercode                
              
              
                
 /*code added by  krishnan RITSL/RMC-SAL-34B  end*/                 
   if @m_errorid <> 0     
    begin  
     select @m_errorid = @m_errorid  
     close order_cursor  
     deallocate order_cursor   
     return  
    end   
  end  
    
  /* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Begins */  
  declare @pono  udd_documentno,  
    @poou  udd_ctxt_ouinstance,  
    @poamendno udd_int,  
    @poiscall udd_int,  
    @soamendno udd_int,  
    @sono  udd_documentno,  
    @errorid udd_int,  
    @poservice udd_ctxt_service  
      
  select @poiscall  = 1  
        
  select @pono   = sohdr_po_no,  
    @poou   = sohdr_po_ou,  
    @poamendno  = sohdr_po_amendno,  
    @soamendno  = sohdr_amend_no  
  from so_order_hdr with (nolock)--EPE-38083  
  where sohdr_order_no = @order_no  
  and  sohdr_ou  = @ctxt_ouinstance  
    
  select @sono   = tmp_sono  
  from ict_po_so_tmp with (nolock)--EPE-38083  
  where tmp_guid  = @guid  
  and  tmp_pono is null -- IS is not called from PO Approval.  
    
  if @sono is  not null and @pono is not null  
  begin  
   if @current_status = 'AU'   
   begin  
    exec ict_purchaseorder_upd  
      @ctxt_language,  
      @ctxt_ouinstance,  
      @ctxt_service,  
      @ctxt_user,  
      @order_no,  
      @ctxt_ouinstance,  
      @soamendno,  
      @guid,  
      'AMDAUT',  
      @errorid output,  
      null,  
      null  
       
    if @errorid<> 0  
    begin  
     --raiserror('Error in PO amendment.',16,1)  
     select @m_errorid  = @errorid  
     close order_cursor   
     deallocate order_cursor  
     return  
    end  
      
    select @poiscall  = 0,  
      @poservice  = 'POAMDMM_SER_APR'        
   end  
  end   
  /* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Ends */  
      
  fetch next from order_cursor into @order_no,@current_status  
 end   
 close order_cursor  
 deallocate order_cursor   
  
  
 delete so_upd_status_tmp   
 where guid  = @guid  
  
  
 select  @ins_flag  = case    
      when count(*) > 0 then 0  
      else 1  
      end  
 from so_disposition_tmp with (nolock)--EPE-38083  
 where guid    = @guid   
 and tran_flag = 'I'  
   
 select  @upd_flag  = case    
      when count(*) > 0 then 0  
      else 1  
      end  
 from so_disposition_tmp (nolock)  
 where guid    = @guid   
 and tran_flag = 'U'  
   
 select  @del_flag  = case    
      when count(*) > 0 then 0  
      else 1  
      end  
 from so_disposition_tmp with (nolock)--EPE-38083  
 where guid    = @guid   
 and tran_flag = 'D'  
  
 select @call_crnote = case    
      when count(*) > 0 then 0  
      else 1  
      end  
 from so_debitnote_tmp with (nolock)--EPE-38083  
 where guid  = @guid   
  
 select @call_cust = case    
      when count(*) > 0 then 0  
      else 1  
      end  
 from so_cust_item_dtl_tmp with (nolock)--EPE-38083  
 where item_guid = @guid   
  
 select @call_quotation = case    
      when count(*) > 0 then 0  
      else 1  
      end  
 from so_qtn_update_tmp with (nolock)--EPE-38083  
 where guid_tmp = @guid   
  
 -- To get the Destinatin OU of INVPLAN to which NSO in interacting with  
 if @ins_flag = 0 or @del_flag = 0 or @upd_flag = 0  
 begin   
  exec scm_get_dest_ou @ctxt_ouinstance,  
     @ctxt_language,  
     @ctxt_user,  
     'NSO',  
     'INVPLAN',  
     @dp_dest_ouid out,  
     @m_errorid_tmp  out  
   
  if @m_errorid_tmp <> 0  
   begin  
    select @m_errorid = @m_errorid_tmp  
    return  
   end   
 end  
 else  
  select @dp_dest_ouid = @ctxt_ouinstance  
  
   
 -- To get the Destinatin OU of CDCN to which NSO is interacting with  
 if @call_crnote = 0  
 begin  
  exec scm_get_dest_ou @ctxt_ouinstance,  
     @ctxt_language,  
     @ctxt_user,  
     'NSO',  
     'CDCN',  
     @crnote_ou out,  
     @m_errorid_tmp  out  
  if @m_errorid_tmp <> 0  
   begin  
    select @m_errorid = @m_errorid_tmp  
    return  
   end   
 end  
 else  
  select @crnote_ou = @ctxt_ouinstance  
  
  
 -- To get the Destinatin OU of CUSTOMER to which NSO is interacting with  
 if @call_cust = 0  
 begin  
  exec scm_get_dest_ou @ctxt_ouinstance,  
     @ctxt_language,  
     @ctxt_user,  
     'NSO',  
     'CU',  
     @cust_ou out,  
     @m_errorid_tmp  out  
  if @m_errorid_tmp <> 0  
   begin  
    select @m_errorid = @m_errorid_tmp  
    return  
   end   
 end  
 else  
  select @cust_ou = @ctxt_ouinstance  
  
 -- To get the Destinatin OU of CUSTOMER to which QUOTATION is interacting with  
 if @call_quotation = 0  
 begin  
  exec scm_get_dest_ou @ctxt_ouinstance,  
     @ctxt_language,  
     @ctxt_user,  
     'NSO',  
     'QUOTATION',  
     @quotation_ou out,  
     @m_errorid_tmp  out  
  if @m_errorid_tmp <> 0  
   begin  
    select @m_errorid = @m_errorid_tmp  
    return  
   end   
 end  
 else  
  select @quotation_ou = @ctxt_ouinstance  
  
 IF @cust_ou = ''  
 BEGIN  
 SELECT @cust_ou = NULL  
 END  
  
 --code added for EPE-38083 begins  
 declare @flag  udd_flag  
 select @flag = 'N'  
 if exists (select 1 from so_api_hdr_tmp with (nolock)  
    where guid =@guid)  
 begin    
  select @flag = 'Y'  
 end  
 --code added for EPE-38083 ends  
  /* code Modifed By paulesakki on 2024-03-11 starts here */        
         
insert into interfacedb.dbo.zrit_IDS_Sales_order_master_post_table_hst        
(        
PLANT        
,SALESID        
,SOITEMID        
,STATUS        
,EXP_DATE        
,IDS_STATUS        
,Updated_datetime        
,Remarks        
,        
add_1        
,add_2        
,add_3        
,add_4        
,add_5        
,add_6        
,add_7        
)        
select        
PLANT        
,SALESID        
,SOITEMID        
,STATUS        
,EXP_DATE        
,IDS_STATUS        
,Updated_datetime        
,Remarks        
,add_1        
,add_2        
,add_3        
,add_4        
,add_5        
,add_6        
,add_7        
from interfacedb.dbo.zrit_IDS_Sales_order_master_post_table        
join interfacedb.dbo.zrit_ids_ou_vw        
on ouid=plant        
where SALESID=@order_no        
and OUInstId=@ctxt_ouinstance        
and IDS_STATUS='0'        
        
update interfacedb.dbo.zrit_IDS_Sales_order_master_post_table        
set IDS_STATUS=1        
,Updated_datetime=getdate()        
from interfacedb..zrit_IDS_Sales_order_master_post_table        
Join interfacedb.dbo.zrit_ids_ou_vw        
on ouid=plant  
where SALESID=@order_no        
and OUInstId=@ctxt_ouinstance        
and IDS_STATUS='0'        
        
         
/* code Modifed By paulesakki on 2024-03-11 starts here */         
        
select  @del_flag 'ALLOWDELETE',  
  @upd_flag  'ALLOWMODIFICATION',  
  @call_crnote 'CALL_CRNOTE',  
  @call_cust 'CALL_CUST',  
  @call_quotation 'CALL_QUOTATION',  
  @crnote_ou 'CRNOTE_OU',  
  --code commented and added for EPE-38083 begins  
  --EB-5021  
  --ISNULL(@cust_ou,0) 'CUST_OU',  
  --CAST(@cust_ou AS nvarchar(5)) 'CUST_OU',   
  --EB-5021  
  --CASE WHEN @flag ='Y' then ISNULL(@cust_ou,0) else CAST(@cust_ou AS nvarchar(5)) end  'CUST_OU', --code commented for TCTC-628  
  CASE WHEN @flag ='Y' then CAST(ISNULL(@cust_ou,0) AS nvarchar(5)) else CAST(@cust_ou AS nvarchar(5)) end  'CUST_OU', --code added for TCTC-628  
  --code commented and added for EPE-38083 ends  
  @dp_dest_ouid 'OUINST',  
  @quotation_ou 'QUOTATION_OU',  
  @ins_flag 'RESQUANTITYMLT'  
 /* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Begins */  
  ,@pono   'PONO',  
  @poou   'POOU',  
    
  --EB-5021  
  --@poiscall  'POCONTROLFLAG',  
        isnull(@poiscall,1)  'POCONTROLFLAG',  
  --EB-5021  
  
  @poservice  'POSERVICENAME',  
  @poamendno  'POAMENDNO'  
/* Code added for ITS ID : 13H120_Supp_00004:ES_Supp_00320 Ends */   
end 



