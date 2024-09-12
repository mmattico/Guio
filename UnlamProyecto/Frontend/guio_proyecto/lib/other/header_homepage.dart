import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/user_session.dart';
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyDataPage()),);
          } else if (value == '2') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePassword()),);
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
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Bienvenido',
        style: TextStyle(
          color: Colors.white,
          fontSize: 45,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'Seleccione origen y destino para comenzar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          //fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Future<void> _logout(context) async {
  // Se eliminan los datos de sesión del usuario
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await deleteUserSession();
  await prefs.remove('isLoggedIn');

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const StartPage()),
  );
}
