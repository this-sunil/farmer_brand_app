import 'package:farmer_brand/Model/BannerModel.dart';
import 'package:farmer_brand/Repository/BannerRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
part 'BannerEvent.dart';
part 'BannerState.dart';
class BannerBloc extends Bloc<BannerEvent,BannerState>{
  final BannerRepository repository;
  BannerBloc(this.repository):super(BannerState.initial()){
    on<FetchBannerEvent>(_fetchBannerApi);
  }
  _fetchBannerApi(FetchBannerEvent event,Emitter<BannerState> emit) async{
    emit(state.copyWith(status: BannerStatus.loading));
    String url='${dotenv.env['BASE_URL']}${dotenv.env['GET_BANNER']}';
    final result=await repository.fetchBanner(url: url);
    result.fold((l)=>emit(state.copyWith(status: l.status,msg: l.msg)), (r)=>emit(state.copyWith(status: r.status,msg: r.msg,model: r.result)));
  }
}