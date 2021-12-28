library testing;

import 'dart:convert';
import 'dart:io' as io;

class MockStdout implements io.Stdout {
  /// Accumulated output
  final buffer = StringBuffer();

  @override
  Encoding encoding = Utf8Codec();

  @override
  void add(List<int> data) {}

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future addStream(Stream<List<int>> stream) {
    throw UnimplementedError();
  }

  @override
  Future close() {
    throw UnimplementedError();
  }

  @override
  Future get done => throw UnimplementedError();

  @override
  Future flush() {
    throw UnimplementedError();
  }

  @override
  bool hasTerminal = true;

  @override
  io.IOSink get nonBlocking => throw UnimplementedError();

  @override
  bool supportsAnsiEscapes = true;

  @override
  int terminalColumns = 80;

  @override
  int terminalLines = 25;

  @override
  void write(Object? object) => buffer.write(object);

  @override
  void writeAll(Iterable objects, [String sep = '']) =>
      buffer.writeAll(objects, sep);

  @override
  void writeCharCode(int charCode) => buffer.writeCharCode(charCode);

  @override
  void writeln([Object? object = '']) => buffer.writeln(object);
}
