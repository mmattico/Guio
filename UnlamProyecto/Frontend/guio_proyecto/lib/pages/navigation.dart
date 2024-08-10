import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guio_proyecto/model/instruccion_node.dart';
import 'home_page.dart';
import '../other/emergency.dart';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pedometer/pedometer.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;

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
  int _instruccionActual = 0;
  bool _isLoading = false;
  bool _girando = true;
  int distanciaARecorrer = 0;
  int distanciaRecorrida = 0;
  String _imagenPath = "";
  double _angle = 0;
  int _norteGrado = 0;
  FlutterTts tts = FlutterTts();
  bool isTtsInitialized = false;

  // Podometro
  String _pasosValue = '0';
  int _pasosIniciales = 0;
  bool _primeraLectura = true; // Chequeo primera lectura de paso sino da el total del podometro
  final double stepLength = 0.762; // Valor de paso promedio
  Stream<StepCount>? _stepCountStream;
  StreamSubscription<StepCount>? _stepCountSubscription;

  // Magnetometro
  StreamSubscription<CompassEvent>? _compassSubscription;
  double direccionMagnetometro = 0;

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

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    requestPermisos();
    startListening();
    obtenerInstruccionesCamino();
  }

  Future<void> requestPermisos() async {
    var status = await Permission.activityRecognition.status;
    if (status.isDenied) {
      if (await Permission.activityRecognition.request().isGranted) {
        initPodometro();
      }
    } else {
      initPodometro();
    }
  }

  // Inicio podometro
  void initPodometro() {
    if (_stepCountSubscription != null) {
      _stepCountSubscription!.cancel();
    }
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountSubscription = _stepCountStream!.listen(onStepCount, onError: onStepCountError, cancelOnError: false);
  }
  void resetStepCount() {
    setState(() {
      _primeraLectura=true;
      _pasosIniciales = int.tryParse(_pasosValue) ?? 0;
      _pasosValue = '0';
    });
  }
  @override
  void dispose() {
    _stepCountSubscription?.cancel();
    super.dispose();
  }
  // Fin podometro

  // Inicio magnetometro
  void startListening() {
    _compassSubscription = FlutterCompass.events!.listen((CompassEvent event) {
      setState(() {
        direccionMagnetometro = event.heading ?? 0;
      });
    });
  }

  // Detiene la suscripción al magnetómetro
  void stopListening() {
    _compassSubscription?.cancel();
  }
  // Fin magnetometro

  Future<void> obtenerInstruccionesCamino() async {
    //var url = Uri.http('localhost:8080', '/api/dijktra/mascorto', {'ORIGEN': widget.selectedOrigin, 'DESTINO': widget.selectedArea});
    //var url = Uri.http('192.168.0.11:8080', '/api/dijktra/mascorto', {'ORIGEN': '1', 'DESTINO': '11'});
    //var url = Uri.http('10.0.2.2:8080', '/api/dijktra/mascorto', {'ORIGEN': '1', 'DESTINO': '11'});
    var url;
    if(widget.selectedService!.isEmpty){
      url = Uri.http('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/dijktra/mascorto',
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
      late StreamSubscription? subscription;

      instrucciones = responseData.instrucciones.toList();
      _norteGrado = responseData.norteGrado;
      print("Norte grado: $_norteGrado");

      subscription = Stream.periodic(Duration(seconds: 1)).listen((_) {
        setState(() {
          if (_instruccionActual > 0) {
            if (direccionMagnetometro - _angle > 15 ||
                direccionMagnetometro - _angle < -15) {
              _girando = true;
              _instruccion = "Gira hasta que dejes de sentir vibraciones";
              Vibration.vibrate();
            } else {
              _girando = false;
              _instruccion = instrucciones[_instruccionActual].instruccionToString();
            }
          }
        });
      });

      _imagenPath = 'assets/images/narrow-top.png';
      for(int i=0; i<instrucciones.length; i++){
        print("________Ciclo: $i");
        resetStepCount();
        if(i > 0){
          if(instrucciones[i-1].distancia! > 0){
            distanciaARecorrer = instrucciones[i-1].distancia!;
            //distanciaRecorrida = 0;
            while (distanciaRecorrida < distanciaARecorrer) {
              print("______________________________________________________DISTANCIA RECORRIDA: $distanciaRecorrida");
              print("______________________________________________________DISTANCIA A RECORRER: $distanciaARecorrer");
              print("______________________________________________________DIRECCION MAGNETOMETRO: $direccionMagnetometro");
              await Future.delayed(Duration(milliseconds: 500));
            }
          }
        }
        setState(() {
          if(i > 0) {
            _instruccionActual = i;
            if (instrucciones[i].sentidoDestino != '') {
              _angle = _mapSentidoConSentidoDestinoAImagen(instrucciones[i].sentidoOrigen ?? '');
            }
          }
        });
      }
      subscription.cancel();
      stopListening();

      direccionMagnetometro = 0;
      _angle = 0;
      _norteGrado = 0;
      _imagenPath = 'assets/images/arrived_2.png';
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

  void onStepCount(StepCount event) {
    if(!_girando) {
      int pasosActuales = event.steps;

      if (_primeraLectura) { //seteo de primer lectura
        setState(() {
          _pasosIniciales = pasosActuales;
          _pasosValue = '0';
          _primeraLectura = false;
        });
      } else {
        // Calcula pasos despues de la primer lectura cuando no esta girando
        setState(() {
          int pasosReales = pasosActuales - _pasosIniciales;
          _pasosValue = pasosReales.toString();
          distanciaRecorrida = (pasosReales.toDouble() * stepLength)
              .toInt(); // Actualiza distancia recorrida
        });
      }
    }
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _pasosValue = 'Error: $error';
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_instruccion != "" && selectedVoiceAssistance) {
      detenerReproduccion();
      hablarTexto(_instruccion);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading && _instruccion == ""
          ? Center(child: CircularProgressIndicator())
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
                          activeColor: Color.fromRGBO(17, 116, 186, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                      width: 300.0,
                      height: 300.0,
                      child: Transform.rotate(
                        angle: (_norteGrado + _angle - direccionMagnetometro) * math.pi / 180, // Rotar 45 grados
                        child: Image.asset(_imagenPath,
                        height: 280,),
                      )
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
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

double _mapSentidoConSentidoDestinoAImagen(String sentidoDestino) {
  switch (sentidoDestino) {
    case 'E':
      return -90;
    case 'O':
      return 90;
    case 'S':
      return 0;
    default:
      return 180;
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