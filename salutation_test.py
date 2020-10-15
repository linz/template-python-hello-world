"""
Tests for the hello() function.
"""

from salutation import hello


def test_hello_without_name():
    """Test with no parameter."""
    assert hello() == "Hello, World!"


def test_hello_with_sample_name():
    """Test with a name supplied."""
    assert hello("Alice") == "Hello, Alice!"


def test_hello_with_macronated_name():
    """Test with a macronated name supplied."""
    assert hello("Ātaahua") == "Hello, Ātaahua!"
