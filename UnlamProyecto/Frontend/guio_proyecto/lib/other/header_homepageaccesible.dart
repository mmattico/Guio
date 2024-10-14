import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/user_session.dart';

//*********** HEADER ACCESIBLE ***********

class BluePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromRGBO(137, 182, 235, 1)
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.80)
      ..quadraticBezierTo(size.width * 0.5, size.height, 0, size.height * 0.80)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HeaderTextoAccesible extends StatefulWidget {
  @override
  _HeaderTextoAccesibleState createState() => _HeaderTextoAccesibleState();
}

class _HeaderTextoAccesibleState extends State<HeaderTextoAccesible> {
  String? ubicacion;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUbicacion();
  }

  Future<void> _fetchUbicacion() async {
    try {
      String? result = await getGraphName();
      setState(() {
        ubicacion = result;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching location: $e");
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Bienvenido, \nusted se encuentra en ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: ubicacion ?? 'Error al cargar', // Mostramos 'Error al cargar' si no hay ubicación
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


}