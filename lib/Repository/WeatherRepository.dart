import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:farmer_brand/Model/Failure.dart';
import 'package:either_dart/either.dart';
import 'package:farmer_brand/Model/WeatherModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../Bloc/WeatherBloc/WeatherBloc.dart';
import '../Model/Success.dart';
import "package:http/http.dart";

abstract class BaseWeatherRepository{
  Future<Either<Failure,Success>> weatherApi({required String url, required Map<String, dynamic> body, Map<String, String>? header});
}

class WeatherRepository extends BaseWeatherRepository{
  @override
  Future<Either<Failure, Success>> weatherApi({required String url, required Map<String, dynamic> body, Map<String, String>? header}) async{
    // TODO: implement weatherApi
    try {
      String lat=body["lat"];
      String long=body["long"];
      String? appId=dotenv.env["WEATHER_API_KEY"];
      final resp = await get(Uri.parse("$url?lat=$lat&lon=$long&appid=$appId"));
      final result = jsonDecode(resp.body);
      switch (resp.statusCode) {
        case 200:
          final results = weatherModelFromJson(resp.body);
          return Right(Success(status: WeatherStatus.completed,
              msg: "Fetch Data Successfully",
              result: results));
        case 404:
          return Left(Failure(msg: result["msg"], status: WeatherStatus.error));
        case 400:
          return Left(Failure(
              msg: result["msg"], status: WeatherStatus.error));
        default:
          return Left(Failure(msg: result["msg"], status: WeatherStatus.error));
      }
    }
    on HandshakeException {
      return Left(Failure(msg: "Please try again later", status: WeatherStatus.error));
    }
    on SocketException {
      return Left(Failure(msg: "Socket Exception", status: WeatherStatus.error));
    }
    on FormatException {
      return Left(Failure(msg: "Invalid Json Format", status: WeatherStatus.error));
    }
    catch(e){
      log("message=>$e");
      return Left(Failure(status: WeatherStatus.error,msg: "Internal Server Error"));
    }
  }
}