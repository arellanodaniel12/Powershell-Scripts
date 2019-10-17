$today = [Int] (Get-Date).DayOfWeek

If ($today -eq 1 -or $today -eq 5) {
    (New-Object -ComObject WScript.Network).SetDefaultPrinter("B-ACCS-01-06");
} Else {
    (New-Object -ComObject WScript.Network).SetDefaultPrinter("B-PS15-04-03");
}

