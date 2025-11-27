#!/usr/bin/env bash

# =============================================================================
# Research Workflow Setup Script
# Claude + Codex + Gemini Configuration Wizard
# =============================================================================

set -euo pipefail

# Colors for beautiful UI
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

# Icons
readonly CHECK="✓"
readonly CROSS="✗"
readonly ARROW="→"
readonly STAR="★"
readonly INFO="ℹ"
readonly WARN="⚠"

# Log file
readonly LOG_FILE="/tmp/claude-team-setup.log"

# =============================================================================
# Logging Functions
# =============================================================================

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $*" >> "$LOG_FILE"
}

log_success() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $*" >> "$LOG_FILE"
}

# =============================================================================
# UI Functions
# =============================================================================

print_header() {
    echo -e "\n${CYAN}${BOLD}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║${NC}  ${STAR} ${MAGENTA}${BOLD}Research Workflow Setup Wizard${NC}                    ${CYAN}${BOLD}║${NC}"
    echo -e "${CYAN}${BOLD}║${NC}     Claude + Codex + Gemini Integration               ${CYAN}${BOLD}║${NC}"
    echo -e "${CYAN}${BOLD}╚════════════════════════════════════════════════════════════╝${NC}\n"
}

print_step() {
    echo -e "${BLUE}${BOLD}${ARROW} $1${NC}"
    log "STEP: $1"
}

print_success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
    log_success "$1"
}

print_error() {
    echo -e "${RED}${CROSS} $1${NC}"
    log_error "$1"
}

print_warning() {
    echo -e "${YELLOW}${WARN} $1${NC}"
    log "WARNING: $1"
}

print_info() {
    echo -e "${CYAN}${INFO} $1${NC}"
    log "INFO: $1"
}

print_separator() {
    echo -e "${CYAN}────────────────────────────────────────────────────────────${NC}"
}

# =============================================================================
# Utility Functions
# =============================================================================

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

ask_yes_no() {
    local prompt="$1"
    local default="${2:-n}"

    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi

    while true; do
        echo -ne "${YELLOW}${prompt}${NC}"
        read -r response

        case "${response:-$default}" in
            [yY]|[yY][eE][sS])
                return 0
                ;;
            [nN]|[nN][oO])
                return 1
                ;;
            *)
                echo -e "${RED}Please answer yes or no.${NC}"
                ;;
        esac
    done
}

backup_file() {
    local file="$1"

    if [[ -f "$file" ]]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$file" "$backup"
        print_warning "Backed up existing file: $file → $backup"
        log "Backup created: $backup"
        return 0
    fi
    return 1
}

# =============================================================================
# Tool Detection
# =============================================================================

detect_tools() {
    print_step "Detecting installed tools..."
    print_separator

    local has_claude=false
    local has_codex=false
    local has_gemini=false

    # Check Claude
    if command_exists claude; then
        print_success "Claude CLI detected: $(which claude)"
        has_claude=true
    else
        print_error "Claude CLI not found"
        has_claude=false
    fi

    # Check Codex
    if command_exists codex; then
        print_success "Codex CLI detected: $(which codex)"
        has_codex=true

        # Check uvx dependency
        if ! command_exists uvx; then
            print_warning "Codex detected, but 'uvx' installer not found"
            print_info "Codex MCP installation may fail without uvx"
            print_info "Install uv: https://docs.astral.sh/uv/getting-started/installation/"
        fi
    else
        print_warning "Codex CLI not found"
        has_codex=false
    fi

    # Check Gemini
    if command_exists gemini; then
        print_success "Gemini CLI detected: $(which gemini)"
        has_gemini=true

        # Check npx dependency
        if ! command_exists npx; then
            print_warning "Gemini detected, but 'npx' installer not found"
            print_info "Gemini MCP installation may fail without npx"
            print_info "Install Node.js and npm: https://nodejs.org/"
        fi
    else
        print_warning "Gemini CLI not found"
        has_gemini=false
    fi

    print_separator

    # Validate tool combinations
    if [[ "$has_claude" == false ]]; then
        print_error "Claude CLI is required but not installed!"
        print_info "Please install Claude CLI first: https://docs.claude.com/docs/claude-code"
        log_error "Claude CLI not found - aborting"
        exit 1
    fi

    if [[ "$has_codex" == false ]] && [[ "$has_gemini" == false ]]; then
        print_error "Neither Codex nor Gemini CLI is installed!"
        print_info "Please install at least one of the following:"
        print_info "  - Codex: https://developers.openai.com/codex/quickstart"
        print_info "  - Gemini: https://github.com/google-gemini/gemini-cli"
        log_error "No Codex or Gemini found - aborting"
        exit 1
    fi

    echo -e "\n${GREEN}${BOLD}${CHECK} Tool Detection Complete${NC}\n"

    # Return values via global variables
    TOOLS_DETECTED="claude"
    [[ "$has_codex" == true ]] && TOOLS_DETECTED="${TOOLS_DETECTED}+codex"
    [[ "$has_gemini" == true ]] && TOOLS_DETECTED="${TOOLS_DETECTED}+gemini"

    export HAS_CODEX="$has_codex"
    export HAS_GEMINI="$has_gemini"
}

