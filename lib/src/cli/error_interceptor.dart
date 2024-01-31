import 'package:args/command_runner.dart';
import 'package:cider/src/cli/console.dart';

class ErrorInterceptor {
  ErrorInterceptor(this.console);

  final Console console;

  /// POSIX exit codes from sysexits.h
  static const exitOK = 0;
  static const exitUsageError = 64;
  static const exitDataError = 65;
  static const exitSoftwareError = 70;

  Future<int> run(Future<int?> Function() f) async {
    try {
      return await f() ?? exitOK;
    } on UsageException catch (e) {
      console.err.writeln(e.usage);
      return exitUsageError;
    } on ArgumentError catch (e) {
      console.err.writeln(e.message);
      return exitDataError;
    } catch (e) {
      console.err.writeln(e);
      return exitSoftwareError;
    }
  }
}
