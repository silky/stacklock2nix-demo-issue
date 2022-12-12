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
        ListLike = final.haskell.lib.dontCheck hprev.ListLike;
      })
    ];

    all-cabal-hashes = final.fetchurl {
      name = "all-cabal-hashes";
      url = "https://github.com/commercialhaskell/all-cabal-hashes/archive/828912a437a490c465a732ceac1f034281a764a3.tar.gz";
      sha256 = "sha256-f3Xkn4EjuWFuQToWIWD/cvU5yJA4+RiFV6HYHsFgoXo=";
    };
  });

  s2n-app = final.s2n-pkg-set.s2n;

  s2n-dev-shell = final.s2n-pkg-set.shellFor {
    packages = haskPkgs: final.s2n-stacklock.localPkgsSelector haskPkgs;
    nativeBuildInputs = [
      final.cabal-install
      final.hpack
      final.stack
      final.ghcid
      (final.haskell.packages.ghc925.haskell-language-server.overrideScope (hfinal: hprev: {
        ListLike = final.haskell.lib.dontCheck hprev.ListLike;
      }))
    ];
  };
}
