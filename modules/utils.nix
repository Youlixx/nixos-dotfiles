{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pass
    wl-clipboard
    htop
    tree
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  programs.ssh.askPassword = "";
}
