import 'package:flutter/material.dart';

class CompassRoseSensor extends InheritedWidget {
  CompassRoseSensor({key, @required this.bloc, child})
      : assert(bloc != null),
        super(key: key, child: child);

  final CompassRoseSensorBloc bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => this != oldWidget;

  static CompassRoseSensorBloc of(BuildContext context) {
    final CompassRoseSensor input =
        context.inheritFromWidgetOfExactType(CompassRoseSensor);
    return input?.bloc;
  }
}

abstract class CompassRoseSensorBloc {
  Stream<double> get heading;
  Stream<double> get track;
}
