# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./nvidia.nix
  ];

  # Pin kernel version to 6.6 since to avoid artifacts with AMD
  boot.kernelPackages = pkgs.linuxPackages_6_6;

  # Disable wacom drivers since they prevent OTD from working
  # boot.blacklistedKernelModules = [ "wacom" ];
  hardware.opentabletdriver.enable = true;

  # Enable flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Machine hotname.
  networking.hostName = "replicant";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Internationalization and localization properties.
  i18n = {
    # Set the locale to en_US.
    defaultLocale = "en_US.UTF-8";

    # Use French locale for time, number, etc...
    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };

    # Enable mozc as the Japanese IME.
    inputMethod = {
      type = "ibus";
      enable = true;
      ibus.engines = with pkgs.ibus-engines; [ mozc ];
    };
  };

  # Environment variables.
  environment.variables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";

    # The follwing environment variable fixes mozc auto-completion window
    # appearing white, in the top-left corner of the screen.
    MOZC_IBUS_CANDIDATE_WINDOW = "ibus";
  };

  # Fonts setup
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      cantarell-fonts
      noto-fonts-cjk-sans
      nerd-fonts.jetbrains-mono
    ];
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.youlix = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Youlix";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      anki-bin
      vlc
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "docker" ];
      theme = "eastwood";
    };
  };

  # Enable docker service.
  virtualisation.docker.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    git
    wget
    nano
    tmux
    pciutils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
