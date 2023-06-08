import 'package:cider/src/cli/command/cider_command.dart';

class UnyankCommand extends CiderCommand {
  UnyankCommand(super.cider, super.printer);

  @override
  final name = 'unyank';
  @override
  final description = 'Unyank a version in the changelog';

  @override
  Future<int> run() async {
    final version = argResults!.rest.first;
    final release = await cider.unyank(context, version);
    printer.out.writeln(release);
    return 0;
  }
}
