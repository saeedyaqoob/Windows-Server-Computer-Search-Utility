<#
.SYNOPSIS
    Windows Server / Computer Search Utility

.DESCRIPTION
    GUI-based tool that searches for computer objects across multiple
    Active Directory domains and displays key attributes.

.NOTES
    Version:        1.2.1
    PowerShell:     7.x
    Requirements:   ActiveDirectory module
#>

# Hide console window
Add-Type -Name Win32 -Namespace Console -MemberDefinition @"
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
"@

$consolePtr = [Console.Win32]::GetConsoleWindow()
[Console.Win32]::ShowWindow($consolePtr, 0)   # 0 = Hide

Add-Type -AssemblyName System.Windows.Forms

# Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Server / Computer Search Utility"
$form.Size = New-Object System.Drawing.Size(600,650)
$form.StartPosition = "CenterScreen"

# Label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Enter Server/Computer Name:"
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(200,20)
$form.Controls.Add($label)

# Input Textbox
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(220,20)
$textBox.Size = New-Object System.Drawing.Size(330,20)
$form.Controls.Add($textBox)

# Output box
$resultsBox = New-Object System.Windows.Forms.TextBox
$resultsBox.Location = New-Object System.Drawing.Point(10,80)
$resultsBox.Size = New-Object System.Drawing.Size(550,520)
$resultsBox.Multiline = $true
$resultsBox.ScrollBars = "Vertical"
$resultsBox.Font = New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Regular)
$form.Controls.Add($resultsBox)

# Label 2
$label2 = New-Object System.Windows.Forms.Label
$label2.Text = "Select organization:"
$label2.Location = New-Object System.Drawing.Point(10,45)
$label2.Size = New-Object System.Drawing.Size(200,20)
$form.Controls.Add($label2)

# Dropdown
$ComboBox1 = New-Object System.Windows.Forms.ComboBox
$ComboBox1.Location = New-Object System.Drawing.Point(220,45)
$ComboBox1.Size = New-Object System.Drawing.Size(150,20)

# Generic placeholder org names
$ComboBox1.Items.Add("ORG-A")
$ComboBox1.Items.Add("ORG-B")
$ComboBox1.Items.Add("ORG-C")
$ComboBox1.Items.Add("ORG-D")
$ComboBox1.Items.Add("ORG-E")

$ComboBox1.SelectedIndex = 0
$form.Controls.Add($ComboBox1)

# Search button
$button = New-Object System.Windows.Forms.Button
$button.Text = "Search"
$button.Location = New-Object System.Drawing.Point(475,45)
$button.Size = New-Object System.Drawing.Size(75,23)

$button.Add_Click({

    $resultsBox.Clear()

    # Domain lists (sanitized placeholders)
    switch ($ComboBox1.SelectedIndex) {
        0 { $ADForests = @("domainA.local","subA.domainA.local") }
        1 { $ADForests = @("domainB.local","subB.domainB.local") }
        2 { $ADForests = @("domainC.local") }
        3 { $ADForests = @("domainD.local") }
        4 { $ADForests = @("domainE.local") }
    }

    $name = $textBox.Text.Trim()

    if ([string]::IsNullOrWhiteSpace($name)) {
        $info = "Please enter a valid computer/server name."
    }
    else {
        $Flag = $false
        :outerLoop foreach ($domain in $ADForests) {
            try {
                $obj = Get-ADComputer -Server $domain -Filter { name -eq $name }
                if ($obj) {
                    $results = Get-ADComputer -Server $domain -Filter { name -eq $name } -Properties * |
                        Select-Object Enabled,Name,SamAccountName,CanonicalName,DNSHostName,
                                      DistinguishedName,IPv4Address,OperatingSystem,
                                      OperatingSystemVersion,Created,ObjectClass
                    $Flag = $true
                    break outerLoop
                }
            }
            catch {}
        }

        if ($Flag) {
            $info = @"
Enabled:
$($results.Enabled)

Name:
$($results.Name)

SamAccountName:
$($results.SamAccountName)

CanonicalName:
$($results.CanonicalName)

DNSHostName:
$($results.DNSHostName)

DistinguishedName:
$($results.DistinguishedName)

IPv4Address:
$($results.IPv4Address)

OperatingSystem:
$($results.OperatingSystem)

OperatingSystemVersion:
$($results.OperatingSystemVersion)

Created:
$($results.Created)

ObjectClass:
$($results.ObjectClass)
"@
        }
        else {
            $info = "Unable to locate computer: $name"
        }
    }

    $resultsBox.Text = $info
})

$form.Controls.Add($button)

[void]$form.ShowDialog()
