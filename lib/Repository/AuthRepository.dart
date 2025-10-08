import 'dart:convert';
import 'dart:io';
import 'package:farmer_brand/Bloc/AuthBloc/AuthBloc.dart';
import 'package:farmer_brand/Model/Failure.dart';
import 'package:farmer_brand/Model/AuthModel.dart';
import 'package:farmer_brand/Model/Success.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

abstract class BaseAuthRepository{
  Future<Either<Failure,Success>> loginRepo({required String url,required Map<String,String>? header,required Map<String,dynamic> body});
  Future<Either<Failure,Success>> registerRepo({required String url,required Map<String,String>? header,required Map<String,dynamic> body});
}

class AuthRepository extends BaseAuthRepository{

  @override
  Future<Either<Failure, Success>> loginRepo({required String url,  Map<String, String>? header,  Map<String, dynamic>? body}) async {
    // TODO: implement loginRepo
    try {

      final resp = await post(Uri.parse(url), body: jsonEncode(body), headers: header);
      if (kDebugMode) {
        print("Url=>$url body=>${resp.body}");
      }
      final result = await jsonDecode(resp.body);
      switch (resp.statusCode) {
        case 200:
          if (result["status"]) {
            final results=authModelFromJson(resp.body);
            return Right(Success(result: results,
                msg: results.msg,
                status:AuthStatus.login));
          }
          else {
            return Left(Failure(msg: result["msg"], status: AuthStatus.error));
          }
        case 404:
          return Left(Failure(msg: result["msg"], status: AuthStatus.error));
        default:
          return Left(Failure(msg: result["msg"], status: AuthStatus.error));
      }
    }
    on HandshakeException {
      return Left(Failure(msg: "Please try again later", status: AuthStatus.error));
    }
    on SocketException {
      return Left(Failure(msg: "Socket Exception", status: AuthStatus.error));
    }
    on FormatException {
      return Left(Failure(msg: "Invalid Json Format", status: AuthStatus.error));
    }
    catch(e,stk){
      return Left(Failure(msg: "Internal Server Error =>$stk", status: AuthStatus.error));
    }
  }

  @override
  Future<Either<Failure, Success>> registerRepo({required String url, required Map<String, String>? header, required Map<String, dynamic> body}) async{
    // TODO: implement registerRepo
    try {

      final resp = await post(Uri.parse(url), body: jsonEncode(body), headers: header);
      if (kDebugMode) {
        print("Url=>$url body=>${resp.body}");
      }
      final result = await jsonDecode(resp.body);
      switch (resp.statusCode) {
        case 200:
          if (result["status"]) {
            final results=authModelFromJson(resp.body);
            return Right(Success(result: results,
                msg: results.msg,
                status:AuthStatus.login));
          }
          else {
            return Left(Failure(msg: result["msg"], status: AuthStatus.error));
          }
        case 404:
          return Left(Failure(msg: result["msg"], status: AuthStatus.error));
        default:
          return Left(Failure(msg: result["msg"], status: AuthStatus.error));
      }
    }
    on HandshakeException {
      return Left(Failure(msg: "Please try again later", status: AuthStatus.error));
    }
    on SocketException {
      return Left(Failure(msg: "Socket Exception", status: AuthStatus.error));
    }
    on FormatException {
      return Left(Failure(msg: "Invalid Json Format", status: AuthStatus.error));
    }
    catch(e,stk){
      return Left(Failure(msg: "Internal Server Error =>$stk", status: AuthStatus.error));
    }
  }

}