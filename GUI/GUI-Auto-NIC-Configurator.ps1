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

function set_to_default_custom {
    Remove-NetIPAddress -InterfaceIndex $network_adapter_custom -confirm:$false
    Remove-NetRoute -InterfaceIndex $network_adapter_custom -confirm:$false
}

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
                <TextBlock HorizontalAlignment="Center" Margin="0,10,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="30" Width="196" FontWeight="Bold" Foreground="White"><Run Language="de-ch" Text="Windows Netzwerk Konfigurator"/></TextBlock>
                <TextBlock HorizontalAlignment="Center" Margin="0,90,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="198" Foreground="#FF7E84D4"><Run Text="Welche Aktion m"/><Run Language="de-ch" Text="oe"/><Run Text="chtest du starten?"/></TextBlock>
                <Button x:Name="SecurepointButton" Content="Securepoint" HorizontalAlignment="Center" Height="35" Margin="100,120,0,0" VerticalAlignment="Top" Width="98" FontWeight="Normal" Foreground="White" Background="#FF252424"/>
                <Button x:Name="ip_release_renew" Content="IP Adresse erneuern" HorizontalAlignment="Center" Height="34" VerticalAlignment="Top" Width="196" FontWeight="Normal" Foreground="White" Background="#FF252424" Margin="0,203,0,0"/>
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
    </TabControl>
</Window>
"@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

#---------------------------------------------------------------------------------------------------------------------------------#
                                                    #ShortCuts#


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
$SecurepointButton.Add_Click({
    securepoint
})
$IpAdressRenewButton.Add_Click({
    ip_release_renew
})

                                                    #ShortCuts End#
#---------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------#
                                                        #Custom#

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


#---------------------------------------------------------------------------------------------------------------------------------#




$window.ShowDialog() | Out-Null
