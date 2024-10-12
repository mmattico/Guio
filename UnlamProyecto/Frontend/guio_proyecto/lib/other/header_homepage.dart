import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/user_session.dart';
import 'package:guio_proyecto/pages/location_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guio_proyecto/pages/start_page.dart';
import '../pages/my_data.dart';
import '../pages/change_password.dart';

//*********** HEADER ***********

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

class HeaderTexto extends StatefulWidget {
  @override
  _HeaderTextoState createState() => _HeaderTextoState();
}

class _HeaderTextoState extends State<HeaderTexto> {
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
        isLoading =
            false;
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
                const Text(
                  'Bienvenido, \nusted se encuentra en',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.topCenter,
                  child: PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.menu_rounded,
                      color: Colors.white,
                      size: 35,
                    ),
                    color: Colors.white,
                    offset: const Offset(-10, 60),
                    onSelected: (String value) {
                      switch (value) {
                        case '1':
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyDataPage()),
                            (Route<dynamic> route) => false,
                          );
                          break;

                        case '2':
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChangePassword()),
                            (Route<dynamic> route) => false,
                          );
                          break;

                        case '3':
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocationSelection()),
                            (Route<dynamic> route) => false,
                          );
                          break;

                        case '4':
                          _logout(context);
                          break;

                        default:
                          print('Valor no válido: $value');
                      }
                      ;
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: '1',
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.black),
                            SizedBox(width: 20),
                            Text('Mi cuenta'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: '2',
                        child: Row(
                          children: [
                            Icon(Icons.password, color: Colors.black),
                            SizedBox(width: 20),
                            Text('Cambiar Contraseña'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: '3',
                        child: Row(
                          children: [
                            Icon(Icons.change_circle_outlined,
                                color: Colors.black),
                            SizedBox(width: 20),
                            Text('Cambiar de Ubicación'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: '4',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.black),
                            SizedBox(width: 20),
                            Text('Cerrar Sesión'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: AnimatedOpacity(
                    opacity: isLoading ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: AutoSizeText(
                      isLoading
                          ? 'Cargando ubicación...'
                          : (ubicacion ?? 'Error al cargar'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                      maxLines: 2,
                      minFontSize: 20,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
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

Future<void> _logout(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await deleteUserSession();
  await prefs.remove('isLoggedIn');

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.logout,
                color: Colors.grey,
                size: 80,
              ),
              SizedBox(height: 10),
              Text(
                '¿Cerrar sesión?',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: <Widget>[
            SizedBox(
              width: 95,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const StartPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  backgroundColor: Color.fromRGBO(17, 116, 186, 1),
                ),
                child: const Text(
                  "SI",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            TextButton(
              child: const Text(
                'NO',
                style: TextStyle(
                    color: Color.fromRGBO(17, 116, 186, 1), fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
