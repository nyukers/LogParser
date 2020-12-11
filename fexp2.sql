SELECT  TimeGenerated,
        CASE SourceName 
          WHEN 'EventLog' THEN 'local0'
          WHEN 'Service Control Manager' THEN 'daemon'
          WHEN 'Print' THEN 'lpr'
          WHEN 'Kerberos' THEN 'auth'
          WHEN 'NETLOGON' THEN 'logaudit'
          WHEN 'Application Popup' THEN 'local7'
          ELSE 'local0'
        END AS MyFacility,
        CASE EventTypeName
          WHEN 'Error event' THEN 'err'
          WHEN 'Warning event' THEN 'warning'
          WHEN 'Information event' THEN 'info'
          ELSE 'info'
        END AS MySeverity,
        ComputerName,
        STRCAT(SourceName, ':'),
        EventID,
        Message
INTO @%OutSyslog%
FROM \\%Src%\System
WHERE (EventID = 6013 AND (TimeGenerated > TO_TIMESTAMP('%DY%','yyyy-MM-dd') AND TimeGenerated <= TO_TIMESTAMP('%DT%','yyyy-MM-dd')))
