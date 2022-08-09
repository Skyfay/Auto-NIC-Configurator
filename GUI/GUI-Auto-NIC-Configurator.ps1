cls
# Script von Skyfay
# Support auf Githup oder support@skyfay.ch
$curent_version = "6.0"

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
        $No_Internet_Connection.Visibility = "hidden"
        
}
Else {
        #cannot ping google"
        $internet_connectivity = "Server FAILED"
        $No_Internet_Connection.Visibility = "Visible"
}
}

#‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾#
#->                                                                  Notification                                                               <-#
#_________________________________________________________________________________________________________________________________________________#

Function New-WPFMessageBox {

    # For examples for use, see my blog:
    # https://smsagent.wordpress.com/2017/08/24/a-customisable-wpf-messagebox-for-powershell/
    
    # CHANGES
    # 2017-09-11 - Added some required assemblies in the dynamic parameters to avoid errors when run from the PS console host.
    
    # Define Parameters
    [CmdletBinding()]
    Param
    (
        # The popup Content
        [Parameter(Mandatory=$True,Position=0)]
        [Object]$Content,

        # The window title
        [Parameter(Mandatory=$false,Position=1)]
        [string]$Title,

        # The buttons to add
        [Parameter(Mandatory=$false,Position=2)]
        [ValidateSet('OK','OK-Cancel','Abort-Retry-Ignore','Yes-No-Cancel','Yes-No','Retry-Cancel','Cancel-TryAgain-Continue','None')]
        [array]$ButtonType = 'OK',

        # The buttons to add
        [Parameter(Mandatory=$false,Position=3)]
        [array]$CustomButtons,

        # Content font size
        [Parameter(Mandatory=$false,Position=4)]
        [int]$ContentFontSize = 14,

        # Title font size
        [Parameter(Mandatory=$false,Position=5)]
        [int]$TitleFontSize = 14,

        # BorderThickness
        [Parameter(Mandatory=$false,Position=6)]
        [int]$BorderThickness = 0,

        # CornerRadius
        [Parameter(Mandatory=$false,Position=7)]
        [int]$CornerRadius = 8,

        # ShadowDepth
        [Parameter(Mandatory=$false,Position=8)]
        [int]$ShadowDepth = 3,

        # BlurRadius
        [Parameter(Mandatory=$false,Position=9)]
        [int]$BlurRadius = 20,

        # WindowHost
        [Parameter(Mandatory=$false,Position=10)]
        [object]$WindowHost,

        # Timeout in seconds,
        [Parameter(Mandatory=$false,Position=11)]
        [int]$Timeout,

        # Code for Window Loaded event,
        [Parameter(Mandatory=$false,Position=12)]
        [scriptblock]$OnLoaded,

        # Code for Window Closed event,
        [Parameter(Mandatory=$false,Position=13)]
        [scriptblock]$OnClosed

    )

    # Dynamically Populated parameters
    DynamicParam {
        
        # Add assemblies for use in PS Console 
        Add-Type -AssemblyName System.Drawing, PresentationCore
        
        # ContentBackground
        $ContentBackground = 'ContentBackground'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.ContentBackground = "White"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ContentBackground, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ContentBackground, $RuntimeParameter)
        

        # FontFamily
        $FontFamily = 'FontFamily'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute)  
        $arrSet = [System.Drawing.FontFamily]::Families.Name | Select -Skip 1 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        $AttributeCollection.Add($ValidateSetAttribute)
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($FontFamily, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($FontFamily, $RuntimeParameter)
        $PSBoundParameters.FontFamily = "Segoe UI"

        # TitleFontWeight
        $TitleFontWeight = 'TitleFontWeight'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Windows.FontWeights] | Get-Member -Static -MemberType Property | Select -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.TitleFontWeight = "Normal"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($TitleFontWeight, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($TitleFontWeight, $RuntimeParameter)

        # ContentFontWeight
        $ContentFontWeight = 'ContentFontWeight'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Windows.FontWeights] | Get-Member -Static -MemberType Property | Select -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.ContentFontWeight = "Normal"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ContentFontWeight, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ContentFontWeight, $RuntimeParameter)
        

        # ContentTextForeground
        $ContentTextForeground = 'ContentTextForeground'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.ContentTextForeground = "Black"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ContentTextForeground, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ContentTextForeground, $RuntimeParameter)

        # TitleTextForeground
        $TitleTextForeground = 'TitleTextForeground'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.TitleTextForeground = "Black"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($TitleTextForeground, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($TitleTextForeground, $RuntimeParameter)

        # BorderBrush
        $BorderBrush = 'BorderBrush'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.BorderBrush = "Black"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($BorderBrush, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($BorderBrush, $RuntimeParameter)


        # TitleBackground
        $TitleBackground = 'TitleBackground'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.TitleBackground = "White"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($TitleBackground, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($TitleBackground, $RuntimeParameter)

        # ButtonTextForeground
        $ButtonTextForeground = 'ButtonTextForeground'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.ButtonTextForeground = "Black"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ButtonTextForeground, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ButtonTextForeground, $RuntimeParameter)

        # Sound
        $Sound = 'Sound'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        #$ParameterAttribute.Position = 14
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = (Get-ChildItem "$env:SystemDrive\Windows\Media" -Filter Windows* | Select -ExpandProperty Name).Replace('.wav','')
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($Sound, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($Sound, $RuntimeParameter)

        return $RuntimeParameterDictionary
    }

    Begin {
        Add-Type -AssemblyName PresentationFramework
    }
    
    Process {

# Define the XAML markup
[XML]$Xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Name="Window" Title="" SizeToContent="WidthAndHeight" WindowStartupLocation="CenterScreen" WindowStyle="None" ResizeMode="NoResize" AllowsTransparency="True" Background="Transparent" Opacity="1">
    <Window.Resources>
        <Style TargetType="{x:Type Button}">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border>
                            <Grid Background="{TemplateBinding Background}">
                                <ContentPresenter />
                            </Grid>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
    <Border x:Name="MainBorder" Margin="10" CornerRadius="$CornerRadius" BorderThickness="$BorderThickness" BorderBrush="$($PSBoundParameters.BorderBrush)" Padding="0" >
        <Border.Effect>
            <DropShadowEffect x:Name="DSE" Color="Black" Direction="270" BlurRadius="$BlurRadius" ShadowDepth="$ShadowDepth" Opacity="0.6" />
        </Border.Effect>
        <Border.Triggers>
            <EventTrigger RoutedEvent="Window.Loaded">
                <BeginStoryboard>
                    <Storyboard>
                        <DoubleAnimation Storyboard.TargetName="DSE" Storyboard.TargetProperty="ShadowDepth" From="0" To="$ShadowDepth" Duration="0:0:1" AutoReverse="False" />
                        <DoubleAnimation Storyboard.TargetName="DSE" Storyboard.TargetProperty="BlurRadius" From="0" To="$BlurRadius" Duration="0:0:1" AutoReverse="False" />
                    </Storyboard>
                </BeginStoryboard>
            </EventTrigger>
        </Border.Triggers>
        <Grid >
            <Border Name="Mask" CornerRadius="$CornerRadius" Background="$($PSBoundParameters.ContentBackground)" />
            <Grid x:Name="Grid" Background="$($PSBoundParameters.ContentBackground)">
                <Grid.OpacityMask>
                    <VisualBrush Visual="{Binding ElementName=Mask}"/>
                </Grid.OpacityMask>
                <StackPanel Name="StackPanel" >                   
                    <TextBox Name="TitleBar" IsReadOnly="True" IsHitTestVisible="False" Text="$Title" Padding="10" FontFamily="$($PSBoundParameters.FontFamily)" FontSize="$TitleFontSize" Foreground="$($PSBoundParameters.TitleTextForeground)" FontWeight="$($PSBoundParameters.TitleFontWeight)" Background="$($PSBoundParameters.TitleBackground)" HorizontalAlignment="Stretch" VerticalAlignment="Center" Width="Auto" HorizontalContentAlignment="Center" BorderThickness="0"/>
                    <DockPanel Name="ContentHost" Margin="0,10,0,10"  >
                    </DockPanel>
                    <DockPanel Name="ButtonHost" LastChildFill="False" HorizontalAlignment="Center" >
                    </DockPanel>
                </StackPanel>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

[XML]$ButtonXaml = @"
<Button xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Width="Auto" Height="30" FontFamily="Segui" FontSize="16" Background="Transparent" Foreground="White" BorderThickness="1" Margin="10" Padding="20,0,20,0" HorizontalAlignment="Right" Cursor="Hand"/>
"@

[XML]$ButtonTextXaml = @"
<TextBlock xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" FontFamily="$($PSBoundParameters.FontFamily)" FontSize="16" Background="Transparent" Foreground="$($PSBoundParameters.ButtonTextForeground)" Padding="20,5,20,5" HorizontalAlignment="Center" VerticalAlignment="Center"/>
"@

[XML]$ContentTextXaml = @"
<TextBlock xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Text="$Content" Foreground="$($PSBoundParameters.ContentTextForeground)" DockPanel.Dock="Right" HorizontalAlignment="Center" VerticalAlignment="Center" FontFamily="$($PSBoundParameters.FontFamily)" FontSize="$ContentFontSize" FontWeight="$($PSBoundParameters.ContentFontWeight)" TextWrapping="Wrap" Height="Auto" MaxWidth="500" MinWidth="50" Padding="10"/>
"@

    # Load the window from XAML
    $Window = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $xaml))

    # Custom function to add a button
    Function Add-Button {
        Param($Content)
        $Button = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $ButtonXaml))
        $ButtonText = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $ButtonTextXaml))
        $ButtonText.Text = "$Content"
        $Button.Content = $ButtonText
        $Button.Add_MouseEnter({
            $This.Content.FontSize = "17"
        })
        $Button.Add_MouseLeave({
            $This.Content.FontSize = "16"
        })
        $Button.Add_Click({
            New-Variable -Name WPFMessageBoxOutput -Value $($This.Content.Text) -Option ReadOnly -Scope Script -Force
            $Window.Close()
        })
        $Window.FindName('ButtonHost').AddChild($Button)
    }

    # Add buttons
    If ($ButtonType -eq "OK")
    {
        Add-Button -Content "OK"
    }

    If ($ButtonType -eq "OK-Cancel")
    {
        Add-Button -Content "OK"
        Add-Button -Content "Cancel"
    }

    If ($ButtonType -eq "Abort-Retry-Ignore")
    {
        Add-Button -Content "Abort"
        Add-Button -Content "Retry"
        Add-Button -Content "Ignore"
    }

    If ($ButtonType -eq "Yes-No-Cancel")
    {
        Add-Button -Content "Yes"
        Add-Button -Content "No"
        Add-Button -Content "Cancel"
    }

    If ($ButtonType -eq "Yes-No")
    {
        Add-Button -Content "Yes"
        Add-Button -Content "No"
    }

    If ($ButtonType -eq "Retry-Cancel")
    {
        Add-Button -Content "Retry"
        Add-Button -Content "Cancel"
    }

    If ($ButtonType -eq "Cancel-TryAgain-Continue")
    {
        Add-Button -Content "Cancel"
        Add-Button -Content "TryAgain"
        Add-Button -Content "Continue"
    }

    If ($ButtonType -eq "None" -and $CustomButtons)
    {
        Foreach ($CustomButton in $CustomButtons)
        {
            Add-Button -Content "$CustomButton"
        }
    }

    # Remove the title bar if no title is provided
    If ($Title -eq "")
    {
        $TitleBar = $Window.FindName('TitleBar')
        $Window.FindName('StackPanel').Children.Remove($TitleBar)
    }

    # Add the Content
    If ($Content -is [String])
    {
        # Replace double quotes with single to avoid quote issues in strings
        If ($Content -match '"')
        {
            $Content = $Content.Replace('"',"'")
        }
        
        # Use a text box for a string value...
        $ContentTextBox = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $ContentTextXaml))
        $Window.FindName('ContentHost').AddChild($ContentTextBox)
    }
    Else
    {
        # ...or add a WPF element as a child
        Try
        {
            $Window.FindName('ContentHost').AddChild($Content) 
        }
        Catch
        {
            $_
        }            }

    # Enable window to move when dragged
    $Window.FindName('Grid').Add_MouseLeftButtonDown({
        $Window.DragMove()
    })

    # Activate the window on loading
    If ($OnLoaded)
    {
        $Window.Add_Loaded({
            $This.Activate()
            Invoke-Command $OnLoaded
        })
    }
    Else
    {
        $Window.Add_Loaded({
            $This.Activate()
        })
    }
    

    # Stop the dispatcher timer if exists
    If ($OnClosed)
    {
        $Window.Add_Closed({
            If ($DispatcherTimer)
            {
                $DispatcherTimer.Stop()
            }
            Invoke-Command $OnClosed
        })
    }
    Else
    {
        $Window.Add_Closed({
            If ($DispatcherTimer)
            {
                $DispatcherTimer.Stop()
            }
        })
    }
    

    # If a window host is provided assign it as the owner
    If ($WindowHost)
    {
        $Window.Owner = $WindowHost
        $Window.WindowStartupLocation = "CenterOwner"
    }

    # If a timeout value is provided, use a dispatcher timer to close the window when timeout is reached
    If ($Timeout)
    {
        $Stopwatch = New-object System.Diagnostics.Stopwatch
        $TimerCode = {
            If ($Stopwatch.Elapsed.TotalSeconds -ge $Timeout)
            {
                $Stopwatch.Stop()
                $Window.Close()
            }
        }
        $DispatcherTimer = New-Object -TypeName System.Windows.Threading.DispatcherTimer
        $DispatcherTimer.Interval = [TimeSpan]::FromSeconds(1)
        $DispatcherTimer.Add_Tick($TimerCode)
        $Stopwatch.Start()
        $DispatcherTimer.Start()
    }

    # Play a sound
    If ($($PSBoundParameters.Sound))
    {
        $SoundFile = "$env:SystemDrive\Windows\Media\$($PSBoundParameters.Sound).wav"
        $SoundPlayer = New-Object System.Media.SoundPlayer -ArgumentList $SoundFile
        $SoundPlayer.Add_LoadCompleted({
            $This.Play()
            $This.Dispose()
        })
        $SoundPlayer.LoadAsync()
    }

    # Display the window
    $null = $window.Dispatcher.InvokeAsync{$window.ShowDialog()}.Wait()

    }
}

