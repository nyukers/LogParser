SELECT  TimeGenerated,
        CASE SourceName
          WHEN 'EventLog' THEN 'mark'
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
          ELSE 'notice'
        END AS MySeverity,
        ComputerName,
        STRCAT(SourceName, ':') as Sn,
        COUNT(EventID) AS TotalLogonFailures,
	TO_LOWERCASE(EXTRACT_TOKEN(Strings,0,'|')) AS User,
	TO_LOWERCASE(EXTRACT_TOKEN(Strings,1,'|')) AS Domain,
	TO_LOWERCASE(EXTRACT_TOKEN(Strings,5,'|')) AS WorkStation,
	CASE TO_INT(EXTRACT_TOKEN(Strings,2,'|')) 
	     WHEN 2 THEN  'Interactive '
	     WHEN 3 THEN  'Network'
	     WHEN 4 THEN  'Batch'
	     WHEN 5 THEN  'Service'
	     WHEN 6 THEN  'Proxy '
	     WHEN 7 THEN  'Unlock '
	     WHEN 8 THEN  'NetworkCleartext'
	     WHEN 9 THEN  'NewCredentials '
	     WHEN 10 THEN 'RemoteInteractive '
	     WHEN 11 THEN 'CachedInteractive'
	     WHEN 12 THEN 'CachedRemoteInteractive'
	     WHEN 13 THEN 'CachedUnlock'
	     ELSE EXTRACT_TOKEN(Strings,2,'|')
	END AS Type,
	message

INTO @WVIT-99,%Out%\dc01-sec.log
FROM \\%Source%\Security
WHERE (EventID IN (4771;4624;4625;4720;4725;4726;4740;4767) AND (TimeGenerated > TO_TIMESTAMP('%DY%','yyyy-MM-dd') AND TimeGenerated <= TO_TIMESTAMP('%DT%','yyyy-MM-dd')))
GROUP BY TimeGenerated,User,Domain,WorkStation,Type,MyFacility,MySeverity,ComputerName,Sn,Message
ORDER BY TotalLogonFailures DESC