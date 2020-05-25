import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relevamiento_precios/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:relevamiento_precios/src/providers/tomasprecio_provider.dart';

final prefs = new PreferenciasUsuario();
final tomaPrecioProvider = new TomasPrecioProvider();



class TomasPrecioPage extends StatelessWidget {

String modo = 'solo';
  TomasPrecioPage({Key key, @required this.modo}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: _identificaModo(modo),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return 
            new ListView.builder(
              itemCount: snapshot.data.documents.length,
              //: getExpenseItems(snapshot), 
            itemBuilder: (BuildContext context, int i) => Dismissible(
            key: UniqueKey(),
            background: Container( color: Colors.red),
            onDismissed: ( direction ) {
              if (modo == 'solo'){
              if (direction == DismissDirection.endToStart) {
              tomaPrecioProvider.updateValidadoRegistroPrecio(snapshot.data.documents[i].documentID,validado: true);}
              else {
                tomaPrecioProvider.updateValidadoRegistroPrecio(snapshot.data.documents[i].documentID,validado: false);
              }} else 
              {final snackBar = SnackBar(content: Text("""No se ha generado ninguna acción. La misma no está disponible en vista todos."""));
              Scaffold.of(context).showSnackBar(snackBar);}},
            secondaryBackground: Container(color: Colors.green),
            
            child: ListTile(
             // leading: Icon( Icons.cloud_queue, color: Theme.of(context).primaryColor ),
              title: Text("EAN: " + snapshot.data.documents[i].data["CODIGO_EAN"]
              + " / PX: " + snapshot.data.documents[i].data["PRECIO"].toString(),textAlign: TextAlign.center,),
              subtitle: Column(children: <Widget>[
                Text("FECHA: " + snapshot.data.documents[i].data["FECHA"].substring(0,10)),
                Text("MAIL: " + snapshot.data.documents[i].data["MAIL"]),
                Text("LAT: " + snapshot.data.documents[i].data["LAT"].substring(0,7)
                 + " / LONG: " + snapshot.data.documents[i].data["LONG"].substring(0,7)),
                Text("TIPO DE LOCAL: " + snapshot.data.documents[i].data["TXLTIPOLOCALSELECCIONADO"])
              ]),trailing: _identificaValidado(snapshot.data.documents[i].data["VALIDADO"]) 
             // onTap: () => utils.abrirScan(context, scans[i]),
            )
          )          
        );
        });
  }

  Stream _identificaModo (String modo) {
    if (modo == 'solo') {
      if (prefs.idTipoLocalSeleccionado == "O"){
      return Firestore.instance.collection("registro_precios").where("MAIL", isEqualTo: prefs.mail_login).snapshots();
    } else {
      return Firestore.instance.collection("registro_precios").where("MAIL", isEqualTo: prefs.mail_login).where("IDTIPOLOCALSELECCIONADO", isEqualTo: prefs.idTipoLocalSeleccionado).snapshots();
    }
    
    } else {
            if (prefs.idTipoLocalSeleccionado == "O"){
      return Firestore.instance.collection("registro_precios").snapshots();
            } else {
      return Firestore.instance.collection("registro_precios").where("IDTIPOLOCALSELECCIONADO", isEqualTo: prefs.idTipoLocalSeleccionado).snapshots();
    }
  }
  }

  Widget _identificaValidado (bool snapshotValido){
    if (snapshotValido==true) 
              {return Icon( Icons.check, color: Colors.green );}
              else {return Icon(Icons.error, color: Colors.red);}
  }



// Encuentra el Scaffold en el árbol de widgets y ¡úsalo para mostrar un SnackBar!


}