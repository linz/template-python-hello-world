# Hello World

[![Build Status](https://github.com/linz/template-python-hello-world/workflows/Build/badge.svg)](https://github.com/linz/template-python-hello-world/actions)
[![Code Style](https://img.shields.io/badge/Code%20Style-black-000000.svg)](https://github.com/psf/black)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/linz/template-python-hello-world/blob/master/LICENSE)

A minimal template for Python development.

## Structure

This is a very simple, single Python module. It is not a Python package and does not contain the structure or tooling required for packaging a Python project.

This repository exists to show basic Python formatting, linting and import sorting configurations with continuous integration.

## Formatting

Formatting is handled by `black`.

The configuration is stored in `pyproject.toml`.

## Linting

Linting is handled by `pylint`.

The configuration is stored in `.pylintrc`.

## Sorting Imports

Import sorting is handled by `isort`.

The configuration is stored in `pyproject.toml`.

### VSCode Configuration

It is possible to configure VSCode to run `isort` every time you save, using the `codeActionsOnSave": { "source.organizeImports": true }` setting. This currently causes a race condition when formatting by `black` is also configured to occur on save (`"editor.formatOnSave": true`), leading to lines being erroneously deleted. The VSCode Python team [can't do anything](https://github.com/Microsoft/vscode-python/issues/2301) about this.

The configuration stored here works with `black` - that is to say, `black` will not reformat changes made by `isort` - but it is still unsafe to apply both commands simultaneously.

In VSCode, you can manually trigger import sorting by:

* right clicking anywhere within a file and selecting `Sort Imports`.
* command palette (`Ctrl + Shift + P`), then `Python Refactor: Sort Imports`.
* creating a shortcut key for `python.sortImports`

There is also some discussion over [whether black should just handle import sorting itself](https://github.com/psf/black/issues/333).

## Line Length

Line length needs to be consistently configured for formatting, linting and while sorting imports. In order to change the line length for a specific project, it will need to be updated in the following locations:

* `.pylintrc`
* `pyproject.toml`

## Continuous Integration

### GitHub Actions

The GitHub Actions workflow is stored at `.github/workflows/push.yml`.

This configuration contains two jobs, with each containing a build matrix with two different versions of Python. The second job depends on the first job being completed successfully by using the `needs` key within the second job.

#### Linter

The first job, `linter`, tests formatting, linting and correct sorting of imports.

```bash
black . --check --diff
```

This command runs the `black` formatter over the Python files in the current directory. The `--check` flag ensures that the command will error out if any changes are required, rather than making changes. `--diff` will show the difference.

`black` will respect the line length configuration stored in `pyproject.toml`.

```bash
pylint salutation.py test_salutation.py
```

This command runs the `pylint` checks for errors, bugs, non-conforming code style and potential code structure improvements over our Python module and tests.

`pylint` uses the configurations stored in `.pylintrc`.

```bash
isort -rc . --check --diff
```

This command runs the `isort` import sorter recursively over the Python files in the current directory. The `--check` flag ensures that the command will error out if any changes are required, rather than making changes. `--diff` will show the difference.

`isort` will respect the configurations stored in `pyproject.toml`.

#### Test

The second job, `test`, runs tests using `pytest`.

```bash
pytest
```

Simply execute `pytest` and it will [find things that look like tests](http://doc.pytest.org/en/latest/goodpractices.html#conventions-for-python-test-discovery) and run them.

### Travis-CI

The Travis-CI configuration is stored in `.travis.yml`.

This configuration contains two jobs, with each containing a build matrix with two different versions of Python. The second job depends on the first job being completed successfully by using "build stages".

Travis-CI doesn't support their standard build matrix syntax while also using build stages, but creating two jobs with the same name within a build stage will have the same effect. This leads to a lot of repeated configuration code, so here we use a YAML alias to prevent configuration redundancy.

The actual tests applied are identical to those used in GitHub Actions.

## Development

Create and activate a virtual environment.

```bash
python3 -m venv .venv
source .venv/bin/activate
```

`python3` must be 3.6+

Install the required dependencies.

```bash
pip install -r requirements-dev.txt
```
