{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pass
    wl-clipboard
    htop
    tree
    usbutils
    unzip
    gimp
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
  services.openvpn.servers = {
    office = { config = '' config /home/youlix/.openvpn/office.conf ''; };
  };

  programs.ssh.askPassword = "";
}
