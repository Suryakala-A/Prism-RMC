/*$File_version=ms4.3.0.04$*/
/* VERSION NO: PPS4.1.0.002 */  
/********************************************************************************/
/* Procedure    : sopp_hso_sp_serch_ml                                          */
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
/* Author       : Aswani K                                                      */
/* Date         : 08/Dec/2005                                                   */
/********************************************************************************/
/* Modification history                                                         */
/********************************************************************************/
/* Modified by  :                                                               */
/* Date         :                                                               */
/* Description  :                                                               */
/********************************************************************************/
-- grant exec on sopp_hso_sp_serch_ml to public
/*Modified by		Date				Remarks		*/
/*Geetha.S		7/11/2006				PPSCMQSOPPS41_000082		*/
/*Indu Ram     		05/Oct/2006  			PPSCMQSOPPS41_000094	*/
/*Anitha N     		18/sep/2007  			NSODMS412AT_000531	   */
/*Sejal N. Khimani	12 Jan 2010				Es_General_00091       */
/*Pandiarajan E		06 04  2015				ES_NSO_00924			*/
/* Sheerapthi KR	22/07/2024				EPE-84825				*/
/*suryakala A       22-01-2025       CU Merging-PJRMC-1252 */
/******************************************************************************************/
create   procedure sopp_hso_sp_serch_ml
	@ctxt_language                                              udd_Ctxt_Language,  --Input 
	@ctxt_ouinstance                                            udd_ctxt_OUInstance,  --Input 
	@ctxt_service                                               udd_Ctxt_Service,  --Input 
	@ctxt_user                                                  udd_ctxt_User,  --Input 
	@cucode                                                     udd_document,  --Input 
	@cuname                                                     udd_NAme,  --Input 
	@docnofr                                                    udd_document,  --Input 
	@docnoto                                                    udd_document,  --Input 
	@docdtfr                                                    udd_date,  --Input 
	@docdtto                                                    udd_date,  --Input 
	@docstatus                                                  udd_document,  --Input 
	@ordpoint                                                   udd_document,  --Input 
	@prodtfr                                                    udd_date,  --Input 
	@prodtto                                                    udd_date,  --Input 
	@schdtfr                                                    udd_date,  --Input 
	@schdtto                                                    udd_date,  --Input 
	@sourcedoc                                                  udd_desc40,  --Input 
	@docstatus_hdn                                   udd_document,  --Input 
	@ouinstid        udd_document,  --Input 
	@m_errorid                                    int output --To Return Execution Status 
	,@hdn_trantype    		udd_transactiontype			=	NULL --Code added for EPE-84825 

