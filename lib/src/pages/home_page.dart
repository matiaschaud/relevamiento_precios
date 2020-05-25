import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:relevamiento_precios/src/models/tiposlocal_model.dart';
import 'package:relevamiento_precios/src/models/tomasprecio_model.dart';
import 'package:relevamiento_precios/src/pages/mapas_page.dart';
import 'package:relevamiento_precios/src/pages/resumen_page.dart';
import 'package:relevamiento_precios/src/pages/tomas_precio_page.dart';
import 'package:relevamiento_precios/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:relevamiento_precios/src/providers/tomasprecio_provider.dart';
import 'package:relevamiento_precios/src/providers/usuario_provider.dart';
import 'package:relevamiento_precios/src/providers/authentication_provider.dart';
import 'package:relevamiento_precios/src/utils/utils.dart';


class HomePage extends StatefulWidget {
  String modo = 'solo';
  
  HomePage({Key key, @required this.modo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  
  String result = 'Code!';
  Position _coordenada;
  String latitud = '0.00';
  String longitud = '0.00';

  final tomasPrecioProvider = new TomasPrecioProvider();
  TomasPrecioModel tomaPrecio = new TomasPrecioModel();
  AuthService _auth = new AuthService();
  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
      prefs.ultimaPagina = 'home';

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            
        ],
        title: Text('TRIVENTO'),centerTitle: true,),
        
        drawer: _crearMenu(),
        body: Column(
          children: <Widget>[
            Container(padding: EdgeInsets.symmetric(horizontal: 45.0),
              child: Row(children: <Widget>[
             _crearDropDown(),Text(": " + prefs.txlTipoLocalSeleccionado)] ),
             margin: EdgeInsets.symmetric(horizontal: 0.0),
             decoration: BoxDecoration(border: Border.all(width: 3.0,color: Colors.blueGrey),borderRadius: BorderRadius.circular(5),
              ),
             ),

                  Expanded(
          child: SizedBox(
            height: 200.0,
            child: _callPage(currentIndex)))]),       
            bottomNavigationBar: _crearBottomNavigationBar(),
            floatingActionButton: FloatingActionButton(
            child: Icon(Icons.scanner),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 10.0,
            onPressed: _scanBarcode ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
  }

Drawer _crearMenu () {
    return Drawer(
      /* Lo tradicional para rellenar un menú es un listview, el cual además tiene scroll! */
      child: ListView(
        /* El padding zero, hace que arranque desde bien arriba la imagen y no deje nada blanco */
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logotrv.png'),
                fit: BoxFit.cover
              )
            ),
          ),
/* Usa un listTile para rellenar un elemento del menú */
          ListTile(
            leading: Icon( Icons.pages, color: Colors.blue ),
            title: Text('Inicio'),
            onTap: ()=> Navigator.pushReplacementNamed(context, 'home' ) ,
          ),

          ListTile(
            leading: Icon( Icons.person, color: Colors.blue ),
            title: Text('Solo tomados por mi'),
            onTap: (){
              setState(() {
                prefs.modo = 'solo';  
              });
              
            },
          ),

          ListTile(
            leading: Icon( Icons.people, color: Colors.blue ),
            title: Text('Por todos'),
            onTap: (){
              setState(() {
                prefs.modo = 'todos';
              });
            },
          ),
/*
          ListTile(
            leading: Icon( Icons.settings, color: Colors.blue ),
            title: Text('Configuración'),
            onTap: (){
              /** el Navigator.pop lo que hace es cerrar el menú, entonces cuando vuelvo, el menú estaría
               * cerrado
               */
              // Navigator.pop(context);
              /* con el pushreplacementnamed, no coloca un icono de menú. Con el pushnamed sale un icono
              de volver. Esto es util cuando pasamos un login y no es necesario que la persona vuelva a la
              pagina anterior. sino se utiliza el pushnamed solamente. */
              Navigator.pushReplacementNamed(context, 'login'  );
            }
          ),
*/          
          ListTile(
            leading: Icon( Icons.exit_to_app, color: Colors.blue ),
            title: Text('Salir'),
            onTap: (){ _salirApp(); },
          ),


        ],
      ),
    );
  }

