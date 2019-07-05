import 'package:flutter/material.dart';
import 'projection.dart';
import 'scale.dart';
import 'track.dart';
import 'indicator.dart';
import 'sensor.dart';

class CompassRose extends StatelessWidget {
  CompassRose({this.sensor});

  final CompassRoseSensorBloc sensor;

  @override
  Widget build(BuildContext context) {
    return CompassRoseSensor(
      bloc: sensor,
      child: Projection(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Scale(),
            Track(),
            Indicator(),
          ],
        ),
      ),
    );
  }
}
