import 'package:test/test.dart';

void expectSubcommandsUsage(String output, {String? command}) {
  if (command != null) {
    expect(output, contains('Usage: cider $command <subcommand> [arguments]'));
  }
  expect(output, contains('-h, --help    Print this usage information.'));
  expect(output, contains('Available subcommands:'));
  expect(output, contains('Run "cider help" to see global options.'));
}
