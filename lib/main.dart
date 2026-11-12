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
  final TextEditingController _confirmarController = TextEditingController();

  // Bandera para cambiar entre modo Login (false) y modo Registro (true)
  bool _esRegistro = false;

  // Base de datos simulada estructurada en formato JSON (Lista de Mapas)
  // Incluye por defecto al usuario 'admin' con su respectivo hash de bcrypt para la contraseña "1234"[cite: 4]
  final List<Map<String, dynamic>> _baseDatosUsuarios = [
    {
      "username": "admin",
      "passwordHash": r'$2a$12$vFbh6xlxYtVa0z5gLeV1BuCnq2Fs75lQek8vCntQ/eqpb8G7i3b6y',
    }
  ];

  void _procesarAccion() {
    String usuario = _usuarioController.text.trim();
    String contrasena = _contrasenaController.text;

    if (_esRegistro) {
      // ==========================================
      // LÓGICA DE REGISTRO EN FORMATO JSON
      // ==========================================
      String confirmar = _confirmarController.text;

      if (usuario.isEmpty || contrasena.isEmpty || confirmar.isEmpty) {
        _mostrarAlerta('Error', 'Por favor llena todos los campos.');
        return;
      }

      if (contrasena != confirmar) {
        _mostrarAlerta('Error', 'Las contraseñas no coinciden.');
        return;
      }

      // Verificamos si el usuario ya existe en nuestra lista JSON
      bool existe = _baseDatosUsuarios.any((u) => u["username"] == usuario);
      if (existe) {
        _mostrarAlerta('Error', 'El usuario ya está registrado.');
        return;
      }

      // Encriptamos la contraseña con bcrypt para cumplir con la seguridad del proyecto
      String hashedPassword = BCrypt.hashpw(contrasena, BCrypt.gensalt());

      // Creamos el nuevo registro estructurado en formato JSON
      Map<String, dynamic> nuevoUsuarioJson = {
        "username": usuario,
        "passwordHash": hashedPassword,
      };

      // Guardamos el JSON en la base de datos simulada
      _baseDatosUsuarios.add(nuevoUsuarioJson);

      _mostrarAlerta('Éxito', '¡Registro exitoso! Ahora inicia sesión.');

      // Limpiamos los campos y volvemos automáticamente al modo Login
      setState(() {
        _esRegistro = false;
        _usuarioController.clear();
        _contrasenaController.clear();
        _confirmarController.clear();
      });

    } else {
      // ==========================================
      // LÓGICA DE INICIO DE SESIÓN (LOGIN)
      // ==========================================
      if (usuario.isEmpty || contrasena.isEmpty) {
        _mostrarAlerta('Error', 'Ingresa usuario y contraseña.');
        return;
      }

      Map<String, dynamic>? usuarioEncontrado;
      try {
        usuarioEncontrado = _baseDatosUsuarios.firstWhere(
          (u) => u["username"] == usuario,
        );
      } catch (e) {
        usuarioEncontrado = null;
      }

      bool credencialesValidas = false;
      if (usuarioEncontrado != null) {
        String hashAlmacenado = usuarioEncontrado["passwordHash"];
        try {
          credencialesValidas = BCrypt.checkpw(contrasena, hashAlmacenado);
        } catch (e) {
          credencialesValidas = false;
        }
      }

      if (credencialesValidas) {
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        _mostrarAlerta('Error', 'Usuario o contraseña incorrectos.');
      }
    }
  }

  void _mostrarAlerta(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.security_rounded,
                size: 90,
                color: Colors.cyanAccent,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: 380,
                child: Column(
                  children: [
                    // Campo Usuario
                    Row(
                      children: [
                        const SizedBox(
                          width: 100, 
                          child: Text(
                            'Username:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
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
                              hintText: 'Usuario...',
                              hintStyle: TextStyle(color: Colors.grey),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Campo Contraseña
                    Row(
                      children: [
                        const SizedBox(
                          width: 100, 
                          child: Text(
                            'Password:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _contrasenaController,
                            obscureText: true, 
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
                              hintText: 'Contraseña...',
                              hintStyle: TextStyle(color: Colors.grey),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Campo opcional: Confirmar Contraseña (Solo visible en modo Registro)
                    if (_esRegistro) ...[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text(
                              'Confirmar:',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _confirmarController,
                              obscureText: true,
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
                                hintText: 'Repite contraseña...',
                                hintStyle: TextStyle(color: Colors.grey),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 35),

              // Botón dinámico principal (Entrar / Registrar)
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _procesarAccion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    _esRegistro ? 'Registrar' : 'Entrar', 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botón inferior para cambiar entre el Login y el Registro en la misma interfaz
              TextButton(
                onPressed: () {
                  setState(() {
                    _esRegistro = !_esRegistro;
                  });
                },
                child: Text(
                  _esRegistro 
                    ? '¿Ya tienes cuenta? Inicia sesión' 
                    : '¿No tienes cuenta? Regístrate',
                  style: const TextStyle(color: Colors.cyanAccent, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// =====================================================================
// PANTALLA PRINCIPAL CON MENÚ Y CILINDRO FLOTANTE EN SEGUNDO PLANO
// =====================================================================
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _cylinderController;

  @override
  void initState() {
    super.initState();
    _cylinderController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _cylinderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeDashboardPage(),
      const SeccionPruebasPage(),
      const SegundaPantalla(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Principal'),
        backgroundColor: Colors.cyan,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.cyan),
              child: Text(
                'Menú de Navegación',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Sección de Pruebas (Extras)'),
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Segunda Pantalla'),
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          pages[_currentIndex],
          Positioned(
            top: 15,
            right: 15,
            child: AnimatedBuilder(
              animation: _cylinderController,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateY(_cylinderController.value * 2 * 3.14159),
                  child: Container(
                    width: 70,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.redAccent, Colors.yellowAccent, Colors.greenAccent, Colors.cyanAccent, Colors.purpleAccent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 3))
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Text(
                          "CILINDRO",
                          style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Positioned(
                          top: 4,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                            child: Text(
                              "${(_cylinderController.value * 100).toInt()}",
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Pruebas'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Extra'),
        ],
      ),
    );
  }
}


///principal
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

  // ignore: strict_top_level_inference
  get constraints => null;

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
   } );
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

