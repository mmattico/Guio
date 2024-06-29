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

  String selectedValue = '';

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
              'Bienvenido',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),

             SizedBox(
              width: 350,
              child:
                OutlinedButton(
                  onPressed: () async {
                    final result = await showSearch<String>(
                      context: context,
                      delegate: CustomSearchDelegate(),
                    );
                    if (result != null && result.isNotEmpty) {
                      setState(() {
                        selectedValue = result;
                      });
                    }
                  },
                  child: const Text('¿A dónde desea ir?'),
                ),
            ),

            if (selectedValue.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Usted ha seleccionado: $selectedValue',
                      style:
                      const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,),),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedValue = '';
                        });
                      },
                      child: const Text('Limpiar'),
                    ),
                  ],
                ),
              ),

            if (selectedValue.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Aún no ha seleccionado ningún area',
                  style:
                  TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,),
                ),

              ),

            const SizedBox(height: 20),


            /*const Text(
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
            ),*/
            //const SizedBox(height: 10),
            const Text(
              'Servicios',
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
                  onTap: serviceIsDisabled && selectedIconIndexService != index
                      ? null
                      : () => onIconPressedArea(index),
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
                        child: const Icon(
                          Icons.favorite,
                          size: 40,
                          color: Colors.blue,
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
            const SizedBox(height: 50),
            Center(
              child: SizedBox(
                width: 250,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // Agregar accion
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
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: _emergencyButton(context),
            ),
          ],
        ),
        ),
        ),
    );
  }

  Widget _emergencyButton(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 250,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              _emergencyPopUp(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.red,
            ),
            child: const Text(
              "EMERGENCIA",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _emergencyPopUp(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            children: <Widget>[
              Icon(
                Icons.info_outline, // Icono grande
                size: 80, // Tamaño del icono
                color: Colors.red,
              ),
              SizedBox(height: 10), // Espacio entre el icono y el título
              Text(
                'ALERTA ENVIADA',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: const Text(
            '¡Por favor, quédate en la\n'
                'misma ubicación hasta recibir asistencia!\n',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Emergencia Solucionada'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
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

class CustomSearchDelegate extends SearchDelegate<String> {

  List<String> searchTerms = [
    "Cardiología",
    "Traumatología",
    "Oftalmología",
    "Clinica Médica",
    "Obstetricia",
    "Cirujía",
    "Internaciones",
    "Internaciones"
  ];

  // Sobrescribir para limpiar el texto de búsqueda
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // Sobrescribir para salir del menú de búsqueda
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, ''); // Devuelve una cadena vacía en lugar de null
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // Sobrescribir para mostrar el resultado de la consulta
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            close(context, result); // Devuelve el valor seleccionado y cierra el buscador
          },
        );
      },
    );
  }

  // Sobrescribir para mostrar el proceso de consulta en tiempo de ejecución
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            close(context, result); // Devuelve el valor seleccionado y cierra el buscador
          },
        );
      },
    );
  }
}