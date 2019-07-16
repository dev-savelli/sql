USE [IGUS2015]
GO

/****** Object:  UserDefinedFunction [dbo].[SAVLeggiRegistro]    Script Date: 13/05/2019 10:58:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Maxone
-- Create date: 13/05/2019
-- Description:	Cerca chiave registro di Business con possibilità di passare anche un default in caso non la trovasse
-- =============================================
CREATE FUNCTION [dbo].[SAVFLeggiRegistro] 
(
	-- Add the parameters for the function here
	@liv1 varchar(max),
	@liv2 varchar(max),
	@liv3 varchar(max),
	@nomprop varchar(max),
	@default varchar(max)=' '
)
RETURNS varchar(max)
AS
BEGIN

	-- Add the T-SQL statements to compute the return value here
return	isnull((Select rp_valprop from arcproc.dbo.regprop 
	where
	 upper(rp_liv1)=upper(@liv1) and upper(rp_liv2)=upper(@liv2) and upper(rp_liv3)=upper(@liv3) and upper(rp_nomprop)= upper(@nomprop)),@default)

END
GO


