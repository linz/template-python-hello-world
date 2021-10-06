from src.salutation import hello


def test_hello_without_name() -> None:
    assert hello() == "Hello, World!"


def test_hello_with_sample_name() -> None:
    assert hello("Alice") == "Hello, Alice!"


def test_hello_with_macronated_name() -> None:
    assert hello("Ātaahua") == "Hello, Ātaahua!"
