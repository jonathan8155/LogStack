$event_log_path = "C:\Users\jonp3\projects\LogStack\data_input\20250207_security.evtx"

$start_time = Get-Date -AsUTC
Get-WinEvent -Path $event_log_path | ForEach-Object -Begin {
    $index = 1
    $events_found = 0
} -Process {
    # Write-Progress -Activity "Processing" -Status "Working on event # $index"
    if ($_.Id -eq 4624) {
        [xml]$xmlevent = $_.ToXml()
        $ERI = $xmlevent.Event.System.EventRecordID
        $TC = $xmlevent.Event.System.TimeCreated.SystemTime
        $SDN = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "SubjectDomainName"} | Select-Object -ExpandProperty '#text'
        $SUN = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "SubjectUserName"} | Select-Object -ExpandProperty '#text'
        $TDN = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "TargetDomainName"} | Select-Object -ExpandProperty '#text'
        $TUN = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "TargetUserName"} | Select-Object -ExpandProperty '#text'
        Write-Host $ERI $TC $SDN $SUN $TDN $TUN
        $events_found ++
    }
    $index ++
} -End {
    Write-Host "Total events parsed = $index"
    Write-Host "Total 4624 events found = $events_found"
}
$end_time = Get-Date -AsUTC

$process_time = $end_time - $start_time

Write-Host "Processing time = $process_time"