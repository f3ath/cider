import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cider/src/cli/config.dart';
import 'package:cider/src/cli/console.dart';
import 'package:cider/src/cli/find_project_root.dart';
import 'package:cider/src/project.dart';
import 'package:cider/src/pubspec_file.dart';
import 'package:rfc_6901/rfc_6901.dart';
import 'package:yaml/yaml.dart';

abstract class CiderCommand extends Command<int> {
  CiderCommand(this.console);

  final Console console;

  Future<int> exec(Project project);

  @override
  Future<int> run() async {
    final projectRoot = globalResults!['project-root'] ??
        (await findProjectRoot(Directory.current)).absolute.path;
    final config = await _readConfigFromPubspec(projectRoot);
    return await exec(Project(projectRoot, config));
  }

  Future<Config> _readConfigFromPubspec(String projectRoot) async {
    final pubspec =
        loadYaml(await pubspecFile(projectRoot).readAsString()) as Map;
    final config = pubspec.read<Map>('/cider', orElse: () => {});
    final diffTemplate =
        config.read<String>('/link_template/diff', orElse: () => '');
    final tagTemplate =
        config.read<String>('/link_template/tag', orElse: () => '');
    final versionTemplate =
        config.read<String>('/link_template/version', orElse: () => '');
    final keepEmptyUnreleased =
        config.read<bool>('/keep_empty_unreleased', orElse: () => false);

    return Config(
      diffTemplate: diffTemplate,
      tagTemplate: tagTemplate,
      versionTemplate: versionTemplate,
      keepEmptyUnreleased: keepEmptyUnreleased,
    );
  }

  @override
  printUsage() => console.out.writeln(usage);
}

extension _Map on Map {
  T read<T>(String pointer, {T Function()? orElse}) =>
      JsonPointer(pointer).read(this, orElse: orElse) as T;
}
