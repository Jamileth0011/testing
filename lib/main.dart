import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bcrypt/bcrypt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const PantallaLogin(),
        'home': (context) => const MainApp(),
      },
    );
  }
}

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  // Hash encriptado con bcrypt que corresponde a la contraseña "1234"
  final String _passwordHashBD = '\$2a\$10\$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy';

  void _iniciarSesion() {
    String usuario = _usuarioController.text;
    String contrasena = _contrasenaController.text;

    // Validamos el usuario
    bool usuarioValido = (usuario == 'admin');
    
    // Validamos la contraseña usando bcrypt
    bool contrasenaValida = false;
    if (contrasena.isNotEmpty) {
      try {
        contrasenaValida = BCrypt.checkpw(contrasena, _passwordHashBD);
      } catch (e) {
        contrasenaValida = false;
      }
    }

if (usuarioValido && contrasenaValida) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Usuario o contraseña incorrectos.'),
            actions: [
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro solicitado
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Centrado general
            children: [
              // Nuevo logo centrado arriba
              const Icon(
                Icons.security_rounded,
                size: 90,
                color: Colors.cyanAccent,
              ),
              const SizedBox(height: 40),

              // Contenedor centrado para alinear los textos a la izquierda y las cajas de texto
              SizedBox(
                width: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Textos a la izquierda
                  children: [
                    // Username Label
                    const Text(
                      'Username:',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _usuarioController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF1E1E1E),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyanAccent),
                        ),
                        hintText: 'Ingresa tu usuario...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Label
                    const Text(
                      'Password:',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _contrasenaController,
                      obscureText: true, // Oculta la contraseña
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF1E1E1E),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyanAccent),
                        ),
                        hintText: 'Ingresa tu contraseña...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),

              // Botón Entrar centrado
              SizedBox(
                width: 320,
                child: ElevatedButton(
                  onPressed: _iniciarSesion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Entrar', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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




class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool modoCupertino = false;

  @override
  Widget build(BuildContext context) {
    if (modoCupertino) {
      return CupertinoApp(debugShowCheckedModeBanner: false,theme: const CupertinoThemeData(brightness: Brightness.light),
        home: PantallaPrincipal(modoCupertino: modoCupertino,
          onCambiarModo: (value) {
            setState(() {
              modoCupertino = value;
            });
          },
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PantallaPrincipal(modoCupertino: modoCupertino,
        onCambiarModo: (value) {
          setState(() {
            modoCupertino = value;
          });
        },
      ),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  final bool modoCupertino;
  final ValueChanged<bool> onCambiarModo;

  const PantallaPrincipal({
    super.key,
    required this.modoCupertino,
    required this.onCambiarModo,
  });

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  String mensaje = "Dale";

  List<String> mensajes = [
    "Por pendejos",
    "Porque no vale nada",
    "Por no entender nada",
    "Por flojear",
  ];

  int indice = 0;

  void cambiarMensaje() {
    setState(() {
      indice++;
      if (indice >= mensajes.length) {
        indice = 0;
      }
      mensaje = mensajes[indice];
    });
  }

  void mostrarAlerta(BuildContext context) {
    cambiarMensaje();

    if (widget.modoCupertino) {
      showCupertinoDialog(context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Alert'),content: Text(mensaje),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } else {
      showDialog( context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alert'), content: Text(mensaje),
            actions: [
              TextButton(child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.modoCupertino) {
      return CupertinoPageScaffold( backgroundColor: const Color.fromARGB(255, 80, 217, 241),
        child: SafeArea(
         child: _buildContenido(context),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 80, 217, 241),body: _buildContenido(context),
    );
  }

  Widget _buildContenido(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox( constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding( padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Ya Estuvo',
                      style: TextStyle(
                        fontSize: 32,fontWeight: FontWeight.bold,
                        color: Colors.black, decoration: TextDecoration.none,
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    Image.asset(
                      'asset/images/31a72afda250825d993400c3ef28c55c.gif',
                      width: 250,
                      height: 250,
                    ),
                    const SizedBox(height: 10),
                    
                    widget.modoCupertino
                        ? CupertinoSwitch(
                            value: widget.modoCupertino, onChanged: widget.onCambiarModo,
                          )
                        : Switch(
                            value: widget.modoCupertino, onChanged: widget.onCambiarModo,
                          ),
                    const SizedBox(height: 5),
                    Text( widget.modoCupertino
                          ? 'Modo iPhone (Cupertino)'
                          : 'Interfaz estilo Android',
                      style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold,
                        color: Colors.black,decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Text( 'Hola',
                          style: TextStyle(
                            fontSize: 60, fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 6, 6, 6), decoration: TextDecoration.none,
                          ),
                        ),
                        const Text( 'Adios',
                          style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold,
                            color: Colors.white, decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Vamonos a China Nuevo León',
                      style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold,
                        color: Colors.black,decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: 300,padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration( color: Colors.white,
                        border: Border.all(
                          color: Colors.black,width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(mensaje,textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,decoration: TextDecoration.none,fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.modoCupertino
                            ? CupertinoButton.filled(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                onPressed: () => mostrarAlerta(context),
                                child: const Text(
                                  'Prueba',style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                ),
                                onPressed: () => mostrarAlerta(context),
                                child: const Text(
                                  'Prueba',style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),

                        const SizedBox(width: 10),

                        widget.modoCupertino
                            ? CupertinoButton(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SegundaPantalla(modoCupertino: widget.modoCupertino),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Click', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              )
                            : OutlinedButton(
                                onPressed: () {
                                  Navigator.push( context,
                                    MaterialPageRoute(
                                      builder: (context) => SegundaPantalla(modoCupertino: widget.modoCupertino),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom( foregroundColor: Colors.black,side: const BorderSide(
                                 color: Colors.black, width: 2),padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                ),
                                child: const Text(
                                  'Click',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SegundaPantalla extends StatelessWidget {
  final bool modoCupertino;

  const SegundaPantalla({super.key, required this.modoCupertino});

  @override
  Widget build(BuildContext context) {
    if (modoCupertino) {
      return CupertinoPageScaffold(backgroundColor: const Color.fromARGB(255, 80, 217, 241),
        child: SafeArea(
          child: Center(
            child: Column( mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¡JA FUNCIONO!',
                  style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,
                    color: CupertinoColors.black, decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 80, 217, 241),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡JA FUNCIONO!',style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}