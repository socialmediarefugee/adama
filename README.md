# Home Manager Configuration Documentation

## Overview

This is a comprehensive Nix Home Manager configuration that provides a complete development environment setup for Linux systems. The configuration is designed to be declarative, reproducible, and easily maintainable.

## Architecture

The configuration consists of three main components:

1. **`flake.nix`** - The main entry point that defines dependencies and outputs
2. **`home.nix`** - The primary user environment configuration
3. **`plasma.nix`** - KDE Plasma desktop environment configuration

## Table of Contents

- [Quick Start](#quick-start)
- [Flake Configuration](#flake-configuration)
- [Home Manager Configuration](#home-manager-configuration)
- [Plasma Configuration](#plasma-configuration)
- [Development Tools](#development-tools)
- [Shell Configuration](#shell-configuration)
- [Services](#services)
- [Customization Guide](#customization-guide)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)

## Quick Start

### Prerequisites

- Nix package manager installed
- Flakes enabled in your Nix configuration

### Installation

1. Clone or copy this configuration to your system
2. Adjust the username in `flake.nix` and `home.nix` if needed
3. Run the following command:

```bash
nix run home-manager/master -- switch --flake .#adama
```

### Basic Usage

```bash
# Apply configuration changes
home-manager switch --flake .#adama

# Check what packages would be installed
home-manager build --flake .#adama

# Update flake inputs
nix flake update
```

## Flake Configuration

### File: `flake.nix`

#### Public API

```nix
{
  description = "Home Manager configuration";
  
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
    home-manager = { url = "github:nix-community/home-manager"; };
    plasma-manager = { url = "github:nix-community/plasma-manager"; };
  };
  
  outputs = { nixpkgs, home-manager, plasma-manager, ... };
}
```

#### Components

| Component | Purpose | Configuration |
|-----------|---------|---------------|
| `nixpkgs` | Base package repository | nixpkgs-unstable branch |
| `home-manager` | User environment management | Latest from nix-community |
| `plasma-manager` | KDE Plasma configuration | Latest from nix-community |

#### Usage Examples

```bash
# Switch to configuration
nix run home-manager/master -- switch --flake .#adama

# Build without switching
nix run home-manager/master -- build --flake .#adama

# Update inputs
nix flake update
```

## Home Manager Configuration

### File: `home.nix`

#### Core Configuration

```nix
{
  home.username = "adama";
  home.homeDirectory = "/home/adama";
  home.stateVersion = "25.05";
}
```

#### Shell Configuration

| Shell | Status | Integration |
|-------|--------|-------------|
| `bash` | ✅ Enabled | vi-mode, completions |
| `fish` | ✅ Enabled | Default shell, completions |
| `nushell` | ❌ Disabled | Available but not active |

#### Shell Aliases

```nix
home.shellAliases = {
  nvlazy = "NVIM_APPNAME=nvim-lazy nvim";
  nvmaria = "NVIM_APPNAME=nvim-maria nvim";
};
```

#### Unfree Package Configuration

```nix
nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (lib.getName pkg) [
    "obsidian" "lmstudio" "code" "vscode"
    "cursor" "albert" "claude-code" "gemini-cli"
  ];
```

### Development Tools

#### Programming Languages

| Language | Compiler/Runtime | Language Server | Tools |
|----------|------------------|-----------------|-------|
| **Go** | `go_1_24` | `gopls` | `golint`, `gotools`, `gotests`, `gocyclo` |
| **Rust** | `rustup` | Built-in | Managed via rustup |
| **C/C++** | `clang`, `zig` | `ccls` | `libclang` |
| **OCaml** | `ocaml` | `ocaml-lsp` | `dune_3`, `utop`, `merlin` |
| **Pascal** | `fpc` | - | `lazarus-qt6` |
| **Nim** | `nim` | `nimlangserver` | `nimble` |
| **Swift** | `swift` | - | `swiftformat` |
| **Lua** | Built-in | `lua-language-server` | `luarocks-nix` |
| **JavaScript** | `nodejs` | Built-in | - |

#### Editors and IDEs

```nix
programs.neovim = {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  withNodeJs = true;
  withPython3 = true;
  withRuby = true;
};

programs.vscode = {
  enable = true;
  package = pkgs.vscode-fhs;
  mutableExtensionsDir = true;
};

programs.emacs = {
  enable = true;
  extraConfig = ''
    (setq standard-indent 2)
  '';
};

programs.neovide = {
  enable = true;
  settings = {
    fork = false;
    frame = "full";
    theme = "auto";
    font = { size = 14.0; };
  };
};
```

#### Development Utilities

| Tool | Purpose | Configuration |
|------|---------|---------------|
| `git` | Version control | Basic setup |
| `gh` | GitHub CLI | Enabled |
| `direnv` | Environment management | Bash integration + nix-direnv |
| `fzf` | Fuzzy finder | Bash integration |
| `ripgrep` | Text search | Enabled |
| `fd` | File finder | Hidden files, ignore patterns |
| `bat` | Cat replacement | Extra packages included |

### Terminal Configuration

#### WezTerm

```nix
programs.wezterm = {
  enable = true;
  enableBashIntegration = true;
  extraConfig = ''
    local wezterm = require 'wezterm'
    local config = wezterm.config_builder()
    
    config.font = wezterm.font("FiraCode Nerd Font")
    config.font_size = 14.0
    config.color_scheme = "VisiBone (terminal.sexy)"
    config.hide_tab_bar_if_only_one_tab = true
    config.default_prog = { 'fish' }
    
    return config
  '';
};
```

#### File Managers

```nix
programs.yazi = {
  enable = true;
  enableBashIntegration = true;
  enableFishIntegration = true;
};

programs.xplr = {
  enable = true;
};
```

### Browser Configuration

#### Chromium

```nix
programs.chromium = {
  enable = true;
  nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
  dictionaries = [ pkgs.hunspellDictsChromium.en_US ];
  commandLineArgs = [ "--disk-cache-dir=\"$XDG_RUNTIME_DIR/adama-chromium\"" ];
};
```

#### Firefox

```nix
programs.firefox = {
  enable = true;
};
```

### Package Collections

#### Nerd Fonts

```nix
nerd-fonts.monaspace
nerd-fonts.monofur
nerd-fonts.daddy-time-mono
nerd-fonts.envy-code-r
nerd-fonts.anonymice
nerd-fonts.arimo
nerd-fonts.fira-code
```

#### Productivity Tools

```nix
# Note-taking and documentation
obsidian          # Note-taking application
glow             # Markdown preview
md-tui           # Markdown renderer
multimarkdown    # Markdown processor

# System utilities
albert           # Application launcher
playerctl        # Media control
xdotool         # X11 automation
```

## Plasma Configuration

### File: `plasma.nix`

#### Desktop Environment

```nix
programs.plasma = {
  enable = true;
  
  workspace = {
    lookAndFeel = "org.kde.breezedark.desktop";
  };
  
  fonts = {
    general = {
      family = "Monaspace Nerd Font Propo";
      pointSize = 14;
    };
  };
};
```

#### Window Rules

```nix
window-rules = [
  {
    description = "wezterm";
    match = {
      window-class = { value = "wezterm"; type = "substring"; };
      window-types = [ "normal" ];
    };
    apply = {
      noborder = { value = true; apply = "force"; };
      maximizehoriz = true;
      maximizevert = true;
    };
  }
  {
    description = "doomEmacs";
    match = {
      window-class = { value = "emacs"; type = "substring"; };
      window-types = [ "normal" ];
    };
    apply = {
      maximizehoriz = true;
      maximizevert = true;
    };
  }
];
```

#### Keyboard Shortcuts

```nix
shortcuts = {
  ksmserver = {
    "Lock Session" = [ "Screensaver" "Meta+Ctrl+Alt+L" ];
  };
  
  kwin = {
    "Expose" = "Meta+,";
    "Switch Window Down" = "Meta+J";
    "Switch Window Left" = "Meta+H";
    "Switch Window Right" = "Meta+L";
    "Switch Windows Up" = "Meta+K";
  };
};
```

#### Touchpad Configuration

```nix
configFile = {
  "touchpadxlibinputrc" = {
    "[Libinput][1739][52759][SYNA32A4:00 06CB:CE17 Touchpad]" = {
      "DisableEventsOnExternalMouse" = true;
    };
  };
};
```

## Services

### Background Services

```nix
services = {
  kdeconnect = {
    enable = true;
    indicator = true;
  };
  
  opensnitch-ui.enable = true;
  
  psd = {
    enable = true;
    browsers = [ "chromium" "firefox" ];
  };
  
  emacs = {
    enable = true;
  };
};
```

### System Integration

```nix
systemd = {
  user.enable = true;
};
```

## Environment Variables

```nix
home.sessionVariables = {
  VISUAL = "neovide";
  PATH = "$HOME/.emacs.d/bin:$PATH";
};
```

## Customization Guide

### Adding New Packages

1. **System packages**: Add to `home.packages` in `home.nix`
2. **Program configurations**: Add to `programs` section
3. **Services**: Add to `services` section

### Example: Adding a new development tool

```nix
# In home.nix
home.packages = with pkgs; [
  # ... existing packages ...
  your-new-package
];

# If it needs configuration
programs.your-program = {
  enable = true;
  # ... configuration options ...
};
```

### Modifying Shell Configuration

```nix
# Adding new shell aliases
home.shellAliases = {
  # ... existing aliases ...
  mynew = "your-command-here";
};

# Modifying shell integration
programs.your-shell = {
  enable = true;
  # ... shell-specific options ...
};
```

### Customizing Plasma

```nix
# In plasma.nix
programs.plasma = {
  # ... existing configuration ...
  
  # Add new shortcuts
  shortcuts = {
    your-app = {
      "Action Name" = "Key+Combination";
    };
  };
  
  # Add new window rules
  window-rules = [
    {
      description = "your-app";
      match = { /* ... */ };
      apply = { /* ... */ };
    }
  ];
};
```

## Examples

### Example 1: Adding Python Development Environment

```nix
# In home.nix
home.packages = with pkgs; [
  # ... existing packages ...
  python3
  python3Packages.pip
  python3Packages.virtualenv
  python3Packages.python-lsp-server
];

programs.neovim = {
  # ... existing configuration ...
  withPython3 = true;  # Already enabled
};
```

### Example 2: Custom Application Launcher

```nix
# In home.nix
home.packages = with pkgs; [
  # ... existing packages ...
  rofi  # Alternative to albert
];

# In plasma.nix
programs.plasma = {
  # ... existing configuration ...
  shortcuts = {
    rofi = {
      "Show Applications" = "Meta+Space";
    };
  };
};
```

### Example 3: Adding Docker Support

```nix
# In home.nix
home.packages = with pkgs; [
  # ... existing packages ...
  docker-compose
  docker-buildx
];

# Note: Docker daemon needs to be configured at system level
```

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure your user has proper permissions for Home Manager
2. **Unfree Packages**: Add package names to `nixpkgs.config.allowUnfreePredicate`
3. **Missing Dependencies**: Check if system-level packages are required

### Debug Commands

```bash
# Check configuration syntax
nix flake check

# Build without switching
home-manager build --flake .#adama

# Show what would be installed
home-manager news --flake .#adama

# Rollback if needed
home-manager rollback
```

### Logs

```bash
# View Home Manager logs
journalctl --user -u home-manager-adama

# View system logs for services
systemctl --user status your-service
```

## Configuration Files Structure

```
.
├── flake.nix           # Main flake configuration
├── flake.lock          # Locked dependencies
├── home.nix            # User environment configuration
├── plasma.nix          # KDE Plasma configuration
└── plasma-dump-defaults # Plasma defaults backup
```

## Maintenance

### Regular Updates

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake update nixpkgs

# Apply updates
home-manager switch --flake .#adama
```

### Cleanup

```bash
# Remove old generations
home-manager expire-generations "-30 days"

# Collect garbage
nix-collect-garbage -d
```

## Contributing

To contribute to this configuration:

1. Test changes in a separate branch
2. Ensure all configurations are properly documented
3. Update this README with any new features or changes
4. Test on a clean system before committing

## License

This configuration is provided as-is for educational and personal use.