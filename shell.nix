let
  pkgs = import (builtins.fetchTarball {
    name = "nixos-unstable-2024-09-17";
    url = "https://github.com/nixos/nixpkgs/archive/345c263f2f53a3710abe117f28a5cb86d0ba4059.tar.gz";
    sha256 = "1llzyzw7a0jqdn7p3px0sqa35jg24v5pklwxdybwbmbyr2q8cf5j";
  }) { overlays = [ (_final: prev: { geos = prev.geos_3_11; }) ]; };
  poetry2nix = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/poetry2nix/archive/2024.9.1542864.tar.gz";
    sha256 = "06vz5hwylvjvx4ywbv4y3kadq8zxmvpf5h7pjy6w1yhkwpjd6k25";
  }) { inherit pkgs; };
  poetryEnv = poetry2nix.mkPoetryEnv {
    projectDir = builtins.path {
      path = ./.;
      name = "template-python-hello-world";
    };
    python = pkgs.python311;
  };
in
poetryEnv.env.overrideAttrs (_oldAttrs: {
  buildInputs = [
    pkgs.bashInteractive
    pkgs.cacert
    pkgs.deadnix
    pkgs.gitFull
    pkgs.niv
    pkgs.nixfmt-rfc-style
    pkgs.nodejs
    pkgs.poetry
    pkgs.statix
    pkgs.which
  ];
  shellHook = ''
    ln --force --no-target-directory --symbolic "${poetryEnv}/bin/python" python
  '';
})
