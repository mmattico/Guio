import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guio_proyecto/model/instruccion_node.dart';
import 'home_page.dart';
import '../other/emergency.dart';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  String _imagenPath = "";
  FlutterTts tts = FlutterTts();
  bool isTtsInitialized = false;



  void toggleSwitch(bool value) {
    setState(() {
      selectedVoiceAssistance = !selectedVoiceAssistance;
    });
  }

  /*Future<void> hablarTexto(String texto) async {
    await tts.setLanguage('es-AR');
    await tts.setPitch(1.0);
    await tts.setSpeechRate(0.7);

    String text = texto;
    await tts.speak(texto);
  }*/

  Future<void> detenerReproduccion() async {
    await tts.stop();
  }

  Future<void> hablarTexto(String texto) async {
    if (isTtsInitialized) {
      try {
        await tts.setLanguage("es-AR"); // Configura el idioma español (Argentina)
        await tts.setPitch(1.0);
        //await tts.setVolume(1.0);
        //await tts.setSpeechRate(1.0); // Descomentado para controlar la velocidad de habla si es necesario
        var result = await tts.speak(texto);
        print("TTS Speak Result: $result");
      } catch (e) {
        print("Error: $e");
      }
    } else {
      print("TTS not initialized");
    }
  }

  Future<void> _showPopup(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('¡Ha llegado a su primer destino!', style: TextStyle(fontSize: 25,),textAlign: TextAlign.center,),
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 150,
                    height: 60,
                    child: ElevatedButton(
                      child: Text('Continuar', style: TextStyle(fontSize: 20, color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    obtenerInstruccionesCamino();
  }

  Future<void> obtenerInstruccionesCamino() async {
    //var url = Uri.http('localhost:8080', '/api/dijktra/mascorto', {'ORIGEN': widget.selectedOrigin, 'DESTINO': widget.selectedArea});
    //var url = Uri.http('localhost:8080', '/api/dijktra/mascorto', {'ORIGEN': '1', 'DESTINO': '11'});
    //var url = Uri.http('10.0.2.2:8080', '/api/dijktra/mascorto', {'ORIGEN': '1', 'DESTINO': '11'});
    var url;
    if(widget.selectedService!.isEmpty){
      url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/dijktra/mascorto',
          {'ORIGEN': widget.selectedOrigin,
            'DESTINO': widget.selectedArea,
            'PREFERENCIA': widget.selectedPreference,
            'UBICACION':'PRUEBA'});
    }else if(widget.selectedArea!.isEmpty) {
      url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/dijktra/portipo',
          { 'ORIGEN': widget.selectedOrigin,
            'SERVICIO': widget.selectedService,
            'PREFERENCIA': widget.selectedPreference,
            'UBICACION':'PRUEBA'});
    } else {
      url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/dijktra/mascortoconnodointermedio',
          {'ORIGEN': widget.selectedOrigin,
            'DESTINO': widget.selectedArea,
            'SERVICIO': widget.selectedService,
            'PREFERENCIA': widget.selectedPreference,
            'UBICACION':'PRUEBA'});
    }

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
        await Future.delayed(const Duration(seconds: 6));
        setState(() {
          _instruccion = instrucciones[i].instruccionToString();
          if(i == 0){
            Vibration.vibrate();
          }

          if(instrucciones[i].haygiro ?? false){
            _imagenPath = _mapSentidoAImagen(instrucciones[i].sentido ?? '');
            Vibration.vibrate();
          } else {
            _imagenPath = 'assets/images/narrow-top.png';
          }

        });

        if(instrucciones[i].commando == 'Fin parte 1 del recorrido'){
          await _showPopup(context);
        }
      }
      _imagenPath = 'assets/images/arrived_2.png';

      Image.asset(
        _imagenPath,
        width: 50,
        height: 50,
      );

      _instruccion = 'Ha llegado a Destino';
      Vibration.vibrate(pattern: [50, 500, 50, 500, 50, 500, 50, 1000]);
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
      backgroundColor: Colors.white,
      body: _isLoading && _instruccion == ""
          ? const Center(child: CircularProgressIndicator())
          : Stack(
            children: [
              CustomPaint(
              painter: BluePainter(),
              child: Container(
                height: 335,
              ),
            ),
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 16, 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
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
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 15),
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
                          activeColor: const Color.fromRGBO(17, 116, 186, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                      width: 300.0,
                      height: 300.0,
                    child: Image.asset(_imagenPath,
                      height: 280,),
                  )
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Instruccion:',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 300,
                        height: 100,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _instruccion,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            )
                        )
                      )

                    ],
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
                          detenerReproduccion();
                          Vibration.cancel();
                          setState(() {
                            selectedVoiceAssistance = !selectedVoiceAssistance;
                          });
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
              ],
            ),
          ),
        ),
      ),
  ],),
    );
  }
}

String _mapSentidoAImagen(String sentido) {
  switch (sentido) {
    case 'Izquierda':
      return 'assets/images/narrow-left.png';
    case 'Derecha':
      return 'assets/images/narrow-right.png';
    case 'Regresar':
      return 'assets/images/narrow-down.png';
    default:
      return 'assets/images/narrow-top.png';
  }
}

FlutterTts tts = FlutterTts();

void detenerReproduccion() async {
  await tts.stop();
}

void hablarTexto(String texto) async {
  await tts.setLanguage("es-AR"); // Configura el idioma español (Argentina)
  await tts.setPitch(1.0);
  await tts.setVolume(1.0);
  //await tts.setSpeechRate(1.0); // Descomentado para controlar la velocidad de habla si es necesario
  await tts.speak(texto);
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image:
            AssetImage("assets/images/logo_GUIO.png"),
            width: 100,
          ),
        ],
      ),
      SizedBox(height: 20),
      Text(
        "Dirigiendose a ",
        style: TextStyle(color: Colors.white,
          fontSize: 28,
        ),
      ),
    ],
  );
}