as
Begin
	-- nocount should be switched on to prevent phantom rows
	set nocount on
	
	-- @m_errorid should be 0 to Indicate Success
	select @m_errorid = 0
	
	--declaration of temporary variables
		
	--temporary and formal parameters mapping
	select @ctxt_service             = ltrim(rtrim(@ctxt_service))
	select @ctxt_user                = ltrim(rtrim(@ctxt_user))
	select @cucode                   = ltrim(rtrim(@cucode))
	select @cuname                   = ltrim(rtrim(@cuname))
	select @docnofr                  = ltrim(rtrim(@docnofr))
	select @docnoto                  = ltrim(rtrim(@docnoto))
	select @docstatus                = ltrim(rtrim(@docstatus))
	select @ordpoint                 = ltrim(rtrim(@ordpoint))
	select @sourcedoc                = ltrim(rtrim(@sourcedoc))
	select @docstatus_hdn            = ltrim(rtrim(@docstatus_hdn))
	select @ouinstid                 = ltrim(rtrim(@ouinstid))
	Select @hdn_trantype			 = ltrim(rtrim(@hdn_trantype))	--Code added for EPE-84825 

		
	--null checking
	IF @ctxt_language = -915
		select @ctxt_language = null  

	IF @ctxt_ouinstance = -915
		select @ctxt_ouinstance = null

     select @ctxt_service = ltrim(rtrim(@ctxt_service))  
	IF @ctxt_service = '~#~'
		select @ctxt_service = null 

     select @ctxt_user = ltrim(rtrim(@ctxt_user)) 
	IF @ctxt_user = '~#~'
		select @ctxt_user = null

     select @cucode = upper(ltrim(rtrim(@cucode)))  
	IF @cucode = '~#~'
		select @cucode = null 

     select @cuname = upper(ltrim(rtrim(@cuname)))   
	IF @cuname = '~#~'
		select @cuname = null

     select @docnofr = upper(ltrim(rtrim(@docnofr)))    
	IF @docnofr = '~#~'
		select @docnofr = null  

     select @docnoto = upper(ltrim(rtrim(@docnoto)))  
	IF @docnoto = '~#~'
		select @docnoto = null 
 
	IF @docdtfr = '01/01/1900' 
		select @docdtfr = null 
 
	IF @docdtto = '01/01/1900' 
		select @docdtto = null  

     select @docstatus = upper(ltrim(rtrim(@docstatus)))  
	IF @docstatus = '~#~'
		select @docstatus = null  

     select @ordpoint = upper(ltrim(rtrim(@ordpoint)))  
	IF @ordpoint = '~#~'
		select @ordpoint = null
  
	IF @prodtfr = '01/01/1900' 
		select @prodtfr = null  

	IF @prodtto = '01/01/1900' 
		select @prodtto = null  

	IF @schdtfr = '01/01/1900' 
		select @schdtfr = null 
 
	IF @schdtto = '01/01/1900' 
		select @schdtto = null  

     select @sourcedoc = upper(ltrim(rtrim(@sourcedoc)))  
	IF @sourcedoc = '~#~'
		select @sourcedoc = null 

     select @docstatus_hdn = upper(ltrim(rtrim(@docstatus_hdn)))   
     if @docstatus_hdn = '~#~' or @docstatus_hdn = '' or @docstatus_hdn is null   
          select @docstatus_hdn = '%'  

	IF @ouinstid = -915
		select @ouinstid = null  

	/*Code added for EPE-84825 begins */
	
	IF @hdn_trantype = '~#~' 
		Select @hdn_trantype = null 
		
	/*Code added for EPE-84825 Ends */
	

	declare	@lo		udd_loid      
     	declare	@bu		udd_buid      
     	declare	@return_val   	int 
	declare @guid_tmp	udd_guid
	declare @sourcedoc_code   udd_desc40


     	select	@return_val = 0
	select @guid_tmp = newid()


	declare @getdate_tmp udd_date
        select  @getdate_tmp = convert(datetime,convert(nvarchar(10),dbo.RES_Getdate(@ctxt_ouinstance),120),120)



	declare @feature_flag_yes_no udd_yesnoflag
	 declare @max_record_count udd_lineno 	
	 declare @result_count     udd_lineno


	 select @feature_flag_yes_no = flag_yes_no,
	 	@max_record_count   = max_record_count
	 	 from pps_feature_list (nolock)
	where feature_id = 'PPS_SOHELP_011' and component_name = 'NSO'
			
	if isnull(@feature_flag_yes_no,'') = ''
		select @feature_flag_yes_no = 'NO'
	
	if @feature_flag_yes_no = 'YES'
	begin

 		if isnull(replace(@cucode,'*','%'),'%')='%'
 		and isnull(replace(@cuname,'*','%'),'%')='%'

		begin
