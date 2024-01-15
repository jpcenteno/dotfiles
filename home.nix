{ config, pkgs, ... }:

let
  buildFromFlake = { repo, system }: (builtins.getFlake repo).packages."${system}".default;
in
rec {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "j";
  home.homeDirectory = "/home/j";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # General command line tools:
    pkgs.bat
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.jq
    pkgs.ripgrep
    pkgs.zenith

    (pkgs.nnn.override { withNerdIcons = true; })

    (pkgs.callPackage buildFromFlake { 
      repo = "git+https://github.com/jpcenteno/tmux-attacher?ref=fix-wrapper-ignoring-arguments&rev=88b5f6320b201bc69f56e1d8396ba0ce2e6a2a66";
    })

    # Text editor.
    pkgs.neovim

    # Productivity tools:
    pkgs.taskwarrior

    # Desktop environment
    pkgs.wob
    pkgs.brightnessctl
    pkgs.zathura

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Do this instead of adding `bash` to `home.packages` in order to Bash to
  # inherit the variables from `home.sessionVariables`.
  programs.bash = {
    enable = true;
    shellAliases = {
      g = "git";
      grep = "grep --color=auto";
      t = "task";

      # Tool replacements.
      cat = "bat";
      ls = "eza";
      tmux = "tmux-attacher";

      # `cd` into a new temporal directory and revoke permissions to any other
      # user.
      cdtmp = "cd \"$(mktemp -d)\" && chmod 700 .";
    };
    initExtra = builtins.readFile dotfiles/bash/bashrc;
  };

  programs.direnv.enable = true;

  programs.git = {
    enable = true;
    userName = "Joaquín P. Centeno";
    userEmail = "jpcenteno@users.noreply.github.com";
    extraConfig = builtins.readFile dotfiles/git/config;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    "${home.sessionVariables.XDG_CONFIG_HOME}/task/taskrc".source = dotfiles/task/taskrc;
    "${home.sessionVariables.XDG_CONFIG_HOME}/git/gitignore".source =
      dotfiles/git/gitignore;

    "${home.sessionVariables.XDG_CONFIG_HOME}/nnn/config.sh".source = dotfiles/nnn/config.sh;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/j/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # XDG base directory variables.
    # Reference: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
    XDG_DATA_HOME = "${home.homeDirectory}/.local/share";
    XDG_CONFIG_HOME = "${home.homeDirectory}/.config";
    XDG_STATE_HOME = "${home.homeDirectory}/.local/state";
    XDG_CACHE_HOME = "${home.homeDirectory }/.cache";
    XDG_DATA_DIRS = "/usr/local/share/:/usr/share/";
    XDG_CONFIG_DIRS = "/etc/xdg";

    # Having `$ENV` undefined broke `mktemp` once on Arch linux. It seems that
    # some Unix systems don't set this at a global level by default.
    TMP = "/tmp";

    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
