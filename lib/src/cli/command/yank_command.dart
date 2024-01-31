import 'package:cider/src/project.dart';
import 'package:cider/src/cli/command/cider_command.dart';

class YankCommand extends CiderCommand {
  YankCommand(super.console);

  @override
  final name = 'yank';
  @override
  final description = 'Yank a version from the changelog';

  @override
  Future<int> exec(Project project) async {
    final version = argResults!.rest.first;
    final release = await project.setYanked(version, true);
    console.out.writeln(release);
    return 0;
  }
}
