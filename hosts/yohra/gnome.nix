{ pkgs, ... }:

{
  # Auto login
  services.displayManager.autoLogin = {
    enable = true;
    user = "youlix";
  };

  # GNOME extensions
  environment.systemPackages = with pkgs; [
    gnomeExtensions.gsconnect
  ];

  # Open KDE connect ports.
  networking.firewall = rec {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
}
