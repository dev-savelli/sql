### Invio email con risultati query direttamente da sql.
Va configurato prima un profilo email (da management studio si puo fare) e poi una sp specifica permette l'invio.

Nota: specificare sempre @execute_query_database = 'nome del db' se si vuole compreneder il risultato di una query con il parametro @query
Seguire questo link per i dettagli: 

https://docs.microsoft.com/it-it/sql/relational-databases/system-stored-procedures/sp-send-dbmail-transact-sql?view=sql-server-2017
