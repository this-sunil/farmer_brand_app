import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:farmer_brand/Bloc/ProductBloc/ProductBloc.dart';
import 'package:farmer_brand/Model/Failure.dart';
import 'package:farmer_brand/Model/Success.dart';
import 'package:either_dart/either.dart';
import 'package:http/http.dart';
abstract class BaseProductRepo{
  Future<Either<Failure,Success>> fetchProduct({required String url,required Map<String,dynamic> body,Map<String,String>? header});
}
class ProductRepo implements BaseProductRepo{
  @override
  Future<Either<Failure, Success>> fetchProduct({required String url, required Map<String, dynamic>? body, Map<String, String>? header}) async{
    // TODO: implement fetchProduct
    try{
      final resp=await post(Uri.parse(url),body: body,headers: header);
      final result=jsonDecode(resp.body);
      log("Product Response=>${resp.body}");
      switch(resp.statusCode){
        case 200:
          return Right(Success(status: ProductStatus.completed,msg: result['msg'],result: result['']));
        case 400:
        case 404:
          return Left(Failure(status: ProductStatus.error,msg: result['msg']));
        case 500:
          return Left(Failure(status: ProductStatus.error,msg: result['msg']));
        default:
          return Left(Failure(status: ProductStatus.error,msg: result['msg']));

      }
    }
    on SocketException catch(e){
      return Left(Failure(status: ProductStatus.error,msg: "Socket Exception"));
    }
    on FormatException catch(e){
      return Left(Failure(status: ProductStatus.error,msg: "Format Exception"));
    }
    on HandshakeException catch(e){
      return Left(Failure(status: ProductStatus.error,msg: "HandShake Exception"));
    }
    on CertificateException catch(e){
      return Left(Failure(status: ProductStatus.error,msg: "Certificate Exception"));
    }
    catch(e,stk){
      log("Fetch Product message=>$stk");
      return Left(Failure(status: ProductStatus.error,msg: "Internal Server Error"));
    }
  }

}