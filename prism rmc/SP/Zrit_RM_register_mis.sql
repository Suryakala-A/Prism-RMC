---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*    
Created Date: 23/03/2023    
use misdb_trg    
purpose : material Register    
EXEC Zrit_RM_register_mis 'PJL','CON','E','Kolkata','6','2024-01-01','2024-03-23','','','',''   
EXEC Zrit_RM_register_mis 'PJL','CON','ALL','ALL','ALL','2024-08-01','2024-09-10','','','',''  
EXEC Zrit_RM_register_mis 'PJL','CON','ALL','ALL','59','2024-01-01','2024-03-23','','CEMENTOPC53-##','',''  
EXEC Zrit_RM_register_mis 'PJLRMC','CON','ALL','ALL','ALL','2024-01-01','2025-01-19','','','',''  
EXEC Zrit_RM_register_mis 'ALL','ALL','ALL','ALL','ALL','2024-01-01','2025-01-19','','','',''  
*/    
    
/* Aparna 03/04/2023  KILU-839 */    
/* Paul     04/04/2023      KILU-839 */    
/* Deepak    13/02/2024			RMC_PUR_31*/
/* suryakala  28/8/2024      PJRMC-402*/
/* Vasanthi K	25-10-2024	PJRMC-953*/
/* Amirtha P.		19.01.2025		PJLMIS_COMP_02           */
/* Narmadhadevi M     04/04/2025     RPRMCB-1 (unit rate mismatch)*/
/* Amirtha P.		13.04.2025		RPJRB-467*/
/* Amirtha P.		18.04.2025		RPJRB-467	(Performance)*/
/* anulakshmi  RPJRB-625  28.04.25 */
/* Suryakala A   RPJRB-730  05-05-2025*/

CREATE   or alter  Proc Zrit_RM_register_mis   
(    
--@ou int
 --@UserId  Varchar(50), 
 @COMPANY VARCHAR(20)--Code Added by Amirtha P on 10.01.2023   
, @DIVISION VARCHAR(20)	
, @ZONE  VARCHAR(40)  	
, @BRANCH  VARCHAR(40) 	
, @Plant  VARCHAR(40)  	
,@from_date DATE,    
@to_date DATE    
--,@from_date DATEtime,    
--@to_date DATEtime  
,@vendor_name   varchar(100)    
,@item_code   varchar(100)    
,@item_grp_desc  varchar(500)	
,@item_type		varchar(500)	/*Code Added for RPJRB-467*/
,@item_account_grp   varchar(500) 
,@user varchar(52) /*Code Added for PJLMIS_COMP_02 */                         
)    
as    
begin  

 /*Code Added for PJLMIS_COMP_02 Begins*/
 if @Company = 'All' or isnull(@Company,'')='' or @Company = Null
	Select @Company = '%'
 /*Code Added for PJLMIS_COMP_02 Ends*/
 
 if @DIVISION = 'All' or isnull(@DIVISION,'')='' or @DIVISION = Null
	Select @DIVISION = '%'

 if @ZONE = 'All' or isnull(@ZONE,'')='' or @ZONE = Null
	Select @ZONE = '%'

 if @BRANCH = 'All' or isnull(@BRANCH,'')='' or  @BRANCH = Null
	Select @BRANCH = '%'

 if @Plant = 'All' or isnull(@Plant,'')='' or @Plant = Null
	Select @Plant = '%' 

/*Code Added for RPJRB-467 Begins*/
 if @item_type = 'All' or isnull(@item_type,'')='' or @item_type = Null
	Select @item_type = '%' 
/*Code Added for RPJRB-467 Ends*/
	
 /*Code Added for PJLMIS_COMP_02 Begins*/

	if	@user = 'reportuser' 
	begin 
		select @user = 'superuser' 
	end
		/*	code added by suryakala (testing git) STARTS*/

	else
	select @user = 'ramcouser'
	CREATE TABLE #bu
	(bu varchar(20),ou int)
	/*code added by narmadhadevi (git testing) starts*/
	insert into #bu
	Select distinct bu_id FROM SCMDB..Zrit_Map_Zone_Branch_Nature_dtl WITH (NOLOCK)
	WHERE Bu_id	like @DIVISION
	And	Company_code like @Company
	AND Zone	LIKE	@ZONE
	AND Branch	LIKE	@BRANCH	
	AND	OU_id	LIKE	@Plant
	/*code added by narmadhadevi (git testing) ends*/

	/*	code added by suryakala (testing git) ENDS*/

	Drop table if exists #user_ou

	Create Table #user_ou (ou int,USERNAME VARCHAR(20))

	Insert into #user_ou
	Select	distinct OUInstId,UserName	/*	code added by suryakala (testing git) */
	From	DEPDB..fw_admin_OUInst_User  with (nolock)
	where	UserName	=	@user 
	And		OUInstId IN (Select distinct OU_id FROM SCMDB..Zrit_Map_Zone_Branch_Nature_dtl WITH (NOLOCK)
	WHERE Bu_id	like @DIVISION
	And	Company_code like @Company
	AND Zone	LIKE	@ZONE
	AND Branch	LIKE	@BRANCH	
	AND	OU_id	LIKE	@Plant)

	/*Code Added for PJLMIS_COMP_02 Ends*/


---CODE ADDED BY DEEPAK R ON FEB/09/2024 START HERE
	/*CREATE TABLE #ou_temp (OU VARCHAR(200))

	IF @Plant 	=	'%'                                                                              
	BEGIN                                                                        
		INSERT	INTO #ou_temp                         
		SELECT	a.OUInstId                                                                      
		FROM	depdb..fw_admin_ouinst_user a WITH (NOLOCK),                                          
				depdb..fw_admin_ouinstance  b WITH (NOLOCK),
				scmdb..Zrit_Map_Zone_Branch_Nature_dtl c WITH (NOLOCK)
		WHERE	a.OUInstID	=		b.ouinstid                                                          
		AND		c.ou_id		=		b.OUInstID
		AND		c.bu_id		=		@DIVISION   
		AND		a.username	=		@UserId  
		AND		c.Zone		LIKE	@ZONE	
		AND		c.Branch	LIKE	@BRANCH                                
	END                 
	ELSE       
	BEGIN
		INSERT	INTO #ou_temp                              
		SELECT	OU_id   
		FROM	scmdb..Zrit_Map_Zone_Branch_Nature_dtl c WITH (NOLOCK)
		WHERE	OU_Name	=		@Plant
		AND		bu_id	=		@DIVISION  
		AND		Zone	LIKE	@ZONE	
		AND		Branch	LIKE	@BRANCH   
	END 
	
	IF @Plant =	'%'   AND @UserId	=	'reportuser'
	BEGIN
		INSERT	INTO #ou_temp    
		SELECT	OU_id   
		FROM	scmdb..Zrit_Map_Zone_Branch_Nature_dtl c WITH (NOLOCK)
		WHERE	OU_Name	LIKE	@Plant
		AND		bu_id	=		@DIVISION  
		AND		Zone	LIKE	@ZONE	
		AND		Branch	LIKE	@BRANCH 
	END*/
	---CODE ADDED BY DEEPAK R ON FEB/09/2024 END HERE

if @vendor_name  = ''     
set @vendor_name = NULL    

if @item_grp_desc = 'ALL'   or   isnull(@item_grp_desc,'')='' or @item_grp_desc = Null
set @item_grp_desc =NULL    


if @item_account_grp  ='ALL'     or   isnull(@item_account_grp,'')='' or @item_account_grp = Null
set @item_account_grp =NULL    
    
Declare @ItemCodeVar Varchar(250)  
  
Set @ItemCodeVar = @item_code   
  
select @item_code =  value from reportsdb..fn_split(@ItemCodeVar,'-') Where idx = 0   

if @item_code  = ''    
set  @item_code  = NULL    

declare @company_code varchar(100)    
--Begin Tran    
Drop Table if exists #main_Po_Gr_Dump    
    
