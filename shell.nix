let
  pkgs =
    import
      (
        fetchTarball {
          name = "release-22.11-2023-02-27T22-57-04Z";
          url = "https://github.com/NixOS/nixpkgs/archive/51992e323a0e46a38ee36c3de7ff6d5755f0786c.tar.gz";
          sha256 = "0wmyhf5rqbq44fw22ij9dq5k5802ddv2wvszqmq85m7a2ghjb07w";
        }
      )
      { };

  poetryEnv = pkgs.poetry2nix.mkPoetryEnv {
    python = pkgs.python3;
    projectDir = builtins.path {
      path = ./.;
      name = "project";
    };
    overrides = pkgs.poetry2nix.overrides.withDefaults (
      self: super: {
        filelock = super.filelock.overridePythonAttrs (
          # In poetry2nix >1.39.1
          old: { buildInputs = (old.buildInputs or [ ]) ++ [ self.hatchling self.hatch-vcs ]; }
        );
      }
    );
  };
in
pkgs.mkShell {
  buildInputs = [
    pkgs.cacert
    pkgs.cargo
    pkgs.docker
    pkgs.gitFull
    pkgs.nodejs
    pkgs.pre-commit
    poetryEnv
  ];
}
