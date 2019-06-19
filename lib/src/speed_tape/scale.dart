import 'package:flutter/material.dart';
import 'projection.dart';
import 'envelope.dart';

class Scale extends StatelessWidget {
  Scale(
      {this.speedOffset = 20,
      this.majorSpeedStep = 20,
      this.minorSpeedStep = 10})
      : assert(speedOffset != null),
        assert(majorSpeedStep != null),
        assert(minorSpeedStep != null);

  final int speedOffset;
  final int majorSpeedStep;
  final int minorSpeedStep;

  @override
  Widget build(BuildContext context) {
    final projection = Projection.of(context);
    final envelope = Envelope.of(context);

    return CustomPaint(
      painter: _ScalePainter(
          scale: this, projection: projection, envelope: envelope),
    );
  }
}

class _ScalePainter extends CustomPainter {
  _ScalePainter(
      {@required this.scale,
      @required this.projection,
      @required this.envelope})
      : assert(scale != null),
        assert(projection != null),
        assert(envelope != null),
        maxSpeed =
            projection.speedBounds.limit(envelope.vne + scale.speedOffset),
        minSpeed =
            projection.speedBounds.limit(envelope.vs - scale.speedOffset);

  final int maxSpeed;
  final int minSpeed;
  final Scale scale;
  final Projection projection;
  final EnvelopeData envelope;

  final _scalePaint = new Paint()
    ..color = Colors.white
    ..strokeWidth = 1.5;

  final _textPainter = TextPainter(textDirection: TextDirection.ltr);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, 0.0);
    canvas.drawLine(
        Offset(
            1.0, projection.project(projection.speedBounds.max, size.height)),
        Offset(
            1.0, projection.project(projection.speedBounds.min, size.height)),
        _scalePaint);

    var tickMarkValue = maxSpeed;
    canvas.translate(0.0, projection.project(tickMarkValue, size.height));

    while (tickMarkValue >= minSpeed) {
      canvas.drawLine(
          Offset(tickMarkValue % scale.majorSpeedStep == 0 ? -20 : -10, 0),
          Offset(0, 0),
          _scalePaint);

      if (tickMarkValue % scale.majorSpeedStep == 0) {
        _textPainter
          ..text = TextSpan(text: '$tickMarkValue')
          ..layout()
          ..paint(canvas,
              Offset(-_textPainter.width - 25, -_textPainter.height / 2));
      }

      tickMarkValue -= scale.minorSpeedStep;
      canvas.translate(
          0.0, projection.translate(scale.minorSpeedStep, size.height));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}