Create Table #main_Po_Gr_Dump    
(    
 OU_ID INT,
OUinstName	varchar(200),
 OU_Name     varchar(200)   
,Po_No       varchar(200)    
,PO_Date      varchar(200)--Datetime /*code commented & added by Alisodaipandian A on 01-04-2023*/    
,Gate_Entry_no     varchar(500)    
,Gate_Entry_date    date--Datetime /*code commented and added by suryakala against PJRMC-402 on 31 aug 2024*/    
,GRN_no       varchar(200)    
,GRN_Date      Datetime    
,GRN_Status                  varchar(100)    
,Line_No      varchar(200)    
,Item_Code      varchar(200)    
,VariantCode     varchar(200)    
,Item_Desc      varchar(200)    
,UOM       varchar(200)    
,Supplier_inv_Qty    Numeric(18,3)    
,GR_Qty       Numeric(18,3)    
,Material_Cost   Numeric(18,2)--   Numeric(18,3) /*code commented and added by suryakala against PJRMC-402 on 31 aug 2024*/ 
,Cess       Numeric(18,3)    
,Transportation_Cost   Numeric(18,3)    
,Handling_charge    Numeric(18,3)    
,Transit_loss     Numeric(18,3)    
,VAT       Numeric(18,3)    
,Others       Numeric(18,3)    
,DISB       Numeric(18,3)--test    
,Cess_it         Numeric(18,3)    
,Transportation_Cost_it   Numeric(18,3)    
,Handling_charge_it    Numeric(18,3)    
,Transit_loss_it       Numeric(18,3)    
,VAT_it       Numeric(18,3)    
,Others_it         Numeric(18,3)    
,DISB_it      Numeric(18,3)--test    
,Tcd_code                    varchar(200)    
,TCD_CODE_line               varchar(100)    
,Total_tcd_value    Numeric(18,3)    
,Dump_tcd                   Numeric(18,3)    
,gr_tcd      numeric(28,3)    
,Tax_rate      varchar(200)    
,Tax_Value      varchar(200)    
,group_desc      varchar(200)    
,Item_Account_Group    varchar(200)    
,GL_Code      varchar(200),    
GL_Description     varchar(max) --Aparna    
,WH_Code      varchar(200)    
,Zone       varchar(200)    
,SupplierInvNo     varchar(200)    
,Transport_Mode     varchar(200)    
,SupplierCode     varchar(200)    
,SupplierName     varchar(200)    
,Transporter_Name    varchar(200)    
,Transporter_Code    varchar(200)    
,Handling_supplier_name   varchar(200)    
,Handling_supplier_code   varchar(200)    
,vehicleno      varchar(200)    
,Lrno_Rrno      varchar(200)    
,LRdate       Datetime    
,Bin      varchar(100)    
/*Code Commented for RPJRB-467 on 18.04.2025 Begins*/
/*
,GREATER_THAN_45_MICRONS  varchar(100)    
,GREATER_THAN_45_MICRONS_value numeric(28,8)    
,GREATER_THAN_90_MICRONS      varchar(100)        
,GREATER_THAN_90_MICRONS_value    numeric(28,8)    
,ALUMINA                     varchar(100)    
,ALUMINA_value                numeric(28,8)    
,ASH                        varchar(100)    
,ASH_value                    numeric(28,8)    
,CALCIUM_OXIDE                varchar(100)    
,CALCIUM_OXIDE_value        numeric(28,8) 
,FIXED_CARBON                varchar(100)    
,FIXED_CARBON_value            numeric(28,8)    
,IRON_OXIDE                    varchar(100)    
,IRON_OXIDE_value            numeric(28,8)    
,GROSS_CALORIFIC_VALUE             varchar(100)    
,GROSS_CALORIFIC_value_VALUE        numeric(28,8)    
,INHERENT_MOISTURE            varchar(100)    
,INHERENT_MOISTURE_value    numeric(28,8)    
,INSOLUBLE_RESIDUE            varchar(100)    
,INSOLUBLE_RESIDUE_value    numeric(28,8)    
,LOSS_ON_IGINITION            varchar(100)    
,LOSS_ON_IGINITION_value    numeric(28,8)    
,MAGNISIUM_OXIDE            varchar(100)    
,MAGNISIUM_OXIDE_value        numeric(28,8)    
,MOISTURE                    varchar(100)    
,MOISTURE_value                numeric(28,8)    
,PHOSPHORUS_PENTOXIDE        varchar(100)    
,PHOSPHORUS_PENTOXIDE_value    numeric(28,8)    
,PURITY                        varchar(100)    
,PURITY_value                numeric(28,8)    
,SULPHUR                    varchar(100)    
,SULPHUR_value                numeric(28,8)    
,SILICA_DI_OXIDE            varchar(100)    
,SILICA_DI_OXIDE_value        numeric(28,8)    
,SURFACE_MOISTURE            varchar(100)    
,SURFACE_MOISTURE_value        numeric(28,8)    
,SULPHUR_TRI_OXIDE            varchar(100)    
,SULPHUR_TRI_OXIDE_value    numeric(28,8)    
,VOLATILE_MATTER            varchar(100)    
,VOLATILE_MATTER_value   numeric(28,8)   
*/
/*Code Commented for RPJRB-467 on 18.04.2025 Ends*/
,Item_flag    varchar(100)    
,Tcd_Desc    varchar(max)    
,Tcd_line_Desc varchar(max),    
item_group      varchar(max),    
remarks  varchar(max), -- Code added by S.Girish on 24 May 2023 RKILU:254 Starts   
po_lin_no nvarchar(200)--code added against RPRMCB-1
/*Code Added for RPJRB-467 Begins*/
,Item_Var_Desc	 varchar(max)
,Tare_Wgt	numeric(28,3)
,Gross_Wgt	numeric(28,3)
,Net_Wgt	numeric(28,3)
,UserID		varchar(200)
/*Code Added for RPJRB-467 Ends*/
)            
    
insert into #main_Po_Gr_Dump    
(    
OU_ID,
OU_Name                      
,Po_No           
,PO_Date          
,Gate_Entry_no         
,Gate_Entry_date        
,GRN_no           
,GRN_Date     
,GRN_Status         
,Line_No          
,Item_Code          
,VariantCode         
,Item_Desc          
,UOM           
,Supplier_inv_Qty        
,GR_Qty           
,Material_Cost         
,Cess           
,Transportation_Cost       
,Handling_charge        
,Transit_loss         
,VAT           
,Others     
,disb    
,Total_tcd_value    
,Tax_rate          
,Tax_Value          
,group_desc          
,Item_Account_Group        
,GL_Code          
,WH_Code          
,Zone           
,SupplierInvNo         
,Transport_Mode         
,SupplierCode         
,SupplierName         
,Transporter_Name        
,Transporter_Code        
,Handling_supplier_name       
,Handling_supplier_code       
,vehicleno          
,Lrno_Rrno          
,LRdate    
,Tcd_code    
,Tcd_Desc    
,Tcd_line_Desc    
,gr_tcd    
,Bin  
,po_lin_no--code added against RPRMCB-1
,Tare_Wgt,Gross_Wgt,Net_Wgt,UserID   /*Code Added for RPJRB-467*/
)    
select    
 gr_hdr_ouinstid
 ,gr_hdr_ouinstid                
,gr_hdr_orderno           
,gr_hdr_orderdate          
,convert(varchar(200),Null) 'gr_hdr_remarks'     
,convert(varchar(200),Null) 'Gate_entry_Date'        
,gr_hdr_grno       
,gr_hdr_grdate       
,gr_lin_linestatus    
,gr_lin_grlineno          
,gr_lin_itemcode          
,gr_lin_itemvariant         
,gr_lin_itemdesc    
,gr_lin_uom           
,gr_lin_acceptedqty        
,gr_lin_receivedqty           
,gr_lin_receivedqty*gr_lin_po_cost         
,Null as Cess           
,Null as Transportation_Cost       
,Null as Handling_charge        
,Null as Transit_loss      
,Null as VAT           
,Null as Others           
,Null as DISB    
,Null as Total_tcd_value         
,Null as Tax_rate     
,Null as Tax_Value          
,null as group_desc          
,null as Item_Account_Group     
,null as GL_Code    
,null as WH_Code          
,null as Zone           
,gr_hdr_suppinvno         
,gr_hdr_transmode         
,gr_hdr_suppcode         
,Null as SupplierName         
,null as Transporter_Name        
,null as Transporter_Code        
,null as Handling_supplier_name       
,null as Handling_supplier_code       
,gr_hdr_vehicleno          
,gr_hdr_lr_no          
,gr_hdr_lr_date    
,NUll,    
Null,    
null,    
gr_hdr_tcdtotalvalue,     
gr_wm_bin ,
gr_lin_orderlineno----code added against RPRMCB-1
/*Code Added for RPJRB-467 Begins*/
,gr_hdr_tareweight		'Tare_Wgt'	
,gr_hdr_grossweight		'Gross_Wgt'	
,gr_hdr_weight			'Net_Wgt'	
,gr_hdr_modifiedby		'UserID'	
/*Code Added for RPJRB-467 Ends*/
 FROM  scmdb..gr_hdr_grmain(NOLOCK)      