void _salirApp () {
  Navigator.of(context).pushReplacementNamed('login');
  _auth.signOut();
}


  Future _scanBarcode() async {
    try {
    Map<String,String> rtaCoordenadas = await _obtieneCoordenadas();
    
    if (rtaCoordenadas['Error'] == 'NoGPS') {
      mostrarAlerta(context, 'Por favor enciende el GPS');
      throw('GPS no activado');
    } else {
      
    if (prefs.txlTipoLocalSeleccionado == 'Todos') {
      mostrarAlerta(context, 'Seleccione tipo de local válido.');
      throw('Tipo de local no válido');}
      
    String bcResult = await BarcodeScanner.scan();
      Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
      bool geolocationPermission = await geolocator.isLocationServiceEnabled();
    if (geolocationPermission) {
      tomaPrecio.mail = prefs.mail_login;
      tomaPrecio.fecha = DateTime.now().toIso8601String();
      tomaPrecio.lat = rtaCoordenadas['Latitud'];
      tomaPrecio.long = rtaCoordenadas['Longitud'];
      tomaPrecio.codigoEan = bcResult;
      tomaPrecio.precio = await _dialogPrecio(context);
      tomaPrecio.validado = true;
      tomaPrecio.idtipoLocalSeleccionado = prefs.idTipoLocalSeleccionado;
      tomaPrecio.txltipoLocalSeleccionado = prefs.txlTipoLocalSeleccionado;
      try {
        double.parse(tomaPrecio.precio);
        tomasPrecioProvider.addRegistroPrecio(tomaPrecio);
      } catch (err) {
        mostrarAlerta(context, '¡Introduce un número correcto!');
      }
      
} else {
        mostrarAlerta(context, 'Por favor enciende el GPS');
        throw("GPS no activado");
      }
    }

  } on PlatformException catch (e) {

    if (e.code == BarcodeScanner.CameraAccessDenied){
      
      setState(() {
        result="Camera permission was denied";
      });
    } else {
      setState(() {
        result="Unkown error $e";
      });
    }
  } on FormatException {
    setState(() {
      result = "You pressed the back buttom before scanning anything.";
    });
  } catch (e) {
      setState(() {
        result="Unkown error: $e";
      });
  }
    }
    
  Future<Map<String,String>> _obtieneCoordenadas () async {
  
  Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
  // GeolocationStatus geolocationStatus  = await geolocator.checkGeolocationPermissionStatus();
  bool geolocationPermission = await geolocator.isLocationServiceEnabled();


    if (geolocationPermission) {
    Position _coordenadas = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  
      _coordenada = _coordenadas;
      
      return { 'Error': "Ok", 'Latitud' : _coordenada.latitude.toString(), 'Longitud' : _coordenada.longitude.toString()};
    
  } else
  {        
      return { 'Error': "NoGPS", 'Latitud' : null, 'Longitud' : null};
  }
  }  


Future<String> _dialogPrecio (BuildContext context){
  TextEditingController customController = new TextEditingController();

  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Text('Por favor inserta el precio a registrar (separador decimal punto)'),
      content: TextField(
        controller: customController,
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: Text('¡Registrar precio!'),
          onPressed: (){
            Navigator.of(context).pop(customController.text.toString());
          },
        )
      ],
    );
  });
}

  Widget _crearBottomNavigationBar() {

    return BottomNavigationBar(
      /* el currentindex le dice al bottomnavigationbar que elemento está activo. Es decir en 
      cual se hizo clic*/
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon( Icons.map ),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.add_shopping_cart),
          title: Text('Tomas de precio')
        ),
      ],
    );


  }

    Widget _callPage( int paginaActual ) {
/* el callPage se hace para controlar a qué pagina se dirigirá cuando se haga clic en los 
items del bottomnavigationbar. Página actual es el currentIndex del bottomnavigationbar, cambia la
página activa! */
    switch( paginaActual ) {

      case 0: return ResumenPage();
      case 1: return TomasPrecioPage(modo: prefs.modo);

      default:
        return MapasPage();
    }

  }

  Future<List<DropdownMenuItem<Map>>> getListaTipoLocales() async {
    List<DropdownMenuItem<Map>> listaTipoLocales = new List(); //como no especifico el tamaño de la lista, esdinamica.
    List<TipoLocalModel> listaLocales = new List();
    listaLocales = await tomaPrecioProvider.cargarTiposLocales();
    listaLocales.forEach((local){
      listaTipoLocales.add(DropdownMenuItem(
        child: Text(local.txltipolocal),
        value: { "id" : local.id, "valor" : local.txltipolocal}));
    });

    return listaTipoLocales;
  }

 
  _crearDropDown(){
    return FutureBuilder(
      future: getListaTipoLocales(),
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return DropdownButton(hint: Text('Tipo de local: '),
        
        items: snapshot.data, 
        onChanged: (opt) {
          setState(() {
            prefs.idTipoLocalSeleccionado = opt["id"];
            prefs.txlTipoLocalSeleccionado = opt["valor"];
          });
        },);
      },
    );
  }
  }
            
