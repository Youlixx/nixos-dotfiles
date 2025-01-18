# nixos-dotfiles
NixOS dotfiles

To rebuild
```sh
sudo nixos-rebuild switch --flake /path/to/dotfiles#<machine>
```

To update the lock file
```sh
nix flake update
```
