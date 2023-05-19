# Get a List of all Primary Keys in a Database

```
SELECT 
    so.name 'Table Name',
    c.name 'Column Name',
    t.Name 'Data type',
    c.max_length 'Max Length',
    c.precision ,
    c.scale ,
    c.is_nullable,
    ISNULL(i.is_primary_key, 0) 'Primary Key'
FROM    
    sys.columns c
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
LEFT OUTER JOIN 
    sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
LEFT OUTER JOIN 
    sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
INNER JOIN 
    sysobjects so ON c.object_id = so.id
WHERE
    i.is_primary_key = 1 and 
    so.xtype = 'U'
Order By 'Table Name', 'Column Name'
```
