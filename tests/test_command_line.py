from typer.testing import CliRunner

from src.salutation import app


def test_should_print_hello_return_value() -> None:
    result = CliRunner().invoke(app, ["--name=Jane Doe"])

    assert result.stdout == "Hello, Jane Doe!\n"
