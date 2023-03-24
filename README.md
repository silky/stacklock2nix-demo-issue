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
