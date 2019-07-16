USE [PROVA3]
GO

/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 12/07/2019 12:28:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[Split]
(
@String NVARCHAR(4000),
@Delimiter NCHAR(1)
)
RETURNS TABLE 
AS
RETURN 
(
WITH Split(stpos,endpos) 
AS(
SELECT 0 AS stpos, CHARINDEX(@Delimiter,@String) AS endpos
UNION ALL
SELECT endpos+1, CHARINDEX(@Delimiter,@String,endpos+1)
FROM Split
WHERE endpos > 0
)
SELECT 'id' = ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
'dati' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String)+1)-stpos)
FROM Split
)
GO

