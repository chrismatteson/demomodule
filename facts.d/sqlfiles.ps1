$hostname = hostname
$instances = get-service | where-object {$_.Name -like 'MSSQL$*'} | select -expand Name | %{$_ -replace 'MSSQL\$'}
foreach ($instance in $instances) {
  $value = sqlcmd -E -S $hostname\$instance -Q "select name, physical_name as current_file_location from sys.master_files";
  echo "$instance => $value"
}
