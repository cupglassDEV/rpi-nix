{
  description = "KDE Plasma 6 + Programming language tools + RPi4. MADE BY CUPGLASSDEV";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, ... }:
  {
    nixosModules = {
      system = {
        disabledModules = [
          "profiles/base.nix"
        ];

        system.stateVersion = "23.11";
      };  
      users = {
        #the nix.dev manual is outdated
        #who the hell, who was using a fricking rpi 1??
        #and the newer rpi4 dosent respect sysfs for gpio 
        #users.groups.gpio = {};
        users.cupglassdev = {
              password = "admin";
              isNormalUser = true;
              extraGroups = ["wheel"];
        };
      };
      services.xserver.enable = true;
      services.xserver.displayManager.sddm.enable = true;
      # TODO: Kalo ke 24.01 apus 'xserver' nya
      services.xserver.desktopManager.plasma6.enable = true;
      programs.sway.enable = true;
      hardware.raspberry-pi."4".fkms-3d.enable = true;
      hardware.pulseaudio.enable = true;
    };  
    packages.aarch64-linux = {
      sdcard = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        format = "sd-aarch64";
        modules = [
          self.nixosModules.system
          self.nixosModules.users
          self.nixosModules.programs
          self.nixosModules.services
          self.nixosModules.hardware
          ./apps.conf.nix
          ./extra.conf.nix
        ];
      };
    };
    packages.aarch64-linux-remoteable = {
      sdcard = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        format = "sd-aarch64";
        modules = [
          self.nixosModules.system
          self.nixosModules.users
          self.nixosModules.programs
          self.nixosModules.services
          self.nixosModules.hardware
          ./remoteable.conf.nix
          ./apps.remoteable.conf.nix
          ./extra.conf.nix
        ];
      };
    };
  };
}
