import 'package:flutter/material.dart';
import 'package:relevamiento_precios/src/bloc/provider.dart';


import 'package:relevamiento_precios/src/pages/home_page.dart';
import 'package:relevamiento_precios/src/pages/login_page.dart';
import 'package:relevamiento_precios/src/pages/reestablecerpsw_page.dart';
import 'package:relevamiento_precios/src/pages/registro_page.dart';
import 'package:relevamiento_precios/src/pages/tomas_precio_page.dart';
import 'package:relevamiento_precios/src/preferencias_usuario/preferencias_usuario.dart';
 
void main() async {  
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
 }
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      final prefs = new PreferenciasUsuario();
      return Provider (
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: prefs.ultimaPagina,
        routes: {
          'login'    : ( BuildContext context ) => LoginPage(),
          'registro' : ( BuildContext context ) => RegistroPage(),
          'home'     : ( BuildContext context ) => HomePage(modo:'solo'),
          'reestablecer_psw' : ( BuildContext context ) => ReestablecerPswPage(),
          'tomaPrecios'     : (BuildContext context) => TomasPrecioPage(modo:'solo'),
        //  'producto' : ( BuildContext context ) => ProductoPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.blueAccent,
        ),
      ),
    );
  }
}