# =============================================================================
# MCP Configuration
# =============================================================================

setup_codex_mcp() {
    print_step "Setting up Codex MCP..."

    # Check if already installed
    if claude mcp list 2>/dev/null | grep -q "^codex:"; then
        print_info "Codex MCP already installed"
        if ask_yes_no "Reinstall Codex MCP?"; then
            print_info "Removing existing Codex MCP..."
            claude mcp remove codex || true
        else
            print_success "Skipped Codex MCP installation"
            log "Codex MCP installation skipped by user"
            return 0
        fi
    fi

    print_info "Installing Codex MCP (this may take a moment)..."
    if claude mcp add codex -s user --transport stdio -- uvx --from git+https://github.com/GuDaStudio/codexmcp.git codexmcp; then
        print_success "Codex MCP installed successfully"
        log_success "Codex MCP installed"
    else
        print_error "Failed to install Codex MCP"
        log_error "Codex MCP installation failed"
        return 1
    fi
}

setup_gemini_mcp() {
    print_step "Setting up Gemini MCP..."

    # Check if already installed
    if claude mcp list 2>/dev/null | grep -q "^gemini-cli:"; then
        print_info "Gemini MCP already installed"
        if ask_yes_no "Reinstall Gemini MCP?"; then
            print_info "Removing existing Gemini MCP..."
            claude mcp remove gemini-cli || true
        else
            print_success "Skipped Gemini MCP installation"
            log "Gemini MCP installation skipped by user"
            return 0
        fi
    fi

    print_info "Installing Gemini MCP (this may take a moment)..."
    if claude mcp add gemini-cli -- npx -y gemini-mcp-tool; then
        print_success "Gemini MCP installed successfully"
        log_success "Gemini MCP installed"
    else
        print_error "Failed to install Gemini MCP"
        log_error "Gemini MCP installation failed"
        return 1
    fi
}

verify_mcp_installation() {
    print_step "Verifying MCP installation..."
    print_separator

    local all_verified=true

    if [[ "$HAS_CODEX" == true ]]; then
        if claude mcp list 2>/dev/null | grep -q "^codex:"; then
            print_success "Codex MCP successfully verified"
        else
            print_error "Codex MCP verification failed!"
            all_verified=false
        fi
    fi

    if [[ "$HAS_GEMINI" == true ]]; then
        if claude mcp list 2>/dev/null | grep -q "^gemini-cli:"; then
            print_success "Gemini MCP successfully verified"
        else
            print_error "Gemini MCP verification failed!"
            all_verified=false
        fi
    fi

    print_separator

    if [[ "$all_verified" == true ]]; then
        print_success "All installed MCPs verified successfully"
    else
        print_warning "Some MCPs could not be verified. Please check the output above"
    fi
}

# =============================================================================
# Template Installation
# =============================================================================

get_install_location() {
    echo -e "\n${CYAN}${BOLD}Where would you like to install the configuration templates?${NC}\n"
    echo -e "  ${BOLD}1)${NC} User directory (~/.claude/, ~/.codex/, ~/.gemini/)"
    echo -e "  ${BOLD}2)${NC} Current directory (./.claude/, ./.codex/, ./.gemini/)"
    echo -e "  ${BOLD}3)${NC} Custom location"
    echo -e "  ${BOLD}4)${NC} Skip template installation\n"

    while true; do
        echo -ne "${YELLOW}Enter your choice [1-4]: ${NC}"
        read -r choice

        case "$choice" in
            1)
                INSTALL_BASE="$HOME"
                print_success "Installing to user directory: $HOME"
                log "Install location: user directory ($HOME)"
                return 0
                ;;
            2)
                INSTALL_BASE="$(pwd)"
                print_success "Installing to current directory: $(pwd)"
                log "Install location: current directory ($(pwd))"
                return 0
                ;;
            3)
                echo -ne "${YELLOW}Enter custom path: ${NC}"
                read -r custom_path

                # Expand ~ if present
                custom_path="${custom_path/#\~/$HOME}"

                if [[ ! -d "$custom_path" ]]; then
                    if ask_yes_no "Directory $custom_path does not exist. Create it?"; then
                        mkdir -p "$custom_path"
                        print_success "Created directory: $custom_path"
                    else
                        continue
                    fi
                fi

                INSTALL_BASE="$custom_path"
                print_success "Installing to custom location: $custom_path"
                log "Install location: custom ($custom_path)"
                return 0
                ;;
            4)
                print_info "Skipping template installation"
                log "Template installation skipped by user"
                return 1
                ;;
            *)
                echo -e "${RED}Invalid choice. Please enter 1-4.${NC}"
                ;;
        esac
    done
}

