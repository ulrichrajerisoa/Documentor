# Documentor

A class documentation, software metrics, and AST-based mini-linter tool for Pharo 13 built with `MicMicrodownTextualBuilder` and SUnit tests.

## Authors

- Ulrich
- Gab

## Installation

Load the project in Pharo 13 using Metacello:

```smalltalk
Metacello new
	baseline: 'Documentor';
	repository: 'github://ulrichrajerisoa/Documentor/src';
	load.
