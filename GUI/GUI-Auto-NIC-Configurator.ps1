cls

################################################################
## Script als Admin Starten und Powershell Console Verstecken ##
################################################################

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $Command = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -WindowStyle hidden -Verb RunAs -ArgumentList $Command
        Exit
 }
}

#####################
## Ordner Struktur ##
#####################

# Wird für die Identifizierung gebraucht, ansonsten funktioniert diese nicht weil die Ordner nicht vorhanden sind.


$Test_Path_folder_1 = Test-Path -Path C:\Sky-Scripts
if ($Test_Path_folder_1 -ne "False") {
    New-Item "C:\Sky-Scripts" -itemType Directory
}
else {}
$Test_Path_folder_2 = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config
if ($Test_Path_folder_2 -ne "False") {
    New-Item "C:\Sky-Scripts\Net-Adapter-Config" -itemType Directory
}
else {}

###########################
##    Identifizierung    ##
###########################

# Er liest die Adapter von unten nach oben
# Die Function identify wurde deaktiviert und wird bei jedem Neustart automatisch ausgeführt da es sonst beim ersten Starten Fehler gibt.
# Der Button wurde aus dem User Interface entfernt

#function identify {
    
    $Test_Path_identify_1 = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\adapter1.sky
    if ($Test_Path_identify_1 -ne "False") {
        New-Item C:\Sky-Scripts\Net-Adapter-Config\adapter1.sky
    }
    else {}

    $Test_Path_identify_2 = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\adapter2.sky
    if ($Test_Path_identify_2 -ne "False") {
        New-Item C:\Sky-Scripts\Net-Adapter-Config\adapter2.sky
    }
    else {}

    $Test_Path_identify_3 = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\adapter3.sky
    if ($Test_Path_identify_3 -ne "False") {
        New-Item C:\Sky-Scripts\Net-Adapter-Config\adapter3.sky
    }
    else {}

    $Test_Path_identify_4 = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\adapter4.sky
    if ($Test_Path_identify_4 -ne "False") {
        New-Item C:\Sky-Scripts\Net-Adapter-Config\adapter4.sky
    }
    else {}

    $Test_Path_identify_5 = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\adapter5.sky
    if ($Test_Path_identify_5 -ne "False") {
        New-Item C:\Sky-Scripts\Net-Adapter-Config\adapter5.sky
    }
    else {}

    $Test_Path_identify_6 = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\adapter6.sky
    if ($Test_Path_identify_6 -ne "False") {
        New-Item C:\Sky-Scripts\Net-Adapter-Config\adapter6.sky
    }


    $adapter1 = Get-NetAdapter | Sort-Object | Select-Object -Skip 0 | Select-Object -First 1 | Format-List -Property "Name" | Out-File C:\Sky-Scripts\Net-Adapter-Config\adapter1.sky
    $adapter2 = Get-NetAdapter | Sort-Object | Select-Object -Skip 1 | Select-Object -First 1 | Format-List -Property "Name" | Out-File C:\Sky-Scripts\Net-Adapter-Config\adapter2.sky
    $adapter3 = Get-NetAdapter | Sort-Object | Select-Object -Skip 2 | Select-Object -First 1 | Format-List -Property "Name" | Out-File C:\Sky-Scripts\Net-Adapter-Config\adapter3.sky
    $adapter4 = Get-NetAdapter | Sort-Object | Select-Object -Skip 3 | Select-Object -First 1 | Format-List -Property "Name" | Out-File C:\Sky-Scripts\Net-Adapter-Config\adapter4.sky
    $adapter5 = Get-NetAdapter | Sort-Object | Select-Object -Skip 4 | Select-Object -First 1 | Format-List -Property "Name" | Out-File C:\Sky-Scripts\Net-Adapter-Config\adapter5.sky
    $adapter6 = Get-NetAdapter | Sort-Object | Select-Object -Skip 5 | Select-Object -First 1 | Format-List -Property "Name" | Out-File C:\Sky-Scripts\Net-Adapter-Config\adapter6.sky

    (Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter1.sky -Raw) -replace 'Name : ','' | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter1.sky
    (Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter2.sky -Raw) -replace 'Name : ','' | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter2.sky
    (Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter3.sky -Raw) -replace 'Name : ','' | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter3.sky
    (Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter4.sky -Raw) -replace 'Name : ','' | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter4.sky
    (Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter5.sky -Raw) -replace 'Name : ','' | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter5.sky
    (Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter6.sky -Raw) -replace 'Name : ','' | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter6.sky

    # Die Ergebnise von identify werden in eine Variable eingelesen 

    $adapter1_content = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter1.sky
    $adapter2_content = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter2.sky
    $adapter3_content = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter3.sky
    $adapter4_content = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter4.sky
    $adapter5_content = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter5.sky
    $adapter6_content = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\adapter6.sky


#}


################
## Funktionen ##
################

function set_to_default {
    Remove-NetIPAddress -InterfaceIndex $network_adapter -confirm:$false
    Remove-NetRoute -InterfaceIndex $network_adapter -confirm:$false
}

function ip_release_renew {
    ipconfig /release
    ipconfig /renew
}


function dhcp {
    $network_adapter = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected.sky
    set_to_default
    Set-DnsClientServerAddress -InterfaceIndex $network_adapter -confirm:$false -ResetServerAddresses
    Set-NetIPInterface -InterfaceIndex $network_adapter -AddressFamily IPv4 -Dhcp Enabled -confirm:$false
}

