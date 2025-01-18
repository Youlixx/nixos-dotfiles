# NVIDIA provides a proprietary driver for its graphics cards that has better 3D
# performance than the X.org drivers. It is not enabled by default because it’s not free
# software. Manual: https://nixos.wiki/wiki/Nvidia.
{ config, lib, pkgs, ... }:

{
  # Enable unfree programs as they are required for NVIDIA proprietary drivers.
  nixpkgs.config.allowUnfree = true;

  # Enable OpenGL
  hardware.graphics = {
    # Whether to enable OpenGL drivers. This is needed to enable OpenGL support in X11
    # systems, as well as for Wayland compositors like sway and Weston. It is enabled by
    # default by the corresponding modules, so you do not usually have to set it
    # yourself, only if there is no module for your wayland compositor of choice. See
    # services.xserver.enable and programs.sway.enable.
    enable = true;

    # On 64-bit systems, whether to support Direct Rendering for 32-bit applications
    # (such as Wine). This is currently only supported for the nvidia as well as Mesa.
    enable32Bit = true;
  };

  # The names of the video drivers the configuration supports. They will be tried in
  # order until one that supports your card is found. Don’t combine those with
  # “incompatible” OpenGL implementations, e.g. free ones (mesa-based) with proprietary
  # ones.
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Whether to enable kernel modesetting when using the NVIDIA proprietary driver.
    # Enabling this fixes screen tearing when using Optimus via PRIME, see
    # hardware.nvidia.prime.sync.enable. This is not enabled by default because it is
    # not officially supported by NVIDIA and would not work with SLI.
    # Modesetting is required.
    modesetting.enable = true;

    # Whether to enable experimental power management through systemd. For more
    # information, see the NVIDIA docs, on Chapter 21. Configuring Power Management
    # Support. Experimental, and can cause sleep/suspend to fail. Enable this if you
    # have graphical corruption issues or application crashes after waking up from
    # sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead of just the
    # bare essentials.
    powerManagement.enable = false;

    # Whether to enable experimental power management of PRIME offload. For more
    # information, see the NVIDIA docs, on Chapter 22. PCI-Express Runtime D3 (RTD3)
    # Power Management.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Whether to enable the open source NVIDIA kernel module.
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Whether to enable nvidia-settings, NVIDIA’s GUI configuration tool.
    nvidiaSettings = true;

    # The NVIDIA driver package to use. Allowed values:
    # - config.boot.kernelPackages.nvidiaPackages.stable;
    # - config.boot.kernelPackages.nvidiaPackages.beta;
    # - config.boot.kernelPackages.nvidiaPackages.production;
    # - config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    # - config.boot.kernelPackages.nvidiaPackages.legacy_470;
    # - config.boot.kernelPackages.nvidiaPackages.legacy_390;
    # - config.boot.kernelPackages.nvidiaPackages.legacy_340;
    # Out of the above, stable and beta will work for the latest RTX cards and some
    # lower cards so long as they're not considered "legacy" by Nvidia. For "legacy"
    # cards, you can consult https://www.nvidia.com/en-us/drivers/unix/legacy-gpu/ and
    # check whether your device is supported by the 470, 390 or 340 branches. If so, you
    # can use the corresponding legacy_470, legacy_390 or legacy_340 driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # NVIDIA Optimus PRIME setup. Currently using Sync mode, see
    # https://nixos.wiki/wiki/Nvidia#Optimus_PRIME_Option_B:_Sync_Mode
    prime = {
      # Whether to enable NVIDIA Optimus support using the NVIDIA proprietary driver via
      # PRIME. If enabled, the NVIDIA GPU will be always on and used for all rendering,
      # while enabling output to displays attached only to the integrated Intel/AMD GPU
      # without a multiplexer.
      # Note that this option only has any effect if the “nvidia” driver is specified in
      # services.xserver.videoDrivers, and it should preferably be the only driver
      # there.
      sync.enable = true;

      # Bus ID of the AMD APU. You can find it using lspci; for example if lspci shows
      # the AMD APU at “04:00.0”, set this option to “PCI:4:0:0”.
      amdgpuBusId = "PCI:36:0:0";

      # Bus ID of the NVIDIA GPU. You can find it using lspci; for example if lspci
      # shows the NVIDIA GPU at “01:00.0”, set this option to “PCI:1:0:0”.
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Adds the nvtop command with support for NVIDIA and AMD GPUs.
  # See https://github.com/Syllo/nvtop.
  environment.systemPackages = with pkgs.nvtopPackages; [
    nvidia
    amd
  ];
}
