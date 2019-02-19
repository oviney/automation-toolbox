[![CircleCI](https://circleci.com/gh/oviney/test-automation-toolbox.svg?style=svg)](https://circleci.com/gh/oviney/test-automation-toolbox)

# test-automation-toolbox
How long does it take to set up your test automation development environment? How long does it take a new automation engineer on your team to set up their dev environment? Say you want to try out a new programming language, how much time do you spend figuring out what tools to use before you actually try out the language?

## Requirements
- Be able to `git clone` a project
- Type a single command and be able to edit and debug it
- The IDE tailored to the language and domain of the project

In this README, we will illustrate how to simplify the development experience using recent releases from Ubuntu, Intellij and Docker with the age-old X Window forwarding.  This tutorial focuses on Windows as your base operating system.

# Preprequisite Software
This section outlines the prerequisite software you need installed on your local system to get this all running.
- Windows 10 Pro (adaptable for other OS's)
- Docker - grab it [here](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
- Git - grab it [here](https://git-scm.com/download/win)
- [X Windows Server](https://sourceforge.net/projects/vcxsrv/) (see details below)
- (Optional) [Chocolatey Windows package manager](https://chocolatey.org/)

## Chocolatey Windows Package Manager Installation
`@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"`

For additional details [see...](https://chocolatey.org/install)

## X Windows Server on Windows
[VcXsrv](https://sourceforge.net/projects/vcxsrv/) looks like a good choice for an X Server on Windows. It is free, maintained, has good ratings, automatable, and easy to install via Chocolatey (*you may choose this approach*): `choco install -y vcxsrv`. 

That installed the most recent 64-bit version vcxsrv v1.20.1.4  released in Jan 2019 on my machine.

# How to use it?  Start the Container and Get Your Prefered IDE Running
## Basic steps to use

### Git clone test-automation-toolbox 
`git clone https://github.com/oviney/test-automation-toolbox.git`

### Build Docker image
- Navigate into `test-automation-toolbox` directory and build the Docker image using `/build.sh` or `build.bat`

### Run Docker image
- Run the Docker image  `startIntellij.bat` or `startIntellij.sh` or run the powershell script.  I typically open the powershell script and run it in the PowerShell IDE (default with Windows 10 Pro).  
- You should see an Intellij window open on your system

### Next steps using the Docker container daily
One thing I noticed was I wanted to automate the manual steps to encourage me to use it.  So, here are a few of my favourite hacks.

- Run Docker container, fire up Intellij, using local git repo (on laptop), using Docker image to store the IDE preferences and plugins.  
> Note:  When you choose to store IDE preferences and plugins in the Docker container, you run `docker run ...` the container only once, then after that you start `docker start ...` the container.  Details on the difference below.  If you don't do it this way, you'll lose your data.

```PowerShell # start VcXsrv if it is not started yet
$prog="$env:ProgramFiles\VcXsrv\vcxsrv.exe"
if (! (ps | ? {$_.path -eq $prog})) {& $prog -multiwindow -ac}

# get the IP address used by Docker for Windows
$ip = Get-NetIPAddress `
    | where {$_.InterfaceAlias -eq 'vEthernet (DockerNAT)' -and $_.AddressFamily -eq 'IPv4'} `
    | select -ExpandProperty IPAddress
echo $ip

# start 
$cmd="intellij-idea-community"
set-variable -name DISPLAY -value ${ip}:0.0
echo $DISPLAY
docker run --rm `
    -e DISPLAY=$DISPLAY `
    --security-opt seccomp=unconfined `
    --name toolbox-intellij `
    oviney/test-automation-toolbox:latest 
```
    
 - Start Docker container (*data from previous sessions persisted*), fire up Intellij, using local git repo (on laptop), using Docker image to store the IDE preferences and plugins.
 
 ```Batch
 C:\Users\ouray>docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

C:\Users\ouray>docker images
REPOSITORY                       TAG                 IMAGE ID            CREATED             SIZE
oviney/test-automation-toolbox   latest              fcffde991fb6        5 minutes ago       1.97GB
oviney/ubuntu-vscode             latest              df830a104655        20 minutes ago      517MB
<none>                           <none>              3ac3b3403a11        About an hour ago   1.97GB
<none>                           <none>              96c337546fe4        2 hours ago         517MB
<none>                           <none>              9cc8e8ecef83        2 hours ago         517MB
ubuntu                           latest              47b19964fb50        12 days ago         88.1MB

C:\Users\ouray>docker ps -a
CONTAINER ID        IMAGE                                   COMMAND                  CREATED             STATUS              PORTS               NAMES
0f4787510f67        oviney/test-automation-toolbox:latest   "/bin/sh -c intellij…"   23 minutes ago      Up 23 minutes                           toolbox-intellij
 ```
 
 Grab the container id for the desired container.  For me, this is `0f4787510f67`.  Let's use that to start *restart* the Docker container.
 
To restart an existing container, we'll use the start command with the `-a` flag to attach to it and the `-i` flag to make it interactive, followed by either the container ID or name. Be sure to substitute the ID of your container in the command below:

> Note:  I removed the following argument from the `docker run...` command; ```--rm		Automatically remove the container when it exits```

 ```Batch
 
 ```
