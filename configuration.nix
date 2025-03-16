# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let variables = import /etc/nixos/variables.nix;

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./gpu/nvidia/nvidia-vulkan-beta
      #./gpu_settings.nix
      #./blocky.nix # DNS Proxy service for blocking ad and malware domains. Untested
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-471dda4a-1178-477f-a9cc-12f254c17038".device = "/dev/disk/by-uuid/471dda4a-1178-477f-a9cc-12f254c17038";
  networking.hostName = "zenith"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Hopefully fix problem of complete system chrash with Input/Output Errors.
  # UPDATE: It did NOT fix the issue. I am ready to give up on life. But it does extend how long it takes until complete ystem crash.
  boot.kernelParams = [
    "fsck.mode=force"
  ];

  # Automatically upgrade nixpkgs channel and packages.
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false; # Do not auto reboot to upgrade packages.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  #services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "dk";
    variant = "nodeadkeys";
  };

  # Attempt to reverse scrolling direction, did not work.
  services.libinput.touchpad.naturalScrolling = false;

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ztoy3r = {
    isNormalUser = true;
    description = "ztoy3r";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      discord
      brave
      #(GPUOffloadApp xivlauncher "xivlauncher")
      xivlauncher
      comma
      openscad
      signal-desktop
    #  thunderbird
    ];
  };

  programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.git = {
    enable = true;
    prompt.enable = true;
    lfs.enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      user = {
        email = variables.user0.email;
	name = variables.user0.username;
      };
      core = {
        sshCommand = "ssh -i ~/.ssh/zenith.priv";
      };
    };
  };

  # Suggest nix package that would contain cli command.
  programs.command-not-found.enable = true;

  # Install firefox. Fuck firefox
  programs.firefox.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    keepassxc
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
