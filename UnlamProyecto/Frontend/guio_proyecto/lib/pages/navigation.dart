import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guio_proyecto/model/instruccion_node.dart';
import 'package:guio_proyecto/other/button_back.dart';
import 'package:guio_proyecto/other/emergency_navigation.dart';
import 'package:guio_proyecto/other/user_session.dart';
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
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math' as math;

import 'home_page_accesible.dart';

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
  int pasosARecorrer = 0;
  int pasosRecorridos = 0;
  String _imagenPath = "";
  double _angle = 0;
  int _norteGrado = 0;
  bool isAccesible=false;

  bool _cancelarRecorrido = false;
  bool _botonCancelarRecorrido = false;
  double _customPaintHeight = 360;
  String _finalizarRecorrido = 'Desea finalizar el recorrido';
  String _recorridoFinalizado = 'Recorrido finalizado';
  String posicionActual = "";

  bool _primerDestino = false;
  String _llegadaDestino = '¡Ha llegado a Destino!';

  String _location = '';
  bool _accesibilidad = false;

  // Podometro
  String _pasosValue = '0';
  int _pasosIniciales = 0;
  bool _primeraLectura =
      true; // Chequeo primera lectura de paso sino da el total del podometro
  final double stepLength = 0.762; // Valor de paso promedio
  Stream<StepCount>? _stepCountStream;
  StreamSubscription<StepCount>? _stepCountSubscription;

  // Magnetometro
  StreamSubscription<CompassEvent>? _compassSubscription;
  double direccionMagnetometro = 0;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _getAccesibilidad();
    requestPermisos();
    startListening();
    _iniciarProceso();
    loadUserAccessibility();
  }

  void loadUserAccessibility() async {
    final bool? userAccessibility = await getUserAccessibility();
    if (userAccessibility != null) {
      setState(() {
        isAccesible = userAccessibility;
      });
    }
  }

  Future<void> _iniciarProceso() async {
    await _cargarLocation();
    obtenerInstruccionesCamino();
  }

  Future<void> _cargarLocation() async {
    String? location = await getGraphCode();
    setState(() {
      _location = location!;
      print("LOCATION: " + _location!);
    });
  }

  Future<void> _getAccesibilidad() async {
    bool? accesibilidad = await getUserAccessibility();
    setState(() {
      _accesibilidad = accesibilidad!;
      selectedVoiceAssistance = _accesibilidad;
      print("ACCESIBILIDAD: $_accesibilidad");
    });
  }

  void _updateCancelarRecorrido(bool value) {
    setState(() {
      _cancelarRecorrido = value;
    });
  }

  Future<void> _popupPrimerDestino(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            '¡Ha llegado a su primer destino!',
            style: TextStyle(
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          ),
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
                      child: const Text(
                        'Continuar',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
                      ),
                      onPressed: () {
                        _primerDestino = false;
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  backgroundColor: Color.fromRGBO(17, 116, 186, 1),
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
                style: TextStyle(
                    color: Color.fromRGBO(17, 116, 186, 1), fontSize: 18),
              ),
            ),
          ],
        );
      },
    );

    if (respuesta == true) {
      bool wasVoiceAssistanceEnabled = selectedVoiceAssistance;

      setState(() {
        _cancelarRecorrido = true;
        if (selectedVoiceAssistance) {
          selectedVoiceAssistance = !selectedVoiceAssistance;
        }
        _botonCancelarRecorrido = !_botonCancelarRecorrido;
      });

      detenerReproduccion();
      Vibration.cancel();

      if (wasVoiceAssistanceEnabled) {
        await speak(_recorridoFinalizado);
      }

      if(!isAccesible){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => const HomePage()),(Route<dynamic> route) => false,);
      }else{
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AccesibleHome()),
              (Route<dynamic> route) => false,
        );
      }
    }
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
    _stepCountSubscription = _stepCountStream!
        .listen(onStepCount, onError: onStepCountError, cancelOnError: false);
  }

  void resetStepCount() {
    setState(() {
      _primeraLectura = true;
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
        direccionMagnetometro = direccionMagnetometro + 180;
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
    if (widget.selectedService!.isEmpty) {
      print("LOCATION ISSSS: " + _location);
      url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net',
          '/api/dijktra/mascorto', {
        'ORIGEN': widget.selectedOrigin,
        'DESTINO': widget.selectedArea,
        'PREFERENCIA': widget.selectedPreference,
        'UBICACION': _location
      });
    } else if (widget.selectedArea!.isEmpty) {
      url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net',
          '/api/dijktra/portipo', {
        'ORIGEN': widget.selectedOrigin,
        'SERVICIO': widget.selectedService,
        'PREFERENCIA': widget.selectedPreference,
        'UBICACION': _location
      });
    } else {
      url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net',
          '/api/dijktra/mascortoconnodointermedio', {
        'ORIGEN': widget.selectedOrigin,
        'DESTINO': widget.selectedArea,
        'SERVICIO': widget.selectedService,
        'PREFERENCIA': widget.selectedPreference,
        'UBICACION': _location
      });
    }
    posicionActual = widget.selectedOrigin.toString();
    print(url);
    print(widget.selectedOrigin);
    print(widget.selectedArea);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      _isLoading = false;
      print(json.decode(response.body));
      var responseData = Autogenerated.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
      late StreamSubscription? subscriptionInstruccion;
      late StreamSubscription? subscriptionTts;

      instrucciones = responseData.instrucciones.toList();
      _norteGrado = responseData.norteGrado;

      subscriptionInstruccion =
          Stream.periodic(const Duration(seconds: 1)).listen((_) async {
        while (_primerDestino) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
        ;
        while (_botonCancelarRecorrido) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
        setState(() {
          if (_cancelarRecorrido) {
            _girando = false;
            Vibration.cancel();
            subscriptionInstruccion?.cancel();
            subscriptionTts?.cancel();
            stopListening();
          } else {
            if (_instruccionActual > 0) {
              if ((_norteGrado + _angle - direccionMagnetometro) % 360 < 22 ||
                  (_norteGrado + _angle - direccionMagnetometro) % 360 >
                      (360 - 22)) {
                _girando = false;
                _instruccion =
                    instrucciones[_instruccionActual].instruccionToString();
              } else {
                _girando = true;
                _instruccion = "Gira hasta que dejes de sentir vibraciones";
                Vibration.vibrate();
              }
            }
          }
        });
      });

      subscriptionTts =
          Stream.periodic(const Duration(seconds: 6)).listen((_) async {
        while (_primerDestino) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
        ;
        while (_botonCancelarRecorrido) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
        if (_cancelarRecorrido) {
          detenerReproduccion();
        } else if (selectedVoiceAssistance) {
          detenerReproduccion();
          speak(_instruccion);
        }
      });

      _imagenPath = 'assets/images/narrow-top.png';
      resetStepCount();
      for (int i = 0; i < instrucciones.length; i++) {

        if (i == 0) {
          Vibration.vibrate(duration: 1500);
          if(selectedVoiceAssistance){
            speak(
                'Se ha iniciado el recorrido. El asistente de voz está activo.');
          }
        }

        while (_botonCancelarRecorrido) {
          await Future.delayed(const Duration(milliseconds: 100));
          detenerReproduccion();
        }

        if (_cancelarRecorrido) {
          break;
        }

        if (_instruccion != "" && selectedVoiceAssistance) {
          detenerReproduccion();
          speak(_instruccion);
        }

        print("________Ciclo: $i");

        if (instrucciones[i].commando == 'Fin parte 1 del recorrido') {
          Vibration.vibrate(pattern: [50, 500, 50, 1000]);
          _primerDestino = true;
          if (_instruccion != "" && selectedVoiceAssistance) {
            detenerReproduccion();
            _instruccion =
                "Ha llegado a su primer destino. Presione el boton continuar para avanzar hacia su siguiente destino.";
            speak(_instruccion);
          }
          await _popupPrimerDestino(context);
        } else {
          if (i > 0) {
            if (instrucciones[i - 1].distancia! > 0) {
              if (i > 2) {
                posicionActual = instrucciones[i - 2].siguienteNodo.toString();
              }
              setState(() {
                pasosRecorridos = 0;
                pasosARecorrer = instrucciones[i - 1].distancia!;
              });
              while (pasosRecorridos < pasosARecorrer) {
                print(
                    "Angulo final: ${(_norteGrado + _angle - direccionMagnetometro) % 360} --- NorteGrado: $_norteGrado --- DM: $direccionMagnetometro --- Angle: $_angle");
                await Future.delayed(const Duration(milliseconds: 500));
                if (_cancelarRecorrido) {
                  break;
                }
              }
              resetStepCount();
            }
          }
          setState(() {
            if (i > 0) {
              _instruccionActual = i;
              if (instrucciones[i].sentidoDestino != '') {
                _angle = _mapSentidoConSentidoDestinoAImagen(
                    instrucciones[i].sentidoOrigen ?? '');
              }
            }
          });
          print(
              "Instruccion actual: ${instrucciones[_instruccionActual].instruccionToString()}");
        }

        if (_instruccion != "" && selectedVoiceAssistance) {
          detenerReproduccion();
          speak(_instruccion);
        }
      }
      subscriptionInstruccion.cancel();
      subscriptionTts.cancel();
      stopListening();

      direccionMagnetometro = 0;
      _angle = 0;
      _norteGrado = 0;

      if (!_cancelarRecorrido) {
        detenerReproduccion();
        stopListening();
        _imagenPath = 'assets/images/arrived_2.png';
        _instruccion = _llegadaDestino;
        if(selectedVoiceAssistance){
          speak(_instruccion);
        }
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
    if (!_girando) {
      int pasosActuales = event.steps;
      if (_primeraLectura) {
        //seteo de primer lectura
        setState(() {
          _pasosIniciales = pasosActuales;
          _pasosValue = '0';
          _primeraLectura = false;
          pasosRecorridos = 0;
        });
      } else {
        // Calcula pasos despues de la primer lectura cuando no esta girando
        setState(() {
          if (pasosRecorridos < pasosARecorrer) {
            int pasosReales = pasosActuales - _pasosIniciales;
            _pasosValue = pasosReales.toString();
            pasosRecorridos = pasosReales; // Actualiza distancia recorrida
          } else {
            pasosRecorridos = pasosARecorrer;
          }
        });
      }
      print(
          "PasosRecorridos $pasosRecorridos  ---  PasosARecorrer: $pasosARecorrer");
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
    return DisableBackButton(
      child: Scaffold(
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
                          _customPaintHeight = (360 - scrollInfo.metrics.pixels)
                              .clamp(0.0, 360.0);
                        });
                        return true;
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(22, 25, 22, 12),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              header(),
                              SizedBox(
                                width: double.infinity,
                                height: 150,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Dirigiendose a ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              height: 1.0),
                                        ),
                                        const SizedBox(height: 9),
                                        SizedBox(
                                          width: double.infinity,
                                          // Ocupa todo el ancho disponible
                                          child: AutoSizeText(
                                            (widget.selectedArea != '' &&
                                                    widget.selectedService !=
                                                        '')
                                                ? '${widget.selectedArea} y ${widget.selectedService}'
                                                : (widget.selectedService != '')
                                                    ? '${widget.selectedService}'
                                                    : (widget.selectedArea !=
                                                            '')
                                                        ? '${widget.selectedArea}'
                                                        : 'None',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 45,
                                              // Tamaño máximo de la fuente
                                              fontWeight: FontWeight.bold,
                                              height: 1.1,
                                            ),
                                            maxLines: 2,
                                            minFontSize: 20,
                                            textAlign: TextAlign.left,
                                            // Alineación del texto a la izquierda
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              const SizedBox(height: 4),
                              Card(
                                color: Colors.white,
                                margin: const EdgeInsets.fromLTRB(6, 8, 6, 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                                        activeColor: const Color.fromRGBO(
                                            17, 116, 186, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                  child: _instruccion == _llegadaDestino
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: 35,
                                            ),
                                            Image.asset(
                                              _imagenPath,
                                              width: 230.0,
                                              height: 230.0,
                                            ),
                                            SizedBox(
                                              height: 50,
                                            ),
                                          ],
                                        )
                                      : SizedBox(
                                          width: double.infinity,
                                          height: 290.0,
                                          child: Transform.rotate(
                                            angle: (_norteGrado +
                                                    _angle -
                                                    direccionMagnetometro) *
                                                math.pi /
                                                180,
                                            // Rotar 45 grados
                                            child: Image.asset(
                                              _imagenPath,
                                              height: 280,
                                            ),
                                          )
                                  )
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          4, 2, 4, 10),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _instruccion,
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 80,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _botonCancelarRecorrido = true;
                                          _cancelarNavegacion(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          backgroundColor: Color.fromRGBO(17, 116, 186, 1),
                                        ),
                                        child: const Text(
                                          "Finalizar Recorrido",
                                          style: TextStyle(fontSize: 20, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Semantics(
                                      label: 'Enviar Alerta',
                                      button: true,
                                      child: IconButton(
                                        onPressed: () {
                                          _cancelarRecorrido = true;
                                          print(posicionActual);
                                          confirmacionAreaActual(context, posicionActual, _updateCancelarRecorrido);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                        icon: const Icon(
                                          Icons.sos,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
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

Widget header() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage("assets/images/logo_GUIO.png"),
            width: 100,
          ),
        ],
      ),
      SizedBox(height: 10),
    ],
  );
}
