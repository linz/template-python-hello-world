let
  pkgs = import
    (
      builtins.fetchTarball {
        name = "nixos-unstable-2021-09-14";
        url = "https://github.com/nixos/nixpkgs/archive/6f5e9a6f7bc5b83bcfd09f4a2d32e3a35d62fb16.tar.gz";
        sha256 = "189k0yxg5zmkab1a8cvhjy348ggby086fci6mdhhqymsj6ivazjs";
      })
    { };
  poetryEnv = pkgs.poetry2nix.mkPoetryEnv {
    python = pkgs.python39;
    projectDir = builtins.path { path = ./.; name = "project"; };

    overrides = pkgs.poetry2nix.overrides.withDefaults (
      self: super: {

        astroid = super.astroid.overridePythonAttrs (
          old: {
            propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.typing-extensions ];
          }
        );

        # https://github.com/nix-community/poetry2nix/issues/357
        backports-entry-points-selectable = super.backports-entry-points-selectable.overridePythonAttrs (
          old: {
            postPatch = ''
              substituteInPlace setup.py --replace \
                'setuptools.setup()' \
                'setuptools.setup(version="${old.version}")'
            '';
          }
        );

        # https://github.com/nix-community/poetry2nix/issues/323
        mypy =
          if pkgs.lib.versionAtLeast super.mypy.version "0.900" then
            super.mypy.overridePythonAttrs
              (
                old: {
                  MYPY_USE_MYPYC = false;
                }
              ) else super.mypy;

        # https://github.com/nix-community/poetry2nix/issues/340
        pylint = super.pylint.overridePythonAttrs (
          old: {
            postPatch = ''
              substituteInPlace setup.cfg --replace 'platformdirs>=2.2.0' 'platformdirs'
            '';
          }
        );
        virtualenv = super.virtualenv.overridePythonAttrs (
          old: {
            postPatch = ''
              substituteInPlace setup.cfg --replace 'platformdirs>=2,<3' 'platformdirs'
            '';
          }
        );

        # https://github.com/nix-community/poetry2nix/issues/322
        ruamel-yaml = super.ruamel-yaml.overridePythonAttrs (
          old: {
            propagatedBuildInputs = (
              old.propagatedBuildInputs or [ ]
            ) ++ [ self.ruamel-yaml-clib ];
          }
        );

        # https://github.com/nix-community/poetry2nix/pull/366#issuecomment-922548728
        pytest = super.pytest.overrideAttrs (
          old: {
            propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.importlib-metadata ];
          }
        );
      }
    );
  };
in
pkgs.mkShell {
  buildInputs = [
    poetryEnv
    pkgs.pre-commit
  ];
}
