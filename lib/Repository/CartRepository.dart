import 'dart:developer';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:farmer_brand/Bloc/CartBloc/CartBloc.dart';
import 'package:farmer_brand/Model/CartModel.dart';
import 'package:farmer_brand/Model/Failure.dart';
import 'package:farmer_brand/Model/Success.dart';
import 'package:http/http.dart';

abstract class BaseCartRepo{
  Future<Either<Failure,Success>> fetchCart({required String url,required Map<String,dynamic> body,Map<String,String>? headers});
}
class CartRepository implements BaseCartRepo{
  @override
  Future<Either<Failure, Success>> fetchCart({required String url, required Map<String, dynamic> body, Map<String, String>? headers}) async{
    // TODO: implement fetchCart
    try{
      final resp=await post(Uri.parse(url),headers: headers,body: body);
      log("Cart Response=>${resp.body}");
      final result=cartModelFromJson(resp.body);
      switch(resp.statusCode){
        case 200:
          if(result.status==true){
            return Right(Success(status: CartStatus.completed,msg: result.msg,result: result));
          }
          else{
            return Left(Failure(status: CartStatus.error,msg: result.msg));
          }

        case 400:
        case 404:
        case 500:
        return Left(Failure(status: CartStatus.error,msg: result.msg));
        default:
          return Left(Failure(status: CartStatus.error,msg: result.msg));
      }
    }
    on SocketException catch(e){
      log("Socket Exception ${e.message}");
      return Left(Failure(status: CartStatus.error,msg: "Socket Exception"));
    }
    on FormatException catch(e){
      log("Format Exception ${e.message}");
      return Left(Failure(status: CartStatus.error,msg: "Invalid Format json"));
    }
    on CertificateException catch(e){
      log("Certificate Exception ${e.message}");
      return Left(Failure(status: CartStatus.error,msg:"Certificate Exception"));
    }
    catch(e){
      return Left(Failure(status: CartStatus.error,msg: "Internal Server Error"));
    }
  }

}