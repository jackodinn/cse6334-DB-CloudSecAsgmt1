SELECT 
    StartTime,
    LoginName,
    DatabaseName,
    TargetUserName,
    TextData, -- This shows the exact SQL query that was run
    EventClass, -- Internal SQL Server event ID
    SPID -- System Process ID
FROM 
    sys.fn_trace_gettable(
        (SELECT CAST(value AS NVARCHAR(260)) 
         FROM sys.fn_trace_getinfo(NULL) 
         WHERE property = 2 AND traceid = 1), 
        DEFAULT
    )
ORDER BY 
    StartTime DESC;
GO