import 'dart:io';

class Printer {
  Printer({this.out = const StdOutChannel(), this.err = const StdErrChannel()});

  final Channel out;
  final Channel err;
}

abstract interface class Channel {
  void writeln([Object message = '']);

  void write(Object message);
}

class StdOutChannel implements Channel {
  const StdOutChannel();

  @override
  void writeln([Object message = '']) => stdout.writeln(message);

  @override
  void write(Object message) => stdout.write(message);
}

class StdErrChannel implements Channel {
  const StdErrChannel();

  @override
  void writeln([Object message = '']) => stderr.writeln(message);

  @override
  void write(Object message) => stderr.write(message);
}

class BufferChannel implements Channel {
  final buffer = StringBuffer();

  @override
  void writeln([Object message = '']) => buffer.writeln(message);

  @override
  void write(Object message) => buffer.write(message);
}
