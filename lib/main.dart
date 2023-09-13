import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'dart:developer';
import 'package:provider/provider.dart';
import 'package:scaneo_pirerayen/presentation/Screens/principal_page.dart';
import 'package:scaneo_pirerayen/providers/text_manager.dart';
import 'dart:io';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TextManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Scalable OCR',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Consumer<TextManager>(
        builder: (context, textManager, child) =>
            CameraPage(textManager: textManager),
      ),
      routes: {
        'principal': (context) => const PrincipalPage(),
      },
    );
  }
}

class CameraPage extends StatefulWidget {
  final TextManager textManager;
  const CameraPage({Key? key, required this.textManager}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escaneo"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ScalableOCR(
              paintboxCustom: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4.0
                ..color = const Color.fromARGB(153, 102, 160, 241),
              boxLeftOff: 5,
              boxBottomOff: 2.5,
              boxRightOff: 5,
              boxTopOff: 2.5,
              boxHeight: MediaQuery.of(context).size.height / 3,
              getRawData: (value) {
                inspect(value);
              },
              getScannedText: (value) {
                text = value;
              },
            ),
            Text(text),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'principal');
              },
              style:ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 92.0, vertical: 15 ), // Ajusta el padding según tus preferencias
              ),
             ),
              child: Text('Ir a Escaneos',
              style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                _showExitConfirmationDialog(context);
              },
              style:ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 60.0, vertical: 15 ), // Ajusta el padding según tus preferencias
              ),
             ),
              child: Text('Salir de la aplicacion',
              style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 100),

            
            Transform.scale(
              scale: 2,
              child: FloatingActionButton(
                backgroundColor: Colors.indigoAccent,
                onPressed: () {
                  widget.textManager.setText(text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrincipalPage(),
                    ),
                  );
                },
                child: Icon(Icons.camera_alt_sharp)
              ),
            ),
          ],
        ),
      ),
    );
  }
   Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Estás seguro que quieres salir?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salir', style: TextStyle(
                color: Colors.red,
              ),),
              onPressed: () {
                Navigator.of(context).pop();
                _clearCacheAndExitApp();
              },
            ),
          ],
        );
      },
    );
  }

  // Función para borrar el caché y salir de la aplicación
void _clearCacheAndExitApp() {
    // Borra el caché o realiza otras tareas de limpieza si es necesario

    // Cierra la aplicación
    exit(0);
  }
}