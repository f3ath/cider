import 'package:cider/src/project.dart';
import 'package:cider/src/cli/command/cider_command.dart';

class UnyankCommand extends CiderCommand {
  UnyankCommand(super.printer);

  @override
  final name = 'unyank';
  @override
  final description = 'Unyank a version in the changelog';

  @override
  Future<int> exec(Project project) async {
    final version = argResults!.rest.first;
    final release = await project.setYanked(version, false);
    printer.out.writeln(release);
    return 0;
  }
}
