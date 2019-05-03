import 'package:flutter/material.dart';

// TODO 需要了解 CustomPainter
class WavePainter extends CustomPainter {
  final double sliderPosition;
  final double dragPercentage;
  final Color color;

  final Paint fillPainter;
  final Paint wavePainter;

  WavePainter({
    @required this.sliderPosition,
    @required this.dragPercentage,
    @required this.color,
  })
      : fillPainter = Paint()
    ..color = color
    ..style = PaintingStyle.fill,
        wavePainter = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    _paintAnchors(canvas, size);
//    _paintLine(canvas, size);
//    _paintBlock(canvas,size);
    _paintWaveLine(canvas, size);
  }

  _paintAnchors(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, size.height), 5.0, fillPainter);
    canvas.drawCircle(Offset(size.width, size.height), 5.0, fillPainter);
  }

  WaveCurveDefinitions _calculateWaveLineDefinitions() {
    double bendWidth = 40.0;
    double bezierWidth = 40.0;

    double startOfBend = sliderPosition - bendWidth / 2;
    double endOfBend = sliderPosition + bendWidth / 2;
    double startOfBezier = startOfBend - bezierWidth;
    double endOfBezier = endOfBend + bezierWidth;

    double controlHeight = 0.0;
    double centerPoint = sliderPosition;

    double leftControlPoint1 = startOfBend;
    double leftControlPoint2 = startOfBend;
    double rightControlPoint1 = endOfBend;
    double rightControlPoint2 = endOfBend;

    WaveCurveDefinitions waveCurve = WaveCurveDefinitions(
      centerPoint: centerPoint,
      controlHeight: controlHeight,
      startOfBezier: startOfBezier,
      startOfBend: startOfBend,
      endOfBezier: endOfBezier,
      endOfBend: endOfBend,
      leftControlPoint1: leftControlPoint1,
      leftControlPoint2: leftControlPoint2,
      rightControlPoint1: rightControlPoint1,
      rightControlPoint2: rightControlPoint2,
    );
    return waveCurve;
  }

  _paintWaveLine(Canvas canvas, Size size) {
    WaveCurveDefinitions waveCurve = _calculateWaveLineDefinitions();

    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(waveCurve.startOfBezier, size.height);
    path.cubicTo(
        waveCurve.leftControlPoint1, size.height, waveCurve.leftControlPoint2,
        waveCurve.controlHeight, waveCurve.centerPoint,
        waveCurve.controlHeight);

    path.cubicTo(waveCurve.rightControlPoint1, waveCurve.controlHeight,
        waveCurve.rightControlPoint2,
        size.height, waveCurve.endOfBezier, size.height);

    path.lineTo(size.width, size.height);
    canvas.drawPath(path, wavePainter);

    // http://www.roblaplaca.com/examples/bezierBuilder/
    // https://www.jianshu.com/p/99084dd0abf2
  }

  _paintLine(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    canvas.drawPath(path, wavePainter);
  }

  _paintBlock(Canvas canvas, Size size) {
    Rect sliderRect =
    Offset(sliderPosition, size.height - 5.0) & Size(3.0, 10.0);
    canvas.drawRect(sliderRect, fillPainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class WaveCurveDefinitions {
  final double startOfBezier;
  final double endOfBezier;
  final double startOfBend;
  final double endOfBend;
  final double controlHeight;
  final double centerPoint;

  final double leftControlPoint1;
  final double leftControlPoint2;
  final double rightControlPoint1;
  final double rightControlPoint2;

  WaveCurveDefinitions({
    this.startOfBezier,
    this.endOfBezier,
    this.startOfBend,
    this.endOfBend,
    this.leftControlPoint1,
    this.leftControlPoint2,
    this.rightControlPoint1,
    this.rightControlPoint2,
    this.controlHeight,
    this.centerPoint,
  });
}
