
--SELECT * FROM AZ001LISTINI 
--SELECT * FROM AZ001LIS_TINI 
--SELECT * FROM AZ001LIS_scag
-- usare an_siglaric per collegare il conto al codice del listino
--crea una temporanea con i validi
WITH tmp
     AS (SELECT TOP 100 PERCENT AZ001LISTINI.LSCODLIS, 
                                AZ001LISTINI.LSDESLIS, 
                                AZ001LIS_SCAG.LICODART, 
                                AZ001LIS_SCAG.LIQUANTI, 
                                AZ001LIS_SCAG.LIPREZZO, 
                                lidatatt
         FROM AZ001LIS_SCAG
              INNER JOIN AZ001LIS_TINI ON AZ001LIS_SCAG.LICODART = AZ001LIS_TINI.LICODART
                                          AND AZ001LIS_SCAG.LIROWNUM = AZ001LIS_TINI.CPROWNUM
              INNER JOIN AZ001LISTINI ON AZ001LIS_TINI.LICODLIS = AZ001LISTINI.LSCODLIS
         WHERE lidatatt <= GETDATE()
               AND lidatdis >= GETDATE()
         ORDER BY AZ001LISTINI.LSCODLIS, 
                  AZ001LIS_SCAG.LICODART, 
                  AZ001LIS_SCAG.LIQUANTI

         --esegue il rank per estrarre quelli con data ultima, cerca le quantita finali e alla fine imposta la quantità finale 999999999
         ),
     tmp2
     AS (SELECT TOP 100 PERCENT LSCODLIS, 
                                lsdeslis, 
                                LICODART, 
                                liprezzo, 
                                LIQUANTI,
                                CASE(LEAD(liquanti, 1, 0) OVER(
                                ORDER BY LSCODLIS, 
                                         LICODART, 
                                         LIQUANTI))
                                    WHEN 0
                                    THEN 0
                                    ELSE(LEAD(liquanti, 1, 0) OVER(
                                        ORDER BY LSCODLIS, 
                                                 LICODART, 
                                                 LIQUANTI)) - 1
                                END liquantf, 
                                lidatatt
         FROM
         (
             SELECT *, 
                    RANK() OVER(PARTITION BY lscodlis, 
                                             licodart, 
                                             liquanti
                    ORDER BY lidatatt DESC) n
             FROM tmp
         ) m
         WHERE n = 1
         ORDER BY LSCODLIS, 
                  LICODART, 
                  LIQUANTI)
     SELECT LSCODLIS, 
            LSDESLIS, 
            LICODART, 
            LIPREZZO, 
            LIQUANTI,
            CASE
                WHEN(liquanti > 0
                     AND liquantf = 0)
                THEN 999999999
                ELSE liquantf
            END AS quantf, 
            lidatatt
     FROM tmp2
     ORDER BY LSCODLIS, 
              LICODART, 
              LIQUANTI;
