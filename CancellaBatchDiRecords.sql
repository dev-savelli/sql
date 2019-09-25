--SELECT *
--FROM #deltest

--CREATE TABLE #DelTest (ID INT IDENTITY, name NVARCHAR(128));
--INSERT INTO #DelTest (name) SELECT name FROM sys.objects;

--cancella batch di record (per tabelle grandi

DECLARE @Numero INT;
DECLARE @Cancellate INT;
DECLARE @totali int
DECLARE @contacancellate int

SET @totali=(SELECT count(*) FROM #deltest)
SET @Numero = 100; --Numero record del batch
SET @Cancellate = 1;
SET @contacancellate=0


WHILE @Cancellate > 0
    BEGIN
        DELETE TOP (@Numero)
        FROM #deltest;

        SET @Cancellate = @@ROWCOUNT;
		SET @contacancellate=@contacancellate+@cancellate
		PRINT convert(varchar(max),@contacancellate) + ' / ' + convert(varchar(max),@totali)
    END;