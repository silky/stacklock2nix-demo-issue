{
    inputs = {
        nixpkgs.url       = "github:nixos/nixpkgs/nixos-22.11";
        stacklock2nix.url = "github:cdepillabout/stacklock2nix/main";
    };

    outputs = inputs: with inputs;
    let
      # System types to support.
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor =
        forAllSystems (system: import nixpkgs { inherit system; overlays = [ stacklock2nix.overlay self.overlay ]; });
    in
    {
      overlay = import nix/overlay.nix;

      packages = forAllSystems (system: {
        s2n = nixpkgsFor.${system}.s2n-app;
      });

      defaultPackage = forAllSystems (system: self.packages.${system}.s2n);

      devShell = forAllSystems (system: nixpkgsFor.${system}.s2n-dev-shell);
    };
}