$WorkedParams = @{
    Title = "ERFOLGREICH"
    TitleFontSize = 20
    TitleBackground = 'Green'
    TitleTextForeground = 'Black'
}

$InfoParams = @{
    Title = "INFORMATION"
    TitleFontSize = 20
    TitleBackground = 'LightSkyBlue'
    TitleTextForeground = 'Black'
}

$WarningParams = @{
    Title = "WARNUNG"
    TitleFontSize = 20
    TitleBackground = 'Orange'
    TitleTextForeground = 'Black'
}

$ErrorMsgParams = @{
    Title = "FEHLER!"
    TitleBackground = "Red"
    TitleTextForeground = "WhiteSmoke"
    TitleFontWeight = "UltraBold"
    TitleFontSize = 20
    Sound = 'Windows Exclamation'
}




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

#GUI

function shortcut_list {

#Nicht mehr in Verwendung 

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window">
            <Grid Background="#FF161719">
                <TextBlock HorizontalAlignment="Center" Margin="0,10,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="30" Width="196" FontWeight="Bold" Foreground="White" TextAlignment="Center"><Run Language="de-ch" Text="Windows Netzwerk Konfigurator Shortcut List"/></TextBlock>
                <TextBlock HorizontalAlignment="Center" Margin="0,90,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="198" Foreground="#FF7E84D4"><Run Text="Welche Aktion m"/><Run Language="de-ch" Text="oe"/><Run Text="chtest du starten?"/></TextBlock>
                <Button x:Name="DhcpButton" Content="DHCP (Default)" Margin="0,120,100,0" FontWeight="Normal" Foreground="White" BorderBrush="#FF707070" Background="#FF252424" HorizontalAlignment="Center" Width="98" Height="35" VerticalAlignment="Top"/>
                <Button x:Name="SecurepointButton" Content="Securepoint" HorizontalAlignment="Center" Height="35" Margin="100,120,0,0" VerticalAlignment="Top" Width="98" FontWeight="Normal" Foreground="White" Background="#FF252424"/>
                <ComboBox x:Name="NetAdapterSelect" HorizontalAlignment="Center" Margin="0,45,0,0" VerticalAlignment="Top" Width="196" Text="Wähle deinen Adapter" BorderBrush="#FF707070" Foreground="Black" Background="#FF252424">
                </ComboBox>
            </Grid>
</Window>
"@
$window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))
$window.ShowDialog()

}

