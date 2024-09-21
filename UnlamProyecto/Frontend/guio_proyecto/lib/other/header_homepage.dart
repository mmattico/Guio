import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/user_session.dart';
import 'package:guio_proyecto/pages/location_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guio_proyecto/pages/start_page.dart';

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

Widget header(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      PopupMenuButton<String>(
        icon: const Icon(
          Icons.account_circle,
          color: Colors.white,
          size: 35,
        ),
        color: Colors.white,
        offset: const Offset(-10, 60),
        onSelected: (String value) {
          if (value == '1') {
            // Ir a la página de "Mi cuenta"
          } else if (value == '2') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePassword()),);
          } else if (value == '3') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LocationSelection()),);
          }
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<String>(
              value: '1',
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.black,),
                  SizedBox(width: 20,),
                  Text('Mi cuenta'),
                ],
              )
          ),
          const PopupMenuItem<String>(
              value: '2',
              child: Row(
                children: [
                  Icon(Icons.password, color: Colors.black,),
                  SizedBox(width: 20,),
                  Text('Cambiar Contraseña'),
                ],
              )
          ),
          const PopupMenuItem<String>(
              value: '3',
              child: Row(
                children: [
                  Icon(Icons.change_circle_outlined, color: Colors.black,),
                  SizedBox(width: 20,),
                  Text('Cambiar de Ubicación'),
                ],
              )
          ),
        ],
      ),
      const Image(
        image: AssetImage("assets/images/logo_GUIO.png"),
        width: 100,
      ),
      IconButton(
        icon: const Icon(Icons.logout, color: Colors.white, size: 30,),
        onPressed: () {
          _logout(context);
        },
      )
    ],
  );
}

Widget headerTexto() {
  Future<String?> ubicacion = getGraphName();

  return FutureBuilder<String?>(
    future: ubicacion,
    builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return const Text(
          'Error al cargar la ubicación',
          style: TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido',
              style: TextStyle(
                color: Colors.white,
                fontSize: 45,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            Text(
              snapshot.data ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Seleccione origen y destino para comenzar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        );
      }
    },
  );
}


Future<void> _logout(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await deleteUserSession();
  await prefs.remove('isLoggedIn');

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const StartPage()),
  );
}
