/* Invio risultato query direttamente da sql 
si può usare il parametro @query per avere nel corpo direttamente il risultato in formato testo 
si può usare il tag '<pre>' se si usa un formato corpo html per avere la spaziatura fissa del carattere per una migliore leggibilità

MOLTO MEGLIO però usare una tabella html composta direttamente nel corpo!
*/

DECLARE @corpo NVARCHAR(MAX);
SET @corpo = '<H2> Elenco Clienti </H2>' + -- tag per titolo
             '<table style="border-collapse:collapse;" border="1" cellpadding="3">' + -- tag di inizio tabella
             '<tr> <th>Conto</th> <th>descrizione</th> <th>indirizzo</th> </tr>' + -- tag per riga header con i nomi delle colonne
             
			 --query che estrae i dati in formato xml mettendo per ogni riga il tag <tr> riga di tabella, e per ogni campo mette il tag <td> (la cella) e </td> (é il '' tra i campi)
			 --l'istruzione FOR XML PATH capisce che il '' tra i campi é il </td> , il CAST serve per restituire un nvarchar che si unisce al resto della stringa 
             CAST(
(
    SELECT td = an_conto, 
           '', 
           td = an_descr1, 
           '', 
           td = an_indir, 
           ''
    FROM anagra
    WHERE an_tipo = 'C' FOR XML PATH('tr')
) AS NVARCHAR(MAX)) + '</table>';

--esegue la sp che invia l'email con la tabella generata direttamente nel corpo
EXEC msdb.dbo.sp_send_dbmail 
     @profile_name = 'avvisi', 
     @execute_query_database = 'PROVA3', 
     @recipients = 'simo@savell.om', 
     @subject = 'invio email da sp', 
     @body_format = 'HTML', 
     @body = @corpo;

-- @query = @qstring, 
-- @attach_query_result_as_file = 0, 
-- @query_result_separator = '|', 
-- @query_result_no_padding = 0, 
-- @query_result_header = 1, 
-- @query_no_truncate = 0, 
-- @exclude_query_output = 0 
-- @append_query_error = 1