----gr_hdr_grmain(NOLOCK)    
 JOIN scmdb..gr_lin_details(NOLOCK)    
ON      
(    
   gr_hdr_ouinstid = gr_lin_ouinstid    
   AND gr_hdr_grno = gr_lin_grno    
)     
left join scmdb..gr_wm_whmove (nolock) --code modified by suryakala against RPJRB-730  on 06-05-2025
on gr_wm_grno = gr_hdr_grno    
and gr_wm_ouinstid = gr_hdr_ouinstid    
and gr_wm_grlineno = gr_lin_grlineno  
/*Code Added for RPJRB-467 Begins*/
Join	itm_master_vw	with	(nolock)
On		itm_itemcode		=	gr_lin_itemcode
And		itm_variantcode		=	gr_lin_itemvariant
/*Code Added for RPJRB-467 Ends*/
where gr_lin_linestatus='FM'    
--and gr_hdr_ouinstid=@ou       
and  CONVERT(DATE,gr_hdr_grdate) between @from_date and @to_date  -- code uncommented by Aparna M on 03-04-2023 for KILU-839    
and gr_hdr_suppcode = isnull(@vendor_name,gr_hdr_suppcode)       
and gr_lin_itemcode  =isnull(@item_code , gr_lin_itemcode)   
/*Code Commented and Added for PJLMIS_COMP_02 Ends*/
/*
--AND    gr_hdr_ouinstid IN (SELECT ou FROM #ou_temp) ---Code Added by Deepak 
AND gr_hdr_ouinstid in (SELECT DISTINCT OU_id FROM SCMDB..Zrit_Map_Zone_Branch_Nature_dtl WITH (NOLOCK)
WHERE Bu_id	like @DIVISION	/*Like Added for PJLMIS_COMP_02*/
And	Company_code like @Company 	/*Code Added for PJLMIS_COMP_02*/
AND Zone	LIKE @ZONE
AND
 

Branch LIKE  @BRANCH
AND OU_id LIKE @Plant)---Code Added by Amirtha.P    
*/
AND    gr_hdr_ouinstid IN ( Select ou from #user_ou with (nolock) )
And		itemtype	like	@item_type	/*Code Added for RPJRB-467 */
/*Code Commented and Added for PJLMIS_COMP_02 Ends*/
    
	

select @company_code=company_code            
from scmdb..emod_ou_bu_map map (nolock)  ,    
#main_Po_Gr_Dump d   
where d.ou_id=map.ou_id 

/* code added by suryakala against PJRMC-402 starts */
 update #main_Po_Gr_Dump
 set GRN_Status=paramdesc
		from #main_Po_Gr_Dump a
		,scmdb..component_metadata_table b(nolock)
		where	componentname	=	'GR'	
		and	paramcategory	=	'META'
		and	paramtype	=	'LINE_STATUS'
		and	paramcode	=	GRN_Status
		and	langid		=	1
/* code added by suryakala against PJRMC-402 ends */
    
Update A    
  set WH_Code =gr_wm_whcode    
,  zone =gr_wm_zone    
From #main_Po_Gr_Dump A    
join scmdb..gr_wm_whmove (Nolock)    
on gr_wm_ouinstid=a.Ou_Name    
and gr_wm_grno  =GRN_NO      
-- Code added by S.Girish on 24 May 2023 RKILU:254 Starts    
Update A 
  set remarks =gr_hdr_remarks    
From #main_Po_Gr_Dump A    
join scmdb..gr_hdr_grmain (Nolock)    
on gr_hdr_ouinstid=Ou_Name    
and gr_hdr_grno  =GRN_NO    
-- Code added by S.Girish on 24 May 2023 RKILU:254 Ends    
    
    
Update A    
set Transporter_Code=transport_code    
from #main_Po_Gr_Dump A    
Join scmdb..rm_freight_master_tbl_iedk  B(Nolock)    
on A.Po_No=tran_no    
    
Update A    
set SupplierName=sup_name    
from #main_Po_Gr_Dump A    
Join scmdb..sup_master_vw (Nolock)    
on SupplierCode=sup_code    
    
Update A    
 set Transporter_Code=case when Transport_Mode='ROAD' then gr_dtcd_suppcode else '' end    
 --,Transporter_Name=sup_name    
 ,Handling_supplier_code=case when Transport_Mode='RAIL' then gr_dtcd_suppcode else '' end    
-- ,Handling_supplier_Name=sup_name    
from #main_Po_Gr_Dump A    
Join scmdb..gr_dtcd_doctcd (nolock)     
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
Update A    
set Transporter_Name=sup_name    
from #main_Po_Gr_Dump A    
Join scmdb..sup_master_vw (Nolock) B    
on Transporter_Code=sup_code    
    
    
Update A    
set Handling_supplier_Name=isnull(sup_name,'')    
from #main_Po_Gr_Dump A    
Join scmdb..sup_master_vw (Nolock) B    
on Handling_supplier_code=sup_code    
    
    
    
Update A    
set  Cess=isnull(Sum_cess,0.00)    
,Item_flag='Document TCD'    
  from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,sum(gr_dtcd_amount) 'Sum_cess' from scmdb..gr_dtcd_doctcd (nolock)    
where gr_dtcd_tcdcode='CESS'    
group by   gr_dtcd_ouinstid,gr_dtcd_grno) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
Update A    
set  Transportation_Cost=isnull(Sum_tc,0.00)    
,Item_flag='Document TCD'    
  from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,sum(gr_dtcd_amount) 'Sum_tc' from scmdb..gr_dtcd_doctcd (nolock)    
where gr_dtcd_tcdcode in ('FRT_RD','FRT_RL')    
group by   gr_dtcd_ouinstid,gr_dtcd_grno) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
Update A    
set  DISB=isnull(Sum_DISB,0.00)      
,Item_flag='Document TCD'    
  from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,sum(gr_dtcd_amount) 'Sum_DISB' from scmdb..gr_dtcd_doctcd (nolock)    
where gr_dtcd_tcdcode  like'DISB%'    
group by   gr_dtcd_ouinstid,gr_dtcd_grno) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
    
Update A    
set  Handling_charge=isnull(sum_hc,0.00)    
,Item_flag='Document TCD'    
  from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,sum(gr_dtcd_amount) 'sum_hc' from scmdb..gr_dtcd_doctcd (nolock)    
where gr_dtcd_tcdcode in ('HNDCHRG','PHAND')    
group by   gr_dtcd_ouinstid,gr_dtcd_grno) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
    
Update A    
set  Transit_loss=isnull(Sum_tl,0.00)    
,Item_flag='Document TCD'    
  from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,sum(gr_dtcd_amount) 'Sum_tl' from scmdb..gr_dtcd_doctcd (nolock)    
where gr_dtcd_tcdcode='PMTLF'    
group by   gr_dtcd_ouinstid,gr_dtcd_grno) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
    
Update A    
set  VAT= isnull(Sum_VAT,0.00)    
,Item_flag='Document TCD'    
  from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,sum(gr_dtcd_amount) 'Sum_VAT' from scmdb..gr_dtcd_doctcd (nolock)    
where gr_dtcd_tcdcode='VAT'    
group by   gr_dtcd_ouinstid,gr_dtcd_grno) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
    
Update A    
set  Others=isnull(Sum_others,0)    
,Item_flag='Document TCD'    
  from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,sum(gr_dtcd_amount) 'Sum_others' from scmdb..gr_dtcd_doctcd (nolock)    
where gr_dtcd_tcdcode not in ('CESS','VAT','PHAND','PMTLF','HNDCHRG','FRT_RD','FRT_RL')    
and gr_dtcd_tcdcode not like 'DISB%'    
group by   gr_dtcd_ouinstid,gr_dtcd_grno) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
    
Update A  
set  Cess=isnull(Sum_cess,0.00)    
,Item_flag='Document TCD'    
  from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,sum(gr_dtcd_amount) 'Sum_cess' from scmdb..gr_dtcd_doctcd (nolock)    
where gr_dtcd_tcdcode='CESS'    
group by   gr_dtcd_ouinstid,gr_dtcd_grno) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
Update A    
set  Transportation_Cost=isnull(Sum_tc,0.00)  
,Item_flag='Document TCD'    
  from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,sum(gr_dtcd_amount) 'Sum_tc' from scmdb..gr_dtcd_doctcd (nolock)    
where gr_dtcd_tcdcode in ('FRT_RD','FRT_RL')    
group by gr_dtcd_ouinstid,gr_dtcd_grno) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
Update A    
set  DISB=isnull(Sum_DISB,0.00)      
,Item_flag='Document TCD'    
  from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,sum(gr_dtcd_amount) 'Sum_DISB' from scmdb..gr_dtcd_doctcd (nolock)    
