{ pkgs, claude-code-nix, ... }:

{
  system.stateVersion = "24.11";

  # Boot
  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
    initrd.availableKernelModules = [
      "ahci"
      "ext4"
      "sd_mod"
      "sr_mod"
      "virtio_pci"
      "virtio_scsi"
      "xhci_pci"
    ];
  };

  # Filesystems
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "ext4";
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "ext4";
      neededForBoot = true;
      options = [ "noatime" ];
    };
    "/code" = {
      device = "/dev/disk/by-label/code";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/node" = {
      device = "/dev/disk/by-label/node";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  # Nix
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = "nix-command flakes";
    max-jobs = 32;
    trusted-users = [ "@wheel" ];
    extra-substituters = [
      "https://cache.iog.io"
      "https://cache.nixos.org"
    ];
    extra-trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  # Locale & Time
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "us";
  documentation.nixos.enable = false;

  # Networking
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  # Users
  users.users = {
    root.hashedPassword = "!";
    paolino = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO773JHqlyLm5XzOjSe+Q5yFJyLFuMLL6+n63t4t7HR8 paolo.veronelli@gmail.com"
      ];
    };
  };

  # Security
  security.sudo.wheelNeedsPassword = false;

  # Services
  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    pcscd.enable = true;
    cron = {
      enable = true;
      systemCronJobs = [
        "* * * * * docker ps -q -f health=unhealthy | xargs -r docker restart"
      ];
    };
  };

  # Virtualisation
  virtualisation.docker.enable = true;

  # Programs
  programs = {
    bash = {
      completion.enable = true;
      shellInit = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
        export EDITOR="vim"
        export DOMINIQUE_DID="did:key:z6MkiuWYPxbojmhUiGGWrzSuJK3HDpbbtWo3QMm3e9VP2gJP"
        export ARNAUD_DID="did:key:z6MkhgPg6WShnhJcmfwox4G5yL3EvJ2zW8L31SZLD95yUi11"
        export ANVIKING_DID="did:key:z6MkoqswZoM5EtGgsWyTYbrbAw2MXWd2JmSvsQ8Ns9jstmCX"
        export PAWEL_DID="did:key:z6Mks4nj3eXrWhjEXknLooeH8ac9c8XcTSzmM7GaooaVyEMN"
        export PAOLINO_DID="did:key:z6MksH6Yr4pkJqPYnY4N5e5a5bCdyCW88grKRkkK6KeMGwLN"
      '';
      shellAliases = {
        # Git
        glg = "git log --graph --oneline";
        gpf = "git push --force origin HEAD";
        # Stgit
        pa = "stg push -a";
        sa = "stg add";
        sbc = "stg branch --create";
        sfl = "stg float";
        sg = "stg goto";
        sn = "stg new";
        sr = "stg refresh";
        ssi = "stg sink -t";
        ssq = "stg squash";
        # System
        cf = "just format";
        nxsw = "sudo nixos-rebuild switch --flake /home/paolino/plutimus-server#hetzner-x86_64";
        sshag = "eval $(ssh-agent -s) && ssh-add ~/.ssh/ed25519";
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [ stdenv.cc.cc.lib ];
    };
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = false;
      };
    };
  };

  # Packages
  environment.systemPackages = with pkgs; [
    claude-code-nix.packages.${pkgs.system}.default

    # Core utils
    file
    gawk
    gnumake
    gnused
    gnutar
    tree
    which

    # Compression
    p7zip
    unzip
    xz
    zip
    zstd

    # Development
    gh
    git
    just
    nodejs
    stgit
    vim

    # Nix tools
    cachix
    nixfmt
    nixpkgs-fmt

    # Network
    dnsutils
    nmap
    socat
    tcpdump
    wget

    # Search
    fzf
    ripgrep

    # Security
    gnupg
    pinentry-curses
    pinentry-tty

    # Shell
    direnv
    tmux

    # System
    jq
    lsof
    ltrace
    strace
    xfsprogs
    yq-go
  ];
}
