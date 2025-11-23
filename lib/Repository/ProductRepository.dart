import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:farmer_brand/Bloc/ProductBloc/ProductBloc.dart';
import 'package:farmer_brand/Bloc/ProductByIdBloc/ProductByIdBloc.dart';
import 'package:farmer_brand/Model/Failure.dart';
import 'package:farmer_brand/Model/ProductByIdModel.dart';
import 'package:farmer_brand/Model/ProductModel.dart';
import 'package:farmer_brand/Model/Success.dart';
import 'package:either_dart/either.dart';
import 'package:http/http.dart';
abstract class BaseProductRepo{
  Future<Either<Failure,Success>> fetchProduct({required String url,required Map<String,dynamic> body,Map<String,String>? header});
  Future<Either<Failure,Success>> productById({required String url,required Map<String,dynamic> body,Map<String,String>? header});
  Future<Either<Failure,Success>> addQtyProduct({required String url,required Map<String,dynamic> body,Map<String,String>? header});
}
class ProductRepo implements BaseProductRepo{

  @override
  Future<Either<Failure, Success>> fetchProduct({required String url, required Map<String, dynamic>? body, Map<String, String>? header}) async{
    // TODO: implement fetchProduct
    try{
      final resp=await post(Uri.parse(url),body: body,headers: header);
      final result=productModelFromJson(resp.body);
      log("Product Response=>${resp.body}");
      switch(resp.statusCode){
        case 200:
          if(result.status==true){
            return Right(Success(status: ProductStatus.completed,msg: result.msg,result: result));
          }
          else{
            return Left(Failure(status: ProductStatus.error,msg: result.msg));
          }

        case 400:
        case 404:
          return Left(Failure(status: ProductStatus.error,msg: result.msg));
        case 500:
          return Left(Failure(status: ProductStatus.error,msg: result.msg));
        default:
          return Left(Failure(status: ProductStatus.error,msg: result.msg));

      }
    }
    on SocketException {
      return Left(Failure(status: ProductStatus.error,msg: "Socket Exception"));
    }
    on FormatException {
      return Left(Failure(status: ProductStatus.error,msg: "Format Exception"));
    }
    on HandshakeException {
      return Left(Failure(status: ProductStatus.error,msg: "HandShake Exception"));
    }
    on CertificateException {
      return Left(Failure(status: ProductStatus.error,msg: "Certificate Exception"));
    }
    catch(e,stk){
      log("Fetch Product message=>$stk");
      return Left(Failure(status: ProductStatus.error,msg: "Internal Server Error"));
    }
  }

  @override
  Future<Either<Failure, Success>> productById({required String url, required Map<String, dynamic> body, Map<String, String>? header}) async{
    // TODO: implement productById
    try{
      final resp=await post(Uri.parse(url),body: body,headers: header);
      final result=productByIdModelFromJson(resp.body);
      log("Product Response=>${resp.body}");
      switch(resp.statusCode){
        case 200:
          if(result.status==true){
            return Right(Success(status: ProductByIdStatus.completed,msg: result.msg,result: result));
          }
          else{
            return Left(Failure(status: ProductStatus.error,msg: result.msg));
          }

        case 400:
        case 404:
          return Left(Failure(status: ProductByIdStatus.error,msg: result.msg));
        case 500:
          return Left(Failure(status: ProductByIdStatus.error,msg: result.msg));
        default:
          return Left(Failure(status: ProductByIdStatus.error,msg: result.msg));

      }
    }
    on SocketException {
      return Left(Failure(status: ProductByIdStatus.error,msg: "Socket Exception"));
    }
    on FormatException {
      return Left(Failure(status: ProductByIdStatus.error,msg: "Format Exception"));
    }
    on HandshakeException {
      return Left(Failure(status: ProductByIdStatus.error,msg: "HandShake Exception"));
    }
    on CertificateException {
      return Left(Failure(status: ProductByIdStatus.error,msg: "Certificate Exception"));
    }
    catch(e,stk){
      log("Fetch Product By Id message=>$stk");
      return Left(Failure(status: ProductByIdStatus.error,msg: "Internal Server Error"));
    }
  }

  @override
  Future<Either<Failure, Success>> addQtyProduct({required String url, required Map<String, dynamic> body, Map<String, String>? header}) async{
    // TODO: implement addQtyProduct
    try{

      final resp=await post(Uri.parse(url),body: jsonEncode(body),headers: header);

      final result=jsonDecode(resp.body);
      log("Add Product Qty Response=>${resp.body}");
      switch(resp.statusCode){
        case 200:
          if(result['status']==true){
            return Right(Success(status: ProductStatus.completed,msg: result['msg']));
          }
          else{
            return Left(Failure(status: ProductStatus.error,msg: result.msg));
          }

        case 400:
        case 404:
        case 500:
          return Left(Failure(status: ProductStatus.error,msg: result['msg']));

        default:
          return Left(Failure(status: ProductStatus.error,msg: result['msg']));

      }
    }
    on SocketException {
      return Left(Failure(status: ProductStatus.error,msg: "Socket Exception"));
    }
    on FormatException {
      return Left(Failure(status: ProductStatus.error,msg: "Format Exception"));
    }
    on HandshakeException {
      return Left(Failure(status: ProductStatus.error,msg: "HandShake Exception"));
    }
    on CertificateException {
      return Left(Failure(status: ProductStatus.error,msg: "Certificate Exception"));
    }
    catch(e,stk){
      log("Add Product message=>$stk");
      return Left(Failure(status: ProductStatus.error,msg: "Internal Server Error"));
    }
  }

}