#!/usr/bin/env python3

"""
Tests for the hello() function.
"""

from salutation import hello


def test_hello_without_name():
    """Test with no parameter."""
    assert "Hello, World!", hello()


def test_hello_with_sample_name():
    """Test with a name supplied."""
    assert "Hello, Alice!", hello("Alice")


def test_hello_with_macronated_name():
    """Test with a macronated name supplied."""
    assert "Hello, Ātaahua!", hello("Ātaahua")
