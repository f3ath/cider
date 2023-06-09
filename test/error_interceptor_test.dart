import 'package:cider/src/cli/channel.dart';
import 'package:cider/src/cli/error_interceptor.dart';
import 'package:cider/src/cli/console.dart';
import 'package:test/test.dart';

void main() {
  final out = BufferChannel();
  final err = BufferChannel();
  final printer = Console(out: out, err: err);
  final interceptor = ErrorInterceptor(printer);

  test('default handler prints to stderr and returns 70', () async {
    final code = await interceptor.run(() => throw 'Foo');
    expect(code, equals(70));
    expect(err.buffer.toString(), equals('Foo\n'));
  });
}
