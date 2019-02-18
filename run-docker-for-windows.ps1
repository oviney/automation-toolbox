# start VcXsrv if it is not started yet
$prog="$env:ProgramFiles\VcXsrv\vcxsrv.exe"
if (! (ps | ? {$_.path -eq $prog})) {& $prog -multiwindow -ac}

# get the IP address used by Docker for Windows
#| where {$_.InterfaceAlias -eq 'vEthernet (DockerNAT)' -and $_.AddressFamily -eq 'IPv4'} `
$ip = Get-NetIPAddress `
    | where {$_.InterfaceAlias -eq 'vEthernet (DockerNAT)' -and $_.AddressFamily -eq 'IPv4'} `
    | select -ExpandProperty IPAddress

echo $ip

# start Visual Studo Code as the vscode user
#$cmd="export DISPLAY=${ip}:0; intellij-idea-community"
#docker run --rm -it --security-opt seccomp=unconfined oviney/test-automation-toolbox su - developer -c $cmd
#docker run --rm -it --security-opt seccomp=unconfined --name toolbox oviney/test-automation-toolbox:latest sudo su - developer -c $cmd
docker run --rm -it --security-opt seccomp=unconfined --name toolbox oviney/test-automation-toolbox:latest
$cmd="code -w ."
set-variable -name DISPLAY -value ${ip}:0.0
echo $DISPLAY
docker run -ti -e DISPLAY=$DISPLAY --rm --security-opt seccomp=unconfined --name toolbox-intellij oviney/test-automation-toolbox:latest
