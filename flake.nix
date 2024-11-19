{
  description = "Main Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.Tango = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ 
        ./configuration.nix
        disko.nixosModules.disko
        {
          disko.devices = {
            disk = {
              main = {
                device = <disk-device>;
                type = "disk";
                content = {
                  type = "gpt";
                  partitions = {
                    ESP = {
                      size = "500M";
                      type = "EF00";
                      content = {
                        type = "filesystem";
                        format = "vfat";
                        mountpoint = "/boot";
                        mountOptions = [ "umask=0077" ];
                      };
                    };
                    luks = {
                      size = "100%";
                      content = {
                        type = "luks";
                        name = "crypted";
                        settings.allowDiscards = true;
                        passwordFile = "/tmp/secret.key";
                        content = {
                          type = "filesystem";
                          format = "ext4";
                          mountpoint = "/";
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        }
      ];
    };
  };
}
