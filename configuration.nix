{ pkgs, ... }:

{
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };


  environment.systemPackages = with pkgs; [

    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    btop # replacement of htop/nmon
    direnv
    dnsutils # `dig` + `nslookup`
    eza # A modern replacement for ‘ls’
    file
    fzf # A command-line fuzzy finder
    gawk
    git
    gnupg
    gnused
    gnutar
    iftop # network monitoring
    iotop # io monitoring
    ipcalc # it is a calculator for the IPv4/v6 addresses
    iperf3
    jq # A lightweight and flexible command-line JSON processor
    just
    ldns # replacement of `dig`, it provide the command `drill`
    lsof # list open files
    ltrace # library call monitoring
    mtr # A network diagnostic tool
    neofetch
    nixpkgs-fmt
    niv
    nmap # A utility for network discovery and security auditing
    nnn # terminal file manager
    p7zip
    ripgrep # recursively searches directories for a regex pattern
    socat # replacement of openbsd-netcat
    stgit
    strace # system call monitoring
    tmux
    tree
    unzip
    unzip
    vim
    wget
    which
    xfsprogs
    xz
    yq-go # yaml processor https://github.com/mikefarah/yq
    zip
    zip
    zstd
    pinentry

  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "ext4";
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-label/nix";
    fsType = "ext4";
    neededForBoot = true;
    options = [ "noatime" ];
  };
  fileSystems."/code" = {
    device = "/dev/disk/by-label/code";
    fsType = "ext4";
    options = [ "noatime" ];
  };
  fileSystems."/node" = {
    device = "/dev/disk/by-label/node";
    fsType = "ext4";
    options = [ "noatime" ];
  };


  documentation.nixos.enable = false;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "us";
  nix.settings.trusted-users = [ "@wheel" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "ext4" ];

  users.users = {
    root.hashedPassword = "!"; # Disable root login
    paolino = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO773JHqlyLm5XzOjSe+Q5yFJyLFuMLL6+n63t4t7HR8 paolo.veronelli@gmail.com"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  networking.firewall.allowedTCPPorts = [ 22 443 80 ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  programs.nix-ld.enable = true;
  virtualisation.docker.enable = true;
  nix.settings.extra-substituters = [ "https://cache.iog.io" "https://cache.nixos.org" ];
  nix.settings.extra-trusted-public-keys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = true;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = false;
    };
  };

  programs.bash = {
    enableCompletion = true;
    # TODO add your custom bashrc here
    shellInit = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      sn = "stg new";
      sr = "stg refresh";
      sa = "stg add";
      gpf = "git push --force origin HEAD";
      cf = "just format";
      sg = "stg goto";
      pa = "stg push -a";
      ssq = "stg squash";
      sfl = "stg float";
      ssi = "stg sink -t";
      sbc = "stg branch --create";
      nxsw = "sudo nixos-rebuild switch -I nixos-config=/home/paolino/plutimus-server/configuration.nix";
      sshag = "eval $(ssh-agent -s) && ssh-add ~/.ssh/ed25519";
    };
  };

}
