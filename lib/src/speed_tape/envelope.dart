import 'package:flutter/material.dart';

class Envelope extends InheritedWidget {
  Envelope({key, @required this.data, child})
      : assert(data != null),
        super(key: key, child: child);

  final EnvelopeData data;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => this != oldWidget;

  static EnvelopeData of(BuildContext context) {
    final Envelope envelope = context.inheritFromWidgetOfExactType(Envelope);
    return envelope?.data;
  }
}

class EnvelopeData {
  static const outOfSpeedRangeColor = Colors.red;

  EnvelopeData({@required this.vne, @required this.vs})
      : assert(vne != null),
        assert(vs != null),
        assert(vne > vs),
        speedRanges = <SpeedRange>[SpeedRange(min: vs, max: vne)];

  final int vne;
  final int vs;
  final List<SpeedRange> speedRanges;

  SpeedRange speedRange(speed) {
    return speedRanges.firstWhere((r) => speed >= r.min && speed <= r.max,
        orElse: () => null);
  }
}

class SpeedRange {
  SpeedRange({@required this.min, @required this.max, this.color})
      : assert(min != null),
        assert(max != null);

  final int min;
  final int max;
  final Color color;
}
