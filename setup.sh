#!/bin/bash

# Where Command Setup Script
# Installs the 'where' command to your system

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SCRIPT="$SCRIPT_DIR/where.sh"
INSTALL_PATH="${1:-/usr/local/bin/where}"


# Functions
print_header() {
    echo -e "${BLUE}=====================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=====================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

check_requirements() {
    print_header "Checking Requirements"
    
    if [[ ! -f "$SOURCE_SCRIPT" ]]; then
        print_error "where.sh not found at $SOURCE_SCRIPT"
        exit 1
    fi
    print_success "where.sh found"
    
    if ! command -v bash &> /dev/null; then
        print_error "bash is required but not installed"
        exit 1
    fi
    print_success "bash is available"
}

install_command() {
    print_header "Installing 'where' Command"
    
    # Create the installation directory if needed
    local install_dir=$(dirname "$INSTALL_PATH")
    if [[ ! -d "$install_dir" ]]; then
        print_info "Creating directory: $install_dir"
        mkdir -p "$install_dir" || {
            print_error "Failed to create $install_dir. Try with sudo."
            exit 1
        }
    fi
    
    # Install the script directly as 'where'
    if sudo cp "$SOURCE_SCRIPT" "$INSTALL_PATH" 2>/dev/null || cp "$SOURCE_SCRIPT" "$INSTALL_PATH"; then
        print_success "Installed script to $INSTALL_PATH"
    else
        print_error "Failed to install script to $INSTALL_PATH"
        exit 1
    fi
    
    # Make it executable
    if sudo chmod +x "$INSTALL_PATH" 2>/dev/null || chmod +x "$INSTALL_PATH"; then
        print_success "Made $INSTALL_PATH executable"
    else
        print_error "Failed to make $INSTALL_PATH executable"
        exit 1
    fi
}

verify_installation() {
    print_header "Verifying Installation"
    
    if ! command -v where &> /dev/null; then
        print_info "Adding $INSTALL_PATH to PATH temporarily..."
        export PATH="$(dirname "$INSTALL_PATH"):$PATH"
    fi
    
    # Test the command
    if where bash &> /dev/null; then
        print_success "where command is working!"
        print_info "Found bash at: $(where bash)"
    else
        print_error "where command test failed"
        exit 1
    fi
}

show_usage() {
    print_header "Usage Examples"
    echo "Find a single command:"
    echo "  where ls"
    echo ""
    echo "Find multiple commands:"
    echo "  where bash grep ls"
    echo ""
    echo "Find a specific path:"
    echo "  where /bin/ls"
    echo ""
    echo "Get help:"
    echo "  where --help"
}

show_summary() {
    print_header "Installation Complete!"
    print_success "The 'where' command has been installed successfully"
    echo ""
    echo "Installation path:"
    echo "  $INSTALL_PATH"
    echo ""
    
    if ! echo "$PATH" | grep -q "$(dirname "$INSTALL_PATH")"; then
        print_info "Note: $(dirname "$INSTALL_PATH") is not in your PATH"
        print_info "Add it with: export PATH=\"\$(dirname \"$INSTALL_PATH\"):\$PATH\""
    fi
    
    show_usage
}

# Main installation flow
main() {
    print_header "Where Command Setup"
    
    check_requirements
    install_command
    verify_installation
    show_summary
}

# Run main function
main
