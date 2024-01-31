import 'package:cider/src/cli/command/cider_command.dart';
import 'package:cider/src/project.dart';
import 'package:pub_semver/pub_semver.dart';

class VersionCommand extends CiderCommand {
  VersionCommand(super.console);

  @override
  final name = 'version';
  @override
  final description = 'Reads/writes project version';

  @override
  Future<int> exec(Project project) async {
    if (argResults!.rest.isNotEmpty) {
      final version = Version.parse(argResults!.rest.first);
      await project.setVersion(version);
    }
    console.out.writeln(await project.getVersion());
    return 0;
  }
}
