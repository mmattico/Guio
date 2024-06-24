import 'package:flutter/material.dart';
//import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          //title: const Text("GUIO App"), // Agregar logo
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              'https://cdn.logo.com/hotlink-ok/logo-social.png',
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
        body: Container(
            margin: const EdgeInsets.fromLTRB(24, 10, 24, 24),
            child:
            Column(
              children: [
                _heading(context),
                const SizedBox(height: 10),
                //_searchBar(context),
                const SizedBox(height: 10),
                _mostVisited(context),
                const SizedBox(height: 10),
                //_carrouselAreas(context),
                const SizedBox(height: 10),
                _services(context),
                const SizedBox(height: 10),
                //_carrouselServices(context),
                const SizedBox(height: 10),
                _emergencyButton(context),
              ],
            )
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

}
