import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/button_back.dart';
import 'package:guio_proyecto/other/user_session.dart';
import 'package:guio_proyecto/pages/home_page_accesible.dart';
import '../pages/home_page.dart';
import '../pages/navigation.dart';
import 'package:flutter/services.dart';

class NavigationConfirmation extends StatefulWidget {
  final String? selectedService;
  final String? selectedArea;
  final String? selectedOrigin;
  final String? selectedPreference;
  final bool isAccesible;

  const NavigationConfirmation({
    Key? key,
    required this.selectedOrigin,
    required this.selectedArea,
    required this.selectedService,
    required this.selectedPreference,
    required this.isAccesible,
  }) : super(key: key);

  @override
  _NavigationConfirmationState createState() => _NavigationConfirmationState();
}

class _NavigationConfirmationState extends State<NavigationConfirmation> {
  @override
  Widget build(BuildContext context) {
    return DoubleBackToExit(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 4, 6, 2),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                label:
                'Origen: ${widget.selectedOrigin}, Destino: ${widget.selectedArea} y ${widget.selectedService}, Preferencia: ${widget.selectedPreference}',
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Origen: \n',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '${widget.selectedOrigin}\n',
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                        ),

                      ),
                      const TextSpan(
                        text: '\nCon destino a: \n',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: (widget.selectedArea != '' &&
                            widget.selectedService != '')
                            ? '${widget.selectedArea} y ${widget.selectedService}\n'
                            : (widget.selectedService != '')
                            ? '${widget.selectedService}\n'
                            : (widget.selectedArea != '')
                            ? '${widget.selectedArea}\n'
                            : 'None\n',
                        style: const TextStyle(
                          fontSize: 23,
                          height: 1.1,
                          color: Colors.black,
                        ),
                      ),
                      const TextSpan(
                        text: '\nUtilizando: \n',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '${widget.selectedPreference}',
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Navigation(
                            selectedOrigin: widget.selectedOrigin,
                            selectedArea: widget.selectedArea,
                            selectedService: widget.selectedService,
                            selectedPreference: widget.selectedPreference,
                          ),
                        ),
                            (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
                    ),
                    child: const Text(
                      "Iniciar Navegación",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(5.0),
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text(
                      "Modificar",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: TextButton(
                    onPressed: () {
                      if (widget.isAccesible) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccesibleHome()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      }
                    },
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(17, 116, 186, 1),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
