# Bootloader configuration.
{ ... }:

{
  # A bootloader is a type of software that manages the loading of the OS on
  # the computer at startup. It is responsible for preparing the system before
  # passing control to the OS. See https://nixos.wiki/wiki/Bootloader.
  boot.loader = {
    efi = {
      # Whether the installation process is allowed to modify EFI boot
      # variables.
      canTouchEfiVariables = true;

      # Where the EFI System Partition is mounted.
      efiSysMountPoint = "/boot";
    };

    # We use GRUB as our boot loader. It is configured to detect other OSs on
    # the computer, see https://nixos.wiki/wiki/Dual_Booting_NixOS_and_Windows.
    grub = {
      # Whether to enable the GNU GRUB boot loader.
      enable = true;

      # Whether GRUB should be built with EFI support.
      efiSupport = true;

      # The device on which the GRUB boot loader will be installed. The special
      # value nodev means that a GRUB boot menu will be generated, but GRUB
      # itself will not actually be installed.
      device = "nodev";

      # If set to true, append entries for other OSs detected by os-prober.
      # os-prober is a tool to autodetect which other systems are present on
      # the machine. Grub can be told to use os-prober to add a menu-entry for
      # each of them.
      useOSProber = true;
    };

    # Disable systemd since we use grub.
    systemd-boot.enable = false;
  };
}