install_templates() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local templates_dir="${script_dir}/templates"

    print_step "Installing configuration templates..."
    print_separator

    # Determine which templates to install based on available tools
    local claude_template=""
    local need_agents=false
    local need_gemini=false

    if [[ "$HAS_CODEX" == true ]] && [[ "$HAS_GEMINI" == true ]]; then
        print_info "Installing full workflow: Claude + Codex + Gemini"
        claude_template="CLAUDE.md"
        need_agents=true
        need_gemini=true
    elif [[ "$HAS_CODEX" == true ]]; then
        print_info "Installing Claude + Codex workflow"
        claude_template="CLAUDE-codex.md"
        need_agents=true
        need_gemini=false
    elif [[ "$HAS_GEMINI" == true ]]; then
        print_info "Installing Claude + Gemini workflow"
        claude_template="CLAUDE-gemini.md"
        need_agents=false
        need_gemini=true
    fi

    # Install CLAUDE.md
    local claude_dest="${INSTALL_BASE}/.claude/CLAUDE.md"
    mkdir -p "$(dirname "$claude_dest")"

    backup_file "$claude_dest"
    cp "$templates_dir/$claude_template" "$claude_dest"
    print_success "Installed: $claude_dest"
    log_success "Installed CLAUDE.md from $claude_template"

    # Install AGENTS.md if needed
    if [[ "$need_agents" == true ]]; then
        local agents_dest="${INSTALL_BASE}/.codex/AGENTS.md"
        mkdir -p "$(dirname "$agents_dest")"

        backup_file "$agents_dest"
        cp "$templates_dir/AGENTS.md" "$agents_dest"
        print_success "Installed: $agents_dest"
        log_success "Installed AGENTS.md"
    fi

    # Install GEMINI.md if needed
    if [[ "$need_gemini" == true ]]; then
        local gemini_dest="${INSTALL_BASE}/.gemini/GEMINI.md"
        mkdir -p "$(dirname "$gemini_dest")"

        backup_file "$gemini_dest"
        cp "$templates_dir/GEMINI.md" "$gemini_dest"
        print_success "Installed: $gemini_dest"
        log_success "Installed GEMINI.md"
    fi

    print_separator
    print_success "Template installation complete!"
}

# =============================================================================
# Main Workflow
# =============================================================================

main() {
    # Clear screen and show header
    clear
    print_header

    log "========================================="
    log "Setup script started"
    log "========================================="

    # Step 1: Detect tools
    detect_tools

    # Step 2: Setup MCP
    echo -e "\n${MAGENTA}${BOLD}${STAR} MCP Configuration${NC}\n"

    if [[ "$HAS_CODEX" == true ]]; then
        setup_codex_mcp
    fi

    if [[ "$HAS_GEMINI" == true ]]; then
        setup_gemini_mcp
    fi

    echo ""
    verify_mcp_installation

    # Step 3: Template installation
    echo -e "\n${MAGENTA}${BOLD}${STAR} Template Configuration${NC}\n"

    if ask_yes_no "Would you like to install the configuration templates?" "y"; then
        if get_install_location; then
            install_templates
        fi
    else
        print_info "Template installation skipped"
        log "Template installation skipped by user"
    fi

    # Final summary
    echo -e "\n${GREEN}${BOLD}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║${NC}  ${CHECK} ${BOLD}Setup Complete!${NC}                                     ${GREEN}${BOLD}║${NC}"
    echo -e "${GREEN}${BOLD}╚════════════════════════════════════════════════════════════╝${NC}\n"

    print_info "Configuration summary:"
    echo -e "  • Tools: ${BOLD}${TOOLS_DETECTED}${NC}"
    [[ "$HAS_CODEX" == true ]] && echo -e "  • Codex MCP: ${GREEN}${CHECK} Installed${NC}"
    [[ "$HAS_GEMINI" == true ]] && echo -e "  • Gemini MCP: ${GREEN}${CHECK} Installed${NC}"

    if [[ -n "${INSTALL_BASE:-}" ]]; then
        echo -e "  • Templates: ${GREEN}${CHECK} Installed to ${INSTALL_BASE}${NC}"
    fi

    echo -e "\n${CYAN}${INFO} Log file: ${LOG_FILE}${NC}"
    echo -e "${CYAN}${INFO} To verify installation, run: ${BOLD}claude mcp list${NC}\n"

    log "========================================="
    log "Setup script completed successfully"
    log "Tools: $TOOLS_DETECTED"
    log "========================================="
}

# =============================================================================
# Script Entry Point
# =============================================================================

main "$@"
