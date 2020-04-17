import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:z_music/Model/PublicV.dart';

class MusicPlayButtonPainter extends CustomPainter {
  int nowSecond = 0;
  int allSeconds = 1;
  int isplaying = 0;

  MusicPlayButtonPainter({this.nowSecond, this.allSeconds, this.isplaying});

  @override
  void paint(Canvas canvas, Size size) {
    print("now:" + nowSecond.toString() + "   " + allSeconds.toString());

    var paint = Paint();
    paint.color = Colors.green;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    canvas.drawCircle(
        Offset(size.width / 2, size.width / 2), size.width / 3.2, paint);

    paint.color = Colors.green;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;
    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 3.5);
    canvas.drawArc(
        rect,
        -PublicV.pi / 2,
        double.parse(((PublicV.pi * 2) * nowSecond / allSeconds).toString()),
        false,
        paint);
    // canvas.drawCircle(Offset(size.width/2,size.width/2), size.width/3.5, paint);

    if (isplaying == 1) {
      paint.style = PaintingStyle.fill;
      paint.strokeWidth = 3;
      canvas.drawLine(Offset(size.width * 0.43, size.width*0.37),
          Offset(size.width * 0.43, size.width*0.63), paint);
      canvas.drawLine(Offset(size.width * 0.57, size.width*0.37),
          Offset(size.width * 0.57, size.width*0.63), paint);
    } else {
      //绘制中间的播放三角形
      var path = Path();
      path.moveTo(size.width * 0.42, size.height * 0.35);
      path.lineTo(size.width * 0.67, size.height * 0.5);
      path.lineTo(size.width * 0.42, size.height * 0.65);
      path.close();
      paint.style = PaintingStyle.fill;
      canvas.drawPath(path, paint);

      paint.color = Colors.white;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 3;
      canvas.drawCircle(
          Offset(size.width / 2, size.width / 2), size.width / 6, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
