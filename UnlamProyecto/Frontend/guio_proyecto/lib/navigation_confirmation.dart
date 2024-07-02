import 'package:flutter/material.dart';
import 'home_page.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(7.0),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Usted ha seleccionado origen ' ,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Center(
                child: Text(
                  '${widget.selectedOrigin}',
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Con destino a ',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Center(
                child: Text(
                  (widget.selectedArea != '' && widget.selectedService != '')
                      ? '${widget.selectedArea} y \n${widget.selectedService}'
                      : (widget.selectedService != '')
                      ? '${widget.selectedService}'
                      : (widget.selectedArea != '')
                      ? '${widget.selectedArea}'
                      : 'None',
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Utilizando ' ,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Center(
                child: Text(
                  '${widget.selectedPreference}',
                  style: const TextStyle(fontSize: 30),
                ),
              ),

              const SizedBox(height: 100),
              Center(
                child: SizedBox(
                  width: 250,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () /*{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigationPreview(selectedService: selectedService),
                        ),
                      );
                    },*/ {},
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue[100],
                    ),
                    child: const Text(
                      "Iniciar Navegación",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 150,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()),);
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.grey,
                ),
                child: const Text(
                  "Cancelar",
                  style: TextStyle(fontSize: 20, color: Colors.white),
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