/* Starts - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
   --raiserror('Please Enter Customer Code or Customer Name for search criteria',16,1)
                        select @m_errorid = 3752543
/* Ends - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
			return
		end
	end

	select	@cuname			=	replace(@cuname,'*','%')
	select	@docnofr		=	replace(@docnofr,'*','%')
	select	@docnoto		=	replace(@docnoto,'*','%')
	select	@docstatus		=	replace(@docstatus,'*','%')
	select	@docnoto		=	replace(@docnoto,'*','%')
	select	@ordpoint		=	replace(@ordpoint,'*','%')
	select	@cucode			=	replace(@cucode,'*','%')
	select	@docstatus_hdn		=	replace(@docstatus_hdn,'*','%')

	if @cucode is null
		select @cucode = '%'

	if @cuname is null
		select @cuname = '%'

	if @docstatus is null
		select @docstatus = '%'

	if @ordpoint is null
     select @ordpoint = null--'%'        --/* Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/

	if @docnofr is null
		select @docnofr = '!'
	
	if @docnoto is null
		select @docnoto = null--ES_General_00091

	if @docdtfr is null
		select @docdtfr = '01/01/1900'

	select @docdtfr  = convert(nvarchar(10),@docdtfr,120)

	if @docdtto is null
		select @docdtto = '01/01/9900'

	if @prodtfr is null
		select @prodtfr = '01/01/1900'

	if @prodtto is null
		select @prodtto = '01/01/9900'

	if @schdtfr is null
		select @schdtfr	 = '01/01/1900'

	if @schdtto is null
		select @schdtto = '01/01/9900'

	if @sourcedoc is null
	begin
/* Starts - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
                --raiserror('Sourcedoc cannot be Null',16,1)
                select @m_errorid = 3752544
/* Ends - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
	end
		
	declare @quo_ouid   udd_ctxt_OUInstance	
   ,@ordpoint1 udd_ctxt_OUInstance      /*  Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/



	/* Getting our LO and BU */
	exec scm_get_emod_details	@ctxt_ouinstance ,
					@getdate_tmp ,
					@lo output,
					@bu output, 
					@return_val output
	
	/* OU Instance is invalid for the Tran Date */
	if @return_val<>0 
	begin
		select @m_errorid = @return_val
		return
	end


	select 	@quo_ouid = destinationouinstid
	from  	fw_admin_view_comp_intxn_model  (nolock)
	where 	sourcecomponentname    	= 'NSO'
	and   	sourceouinstid         	= @ctxt_ouinstance 
	and   	destinationcomponentname= 'QUOTATION'

	/* Begins - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/
  select @ordpoint1=ou_id      
  from emod_ou_mst_vw(nolock)      
  where ouinstname=@ordpoint      
      
      
 select destinationouinstid 'quo_ouid'into  #temp      
 from   fw_admin_view_comp_intxn_model  (nolock)        
 where  sourcecomponentname     = 'NSO'        
 and    sourceouinstid          = @ctxt_ouinstance         
 and  destinationcomponentname= 'NSO'      
 /* Ends - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/     
	select	@sourcedoc_code = paramcode
	from 	so_comp_metadata_vw  (nolock)
	where 	componentname 	= 	'NSO'
	and	paramcategory	=	'COMBO'
	and	paramtype	=	'SO_REF_DOC'	
	and	paramdesc	=	@sourcedoc
	and	langid		=	@ctxt_language


	/*Code modified by Indu for PPSCMQSOPPS41_000094 on 05/Oct/2006 Begins*/	
	--if(@sourcedoc_code = 'NSO')--code commended  for ES_NSO_00924
	if(@sourcedoc_code in ( 'NSO','CON'))--code added  for ES_NSO_00924
	begin
		select	@docstatus_hdn = paramcode
		from 	component_metadata_table  (nolock)
		where 	componentname 	= 	'NSO'
		and   	paramcategory 	= 	'STATUS'
		and   	paramtype 	= 	'SO_STATUS'
		and	paramdesc	=	@docstatus
		and	langid		=	@ctxt_language
	end
	else
	begin
		select	@docstatus_hdn = paramcode
		from 	component_metadata_table  (nolock)
		where 	componentname 	= 	@sourcedoc
		and	paramcategory	=	'COMBO'
		and	paramtype	=	'STATUS'	
		and	paramdesc	=	@docstatus
		and	langid		=	@ctxt_language
	end
	/*Code modified by Indu for PPSCMQSOPPS41_000094 on 05/Oct/2006 Ends*/


	if ltrim(rtrim(@sourcedoc_code)) in ('NSO','TEMP') --NSODMS412AT_000531

	begin

	insert into so_search_tmp
	(	
	sosrc_guid,sosrc_order_ou,sosrc_order_no,sosrc_order_date,sosrc_prm_date_dflt,
	sosrc_ship_to_cust_dflt,sosrc_shipto_cust_name_dflt,sosrc_sch_date_dflt
	)
	select distinct
	@guid_tmp,@ctxt_ouinstance,sohdr_order_no,sohdr_order_date,sohdr_prm_date_dflt,
	sohdr_shiptocust_dflt,clo_cust_name,sodtl_to_ship_date_dflt
	from 	cust_lo_info_vw			cust	(nolock),
		so_order_hdr			hdr	(nolock)
	left 	outer join
		so_order_item_dtl		item	(nolock)
	on	hdr.sohdr_ou			=	item.sodtl_ou
	and	hdr.sohdr_order_no		=	item.sodtl_order_no
	where	hdr.sohdr_ou			=	@ctxt_ouinstance
	and	cust.clo_lo			= 	@lo
	and	cust.clo_cust_code		=	hdr.sohdr_order_from_cust
  	and	hdr.sohdr_order_status		like	rtrim(@docstatus_hdn)
