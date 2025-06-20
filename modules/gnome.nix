# GNOME is a desktop environment that aims to be simple and easy to use. It is designed
# by The GNOME Project and is composed entirely of free and open-source software. GNOME
# is a part of the GNU Project. See https://nixos.wiki/wiki/GNOME.
{ pkgs, ... }:

{
  services = {
    # Enable GNOME desktop manager.
    desktopManager.gnome.enable = true;

    # Whether to enable GDM, the GNOME Display Manager.
    displayManager.gdm.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      # Whether to enable the X server.
      enable = true;

      # X keyboard layout, or multiple keyboard layouts separated by commas. Required to
      # edit the keyboard layout of the login screen.
      xkb = {
        layout = "fr";
        variant = "azerty";
      };

      # Which X11 packages to exclude from the default environment. Removes XTerm from the
      # default X11 packages.
      excludePackages = with pkgs; [ xterm ];
    };
  };

  # Use GNOME terminal instead of XTerm.
  environment.systemPackages = with pkgs; [
    gnome-terminal
    loupe
  ];

  # Which packages GNOME should exclude from the default environment. The default GNOME
  # configuration comes with a lot of unecessary utilities, almost all of them are
  # disabled here.
  environment.gnome.excludePackages = with pkgs; [
    baobab
    cheese
    epiphany
    simple-scan
    totem
    yelp
    evince
    file-roller
    geary
    seahorse
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-maps
    gnome-music
    gnome-weather
    gnome-disk-utility
    gnome-connections
    gnome-photos
    gnome-tour
    gnome-console
    gedit
  ];
}
