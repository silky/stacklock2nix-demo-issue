final: prev: {
  s2n-stacklock = final.stacklock2nix {
    stackYaml = ../stack.yaml;
  };

  s2n-pkg-set = final.haskell.packages.ghc925.override (oldAttrs: {
    overrides = final.lib.composeManyExtensions [
      (oldAttrs.overrides or (_: _: {}))

      final.s2n-stacklock.stackYamlResolverOverlay

      final.s2n-stacklock.stackYamlExtraDepsOverlay

      final.s2n-stacklock.stackYamlLocalPkgsOverlay

      final.s2n-stacklock.suggestedOverlay

      (hfinal: hprev: {
      })
    ];

    all-cabal-hashes = final.fetchurl {
      name = "all-cabal-hashes";
      url = let hash = "58337345887bcb5ade89ea77e0eabe6b274cff28";
             in "https://github.com/commercialhaskell/all-cabal-hashes/archive/${hash}.tar.gz";
      sha256 = "sha256-pxXhmJp/aPF5XmepF25KLlH9M6Eu7ZTXKkAPlIwrqws=";
    };
  });

  s2n-app = final.s2n-pkg-set.s2n;

  s2n-dev-shell = final.s2n-pkg-set.shellFor {
    packages = haskPkgs: final.s2n-stacklock.localPkgsSelector haskPkgs;
    nativeBuildInputs = [
      final.cabal-install
      final.stack
    ];
  };
}
