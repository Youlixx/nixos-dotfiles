{ pkgs, ... }:

{
  # GNOME configuration overrides.
  services.displayManager.autoLogin = {
    enable = true;
    user = "youlix";
  };

  # Enable fractional scaling.
  services.desktopManager.gnome = {
    extraGSettingsOverridePackages = [ pkgs.mutter ];
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
    '';
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
