import 'dart:math' as math;
import 'package:flutter/material.dart';

class Projection extends InheritedWidget {
  Projection({key, @required this.speedBounds, child})
      : assert(speedBounds != null),
        super(key: key, child: child);

  final SpeedBounds speedBounds;

  double project(num speed, double size, [double offset = 0]) {
    final ratio = size / (speedBounds.max - speedBounds.min);
    final position = (speedBounds.max - speed) * ratio;
    return math.min(math.max(position, offset), size - offset);
  }

  double translate(num dSpeed, double size) {
    final ratio = size / (speedBounds.max - speedBounds.min);
    return dSpeed * ratio;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => this != oldWidget;

  static Projection of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(Projection) as Projection;
  }
}

class SpeedBounds {
  SpeedBounds({@required this.max, @required this.min})
      : assert(max != null),
        assert(min != null),
        assert(max > min),
        assert(min >= 0);

  final int max;
  final int min;

  int limit(num speed) => math.min(math.max(speed, min), max);
}
