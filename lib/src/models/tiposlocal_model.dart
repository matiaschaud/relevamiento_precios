// To parse this JSON data, do
//
//     final tipoLocalModel = tipoLocalModelFromJson(jsonString);

import 'dart:convert';

List<TipoLocalModel> tipoLocalModelFromJson(String str) => List<TipoLocalModel>.from(json.decode(str).map((x) => x == null ? null : TipoLocalModel.fromJson(x)));

String tipoLocalModelToJson(List<TipoLocalModel> data) => json.encode(List<dynamic>.from(data.map((x) => x == null ? null : x.toJson())));

class TipoLocalModel {
    String txltipolocal;
    String id;

    TipoLocalModel({
        this.txltipolocal,
        this.id,
    });

    factory TipoLocalModel.fromJson(Map<String, dynamic> json) => TipoLocalModel(
        txltipolocal: json["txltipolocal"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "txltipolocal": txltipolocal,
        "id": id,
    };
}
