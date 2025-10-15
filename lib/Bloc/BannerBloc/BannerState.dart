part of 'BannerBloc.dart';
enum BannerStatus{initial,loading,completed,error}
class BannerState extends Equatable{
  final BannerStatus? status;
  final String? msg;
  final BannerModel? model;
  const BannerState({this.status,this.msg,this.model});

  factory BannerState.initial(){
    return BannerState(
      status: BannerStatus.initial
    );
  }

  BannerState copyWith({BannerStatus? status,String? msg,BannerModel? model}){
    return BannerState(
      status: status??status,
      msg: msg??msg,
      model: model??model
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status,msg,model];
}