where gr_dtcd_tcdcode  like'DISB%'    
group by   gr_dtcd_ouinstid,gr_dtcd_grno) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
  
Update A    
set  Handling_charge=isnull(sum_hc,0.00)    
,Item_flag='Document TCD'    
  from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,sum(gr_dtcd_amount) 'sum_hc' from scmdb..gr_dtcd_doctcd (nolock)    
where gr_dtcd_tcdcode in ('HNDCHRG','PHAND')    
group by   gr_dtcd_ouinstid,gr_dtcd_grno) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
    
Update A    
set  Transit_loss=isnull(Sum_tl,0.00)    
,Item_flag='Document TCD'    
  from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,sum(gr_dtcd_amount) 'Sum_tl' from scmdb..gr_dtcd_doctcd (nolock)    
where gr_dtcd_tcdcode='PMTLF'    
group by   gr_dtcd_ouinstid,gr_dtcd_grno) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    

    
Update A    
set  VAT= isnull(Sum_VAT,0.00)    
,Item_flag='Document TCD'    
  from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,sum(gr_dtcd_amount) 'Sum_VAT' from scmdb..gr_dtcd_doctcd (nolock)    
where gr_dtcd_tcdcode='VAT'    
group by   gr_dtcd_ouinstid,gr_dtcd_grno) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
    
Update A    
set  Others=isnull(Sum_others,0)    
,Item_flag='Document TCD'    
  from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,sum(gr_dtcd_amount) 'Sum_others' from scmdb..gr_dtcd_doctcd (nolock)    
where gr_dtcd_tcdcode not in ('CESS','VAT','PHAND','PMTLF','HNDCHRG','FRT_RD','FRT_RL')    
and gr_dtcd_tcdcode not like 'DISB%'    
group by   gr_dtcd_ouinstid,gr_dtcd_grno) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
    
Update A    
set  Cess_it=isnull(Sum_cess_itm,0.00)    
--,Item_flag='Line Level Tcd'    
  from #main_Po_Gr_Dump A    
Join (select gr_itcd_ouinstid,gr_itcd_grlineno,gr_itcd_grno,sum(gr_itcd_amount) 'Sum_cess_itm' from scmdb..gr_itcd_itmtcd (nolock)    
where gr_itcd_tcdcode='CESS'    
group by  gr_itcd_ouinstid,gr_itcd_grlineno,gr_itcd_grno) C    
on  gr_itcd_ouinstid=OU_Name    
and gr_itcd_grno=GRN_no    
and gr_itcd_grlineno=Line_No    
--where Cess is null----/* code commented by Paul on 04/04/2023 Ledger Mismatch Issue */    
--and Item_flag is null    
       
    
Update A    
set  Transportation_Cost_it=isnull(Sum_tc_itm,0.00)      
--,Item_flag='Line Level Tcd'    
  from #main_Po_Gr_Dump A    Join (select gr_itcd_ouinstid,gr_itcd_grlineno,gr_itcd_grno,sum(gr_itcd_amount) 'Sum_tc_itm' from scmdb..gr_itcd_itmtcd (nolock)    
where gr_itcd_tcdcode in ('FRT_RD','FRT_RL')    
group by   gr_itcd_ouinstid,gr_itcd_grlineno,gr_itcd_grno) C    
on  gr_itcd_ouinstid=OU_Name    
and gr_itcd_grno=GRN_no    
and gr_itcd_grlineno=Line_No    
--where Transportation_Cost is null----/* code commented by Paul on 04/04/2023 Ledger Mismatch Issue */    
--and Item_flag is null    
    
    
Update A    
set  DISB_it=isnull(Sum_dis_itm,0.00)    
--,Item_flag='Line Level Tcd'    
  from #main_Po_Gr_Dump A    
Join (select gr_itcd_ouinstid,gr_itcd_grlineno,gr_itcd_grno,sum(gr_itcd_amount) 'Sum_dis_itm' from scmdb..gr_itcd_itmtcd (nolock)    
where gr_itcd_tcdcode like'DISB%'    
group by   gr_itcd_ouinstid,gr_itcd_grlineno,gr_itcd_grno) C    
on gr_itcd_ouinstid=OU_Name    
and gr_itcd_grno=GRN_no    
and gr_itcd_grlineno=Line_No    
--where DISB is null/* code commented by Paul on 04/04/2023 Ledger Mismatch Issue */    
--and Item_flag is null    
    
    
    
Update A    
set  Handling_charge_it=isnull(Sum_hand_itm,0.00)    
--,Item_flag='Line Level Tcd'    
  from #main_Po_Gr_Dump A    
Join (select gr_itcd_ouinstid,gr_itcd_grlineno,gr_itcd_grno,sum(gr_itcd_amount) 'Sum_hand_itm' from scmdb..gr_itcd_itmtcd (nolock) 
where gr_itcd_tcdcode in ('HNDCHRG','PHAND')    
group by   gr_itcd_ouinstid,gr_itcd_grlineno,gr_itcd_grno) C    
on  gr_itcd_ouinstid=OU_Name    
and gr_itcd_grno=GRN_no    
and gr_itcd_grlineno=Line_No    
/* code commented by Paul on 04/04/2023 Ledger Mismatch Issue */    
--where Handling_charge is null    
--and Item_flag is null    
/* code commented by Paul on 04/04/2023 Ledger Mismatch Issue */    
    
    
Update A    
set  Transit_loss_it=isnull(Sum_mT_itm,0.00)     
--,Item_flag='Line Level Tcd'    
  from #main_Po_Gr_Dump A    
Join (select gr_itcd_ouinstid,gr_itcd_grlineno,gr_itcd_grno,sum(gr_itcd_amount) 'Sum_mT_itm' from scmdb..gr_itcd_itmtcd (nolock)  
where gr_itcd_tcdcode='PMTLF'    
group by   gr_itcd_ouinstid,gr_itcd_grlineno,gr_itcd_grno) C    
on  gr_itcd_ouinstid=OU_Name    
and gr_itcd_grno=GRN_no    
and gr_itcd_grlineno=Line_No    
/* code commented by Paul on 04/04/2023 Ledger Mismatch Issue */    
--where Transit_loss is null    
--and Item_flag is null    
/* code commented by Paul on 04/04/2023 Ledger Mismatch Issue */    
    
    
Update A    
set  VAT_it= isnull(Sum_VAT_itm,0.00)    
--,Item_flag='Line Level Tcd'    
  from #main_Po_Gr_Dump A    
Join (select gr_itcd_ouinstid,gr_itcd_grlineno,gr_itcd_grno,sum(gr_itcd_amount) 'Sum_VAT_itm' from scmdb..gr_itcd_itmtcd (nolock)    
where gr_itcd_tcdcode ='VAT'    
group by   gr_itcd_ouinstid,gr_itcd_grlineno,gr_itcd_grno) C    
on  gr_itcd_ouinstid=OU_Name    
and gr_itcd_grno=GRN_no    
and gr_itcd_grlineno=Line_No    
/* code commented by Paul on 04/04/2023 Ledger Mismatch Issue */    
--where VAT is null    
--and Item_flag is null    
/* code commented by Paul on 04/04/2023 Ledger Mismatch Issue */    
    
    
Update A    
set  Others_it=isnull(C.Sum_oth_itm,0)    
--,Item_flag='Line Level Tcd'    
from #main_Po_Gr_Dump A    
Join (select gr_itcd_ouinstid,gr_itcd_grlineno,gr_itcd_grno,sum(gr_itcd_amount) 'Sum_oth_itm' from scmdb..gr_itcd_itmtcd (nolock)    
where  gr_itcd_tcdcode not in ('CESS','VAT','PHAND','PMTLF','HNDCHRG','FRT_RD','FRT_RL')    
and gr_itcd_tcdcode not like 'DISB%'    
group by   gr_itcd_ouinstid,gr_itcd_grlineno,gr_itcd_grno) C  
on  gr_itcd_ouinstid=OU_Name    
and gr_itcd_grno=GRN_no    
and gr_itcd_grlineno=Line_No    
/* code commented by Paul on 04/04/2023 Ledger Mismatch Issue */    
--where Others is null    
--and Item_flag is null    
/* code commented by Paul on 04/04/2023 Ledger Mismatch Issue */    
    
    
Update A    
set Tcd_code=tcd    
,Tcd_desc=t_desc    
from #main_Po_Gr_Dump A    
Join (select gr_dtcd_ouinstid,gr_dtcd_grno,STRING_AGG(gr_dtcd_tcdcode,',') 'tcd',string_agg(tcdhd_tcddescription,',') 't_desc'     
from scmdb..gr_dtcd_doctcd with(nolock)    
join scmdb..tcd_tcdhd_tcdcodehdr  (Nolock)   
on gr_dtcd_tcdcode=tcdhd_tcdcode    
group by gr_dtcd_ouinstid,gr_dtcd_grno    
) B    
on  gr_dtcd_ouinstid=OU_Name    
and gr_dtcd_grno=GRN_no    
    
    
    
    
Update A    
set TCD_CODE_line=item_tcd    
,TCD_line_desc=t_desc    
from #main_Po_Gr_Dump A    
Join (select gr_itcd_ouinstid,gr_itcd_tcdcode,gr_itcd_grlineno,gr_itcd_grno,string_agg(gr_itcd_tcdcode,',') 'item_tcd',string_agg(tcdhd_tcddescription,',') 't_desc'     
from scmdb..gr_itcd_itmtcd (nolock)    
join scmdb..tcd_tcdhd_tcdcodehdr  (Nolock)    
on gr_itcd_tcdcode=tcdhd_tcdcode    
group by   gr_itcd_ouinstid,gr_itcd_tcdcode,gr_itcd_grlineno,gr_itcd_grno    
) B    
on  gr_itcd_ouinstid=OU_Name    
and gr_itcd_grno=GRN_no    
and gr_itcd_grlineno=Line_no 
--where Tcd_code is null    -- /*code commented by suryakala against PJRMC-402 on 31 aug 2024*/   
    
    
   
