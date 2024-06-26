import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.help),
              tooltip: 'Help Icon',
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.grey,
          elevation: 50.0,
          leading: IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {},
          ),
        ),
        body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.fromLTRB(24, 10, 24, 24),
            child:
            Column(
              children: [
                _heading(context),
                const SizedBox(height: 10),
                _searchBar(context),
                const SizedBox(height: 10),
                _mostVisited(context),
                //const SizedBox(height: 10),
                _carouselAreas(context),
                //const SizedBox(height: 10),
                _services(context),
                const SizedBox(height: 10),
                //_carouselServices(context),
                const SizedBox(height: 10),
                _emergencyButton(context),
              ],
            )
        ),
      ),
      ),
      debugShowCheckedModeBanner: false, //Removing Debug Banner
    );
  }

  _heading(context){ //Ver como hacer para ponerlo a la izquierda
    return const
    Center(
      child: Column(
        children: [
          Text(
            "Bienvenido",
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
          ),
          Text(
            "¿A donde quiere ir?",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  _searchBar(context){
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

  _mostVisited(context){ //Ver como hacer para ponerlo a la izquierda
    return const
    Center(
      child: Column(
        children: [
          Text(
            "Lugares más visitados",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            "Seleccione un área",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  _carouselAreas(context){
    return CarouselSlider(
      options: CarouselOptions(height: 170.0,
        //enableInfiniteScroll: true,
        enlargeCenterPage: true,
        viewportFraction: 0.4
      ),
      items: [1,2,3,4,5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: 170, //MediaQuery.of(context).size.width
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.lightBlueAccent
                ),
                child: Center(
                    child:
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child:
                      Text('ÁREA $i', style: const TextStyle(fontSize: 16.0, color: Colors.black)),
                    )
                )

            );
          },
        );
      }).toList(),
    );
  }

  _services(context){ //Ver como hacer para ponerlo a la izquierda
    return const
    Center(
      child: Column(
        children: [
          Text(
            "Servicios",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            "Seleccione un servicio",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  _emergencyButton(context){
    return Column(
      children: [
        SizedBox(
            width: 250,
            height: 60,
            child:ElevatedButton(
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
            )
        ),
      ],
    );
  }


  /*_emergencyPopUp(context) {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "ALERTA ENVIADA",
      desc: "¡Por favor, quédate en la misma ubicación hasta recibir asistencia!",
      buttons: [
        DialogButton(
          child: Text(
            "Emergencia Solucionada",
            style: TextStyle(color: Colors.white, fontSize: 19),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
          height: 60,
        ),
        DialogButton(
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
          height: 60,
        ),
      ],
    ).show();
  }*/

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
                color: Colors.red
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
              textAlign: TextAlign.center
          ),
          actions: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      //backgroundColor: const Color.fromRGBO(145, 197, 148, 75)
                    ),
                    child: const Text('Emergencia Solucionada'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      //backgroundColor: Colors.grey
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
