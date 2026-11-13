import 'package:flutter/material.dart';
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

// =====================================================================
// PANTALLA DE LOGIN Y REGISTRO EN FORMATO JSON
// =====================================================================
class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmarController = TextEditingController();

  bool _esRegistro = false;

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
      String confirmar = _confirmarController.text;

      if (usuario.isEmpty || contrasena.isEmpty || confirmar.isEmpty) {
        _mostrarAlerta('Error', 'Por favor llena todos los campos.');
        return;
      }

      if (contrasena != confirmar) {
        _mostrarAlerta('Error', 'Las contraseñas no coinciden.');
        return;
      }

      bool existe = _baseDatosUsuarios.any((u) => u["username"] == usuario);
      if (existe) {
        _mostrarAlerta('Error', 'El usuario ya está registrado.');
        return;
      }

      String hashedPassword = BCrypt.hashpw(contrasena, BCrypt.gensalt());

      Map<String, dynamic> nuevoUsuarioJson = {
        "username": usuario,
        "passwordHash": hashedPassword,
      };

      _baseDatosUsuarios.add(nuevoUsuarioJson);
      _mostrarAlerta('Éxito', '¡Registro exitoso! Ahora inicia sesión.');

      setState(() {
        _esRegistro = false;
        _usuarioController.clear();
        _contrasenaController.clear();
        _confirmarController.clear();
      });
    } else {
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
// PANTALLA PRINCIPAL (GESTIONA EL MENÚ Y LA ANIMACIÓN GLOBAL MUY LENTA)
// =====================================================================
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _circleController;

  @override
  void initState() {
    super.initState();
    // Duración de 150 segundos para que sea MUY LENTO y llegue hasta 1000 gradualmente
    _circleController = AnimationController(
      duration: const Duration(seconds: 150),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeDashboardPage(circleController: _circleController),
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
              title: const Text('Inicio (Círculo Giratorio)'),
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Sección de Pruebas'),
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Segunda Página'),
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Pruebas'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Segunda Pág'),
        ],
      ),
    );
  }
}

// =====================================================================
// PÁGINA DE INICIO (CÍRCULO CENTRAL CON IMAGEN Y CONTADOR HASTA 1000)
// =====================================================================
class HomeDashboardPage extends StatelessWidget {
  final AnimationController circleController;

  const HomeDashboardPage({super.key, required this.circleController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 80, 217, 241),
      body: Stack(
        children: [
          // CÍRCULO PERFECTO EN EL MEDIO QUE GIRA LENTAMENTE CON LA IMAGEN ADENTRO
          Center(
            child: AnimatedBuilder(
              animation: circleController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: circleController.value * 2 * 3.14159, // Rotación lenta continua
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'asset/images/31a72afda250825d993400c3ef28c55c.gif',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.white,
                          child: const Center(
                            child: Text(
                              "Sin Imagen",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // CONTADOR GRANDE EN LA ESQUINA (HASTA 1000, LENTO Y PERSISTENTE)
          Positioned(
            top: 25,
            right: 25,
            child: AnimatedBuilder(
              animation: circleController,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.cyanAccent, width: 2),
                  ),
                  child: Text(
                    "Contador: ${(circleController.value * 1000).toInt()}",
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// SECCIÓN DE PRUEBAS
// =====================================================================
class SeccionPruebasPage extends StatefulWidget {
  const SeccionPruebasPage({super.key});

  @override
  State<SeccionPruebasPage> createState() => _SeccionPruebasPageState();
}

class _SeccionPruebasPageState extends State<SeccionPruebasPage> {
  String mensaje = "Dale";
  List<String> mensajes = [
    "Por pendejos",
    "Porque no vale nada",
    "Por no entender nada",
    "Por flojear",
  ];
  int indice = 0;
  bool modoCupertinoLocal = false;

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(mensaje),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 80, 217, 241),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ya Estuvo',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 15),
              Image.asset(
                'asset/images/31a72afda250825d993400c3ef28c55c.gif',
                width: 200,
                height: 200,
                errorBuilder: (context, error, stackTrace) => const Text("GIF no encontrado (verifica assets)"),
              ),
              const SizedBox(height: 10),
              Switch(
                value: modoCupertinoLocal,
                onChanged: (val) => setState(() => modoCupertinoLocal = val),
              ),
              Text(
                modoCupertinoLocal ? 'Modo iPhone (Cupertino)' : 'Interfaz estilo Android',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 15),
              Stack(
                alignment: Alignment.center,
                children: const [
                  Text(
                    'Hola',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    'Adios',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Vamonos a China Nuevo León',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 15),
              Container(
                width: 300,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  mensaje,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => mostrarAlerta(context),
                child: const Text('Prueba', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// SEGUNDA PÁGINA SECUNDARIA
// =====================================================================
class SegundaPantalla extends StatelessWidget {
  const SegundaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 80, 217, 241),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡JA FUNCIONO!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

