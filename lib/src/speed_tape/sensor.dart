import 'package:flutter/material.dart';

class Sensor extends InheritedWidget {
  Sensor({key, @required this.bloc, child})
      : assert(bloc != null),
        super(key: key, child: child);

  final SensorBloc bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => this != oldWidget;

  static SensorBloc of(BuildContext context) {
    final Sensor sensor = context.inheritFromWidgetOfExactType(Sensor);
    return sensor?.bloc;
  }
}

abstract class SensorBloc {
  Stream<double> get airSpeed;
}