--   	and	hdr.sohdr_order_no		between	rtrim(@docnofr) and rtrim(@docnoto)
   	and	hdr.sohdr_order_no		between	isnull(@docnofr,hdr.sohdr_order_no) and isnull(@docnoto,hdr.sohdr_order_no)--ES_General_00091
  	and	cust.clo_cust_code		like	rtrim(@cucode)
  	and	cust.clo_cust_name_shd		like	rtrim(@cuname)
  	and	hdr.sohdr_order_date		between	convert(nvarchar(10),@docdtfr,120) and convert(nvarchar(10),@docdtto,120)
-- 	and	hdr.sohdr_prm_date_dflt		between convert(nvarchar(10),@prodtfr,120) and convert(nvarchar(10),@prodtto,120)
 	and	isnull(hdr.sohdr_prm_date_dflt,convert(nvarchar(10),@prodtfr,120)) >= convert(nvarchar(10),@prodtfr,120)
	and 	isnull(hdr.sohdr_prm_date_dflt,convert(nvarchar(10),@prodtto,120)) <= convert(nvarchar(10),@prodtto,120)
 	and 	item.sodtl_to_ship_date_dflt	between	convert(nvarchar(10),@schdtfr,120) and convert(nvarchar(10),@schdtto,120)
	and	ltrim(rtrim(str(hdr.sohdr_ou)))	like	isnull(ltrim(rtrim(str(@ouinstid))),'%')			
	AND	sohdr_order_type 		= @sourcedoc_code --NSODMS412AT_000531

	if @feature_flag_yes_no = 'YES'
	begin
	        if isnull(@max_record_count,0) > 0
	     	begin
			select  @result_count	= count('x') 	
			from 	so_search_tmp			src	(nolock)
			where	sosrc_guid			= 	@guid_tmp
			and	src.sosrc_order_ou		=	@ctxt_ouinstance
		end

		if isnull(@result_count,0) > isnull(@max_record_count,0)
		begin	
