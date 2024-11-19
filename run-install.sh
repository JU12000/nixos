sudo nix --extra-experimental-features nix-command run 'github:nix-community/disko/latest#disko-install' -- --flake $1 --disk $2 $3
