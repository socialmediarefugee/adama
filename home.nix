{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "adama";
  home.homeDirectory = "/home/adama";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    unzip 
    nixd
		nixfmt-rfc-style
    nixd
  ];

  programs = 	{
    neovide = {
      enable = true;
      settings = {
        fork = false;
        frame = "full";
        idle = true;
        maximized = false;
        neovim-bin = "/usr/bin/nvim";
        no-multigrid = false;
        srgb = false;
        tabs = true;
        theme = "auto";
        title-hidden = true;
  	    vsync = true;
  	    wsl = false;
    	  font = {
          normal = [];
	        size = 14.0;
  	    };
    	};
    };

		ripgrep = {
		  enable = true;
    };

		bash = {
		  enable = true; # This is not redundant because there is no guarantee that bash will be available on system.
			enableCompletion = true;
		  bashrcExtra = '' set -o vi '';
		  profileExtra = '' set -o vi '';
		};

		bat.enable = true;

    eza = {
		  enable = true;
			enableBashIntegration = true;
			git = true;
			icons = auto;
			extraOptions = [
			  "--group-directories-first"
				"--header"
			];
		};

    fd = {
		  enable = true;
			hidden = true;
			ignores = [ 
			  ".git"
				"*.bak"
				];

    }; 
		fzf = {
		  enable = true;
			enableBashIntegration = true;
    };

		gh = { #Github cli
		  enable = true;
    };

		git = { # Should be installed in default system but not guaranteed
		  enable = true;
    };

		lsd = {
		  enable = true;
			enableAliases = true;
    };

		wezterm = {
		  enable = true;
			enableBashIntegration = true;
			# Since things like this are copied verbatim, do not format at this level
			extraConfig = 
''
-- Your lua code / config here
local wezterm = require 'wezterm';
return {
  font = wezterm.font("JetBrains Mono"),
  font_size = 16.0,
  color_scheme = "Treehouse",
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    {key="n", mods="SHIFT|CTRL", action="ToggleFullScreen"},
  }
}
'';

    }; # wezterm

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
				"${lib.makeLibraryPath [ pkgs.stdenv.cc.cc pkgs.zlib ]}"
				"--suffix"
				"PKG_CONFIG_PATH"
				":"
				"${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [ pkgs.stdenv.cc.cc pkgs.zlib ]}"
     			];
    }; 
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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
