🖥️ Windows Server / Computer Search Utility
A lightweight PowerShell GUI tool for searching computer objects across multiple Active Directory domains.
This utility provides a simple graphical interface that allows administrators to quickly locate Windows servers or workstations, retrieve key AD attributes, and display them in an easy‑to‑read format.

📌 Features
- GUI built with Windows Forms
- Search for computers across multiple AD domains
- Selectable organization/domain groups
- Displays detailed AD attributes:
- Enabled status
- Name
- SamAccountName
- CanonicalName
- DNSHostName
- DistinguishedName
- IPv4 Address
- Operating System
- OS Version
- Created date
- ObjectClass
- Clean, scrollable output window
- Console window hidden for a cleaner user experience

📁 Requirements
- PowerShell 7.x
- ActiveDirectory module
- Install via RSAT or:
Install-WindowsFeature RSAT-AD-PowerShell
- Windows OS with .NET Framework support for WinForms

🚀 How to Use
- Clone or download the repository.
- Ensure the script is unblocked:
Unblock-File .\ServerSearchUtility.ps1
- Run the script:
pwsh .\ServerSearchUtility.ps1
- In the GUI:
- Enter a computer/server name
- Select an organization/domain group
- Click Search
- Results will appear in the output window.

🧩 Domain Configuration
The script uses placeholder domain names for public sharing:
$ADForests = @("domainA.local", "subA.domainA.local")

You can replace these with your real internal domains:
$ADForests = @(
    "corp.example.com",
    "subdomain.example.com"
)

Each organization dropdown entry corresponds to a domain list in the script.

🛠️ Customization
You can easily modify:
- Organization names in the dropdown
- Domain lists
- Displayed AD attributes
- GUI layout (labels, fonts, sizes)

📷 Screenshot 
<img width="361" height="401" alt="image" src="https://github.com/user-attachments/assets/660eccd7-551f-402e-b96b-a4a35f9e9e88" />

🤝 Contributing
Pull requests and suggestions are welcome.
Feel free to open an issue for enhancements or bug reports.
