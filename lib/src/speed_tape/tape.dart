import 'package:flight_display/flight_display.dart';
import 'package:flutter/material.dart';
import 'projection.dart';

class Tape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final projection = Projection.of(context);
    final envelope = Envelope.of(context);
    final theme = Theme.of(context);

    return CustomPaint(
      painter: _TapePainter(
          projection: projection, envelope: envelope, theme: theme),
    );
  }
}

class _TapePainter extends CustomPainter {
  _TapePainter(
      {@required this.projection,
      @required this.envelope,
      @required this.theme})
      : assert(projection != null),
        assert(envelope != null),
        assert(theme != null);

  final Projection projection;
  final EnvelopeData envelope;
  final ThemeData theme;

  final _tapePaint = new Paint()
    ..strokeWidth = 1.5;

  void _paintTape(
      Canvas canvas, Size size, int maxSpeed, int minSpeed, Color color) {
    _tapePaint.color = color;

    canvas.drawRect(
        Rect.fromLTRB(-10.0, projection.project(maxSpeed, size.height), 0.0,
            projection.project(minSpeed, size.height)),
        _tapePaint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, 0.0);

    _paintTape(canvas, size, projection.speedBounds.max,
        projection.speedBounds.min, EnvelopeData.outOfSpeedRangeColor);

    envelope.speedRanges.forEach((range) {
      _paintTape(canvas, size, range.max, range.min,
          range.color ?? theme.scaffoldBackgroundColor);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}
