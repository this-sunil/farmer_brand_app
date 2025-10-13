import 'dart:convert';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:farmer_brand/Bloc/PostBloc/PostBloc.dart';
import 'package:farmer_brand/Model/Failure.dart';
import 'package:farmer_brand/Model/PostModel.dart';
import 'package:farmer_brand/Model/Success.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

abstract class BasePostRepository{
  Future<Either<Failure,Success>> getAllPost({required String url, Map<String, dynamic>? body, Map<String, String>? header});
}

class PostRepository extends BasePostRepository {
  @override
  Future<Either<Failure, Success>> getAllPost({required String url, Map<String, dynamic>? body, Map<String, String>? header}) async{
    // TODO: implement getAllPost
    try{
      if(kDebugMode){
        log("Response Post=>$url");
      }
      final resp=await post(Uri.parse(url),headers: header,body: jsonEncode(body));
      if(kDebugMode){
        log("Response =>${resp.body}");
      }
      final result=jsonDecode(resp.body);

      switch(resp.statusCode){
        case 200:
          if(result["status"]){
            final results=postModelFromJson(resp.body);
            return Right(Success(status: PostStatus.completed,msg:"${result['msg']}",result: results));
          }
          else{
            return Left(Failure(status: PostStatus.error,msg:"${result['msg']}"));
          }
        case 400:
          return Left(Failure(status: PostStatus.error,msg:"${result['msg']}"));
        default:
          return Left(Failure(status: PostStatus.error,msg:"${result['msg']}"));
      }
    }
    catch(e){
      return Left(Failure(status: PostStatus.error,msg:"Internal Server Error"));
    }
  }

}