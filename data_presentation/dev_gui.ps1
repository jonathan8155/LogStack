# License: https://github.com/jonathan8155/LogStack/blob/master/LICENSE

# Add assemblies
Add-Type -AssemblyName PresentationFramework, PresentationCore

#region Functions
function MenuClick {
    # Function ensures the button clicked in that menu checked.
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][array]$EventArgs,
        [Parameter(Mandatory=$true)][array]$MenuButtons
    )
    Write-Verbose "MenuClick function called..."
    $trigger = ($EventArgs[0]).Name
    foreach ($button in $MenuButtons) {
        if ($button.Name -eq $trigger) {$button.IsChecked = $true}
        else {$button.IsChecked = $false}
    }
}

function LoadData {
    param (
        [Parameter(Mandatory=$true)][array]$Categories
    )
    
}
#endregion

# Load and Parse xaml
[xml]$xaml = Get-Content -Path .\main_window.xaml -Raw
$reader = [System.Xml.XmlNodeReader]::new($xaml)

# Create main window
$MainWindow = [Windows.Markup.XamlReader]::Load($reader)

# Id inputs/outputs/buttons, and assign handlers.

## Application Menu Buttons
$Configuration = $MainWindow.FindName("Configuration")
$Exit = $MainWindow.FindName("Exit")
$Configuration.Add_Click({Write-Host "Configuration button was clicked"})
$Exit.Add_Click({
    Write-Host "Exit menu button clicked... Closing window." -ForegroundColor Yellow
    $MainWindow.Close()
    Write-Host "Now exiting" -ForegroundColor Yellow
    exit
})

## TimeFrame Menu Buttons
$TimeFrameMenuButtons = @(
    $MainWindow.FindName("Last24Hours"),
    $MainWindow.FindName("Last7Days"),
    $MainWindow.FindName("Last2Weeks"),
    $MainWindow.FindName("Last1Month")
)

## TimeFrame Menu Buttons Event Handlers
foreach ($button in $TimeFrameMenuButtons) {
    $button.Add_Click({MenuClick -EventArgs $args -MenuButtons $TimeFrameMenuButtons})
}

## Event Category Menu Buttons
$EventCategoryMenuButtons = @(
    $MainWindow.FindName("UserAccountManagement"),
    $MainWindow.FindName("UserGroupCreationDeletion"),
    $MainWindow.FindName("UserGroupChanges")
)

## Event Category Menu Button Event Handlers
foreach ($button in $EventCategoryMenuButtons) {
    $button.Add_Click({
        MenuClick -EventArgs $args -MenuButtons $EventCategoryMenuButtons
    })
}


$TestData = @(
    [PSCustomObject]@{Property1 = "first item, first property"; Property2 = "first item, second property"},
    [PSCustomObject]@{Property1 = "second item, first property"; Property2 = "second item, second property"},
    [PSCustomObject]@{Property1 = "third item, first property"; Property2 = "third item, second property"},
    [PSCustomObject]@{Property1 = "fourth item, first property"; Property2 = "fourth item, second property"}
)


$DataGrid = $MainWindow.FindName("TestDataGrid")
$DataGrid.ItemsSource = $TestData






## Other


# Show the window
$MainWindow.ShowDialog()