--select * from scmdb..gr_hdr_grmain where gr_hdr_grno = 'SDMGRT23/0001556' --test    
--select * from scmdb..gr_dtcd_doctcd where gr_dtcd_grno = 'SDMGRT23/0001556' --test    
    
    
    
    
    
Update A    
set Cess=Cess*(Material_Cost/mat_cess)    
,Transportation_Cost=Transportation_Cost*(Material_Cost/mat_cess)    
,Handling_charge=Handling_charge*(Material_Cost/mat_cess)    
,Transit_loss=Transit_loss*(Material_Cost/mat_cess)    
,VAT=VAT*(Material_Cost/mat_cess)    
,Others=Others*(Material_Cost/mat_cess)    
,disb=disb*(Material_Cost/mat_cess) --test    
from #main_Po_Gr_Dump A    
Join (select OU_Name,Po_No,GRN_no,sum(Material_Cost) 'Mat_cess'from #main_Po_Gr_Dump    
group by OU_Name,Po_No,GRN_no) B    
on     
 A.OU_Name=B.OU_Name    
and A.Po_No=B.Po_No    
and A.GRN_no=B.GRN_no    
where Item_flag='Document TCD'    
    
    
    
    
 /*    
 Transportation_Cost =case when gr_dtcd_tcdcode in ('FRT_RD','FRT_RL') then gr_dtcd_amount else 0.00 end     
 Handling_charge  =case when gr_dtcd_tcdcode like '%HNDCHRG%' then gr_dtcd_amount else 0.00 end 
 Transit_loss  =case when gr_dtcd_tcdcode like '%PMTLF%' then gr_dtcd_amount else 0.00 end     
 VAT     =case when gr_dtcd_tcdcode like '%VAT%' then gr_dtcd_amount else 0.00 end     
 Others        =case when gr_dtcd_tcdcode not in('cess','VAT','HNDCHRG') then gr_dtcd_amount else 0.00 end     
 */    
    
Update A    
Set Total_tcd_value=    
isnull(Cess_it,0.00)           
+isnull(Transportation_Cost_it,0.00)            
+isnull(Handling_charge_it,0.00)      
+isnull(Transit_loss_it,0.00)       
+isnull(VAT_it,0.00)         
+isnull(Others_it,0.00)    
+isnull(DISB_it,0.00)     
+isnull(Cess,0.00)           
+isnull(Transportation_Cost,0.00)            
+isnull(Handling_charge,0.00)      
+isnull(Transit_loss,0.00)       
+isnull(VAT,0.00)         
+isnull(Others,0.00)    
+isnull(DISB,0.00)    
from #main_Po_Gr_Dump A    
/*Join (select     
OU_Name,GRN_no,sum(isnull(Cess,0.00))+sum(isnull(Transportation_Cost,0.00))    
+sum(isnull(Handling_charge,0.00))+sum(isnull(Transit_loss,0.00))+sum(isnull(VAT,0.00))+sum(isnull(Others,0.00))+sum(isnull(DISB,0.00)) 'total_sum'    
from #main_Po_Gr_Dump (Nolock)     
Group by OU_Name,GRN_no) B    
on  A.OU_Name=B.OU_Name    
and A.GRN_no=B.GRN_no    
*/    


 
    
Update A    
set Item_flag='Line Level TCD'    
from #main_Po_Gr_Dump A    
where Item_flag is null 
 /*code  added by suryakala against PJRMC-402 on 31 aug 2024 starts here */   
and gr_tcd !='0.00'
 and Total_tcd_value !='0.00' 
 
--AND  Item_flag is null 
 /*code  added by suryakala against PJRMC-402 on 31 aug 2024 starts here */   
--and gr_tcd !=isnull(gr_tcd,'0.00')
 --and Total_tcd_value !=isnull(Total_tcd_value,'0.00')    


Update A    
set Item_flag='Document/Line Level TCD'    
from #main_Po_Gr_Dump A    
where 
 TCD_CODE_line is not null
and Tcd_code is not null
      /*code  added by suryakala against PJRMC-402 on 31 aug 2024 ends here */    

    
Update A    
set dump_tcd=tcd_dump    
from #main_Po_Gr_Dump A    
Join (select sum(Total_tcd_value) 'tcd_dump'    
,OU_Name    
,GRN_no    
from #main_Po_Gr_Dump (Nolock)  
group by     
OU_Name    
,GRN_no    
)B    
on  A.OU_Name=B.OU_Name    
and A.GRN_no=B.GRN_no    
--and A.gr_itcd_grlineno=B.Line_No    
    
    
    
    
Drop table If exists #tax    
select tran_no,tran_ou,tax_type, code_type,sum(tax_rate) 'tax_rate',sum(corr_tax_amt) as 'tax'    
into #tax    
from scmdb..tcal_TAx_dtl (nolock)    
group by tran_no,tran_ou,tax_type,code_type    
 
    
Update A    
Set Tax_Rate=convert(numeric(18,2),B.tax_rate )   
,Tax_Value=Tax    
From #main_Po_Gr_Dump A  
Join #tax B    
on tran_no=GRN_no    
and tran_ou=ou_name  
    
    
Update A    
set Item_Account_Group= account_group    
from #main_Po_Gr_Dump A    
Join MISDB..itm_master_vw B(Nolock)   
on itm_itemcode=item_code     
and itm_variantcode=VariantCode    

/*Code Added for RPJRB-467 Begins*/
Update	T
Set		Item_Var_Desc		=	lov_itmvardesc
from	#main_Po_Gr_Dump	T
Join	scmdb..itm_lov_varianthdr	
On		lov_itemcode		=	item_code
And		lov_variantcode		=	VariantCode

Update	T
Set		UserID	=	fullname
From	#main_Po_Gr_Dump	T
Join	scmdb..fw_admin_user
On		UserID	=	username


/*Code Added for RPJRB-467 Ends*/
    
Update A    
set GL_CODE=account_code       
from #main_Po_Gr_Dump A    
Join scmdb..emod_bu_ou_fb_map (Nolock) B    
on a.ou_name=b.ou_id    
Join scmdb..ard_item_account_mst C(Nolock)    
on Item_account_group=item_acctgrp    
and B.fb_id=C.fb_id    
where account_type='STKAC'    
and getdate() between C.effective_from and isnull(C.effective_to,getdate())    
    
    
    
update T    
set GL_description = ml_account_desc  
from #main_Po_Gr_Dump T    
join scmdb..as_ml_opaccount_dtl A(nolock)    
on account_code = GL_CODE    
join scmdb..as_opaccountcomp_map B(nolock)    
on  A.opcoa_id = B.opcoa_id    
and A.account_code = B.account_code    
and   company_code = @company_code    
    
