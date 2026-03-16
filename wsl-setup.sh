#!/bin/bash
#===============================================================================
#
#          FILE: install-wsl.sh
#
#         USAGE: ./install-wsl.sh
#
#   DESCRIPTION: Automated WSL setup script with Zsh, Powerlevel10k, and dev tools
#
#       OPTIONS: None
#  REQUIREMENTS: WSL2, Debian/Ubuntu
#          BUGS: Probably none, but who knows ¯\_(ツ)_/¯
#         NOTES: Feel free to modify and make it your own
#        AUTHOR: ExeGuy
#       CREATED: 2026-03-15
#       VERSION: 2.1
#
#===============================================================================

set -e

#-------------------------------------------------------------------------------
# Colors
#-------------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

#-------------------------------------------------------------------------------
# Helper Functions
#-------------------------------------------------------------------------------

print_header() {
    echo ""
    echo -e "${PURPLE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC} ${WHITE}$1${NC} ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}┌─────────────────────────────────────────────────────${NC}"
    echo -e "${BLUE}│${NC} ${CYAN}►${NC} ${WHITE}$1${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

spinner() {
    local pid=$1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep -w $pid)" ]; do
        local temp=${spinstr#?}
        printf "\r${CYAN}[%c]${NC} " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep 0.1
    done
    printf "\r${GREEN}[✓]${NC} "
}

#-------------------------------------------------------------------------------
# Main Script
#-------------------------------------------------------------------------------

print_header "🚀 ExeGuy's WSL Setup Script v2.1"
echo -e "${WHITE}Setting up your development environment...${NC}"
echo ""

#-------------------------------------------------------------------------------
# Step 1: Update system
#-------------------------------------------------------------------------------
print_step "Step 1/5: Updating system packages"
sudo apt update -qq
sudo apt upgrade -y -qq
print_success "System updated"
echo ""

#-------------------------------------------------------------------------------
# Step 2: Install base dependencies
#-------------------------------------------------------------------------------
print_step "Step 2/5: Installing base dependencies"
sudo apt install --no-install-recommends -y -qq \
    ca-certificates curl wget git openssh-client gnupg \
    build-essential
print_success "Base dependencies installed"
echo ""

#-------------------------------------------------------------------------------
# Step 3: Install development tools
#-------------------------------------------------------------------------------
print_step "Step 3/5: Installing development tools"
sudo apt install --no-install-recommends -y -qq \
    zsh neovim kitty \
    fzf ripgrep bat eza \
    tree htop ncdu jq \
    unzip zip p7zip-full \
    man-db fastfetch nmap
print_success "Development tools installed"
echo ""

#-------------------------------------------------------------------------------
# Step 4: Setup Zsh + Oh-My-Zsh + Powerlevel10k
#-------------------------------------------------------------------------------
print_step "Step 4/5: Configuring Zsh + Powerlevel10k"

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    print_warning "Restart your terminal or run: exec zsh"
fi

# Install Oh-My-Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${CYAN}Installing Oh-My-Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh-My-Zsh installed"
else
    print_success "Oh-My-Zsh already installed"
fi

# Install Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo -e "${CYAN}Cloning Powerlevel10k...${NC}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    print_success "Powerlevel10k installed"
else
    print_success "Powerlevel10k already installed"
fi

# Configure .zshrc
if ! grep -q 'powerlevel10k' ~/.zshrc 2>/dev/null; then
    echo -e "${CYAN}Configuring .zshrc...${NC}"
    
    # Backup existing .zshrc
    cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
    
    # Replace theme line
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
    
    # If not found, append to end
    if ! grep -q 'ZSH_THEME="powerlevel10k' ~/.zshrc; then
        echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
    fi
    
    print_success "Powerlevel10k configured in .zshrc"
else
    print_success "Powerlevel10k already configured"
fi

# Install zsh plugins
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo -e "${CYAN}Installing zsh plugins...${NC}"
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
        "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
        "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    print_success "Plugins installed"
else
    print_success "Plugins already installed"
fi

# Enable plugins in .zshrc
if ! grep -q 'zsh-autosuggestions' ~/.zshrc 2>/dev/null; then
    sed -i 's/^plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
    print_success "Plugins enabled in .zshrc"
fi

echo ""

#-------------------------------------------------------------------------------
# Step 5: Configure Neovim and Git
#-------------------------------------------------------------------------------
print_step "Step 5/5: Configuring Neovim and Git"

# Create Neovim config directory
mkdir -p ~/.config/nvim

# Basic Neovim config
cat > ~/.config/nvim/init.vim << 'EOF'
" ExeGuy's minimal Neovim config
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set termguicolors
set mouse=a
let mapleader=" "

" Keybindings
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>
EOF
print_success "Neovim configured"

# Configure Git (only if not already set)
if ! git config --global user.name >/dev/null 2>&1; then
    read -p "Enter your Git name: " GIT_NAME
    read -p "Enter your Git email: " GIT_EMAIL
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    print_success "Git configured"
else
    print_success "Git already configured"
fi

echo ""

#-------------------------------------------------------------------------------
# Done!
#-------------------------------------------------------------------------------
print_header "🎉 Setup Complete!"

echo -e "${WHITE}Next steps:${NC}"
echo -e "  ${CYAN}1.${NC} Restart terminal or run: ${YELLOW}exec zsh${NC}"
echo -e "  ${CYAN}2.${NC} Complete Powerlevel10k wizard (arrows + Y)"
echo -e "  ${CYAN}3.${NC} Verify installation: ${YELLOW}nvim${NC}, ${YELLOW}kitty${NC}, ${YELLOW}git${NC}"
echo -e "  ${CYAN}4.${NC} Setup SSH for GitHub (if needed)"
echo ""

echo -e "${PURPLE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║${NC}        ${GREEN}💪 Your WSL dev environment is ready!${NC}        ${PURPLE}║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
