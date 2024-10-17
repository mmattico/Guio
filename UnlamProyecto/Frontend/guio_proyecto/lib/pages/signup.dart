import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/user.dart';
import 'login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  final String selectedUsuario;
  final String selectedEmail;
  final String usuarioOEmail;

  const SignupPage({super.key, String? selectedUsuario, String? selectedEmail, String? usuarioOEmail}): selectedUsuario = selectedUsuario ?? '', selectedEmail = selectedEmail ?? '', usuarioOEmail = usuarioOEmail ?? '';
  //const SignupPage({super.key}, optional usuario,telefono,email);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>{
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _dniController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isChecked = false; // este se envía para lo de accesibilidad :)
  String errorUsernameMessage = "";
  String errorDocumentMessage = "";
  String errorEmailMessage = "";
  bool _isPasswordVisible = false;

  bool _isValidatingInfo = false; // Variable para controlar el estado del botón "Registrate"

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
    _emailController.text = widget.selectedEmail;
    _usernameController.text = widget.selectedUsuario;
    if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(widget.usuarioOEmail)) {
      _emailController.text = widget.usuarioOEmail;
    } else {
      _usernameController.text = widget.usuarioOEmail;
    }
  }

  Future<void> _validateUsername() async{
    var url;
    url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/users/validar-nombre-usuario',
        {'USERNAME': usuario});

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print("Retorno usuario $responseData");
      if(!responseData) {
        errorUsernameMessage = "";
      } else {
        errorUsernameMessage = "El nombre de usuario ingresado ya esta en uso.";
      }
    } else {
      errorUsernameMessage = "Error al validar usuario, intente de nuevo.";
    }
  }

  Future<void> _validateDocument() async{
    var url;
    url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/users/validar-documento',
        {'DNI': dni.toString()});

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print("Retorno documento $responseData");
      if(!responseData) {
        errorDocumentMessage = "";
      } else {
        errorDocumentMessage = "El dni ingresado ya esta en uso.";
      }
    } else {
      errorDocumentMessage = "Error al validar dni, intente de nuevo.";
    }
  }

  Future<void> _validateEmail() async{
    var url;
    url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/users/validar-correo',
        {'EMAIL': email});

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print("Retorno email $responseData");
      if(!responseData) {
        errorEmailMessage = "";
      } else {
        errorEmailMessage = "El correo ingresado ya esta en uso.";
      }
    } else {
      errorEmailMessage = "Error al validar correo, intente de nuevo.";
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
                _headerSignUp(context),
                const SizedBox(height: 30),
                _inputSignUp(context),
                const SizedBox(height: 15),
                _accesibilityCheck(context),
                const SizedBox(height: 20),
                _buttonSignup(context),
                const SizedBox(height: 25),
                _logIn(context),
              ],
            ),
          ),
        ),),),
    );
  }

  _headerSignUp(context) {
    return SizedBox(
      width: double.infinity,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Registrate en GUIO App\n", // Primer texto con salto de línea
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Siempre especifica el color en TextSpan
              ),
            ),
            TextSpan(
              text: "Completá los campos y registrate para comenzar a navegar", // Segundo texto
              style: TextStyle(
                fontSize: 18,
                color: Colors.black, // El color también debe ser especificado
              ),
            ),
          ],
        ),
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
                  controller: _firstnameController,
                  decoration: InputDecoration(
                      hintText: "Nombre",
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
                      return 'Por favor, ingrese su Nombre.';
                    }
                    if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value)) {
                      return 'Por favor, utilice únicamente caracteres alfabéticos.';
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
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.person)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su Apellido.';
                    }
                    if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value)) {
                      return 'Por favor, utilice únicamente caracteres alfabéticos.';
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
                    hintText: "D.N.I",
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
                      return 'Por favor, ingrese su D.N.I.';
                    }
                    if (value.length < 7 || value.length > 8) {
                      return 'El D.N.I debe tener entre 7 y 8 caracteres.';
                    }

                    try {
                      dni = int.parse(value); // Conversión segura de String a int
                    } catch (e) {
                      return 'El DNI debe contener solo números.';
                    }

                    if(errorDocumentMessage == "") {
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
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.alternate_email)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su correo electrónico.';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Formato inválido de correo electrónico.';
                    }
                    email = value;

                    if(errorEmailMessage == "") {
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
                        return 'Por favor, ingrese su número telefónico.';
                      }
                      if (value.length != 10) {
                        return 'El número telefónico debe tener 10 dígitos.';
                      }
                      try {
                        telefono = int.parse(value); // Conversión segura de String a int
                      } catch (e) {
                        return 'El número telefónico debe contener solo números.';
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
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.person)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un nombre de usuario.';
                    }
                    usuario = value;

                    if(errorUsernameMessage == "") {
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[600],  // Color del ícono
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      highlightColor: Colors.transparent,  // Sin efecto de highlight
                      splashColor: Colors.grey[300],  // Un gris claro visible
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese una contraseña.';
                    }
                    if (value.length <10) {
                      return 'La contraseña debe tener un mínimo de 10 caracteres.';
                    }
                    password = value;
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
            title: const Text('Deseo tener por defecto activas las opciones de accesibilidad', style: TextStyle(fontSize: 14),),
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

  _buttonSignup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isValidatingInfo? null : () async {
          setState(() {
            _isValidatingInfo = true; // Deshabilita el botón
          });

          _formKey.currentState!.validate();

          await _validateUsername();
          await _validateDocument();
          await _validateEmail();

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

            final response = await createUser(user);

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
              ? const Color.fromRGBO(17, 116, 186, 0.25) // Cambia el color del botón cuando está deshabilitado
              : const Color.fromRGBO(17, 116, 186, 1),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()),);
            },
            child: const Text("Iniciar Sesión", style: TextStyle(color: Color.fromRGBO(17, 116, 186, 1)),)
        )
      ],
    );
  }
}

