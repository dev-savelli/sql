
/* Invio risultato query direttamente da sql 
si può usare il parametro @query per avere nel corpo direttamente il risultato in formato testo 
si può usare il tag '<pre>' se si usa un formato corpo html per avere la spaziatura fissa del carattere per una migliore leggibilità

MOLTO MEGLIO però usare una tabella html composta direttamente nel corpo!
Si usa la select con la direttiva FOR XML PATH che converte l'output in xml i cui tag per riga possono essere sostituiti con il tag <tr> (riga tabella html)
*/

DECLARE @corpo NVARCHAR(MAX);
-- compone l'html del titolo, la tabella, la riga con l'header della tabella con il nome delle colonne
SET @corpo = '<H2> Situazione magazzino </H2>  
             <table style="border-collapse:collapse;" border="1" cellpadding="3">  
             <tr>
			 <th style="background-color:lavender;">Articolo</th>  
			 <th style="background-color:lavender;">Descrizione</th>
			 <th style="background-color:lavender;">UM</th>
			 <th style="background-color:yellow;">Esistenza</th>
			 <th style="background-color:lavender;">Ordinato</th>
			 <th style="background-color:lavender;">Impegnato</th>
			 </tr>' + -- unisce alla stringa il risultato della query che estrae i dati in formato xml 
             -- mettendo per ogni riga il tag <tr> riga di tabella, e per ogni campo mette il tag <td> (la cella) 
             -- l'istruzione FOR XML PATH capisce che il '' tra i campi é il </td> , il CAST serve per assicurare un nvarchar che si unisce al resto della stringa 
             CAST(
(
    SELECT artico.ar_codart AS td, 
           '', 
           artico.ar_descr AS td, 
           '', 
           artico.ar_unmis AS td, 
           '', 
           format(artprox.apx_esist, '#.##') AS td, 
           '', 
           format(artprox.apx_ordin, '#.##') AS td, 
           '', 
           format(artprox.apx_impeg, '#.##') AS td, 
           ''
    FROM artico
         INNER JOIN artprox ON artico.ar_codart = artprox.apx_codart
                               AND artico.codditt = artprox.codditt
    WHERE apx_esist > 0
          AND apx_ordin > 0
    ORDER BY artico.ar_codart FOR XML PATH('tr')
) AS NVARCHAR(MAX)) + '</table>'; --chiude il tag della tabella
--PRINT @corpo;
--esegue la sp che invia l'email con la tabella generata direttamente nel corpo
EXEC msdb.dbo.sp_send_dbmail 
     @profile_name = 'avvisi', 
     @execute_query_database = 'PROVA3', 
     @recipients = 'indir@indir.com', 
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
