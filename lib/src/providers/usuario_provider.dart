import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:relevamiento_precios/src/models/cuentasdominiotrv_model.dart';
import 'package:relevamiento_precios/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {

  final String _firebaseToken = 'AIzaSyDembqAWVF6R4nlMYcmTr6R72HOlZdB_kU';
  final _prefs = new PreferenciasUsuario();
  final String _url = 'https://toma-precios.firebaseio.com/';

  FirebaseAuth auth;
  FirebaseUser user;


/*

ESTO ME SERVIRÍA PARA LOGEAR EN UNA APP USANDO SU TOKEN!! 
FINALMENTE LO HICE USANDO FIREBASEAUTH Y FIREBASEUSER

  Future<Map<String, dynamic>> login( String email, String password) async {

    final authData = {
      'email'    : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: json.encode( authData )
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp);

    if ( decodedResp.containsKey('idToken') ) {
      
      _prefs.token = decodedResp['idToken'];


      return { 'ok': true, 'token': decodedResp['idToken'] };
    } else {
      return { 'ok': false, 'mensaje': decodedResp['error']['message'] };
    }

  }


  Future<Map<String, dynamic>> nuevoUsuario( String email, String password ) async {

    final authData = {
      'email'    : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken'
      ,
      body: json.encode( authData )
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp);

    if ( decodedResp.containsKey('idToken') ) {
      
      _prefs.token = decodedResp['idToken'];



      return { 'ok': true, 'token': decodedResp['idToken'] };
    } else {
      return { 'ok': false, 'mensaje': decodedResp['error']['message'] };
    }


  }

  */
  Future<List<CuentasdominiotrvModel>> cargarCuentasTRV() async {

    final url  = '$_url/cuentasdominiotrv.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<CuentasdominiotrvModel> cuentastrv = new List();

/* primero valida que exista información en la bbdd sino devuelve algo vacio */
    if ( decodedData == null ) return [];

    decodedData.forEach( ( id, prod ){
/* la estructura de cuentastrv es:
{"ABC123":{"disponible":true,"precio":100,"titulo":"Tamales"}}
el id: es el ABC123 y prod son el resto de los elementos.
Entonces con fromJson lo convierte en objetos.
COmo es un objeto, asigna a la propiedad de ese objeto id por fuera del fromJson! */
      final cuentastemp = CuentasdominiotrvModel.fromJson(prod);

      cuentastrv.add( cuentastemp );

    });

    return cuentastrv;

  }

  Future<bool> existeCuenta (String cuentaIngresada) async {
    List<CuentasdominiotrvModel> cuentas = await cargarCuentasTRV();
    bool existe = cuentas.any((cuentaPrueba) => cuentaPrueba.cuenta.toLowerCase() == cuentaIngresada.toLowerCase());
     return existe;
  }


}