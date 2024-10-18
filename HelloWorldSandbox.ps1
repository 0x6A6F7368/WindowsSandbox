# Create Sandbox Directory
New-Item -Path "C:\SandboxFiles" -ItemType Directory
New-Item -Path "C:\SandboxFiles\Shared" -ItemType Directory

# Create environment and configuration for HelloWorldSandbox
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
    <Command>powershell -command "Start-Process cmd.exe -ArgumentList '/c C:\SandboxFiles\Shared\HelloWorld.bat'"</Command>
  </LogonCommand>
</Configuration>
"@ | Out-File -FilePath "C:\SandboxFiles\HelloWorld.wsb" -Encoding UTF8


# This is the code that is run when the sandbox starts
@"
echo "Hello World"
pause
"@ | Out-File -FilePath "C:\SandboxFiles\Shared\HelloWorld.bat" -Encoding UTF8

# Run the Sandbox
WindowsSandbox "C:\SandboxFiles\HelloWorld.wsb"