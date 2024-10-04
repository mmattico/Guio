import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/user_session.dart';
import '../pages/home_page.dart';
import '../pages/navigation.dart';
import 'package:flutter/services.dart';

class NavigationConfirmation extends StatefulWidget {
  final String? selectedService;
  final String? selectedArea;
  final String? selectedOrigin;
  final String? selectedPreference;

  const NavigationConfirmation({Key? key, required this.selectedOrigin, required this.selectedArea,
    required this.selectedService, required this.selectedPreference}) : super(key: key);

  @override
  _NavigationConfirmationState createState() => _NavigationConfirmationState();
}

class _NavigationConfirmationState extends State<NavigationConfirmation> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(6, 4, 6, 2),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Origen ' ,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${widget.selectedOrigin}',
              style: const TextStyle(fontSize: 23),
            ),
            const SizedBox(height: 10),
            const Text(
              'Con destino a ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ), Text(
              (widget.selectedArea != '' && widget.selectedService != '')
                  ? '${widget.selectedArea} y ${widget.selectedService}'
                  : (widget.selectedService != '')
                  ? '${widget.selectedService}'
                  : (widget.selectedArea != '')
                  ? '${widget.selectedArea}'
                  : 'None',
              style: const TextStyle(fontSize: 23, height: 1.1,),
            ),
            const SizedBox(height: 10),
            const Text(
              'Utilizando ' ,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${widget.selectedPreference}',
              style: const TextStyle(fontSize: 23),
            ),

            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Navigation(
                          selectedOrigin: widget.selectedOrigin,
                          selectedArea: widget.selectedArea,
                          selectedService: widget.selectedService,
                          selectedPreference: widget.selectedPreference
                        ),
                      ),
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
                height: 40,
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
                height: 38,
                child: TextButton(
                  onPressed: () {

                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const HomePage()),);
                  },
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(fontSize: 20, color: Color.fromRGBO(17, 116, 186, 1)),
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