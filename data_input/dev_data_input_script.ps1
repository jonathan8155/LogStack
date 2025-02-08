$event_log_path = "C:\Users\jonp3\projects\LogStack\data_input\20250207_security.evtx"

$start_time = Get-Date -AsUTC
Get-WinEvent -Path $event_log_path | ForEach-Object -Begin {
    $index = 1
    $4624 = $4625 = $ignored = $4720 = $4722 = $4723 = $4724 = $4725 = $4726 = $4749 = $4767 = $4731 = $4732 = $4733 = $4734 = $4672 = $4673 = $4674 = $1102 = 0
} -Process {
    # Write-Progress -Activity "Processing" -Status "Working on event # $index"
    [xml]$xmlevent = $_.ToXml()
    switch ($_.Id) {
        4624 { 
            $TC = $xmlevent.Event.System.TimeCreated.SystemTime
            $C = $xmlevent.Event.System.Computer
            $ERI = $xmlevent.Event.System.EventRecordID
            $SDN = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "SubjectDomainName"} | Select-Object -ExpandProperty '#text'
            $SUN = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "SubjectUserName"} | Select-Object -ExpandProperty '#text'
            $SLI = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "SubjectLogonId"} | Select-Object -ExpandProperty '#text'
            $TDN = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "TargetDomainName"} | Select-Object -ExpandProperty '#text'
            $TUN = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "TargetUserName"} | Select-Object -ExpandProperty '#text'
            $TLI = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "TargetLogonId"} | Select-Object -ExpandProperty '#text'
            $LT = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "Logontype"} | Select-Object -ExpandProperty '#text'
            $ET = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "ElevatedToken"} | Select-Object -ExpandProperty '#text'
            Write-Host "4624 Event" $TC $C $ERI $SDN $SUN $SLI $TDN $TUN $TLI $LT $ET -Separator ", "
            $4624 ++
        }
        4625 {
            $TC = $xmlevent.Event.System.TimeCreated.SystemTime
            $C = $xmlevent.Event.System.Computer
            $ERI = $xmlevent.Event.System.EventRecordID
            $SDN = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "SubjectDomainName"} | Select-Object -ExpandProperty '#text'
            $SUN = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "SubjectUserName"} | Select-Object -ExpandProperty '#text'
            $SLI = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "SubjectLogonId"} | Select-Object -ExpandProperty '#text'
            $TDN = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "TargetDomainName"} | Select-Object -ExpandProperty '#text'
            $TUN = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "TargetUserName"} | Select-Object -ExpandProperty '#text'
            $LT = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "Logontype"} | Select-Object -ExpandProperty '#text'
            $FR = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "FailureReason"} | Select-Object -ExpandProperty '#text'
            $S = $xmlevent.Event.EventData.Data | Where-Object {$_.Name -eq "Status"} | Select-Object -ExpandProperty '#text'
            Write-Host "4625 Event" $TC $C $ERI $SDN $SUN $SLI $TDN $TUN $TLI $LT $FR $S -Separator ", "
            $4624 ++
        }
        4720 {
            $4720 ++
        }
        4722 {
            $4722 ++
        }
        4723 {
            $4723 ++
        }
        4724 {

        }
        4725 {

        }
        4726 {

        }
        4749 {

        }
        4767 {

        }
        4731 {

        }
        4732 {

        }
        4733 {

        }
        4734 {

        }
        4672 {

        }
        4673 {

        }
        4674 {

        }
        1102 {

        }
        Default {$ignored ++}
    }
    $index ++
} -End {
    Write-Host "Total events parsed = $index"
    Write-Host "Total number of events kept by eventid: `n`t 4624 = $4624 `n`t 4625 = $4624" -ForegroundColor Green
    Write-Host "`t Total number of events filtered out = $ignored"
}
$end_time = Get-Date -AsUTC

$process_time = $end_time - $start_time

Write-Host "Processing time = $process_time"