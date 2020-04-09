#AUTHOR: Mitchell Rowin
#Class: Wednesday 5:30PM
#Date: 4/8/2020 6:00PM
#Project 1

#Project 1 Step 1
#Ask the User for the Computername of the computer you wish to query
param (
    [Parameter(Mandatory=$true)]
    $computername = 'localhost'
)
#Create a Date Variable for usage in the Report Text Files Name
$date = Get-Date -Format '-MM-dd-yyyy'
#Create Filename using the Computer Name combined with the Date
$filename="$computername$date.txt"
#Create the Report Text File, forcefully do it just in case an existing file with the same name exists
New-Item C:\$filename -Force
#Project 1 Step 2 #1 Operating system information including OS Name, Build and Version Number
Write-Output "#1: Operating System (Name, Build and Version)" | Out-File $filename
Get-CimInstance -Computername $computername -Classname Win32_OperatingSystem | fl caption, buildnumber, version | Out-File $filename -Append
#Step 2 #2 Processor information including Device ID, the name and the max clock speed.
Write-Output "#2: Processor Information (Device ID, Name, Max Clock)" | Out-File $filename -Append
Get-CimInstance -Computername $computername -Classname Win32_Processor | fl DeviceID, Name, MaxClockSpeed | Out-File $filename -Append
#Step 2 #3 IP Address information including the IP Address the subnet mask, the default gateway and the DHCP
Write-Output "#3: IP Address Configuration (IP Address, Subnet, Gateway, DHCP)" | Out-File $filename -Append
get-ciminstance -Computername $computername -classname Win32_NetworkAdapterconfiguration | where {$_.IPAddress -ne $null} | fl IPAddress, IPSubnet, DefaultIPGateway, DHCPEnabled | Out-File $filename -Append
#Step 2 #4 The DNS Client server address
Write-Output "#4 DNS Client Server Address" | Out-File $filename -Append
Get-DNSClientServerADDRESS -InterfaceAlias "Ethernet0" -AddressFamily IPv4 | fl ServerAddresses | Out-File $filename -Append
#Step 2 #5 The total system memory in gigabytes
Write-Output "#5 System Memory in Gigabytes" | Out-File $filename -Append
(get-ciminstance -Computername $computername -classname Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb | Out-File $filename -Append
#Step 2 #6 The amount of free space in the main C:\ Drive
Write-Output "#6 Free Gigabytes in C:\ Drive" | Out-File $filename -Append
(Get-CimInstance -Computername $computername -classname WIN32_LogicalDisk -Filter "DeviceID='C:'" | Measure-Object -Property FreeSpace -Sum).sum /1gb | Out-File $filename -Append
#Step 2 #7 The last bootup time of the computer, the name of the computer and the time.
Write-Output "#7 Last Computer Bootup Name/Time/Date" | Out-File $filename -Append
get-ciminstance -Computername $computername -classname win32_operatingsystem | fl CSName, lastbootuptime | Out-File $filename -Append
#Step 2 #8 The last user to log in to the computer, including the name and the date and time.
Write-Output "#8 Last User Login time Username/Time" | Out-File $filename -Append
Get-ciminstance -Computername $computername -ClassName win32_networkloginprofile | select-object Name, lastlogon | sort-object lastlogon | select-object -last 1 | out-file $filename -Append
#Step 2 #9 Retreive and post all local user accounts on the entire system.
Write-Output "#9 All Local User Accounts" | Out-File $filename -Append
get-ciminstance -Computername $computername -classname win32_useraccount -Filter "Domain='$computername'"| fl name | Out-File $filename -Append
#Step 2 #10 Find all of the hotfixes and updates and print their ID numbers.
Write-Output "#10 ID Numbers of All Installed Hotfixes and Updates" | Out-File $filename -Append
get-ciminstance -Computername $computername -classname win32_quickfixengineering | fl HotFixID | out-file $filename -Append
#Step 2 #11 All Installed applications, their names the vendors and the versions of each.
Write-Output "#11 All installed Applications (Name/Vendor/Version)" | Out-File $filename -Append
get-ciminstance -Computername $computername -classname Win32_product | fl Name, Vendor, Version | out-file $filename -Append