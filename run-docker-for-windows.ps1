# start VcXsrv if it is not started yet
$prog="$env:ProgramFiles\VcXsrv\vcxsrv.exe"
if (! (ps | ? {$_.path -eq $prog})) {& $prog -multiwindow -ac}

# get the IP address used by Docker for Windows
#| where {$_.InterfaceAlias -eq 'vEthernet (DockerNAT)' -and $_.AddressFamily -eq 'IPv4'} `
$ip = Get-NetIPAddress `
    | where {$_.InterfaceAlias -eq 'vEthernet (Default Switch)' -and $_.AddressFamily -eq 'IPv4'} `
    | select -ExpandProperty IPAddress

echo $ip

# start Visual Studo Code as the vscode user
$cmd="intellij-idea-community"
set-variable -name DISPLAY -value ${ip}:0.0
echo $DISPLAY
# -v C:\Users\ouray\OneDrive\DEV:/home/developer/.IdeaIC2018.3 `
# --rm 
docker run `
    -v C:\Users\ouray\OneDrive\DEV:/mnt/onedrive `
    -e DISPLAY=$DISPLAY `
    --security-opt seccomp=unconfined `
    --name toolbox-intellij `
    oviney/test-automation-toolbox:latest