import 'dart:ffi';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guio_proyecto/other/user_session.dart';
import 'package:guio_proyecto/pages/home_page.dart';
import '../model/user.dart';
import 'login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/*const users =  {
  'admin@gmail.com': '12345',
  'guioapp@gmail.com': 'guioapp',
};*/

class MyDataPage extends StatefulWidget {
  const MyDataPage({super.key});

  @override
  _MyDataPageState createState() => _MyDataPageState();
}

class _MyDataPageState extends State<MyDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _dniController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isChecked = false; // este se envía para lo de accesibilidad :)
  int _userID = 0;
  String errorUsernameMessage = "";
  String errorDocumentMessage = "";
  String errorEmailMessage = "";
  String emailInicial = "";
  String userNameInicial = "";

  bool userNameChange = false;
  bool emailChange = false;
  bool passwordChange = false;

  bool _isValidatingInfo =
      false; // Variable para controlar el estado del botón "Registrate"

  String nombre = '';
  String apellido = '';
  String email = '';
  int telefono = 0;
  int dni = 0;
  String usuario = '';
  String password = '';

  @override
  void initState() {
    super.initState();

    getUserID().then((int? id) {
      setState(() {
        _userID = id ?? 0; // Si el id es nulo, asigna 0 u otro valor entero por defecto.
      });
    });
    getUserFirstName().then((String? firstName) {
      _firstnameController.text = firstName ?? '';
    });
    getUserLastName().then((String? lastName) {
      _lastnameController.text = lastName ?? '';
    });
    getUserEmail().then((String? userEmail) {
      emailInicial = userEmail!;
      _emailController.text = userEmail ?? '';
    });
    getUserPhone().then((String? firstName) {
      _phoneController.text = firstName ?? '';
    });
    getUserDNI().then((String? dni) {
      _dniController.text = dni ?? '';
    });
    getUsername().then((String? userName) {
      userNameInicial = userName!;
      _usernameController.text = userName ?? '';
    });
    getPassword().then((String? password) {
      _passwordController.text = password ?? '';
    });
    getUserAccessibility().then((bool? accesibility) {
      setState(() {
        _isChecked = accesibility ?? false;
      });
    });
  }

  Future<void> _getUserByUsername(String username) async{
    var url;
    url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/users/get-username/$username');
    print("Url: ${url.toString()}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("Response.body en _getUserByUsername: ${response.body}");
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      print("JsonMap: $jsonMap");
      print("JsonMap['contraseña']: ${jsonMap["contraseÃ±a"]}");

        await saveUserID(jsonMap["usuarioID"]);
        await saveUserFirstName(jsonMap["nombre"]);
        await saveUserLastName(jsonMap["apellido"]);
        await saveUserEmail(jsonMap["email"]);
        await saveUserPhone(jsonMap["telefono"]);
        await saveUserDNI(jsonMap["dni"]);
        await saveUsername(jsonMap["usuario"]);
        await savePassword(jsonMap["contraseÃ±a"]);
        await saveUserAccessibility(jsonMap["accesibilidadDefault"]);
    }
  }

  Future<void> _validateUsername() async {
    var url;
    url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net',
        '/api/users/validar-nombre-usuario', {'USERNAME': usuario});

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print("Retorno usuario $responseData");
      if (!responseData) {
        errorUsernameMessage = "";
      } else {
        errorUsernameMessage = "El nombre de usuario ingresado ya esta en uso";
      }
    } else {
      errorUsernameMessage = "Error al validar usuario, intente de nuevo";
    }
  }

  Future<void> _validateDocument() async {
    var url;
    url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net',
        '/api/users/validar-documento', {'DNI': dni.toString()});

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print("Retorno documento $responseData");
      if (!responseData) {
        errorDocumentMessage = "";
      } else {
        errorDocumentMessage = "El dni ingresado ya esta en uso";
      }
    } else {
      errorDocumentMessage = "Error al validar dni, intente de nuevo";
    }
  }

  Future<void> _validateEmail() async {
    var url;
    url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net',
        '/api/users/validar-correo', {'EMAIL': email});

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print("Retorno email $responseData");
      if (!responseData) {
        errorEmailMessage = "";
      } else {
        errorEmailMessage = "El correo ingresado ya esta en uso";
      }
    } else {
      errorEmailMessage = "Error al validar correo, intente de nuevo";
    }
  }

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
                children: [
                  const SizedBox(height: 30),
                  _headerSaveChanges(context),
                  const SizedBox(height: 30),
                  _inputSaveChanges(context),
                  const SizedBox(height: 15),
                  _accesibilityCheck(context),
                  const SizedBox(height: 20),
                  _buttonSaveChanges(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  _headerSaveChanges(context) {
    return const SizedBox(
      width: double
          .infinity, // Asegura que el Container ocupe todo el ancho disponible
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Mi cuenta",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          )/*,
          SizedBox(
              height: 10), // Añade un espacio entre los textos si lo deseas
          Text(
            "Registrate para utilizar la aplicación",
            style: TextStyle(fontSize: 18),
          ),*/
        ],
      ),
    );
  }

  _inputSaveChanges(context) {
    return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _firstnameController,
                  decoration: InputDecoration(
                      hintText: "Nombre",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.person)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su Nombre';
                    }
                    if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value)) {
                      return 'Por favor, utilice únicamente caracteres alfabéticos';
                    }

                    nombre = value;
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _lastnameController,
                  decoration: InputDecoration(
                      hintText: "Apellido",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.person)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su Apellido';
                    }
                    if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value)) {
                      return 'Por favor, utilice únicamente caracteres alfabéticos';
                    }


                    apellido = value;
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
                  enabled: false, // Deshabilita el campo
                  validator: (value) {
                   /* if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su DNI';
                    }
                    if (value.length < 7 || value.length > 8) {
                      return 'El DNI debe tener entre 7 y 8 caracteres';
                    }*/

                    try {
                      dni =
                          int.parse(value!); // Conversión segura de String a int
                    } catch (e) {
                      return 'El DNI debe contener solo números';
                    }

                    if (errorDocumentMessage == "") {
                      return null;
                    } else {
                      return errorDocumentMessage;
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: "Correo Electrónico",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.alternate_email)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su correo electrónico';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Formato inválido de correo electrónico';
                    }
                    email = value;

                    if (value != emailInicial) {
                      emailChange = true;
                    }

                    if (errorEmailMessage == "") {
                      return null;
                    } else {
                      return errorEmailMessage;
                    }
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
                    try {
                      telefono =
                          int.parse(value); // Conversión segura de String a int
                    } catch (e) {
                      return 'El número telefónico debe contener solo números';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      hintText: "Nombre de usuario",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.person)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un nombre de usuario';
                    }
                    usuario = value;

                    if (value != userNameInicial) {
                      userNameChange = true;
                    }

                    if (errorUsernameMessage == "") {
                      return null;
                    } else {
                      return errorUsernameMessage;
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
                    if (value.length < 10) {
                      return 'La contraseña debe tener un mínimo de 10 caracteres';
                    }

                    if (value != _passwordController.text) {
                      passwordChange = true;
                    }

                    password = value;
                    return null;
                  },
                ),
              ],
            )));
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
            title: const Text(
              'Deseo tener por defecto activas las opciones de accesibilidad',
              style: TextStyle(fontSize: 14),
            ),
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value ?? false;
              });
            },
          ),
        )
      ],
    );
  }


  _buttonSaveChanges(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: (_isValidatingInfo)
            ? null
            : () async {
                setState(() {
                  _isValidatingInfo = true; // Deshabilita el botón
                });

                _formKey.currentState!.validate();

                if(userNameChange == true){
                  await _validateUsername();
                }
                if(emailChange == true){
                  await _validateEmail();
                }

                if (_formKey.currentState!.validate()) {
                  //Acá se envian los datos a la BD de usuario
                  User user = User(
                    nombre: nombre,
                    apellido: apellido,
                    dni: dni.toString(),
                    email: email,
                    telefono: telefono.toString(),
                    permisos: 'USER',
                    usuario: usuario,
                    password: password,
                    accesibilidadDefault: _isChecked,
                    contraseniaReseteada: false,
                  );

                  final response = await updateUser(_userID,user);// Acá va el método para actualizar

                  if (response.statusCode == 200) {
                    // Usuario creado con éxito
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 90,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '¡Cambios guardados!',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()),
                                      );
                                      _getUserByUsername(usuario);
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()),(Route<dynamic> route) => false,);
                                    }
                                  },

                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    backgroundColor:
                                        const Color.fromRGBO(17, 116, 186, 1),
                                  ),
                                  child: const Text(
                                    "Continuar",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
                setState(() {
                  _isValidatingInfo = false; // Habilita el botón de nuevo
                });
              },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          backgroundColor: _isValidatingInfo
              ? const Color.fromRGBO(17, 116, 186,
                  0.25) // Cambia el color del botón cuando está deshabilitado
              : const Color.fromRGBO(17, 116, 186, 1),
        ),
        child: const Text(
          "Guardar cambios",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

}
