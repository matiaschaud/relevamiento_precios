// To parse this JSON data, do
//
//     final tomasPrecio = tomasPrecioFromJson(jsonString);

import 'dart:convert';

TomasPrecioModel tomasPrecioModelFromJson(String str) => TomasPrecioModel.fromJson(json.decode(str));

String tomasPrecioModelToJson(TomasPrecioModel data) => json.encode(data.toJson());


class TomasPrecioModel {
    String codigoEan;
    String fecha;
    String lat;
    String long;
    String mail;
    String nombre;
    String precio;
    bool   validado;
    String fechaModificacion;
    String idtipoLocalSeleccionado;
    String txltipoLocalSeleccionado;

    TomasPrecioModel({
        this.codigoEan,
        this.fecha,
        this.lat,
        this.long,
        this.mail,
        this.nombre,
        this.precio,
        this.validado,
        this.fechaModificacion,
        this.idtipoLocalSeleccionado,
        this.txltipoLocalSeleccionado,
    });

    factory TomasPrecioModel.fromJson(Map<String, dynamic> json) => TomasPrecioModel(
        codigoEan: json["CODIGO_EAN"],
        fecha: json["FECHA"],
        lat: json["LAT"],
        long: json["LONG"],
        mail: json["MAIL"],
        nombre: json["NOMBRE"],
        precio: json["PRECIO"],
        validado: json["VALIDADO"],
        fechaModificacion: json["FECHA_MODIFICACION"],
        idtipoLocalSeleccionado: json["IDTIPOLOCALSELECCIONADO"],
        txltipoLocalSeleccionado: json["TXLTIPOLOCALSELECCIONADO"],
    );

    Map<String, dynamic> toJson() => {
        "CODIGO_EAN": codigoEan,
        "FECHA": fecha,
        "LAT": lat,
        "LONG": long,
        "MAIL": mail,
        "NOMBRE": nombre,
        "PRECIO": precio,
        "VALIDADO": validado,
        "FECHA_MODIFICACION": fechaModificacion,
        "IDTIPOLOCALSELECCIONADO": idtipoLocalSeleccionado,
        "TXLTIPOLOCALSELECCIONADO": txltipoLocalSeleccionado,
    };
}
