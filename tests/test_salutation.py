from typer.testing import CliRunner

from src.salutation import app, hello

CLI_RUNNER = CliRunner()


def test_hello_without_name() -> None:
    assert hello() == "Hello, World!"


def test_hello_with_sample_name() -> None:
    assert hello("Alice") == "Hello, Alice!"


def test_hello_with_macronated_name() -> None:
    assert hello("Ātaahua") == "Hello, Ātaahua!"


def test_cli_name() -> None:
    result = CLI_RUNNER.invoke(app, ["--name=Bob"])
    assert result.exit_code == 0, result


def test_cli_help() -> None:
    result = CLI_RUNNER.invoke(app, ["--help"])
    assert result.exit_code == 0, result
