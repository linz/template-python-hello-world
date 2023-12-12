let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};
  poetry2nix = import sources.poetry2nix {};
  poetryEnv = poetry2nix.mkPoetryEnv {
    projectDir = builtins.path {
      path = ./.;
      name = "template-python-hello-world";
    };
    overrides = poetry2nix.overrides.withDefaults (
      self: super: {
        pony = super.pony.overridePythonAttrs (
          old: {
            buildInputs =
              old.buildInputs
              or []
              ++ [
                self.hatch-fancy-pypi-readme
                self.hatchling
                self.hatch-vcs
              ];
          }
        );
      }
    );
  };
in
  poetryEnv.env.overrideAttrs (
    _oldAttrs: {
      buildInputs = [
        pkgs.alejandra
        pkgs.bashInteractive
        pkgs.cacert
        pkgs.deadnix
        pkgs.gitFull
        pkgs.niv
        pkgs.nodejs
        pkgs.poetry
        pkgs.statix
        pkgs.which
      ];
      shellHook = ''
        ln --force --no-target-directory --symbolic "${poetryEnv}/bin/python" python
      '';
    }
  )
