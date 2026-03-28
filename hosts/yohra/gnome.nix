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
}
