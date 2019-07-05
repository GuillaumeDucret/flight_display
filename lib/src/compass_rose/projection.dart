import 'dart:math';
import 'package:flutter/material.dart';
import 'sensor.dart';

class Projection extends StatelessWidget {
  Projection({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sensor = CompassRoseSensor.of(context);

    return StreamBuilder(
      stream: sensor.heading,
      builder: (context, snapshot) {
        return ProjectionData(origin: snapshot.data, child: child);
      },
    );
  }

  static ProjectionData of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ProjectionData);
  }
}

class ProjectionData extends InheritedWidget {
  ProjectionData({key, this.origin, child}) : super(key: key, child: child);

  final double origin;

  Radial projectHeading(num heading, Geometry geometry) {
    var angle = (heading - origin) * pi / 180;
    angle = angle % (pi * 2);

    if (angle.abs() > pi) {
      angle = angle.sign * (angle.abs() - (pi * 2));
    }

    return geometry.radial(angle);
  }

  double reverseHeading(double angle) {
    var heading = (angle * 180 / pi) + origin;
    heading = heading % 360;

    if (heading <= 0) {
      heading += 360;
    }
    return heading;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => this != oldWidget;
}

class Geometry {
  Geometry._({this.size, this.radius, this.arcAngle, this.breakAngle});

  factory Geometry({size}) {
    final radius = size.height / 3 * 2;
    final arcAngle = _arcAngle(size, radius);
    final breakAngle = _breakAngle(size, radius);

    return Geometry._(
      size: size,
      radius: radius,
      arcAngle: arcAngle,
      breakAngle: breakAngle,
    );
  }

  final Size size;
  final double radius;
  final double arcAngle;
  final double breakAngle;

  Radial radial(angle) {
    var length;
    if (angle.abs() < arcAngle) {
      length = radius;
    } else if (angle.abs() < breakAngle) {
      length = (size.width / 2 / sin(angle)).abs();
    } else {
      length = (size.height - radius) / sin(angle - (pi / 2)).abs();
    }

    return Radial(angle: angle, length: length);
  }

  static double _arcAngle(Size size, double radius) {
    var angle = asin((size.width / 2) / radius);
    if (!angle.isNaN) return angle;

    angle = asin((size.height - radius) / radius) + (pi / 2);
    if (!angle.isNaN) return angle;

    angle = pi;
    return angle;
  }

  static double _breakAngle(Size size, double radius) {
    return atan((size.height - radius) / (size.width / 2)) + (pi / 2);
  }
}

class Radial {
  Radial({this.angle, this.length});

  final double angle;
  final double length;
}
