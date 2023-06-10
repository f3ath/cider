import 'package:cider/src/project.dart';
import 'package:cider/src/cli/command/cider_command.dart';

class ReleaseCommand extends CiderCommand {
  ReleaseCommand(super.printer) {
    argParser.addOption('date', help: 'Release date', defaultsTo: 'today');
  }

  @override
  final name = 'release';
  @override
  final description = 'Release the unreleased changes';

  @override
  Future<int> exec(Project project) async {
    final date = argResults!['date'];
    final parsedDate = date == 'today' ? DateTime.now() : DateTime.parse(date);
    final release = await project.release(parsedDate);
    printer.out.writeln(release);
    return 0;
  }
}
