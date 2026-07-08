# WSTunnel Install Script

A simple Bash script to quickly install and configure **wstunnel** on Ubuntu for WireGuard.

## Requirements

* Ubuntu or Debian
* Root or sudo privileges
* Internet connection

## Installation

Clone the repository:

```bash
git clone https://github.com/Laurens8006/wstunnel-install-script.git
cd wstunnel-install-script
```

Make the script executable:

```bash
chmod +x install.sh
```

Run the installer:

```bash
sudo ./install.sh
```

## Usage

After installation, verify that wstunnel is installed:

```bash
wstunnel --version
```

For available options:

```bash
wstunnel --help
```

## WireGuard (Windows) Full Tunnel Notice

If you use WireGuard with:

```ini
AllowedIPs = AllowedIPs = 0.0.0.0/1, 128.0.0.0/1
```

WireGuard will attempt to send **all traffic** through the VPN. Since the wstunnel client itself also needs an Internet connection to reach the server, this can create a routing loop and cause the tunnel to disconnect.

To prevent this, add a route on the Windows client so that traffic to your **wstunnel server IP** always uses the normal network interface.

Replace `YOURWSTUNNELIP` with your server's public IP address:

```powershell
$route = Get-NetRoute -DestinationPrefix "0.0.0.0/0" |
    Where-Object {$_.NextHop -ne "0.0.0.0"} |
    Sort-Object RouteMetric |
    Select-Object -First 1

New-NetRoute -DestinationPrefix "YOURWSTUNNELIP/32" `
    -InterfaceIndex $route.InterfaceIndex `
    -NextHop $route.NextHop
```

When you disconnect, you can remove the route:

```powershell
Remove-NetRoute -DestinationPrefix "YOURWSTUNNELIP/32" -Confirm:$false
```

> **Note:** WireGuard for Windows does **not** support the `PostUp` and `PreDown` options that are available on Linux. The route must be added manually or by using your own PowerShell script.

## Uninstall

Remove the binary manually if needed:

```bash
sudo rm -f /usr/local/bin/wstunnel
```

*(Adjust the installation path if your script installs it elsewhere.)*

## License

This project is released under the MIT License unless stated otherwise.
