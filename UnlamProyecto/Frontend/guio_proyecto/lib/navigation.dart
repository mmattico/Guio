import 'package:flutter/material.dart';
import 'home_page.dart';

class Navigation extends StatefulWidget {
  final String? selectedService;
  final String? selectedArea;
  final String? selectedOrigin;
  final String? selectedPreference;

  const Navigation({Key? key, required this.selectedOrigin, required this.selectedArea,
    required this.selectedService, required this.selectedPreference}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool selectedVoiceAssistance = false;

  void toggleSwitch(bool value){
    setState(() {
      selectedVoiceAssistance=!selectedVoiceAssistance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Dirigiendose a ",
                style: TextStyle(fontSize: 25),
              ),
              Text(
                '${widget.selectedArea}',
                style: const TextStyle(fontSize: 40),
              ),

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
            ),
              Center(
                child: Image.network(
                  'https://cdn-icons-png.freepik.com/512/7884/7884621.png',
                  height: 300,
                ),
              ),

              const Center(
                child: Text(
                  "Gire a la Derecha",
                  style: TextStyle(fontSize: 25),
                ),
              ),

              const SizedBox(height: 40),

              Center(
                child: SizedBox(
                  width: 250,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),);
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
              ),
            ],
          ),
      ),
      ),
    );
  }
}

