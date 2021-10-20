from typer import Option, Typer, echo

app = Typer()


def hello(name: str = "World") -> str:
    return f"Hello, {name}!"


@app.command()
def main(name: str = Option(...)) -> None:
    echo(hello(name))


if __name__ == "__main__":
    app()
