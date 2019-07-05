import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'projection.dart';
import 'sensor.dart';

class Track extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final projection = Projection.of(context);
    final sensor = CompassRoseSensor.of(context);

    return StreamBuilder(
      stream: sensor.track,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomPaint(
            painter:
                _TrackPainter(track: snapshot.data, projection: projection),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

class _TrackPainter extends CustomPainter {
  _TrackPainter({@required this.track, @required this.projection})
      : assert(track != null),
        assert(track > 0 && track <= 360),
        assert(projection != null);

  final double track;
  final ProjectionData projection;

  final _trackPaint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = 1.5;

  final _textPainter = TextPainter(
      textDirection: TextDirection.ltr, textAlign: TextAlign.center);

  final _textStyle =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

  @override
  void paint(Canvas canvas, Size size) {
    final geometry = Geometry(size: size);
    final radial = projection.projectHeading(track, geometry);

    canvas.translate(size.width / 2, geometry.radius);
    canvas.rotate(radial.angle);

    canvas.drawLine(
        Offset(0.0, -radial.length), Offset(0.0, -10.0), _trackPaint);

    canvas.translate(0, -radial.length + 32);

    canvas.drawCircle(Offset.zero, 20.0, _trackPaint);

    canvas.rotate(-radial.angle);

    _textPainter
      ..text = TextSpan(text: '${track.toInt()}', style: _textStyle)
      ..layout(minWidth: 40.0, maxWidth: 40.0)
      ..paint(canvas, Offset(-20.0, -_textPainter.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}
