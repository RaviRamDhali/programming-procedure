## Maintenance command that updates all table and index statistics in the current database

```
SELECT  
    t.name AS [TableName],
    s.name AS [StatisticName],
    STATS_DATE(s.object_id, s.stats_id) AS [LastUpdated],
    sp.rows AS [RowCount]
FROM sys.stats AS s
INNER JOIN sys.objects AS t 
    ON s.object_id = t.object_id
INNER JOIN sys.partitions AS sp 
    ON t.object_id = sp.object_id 
    AND sp.index_id IN (0,1)
WHERE t.type = 'U'  -- only user tables
GROUP BY t.name, s.name, STATS_DATE(s.object_id, s.stats_id), sp.rows
ORDER BY [LastUpdated] ASC, t.name;
```
## RUN

```EXEC sp_updatestats;```
