// To parse this JSON data, do
//
//     final cuentasdominiotrvModel = cuentasdominiotrvModelFromJson(jsonString);

import 'dart:convert';

Map<String, CuentasdominiotrvModel> cuentasdominiotrvModelFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, CuentasdominiotrvModel>(k, CuentasdominiotrvModel.fromJson(v)));

String cuentasdominiotrvModelToJson(Map<String, CuentasdominiotrvModel> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class CuentasdominiotrvModel {
    String cuenta;
    bool estado;

    CuentasdominiotrvModel({
        this.cuenta,
        this.estado,
    });

    factory CuentasdominiotrvModel.fromJson(Map<String, dynamic> json) => CuentasdominiotrvModel(
        cuenta: json["cuenta"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "cuenta": cuenta,
        "estado": estado,
    };
}
