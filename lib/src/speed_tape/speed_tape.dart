import 'package:flutter/material.dart';
import 'projection.dart';
import 'envelope.dart';
import 'sensor.dart';
import 'indicator.dart';
import 'scale.dart';
import 'tape.dart';

class SpeedTape extends StatelessWidget {
  SpeedTape({@required this.envelope, @required this.sensor})
      : assert(envelope != null),
        assert(sensor != null);

  final int speedOffset = 20;
  final EnvelopeData envelope;
  final SensorBloc sensor;

  @override
  Widget build(BuildContext context) {
    return Projection(
      speedBounds: SpeedBounds(
        max: envelope.vne + speedOffset * 2,
        min: envelope.vs - speedOffset * 2,
      ),
      child: Envelope(
        data: envelope,
        child: Sensor(
          bloc: sensor,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Tape(),
              Scale(speedOffset: speedOffset),
              Indicator()
            ],
          ),
        ),
      ),
    );
  }
}
