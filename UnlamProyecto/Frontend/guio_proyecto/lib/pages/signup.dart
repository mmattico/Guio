import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guio_proyecto/pages/home_page.dart';
import 'login.dart';

/*const users =  {
  'admin@gmail.com': '12345',
  'guioapp@gmail.com': 'guioapp',
};*/



class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>{
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dniController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //_back(context),
                const SizedBox(height: 30),
                _headerSignUp(context),
                const SizedBox(height: 30),
                _inputSignUp(context),
                const SizedBox(height: 15),
                _accesibilityCheck(context),
                const SizedBox(height: 20),
                _buttonSignup(context),
                const SizedBox(height: 35),
                _logIn(context),
              ],
            ),
          ),
        ),),),
    );
  }

  _back (context){
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  _headerSignUp(context) {
    return const SizedBox(
      width: double.infinity, // Asegura que el Container ocupe todo el ancho disponible
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "¡Bienvenido a \nGUIO App!",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10), // Añade un espacio entre los textos si lo deseas
          Text(
            "Registrate para utilizar la aplicación",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  _inputSignUp(context){
    return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: "Nombre y Apellido",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.person)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su Nombre y Apellido';
                    }
                    if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value)) {
                      return 'Por favor, utilice únicamente caracteres alfabéticos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _dniController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: "DNI",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.credit_card),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su DNI';
                    }
                    if (value.length < 7 || value.length > 8) {
                      return 'El DNI debe tener entre 7 y 8 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: "Correo Electrónico",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.alternate_email)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su correo electrónico';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Formato inválido de correo electrónico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: "Número de Teléfono",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese su número telefónico';
                      }
                      if (value.length != 10) {
                        return 'El número telefónico debe tener 10 dígitos';
                      }
                    },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Contraseña",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.password),
                  ),
                  obscureText: true,
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese una contraseña';
                }
                if (value.length <10) {
                  return 'La contraseña debe tener un mínimo de 10 caracteres';
                }
                return null;
              },
                ),
              ],
            )
        )
    );
  }

  _accesibilityCheck(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CheckboxListTile(
            activeColor: Colors.green,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            title: Text('Deseo tener por defecto activas las opciones de accesibilidad'),
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value ?? false;
              });
            },
          ),
        )

        //Text(_isChecked ? 'Checkbox está seleccionado' : 'Checkbox no está seleccionado'),
      ],
    );
  }

  _buttonSignup(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.check, color: Colors.green, size: 90,),
                      SizedBox(height: 8),
                      Text(
                        '¡Te haz registrado en GUIO App!',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Inicia sesión para comenzar a utilizar las funcionalidades',
                        style: TextStyle(fontSize: 18,),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  actions: <Widget>[
                    Center(
                      child: SizedBox(
                        width: 250,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()),);
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => AccesibleHome()),);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
                          ),
                          child: const Text(
                            "Iniciar Sesión",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
        ),
        child: const Text(
          "Registrate",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  _logIn(context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("¿Ya tienes cuenta?"),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
            },
            child: const Text("Iniciar Sesión", style: TextStyle(color: Color.fromRGBO(17, 116, 186, 1)),)
        )
      ],
    );
  }
}