/* Starts - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
                        --raiserror('Redefine Search Criteria',16,1)
                        select @m_errorid = 3752545
/* Ends - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
			return
		end
	end


	SELECT sosrc_order_no 			'CU_CODE', 
	sosrc_shipto_cust_name_dflt 		'CU_NAME', 
	sosrc_ship_to_cust_dflt 		'DOCNO', 
	sosrc_prm_date_dflt 			'DOCDT', 
	sosrc_sch_date_dflt 			'SCHDT', 
	sosrc_order_date 			'PRODT' 
	from 	so_search_tmp			src	(nolock)
 	where	sosrc_guid			= 	@guid_tmp
 	and	src.sosrc_order_ou		=	@ctxt_ouinstance
	end


	if ltrim(rtrim(@sourcedoc_code))='QUO'

	begin


	insert into so_search_tmp
	(
	sosrc_guid,sosrc_order_ou,sosrc_order_no,sosrc_order_date,sosrc_prm_date_dflt,
	sosrc_ship_to_cust_dflt,sosrc_shipto_cust_name_dflt,sosrc_sch_date_dflt
	)

	select distinct
	@guid_tmp,@quo_ouid,qhdr_quotnumber,qhdr_date,qsch_promised_date,
	qhdr_customercode,clo_cust_name,qsch_sch_date
	from 	cust_lo_info_vw			cust	(nolock),
		qtn_quotation_hdr_Vw			hdr	(nolock)
	left 	outer join
		qtn_sch_dtl_Vw				item	(nolock)
	on	hdr.qhdr_ouinstance		=	item.qsch_ou
	and	hdr.qhdr_quotnumber		=	item.qsch_qtn_no
	where	hdr.qhdr_ouinstance		=	@quo_ouid
	and	cust.clo_lo			= 	@lo
	and	cust.clo_cust_code		=	hdr.qhdr_customercode
  	and	hdr.qhdr_status			like	rtrim(@docstatus_hdn)
  --	and	hdr.qhdr_quotnumber		between	rtrim(@docnofr) and rtrim(@docnoto)
   	and	hdr.qhdr_quotnumber		between	isnull(@docnofr,hdr.qhdr_quotnumber) and isnull(@docnoto,hdr.qhdr_quotnumber)--ES_General_00091
 	and	cust.clo_cust_code		like	rtrim(@cucode)
 	and	cust.clo_cust_name_shd		like	rtrim(@cuname)
 	and	hdr.qhdr_date			between	convert(nvarchar(10),@docdtfr,120) and convert(nvarchar(10),@docdtto,120)
 	and	isnull(item.qsch_promised_date,convert(nvarchar(10),@prodtfr,120)) >= convert(nvarchar(10),@prodtfr,120)
	and 	isnull(item.qsch_promised_date,convert(nvarchar(10),@prodtto,120)) <= convert(nvarchar(10),@prodtto,120)
  	and	isnull(item.qsch_sch_date,convert(nvarchar(10),@schdtfr,120)) >= convert(nvarchar(10),@schdtfr,120)
 	and 	isnull(item.qsch_sch_date,convert(nvarchar(10),@schdtto,120)) <= convert(nvarchar(10),@schdtto	,120)
	--and 	item.qsch_sch_date		between	convert(nvarchar(10),@schdtfr,120) and convert(nvarchar(10),@schdtto,120)
 	and	ltrim(rtrim(str(hdr.qhdr_ouinstance)))	like	isnull(ltrim(rtrim(str(@ouinstid))),'%')



	if @feature_flag_yes_no = 'YES'
	begin
	        if isnull(@max_record_count,0) > 0
	     	begin
			select  @result_count	= count('x') 	
			from 	so_search_tmp			src	(nolock)
			where	sosrc_guid			= 	@guid_tmp
			and	src.sosrc_order_ou		=	@quo_ouid
		end

		if isnull(@result_count,0) > isnull(@max_record_count,0)
		begin	
/* Starts - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
           --raiserror('Redefine Search Criteria',16,1)
                        select @m_errorid = 3752545
/* Ends - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
			return
		end
	end





	SELECT sosrc_order_no 			'CU_CODE', 
	sosrc_shipto_cust_name_dflt 		'CU_NAME', 
	sosrc_ship_to_cust_dflt 		'DOCNO', 
	sosrc_prm_date_dflt 			'DOCDT', 
	sosrc_sch_date_dflt 			'SCHDT', 
	sosrc_order_date 			'PRODT' 
	from 	so_search_tmp			src	(nolock)
 	where	sosrc_guid			= 	@guid_tmp
 	and	src.sosrc_order_ou		=	@ctxt_ouinstance


	end
--Added for NSODMS412AT_000531 begins
declare @FLAG_YES_NO udd_yesnoflag--code added  for ES_NSO_00924
	if ltrim(rtrim(@sourcedoc_code))='CON'

	begin
		--code added  for  ES_NSO_00924 begin here 
			select	@FLAG_YES_NO	= FLAG_YES_NO
			from	pps_feature_list (nolock)
			where	FEATURE_ID		='PPS_FID_00214'		
			
		--code added  for  ES_NSO_00924 ends here

	/* Code added for EPE-84825 begins */
	IF @hdn_trantype	=	'SAL_EXPQSO'
	BEGIN
		insert into so_search_tmp
		(
			sosrc_guid,						sosrc_order_ou,						sosrc_order_no,				
			sosrc_order_date,				sosrc_prm_date_dflt,				sosrc_ship_to_cust_dflt	,
			sosrc_shipto_cust_name_dflt,	sosrc_sch_date_dflt
		)
		select distinct
			@guid_tmp,						@quo_ouid,							conhdr_contract_no,
			conhdr_contract_date,			bsosch_prm_date,					conhdr_order_from_cust,
			clo_cust_name,					bsosch_req_date
		from 	cust_lo_info_vw	cust	(nolock),
				so_contract_hdr	hdr	(nolock)
		left	outer	join	so_blanket_sch_dtl	item	(nolock)
		on	hdr.conhdr_ou				=	item.bsosch_ou
		and	hdr.conhdr_contract_no		=	item.bsosch_contract_no
		where	hdr.conhdr_ou			=	@quo_ouid
		and	cust.clo_lo					= 	@lo
		and	cust.clo_cust_code			=	hdr.conhdr_order_from_cust
  		and	hdr.conhdr_status			like	rtrim(@docstatus_hdn)
  		and	hdr.conhdr_contract_no		between	isnull(@docnofr,hdr.conhdr_contract_no) and isnull(@docnoto,hdr.conhdr_contract_no) 
 		and	cust.clo_cust_code			like	rtrim(@cucode)
 		and	cust.clo_cust_name_shd		like	rtrim(@cuname)
 		and	hdr.conhdr_contract_date			between	convert(nvarchar(10),@docdtfr,120) and convert(nvarchar(10),@docdtto,120)
 		and	isnull(item.bsosch_prm_date,convert(nvarchar(10),@prodtfr,120)) >= convert(nvarchar(10),@prodtfr,120)
		and 	isnull(item.bsosch_prm_date,convert(nvarchar(10),@prodtto,120)) <= convert(nvarchar(10),@prodtto,120)
  		and	isnull(item.bsosch_req_date,convert(nvarchar(10),@schdtfr,120)) >= convert(nvarchar(10),@schdtfr,120)
 		and 	isnull(item.bsosch_req_date,convert(nvarchar(10),@schdtto,120)) <= convert(nvarchar(10),@schdtto	,120)
  		and	ltrim(rtrim(str(hdr.conhdr_ou)))	like	isnull(ltrim(rtrim(str(@ouinstid))),'%')
  		and ( case  when @FLAG_YES_NO = 'YES' then  hdr.conhdr_status  else '1' end ) <> ( case  when @FLAG_YES_NO = 'YES' then  'SC'  else '0' end ) 
		and		conhdr_status			=	'AU'
		and		conhdr_contract_type	=	'BSO'
	END
	ELSE
	BEGIN
	/* Code added for EPE-84825 Ends */
		insert into so_search_tmp
		(
		sosrc_guid,sosrc_order_ou,sosrc_order_no,sosrc_order_date,sosrc_prm_date_dflt,
		sosrc_ship_to_cust_dflt,sosrc_shipto_cust_name_dflt,sosrc_sch_date_dflt
		)
		select distinct
		@guid_tmp,@quo_ouid,conhdr_contract_no,conhdr_contract_date,bsosch_prm_date,
		conhdr_order_from_cust,clo_cust_name,bsosch_req_date
		from 	cust_lo_info_vw			cust	(nolock),
			so_contract_hdr			hdr	(nolock)
		left 	outer join
			so_blanket_sch_dtl		item	(nolock)
		on	hdr.conhdr_ou		=	item.bsosch_ou
		and	hdr.conhdr_contract_no		=	item.bsosch_contract_no
             /* Begins - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/
 		where --hdr.conhdr_ou  = @quo_ouid        
 		bsosch_ship_point =isnull(@ordpoint1,bsosch_ship_point)       
 		and hdr.conhdr_ou    in( select destinationouinstid      
             	from  fw_admin_view_comp_intxn_model        
             	where sourcecomponentname     = 'NSO'      
             	and   sourceouinstid          = @ctxt_ouinstance      
             	and   destinationcomponentname  = 'nso') 
	     /* ends - Code added / Commented /Modified against rTrack ID : CU Merging-PJRMC-1252*/     
		and	cust.clo_lo			= 	@lo
		and	cust.clo_cust_code		=	hdr.conhdr_order_from_cust
  		and	hdr.conhdr_status			like	rtrim(@docstatus_hdn)
	 -- 	and	hdr.conhdr_contract_no		between	rtrim(@docnofr) and rtrim(@docnoto)
 		and	hdr.conhdr_contract_no		between	isnull(@docnofr,hdr.conhdr_contract_no) and isnull(@docnoto,hdr.conhdr_contract_no)--ES_General_00091
 		and	cust.clo_cust_code		like	rtrim(@cucode)
 		and	cust.clo_cust_name_shd		like	rtrim(@cuname)
 		and	hdr.conhdr_contract_date			between	convert(nvarchar(10),@docdtfr,120) and convert(nvarchar(10),@docdtto,120)
 		and	isnull(item.bsosch_prm_date,convert(nvarchar(10),@prodtfr,120)) >= convert(nvarchar(10),@prodtfr,120)
		and 	isnull(item.bsosch_prm_date,convert(nvarchar(10),@prodtto,120)) <= convert(nvarchar(10),@prodtto,120)
  		and	isnull(item.bsosch_req_date,convert(nvarchar(10),@schdtfr,120)) >= convert(nvarchar(10),@schdtfr,120)
 		and 	isnull(item.bsosch_req_date,convert(nvarchar(10),@schdtto,120)) <= convert(nvarchar(10),@schdtto	,120)
		--and 	item.qsch_sch_date		between	convert(nvarchar(10),@schdtfr,120) and convert(nvarchar(10),@schdtto,120)
 		and	ltrim(rtrim(str(hdr.conhdr_ou)))	like	isnull(ltrim(rtrim(str(@ouinstid))),'%')
  		and ( case  when @FLAG_YES_NO = 'YES' then  hdr.conhdr_status  else '1' end ) <> ( case  when @FLAG_YES_NO = 'YES' then  'SC'  else '0' end )--code added  for 	ES_NSO_00924
	END	--Code added for EPE-84825

	if @feature_flag_yes_no = 'YES'
	begin
	        if isnull(@max_record_count,0) > 0
	     	begin
			select  @result_count	= count('x') 	
			from 	so_search_tmp			src	(nolock)
			where	sosrc_guid			= 	@guid_tmp
			and	src.sosrc_order_ou		=	@quo_ouid
		end

		if isnull(@result_count,0) > isnull(@max_record_count,0)
		begin	
/* Starts - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
                        --raiserror('Redefine Search Criteria',16,1)
               select @m_errorid = 3752545
/* Ends - Code modified by Geetha.S for bug id : PPSCMQSOPPS41_000082 */
			return
		end
	end





	SELECT sosrc_order_no 			'CU_CODE', 
	sosrc_shipto_cust_name_dflt 		'CU_NAME', 
	sosrc_ship_to_cust_dflt 		'DOCNO', 
	sosrc_prm_date_dflt 			'DOCDT', 
	sosrc_sch_date_dflt 			'SCHDT', 
	sosrc_order_date 			'PRODT' 
	from 	so_search_tmp			src	(nolock)
 	where	sosrc_guid			= 	@guid_tmp
 	and	src.sosrc_order_ou		=	@ctxt_ouinstance


	end
--Added for NSODMS412AT_000531 ends
	delete from so_search_tmp 
	where sosrc_guid = @guid_tmp 




/* 
	--OuputList
	Select null 'cu_code', 
	null 'cu_name', 
	null 'docno', 
	null 'docdt', 
	null 'schdt', 
	null 'prodt' from *** 
*/
	
	set nocount off
End













 


