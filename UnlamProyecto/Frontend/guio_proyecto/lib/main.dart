import 'package:flutter/material.dart';

import 'package:guio_proyecto/pages/home_page.dart';
import 'package:provider/provider.dart';

//import 'dashboard_screen.dart';
import '/pages/login.dart';
import '/pages/signup.dart';
import '/pages/start_page.dart';
//import 'navigation.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GUIO App',
        theme: ThemeData(
          //useMaterial3: true,
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), //Queda comentado hasta ver cómo funcionan los temas
        ),
        home: const GeneratorPage(),
      ),
    );
  }
}

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const StartPage();
      case 1:
        page = const LoginPage();
      case 2:
        page = const SignupPage();
      case 3:
        page = const HomePage();

      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Container(
                //color: Theme.of(context).colorScheme.primaryContainer, //Queda comentado hasta solucionar problemas con colores
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class MyAppState extends ChangeNotifier {

}




