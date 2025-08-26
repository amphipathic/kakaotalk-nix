{
  description = "A nix flake for kakaotalk";

  inputs = {
    erosanix.url = "github:emmanuelrosa/erosanix";
    nixpkgs.url = "github:NixOS/nixpkgs/master";
  };

  outputs = { self, erosanix, nixpkgs }: {
    packages.x86_64-linux = let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in with (pkgs // erosanix.packages.x86_64-linux // erosanix.lib.x86_64-linux); {
      default = self.packages.x86_64-linux.kakaotalk;

      kakaotalk = callPackage ./kakaotalk.nix {
        inherit mkWindowsApp makeDesktopIcon copyDesktopIcons;
        wine = wineWowPackages.base;
      };
    };
  };
}
