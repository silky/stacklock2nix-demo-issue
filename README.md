# notes

works:

```
> nix develop
> hpack --version
```

doesn't work:

```
> nix develop
> stack ghci --nix
> import System.Process
> system "hpack --version"
```

works!


```
> nix develop
> cabal repl
> import System.Process
> system "hpack --version"
```

### resolution

- add the right program to the `nativeBuildInputs` to `./nix/stack-shell.nix` !
