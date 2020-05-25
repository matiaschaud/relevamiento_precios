
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relevamiento_precios/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:relevamiento_precios/src/utils/auth.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  // Dependencies

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final prefs = new PreferenciasUsuario();

  // Shared State for Widgets
  FirebaseUser user; // firebase user

  
  Future<Map<String,String>> crearCuenta (String email, String password) async {

    try {
        await _auth.createUserWithEmailAndPassword(email: email ,password: password);
        await _auth.signInWithEmailAndPassword(email: email ,password: password);
        FirebaseUser user = await _auth.currentUser();
        await user.sendEmailVerification();
        
      if (user.email == null){
           return { 'Error': 'NO_CREADO', 'Message': 'Correo aún no existe'};
         } else {
           return { 'Error': 'OK', 'Message': 'Creación exitosa de cuenta'};
         }
    } catch (e) {
      return { 'Error': e.code, 'Message': e.message};
    }
        
         
  }

  Future<Map<String,String>> logear (String email, String password) async {

    try {
      await _auth.signInWithEmailAndPassword(email: email,password: password);
      FirebaseUser user = await _auth.currentUser();
      if (!user.isEmailVerified){
           return { 'Error': 'NO_VERIFICADO', 'Message': 'Correo electrónico no verificado'};
         } else {
           almacenainfo();
           return { 'Error': 'OK', 'Message': 'Ingreso exitoso'};
         }
    } catch (e) {
      return { 'Error': e.code, 'Message': e.message};
    }
  }

  Future<Map<String,String>> reestablecerPsw (String email) async {

    try {
      _auth.sendPasswordResetEmail(email: email);
      return { 'Error': 'OK', 'Message': 'Ingreso exitoso'};
    } catch (e) {
      return { 'Error': e.code, 'Message': e.message};
    }
         
  }

  void almacenainfo () async {
    FirebaseUser actualUser = await _auth.currentUser();
    IdTokenResult token = await actualUser.getIdToken();
    // print(token.token);
    // print(token.authTime);
    // print(token.expirationTime);
    // print(token.signInProvider);
    // print(token.claims);
    // print(token.hashCode);
    prefs.mail_login = actualUser.email;
    prefs.token = token.token;
    prefs.uid = actualUser.uid;
  }

  void signOut() {
    _auth.signOut();
    prefs.mail_login();
    prefs.ultimaPagina();
    prefs.token();
    prefs.uid();
  }
}