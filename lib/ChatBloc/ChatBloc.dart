import 'dart:developer';

import 'package:farmer_brand/OpenAI.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'ChatEvent.dart';
part 'ChatState.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState.initial()) {
    on<BotEvent>(_chatBoatApi);
  }
  List<Map<String, String>> chats = [];
  _chatBoatApi(BotEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading, chats: chats));
    if (event.status == BoatStatus.user) {
      chats.add({'sender': 'user', 'text': event.msg.toString().trim()});
      emit(
        state.copyWith(
          status: ChatStatus.completed,
          msg: "Fetch Successfully",
          chats: chats,
        ),
      );
    } else {
      final result = await OpenAIService().generateResponse(
        event.msg.toString(),
      );
      log("message=>${event.status}");
      result.fold(
        (l) => emit(state.copyWith(status: l.status, msg: l.msg, chats: chats)),
        (r) {
          chats.add({'sender': 'boat', 'text': r.result.toString().trim()});
          emit(state.copyWith(status: r.status, msg: r.msg, chats: chats));
        },
      );
    }
  }
}
