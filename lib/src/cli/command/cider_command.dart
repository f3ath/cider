import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cider/src/cli/config.dart';
import 'package:cider/src/cli/console.dart';
import 'package:cider/src/cli/find_project_root.dart';
import 'package:cider/src/project.dart';
import 'package:cider/src/pubspec_file.dart';
import 'package:yaml/yaml.dart';

abstract class CiderCommand extends Command<int> {
  CiderCommand(this.console);

  final Console console;

  Future<int> exec(Project project);

  @override
  Future<int> run() async {
    final projectRoot = globalResults!['project-root'] ??
        (await findProjectRoot(Directory.current)).absolute.path;
    final pubspecYaml = loadYaml(await pubspecFile(projectRoot).readAsString());
    final config = Config.fromPubspec(pubspecYaml as Map);
    return await exec(Project(projectRoot, config));
  }

  @override
  printUsage() => console.out.writeln(usage);
}