#Start

function Adapter_Information_Field_Update {

    function Adapter_Information_Field_Update_Initial {
    Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Name.sky | echo
    }
    $NetInformation_Name = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Name.sky
    $NetInformation_Description = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Description.sky
    $NetInformation_Status = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Status.sky
    $NetInformation_MacAddress = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\NetInformation_MacAddress.sky
    $NetInformation_LinkSpeed = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\NetInformation_LinkSpeed.sky

    $Adapter_Information_Field.Text= "$NetInformation_Name`n$NetInformation_Description`n$NetInformation_Status`n$NetInformation_MacAddress`n$NetInformation_LinkSpeed"
}

#Shortcut

function set_to_default {
    Remove-NetIPAddress -InterfaceIndex $network_adapter -confirm:$false
    Remove-NetRoute -InterfaceIndex $network_adapter -confirm:$false
}

function ip_release_renew {
    ipconfig /release
    ipconfig /renew
    test_internet_connectivity
}


function dhcp {
    $network_adapter = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected.sky
    set_to_default
    Set-DnsClientServerAddress -InterfaceIndex $network_adapter -confirm:$false -ResetServerAddresses
    Set-NetIPInterface -InterfaceIndex $network_adapter -AddressFamily IPv4 -Dhcp Enabled -confirm:$false
}

