import 'package:args/command_runner.dart';

class CiderCommand extends Command<CiderCommand> {
  CiderCommand(this.name, this.description);

  @override
  final String name;

  @override
  final String description;

  @override
  CiderCommand run() => this;
}
