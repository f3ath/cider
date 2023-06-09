import 'package:args/command_runner.dart';
import 'package:cider/src/cli/console.dart';

class ErrorInterceptor {
  ErrorInterceptor(this.printer);

  final Console printer;

  /// POSIX exit codes from sysexits.h
  static const exitOK = 0;
  static const exitUsageError = 64;
  static const exitDataError = 65;
  static const exitSoftwareError = 70;

  Future<int> run(Future<int?> Function() f) async {
    try {
      return await f() ?? exitOK;
    } on UsageException {
      return exitUsageError;
    } on ArgumentError catch (e) {
      printer.err.writeln(e.message);
      return exitDataError;
    } catch (e) {
      printer.err.writeln(e);
      return exitSoftwareError;
    }
  }
}
