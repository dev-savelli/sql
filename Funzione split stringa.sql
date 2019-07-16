USE [PROVA3]
GO

/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 12/07/2019 12:28:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* funzionae di tipo tabella che accetta come parametri una stringa e un delimitatore, restituisce una tabella
con le colonne ID, Dati dove in dati ci sono i pezzi splittati dal delimitatore
Es. SELECT * FROM dbo.split('primo_secondo_terzo' , '_') 
*/

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

