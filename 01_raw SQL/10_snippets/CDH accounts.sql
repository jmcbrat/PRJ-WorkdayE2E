/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [PY_CDH_NO]
      ,[PY_CDH_CD]
      ,[PY_CDH_TITLE]
      ,[PY_CDH_MISC_CD01]
      ,[PY_CDH_MISC_CD02]
      ,[PY_CDH_MISC_CD03]
      ,[PY_CDH_MISC_CD04]
      ,[PY_CDH_MISC_CD05]
      ,[PY_CDH_MISC_CD06]
      ,[PY_CDH_MISC_CD07]
      ,[PY_CDH_MISC_CD08]
      ,[PY_CDH_REL_CD01]
      ,[PY_CDH_REL_CD02]
      ,[PY_CDH_REL_CD03]
      ,[PY_CDH_REL_CD04]
      ,[PY_CDH_REL_CD05]
      ,[PY_CDH_REL_CD06]
      ,[PY_CDH_REL_CD07]
      ,[PY_CDH_REL_CD08]
      ,[PY_CDH_XTD]
      ,[PY_CDH_BEG]
      ,[PY_CDH_END]
      ,[PY_HR_M_EXT]
      ,[PY_HR_D_EXT]
      ,[UNIQUE_KEY]
      ,[CREATE_WHO]
      ,[CREATE_WHEN]
      ,[UPDATE_WHO]
      ,[UPDATE_WHEN]
      ,[unique_id]
      ,[py_cdh_mask]
  FROM [production_finance].[dbo].[py_cdh_mstr]
  where py_cdh_no in ('2980','2319','2349','2465','2463')