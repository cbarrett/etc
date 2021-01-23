{ linkFarm, fetchFromGitHub, lib, stdenv }:
with lib.attrsets;
let 
  isFetcherAttr = attr: _: attr != "optional" && attr != "fetch";
  mkPlugin = name: attrs:
    let fetcher =
          if attrs.fetch == "github" then fetchFromGitHub
          else abort("unknown value for ${name}.fetch: ${attrs.fetch}");
        fetcherAttrs = 
          (filterAttrs isFetcherAttr attrs) // { inherit name; };
    in {
      inherit name;
      path = fetcher fetcherAttrs;
      optional = attrs.optional or false;
    };
  plugins = mapAttrsToList mkPlugin (import ./vim-plugins.nix);
in
linkFarm "vim-plugins" [ {
    name = "start";
    path = linkFarm "vim-plugins-startup" 
      (builtins.filter (p: ! p.optional) plugins);
  } {
    name = "opt";
    path = linkFarm "vim-plugins-optional" 
      (builtins.filter (p: p.optional) plugins);
  } ]
