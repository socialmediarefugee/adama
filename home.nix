{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "adama";
  home.homeDirectory = "/home/adama";

  home.shellAliases = {
    cdf = "cd \"$(dirname \"$(realpath \"$1\")\")";
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "obsidian"
      "lmstudio"
      "code"
      "vscode"
      "vscode-fhs"
      "steam"
      "steam-unwrapped"
      "steam-original"
      "steam-run"
      "albert"
    ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    #  (nerdfonts.override { fonts = [ "Monaspace" "FiraCode"]; })
    nerd-fonts.monaspace
    nerd-fonts.monofur
    nerd-fonts.daddy-time-mono # This is just wrong and I hate myself for liking it.
    nerd-fonts.envy-code-r
    nerd-fonts.anonymice
    nerd-fonts.arimo
    nerd-fonts.fira-code
    nixfmt-rfc-style
    nixd
    manix
    albert # Alfred work-alike for Linux
    gnumake # Yech, but required for lazarus
    fpc # I thought Lazarus installed this itself but apparently not
    lazarus-qt6 # 3.6.0 version of Lazarus
    gdb # debugger
    zig # get a c compiler for free
    clang
    rustup # So's we can manage rust on our lonesome
    tor-browser
    brave # Brave doesn't appear to be supported by home-manager yet

    ###### Unfree ######
    obsidian # Because its my scratch pad.
    vscode-fhs
    lmstudio
    #    steam
    #    steam-unwrapped
    #    steam-original
    #    steam-run

    xdotool
    xorg.xprop
    kdePackages.qttools
    kdePackages.kdialog
  ];

  programs = {

    bash = {
      enable = true; # This is not redundant because there is no guarantee that bash will be available on system.
      enableCompletion = true;
      bashrcExtra = ''set -o vi '';
      profileExtra = ''set -o vi '';
    };

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batgrep
        batman
        batpipe
        batwatch
        prettybat
      ];
    };


    chromium = {
      enable = true;
      nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
      dictionaries = [
        pkgs.hunspellDictsChromium.en_US
      ];
      #enablePlasmaBrowserIntegration = true;
      # TODO: Replace the hard coded user
      commandLineArgs = [ "--disk-cache-dir=\"$XDG_RUNTIME_DIR/adama-chromium\"" ];
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      enableBashIntegration = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
    
    firefox = {
      enable = true;
      
    };
    # Better Finder
    fd = {
      enable = true;
      hidden = true;
      ignores = [
        ".git"
        "*.bak"
      ];

    };

    #freetube.enable = true;  #  Thinking about this rather than using Firefox.

    # Fuzzy finder
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    gh = {
      # Github cli
      enable = true;
    };

    git = {
      # Should be installed in default system but not guaranteed
      enable = true;
    };

    lsd = {
      enable = true;
      enableAliases = true;
    };

    neovide = {
      enable = true;
      settings = {
        fork = false;
        frame = "full";
        idle = true;
        maximized = false;
        no-multigrid = false;
        srgb = false;
        tabs = true;
        theme = "auto";
        title-hidden = true;
        vsync = true;
        wsl = false;
        font = {
          normal = [ ];
          size = 14.0;
        };
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        nvchad
      ];
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;

      extraWrapperArgs = [
        "--suffix"
        "LIBRARY_PATH"
        ":"
        "${lib.makeLibraryPath [
          pkgs.stdenv.cc.cc
          pkgs.zlib
        ]}"
        "--suffix"
        "PKG_CONFIG_PATH"
        ":"
        "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
          pkgs.stdenv.cc.cc
          pkgs.zlib
        ]}"
      ];
    };

    oh-my-posh = {
      enable = true;
      enableBashIntegration = true;
      useTheme = "atomic";
    };

    ripgrep = {
      enable = true;
    };

    tealdeer = {
      enable = true;
      enableAutoUpdates = true;
    };

    wezterm = {
      enable = true;
      enableBashIntegration = true;
      # Since things like this are copied verbatim, do not format at this level
      extraConfig = ''
               -- Your lua code / config here
                -- Pull in the wezterm API
        local wezterm = require 'wezterm'

        -- Use config_builder for cleaner configuration
        local config = wezterm.config_builder()

        -- Load plugins
        local wezterm_config_nvim = wezterm.plugin.require 'https://github.com/winter-again/wezterm-config.nvim'
        local modal = wezterm.plugin.require("https://github.com/MLFLexer/modal.wezterm")

        -- Apply modal plugin to config
        -- modal.apply_to_config(config)

        -- Handle dynamic config overrides via user-var-changed event
        wezterm.on('user-var-changed', function(window, pane, name, value)
            local overrides = window:get_config_overrides() or {}
            overrides = wezterm_config_nvim.override_user_var(overrides, name, value)
            window:set_config_overrides(overrides)
        end)

        -- Set configuration options directly on the config object
        config.font = wezterm.font("FiraCode Nerd Font") -- Fixed font syntax
        config.font_size = 16.0
        config.color_scheme = "VisiBone (terminal.sexy)"
        config.hide_tab_bar_if_only_one_tab = true
        config.keys = {
            { key = "n", mods = "SHIFT|CTRL", action = wezterm.action.ToggleFullScreen },
        }

        -- Return the config object
        return config 
      '';

    }; # wezterm

    xplr = {
      enable = true;
    };

    vscode = {
      enable = true;
      package = pkgs.vscode-fhs;
      #   profiles = {
      #     adama = {
      #       extensions = [ asvetliakov.vscode-neovim ];
      #     };
      #   };
      # Mutually exclusive with:
      mutableExtensionsDir = true;
    };

  }; # programs

  services = {
    # activitywatch.enable = true;

    #copyq.enable = true;

    kdeconnect = {
      enable = true;
      indicator = true;
    };

    opensnitch-ui.enable = true;

    psd = {
      enable = true;
      browsers = [
        "chromium"
        "firefox"
      ];

    };

  };

  systemd = {
    user.enable = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/adama/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    #     EDITOR = "nvim";
    VISUAL = "neovide";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
