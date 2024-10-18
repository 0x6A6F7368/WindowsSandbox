# Create temp file
New-Item -Path "C:\SandboxFiles" -ItemType Directory
New-Item -Path "C:\SandboxFiles\Temp" -ItemType Directory
New-Item -Path "C:\SandboxFiles\Shared" -ItemType Directory

# Download and extract Libre Office Portable. There are some manual steps dueing the extraction.
Invoke-WebRequest -Uri "https://download.documentfoundation.org/libreoffice/portable/24.8.2/LibreOfficePortable_24.8.2_MultilingualStandard.paf.exe" -OutFile "C:\SandboxFiles\Temp\LibreOfficePortable_24.8.2_MultilingualStandard.paf.exe"
Start-Process "C:\SandboxFiles\Temp\LibreOfficePortable_24.8.2_MultilingualStandard.paf.exe" -ArgumentList "/DESTINATION=C:\SandboxFiles\Shared\" -Wait

# Create environment and configuration for LibreOfficeSandbox
@"
<Configuration>
  <MappedFolders>
    <MappedFolder>
      <HostFolder>C:\SandboxFiles\Shared</HostFolder>
      <SandboxFolder>C:\SandboxFiles\Shared</SandboxFolder>
      <ReadOnly>true</ReadOnly>
    </MappedFolder>
  </MappedFolders>
  <LogonCommand>
    <Command>powershell -command "Start-Process cmd.exe -ArgumentList '/c C:\SandboxFiles\Shared\LibreOffice.bat'"</Command>
  </LogonCommand>
</Configuration>
"@ | Out-File -FilePath "C:\SandboxFiles\LibreOffice.wsb" -Encoding UTF8


# This is the code that is run when the sandbox starts
@"
@echo off
xcopy "C:\SandboxFiles\Shared\LibreOfficePortable" "C:\Users\WDAGUtilityAccount\Desktop\LibreOfficePortable" /E /I /Y
start "" "C:\Users\WDAGUtilityAccount\Desktop\LibreOfficePortable\LibreOfficePortable.exe"
"@ | Out-File -FilePath "C:\SandboxFiles\Shared\LibreOffice.bat" -Encoding UTF8

# Run the Sandbox
WindowsSandbox "C:\SandboxFiles\LibreOffice.wsb"