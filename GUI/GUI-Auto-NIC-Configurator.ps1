cls
# Script von Skyfay
# Support auf Githup oder support@skyfay.ch
$curent_version = "4.0"

#‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾#
#->                                       Script als Admin Starten und Powershell Console Verstecken                                            <-#
#_________________________________________________________________________________________________________________________________________________#

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $Command = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -WindowStyle hidden -Verb RunAs -ArgumentList $Command
        Exit
 }
}

#‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾#
#->                                                                 Github Release                                                              <-#
#_________________________________________________________________________________________________________________________________________________#

# Fragt meine Website nach den neusten Daten von Github ab

$curent_tag = $curent_version
$releases = "https://skyfay.ch/wp-content/uploads/2022/07/Auto_Nic_Configurator_Github_Api.txt"
$tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name # -Headers $headers

# Ist für den Text im Script verantwortlich

function gitrelease {

if ($curent_tag -lt $tag) {
    echo "Es ist ein neuer Release bereit ($tag)"
}
else {
    echo "Du nutzt die neuste Version $curent_tag"
}

}

$gitrelease_function = gitrelease


# Ist für die Farbe im Script verantwortlich


function gitrelease_color {
    if ($curent_tag -lt $tag) {
        echo "#FFDC855C"
    }
    else {
        echo "#FF827D7D"
    }
}

$gitrelease_function_color = gitrelease_color

# Ist für den Download Button im Script verantwortlich

function gitrelease_download {
    if ($curent_tag -lt $tag) {
        echo '<Button x:Name="new_version_download" Content="Download" HorizontalAlignment="Center" Height="30" Margin="0,351,0,0" VerticalAlignment="Top" Width="98" FontWeight="Bold" Foreground="White" Background="#FF252424" FontStyle="Normal"/>'
    }
    else {
        ""
    }
}

$new_github_release_download_button = gitrelease_download

# Ist für die Internet Connetion Abfrage verantwortlich
function test_internet_connectivity {
if (Test-Connection -ComputerName www.google.com -Count 1 -ea SilentlyContinue) {

        #internet OK"
        $internet_connectivity = "Server OK"
        echo '<TextBlock HorizontalAlignment="Center" Margin="0,350,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="18" Foreground="#FFDC855C" TextAlignment="Center"><Run Language="de-ch" Text=""/></TextBlock>'
        
}
Else {
        #cannot ping google"
        $internet_connectivity = "Server FAILED"
        echo '<TextBlock HorizontalAlignment="Center" Margin="0,350,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="18" Foreground="#FFDC5C5C" TextAlignment="Center"><Run Language="de-ch" Text="Keine Verbindung zum Internet!"/></TextBlock>'
}
}

$internet_connectivity_startup = test_internet_connectivity

#‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾#
#->                                                                Ordner Strucktur                                                             <-#
#_________________________________________________________________________________________________________________________________________________#


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

#‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾#
#->                                                                Identifizierung                                                              <-#
#_________________________________________________________________________________________________________________________________________________#

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


    # Identifizierung #


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





#‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾#
#->                                                                   Funktionen                                                                <-#
#_________________________________________________________________________________________________________________________________________________#

#Shortcut

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

function set_to_default_custom {
    Remove-NetIPAddress -InterfaceIndex $network_adapter_custom -confirm:$false
    Remove-NetRoute -InterfaceIndex $network_adapter_custom -confirm:$false
}

#Custom

function custom {
    $network_adapter_custom = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected.sky

    #set_to_default_custom

    $ipadress_custom = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\custom_ipadress.sky
    $subnetz_custom = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\custom_subnetz.sky
    $gateway_custom = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\custom_gateway.sky
    $dns_custom = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\custom_dns.sky

    New-Netipaddress -InterfaceIndex $network_adapter_custom -AddressFamily IPv4 -IPAddress $ipadress_custom -PrefixLength $subnetz_custom -DefaultGateway $gateway_custom -confirm:$false
    Set-DnsClientServerAddress -InterfaceIndex $network_adapter_custom -ServerAddresses $dns_custom -confirm:$false
}

#Team



#‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾#
#->                                                              Grapical Interface                                                             <-#
#_________________________________________________________________________________________________________________________________________________#

Add-Type -AssemblyName PresentationFramework

# Der Grid Teil muss jeweils von Visual Studio importiert werden und den "Click="Button_Click" entfernet werden


