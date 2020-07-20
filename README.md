![Python Template - Hello World Banner](https://raw.githubusercontent.com/linz/template-python-hello-world/master/docs/_static/banner.png)

### _A minimal template for Python development_

[![GitHub Actions Status](https://github.com/linz/template-python-hello-world/workflows/Build/badge.svg)](https://github.com/linz/template-python-hello-world/actions)
[![Travis CI Status](https://badgen.net/travis/linz/template-python-hello-world/master?icon=travis&label=Travis&labelColor=2e3a44&color=3dc64b)](https://travis-ci.com/linz/template-python-hello-world)
[![Alerts](https://badgen.net/lgtm/alerts/g/linz/template-python-hello-world?icon=lgtm&labelColor=2e3a44&label=Alerts&color=3dc64b)](https://lgtm.com/projects/g/linz/template-python-hello-world/context:python)
[![Dependabot Status](https://badgen.net/dependabot/linz/template-python-hello-world?icon=dependabot&labelColor=2e3a44&color=blue)](https://dependabot.com)
[![License](https://badgen.net/github/license/linz/template-python-hello-world?labelColor=2e3a44&label=License)](https://github.com/linz/template-python-hello-world/blob/master/LICENSE)
[![Conventional Commits](https://badgen.net/badge/Commits/conventional?labelColor=2e3a44&color=EC5772)](https://conventionalcommits.org)
[![Code Style](https://badgen.net/badge/Code%20Style/black?labelColor=2e3a44&color=000000)](https://github.com/psf/black)

## Why?

This repository exists to show a working example of Python formatting, linting and import sorting configurations with continuous integration.

## Structure

This is a very simple, single Python module. It is not a Python package and does not contain the structure or tooling required for packaging / installing a Python project.

## Formatting

Formatting is handled by `black`.

Black is an uncompromising Python code formatting tool. It takes a Python file as an input, and provides a reformatted Python file as an output, using rules that are a strict subset of [PEP 8](https://www.python.org/dev/peps/pep-0008/). It offers very little in the way of configuration (line length being the main exception) in order to achieve formatting consistency. It is deterministic - it will always produce the same output from the same inputs.

The line length configuration is stored in `pyproject.toml`.

Configuring Black to automatically run every time code is modified allows developers to forget about _how_ code should be formatted and stay focused on functionality. Many IDEs and text editors allow this. Git hooks can also be used to execute Black before Python code is committed to a repository - this is not configured here as use of autosave and continuous integration checks makes it redundant.

### VSCode Configuration

In VSCode, you can set the default Python formatter using the setting: `"python.formatting.provider": "black"`, and then turn on autosave using `"editor.formatOnSave": true`. VSCode will pick up the line length configuration from a `pyproject.toml` file per repository.

## Linting

Linting is handled by `pylint`.

Pylint checks Python files in order to detect syntax errors and potential bugs (unreachable code / unused variables), provide refactoring help,

The configuration is stored in `.pylintrc`.

### VSCode Configuration

Pylint is enabled by default in VSCode. VSCode will respect Pylint configurations stored in a `.pylintrc` file per repository.

## Sorting Imports

Import sorting is handled by `isort`.

isort sorts Python imports alphabetically within their respective sections:

1. Standard library imports
2. Related third party imports
3. Local application / library specific imports

isort has many configuration options but these can cause inconsistencies with Black, so must be carefully assessed. The configurations within this repository will provide consistently ordered / formatted imports.

The configuration is stored in `pyproject.toml`.

### VSCode Configuration

It is possible to configure VSCode to run `isort` every time you save, using the `codeActionsOnSave": { "source.organizeImports": true }` setting. This currently causes a race condition when formatting by `black` is also configured to occur on save (`"editor.formatOnSave": true`), leading to lines being erroneously deleted. The VSCode Python team [can't do anything](https://github.com/Microsoft/vscode-python/issues/2301) about this.

The configuration stored here works with `black` - that is to say, `black` will not reformat changes made by `isort` - but it is still unsafe to apply both commands simultaneously.

In VSCode, you can manually trigger import sorting by:

- right clicking anywhere within a file and selecting `Sort Imports`.
- command palette (`Ctrl + Shift + P`), then `Python Refactor: Sort Imports`.
- creating a shortcut key for `python.sortImports`

There is also some discussion over [whether black should just handle import sorting itself](https://github.com/psf/black/issues/333).

## Line Length

Line length needs to be consistently configured for formatting, linting and while sorting imports. In order to change the line length for a specific project, it will need to be updated in the following locations:

- `.pylintrc`
- `pyproject.toml`

## Commit Messages

Commit messages must conform to [conventional commits](https://www.conventionalcommits.org/):

```
type(optional-scope): description
```

where type is one of `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, `test` as specified in `.gitlint`.

For example:

```
ci(github-actions): add new matrix jobs for Python 3.8
```

## Continuous Integration

### GitHub Actions

The GitHub Actions workflow is stored at `.github/workflows/push.yml`.

This configuration contains two jobs, with each containing a build matrix with two different versions of Python. The second job depends on the first job being completed successfully by using the `needs` key within the second job.

#### Linter

The first job, `linter`, tests formatting, linting and correct sorting of imports.

```bash
gitlint
```

This command runs `gitlint` on the **most recent commit**, to check that commit message titles conform to the conventional commits specification. Earlier commits may not conform, but all commits that are included in a Pull Request are checked by the next command. Pull Requests are the recommended code review workflow before merging into master.

```bash
gitlint --commits origin/${{ github.base_ref }}..${{ github.event.pull_request.head.sha }}
```

This command runs `gitlint` over **all commits** in a Pull Request, to check that commit message titles conform to the conventional commits specification.

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

## Automated Dependency Updates

### Dependabot

Dependabot is enabled on this repository. There is no special configuration here, and enabling Dependabot occurs at the GitHub organisation level.

Dependabot checks the dependencies listed in `requirements-dev.txt` daily to check if any new versions of those dependencies have been released. If Dependabot finds a new release, it opens a new Pull Request with a version bump, and attempts to show the changelog for that change. It also provides a compatibility prediction based on all of the Pull Requests that it has opened on other open source repositories and whether continous integration was successful.

Dependabot is owned by GitHub and free for both open source and private repositories.

## Automated Vulnerability Checks

### LGTM

LGTM is enabled on this repository. There is no special configuration here, and enabling LGTM occurs at the GitHub organisation level.

LGTM provides automated code review and security analysis.

LGTM is owned by GitHub and free for open source repositories. It can only be enabled on private repositories by building your own instance of LGTM.

## Development

Create and activate a virtual environment.

```bash
python3 -m venv .venv
source .venv/bin/activate
```

`python3` must be 3.6+

Upgrade pip and install the required dependencies.

```bash
pip install --upgrade pip
pip install -r requirements-dev.txt
```

Install commit-msg git hook.

```bash
pre-commit install --hook-type commit-msg
```
