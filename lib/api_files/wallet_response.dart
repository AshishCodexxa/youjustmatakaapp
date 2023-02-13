// To parse this JSON data, do
//
//     final walletResponse = walletResponseFromJson(jsonString);

import 'dart:convert';

WalletResponse walletResponseFromJson(String str) => WalletResponse.fromJson(json.decode(str));

String walletResponseToJson(WalletResponse? data) => json.encode(data!.toJson());

class WalletResponse {
  WalletResponse({
    this.message,
    this.status,
  });

  String? message;
  String? status;

  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}