Update A    
set PO_Date=convert(varchar(30),pomas_createddate,105)/*code added by Alisodaipandian A on 01-04-2023*/    
from #main_Po_Gr_Dump A    
Join scmdb..po_pomas_pur_order_hdr (Nolock)     
on ou_name=pomas_poou    
and pomas_pono=Po_No    
    
    
    
    
Update A    
set ou_name=ouinstdesc    
from #main_Po_Gr_Dump A    
Join scmdb..fw_admin_ouinstance (Nolock)     
on ou_name=ouinstid    
    
    
Update A    
set Gate_Entry_no=ge_gateentrynumber    
,Gate_Entry_date=isnull(ge_date,'')--convert(varchar(300),ge_date+' '+ge_time)  /*code  added by suryakala against PJRMC-402 on 31 aug 2024 ends here */    
from #main_Po_Gr_Dump A    
Join scmdb..GR_Gatent_hdr (Nolock)     
on Po_No=ge_porsno    
    
    
Update A    
set group_desc= item_igm_groupdesc      
from #main_Po_Gr_Dump A    
Join scmdb..item_group_byitem (Nolock) B    
on item_igi_itemcode=Item_Code    
and item_igi_variantcode=VariantCode    
Join scmdb..item_group_master(Nolock) C    
on B.item_igi_groupcode=C.item_igm_groupcode    
where item_igt_grouptype='MIS'    
    
    
--GR_Gatent_hdr---ge_gateentrynumber,ge_date    
--item_group_byitem,item_group_master----item_igi_groupcode    
--ard_item_account_mst    
--sp_tables '%item%group%'    
    
    
/*    
ard_item_account_mst    
    
ard_item_account_mst    
account_type='STKAC'    
sp_tables '%ard%item%acc%'    
    
item_acctgrp    
select * from ard_item_account_mst    
where item_acctgrp='COAL-G-5'    
fb_id    
    
sp_tables '%ard%acc%'    
    
select * from  tcal_TAx_dtl     
where tran_no='SDMGRT23/0002634'    
order by created_date desc    
 
*/    
--select distinct gr_dtcd_tcdcode,tcdcodevariantdesc from gr_dtcd_doctcd    
--Join tcd_tcdvardtl_lang_desc_vw    
--on gr_dtcd_tcdcode=tcdcode    
     
/*Code Commented for RPJRB-467 on 18.04.2025  Begins*/
/*	 
update #main_Po_Gr_Dump        
set GREATER_THAN_45_MICRONS = case when transport_mode= 'ROAD'    
then (select attributecode from scmdb..gr_qual_ins_dtl with(nolock)     
where gr_strno =grn_no    
and attributecode like '%45MIC'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%45MIC'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
) end,    
GREATER_THAN_45_MICRONS_value = case when transport_mode= 'ROAD'    
then (select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)     
where gr_strno =grn_no    
and attributecode like '%45MIC'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%45MIC'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
) end    
    
    
update #main_Po_Gr_Dump    
set GREATER_THAN_90_MICRONS = case when transport_mode='Road'    
then (select attributecode from  scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%90MIC%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%90MIC%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
GREATER_THAN_90_MICRONS_VALUE = case when transport_mode='Road'    
then (select actParvalue from  scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%90MIC%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%90MIC%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end    
    
update #main_Po_Gr_Dump    
set ALUMINA = case when transport_mode='ROAD'    
then (select attributecode from   scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%AL203%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%AL203%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
 ALUMINA_VALUE = case when transport_mode='ROAD'    
then (select actParvalue from   scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%AL203%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%AL203%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end    
    
    
update #main_Po_Gr_Dump    
set ASH= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%ASH%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%ASH%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
 ASH_VALUE= case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%ASH%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%ASH%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end    
    
    
update #main_Po_Gr_Dump    
set CALCIUM_OXIDE= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%CAO%'    
AND itemcode = Item_Code    
AND itemvariant = VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%CAO%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
CALCIUM_OXIDE_VALUE= case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%CAO%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%CAO%'    
AND itemcode = Item_Code 
AND itemvariant =  VariantCode    
)    
end    
    
    
    
update #main_Po_Gr_Dump    
set FIXED_CARBON= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%FC%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%FC%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
FIXED_CARBON_VALUE= case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%FC%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%FC%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end    
    
    
update #main_Po_Gr_Dump    
set IRON_OXIDE= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no  
and attributecode like '%FE2O3%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%FE2O3%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
IRON_OXIDE_VALUE = case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%FE2O3%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode)    
ELSE    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%FE2O3%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
END    
    
    
    
update #main_Po_Gr_Dump    
set GROSS_CALORIFIC_VALUE= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%GCV%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%GCV%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
GROSS_CALORIFIC_VALUE_VALUE = case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%GCV%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode)    
ELSE    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%IM%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
    
END  
    
    
update #main_Po_Gr_Dump    
set INHERENT_MOISTURE= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%IM%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%IM%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
 INHERENT_MOISTURE_VALUE = case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%IM%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode)    
ELSE    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%IM%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
    
END    
    
    
update #main_Po_Gr_Dump    
set INSOLUBLE_RESIDUE= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%IR%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%IR%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
 INSOLUBLE_RESIDUE_VALUE = case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%IR%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode)    
ELSE    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%IR%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
    
END    
    
    
update #main_Po_Gr_Dump    
set LOSS_ON_IGINITION= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%LOI%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%LOI%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
 LOSS_ON_IGINITION_VALUE = case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%LOI%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode)    
ELSE    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%LOI%'    
AND itemcode = Item_Code  
AND itemvariant =  VariantCode    
)    
    
END    
    
update #main_Po_Gr_Dump    
set MAGNISIUM_OXIDE= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%MGO%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no  
and attributecode like '%MGO%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
 MAGNISIUM_OXIDE_VALUE = case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%MGO%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode)    
ELSE    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)    
where grstrno =grn_no    
and attributecode like '%MGO%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
    
END    
    
    
update #main_Po_Gr_Dump    
set MOISTURE= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%MOIS%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%MOIS%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
 MOISTURE_VALUE = case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%MOIS%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode)    
ELSE    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%MOIS%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
    
END    
/*    
update #main_Po_Gr_Dump    
set NCV= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl    
where gr_strno =grn_no    
and attributecode like '%NCV%')    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl     
where grstrno =grn_no    
and attributecode like '%NCV%')    
end*/    

update #main_Po_Gr_Dump    
set PHOSPHORUS_PENTOXIDE= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%P2O5%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%P2O5%' 
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
 PHOSPHORUS_PENTOXIDE_VALUE = case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%P2O5%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode) 
ELSE    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%P2O5%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
    
END    
    
update #main_Po_Gr_Dump    
set PURITY= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%PURITY%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%PURITY%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
 PURITY_VALUE = case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%PURITY%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode)    
ELSE    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no 
and attributecode like '%PURITY%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
    
END    
    
update #main_Po_Gr_Dump    
set SULPHUR= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode ='S'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode ='S'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
 SULPHUR_VALUE = case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode ='S'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode)    
ELSE    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)    
where grstrno =grn_no    
and attributecode ='S'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
    
END    
    
update #main_Po_Gr_Dump    
set SILICA_DI_OXIDE= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%SIO2%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%SIO2%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
 SILICA_DI_OXIDE_VALUE = case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%SIO2%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode)    
ELSE    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl  with(nolock)    
where grstrno =grn_no    
and attributecode like '%SIO2%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
    
END    
    
