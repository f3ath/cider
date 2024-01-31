import 'package:cider/src/cli/channel.dart';
import 'package:cider/src/cli/console.dart';
import 'package:cider/src/cli/error_interceptor.dart';
import 'package:test/test.dart';

void main() {
  final out = BufferChannel();
  final err = BufferChannel();
  final console = Console(out: out, err: err);
  final interceptor = ErrorInterceptor(console);

  test('default handler prints to stderr and returns 70', () async {
    final code = await interceptor.run(() => throw 'Foo');
    expect(code, equals(70));
    expect(err.buffer.toString(), equals('Foo\n'));
  });
}
