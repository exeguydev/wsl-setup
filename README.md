# 🚀 WSL Setup Script

### THIS IS MY FIRST PERSONAL SCRIPT! USE IT AT YOUR OWN RISK!
## If You Found A Bug, Please Report It.

Automated setup script for WSL2 development environment with Zsh, Powerlevel10k, and essential dev tools.

![Version](https://img.shields.io/badge/version-1.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## ✨ Features

- 🎨 **Beautiful output** - Colored text, spinners, and progress indicators
- ⚡ **Fast setup** - Everything installed in one command
- 🛠️ **Dev-ready** - Neovim, Git, Zsh, and essential tools pre-configured
- 🎯 **Powerlevel10k** - Auto-installed and configured
- 🔄 **Idempotent** - Safe to run multiple times

## 📦 What Gets Installed

| **Shell** | Zsh, Oh-My-Zsh, Powerlevel10k |
| **Editor** | Neovim (basic config included) |
| **Terminal** | Kitty |
| **Utilities** | fzf, ripgrep, bat, eza, tree, htop, ncdu, jq |
| **Dev Tools** | Git, curl, wget, build-essential |
| **Archives** | zip, unzip, p7zip-full |

## 🚀 Quick Start

### 1. Clone the repository

```
git clone https://github.com/ExeGuyDev/wsl-setup.git
cd wsl-setup
```

### 2. Make the script executable
```
chmod +x install-wsl.sh
```

### 3. Run the installer
```
./install-wsl.sh
```

### 4. Restart your shell
```
exec zsh
```

### 5. Complete Powerlevel10k setup
 Follow the Wizard

 📋 Requirements

    WSL2 installed
    Debian or Ubuntu distribution
    Internet connection
    ~500MB free disk space

🛠️ Customization
Feel free to modify the script to fit your needs:

    Add/remove packages in Step 3
    Change Neovim config in Step 5
    Add your own dotfiles configuration

🤝 Contributing

    Fork the repo
    Create your feature branch (git checkout -b feature/AmazingFeature)
    Commit your changes (git commit -m 'Add some AmazingFeature')
    Push to the branch (git push origin feature/AmazingFeature)
    Open a Pull Request

📝 License
This project is licensed under the MIT License - see the LICENSE
 file for details.
🙏 Acknowledgments

    Powerlevel10k - Amazing Zsh theme
    Oh-My-Zsh - Zsh framework
    Neovim - Best editor ever
