"""
Tests for the hello() function.
"""

from module_name.salutation import hello


def test_hello_without_name() -> None:
    """Test with no parameter."""
    assert hello() == "Hello, World!"


def test_hello_with_sample_name() -> None:
    """Test with a name supplied."""
    assert hello("Alice") == "Hello, Alice!"


def test_hello_with_macronated_name() -> None:
    """Test with a macronated name supplied."""
    assert hello("Ātaahua") == "Hello, Ātaahua!"
