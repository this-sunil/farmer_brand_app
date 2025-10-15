import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:farmer_brand/Bloc/BannerBloc/BannerBloc.dart';
import 'package:farmer_brand/Model/BannerModel.dart';
import 'package:farmer_brand/Model/Failure.dart';
import 'package:farmer_brand/Model/Success.dart';
import 'package:http/http.dart';

abstract class BaseBannerRepo{
  Future<Either<Failure,Success>> fetchBanner({required String url,Map<String,dynamic>? body,Map<String,String>? header});
}

class BannerRepository extends BaseBannerRepo{
  @override
  Future<Either<Failure, Success>> fetchBanner({required String url, Map<String, dynamic>? body, Map<String, String>? header}) async{
    // TODO: implement fetchBanner
    try{
      final resp=await post(Uri.parse(url),headers: {
        "Content-Type":"application/json"
      });
      final result=jsonDecode(resp.body);
      log("Url=>$url,Response=>${resp.body}");
      switch(resp.statusCode){
        case 200:
          final model=bannerModelFromJson(resp.body);
          if(result["status"]) {
            return Right(Success(status: BannerStatus.completed,
                msg: model.msg,
                result: model));
          }
          else{
            return Left(Failure(status: BannerStatus.error,msg: result["msg"]));
          }
        case 404:
        case 400:
        case 500:
          return Left(Failure(status: BannerStatus.error,msg: result["msg"]));
        default:
          return Left(Failure(status: BannerStatus.error,msg: result["msg"]));
      }
    }
    on CertificateException catch(e){
      log("message=>${e.message}");
      return Left(Failure(status: BannerStatus.error,msg: "Certificate Exception"));
    }
    on FormatException catch(e){
      log("message=>${e.message}");
      return Left(Failure(status: BannerStatus.error,msg: "Format Exception"));
    }
    on SocketException catch(e){
      log("message=>${e.message}");
      return Left(Failure(status: BannerStatus.error,msg: "Socket Exception"));
    }
    catch(e,stk){
      log("message=>${stk.toString()}");
      return Left(Failure(status: BannerStatus.error,msg: "Internal Server Error"));
    }
  }

}