function securepoint {
    $network_adapter = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected.sky
    set_to_default
    $error.clear()
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
    $network_adapter_custom = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected_custom.sky

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

# Default

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
        <TabItem Header="Start" Background="#FF7ED2D4">
            <Grid Background="#FF161719">
                <TextBlock HorizontalAlignment="Center" Margin="0,10,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="30" Width="196" FontWeight="Bold" Foreground="White" TextAlignment="Center"><Run Language="de-ch" Text="Windows Netzwerk Konfigurator Start"/></TextBlock>
                <TextBlock HorizontalAlignment="Center" Margin="0,90,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="198" Foreground="#FF7ED2D4" Text="Infos zum Adapter anzeigen lassen" TextAlignment="Center"/>
                <Button x:Name="ip_release_renew" Content="IP Adresse erneuern" HorizontalAlignment="Center" Height="34" VerticalAlignment="Top" Width="196" FontWeight="Normal" Foreground="White" Background="#FF252424" Margin="0,203,0,0"/>
                <Button x:Name="settings_button" Content="Einstellungen" HorizontalAlignment="Center" Height="35" Margin="0,242,0,0" VerticalAlignment="Top" Width="98" FontWeight="Normal" Foreground="White" Background="#FF252424"/>
                <TextBlock HorizontalAlignment="Center" Margin="354,310,354,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="18" Foreground="#FF827D7D" TextAlignment="Center"><Run Language="de-ch" Text="Script by Skyfay"/></TextBlock>
                <TextBlock HorizontalAlignment="Center" Margin="247,330,247,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="18" Foreground="$gitrelease_function_color" TextAlignment="Center"><Run Language="de-ch" Text="$gitrelease_function"/></TextBlock>
                $new_github_release_download_button
                <TextBlock x:Name="No_Internet_Connection" HorizontalAlignment="Center" Margin="0,350,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="18" Foreground="#FFDC5C5C" TextAlignment="Center"><Run Language="de-ch" Text="Keine Verbindung zum Internet"/></TextBlock>
                <TextBox x:Name="Adapter_Information_Field" HorizontalAlignment="Center" Height="81" Margin="0,111,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="276" Background="#FF252424" Foreground="White" TextAlignment="Center"/>
                <ComboBox x:Name="NetAdapterSelect_Start" HorizontalAlignment="Center" Margin="0,45,0,0" VerticalAlignment="Top" Width="196" Text="Wähle deinen Adapter" BorderBrush="#FF707070" Foreground="Black" Background="#FF252424">
                    <ComboBoxItem Content="$adapter1_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter2_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter3_content"></ComboBoxItem> 
                    <ComboBoxItem Content="$adapter4_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter5_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter6_content"></ComboBoxItem>
                </ComboBox>
            </Grid>
        </TabItem>
        <TabItem Header="Shortcut" Background="#FF7E84D4">
            <Grid Background="#FF161719">
                <TextBlock HorizontalAlignment="Center" Margin="0,10,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="30" Width="196" FontWeight="Bold" Foreground="White" TextAlignment="Center"><Run Language="de-ch" Text="Windows Netzwerk Konfigurator Shortcut"/></TextBlock>
                <TextBlock HorizontalAlignment="Center" Margin="0,90,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="198" Foreground="#FF7E84D4"><Run Text="Welche Aktion m"/><Run Language="de-ch" Text="oe"/><Run Text="chtest du starten?"/></TextBlock>
                <Button x:Name="DhcpButton" Content="DHCP (Default)" Margin="0,120,100,0" FontWeight="Normal" Foreground="White" BorderBrush="#FF707070" Background="#FF252424" HorizontalAlignment="Center" Width="98" Height="35" VerticalAlignment="Top"/>
                <Button x:Name="SecurepointButton" Content="Securepoint" HorizontalAlignment="Center" Height="35" Margin="100,120,0,0" VerticalAlignment="Top" Width="98" FontWeight="Normal" Foreground="White" Background="#FF252424"/>
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
                <Button x:Name="Done_Add_Team" Content="Anwenden" HorizontalAlignment="Center" Height="34" VerticalAlignment="Top" Width="196" FontWeight="Normal" Foreground="White" Background="#FF252424" Margin="0,307,0,0"/>
                <TextBlock x:Name="NIC_Team_Name_Text" HorizontalAlignment="Center" Margin="0,241,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="19" Width="196" FontWeight="Normal" Foreground="#FF89D47A" TextAlignment="Center" Text="Wie soll das NIC Teaming heissen?"/>
                <TextBox x:Name="Input_NIC_Team_Name" HorizontalAlignment="Center" TextWrapping="Wrap" VerticalAlignment="Top" Width="196" Height="19" TextAlignment="Center" Background="#FF252424" Foreground="White" Text="NIC-TEAM" Margin="0,262,0,0"/>
                <TextBlock x:Name="Hyper_V_not_installed" HorizontalAlignment="Center" Margin="0,350,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="18" Foreground="#FFDC5C5C" TextAlignment="Center"><Run Language="de-ch" Text="Hyper-V ist nicht installiert!"/></TextBlock>
                <RadioButton x:Name="Add_Team" Content="Erstellen&#xD;&#xA;" HorizontalAlignment="Center" Height="18" Margin="0,68,350,0" VerticalAlignment="Top" Width="74" Foreground="White" Background="White"/>
                <RadioButton x:Name="Remove_Team" Content="Löschen&#xD;&#xA;&#xA;" HorizontalAlignment="Center" Height="18" Margin="0,88,350,0" VerticalAlignment="Top" Width="74" Foreground="White" Background="White"/>
                <Rectangle HorizontalAlignment="Center" Height="50" Margin="0,60,350,0" Stroke="White" VerticalAlignment="Top" Width="102"/>
                <TextBlock x:Name="Team_Adapter_Value_Remove" HorizontalAlignment="Center" Margin="0,50,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="243" Height="19" TextAlignment="Center" Foreground="#FF89D47A" Text="Welches NIC-Teaming soll entfernt werden?"/>
                <ComboBox x:Name="Adapter_Value_Team_Remove" HorizontalAlignment="Center" Margin="0,70,0,0" VerticalAlignment="Top" Width="196" Text="Wähle deinen Adapter" BorderBrush="#FF707070" Foreground="Black" Background="#FF252424">
                    <ComboBoxItem Content="$adapter1_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter2_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter3_content"></ComboBoxItem> 
                    <ComboBoxItem Content="$adapter4_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter5_content"></ComboBoxItem>
                    <ComboBoxItem Content="$adapter6_content"></ComboBoxItem>
                </ComboBox>
                <Button x:Name="Done_Remove_Team" Content="Löschen" HorizontalAlignment="Center" Height="34" VerticalAlignment="Top" Width="196" FontWeight="Normal" Foreground="White" Background="#FF252424" Margin="0,307,0,0"/>
            </Grid>
        </TabItem>
    </TabControl>
</Window>
"@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

#‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾#
#->                                                                    Start                                                                    <-#
#_________________________________________________________________________________________________________________________________________________#

#--Sucht nach dem Button und führt darunter die Aktion aus--##
$IpAdressRenewButton = $window.FindName("ip_release_renew")
$settings_button = $window.FindName("settings_button")
$new_version_download = $window.FindName("new_version_download")
$No_Internet_Connection = $window.FindName("No_Internet_Connection")
$Adapter_Information_Field = $window.FindName("Adapter_Information_Field")
$NetAdapterSelect_Start = $window.FindName("NetAdapterSelect_Start")

#--Erstellt die Datei selected_start.sky und die anderen Dateien für die Speicherung des aktuell ausgewählten Netzwerk Adapters und weiteren Infos--##

$Selected_Path_identify_Start = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\selected_start.sky
if ($Test_Path_identify_Start -ne "True") {
Remove-Item C:\Sky-Scripts\Net-Adapter-Config\selected_start.sky
}
else {}

New-Item C:\Sky-Scripts\Net-Adapter-Config\selected_start.sky

$NetInformation_Name = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Name.sky
if ($NetInformation_Name -ne "True") {
Remove-Item C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Name.sky
}
else {}

New-Item C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Name.sky

$NetInformation_Description = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Description.sky
if ($NetInformation_Description -ne "True") {
Remove-Item C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Description.sky
}
else {}

New-Item C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Description.sky

$NetInformation_Status = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Status.sky
if ($NetInformation_Status -ne "True") {
Remove-Item C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Status.sky
}
else {}

New-Item C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Status.sky

$NetInformation_MacAddress = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\NetInformation_MacAddress.sky
if ($NetInformation_MacAddress -ne "True") {
Remove-Item C:\Sky-Scripts\Net-Adapter-Config\NetInformation_MacAddress.sky
}
else {}

New-Item C:\Sky-Scripts\Net-Adapter-Config\NetInformation_MacAddress.sky

$NetInformation_LinkSpeed = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\NetInformation_LinkSpeed.sky
if ($NetInformation_LinkSpeed -ne "True") {
Remove-Item C:\Sky-Scripts\Net-Adapter-Config\NetInformation_LinkSpeed.sky
}
else {}

New-Item C:\Sky-Scripts\Net-Adapter-Config\NetInformation_LinkSpeed.sky

#--Liest den aktuell ausgewählten Wert aus dem Dropdown Menu aus--##

$NetAdapterSelect_Start.add_SelectionChanged( {

    param($sender, $args)

    $selected = $sender.SelectedItem.Content

    # Die Leerzeichen vor und danach entfernen

    $selected_trim = $selected.trimstart().trimend()
    """$selected_trim""" | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected_start.sky


    #Schreibt den Wert in die IfIndex Nummer um und schreibt den Wert dann wieder in die Datei selected.sky #
    $content_get = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected.sky
    $IfIndex = (get-netadapter -name "$selected_trim").IfIndex | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected_start.sky
    $IfIndex_Info = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\selected_start.sky

    #Werte für die Informationsbox bereitstellen
    Get-NetAdapter -InterfaceIndex $IfIndex_Info | Select-Object -ExpandProperty 'Name' | Out-File C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Name.sky
    Get-NetAdapter -InterfaceIndex $IfIndex_Info | Select-Object -ExpandProperty 'InterfaceDescription' | Out-File C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Description.sky
    Get-NetAdapter -InterfaceIndex $IfIndex_Info | Select-Object -ExpandProperty 'Status' | Out-File C:\Sky-Scripts\Net-Adapter-Config\NetInformation_Status.sky
    Get-NetAdapter -InterfaceIndex $IfIndex_Info | Select-Object -ExpandProperty 'MacAddress' | Out-File C:\Sky-Scripts\Net-Adapter-Config\NetInformation_MacAddress.sky
    Get-NetAdapter -InterfaceIndex $IfIndex_Info | Select-Object -ExpandProperty 'LinkSpeed' | Out-File C:\Sky-Scripts\Net-Adapter-Config\NetInformation_LinkSpeed.sky

    Adapter_Information_Field_Update

})

##--Buton Action--##
$IpAdressRenewButton.Add_Click({
    $error.clear()
    try {
       ip_release_renew
    }
    catch {
       New-WPFMessageBox @ErrorMsgParams -Content "Die IP-Adresse konnt nicht neu bezogen werden"
    }
    if (!$error) {
       New-WPFMessageBox @WorkedParams -Content "Die IP-Adresse wurde erfolgreich neu bezogen"
    }
    
})
$settings_button.Add_Click({
    ncpa.cpl
})
$new_version_download.Add_Click({
    Start "https://github.com/Skyfay/Auto-NIC-Configurator/releases/latest"
})

#‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾#
#->                                                                  ShortCuts                                                                  <-#
#_________________________________________________________________________________________________________________________________________________#


#--Sucht nach dem Button und führt darunter die Aktion aus--##
$DhcpButton = $window.FindName("DhcpButton")
$CustomButton = $window.FindName("CustomButton")
$SecurepointButton = $window.FindName("SecurepointButton")
$NetAdapterSelect = $window.FindName("NetAdapterSelect")


#INTERNET CONNECTION FUNCTION

test_internet_connectivity


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
    $error.clear()
    try {
        dhcp
    }
    catch {
       New-WPFMessageBox @ErrorMsgParams -Content "Der Netzwerk Adapter konnte nicht auf DHCP umgestellt werden"
    }
    if (!$error) {
       New-WPFMessageBox @WorkedParams -Content "Der Netzwerk Adapter wurde erfolgreich auf DHCP umgestellt"
    }
})
$SecurepointButton.Add_Click({
    $error.clear()
    try {
        securepoint
    }
    catch {
       New-WPFMessageBox @ErrorMsgParams -Content "Der Netzwerk Adapter konnte nicht auf die Werte von Securepoint umgestellt werden"
    }
    if (!$error) {
       New-WPFMessageBox @WorkedParams -Content "Der Netzwerk Adapter wurde erfolgreich auf die Werte von Securepoint umgestellt"
    }
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

    $error.clear()
    try {
        custom
    }
    catch {
       New-WPFMessageBox @ErrorMsgParams -Content "Beim Ändern des Netzwerk Adapters ist ein unerwarteter Fehler aufgetreten"
    }
    if (!$error) {
       New-WPFMessageBox @WorkedParams -Content "Der Netzwerk Adapter wurde erfolgreich auf deine Werte konfiguriert"
    }
    
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

$team_remove_value_identify = Test-Path -Path C:\Sky-Scripts\Net-Adapter-Config\value_remove_team.sky
if ($team_remove_value_identify -eq "True") { 
    Remove-Item C:\Sky-Scripts\Net-Adapter-Config\value_remove_team.sky
}
else {}

New-Item C:\Sky-Scripts\Net-Adapter-Config\value_remove_team.sky

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

#Add

$Team_Adapter_Value = $window.FindName("Team_Adapter_Value")
$Adapter_Value_Team = $window.FindName("Adapter_Value_Team")
$NetAdapterSelect_Team = $window.FindName("NetAdapterSelect_Team")
$NetAdapterSelect_Team_2 = $window.FindName("NetAdapterSelect_Team_2")
$NetAdapterSelect_Team_3 = $window.FindName("NetAdapterSelect_Team_3")
$NetAdapterSelect_Team_4 = $window.FindName("NetAdapterSelect_Team_4")
$Team_Select_Adapter = $window.FindName("Team_Select_Adapter")
$NIC_Team_Name_Text = $window.FindName("NIC_Team_Name_Text")
$Input_NIC_Team_Name = $window.FindName("Input_NIC_Team_Name")
$Done_Add_Team = $window.FindName("Done_Add_Team")
$Hyper_V_not_installed = $window.FindName("Hyper_V_not_installed")
$Add_Team = $window.FindName("Add_Team")
$Remove_Team = $window.FindName("Remove_Team")

#Remove

$Team_Adapter_Value_Remove = $window.FindName("Team_Adapter_Value_Remove")
$Adapter_Value_Team_Remove = $window.FindName("Adapter_Value_Team_Remove")
$Done_Remove_Team = $window.FindName("Done_Remove_Team")

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
$Team_Adapter_Value_Remove.Visibility = "Hidden"

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

$Adapter_Value_Team_Remove.add_SelectionChanged({

    param($sender, $args)

    $selected = $sender.SelectedItem.Content

    # DIE LEERZEICHEN VOR UND DANACH ENTFERNEN

    $selected_trim = $selected.trimstart().trimend()
    "$selected_trim" | Set-Content -Path C:\Sky-Scripts\Net-Adapter-Config\value_remove_team.sky
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

$Done_Add_Team.Add_Click({

    $error.clear()
    try {
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
    }
    catch {
       New-WPFMessageBox @ErrorMsgParams -Content "Beim Erstellen vom NIC-Teaming ist ein Fehler aufgetreten."
    }
    if (!$error) {
       New-WPFMessageBox @WorkedParams -Content "Das NIC-Teaming wurde erfolgreich erstellt"
    }


})


 # WECHSELT ZWISCHEN "ADD UND REMOVE" TEAM SWITCH

$Add_Team.add_Checked({
    #Ausblenden
    $Team_Adapter_Value_Remove.Visibility = "Hidden"
    $Adapter_Value_Team_Remove.Visibility = "Hidden"
    $Done_Remove_Team.Visibility = "Hidden"
    #Einblenden
    $Team_Adapter_Value.Visibility = "Visible"
    $Adapter_Value_Team.Visibility = "Visible"
    $Done_Add_Team.Visibility = "Visible"
})



$Remove_Team.add_Checked({
    #Ausblenden
    $Team_Adapter_Value.Visibility = "Hidden"
    $Adapter_Value_Team.Visibility = "Hidden"
    $Done_Add_Team.Visibility = "Hidden"
    $Team_Select_Adapter.Visibility = "Hidden"
    $NetAdapterSelect_Team.Visibility = "Hidden"
    $NetAdapterSelect_Team_2.Visibility = "Hidden"
    $NetAdapterSelect_Team_3.Visibility = "Hidden"
    $NetAdapterSelect_Team_4.Visibility = "Hidden"
    $NIC_Team_Name_Text.Visibility = "Hidden"
    $Input_NIC_Team_Name.Visibility = "Hidden"
    #Einblenden
    $Team_Adapter_Value_Remove.Visibility = "Visible"
    $Adapter_Value_Team_Remove.Visibility = "Visible"
    $Done_Remove_Team.Visibility = "Visible"

})

$Done_Remove_Team.Add_Click({
    $value_team_remove = Get-Content -Path C:\Sky-Scripts\Net-Adapter-Config\value_remove_team.sky
    $error.clear()
    try {
        Remove-VMSwitch $value_team_remove
    }
    catch {
       New-WPFMessageBox @ErrorMsgParams -Content "Beim Löschen vom NIC-Teaming ist ein Fehler aufgetreten."
    }
    if (!$error) {
       New-WPFMessageBox @WorkedParams -Content "Das NIC-Teaming wurde erfolgreich gelöscht"
    }
})



 $window.ShowDialog() | Out-Null

