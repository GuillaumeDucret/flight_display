import 'dart:math';

import 'package:flutter/material.dart';
import 'projection.dart';

class Scale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final projection = Projection.of(context);

    return CustomPaint(
      painter: _ScalePainter(scale: this, projection: projection),
    );
  }
}

class _ScalePainter extends CustomPainter {
  _ScalePainter({@required this.scale, @required this.projection})
      : assert(scale != null),
        assert(projection != null);

  final Scale scale;
  final ProjectionData projection;

  final _scalePaint = new Paint()
    ..color = Colors.white
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke;

  final _scaleCenterPaint = new Paint()
    ..color = Colors.white
    ..strokeWidth = 1.5;

  final _textPainter = TextPainter(textDirection: TextDirection.ltr);

  @override
  void paint(Canvas canvas, Size size) {
    final geometry = Geometry(size: size);

    canvas.translate(size.width / 2, geometry.radius);

    canvas.drawCircle(Offset.zero, 5.0, _scaleCenterPaint);

    canvas.drawArc(
        Rect.fromLTRB(-geometry.radius, -geometry.radius, geometry.radius,
            geometry.radius),
        pi * 3 / 2 - geometry.arcAngle,
        geometry.arcAngle * 2,
        false,
        _scalePaint);

    final startHeading =
        (projection.reverseHeading(-geometry.arcAngle) / 5).ceil() * 5;
    final endHeading =
        (projection.reverseHeading(geometry.arcAngle) / 5).floor() * 5;

    var tickMarkValue = startHeading;
    canvas.rotate(projection.projectHeading(tickMarkValue, geometry).angle);

    while (tickMarkValue != (endHeading + 5)) {
      canvas.drawLine(
          Offset(0.0, -geometry.radius),
          Offset(0.0, -geometry.radius + (tickMarkValue % 10 == 0 ? 20 : 10)),
          _scalePaint);

      if (tickMarkValue % 30 == 0) {
        _textPainter
          ..text = TextSpan(text: '$tickMarkValue')
          ..layout()
          ..paint(
              canvas,
              Offset(-_textPainter.width / 2,
                  -geometry.radius + 32.0 - _textPainter.height / 2));
      }

      tickMarkValue += 5;
      if (tickMarkValue > 360) tickMarkValue -= 360;
      canvas.rotate(5 * pi / 180);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}
