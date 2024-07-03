import 'package:flutter/material.dart';
//import 'navigation_confirmation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedArea = '';
  String selectedService = '';
  String selectedOrigin = '';
  String selectedPreference = '';

  bool areaIsDisabled = false;
  int? selectedIconIndexArea;

  bool serviceIsDisabled = false;
  int? selectedIconIndexService;

  bool preferenceIsDisabled = false;
  int? selectedIconIndexPreference;

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
        if (selectedService.isEmpty){
          selectedService = serviceTexts[index];
        } else {
          selectedService = '';
        }
      } else {
        serviceIsDisabled = true;
        selectedIconIndexService = index;
        selectedService = serviceTexts[index];
      }

      if (!serviceIsDisabled) {
        selectedIconIndexService = null;
      }

    });
    print('Selected service: $selectedService');
  }

  void onIconPressedAccesibility(int index) {
    setState(() {
      if (selectedIconIndexPreference == index) {
        preferenceIsDisabled = !preferenceIsDisabled;
        if (selectedPreference.isEmpty){
          selectedPreference = accesibilityTexts[index];
        } else {
          selectedPreference = '';
        }
      } else {
        preferenceIsDisabled = true;
        selectedIconIndexPreference = index;
        selectedPreference = accesibilityTexts[index];
      }

      if (!preferenceIsDisabled) {
        selectedIconIndexPreference = null;
      }

    });
    print('Selected service: $selectedPreference');
  }

  List<String> accesibilityTexts = [
    'Escaleras',
    'Ascensor',
    'Indiferente'
  ];

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              printHeader(),
              Center(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 150,
                        child:
                        OutlinedButton(
                          onPressed: () async {
                            final resultOrigin = await showSearch<String>(
                              context: context,
                              delegate: CustomSearchDelegate(),
                            );
                            if (resultOrigin != null && resultOrigin.isNotEmpty) {
                              setState(() {
                                selectedOrigin = resultOrigin;
                              });
                            }
                          },
                          child: const Text('Origen'),
                        ),
                      ),

                      const SizedBox(width: 20),

                      SizedBox(
                        width: 150,
                        child:
                        OutlinedButton(
                          onPressed: () async {
                            final result = await showSearch<String>(
                              context: context,
                              delegate: CustomSearchDelegate(),
                            );
                            if (result != null && result.isNotEmpty) {
                              setState(() {
                                selectedArea = result;
                              });
                            }
                          },
                          child: const Text('Destino'),
                        ),
                      ),
                    ]

                ),
              ),

              const SizedBox(height: 10),

              if((selectedArea == selectedOrigin) && (selectedArea.isNotEmpty || selectedOrigin.isNotEmpty))
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('El lugar de origen y destino deben ser diferentes',
                    style:
                    TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,),
                  ),

                ),

              if (selectedOrigin.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Aún no ha indicado su origen',
                    style:
                    TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,),
                  ),

                ),

              if (selectedArea.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Aún no ha seleccionado ningún destino',
                    style:
                    TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,),
                  ),
                ),

              if (selectedOrigin.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Origen: $selectedOrigin',
                        style:
                        const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,),),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedOrigin = '';
                          });
                        },
                        child: const Text('Limpiar Origen'),
                      ),
                    ],
                  ),
                ),

              if (selectedArea.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Destino: $selectedArea',
                        style:
                        const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,),),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedArea = '';
                          });
                        },
                        child: const Text('Limpiar Destino'),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

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
                physics: const NeverScrollableScrollPhysics(),
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

              const SizedBox(height: 20),
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
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(accesibilityTexts.length, (index) {
                  return InkWell(
                    onTap: preferenceIsDisabled && selectedIconIndexPreference != index
                        ? null
                        : () => onIconPressedAccesibility(index),
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
                          accesibilityTexts[index],
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
                    onPressed: (selectedOrigin.isEmpty || (selectedService.isEmpty && selectedArea.isEmpty)
                        || (selectedOrigin == selectedArea) || selectedPreference.isEmpty) ? null : () {
                      /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationConfirmation(selectedOrigin: selectedOrigin,
const                             selectedArea: selectedArea, selectedService: selectedService, selectedPreference: selectedPreference),
                      ),
                    );*/
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmación'),
                            /*content: NavigationConfirmation(
                              selectedOrigin: selectedOrigin,
                              selectedArea: selectedArea,
                              selectedService: selectedService,
                              selectedPreference: selectedPreference,
                            ),*/
                            actions: [
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Cierra el diálogo
                                  },
                                  child: const Text('Modificar',
                                    style: TextStyle(fontSize: 20, color: Colors.black),),
                                ),
                              )
                            ],
                          );
                        },
                      );
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

Widget printHeader(){
  return const Text(
    'Bienvenido',
    style: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
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