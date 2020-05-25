import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:

  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    prefs.initPrefs();

*/

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET de la última página
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs.setString('token', value);
  }
  

  get mail_login {
    return _prefs.getString('mail_login') ?? '';
  }

  set mail_login( String value ) {
    _prefs.setString('mail_login', value);
  }

 get uid {
    return _prefs.getString('uid') ?? '';
  }

  set uid( String value ) {
    _prefs.setString('uid', value);
  }

  // GET y SET de la última página
  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina( String value ) {
    _prefs.setString('ultimaPagina', value);
  }

  get modo {
    return _prefs.getString('modo') ?? '';
  }

  set modo( String value ) {
    _prefs.setString('modo', value);
  }


  get txlTipoLocalSeleccionado {
    return _prefs.getString('txlTipoLocalSeleccionado') ?? 'Todos';
  }

  set txlTipoLocalSeleccionado( String value ) {
    _prefs.setString('txlTipoLocalSeleccionado', value);
  }

    get idTipoLocalSeleccionado {
    return _prefs.getString('idTipoLocalSeleccionado') ?? 'O';
  }

  set idTipoLocalSeleccionado( String value ) {
    _prefs.setString('idTipoLocalSeleccionado', value);
  }

}

