import 'package:flutter/material.dart';
import 'home_page.dart';
import 'emergency.dart';

class Navigation extends StatefulWidget {
  final String? selectedService;
  final String? selectedArea;
  final String? selectedOrigin;
  final String? selectedPreference;

  const Navigation(
      {Key? key,
      required this.selectedOrigin,
      required this.selectedArea,
      required this.selectedService,
      required this.selectedPreference})
      : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool selectedVoiceAssistance = false;

  void toggleSwitch(bool value) {
    setState(() {
      selectedVoiceAssistance = !selectedVoiceAssistance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            'https://cdn.logo.com/hotlink-ok/logo-social.png', //Reemplazar por logo de GUIO
            //Reemplazar con Icon de GUIO
            height: 50,
          ),
        ),
        centerTitle: true,
        //backgroundColor: Colors.grey[200],
        elevation: 50.0,
        leading: IconButton(
          icon: const Icon(Icons.person),
          tooltip: 'Profile',
          onPressed: () {},
        ),
      ),
      body:*/
      backgroundColor: Colors.white,
      body: Stack(
            children: [
              CustomPaint(
              painter: BluePainter(),
              child: Container(
                height: 340,
              ),
            ),
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 13, 16, 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(),
                const SizedBox(height: 9),
                Text(
                  (widget.selectedArea != '' && widget.selectedService != '')
                      ? '${widget.selectedArea} y ${widget.selectedService}'
                      : (widget.selectedService != '')
                          ? '${widget.selectedService}'
                          : (widget.selectedArea != '')
                              ? '${widget.selectedArea}'
                              : 'None',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 11),
                /*SwitchListTile(
                  title: const Text('Asistencia por voz'),
                  value: selectedVoiceAssistance,
                  onChanged: (bool value) {
                    setState(() {
                      selectedVoiceAssistance = value;
                    });
                    print('$selectedVoiceAssistance');
                  },
                  secondary: const Icon(Icons.volume_up),
                ),*/
                Card(
                  color: Colors.white,
                  margin: const EdgeInsets.fromLTRB(15, 10, 15, 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Asistencia por voz'),
                          value: selectedVoiceAssistance,
                          onChanged: (bool value) {
                            setState(() {
                              selectedVoiceAssistance = value;
                            });
                            print('$selectedVoiceAssistance');
                          },
                          secondary: const Icon(Icons.volume_up),
                          activeColor: Color.fromRGBO(17, 116, 186, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Image.network(
                    'https://cdn-icons-png.freepik.com/512/7884/7884621.png',
                    height: 280,
                  ),
                ),
                const Center(
                  child: Text(
                    "Gire a la Derecha",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text(
                          "Finalizar Recorrido",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),),
                    const SizedBox(width: 10,),
                    emergencyButton(context),
                  ],
                ),
                /*Center(
                  child: SizedBox(
                    width: 250,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text(
                        "Finalizar Recorrido",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
  ],),
    );
  }
}

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

Widget header() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('         '),
          Image(
            image:
            AssetImage("assets/images/logo_GUIO.png"),
            width: 100,
          ),
          Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 40,
          ),
        ],
      ),
      SizedBox(height: 20),
      Text(
        "Dirigiendose a ",
        style: TextStyle(color: Colors.white,
          fontSize: 25,
        ),
      ),
    ],
  );
}