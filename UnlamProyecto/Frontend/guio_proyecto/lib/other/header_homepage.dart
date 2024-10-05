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

Widget header(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      /*const Image(
        image: AssetImage("assets/images/logo_GUIO_3.png"),
        width: 40,
      ),*/
      PopupMenuButton<String>(
        icon: const Icon(
          Icons.menu_rounded,
          color: Colors.white,
          size: 30,
        ),
        color: Colors.white,
        offset: const Offset(-10, 60),
        onSelected: (String value) {
          if (value == '1') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyDataPage()),);
          } else if (value == '2') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePassword()),);
          } else if (value == '3') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LocationSelection()),
                  (Route<dynamic> route) => false,
            );
          } else if (value == '4') {
            _logout(context);
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
          const PopupMenuItem<String>(
              value: '4',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.black,),
                  SizedBox(width: 20,),
                  Text('Cerrar Sesión'),
                ],
              )
          ),
        ],
      ),
      /*const Image(
        image: AssetImage("assets/images/logo_GUIO_3.png"),
        width: 75,
      ),*/
            /*IconButton(
        icon: const Icon(Icons.logout, color: Colors.white, size: 20,),
        onPressed: () {
          _logout(context);
        },
      ),*/
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
        return Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
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
                      //fontWeight: FontWeight.bold,
                      //height: 1.1,
                    ),
                  ),
                  SizedBox(width: 65,),
                  Align(
                    alignment: Alignment.topCenter, // Alinea el ícono en la parte superior
                    child: PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.menu_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      color: Colors.white,
                      offset: const Offset(-10, 60),
                      onSelected: (String value) {
                        if (value == '1') {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyDataPage()),);
                        } else if (value == '2') {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePassword()),);
                        } else if (value == '3') {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LocationSelection()),
                                (Route<dynamic> route) => false,
                          );
                        } else if (value == '4') {
                          _logout(context);
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
                        const PopupMenuItem<String>(
                            value: '4',
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: Colors.black,),
                                SizedBox(width: 20,),
                                Text('Cerrar Sesión'),
                              ],
                            )
                        ),
                      ],
                    ), // Tamaño del ícono
                    ),

                ],
             ),

              Row(
                children: [
                  Expanded(child:
                    Text(
                      snapshot.data ?? '',
                      //"HOSPITAL ITALIANO",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  //SizedBox(width: 10,),
                  /*IconButton(
                    icon: const Icon(Icons.change_circle_outlined, color: Colors.white, size: 45,),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LocationSelection()),);
                    },
                  ),*/
                ],
              ),
              /*const Text(
              'Seleccione origen y destino para comenzar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),*/
            ],
          ),
        );
      }
    },
  );
}


Future<void> _logout(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await deleteUserSession();
  await prefs.remove('isLoggedIn');

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const StartPage()),
        (Route<dynamic> route) => false,
  );

}
