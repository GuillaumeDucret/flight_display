import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'sensor.dart';
import 'projection.dart';
import 'envelope.dart';

class Indicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final projection = Projection.of(context);
    final envelope = Envelope.of(context);
    final sensor = Sensor.of(context);

    return StreamBuilder(
      stream: sensor.airSpeed,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomPaint(
            painter: _IndicatorPainter(
                speed: snapshot.data,
                projection: projection,
                envelope: envelope),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

class _IndicatorPainter extends CustomPainter {
  _IndicatorPainter(
      {@required this.speed,
      @required this.projection,
      @required this.envelope})
      : assert(speed != null),
        assert(speed >= 0),
        assert(projection != null),
        assert(envelope != null);

  final double speed;
  final Projection projection;
  final EnvelopeData envelope;

  final _indicatorPaint = new Paint()..strokeWidth = 1.5;

  final _textPainter = TextPainter(
      textDirection: TextDirection.ltr, textAlign: TextAlign.center);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(
        size.width / 2, projection.project(speed, size.height, 12.0));

    TextStyle textStyle;
    final speedRange = envelope.speedRange(speed);
    if (speedRange != null && speedRange.color != null) {
      _indicatorPaint.color = speedRange.color;
      textStyle = TextStyle(fontWeight: FontWeight.bold);
    } else if (speedRange != null) {
      _indicatorPaint.color = Colors.white;
      textStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.black);
    } else {
      _indicatorPaint.color = EnvelopeData.outOfSpeedRangeColor;
      textStyle = TextStyle(fontWeight: FontWeight.bold);
    }

    canvas.drawRRect(
        RRect.fromLTRBR(-57.0, -12.0, -20.0, 12.0, Radius.circular(5.0)),
        _indicatorPaint);

    canvas.drawLine(Offset(-25.0, 0.0), Offset(0.0, 0.0), _indicatorPaint);

    _textPainter
      ..text = TextSpan(text: '${speed.toInt()}', style: textStyle)
      ..layout(minWidth: 37.0, maxWidth: 37.0)
      ..paint(canvas, Offset(-57, -_textPainter.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}
