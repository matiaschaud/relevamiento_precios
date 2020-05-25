import 'dart:async';

import 'package:relevamiento_precios/src/providers/usuario_provider.dart';



class Validators {


/* con el <String, String> le estamos diciendo que en el streamtransofrmer entrará un string y saldrá
también un string */
/* esta validación de 6 caracteres podría utilizarse en cualquier lugar de la app! no solo en 
la contraseña de entrada! */
/* IMPORTANTE: el modo de implementación es: esto que hacemos es el stream transformer, luego en el setter
del login_bloc le agregamos el metodo "transform" y le pasamos esta función "validarPassword"  */
  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: ( password, sink ) {

/* La diferencia entre .add y .addError es que cuando enviamos un error, entonces en realidad no se envia
información, sino errores, es decir que cuando utilicemos el snapshot.data no mostrará nada! 
pero si podemos mostrar el error para eso utilizamos snapshot.error*/
      if ( password.length >= 6 ) {
        sink.add( password );
      } else {
        sink.addError('Más de 6 caracteres por favor');
      }

    }
  );



  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: ( email, sink ) async {

  UsuarioProvider _up = new UsuarioProvider();

/* expresión regular que nos comparte fernando para validación de mails */
      Pattern patternTrv = r'.*(@trivento.com).*';
      /* RegExp es una clase para expresiones regulares, se ve muy buena! */
      RegExp regExpTrv   = new RegExp(patternTrv);

/* expresión regular que nos comparte fernando para validación de mails */
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      /* RegExp es una clase para expresiones regulares, se ve muy buena! */
      RegExp regExp   = new RegExp(pattern);

      // bool existeCuenta = await _up.existeCuenta(email);

      if ( regExp.hasMatch( email ) ) {
        if ( regExpTrv.hasMatch( email.toLowerCase() )){
          // if (existeCuenta){
              sink.add( email );
            // } else { 
            //   sink.addError('Email no existe en el dominio de Trivento');
            // }
            } else { 
              sink.addError('El email debe pertenecer Trivento');
            
          } }else {
          sink.addError('Email no es correcto');
          }});
  }