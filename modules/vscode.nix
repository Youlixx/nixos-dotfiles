{ pkgs, ... }:

{
  # The environment variable NIXOS_OZONE_WL must be set to 1 to run VSCode under
  # Wayland, see https://nixos.wiki/wiki/Visual_Studio_Code#Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # VSCode extensions are managed with vscode-with-extensions
  environment.systemPackages = with pkgs;
    let
      vcsodeWithExtension = vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          ms-vscode-remote.remote-ssh
          ms-vscode-remote.remote-containers
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
        ];
      };
    in
    [
      nixpkgs-fmt
      vcsodeWithExtension
    ];
}
