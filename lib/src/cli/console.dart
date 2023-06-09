import 'package:cider/src/cli/channel.dart';

class Console {
  const Console({
    this.out = const StdOutChannel(),
    this.err = const StdErrChannel(),
  });

  final Channel out;
  final Channel err;
}
