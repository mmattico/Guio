import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guio_proyecto/model/instruccion_node.dart';
import 'home_page.dart';
import '../other/emergency.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';

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

/*
class _NavigationState extends State<Navigation> {
  String _stepCountValue = 'Unknown';
  Pedometer _pedometer;

  @override
  void initState() {
    super.initState();
    _initPedometer();
  }

  void _initPedometer() {
    _pedometer = Pedometer();
    _pedometer.pedometerStream.listen(_onData, onError: _onError);
  }

  void _onData(int stepCountValue) {
    setState(() {
      _stepCountValue = "$stepCountValue";
    });
  }

  void _onError(error) {
    print("Error: $error");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedometer Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Step Count:',
            ),
            Text(
              '$_stepCountValue',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}*/


class _NavigationState extends State<Navigation> {
  bool selectedVoiceAssistance = true;
  List<Instrucciones> instrucciones = [];
  String _instruccion = "";
  bool _isLoading = false;
  int distanciaARecorrer = 0;
  int distanciaRecorrida = 0;

  void toggleSwitch(bool value) {
    setState(() {
      selectedVoiceAssistance = !selectedVoiceAssistance;
    });
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    obtenerInstruccionesCamino();
  }

  Future<void> obtenerInstruccionesCamino() async {
    //var url = Uri.http('localhost:8080', '/api/dijktra/mascorto', {'ORIGEN': widget.selectedOrigin, 'DESTINO': widget.selectedArea});
    var url = Uri.http('localhost:8080', '/api/dijktra/mascorto', {'ORIGEN': '1', 'DESTINO': '11'});
    //var url = Uri.http('localhost:8080/api/dijktra/mascorto?ORIGEN=1&DESTINO=11');
    print(url);
    print(widget.selectedOrigin);
    print(widget.selectedArea);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      _isLoading = false;
      print(json.decode(response.body));
      var responseData = Autogenerated.fromJson(json.decode(response.body) as Map<String, dynamic>);
      instrucciones = responseData.instrucciones.toList();
      for(int i=0; i<instrucciones.length; i++){
        /*
        if(i > 1){
          if(instrucciones[i-1].distancia! > 0){
            final stepCountStream = Pedometer.stepCountStream;
            distanciaARecorrer = instrucciones[i-1].distancia!;
            distanciaRecorrida = 0;
            while(distanciaARecorrer > 0) {
              stepCountStream.listen(_onStepCount).onError(_onStepCountError);
            }
          }
        }*/
        await Future.delayed(Duration(seconds: 6));
        setState(() {
          _instruccion = instrucciones[i].instruccionToString();
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        print('Failed to get response');
        throw Exception('Failed to load album');
      });
    }
  }
/*
  void _onStepCount(StepCount event) {
    distanciaRecorrida = distanciaRecorrida + event.steps;
    distanciaARecorrer = distanciaARecorrer - event.steps;
  }

  void _onStepCountError(error) {
    print('Step Count not available');
  }*/
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Refrescar Pantalla'),
      ),
      body: _isLoading && _instruccion == ""
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Contador:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              _instruccion,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}*/
  @override
  Widget build(BuildContext context) {
    if(_instruccion != "" && selectedVoiceAssistance) {
      detenerReproduccion();
      hablarTexto(_instruccion);
    }
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
      body: _isLoading && _instruccion == ""
          ? Center(child: CircularProgressIndicator())
          : Stack(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Instruccion:',
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        _instruccion,
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                /*
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

                */


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
TextToSpeech tts = TextToSpeech();

void detenerReproduccion() {
  tts.stop();
}

void hablarTexto(String texto) {
  tts.setLanguage("es-AR"); // Configura el idioma español (España)
  tts.setPitch(1.0);
  tts.setVolume(1.0);
  tts.setRate(1.0);
  tts.speak(texto);
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