[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window">
    <TabControl Background="#FF161719">
        <TabControl.Style>
            <Style/>
        </TabControl.Style>
        <TabControl.FocusVisualStyle>
            <Style/>
        </TabControl.FocusVisualStyle>
        <TabItem Header="Shortcut" Background="#FF7E84D4">
            <Grid Background="#FF161719">
                <Button x:Name="DhcpButton" Content="DHCP (Default)" Margin="0,120,100,0" FontWeight="Normal" Foreground="White" BorderBrush="#FF707070" Background="#FF252424" HorizontalAlignment="Center" Width="98" Height="35" VerticalAlignment="Top"/>
                <TextBlock HorizontalAlignment="Center" Margin="0,10,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="30" Width="196" FontWeight="Bold" Foreground="White" TextAlignment="Center"><Run Language="de-ch" Text="Windows Netzwerk Konfigurator Shortcut"/></TextBlock>
                <TextBlock HorizontalAlignment="Center" Margin="0,90,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="198" Foreground="#FF7E84D4"><Run Text="Welche Aktion m"/><Run Language="de-ch" Text="oe"/><Run Text="chtest du starten?"/></TextBlock>
                <Button x:Name="SecurepointButton" Content="Securepoint" HorizontalAlignment="Center" Height="35" Margin="100,120,0,0" VerticalAlignment="Top" Width="98" FontWeight="Normal" Foreground="White" Background="#FF252424"/>
                <Button x:Name="ip_release_renew" Content="IP Adresse erneuern" HorizontalAlignment="Center" Height="34" VerticalAlignment="Top" Width="196" FontWeight="Normal" Foreground="White" Background="#FF252424" Margin="0,203,0,0"/>
                <Button x:Name="settings_button" Content="Einstellungen" HorizontalAlignment="Center" Height="35" Margin="0,242,0,0" VerticalAlignment="Top" Width="98" FontWeight="Normal" Foreground="White" Background="#FF252424"/>
                <TextBlock HorizontalAlignment="Center" Margin="354,310,354,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="18" Foreground="#FF827D7D" TextAlignment="Center"><Run Language="de-ch" Text="Script by Skyfay"/></TextBlock>
                <TextBlock HorizontalAlignment="Center" Margin="247,330,247,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="18" Foreground="$gitrelease_function_color" TextAlignment="Center"><Run Language="de-ch" Text="$gitrelease_function"/></TextBlock>
                $new_github_release_download_button
                $internet_connectivity_startup
                <ComboBox x:Name="NetAdapterSelect" HorizontalAlignment="Center" Margin="0,45,0,0" VerticalAlignment="Top" Width="196" Text="Wähle deinen Adapter" BorderBrush="#FF707070" Foreground="Black" Background="#FF252424">
                    <ComboBoxItem Content="$adapter1_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter2_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter3_content"></ComboBoxItem> 
                    <ComboBoxItem Content="$adapter4_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter5_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter6_content"></ComboBoxItem>
                </ComboBox>
            </Grid>
        </TabItem>
        <TabItem Header="Custom" Background="#FFD47E7E">
            <Grid Background="#FF161719">
                <TextBlock HorizontalAlignment="Center" Margin="0,10,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="30" Width="196" FontWeight="Bold" Foreground="White" Text="Windows Netzwerk Konfigurator&#xD;&#xA;Custom Setup&#xD;&#xA;" TextAlignment="Center"/>
                <ComboBox x:Name="NetAdapterSelect_Custom" HorizontalAlignment="Center" Margin="0,45,0,0" VerticalAlignment="Top" Width="196" Text="Wähle deinen Adapter" BorderBrush="#FF707070" Foreground="Black" Background="#FF252424">
                    <ComboBoxItem Content="$adapter1_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter2_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter3_content"></ComboBoxItem> 
                    <ComboBoxItem Content="$adapter4_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter5_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter6_content"></ComboBoxItem>
                </ComboBox>
                <TextBox x:Name="InputIPAdress_Custom" HorizontalAlignment="Center" Margin="0,105,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="196" Height="19" TextAlignment="Center" Background="#FF252424" Foreground="White" Text="192.168.1.1"/>
                <TextBlock HorizontalAlignment="Center" Margin="0,81,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="19" Width="196" FontWeight="Normal" Foreground="#FFD47E7E" TextAlignment="Center" Text="Trage die IP-Adresse ein"/>
                <StackPanel/>
                <TextBlock HorizontalAlignment="Center" Margin="0,135,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="19" Width="196" FontWeight="Normal" Foreground="#FFD47E7E" TextAlignment="Center" Text="Trage die Subnetzmaske ein" IsEnabled="False"/>
                <TextBox x:Name="InputSubnetz_Custom" HorizontalAlignment="Center" Margin="0,159,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="196" Height="19" TextAlignment="Center" Background="#FF252424" Foreground="White" Text="24"/>
                <TextBlock HorizontalAlignment="Center" Margin="0,188,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="19" Width="196" FontWeight="Normal" Foreground="#FFD47E7E" TextAlignment="Center" IsEnabled="False"><Run Text="Trage "/><Run Language="de-ch" Text="den"/><Run Text=" "/><Run Language="de-ch" Text="Gateway"/><Run Text=" ein"/></TextBlock>
                <TextBox x:Name="InputGateway_Custom" HorizontalAlignment="Center" Margin="0,212,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="196" Height="19" TextAlignment="Center" Background="#FF252424" Foreground="White" Text="192.168.1.1"/>
                <TextBlock HorizontalAlignment="Center" Margin="0,241,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="19" Width="196" FontWeight="Normal" Foreground="#FFD47E7E" TextAlignment="Center" IsEnabled="False"><Run Text="Trage die "/><Run Language="de-ch" Text="DNS Adresse"/><Run Text=" ein"/></TextBlock>
                <TextBox x:Name="InputDNS_Custom" HorizontalAlignment="Center" Margin="0,265,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="196" Height="19" TextAlignment="Center" Background="#FF252424" Foreground="White" Text="1.1.1.1"/>
                <Button x:Name="Done_Custom" Content="Anwenden" HorizontalAlignment="Center" Height="34" VerticalAlignment="Top" Width="196" FontWeight="Normal" Foreground="White" Background="#FF252424" Margin="0,307,0,0"/>
            </Grid>
        </TabItem>
        <TabItem Header="Nic_Team" Background="#FF89D47A">
            <Grid Background="#FF161719">
                <TextBlock HorizontalAlignment="Center" Margin="0,10,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="30" Width="243" FontWeight="Bold" Foreground="White" Text="Windows Netzwerk Konfigurator&#xA;Nic Teaming (Hyper-V - Virtual Switch)" TextAlignment="Center"/>
                <TextBlock x:Name="Team_Adapter_Value" HorizontalAlignment="Center" Margin="0,50,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="196" Height="19" TextAlignment="Center" Foreground="#FF89D47A" Text="Anzahl Adapter im Nic Team"/>
                <ComboBox x:Name="Adapter_Value_Team" HorizontalAlignment="Center" Margin="0,70,0,0" VerticalAlignment="Top" Width="196" Text="Wähle deinen Adapter" BorderBrush="#FF707070" Foreground="Black" Background="#FF252424">
                <ComboBoxItem Content="2"></ComboBoxItem>
                <ComboBoxItem Content="3"></ComboBoxItem>
                <ComboBoxItem Content="4"></ComboBoxItem>
                </ComboBox>
                <TextBlock x:Name="Team_Select_Adapter" HorizontalAlignment="Center" Margin="0,100,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="19" Width="196" FontWeight="Normal" Foreground="#FF89D47A" TextAlignment="Center" Text="Selektiere die Adapter "/>
                <ComboBox x:Name="NetAdapterSelect_Team" HorizontalAlignment="Center" Margin="0,120,0,0" VerticalAlignment="Top" Width="196" Text="Wähle deinen Adapter" BorderBrush="#FF707070" Foreground="Black" Background="#FF252424">
                    <ComboBoxItem Content="$adapter1_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter2_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter3_content"></ComboBoxItem> 
                    <ComboBoxItem Content="$adapter4_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter5_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter6_content"></ComboBoxItem>
                </ComboBox>
                <ComboBox x:Name="NetAdapterSelect_Team_2" HorizontalAlignment="Center" Margin="0,150,0,0" VerticalAlignment="Top" Width="196" Text="Wähle deinen Adapter" BorderBrush="#FF707070" Foreground="Black" Background="#FF252424">
                    <ComboBoxItem Content="$adapter1_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter2_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter3_content"></ComboBoxItem> 
                    <ComboBoxItem Content="$adapter4_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter5_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter6_content"></ComboBoxItem>
                </ComboBox>
                <ComboBox x:Name="NetAdapterSelect_Team_3" HorizontalAlignment="Center" Margin="0,180,0,0" VerticalAlignment="Top" Width="196" Text="Wähle deinen Adapter" BorderBrush="#FF707070" Foreground="Black" Background="#FF252424">
                    <ComboBoxItem Content="$adapter1_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter2_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter3_content"></ComboBoxItem> 
                    <ComboBoxItem Content="$adapter4_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter5_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter6_content"></ComboBoxItem>
                </ComboBox>
                <ComboBox x:Name="NetAdapterSelect_Team_4" HorizontalAlignment="Center" Margin="0,210,0,0" VerticalAlignment="Top" Width="196" Text="Wähle deinen Adapter" BorderBrush="#FF707070" Foreground="Black" Background="#FF252424">
                    <ComboBoxItem Content="$adapter1_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter2_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter3_content"></ComboBoxItem> 
                    <ComboBoxItem Content="$adapter4_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter5_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter6_content"></ComboBoxItem>
                </ComboBox>
                <Button x:Name="Done_Team" Content="Anwenden" HorizontalAlignment="Center" Height="34" VerticalAlignment="Top" Width="196" FontWeight="Normal" Foreground="White" Background="#FF252424" Margin="0,307,0,0"/>
                <TextBlock x:Name="NIC_Team_Name_Text" HorizontalAlignment="Center" Margin="0,241,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="19" Width="196" FontWeight="Normal" Foreground="#FF89D47A" TextAlignment="Center" Text="Wie soll das NIC Teaming heissen?"/>
                <TextBox x:Name="Input_NIC_Team_Name" HorizontalAlignment="Center" TextWrapping="Wrap" VerticalAlignment="Top" Width="196" Height="19" TextAlignment="Center" Background="#FF252424" Foreground="White" Text="NIC-TEAM" Margin="0,262,0,0"/>
                <TextBlock x:Name="Hyper_V_not_installed" HorizontalAlignment="Center" Margin="0,350,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="18" Foreground="#FFDC5C5C" TextAlignment="Center"><Run Language="de-ch" Text="Hyper-V ist nicht installiert!"/></TextBlock>
            </Grid>
        </TabItem>
    </TabControl>
</Window>
"@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

#‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾#
#->                                                                  ShortCuts                                                                  <-#
#_________________________________________________________________________________________________________________________________________________#


#--Sucht nach dem Button und führt darunter die Aktion aus--##
$DhcpButton = $window.FindName("DhcpButton")
$CustomButton = $window.FindName("CustomButton")
$SecurepointButton = $window.FindName("SecurepointButton")
$NetAdapterSelect = $window.FindName("NetAdapterSelect")
$IpAdressRenewButton = $window.FindName("ip_release_renew")
$settings_button = $window.FindName("settings_button")
$new_version_download = $window.FindName("new_version_download")

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
$SecurepointButton.Add_Click({
    securepoint
})
$IpAdressRenewButton.Add_Click({
    ip_release_renew
})
$settings_button.Add_Click({
    ncpa.cpl
})
$new_version_download.Add_Click({
    Start "https://github.com/Skyfay/Auto-NIC-Configurator/releases/latest"
})


#‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾#
#->                                                                    Custom                                                                   <-#
#_________________________________________________________________________________________________________________________________________________#

# Erstellt die notwendigen Dateien als Datenablage #

$Selected_Custom_Path_identify = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\selected_custom.sky
if ($Selected_Custom_Path_identify -eq "True") {
Remove-Item C:\Sky-Scripts\Net-Adapter-Config\selected_custom.sky
}
else {}

New-Item C:\Sky-Scripts\Net-Adapter-Config\selected_custom.sky



$custom_ipadress_Path_identify = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\custom_ipadress.sky
if ($custom_ipadress_Path_identify -ne "False") {
    New-Item C:\Sky-Scripts\Net-Adapter-Config\custom_ipadress.sky
}
else {}

$custom_subnetz_Path_identify = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\custom_subnetz.sky
if ($custom_subnetz_Path_identify -ne "False") {
    New-Item C:\Sky-Scripts\Net-Adapter-Config\custom_subnetz.sky
}
else {}

$custom_gateway_Path_identify = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\custom_gateway.sky
if ($custom_gateway_Path_identify -ne "False") {
    New-Item C:\Sky-Scripts\Net-Adapter-Config\custom_gateway.sky
}
else {}

$custom_DNS_Path_identify = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\custom_DNS.sky
if ($custom_DNS_Path_identify -ne "False") {
    New-Item C:\Sky-Scripts\Net-Adapter-Config\custom_DNS.sky
}
else {}


# Sucht nach dem Button und führt darunter die Aktion aus #

$NetAdapterSelect_Custom = $window.FindName("NetAdapterSelect_Custom")
$Done_Custom = $window.FindName("Done_Custom")
$InputIPAdress_Custom = $window.FindName("InputIPAdress_Custom")
$InputSubnetz_Custom = $window.FindName("InputSubnetz_Custom")
$InputGateway_Custom = $window.FindName("InputGateway_Custom")
$InputDNS_Custom = $window.FindName("InputDNS_Custom")


# Nimmt die Werte aus den Textboxen in die Dateien und führt dann das Script durch #

$Done_Custom.Add_Click({

    $InputIPAdress_Custom_Var = $InputIPAdress_Custom.Text.ToString()
    $InputSubnetz_Custom_Var = $InputSubnetz_Custom.Text.ToString()
    $InputGateway_Custom_var = $InputGateway_Custom.Text.ToString()
    $InputDNS_Custom_Var = $InputDNS_Custom.Text.ToString()

    $InputIPAdress_Custom_Var | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\custom_ipadress.sky
    $InputSubnetz_Custom_Var | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\custom_subnetz.sky
    $InputGateway_Custom_var | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\custom_gateway.sky
    $InputDNS_Custom_Var | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\custom_dns.sky

    custom
})

# Liest den aktuell ausgewählten Wert aus dem Dropdown Menu aus #


$NetAdapterSelect_Custom.add_SelectionChanged( {

    param($sender, $args)

    $selected = $sender.SelectedItem.Content

    # Die Leerzeichen vor und danach entfernen

    $selected_trim = $selected.trimstart().trimend()
    """$selected_trim""" | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected_custom.sky


    #Schreibt den Wert in die IfIndex Nummer um und schreibt den Wert dann wieder in die Datei selected.sky #
    $content_get = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected_custom.sky
    $IfIndex = (get-netadapter -name "$selected_trim").IfIndex | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected_custom.sky


})


#‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾#
#->                                                                     Team                                                                    <-#
#_________________________________________________________________________________________________________________________________________________#

# Erstellt die Datei value_team.sky für die Speicherung der Anzahl Adapter (Wird jedes mal neu erstellt)

$team_value_identify = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\value_team.sky
if ($team_value_identify -eq "True") { 
    Remove-Item C:\Sky-Scripts\Net-Adapter-Config\value_team.sky
}
else {}

New-Item C:\Sky-Scripts\Net-Adapter-Config\value_team.sky

$team_netadapter_identify = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\netadapter_team.sky
if ($team_netadapter_identify -eq "True") { 
    Remove-Item C:\Sky-Scripts\Net-Adapter-Config\netadapter_team.sky
}
else {}

New-Item C:\Sky-Scripts\Net-Adapter-Config\netadapter_team.sky

$team_netadapter_2_identify = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\netadapter_2_team.sky
if ($team_netadapter_2_identify -eq "True") { 
    Remove-Item C:\Sky-Scripts\Net-Adapter-Config\netadapter_2_team.sky
}
else {}

New-Item C:\Sky-Scripts\Net-Adapter-Config\netadapter_2_team.sky

$team_netadapter_3_identify = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\netadapter_3_team.sky
if ($team_netadapter_3_identify -eq "True") { 
    Remove-Item C:\Sky-Scripts\Net-Adapter-Config\netadapter_3_team.sky
}
else {}

New-Item C:\Sky-Scripts\Net-Adapter-Config\netadapter_3_team.sky

$team_netadapter_4_identify = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\netadapter_4_team.sky
if ($team_netadapter_4_identify -eq "True") { 
    Remove-Item C:\Sky-Scripts\Net-Adapter-Config\netadapter_4_team.sky
}
else {}

New-Item C:\Sky-Scripts\Net-Adapter-Config\netadapter_4_team.sky

# Sucht nach dem Button und führt darunter die Aktion aus

$Adapter_Value_Team = $window.FindName("Adapter_Value_Team")
$NetAdapterSelect_Team = $window.FindName("NetAdapterSelect_Team")
$NetAdapterSelect_Team_2 = $window.FindName("NetAdapterSelect_Team_2")
$NetAdapterSelect_Team_3 = $window.FindName("NetAdapterSelect_Team_3")
$NetAdapterSelect_Team_4 = $window.FindName("NetAdapterSelect_Team_4")
$Team_Select_Adapter = $window.FindName("Team_Select_Adapter")
$NIC_Team_Name_Text = $window.FindName("NIC_Team_Name_Text")
$Input_NIC_Team_Name = $window.FindName("Input_NIC_Team_Name")
$Done_Team = $window.FindName("Done_Team")
$Hyper_V_not_installed = $window.FindName("Hyper_V_not_installed")


# FUNCTIONS

# ZEIGT AN, OB HYPER-V INSTALLIERT IST ODER NICHT

function Hyper_V_Installed {
    $hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V -Online
    # Check if Hyper-V is enabled
    if($hyperv.State -eq "Enabled") {

        #Hyper-V is enabled.
        $Hyper_V_not_installed.Visibility = "Hidden"

    } else {

        #Hyper-V is disabled.
        $Hyper_V_not_installed.Visibility = "Visible"
    }
}
Hyper_V_Installed


# STANDARD EIGENSCHAFTEN VON CONTROLS

$Team_Select_Adapter.Visibility = "Hidden"
$NetAdapterSelect_Team.Visibility = "Hidden"
$NetAdapterSelect_Team_2.Visibility = "Hidden"
$NetAdapterSelect_Team_3.Visibility = "Hidden"
$NetAdapterSelect_Team_4.Visibility = "Hidden"
$NIC_Team_Name_Text.Visibility = "Hidden"
$Input_NIC_Team_Name.Visibility = "Hidden"

# Funktion zur Entfernung von Adaptern über die ausgewählte Anzahl


 
 function team_adapter_live_update {

 $value_team = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\value_team.sky

 if ($value_team -eq "2"){
    $Team_Select_Adapter.Visibility = "Visible"
    $NetAdapterSelect_Team.Visibility = "Visible"
    $NetAdapterSelect_Team_2.Visibility = "Visible"
    $NetAdapterSelect_Team_3.Visibility = "Hidden"
    $NetAdapterSelect_Team_4.Visibility = "Hidden"
 }
 if ($value_team -eq "3"){
    $Team_Select_Adapter.Visibility = "Visible"
    $NetAdapterSelect_Team.Visibility = "Visible"
    $NetAdapterSelect_Team_2.Visibility = "Visible"
    $NetAdapterSelect_Team_3.Visibility = "Visible"
    $NetAdapterSelect_Team_4.Visibility = "Hidden"
 }
 if ($value_team -eq "4"){
    $Team_Select_Adapter.Visibility = "Visible"
    $NetAdapterSelect_Team.Visibility = "Visible"
    $NetAdapterSelect_Team_2.Visibility = "Visible"
    $NetAdapterSelect_Team_3.Visibility = "Visible"
    $NetAdapterSelect_Team_4.Visibility = "Visible"
 }
 else{}
 }

 # ZEIGT DIE NAMEN EINGABE ERST, WENN DIE SPEZIFISCHEN FELDER AUSGEFÜLLT SIND

 function team_name_live_update {
    $value_team = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\value_team.sky

    $teams = @(
        'netadapter_team.sky'
        'netadapter_2_team.sky'
        'netadapter_3_team.sky'
        'netadapter_4_team.sky'
    ) | Join-Path -Path 'C:\Sky-Scripts\Net-Adapter-Config' -ChildPath { $_ } |
        Get-Content -Path { $_ } -Raw |
        ForEach-Object Trim
    if ($value_team -eq "2"){
    
        if ($teams.Count -ge 2) {
        $NIC_Team_Name_Text.Visibility = "Visible"
        $Input_NIC_Team_Name.Visibility = "Visible"
        } else {
        $NIC_Team_Name_Text.Visibility = "Hidden"
        $Input_NIC_Team_Name.Visibility = "Hidden"
    }
    }
    if ($value_team -eq "3"){

        if ($teams.Count -ge 3) {
        $NIC_Team_Name_Text.Visibility = "Visible"
        $Input_NIC_Team_Name.Visibility = "Visible"
        } else {
        $NIC_Team_Name_Text.Visibility = "Hidden"
        $Input_NIC_Team_Name.Visibility = "Hidden"
    }
    }
    if ($value_team -eq "4"){

        if ($teams.Count -ge 4) {
        $NIC_Team_Name_Text.Visibility = "Visible"
        $Input_NIC_Team_Name.Visibility = "Visible"
        } else {
        $NIC_Team_Name_Text.Visibility = "Hidden"
        $Input_NIC_Team_Name.Visibility = "Hidden"
    }
    }
}

# Liest den aktuell ausgewählten Wert aus dem Dropdown Menu "Adapter_Value_Team" aus


$Adapter_Value_Team.add_SelectionChanged({

    param($sender, $args)

    $selected = $sender.SelectedItem.Content

    # DIE LEERZEICHEN VOR UND DANACH ENTFERNEN

    $selected_trim = $selected.trimstart().trimend()
    "$selected_trim" | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\value_team.sky

    # FÜHRT DIE FUNKTION AUS, WELCHE DIE CONTROLS ANZEIGT ODER VERSTECKT

    team_adapter_live_update
})

$NetAdapterSelect_Team.add_SelectionChanged({

    param($sender, $args)

    $selected = $sender.SelectedItem.Content

    # DIE LEERZEICHEN VOR UND DANACH ENTFERNEN

    $selected_trim = $selected.trimstart().trimend()
    "$selected_trim" | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\netadapter_team.sky

    team_name_live_update
})
$NetAdapterSelect_Team_2.add_SelectionChanged({

    param($sender, $args)

    $selected = $sender.SelectedItem.Content

    # DIE LEERZEICHEN VOR UND DANACH ENTFERNEN

    $selected_trim = $selected.trimstart().trimend()
    "$selected_trim" | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\netadapter_2_team.sky
    
    team_name_live_update
})
$NetAdapterSelect_Team_3.add_SelectionChanged({

    param($sender, $args)

    $selected = $sender.SelectedItem.Content

    # DIE LEERZEICHEN VOR UND DANACH ENTFERNEN

    $selected_trim = $selected.trimstart().trimend()
    "$selected_trim" | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\netadapter_3_team.sky

    team_name_live_update
})
$NetAdapterSelect_Team_4.add_SelectionChanged({

    param($sender, $args)

    $selected = $sender.SelectedItem.Content

    # DIE LEERZEICHEN VOR UND DANACH ENTFERNEN

    $selected_trim = $selected.trimstart().trimend()
    "$selected_trim" | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\netadapter_4_team.sky

    team_name_live_update
})

$Done_Team.Add_Click({

        $value_team = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\value_team.sky
        $value_netadater_team = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\netadapter_team.sky
        $value_netadater_2_team = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\netadapter_2_team.sky
        $value_netadater_3_team = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\netadapter_3_team.sky
        $value_netadater_4_team = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\netadapter_4_team.sky
        $Input_NIC_Team_Name_Var = $Input_NIC_Team_Name.Text.ToString()

        if ($value_team -eq "2"){
            New-VMSwitch -Name $Input_NIC_Team_Name_Var -NetAdapterName "$value_netadater_team","$value_netadater_2_team" -EnableEmbeddedTeaming $true
            Set-VMSwitchTeam -Name $Input_NIC_Team_Name_Var -LoadBalancingAlgorithm Dynamic
        }
        if ($value_team -eq "3"){
            New-VMSwitch -Name $Input_NIC_Team_Name_Var -NetAdapterName "$value_netadater_team","$value_netadater_2_team","$value_netadater_3_team" -EnableEmbeddedTeaming $true
            Set-VMSwitchTeam -Name $Input_NIC_Team_Name_Var -LoadBalancingAlgorithm Dynamic
        }
        if ($value_team -eq "4"){
            New-VMSwitch -Name $Input_NIC_Team_Name_Var -NetAdapterName "$value_netadater_team","$value_netadater_2_team","$value_netadater_3_team","$value_netadater_4_team" -EnableEmbeddedTeaming $true
            Set-VMSwitchTeam -Name $Input_NIC_Team_Name_Var -LoadBalancingAlgorithm Dynamic
        }
        else{}
})





 $window.ShowDialog() | Out-Null

