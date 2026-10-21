import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MainApp());
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