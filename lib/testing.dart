library testing;

import 'dart:convert';
import 'dart:io' as io;

class MockStdout implements io.Stdout {
  /// Accumulated output
  final buffer = StringBuffer();

  @override
  Encoding encoding = Utf8Codec();

  @override
  void add(List<int> data) {
    // TODO: implement add
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    // TODO: implement addError
  }

  @override
  Future addStream(Stream<List<int>> stream) {
    // TODO: implement addStream
    throw UnimplementedError();
  }

  @override
  Future close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  // TODO: implement done
  Future get done => throw UnimplementedError();

  @override
  Future flush() {
    // TODO: implement flush
    throw UnimplementedError();
  }

  @override
  bool hasTerminal = true;

  @override
  // TODO: implement nonBlocking
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
