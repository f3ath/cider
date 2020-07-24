import 'dart:io';

/// A very simple Console output abstraction.
/// Allows to print log messages and error messages.
class Console {
  /// Creates an instance with
  const Console(this._output, this._error);

  Console.stdio() : this(stdout, stderr);

  final Stdout _output;

  final Stdout _error;

  /// Writes the [message] to the error sink
  void error(Object message) => _error.writeln(message.toString());

  /// Writes the [message] the to the normal output sink
  void log(Object message) => _output.writeln(message.toString());
}
