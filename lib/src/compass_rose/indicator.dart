import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'sensor.dart';

class Indicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sensor = CompassRoseSensor.of(context);

    return StreamBuilder(
      stream: sensor.heading,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomPaint(
            painter: _IndicatorPainter(heading: snapshot.data),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

class _IndicatorPainter extends CustomPainter {
  _IndicatorPainter({@required this.heading})
      : assert(heading != null),
        assert(heading > 0 && heading <= 360);

  final double heading;

  final _indicatorPaint = new Paint()
    ..color = Colors.white
    ..strokeWidth = 1.5;

  final _textPainter = TextPainter(
      textDirection: TextDirection.ltr, textAlign: TextAlign.center);

  final _textStyle =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, 0.0);

    canvas.drawRRect(
        RRect.fromLTRBR(-20.0, 20.0, 20.0, 44.0, Radius.circular(5.0)),
        _indicatorPaint);

    canvas.drawLine(Offset(0.0, 0.0), Offset(0.0, 20.0), _indicatorPaint);

    _textPainter
      ..text = TextSpan(text: '${heading.toInt()}', style: _textStyle)
      ..layout(minWidth: 40.0, maxWidth: 40.0)
      ..paint(canvas, Offset(-20.0, 32.0 - _textPainter.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}
