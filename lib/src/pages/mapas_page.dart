import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relevamiento_precios/src/models/tomasprecio_model.dart';
import 'package:relevamiento_precios/src/providers/tomasprecio_provider.dart';

class MapasPage extends StatelessWidget {
  
  TomasPrecioProvider tpp = new TomasPrecioProvider();
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Center(child: 
     // RaisedButton(onPressed: tpp.updateRegistroPrecio,),
      Text('Proximamente...')
      ),
    );
  }
}