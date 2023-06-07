import 'dart:async';
import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cider/cider.dart';
import 'package:cider/src/cider_command.dart';
import 'package:cider/src/service/changelog_service.dart';
import 'package:cider/src/service/pubspec_service.dart';
import 'package:klizma/klizma.dart';
import 'package:path/path.dart';

class Cider {
  Cider(
      {Iterable<void Function(Cider cider)> plugins = const [],
      String name = 'cider',
      String description = 'Dart package release tools.',
      io.Directory? root})
      : _runner = CommandRunner<CiderCommand>(name, description) {
    _di.provide((_) => _findRoot(root ?? io.Directory.current), name: 'root');
    _di.provide<io.Stdout>((_) => io.stdout);
    _di.provide<io.Stdout>((_) => io.stderr, name: 'stderr');
    [
      PubspecService.install,
      ChangelogService.install,
    ].followedBy(plugins).forEach((install) => install(this));
  }

  /// Finds the project root by locating 'pubspec.yaml'.
  /// Starts from [dir] and makes its way up to the system root folder.
  /// Throws a [StateError] if 'pubspec.yaml' can not be located.
  static io.Directory _findRoot(io.Directory dir) {
    if (io.File(join(dir.path, 'pubspec.yaml')).existsSync()) return dir;
    if (io.FileSystemEntity.identicalSync(dir.path, dir.parent.path)) {
      throw StateError('Can not find project root');
    }
    return _findRoot(dir.parent);
  }

  static const exitOK = 0;
  static const exitUsageException = 1;
  static const exitException = 64;

  final _di = Container();
  final _handler = <CiderCommand, Handler>{};
  final CommandRunner<CiderCommand> _runner;

  /// Adds a new service to be available for other services and handlers
  /// Some of the built-in services are:
  /// - `get<Directory>('root')` - project root folder (the one containing pubspec.yaml)
  /// - `get<PubspecService>()` - manipulates the pubspec.yaml
  /// - `get<ChangelogService>()` - manipulates the changelog
  /// - `get<Stdout>()` - the dart:io `stdout` sink (for testability)
  /// - `get<Stdout>('stderr')` - the dart:io `stderr` sink (for testability)
  void provide<T extends Object>(FactoryFun<T> factory,
      {String name = '', bool cached = true}) {
    _di.provide<T>(factory, name: name, cached: cached);
  }

  /// Adds a new [command] which, when invoked, will be served by the handler
  /// produced by [handlerFactory].
  void addCommand(CiderCommand command, Handler handler) {
    _handler[command] = handler;
    _runner.addCommand(command);
  }

  Future<int> run(Iterable<String> args) async {
    try {
      final cmd = await _runner.run(args);
      final handler = _handler[cmd];
      if (handler != null) {
        return await handler(cmd!.argResults!, _di.get);
      }
      return 0;
    } on Error catch (e) {
      _di.get<io.Stdout>('stderr').writeln(e);
      _di.get<io.Stdout>('stderr').writeln(e.stackTrace);
      return exitException;
    }
  }
}

/// A command handler
typedef Handler = FutureOr<int> Function(ArgResults args, ServiceLocator get);
