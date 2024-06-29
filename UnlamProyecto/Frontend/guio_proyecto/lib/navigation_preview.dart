import 'package:flutter/material.dart';
import 'home_page.dart';

class NavigationPreview extends StatefulWidget {
  final String? selectedService;
  final String? selectedArea;

  const NavigationPreview({Key? key, required this.selectedArea, required this.selectedService}) : super(key: key);

  @override
  _NavigationPreviewState createState() => _NavigationPreviewState();
}

class _NavigationPreviewState extends State<NavigationPreview> {
  String selectedPreference = '';

  bool preferenceIsDisabled = false;
  int? selectedIconIndexPreference;

  void onIconPressedService(int index) {
    setState(() {
      if (selectedIconIndexPreference == index) {
        preferenceIsDisabled = !preferenceIsDisabled;
        if (selectedPreference.isEmpty){
          selectedPreference = serviceTexts[index];
        } else {
          selectedPreference = '';
        }
      } else {
        preferenceIsDisabled = true;
        selectedIconIndexPreference = index;
        selectedPreference = serviceTexts[index];
      }

      if (!preferenceIsDisabled) {
        selectedIconIndexPreference = null;
      }

    });
    print('Selected service: $selectedPreference');
  }

  List<String> serviceTexts = [
    'Escaleras',
    'Ascensor',
    'Indiferente'
  ];

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
                'Indicaciones para ir hacia:',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
              (widget.selectedArea != '' && widget.selectedService != '')
                  ? '${widget.selectedArea} y \n${widget.selectedService}'
                  : (widget.selectedService != '')
                  ? '${widget.selectedService}'
                  : (widget.selectedArea != '')
                  ? '${widget.selectedArea}'
                  : 'None',
              style: TextStyle(fontSize: 35),
            ),
              const SizedBox(height: 10),
              Image.network(
                'https://www.ciudad.com.ar/resizer/v2/google-ofrece-distintas-funcionalidades-segun-la-version-del-reloj-3GFIXP57D5EXVAERWCSWJMPBKI.jpg?auth=98190f348eb7e4dbb55927279f6c3b5654aff33290026f9c2f56cef508601682&width=767', //Reemplazar con Icon de GUIO
                width: 350,
              ),
              const SizedBox(height: 30),


              const Text(
                'Accesibilidad',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(serviceTexts.length, (index) {
                  return InkWell(
                    onTap: preferenceIsDisabled && selectedIconIndexPreference != index
                        ? null
                        : () => onIconPressedService(index),
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: preferenceIsDisabled && selectedIconIndexPreference != index
                                ? Colors.grey
                                : Colors.blue[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 40,
                            color: preferenceIsDisabled && selectedIconIndexPreference != index
                                ? Colors.grey
                                : Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          serviceTexts[index],
                          style: TextStyle(
                            color: preferenceIsDisabled && selectedIconIndexPreference != index
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: 250,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: /*selectedService.isEmpty && selectedArea.isEmpty ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigationPreview(selectedService: selectedService),
                        ),
                      );
                    },*/ () {},
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