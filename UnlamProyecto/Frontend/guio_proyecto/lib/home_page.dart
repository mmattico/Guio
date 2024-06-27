import 'package:flutter/material.dart';
//import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool areaIsDisabled = false;
  int? selectedIconIndexArea;

  bool serviceIsDisabled = false;
  int? selectedIconIndexService;

  void onIconPressedArea(int index) {
    setState(() {
      if (selectedIconIndexArea == index) {
        areaIsDisabled = !areaIsDisabled;
      } else {
        areaIsDisabled = true;
        selectedIconIndexArea = index;
      }

      if (!areaIsDisabled) {
        selectedIconIndexArea = null;
      }
    });
  }

  void onIconPressedService(int index) {
    setState(() {
      if (selectedIconIndexService == index) {
        serviceIsDisabled = !serviceIsDisabled;
      } else {
        serviceIsDisabled = true;
        selectedIconIndexService = index;
      }

      if (!areaIsDisabled) {
        selectedIconIndexArea = null;
      }
    });
  }

  List<String> areaTexts = [
    'Cardiología',
    'Neurología',
    'Dermatología',
    'Pediatría',
    'Clinica Medica',
    'Ginecología'
  ];

  List<String> serviceTexts = [
    'Baño',
    'Snack',
    'Ventanilla'
  ];

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
      body:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '¿A dónde desea ir?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 1),
            _searchBar(context),
            const SizedBox(height: 20),
            const Text(
              'Áreas más visitadas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 5,
                children: List.generate(areaTexts.length, (index) {
                  return InkWell(
                      onTap: areaIsDisabled && selectedIconIndexArea != index
                          ? null
                          : () => onIconPressedArea(index),
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: areaIsDisabled && selectedIconIndexArea != index
                              ? Colors.grey
                              : Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 40,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        areaTexts[index],
                        style: TextStyle(
                          color: areaIsDisabled && selectedIconIndexArea != index
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  );
                }),
              ),
            ),
            //const SizedBox(height: 10),
            const SizedBox(height: 20),
            const Text(
              'Servicios',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 5,
                children: List.generate(serviceTexts.length, (index) {
                  return InkWell(
                    onTap: serviceIsDisabled && selectedIconIndexService != index
                        ? null
                        : () => onIconPressedService(index),
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: serviceIsDisabled && selectedIconIndexService != index
                                ? Colors.grey
                                : Colors.blue[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 40,
                            color: serviceIsDisabled && selectedIconIndexService != index
                                ? Colors.grey
                                : Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          serviceTexts[index],
                          style: TextStyle(
                            color: serviceIsDisabled && selectedIconIndexService != index
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child:
              SizedBox(
                  width: 250,
                  height: 60,
                  child:ElevatedButton(
                    onPressed: () {
                      //Agregar accion
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue[100],
                    ),
                    child: const Text(
                      "IR",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }


  _searchBar(BuildContext context) {
    String selectedValue = "Cardiología";
    return Column(children: <Widget>[
      DropdownButtonFormField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        value: selectedValue,
        items: dropdownItems,
        onChanged: (value) {  },
        isExpanded: true,
      )
    ]);

  }

}

List<DropdownMenuItem<String>> get dropdownItems{
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(value: "Cardiología", child: Text("Cardiología")),
    const DropdownMenuItem(value: "Traumatología", child: Text("Traumatología")),
    const DropdownMenuItem(value: "Oftalmología", child: Text("Oftalmología")),
    const DropdownMenuItem(value: "Clinica Médica", child: Text("Clinica Médica")),
    const DropdownMenuItem(value: "Obstetricia", child: Text("Obstetricia")),
    const DropdownMenuItem(value: "Cirujía", child: Text("Cirujía")),
    const DropdownMenuItem(value: "Internaciones", child: Text("Internaciones")),
    const DropdownMenuItem(value: "Guardia Médica", child: Text("Guardia Médica")),
  ];
  return menuItems;
}

