
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:mime_type/mime_type.dart';
import 'package:relevamiento_precios/src/models/tiposlocal_model.dart';

import 'package:relevamiento_precios/src/models/tomasprecio_model.dart';

/* este es el archivo que se encarga de realizar las interacciones directas con la base de datos
Firebase:
https://firebase.google.com/ (creamos un nuevo proyecto y luego una nueva base de datos)
https://firebase.google.com/docs/reference/rest/database
Firebase no es gratuito! solo puede hacerse pruebas. 
también importa el paquete de http*/

class TomasPrecioProvider {
/* acá hay que colocar la raiz principal de la aplicación, del proyecto en firebase */
  final String _url = 'https://toma-precios.firebaseio.com/';
/* firebase expone su rest API con ese url, por esto podemos hacer peticiones GET, PUT, POST Y DELETE
como en cualquier servicio comun que se hace en los back end en PHP, NODE, DJANGO, ETC  */


/* lo que hacemos acá es insertar un valor en la bbdd de firebase */
  Future<bool> crearProducto( TomasPrecioModel producto ) async {
    /* Se direcciona en el nodo de productos! */
    final url = '$_url/TOMAS_PRECIO.json';
/* esto devuelve un future, antes lo pasa de modelo a json! */
    final resp = await http.post( url, body: tomasPrecioModelToJson(producto) ); 

    final decodedData = json.decode(resp.body);

    print( decodedData );

    return true;

  }

  Future<bool> editarProducto( TomasPrecioModel producto ) async {
    
    final url = '$_url/productos/${ producto.codigoEan }.json';
/* el post reemplaza el elemento, mientras que el put lo reemplaza. */
    final resp = await http.put( url, body: tomasPrecioModelToJson(producto) );

    final decodedData = json.decode(resp.body);

    print( decodedData );

    return true;

  }


/* aca necesitamos extender la ruta hasta productos:
https://flutter-varios-46ee6.firebaseio.com/productos.json */
  Future<List<TomasPrecioModel>> cargarProductos() async {

    final url  = '$_url/productos.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<TomasPrecioModel> productos = new List();

/* primero valida que exista información en la bbdd sino devuelve algo vacio */
    if ( decodedData == null ) return [];

    decodedData.forEach( ( id, prod ){
/* la estructura de productos es:
{"ABC123":{"disponible":true,"precio":100,"titulo":"Tamales"}}
el id: es el ABC123 y prod son el resto de los elementos.
Entonces con fromJson lo convierte en objetos.
COmo es un objeto, asigna a la propiedad de ese objeto id por fuera del fromJson! */
      final prodTemp = TomasPrecioModel.fromJson(prod);
      prodTemp.codigoEan = id;

      productos.add( prodTemp );

    });

    // print( productos[0].id );

    return productos;

  }


  Future<int> borrarProducto( String id ) async { 
/* en la url, le añade el id */
    final url  = '$_url/TOMAS_PRECIO/$id.json';
    final resp = await http.delete(url);
/*  con este print, vemos que devuelve un nulo al borrar un elemento!, Esto puede ser utilizado para
la autenticación, ya que sino devolveria un error */
    print( resp.body ); 

    return 1;
  }


/* Para subir la imagen, se podría realizar directamente en FireBase, pero se necesita realizar ciertas
funciones y crear el back-end. Por lo que directamente utiliza un sistema donde se puede crear más facil.
El mismo es: https://cloudinary.com/console
Luego con postman lo prueba. (video 219) .*/

/* mimeType sirve para identificar que tipo de imagen se ha seleccionado!
Utiliza el paquete: https://pub.dev/packages/mime_type#-readme-tab- */

/* IMPORTANTE: ESTE CODIGO NO SIRVE SOLAMENTE PARA IMAGENES, SIRVE PARA TODO, DEPENDERÁ DE LA CONFIGURACIÓN
DEL BACK END, O END POINT. */
  Future<String> subirImagen( File imagen ) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/drhu6sqaz/image/upload?upload_preset=tkmc2ao6');
    /* El formato en el que resulta despues de aplicar mime es //image/jpeg
    Por esto es que luego le hace un split, de esta forma la primer parte es image y la segunda jpeg en
    este ejemplo */
    final mimeType = mime(imagen.path).split('/'); 

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType( mimeType[0], mimeType[1] )
    );
/* con esta instrucción subimos el archivo  */
    imageUploadRequest.files.add(file);

/* acá obtenemos la respuesta de lo que subimos */
    final streamResponse = await imageUploadRequest.send();
/* esta respuesta es la misma que veniamos trabajando como "resp" con los otros métodos arriba */
    final resp = await http.Response.fromStream(streamResponse);
/* codigo 200 y 201 son las que nos indican que la respuesta salio ok! */
    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('Algo salio mal');
      print( resp.body ); // esto seria la respuesta del error
      return null;
    }

/* lo siguiente será extraer el url de la respuesta!!, y esta URL tengo que meterla en los registros
de firebase */
    final respData = json.decode(resp.body);
    print( respData);

    return respData['secure_url'];


  }



/* directamente con FireStore en cloud---------------------------------*/


final Firestore firestore = Firestore.instance;

void addRegistroPrecio (TomasPrecioModel precio) {
  
  firestore.collection("registro_precios").add(precio.toJson()).whenComplete((){
  }).catchError((e) => print(e));

}



void updateValidadoRegistroPrecio (String idDocumento,{bool validado = true} ) {
  
  firestore.collection("registro_precios").document(idDocumento).updateData(<String,dynamic> {"VALIDADO": validado,"FECHA_MODIFICACION": DateTime.now().toIso8601String() }).whenComplete((){
  }).catchError((e) => print(e));

}


/*--------------- Tipos de locales -------------------------*/

  Future<List<TipoLocalModel>> cargarTiposLocales() async {

    final url  = '$_url/d_tipolocal.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<TipoLocalModel> tipoLocalList = new List();

/* primero valida que exista información en la bbdd sino devuelve algo vacio */
    if ( decodedData == null ) return [];

    decodedData.forEach( ( id, prod ){
/* la estructura de tipoLocal es:
{"ABC123":{"disponible":true,"precio":100,"titulo":"Tamales"}}
el id: es el ABC123 y prod son el resto de los elementos.
Entonces con fromJson lo convierte en objetos.
COmo es un objeto, asigna a la propiedad de ese objeto id por fuera del fromJson! */
      final tipoLocalTemp = TipoLocalModel.fromJson(prod);
      tipoLocalTemp.id = id;

      tipoLocalList.add( tipoLocalTemp );

    });

    // print( productos[0].id );
    tipoLocalList.sort((a,b) => a.txltipolocal.compareTo(b.txltipolocal) );
    return tipoLocalList;

  }

}

