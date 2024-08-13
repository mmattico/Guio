import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guio_proyecto/model/instruccion_node.dart';
import '../other/header_homepage.dart';
import '../other/text_to_voice.dart';
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
      {super.key,
      required this.selectedOrigin,
      required this.selectedArea,
      required this.selectedService,
      required this.selectedPreference});

  @override
  _NavigationState createState() => _NavigationState();
}

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

  bool _cancelarRecorrido = false;
  bool _botonCancelarRecorrido = false;
  double _customPaintHeight = 380;
  String finalizarRecorrido = 'Desea finalizar el recorrido';

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

  Future<void> _popupPrimerDestino(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('¡Ha llegado a su primer destino!', style: TextStyle(fontSize: 25,),textAlign: TextAlign.center,),
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 150,
                    height: 60,
                    child: ElevatedButton(
                      child: const Text('Continuar', style: TextStyle(fontSize: 20, color: Colors.white),),
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

  Future<void> _cancelarNavegacion(BuildContext context) async {
    // Lee en voz alta el título del AlertDialog
    const String titulo = "¿Desea finalizar el recorrido?";

    // Verifica si la asistencia por voz está habilitada
    if (selectedVoiceAssistance) {
      await speak(titulo);
    }

    // Espera hasta que el TTS termine de hablar antes de mostrar el AlertDialog
    final respuesta = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            titulo,
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            SizedBox(
              width: 95,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
                ),
                child: const Text(
                  'Sí',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _botonCancelarRecorrido = !_botonCancelarRecorrido;
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'No',
                style: TextStyle(color: Color.fromRGBO(17, 116, 186, 1), fontSize: 18),
              ),
            ),
          ],
        );
      },
    );

    if (respuesta == true) {
      setState(() {
        _cancelarRecorrido = true;
        if (selectedVoiceAssistance) {
          selectedVoiceAssistance = !selectedVoiceAssistance;
        }
        _botonCancelarRecorrido = ! _botonCancelarRecorrido;
      });
      detenerReproduccion();
      Vibration.cancel();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  Future<void> detenerReproduccion() async {
    await tts.stop();
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
      late StreamSubscription? subscriptionInstruccion;
      late StreamSubscription? subscriptionTts;

      instrucciones = responseData.instrucciones.toList();
      _norteGrado = responseData.norteGrado;

      subscriptionInstruccion = Stream.periodic(Duration(seconds: 1)).listen((_) {
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

      subscriptionTts = Stream.periodic(Duration(seconds: 6)).listen((_) {
        setState(() {
          speak(_instruccion);
        });
      });

      _imagenPath = 'assets/images/narrow-top.png';
      for(int i=0; i<instrucciones.length; i++){
        print("________Ciclo: $i");
        resetStepCount();
        if(i > 0){
          if(instrucciones[i-1].distancia! > 0){
            setState(() {
              distanciaRecorrida = 0;
              distanciaARecorrer = instrucciones[i - 1].distancia!;
            });
            while (distanciaRecorrida < distanciaARecorrer) {
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
        print("Instruccion actual: ${instrucciones[_instruccionActual].instruccionToString()}");

        while (_botonCancelarRecorrido) {
          await Future.delayed(const Duration(milliseconds: 100));
          detenerReproduccion();
        }

        if (_cancelarRecorrido) {
          break;
        }

        if(instrucciones[i].commando == 'Fin parte 1 del recorrido'){
          Vibration.vibrate(pattern: [50, 500, 50, 1000]);
          await _popupPrimerDestino(context);
        }
      }
      subscriptionInstruccion.cancel();
      subscriptionTts.cancel();
      stopListening();

      direccionMagnetometro = 0;
      _angle = 0;
      _norteGrado = 0;

      if(!_cancelarRecorrido){
        _imagenPath = 'assets/images/arrived_2.png';

        Image.asset(
          _imagenPath,
          width: 50,
          height: 50,
        );

        _instruccion = 'Ha llegado a Destino';
        Vibration.vibrate(pattern: [50, 500, 50, 500, 50, 500, 50, 1000]);
      }
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
          distanciaRecorrida = 0;
        });
      } else {
        // Calcula pasos despues de la primer lectura cuando no esta girando
        setState(() {
          if(distanciaRecorrida < distanciaARecorrer) {
            int pasosReales = pasosActuales - _pasosIniciales;
            _pasosValue = pasosReales.toString();
            distanciaRecorrida = (pasosReales.toDouble() * stepLength).toInt(); // Actualiza distancia recorrida
          } else {
            distanciaRecorrida = distanciaARecorrer;
          }
        });
      }
      print("DistanciaRecorrida $distanciaRecorrida  ---  DistanciaARecorrer: $distanciaARecorrer");
    } else {
      print("El paso no fue contabilizado, apunta hacia la flecha");
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
      if(_instruccion == "Fin parte 1 del recorrido"){
        _instruccion = "Ha llegado a su primer destino. Presione el boton continuar para avanzar hacia su siguiente destino.";
      }
      speak(_instruccion);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading && _instruccion == ""
          ? const Center(child: CircularProgressIndicator())
          : Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CustomPaint(
                  painter: BluePainter(),
                  child: Container(
                    height: _customPaintHeight,
                  ),
                ),
              ),
          SafeArea(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                setState(() {
                  _customPaintHeight = (380 - scrollInfo.metrics.pixels).clamp(0.0, 380.0);
                });
                return true;
              },
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
                                _botonCancelarRecorrido = true;
                                _cancelarNavegacion(context);
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
                          //emergencyButton(context), //queda comentado hasta que se haga el boton de alerta desde navegacion
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),),
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