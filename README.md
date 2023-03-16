# notes

fails:

```
nix develop
```

infinite recurision

```
> nix develop
error: infinite recursion encountered

       at /nix/store/rksi78f7vq2xrfghg6jfg1r5dsa8lbv7-source/pkgs/stdenv/generic/make-derivation.nix:314:7:

          313|       depsHostHost                = lib.elemAt (lib.elemAt dependencies 1) 0;
          314|       buildInputs                 = lib.elemAt (lib.elemAt dependencies 1) 1;
             |       ^
          315|       depsTargetTarget            = lib.elemAt (lib.elemAt dependencies 2) 0;
(use '--show-trace' to show detailed location information)

```

notably, `stack build --nix` alone works; so i don't understand why.
