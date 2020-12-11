SELECT
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
	END AS Type
INTO CHART
FROM \\%Source%\security
WHERE EventID IN (4771)
GROUP BY User,Domain,WorkStation,Type
ORDER BY TotalLogonFailures DESC