update #main_Po_Gr_Dump    
set SURFACE_MOISTURE= case when transport_mode ='ROAD'    
then    
(select DISTINCT attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode ='SM'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select DISTINCT attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode ='SM'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
 SURFACE_MOISTURE_VALUE = case when transport_mode ='ROAD'    
then    
(select DISTINCT actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode ='SM'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode)    
ELSE    
(select DISTINCT ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode ='SM'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
    
END    
    
update #main_Po_Gr_Dump    
set SULPHUR_TRI_OXIDE= case when transport_mode ='ROAD'    
then    
(select attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%SO3%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%SO3%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
 SULPHUR_TRI_OXIDE_VALUE = case when transport_mode ='ROAD'    
then    
(select actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%SO3%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode)    
ELSE    
(select ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%SO3%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
    
END    
    
    
    
    
update #main_Po_Gr_Dump    
set VOLATILE_MATTER= case when transport_mode ='ROAD'    
then    
(select DISTINCT attributecode from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%VM%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select DISTINCT attributecode from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%VM%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end,    
 VOLATILE_MATTER_VALUE= case when transport_mode ='ROAD'    
then    
(select DISTINCT actParvalue from scmdb..gr_qual_ins_dtl with(nolock)    
where gr_strno =grn_no    
and attributecode like '%VM%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
else    
(select DISTINCT ValSmp1 from scmdb..gr_qual_insp_wgn_dtl with(nolock)     
where grstrno =grn_no    
and attributecode like '%VM%'    
AND itemcode = Item_Code    
AND itemvariant =  VariantCode    
)    
end    
*/
/*Code Commented for RPJRB-467 on 18.04.2025 Ends*/
 
   
alter table #main_Po_Gr_Dump 
add  BU_Code varchar(80),
	 Branch varchar(80),
	 Company_Code varchar(80)
	 update #main_Po_Gr_Dump
set [zone] = paramdesc,
branch = a.branch,
BU_Code=a.Bu_Name,
Company_Code=a.Company_Name,
OUinstName=a.OU_Name
from  scmdb..Zrit_Map_Zone_Branch_Nature_dtl a
join #main_Po_Gr_Dump c on c.OU_ID =a.Ou_id
join scmdb..component_metadata_table with(nolock) 
  on a.[Zone] = paramcode
and componentname = 'EMOD'   
and paramcategory = 'COMBO'   
and paramtype = 'ZONE'
and langid =  1/*Code Added for PJLMIS_COMP_02*/

/*code added by K Vishnupriya for rtrack id : RMC_INV_106 starts*/ 
 alter table #main_Po_Gr_Dump
 add variant_desc varchar(600) ,
 item_account_grp_desc varchar(600) /*code added by suryakala against PJRMC-402*/

update A
 set  variant_desc =   mlt1.ml_varshortdesc        
from #main_Po_Gr_Dump A (nolock)      
 inner join  scmdb..itm_ml_multilanguage mlt1 (nolock)       
on       
    mlt1.ml_itemcode =  Item_Code   
and  mlt1.ml_variantcode = VariantCode      
and  mlt1.ml_langid  = 1--@ctxt_language
/*code added by K Vishnupriya for rtrack id : RMC_INV_106 ends*/ 
/* Code added by SuryaKala against PJRMC-402 starts*/
update  A
set item_account_grp_desc=rtrim(ag_description)       
  from #main_Po_Gr_Dump A join
  scmdb..itm_ag_accountgrphdr(nolock)      
  on       
    ag_accountgroup = isnull(A.Item_Account_Group,'')

/* Code added by SuryaKala against PJRMC-402 ends*/
    
/*  --surya 
	if @@spid=198
	begin

	--select VariantCode,* from #main_Po_Gr_Dump where VariantCode='##'
	end 

	*/ 

	update #main_Po_Gr_Dump
	set VariantCode=NULL
	where VariantCode='##'

	--Code added By Vasanthi K against id:PJRMC-953 BEGINS
	alter table #main_Po_Gr_Dump
 add Unit_Rate numeric(28,2)



 update A
 set Unit_rate=poitm_po_cost
 from #main_Po_Gr_Dump A
 join scmdb..po_poitm_item_detail B (nolock)
 on  poitm_pono=Po_No
 and poitm_polineno=po_lin_no--code added against RPRMCB-1(unit rate mismatch)
	--Code added By Vasanthi K against id:PJRMC-953 ENDS

	/*code added against RPJRB-625 28.04.25 starts*/
	alter table #main_Po_Gr_Dump add WB_Accepted_Weight	 numeric(28,3)
	alter table #main_Po_Gr_Dump add WB_Deduction		 numeric(28,3)
	alter table #main_Po_Gr_Dump add Adjustment_Quantity numeric(28,3)
	alter table #main_Po_Gr_Dump add Adjustment_Value	 numeric(28,2)

	update a
	set WB_Accepted_Weight = Wbtp_Acc_Wght
	,	WB_Deduction	   = case when Wbtp_Ded_Type = 'Prctg' then Wbtp_Ded_per
								  when Wbtp_Ded_Type = 'kg%' then Wbtp_Ded_Kgs else 0 end
	from #main_Po_Gr_Dump a
	join scmdb..mcl_factweb_tranaction_dtl b with(nolock)
	on	 a.GRN_no	= b.gr_hdr_grno
	join SCMDB..Zrit_WB_Trip_Dtl c
	on	 b.tran_no	= c.Wbtp_Po_So_No
	and	 b.veh_no	= c.Wbtp_Vech_No
	and	 b.Trip_No	= c.Wbtp_WB_Trp_No
	and	 b.item_code= c.Wbtp_Item_Code
	and	 b.item_var	= c.Wbtp_Variant_Code

	update a
	set Adjustment_Quantity = adf_adjust_quantity
	,	Adjustment_Value	= adf_adjust_value
	from #main_Po_Gr_Dump a 
	join scmdb..Zrit_Auto_GRN_dtl b with(nolock)	
	on  b.GR_No	   = a.GRN_no 
	join scmdb..adj_adjustment_fin_dtl c with(nolock)
	on b.Stkadj_No = c.adf_tran_no
	/*code added against RPJRB-625 28.04.25 ends*/

select  
ISNULL(Company_Code,'') 'COMPANY',
ISNULL(BU_Code,'') 'BU',
isnull(Zone,'') 'ZONE',  
ISNULL(branch,'') 'BRANCH',
isnull(OUinstName,'')       'OU',   
isnull(OU_Name,'')          'OU NAME',    
isnull(Po_No,'')           'PO NO' ,   
IIF(PO_Date='1900-01-01 00:00:00.000',null,PO_Date)  'PO DATE'    
,isnull(Gate_Entry_no,'')   'GATE ENTRY NO'    
,IIF(Gate_Entry_date='1900-01-01 00:00:00.000','',Gate_Entry_date) 'GATE ENTRY DATE'    
,isnull(GRN_no,'')         'GRN NO'    
,IIF(GRN_DATE='1900-01-01 00:00:00.000',null,GRN_DATE)        'GRN DATE'    
,isnull(GRN_Status,'') 'GRN Status'    
,isnull(Line_No,'')         'LINE NO'    
,isnull(Item_Code,'')       'ITEM CODE' 
,isnull(VariantCode,'')     'VARIANT CODE'    
,isnull(Item_Desc,'')     'ITEM DESC'    
,isnull(UOM,'')        'UOM'    
,isnull(Supplier_inv_Qty,0)  'INVOICE QUANTITY'    
,isnull(GR_Qty,0)            'GR QUANTITY'    
,isnull(Material_Cost,0)     'MATERIAL COST'    
,isnull(Cess,0)              'CESS_doc'    
,isnull(Transportation_Cost,0)  'TRANSPORTATION_COST_Doc'    
,isnull(Handling_charge,0)   'HANDLING_CHANRGES_doc'    
,isnull(Transit_loss,0)  'TRANSIT_LOSS_doc'    
,isnull(VAT,0)        'VAT_Doc'    
,isnull(Others,0)      'OTHERS_Doc'    
,isnull(DISB,0) 'DISB_Doc'    
,isnull(Cess_it,0)              'CESS_Line'    
,isnull(Transportation_Cost_it,0)  'TRANSPORTATION_COST_line'    
,isnull(Handling_charge_it,0)   'HANDLING_CHANRGES_line'    
,isnull(Transit_loss_it,0)  'TRANSIT_LOSS_line'    
,isnull(VAT_it,0)       'VAT_line'    
,isnull(Others_it,0)      'OTHERS_line'    
,isnull(DISB_it,0) 'DISB_line'    
,isnull(Tcd_code,'')   'TCD_document'    
,isnull(TCD_CODE_line,'')   'TCD_line'    
,isnull(Tcd_Desc,'')  'TCD_document_desc'    
,isnull(TCD_line_desc,'')   'TCD_line_desc' 
,isnull(Total_tcd_value,0) 'TOTAL TCD VALUE'    
,isnull(dump_tcd,0.00) 'dump_tcd'     
,isnull(gr_tcd , 0)  'gr_tcd'    
,isnull(Item_flag,'') 'TCD_LEVEL'    
,isnull(Tax_rate,0) 'TAX RATE'     
,(group_desc) 'ITEM GROUP DESC'    
,(item_account_grp_desc) 'ITEM ACCOUNT GROUP'     /*code  modified by suryakala against PJRMC-402 on 31 aug 2024  */     
,isnull(GL_Code,'') 'GL CODE'    
,isnull(GL_description , '') 'GL description'    
,isnull(WH_Code,'') 'WHARHOUSE CODE'    
,isnull(SupplierInvNo,'') 'SUPPLIER INVOICE NO'    
,isnull(Transport_Mode,'') 'TRANSPORTATION MODE'    
,isnull(SupplierCode,'')  'SUPPLIER CODE'    
,isnull(SupplierName,'')  'SUPPLIER NAME'    
,isnull(Transporter_Name,'') 'TRANSPORTER NAME'     
,isnull(Transporter_Code,'') 'TRANSPORTER CODE'     
,isnull(Handling_supplier_name,'')'HANDLING SUPPLIER NAME'     
,isnull(Handling_supplier_code,'')'HANDLING SUPPLIER NAME'     
,isnull(vehicleno,'')    'VEHICLE NO'    
,isnull(Lrno_Rrno,'')    'LRNO'    
,IIF(LRdate='1900-01-01 00:00:00.000',null,LRdate) 'LR DATE'
/*
,isnull(bin,'')   'Bin'    
,'GREATER_THAN_90_MICRONS'            
,'GREATER_THAN_90_MICRONS_value'        
,'ALUMINA'                        
,'ALUMINA_value'                    
,'ASH'                            
,'ASH_value'                        
,'CALCIUM_OXIDE'                    
,'CALCIUM_OXIDE_value'            
,'FIXED_CARBON'                    
,'FIXED_CARBON_value'                
,'IRON_OXIDE'                        
,'IRON_OXIDE_value'                
,'GROSS_CALORIFIC_VALUE'                 
,'GROSS_CALORIFIC__VALUE_value'            
,'INHERENT_MOISTURE'                
,'INHERENT_MOISTURE_value'        
,'INSOLUBLE_RESIDUE'                
,'INSOLUBLE_RESIDUE_value'        
,'LOSS_ON_IGINITION'                
,'LOSS_ON_IGINITION_value'        
,'MAGNISIUM_OXIDE'         
,'MAGNISIUM_OXIDE_value'            
,'MOISTURE'                        
,'MOISTURE_value'                    
,'PHOSPHORUS_PENTOXIDE'            
,'PHOSPHORUS_PENTOXIDE_value'        
,'PURITY'                            
,'PURITY_value'                    
,'SULPHUR'                        
,'SULPHUR_value'                    
,'SILICA_DI_OXIDE'                
,'SILICA_DI_OXIDE_value'            
,'SURFACE_MOISTURE'                
,'SURFACE_MOISTURE_value'            
,'SULPHUR_TRI_OXIDE'                
,'SULPHUR_TRI_OXIDE_value'        
,'VOLATILE_MATTER'                
,'VOLATILE_MATTER_value'           
,isnull(GREATER_THAN_45_MICRONS,'')        'GREATER_THAN_45_MICRONS'    
,isnull(convert(varchar(100),GREATER_THAN_45_MICRONS_value),'')   'GREATER_THAN_45_MICRONS_value'    
,isnull(GREATER_THAN_90_MICRONS,'')        'GREATER_THAN_90_MICRONS'     
,isnull(convert(varchar(100),GREATER_THAN_90_MICRONS_value,0),'')   'GREATER_THAN_90_MICRONS_value'                  
,isnull(ALUMINA,'')                        'ALUMINA'     
,isnull(convert(varchar(100),ALUMINA_value ,0),'')                  'ALUMINA_value'          
,isnull(ASH,'')                            'ASH'    
,isnull(convert(varchar(100),ASH_value ,0),'')                      'ASH_value'        
,isnull(CALCIUM_OXIDE,'')                  'CALCIUM_OXIDE'    
,isnull(convert(varchar(100),CALCIUM_OXIDE_value,0),'')             'CALCIUM_OXIDE_value'     
,isnull(FIXED_CARBON,'')                   'FIXED_CARBON'    
,isnull(convert(varchar(100),FIXED_CARBON_value,0),'')              'FIXED_CARBON_value'             
,isnull(IRON_OXIDE ,'')                    'IRON_OXIDE'           
,isnull(convert(varchar(100),IRON_OXIDE_value ,0),'')               'IRON_OXIDE_value'         
,isnull(GROSS_CALORIFIC_VALUE,'')          'GROSS_CALORIFIC_VALUE'              
,isnull(convert(varchar(100),GROSS_CALORIFIC_valuE_VALUE,0),'')     'GROSS_CALORIFIC_valuE_VALUE'                   
,isnull(INHERENT_MOISTURE,'')              'INHERENT_MOISTURE'          
,isnull(convert(varchar(100),INHERENT_MOISTURE_value ,0),'')        'INHERENT_MOISTURE_value'          
,isnull(INSOLUBLE_RESIDUE,'')               'INSOLUBLE_RESIDUE'         
,isnull(convert(varchar(100),INSOLUBLE_RESIDUE_value,0),'')          'INSOLUBLE_RESIDUE_value'          
,isnull(LOSS_ON_IGINITION,'')               'LOSS_ON_IGINITION'        
,isnull(convert(varchar(100),LOSS_ON_IGINITION_value,0),'')           'LOSS_ON_IGINITION_value'           
,isnull(MAGNISIUM_OXIDE,'')                  'MAGNISIUM_OXIDE'     
,isnull(convert(varchar(100),MAGNISIUM_OXIDE_value,0),'')             'MAGNISIUM_OXIDE_value'           
,isnull(MOISTURE,'')                         'MOISTURE'       
,isnull(convert(varchar(100),MOISTURE_value,0),'')                    'MOISTURE_value'            
,isnull(PHOSPHORUS_PENTOXIDE,'')             'PHOSPHORUS_PENTOXIDE'      
,isnull(convert(varchar(100),PHOSPHORUS_PENTOXIDE_value,0),'')        'PHOSPHORUS_PENTOXIDE_value'            
,isnull(PURITY,'')                           'PURITY'         
,isnull(convert(varchar(100),PURITY_value,0),'')                      'PURITY_value'          
,isnull(SULPHUR ,'')                         'SULPHUR'      
,isnull(convert(varchar(100),SULPHUR_value,0),'')                     'SULPHUR_value'          
,isnull(SILICA_DI_OXIDE,'')                  'SILICA_DI_OXIDE'      
,isnull(convert(varchar(100),SILICA_DI_OXIDE_value ,0),'')            'SILICA_DI_OXIDE_value'         
,isnull(SURFACE_MOISTURE,'')                 'SURFACE_MOISTURE'       
,isnull(convert(varchar(100),SURFACE_MOISTURE_value,0),'')            'SURFACE_MOISTURE_value'          
,isnull(SULPHUR_TRI_OXIDE,'')                'SULPHUR_TRI_OXIDE'        
,isnull(convert(varchar(100),SULPHUR_TRI_OXIDE_value,0),'')           'SULPHUR_TRI_OXIDE_value'       
,isnull(VOLATILE_MATTER,'')                  'VOLATILE_MATTER'     
,isnull(convert(varchar(100),VOLATILE_MATTER_value,0),'')             'VOLATILE_MATTER_value',  
*/
,remarks -- Code added by S.Girish on 24 May 2023 RKILU-254   
,variant_desc --code added by K Vishnupriya for rtrack RMC_INV_106
,Unit_Rate 'Unit Rate' ----Code added By Vasanthi K against id:PJRMC-953 
,Item_Var_Desc,Tare_Wgt,Gross_Wgt,Net_Wgt,UserID   /*Code Added for RPJRB-467*/
/*code added against RPJRB-625 28.04.25 starts*/
,WB_Accepted_Weight	 'WB Accepted Weight'	 
,WB_Deduction		 'WB Deduction'		 
,Adjustment_Quantity 'Adjustment Quantity'
,Adjustment_Value	 'Adjustment Value'	 
/*code added against RPJRB-625 28.04.25 ends*/
from #main_Po_Gr_Dump    
/*where group_desc =isnull(@item_grp_desc,group_desc)    */
where Isnull(group_desc,'') =isnull(@item_grp_desc,Isnull(group_desc,''))    --code aded by suryakala against PJRMC-402 on 21-08-2024
and Item_Account_Group  =isnull(@item_account_grp,Item_Account_Group)   
order by GRN_date desc    

   -- select * from #main_Po_Gr_Dump where po_no='RPUR260124000330'


--where GRN_DATE between '2023-01-01 00:00:00.000' and '2023-03-08 00:00:00.000'    
---where GRN_NO='BNRGRT23/0000032'    
---where GRN_NO='BNRGRT23/0001954'    
--item_flag='Document TCD'    
--and Line_no=2    
--GRN_NO='BNRGRT23/0002148'    

    
    
    
    
    
---where Others is Not null    
    
--select distinct item_code  from ard_item_account_mst    
--where item_code='9880700001'    
/*    
select gr_dtcd_grno,count(gr_dtcd_grno) from gr_dtcd_doctcd    
group by gr_dtcd_grno    
having count(gr_dtcd_grno)>1    
 
select * from gr_dtcd_doctcd    
where gr_dtcd_grno='SDMGRT23/0002634'    
*/    
--rollback Tran    
    
    
    
    
end