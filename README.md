# WSTunnel Install Script

A simple Bash script to quickly install and configure **wstunnel** on Ubuntu

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
## Uninstall

Remove the binary manually if needed:

```bash
sudo rm -f /usr/local/bin/wstunnel
```

*(Adjust the installation path if your script installs it elsewhere.)*

## License

This project is released under the MIT License unless stated otherwise.

