import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:farmer_brand/Bloc/NotificationBloc/NotificationBloc.dart';
import 'package:farmer_brand/Model/Failure.dart';
import 'package:farmer_brand/Model/NotificationModel.dart';
import 'package:farmer_brand/Model/Success.dart';
import 'package:http/http.dart';
abstract class BaseNotificationRepo{
  Future<Either<Failure,Success>> fetchNotification({required String url,Map<String,dynamic>? header,Map<String,dynamic>? body});
}
class NotificationRepository extends BaseNotificationRepo{

  @override
  Future<Either<Failure, Success>> fetchNotification({required String url, Map<String, dynamic>? header, Map<String, dynamic>? body}) async{
    // TODO: implement fetchNotification
    try{
      final resp=await post(Uri.parse(url));
      final result=jsonDecode(resp.body);
      switch(resp.statusCode){
        case 200:
          if(result['status']){
            final model=notificationModelFromJson(resp.body);
            return Right(Success(status: NotificationStatus.completed,msg: "${result['msg']}",result: model));
          }
          else{
            return Left(Failure(status: NotificationStatus.error,msg: "${result['msg']}"));
          }
        case 400:
        case 404:
        return Left(Failure(status: NotificationStatus.error,msg: "${result['msg']}"));
        default:
          return Left(Failure(status: NotificationStatus.error,msg: "${result['msg']}"));
      }
    }
    catch(e){
      return Left(Failure(status: NotificationStatus.error,msg: "Internal Server Error"));
    }
  }

}