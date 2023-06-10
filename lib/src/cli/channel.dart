import 'dart:io';

abstract interface class Channel {
  void writeln([Object message = '']);
}

// coverage:ignore-start
class StdOutChannel implements Channel {
  const StdOutChannel();

  @override
  void writeln([Object message = '']) => stdout.writeln(message);
}
// coverage:ignore-end

// coverage:ignore-start
class StdErrChannel implements Channel {
  const StdErrChannel();

  @override
  void writeln([Object message = '']) => stderr.writeln(message);
}
// coverage:ignore-end

class BufferChannel implements Channel {
  final buffer = StringBuffer();

  @override
  void writeln([Object message = '']) => buffer.writeln(message);
}