function securepoint {
    set_to_default
    $network_adapter = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected.sky
    # Securepoint Settings
    Set-NetIPInterface -InterfaceIndex $network_adapter -AddressFamily IPv4 -Dhcp Disabled
    New-Netipaddress -InterfaceIndex $network_adapter -AddressFamily IPv4 -IPAddress 192.168.175.5 -PrefixLength 24 -DefaultGateway 192.168.175.1 -confirm:$false
    Set-DnsClientServerAddress -InterfaceIndex $network_adapter -ServerAddresses 192.168.175.1 -confirm:$false
}

function custom {
    dhcp
    cls
    $ip_adress = Read-Host "Welche IP Adresse möchtest du vergeben?"
    $cidr = Read-Host "Welche Subnetzmaske möchtest du vergeben? (z.B 24)"
    $gateway = Read-Host "Welchen Gateway möchtest du vergeben?"
    $dns = Read-Host "Welche IP möchtest du als DNS Adresse"
    New-Netipaddress $network_adapter -IPAddress $ip_adress -PrefixLength $cidr -DefaultGateway $gateway -confirm:$false
    Set-DnsClientServerAddress $network_adapter -ServerAddresses $dns -confirm:$false
}


###############
##    GUI    ##
###############

Add-Type -AssemblyName PresentationFramework

# Der Grid Teil muss jeweils von Visual Studio importiert werden und den "Click="Button_Click" entfernet werden


[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window">
    <Grid x:Name="Grid" Background="#FF161719">
        <Button x:Name="DhcpButton" Content="DHCP (Default)" Margin="0,120,100,0" FontWeight="Normal" Foreground="White" BorderBrush="#FF707070" Background="#FF252424" HorizontalAlignment="Center" Width="98" Height="35" VerticalAlignment="Top"/>
        <TextBlock HorizontalAlignment="Center" Margin="0,10,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="30" Width="196" FontWeight="Bold" Foreground="White"><Run Language="de-ch" Text="Windows Netzwerk Konfigurator"/></TextBlock>
        <TextBlock HorizontalAlignment="Center" Margin="0,90,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="196" Foreground="#FFCE8484"><Run Language="de-ch" Text="Welche Aktion möchtest du starten?"/></TextBlock>
        <Button x:Name="CustomButton" Content="Custom" HorizontalAlignment="Center" Height="35" Margin="100,120,0,0" VerticalAlignment="Top" Width="98" FontWeight="Normal" Foreground="White" Background="#FF252424" RenderTransformOrigin="1.05,0.55"/>
        <Button x:Name="SecurepointButton" Content="Securepoint" HorizontalAlignment="Center" Height="34" Margin="0,157,0,0" VerticalAlignment="Top" Width="98" FontWeight="Normal" Foreground="White" Background="#FF252424"/>
        <ComboBox x:Name="NetAdapterSelect" HorizontalAlignment="Center" Margin="0,45,0,0" VerticalAlignment="Top" Width="196" Text="Wähle deinen Adapter" BorderBrush="#FF707070" Foreground="Black" Background="#FF252424">
            <ComboBoxItem Content="$adapter1_content"></ComboBoxItem>
            <ComboBoxItem Content="$adapter2_content"></ComboBoxItem>
            <ComboBoxItem Content="$adapter3_content"></ComboBoxItem> 
            <ComboBoxItem Content="$adapter4_content"></ComboBoxItem>
            <ComboBoxItem Content="$adapter5_content"></ComboBoxItem>
            <ComboBoxItem Content="$adapter6_content"></ComboBoxItem>
        </ComboBox>
        <Button x:Name="ip_release_renew" Content="IP Adresse erneuern" HorizontalAlignment="Center" Height="34" Margin="0,232,0,0" VerticalAlignment="Top" Width="196" FontWeight="Normal" Foreground="White" Background="#FF252424"/>
    </Grid>
</Window>
"@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)



#--Sucht nach dem Button und führt darunter die Aktion aus--##

$DhcpButton = $window.FindName("DhcpButton")
$CustomButton = $window.FindName("CustomButton")
$SecurepointButton = $window.FindName("SecurepointButton")
$NetAdapterSelect = $window.FindName("NetAdapterSelect")
$IpAdressRenewButton = $window.FindName("ip_release_renew")

#--Erstellt die Datei selected.sky für die Speicherung des aktuell ausgewählten Netzwerk Adapters--##

$Selected_Path_identify = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\selected.sky
if ($Test_Path_identify -ne "True") {
Remove-Item C:\Sky-Scripts\Net-Adapter-Config\selected.sky
}
else {}

New-Item C:\Sky-Scripts\Net-Adapter-Config\selected.sky

#--Liest den aktuell ausgewählten Wert aus dem Dropdown Menu aus--##

$NetAdapterSelect.add_SelectionChanged( {

    param($sender, $args)

    $selected = $sender.SelectedItem.Content

    # Die Leerzeichen vor und danach entfernen

    $selected_trim = $selected.trimstart().trimend()
    """$selected_trim""" | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected.sky


    #Schreibt den Wert in die IfIndex Nummer um und schreibt den Wert dann wieder in die Datei selected.sky #
    $content_get = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected.sky
    $IfIndex = (get-netadapter -name "$selected_trim").IfIndex | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected.sky


})



##--Buton Action--##

$DhcpButton.Add_Click({
    dhcp
})
$CustomButton.Add_Click({
    custom
})
$SecurepointButton.Add_Click({
    securepoint
})
$IpAdressRenewButton.Add_Click({
    ip_release_renew
})
$window.ShowDialog() | Out-Null
