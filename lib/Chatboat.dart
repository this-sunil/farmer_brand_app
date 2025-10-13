import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:farmer_brand/OpenAI.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:farmer_brand/ChatBloc/ChatBloc.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final OpenAIService openAIService = OpenAIService();
  final TextEditingController controller = TextEditingController();
  // List<Map<String, String>> messages = [];
  SpeechToText speechToText=SpeechToText();
  void sendMessage() async {
    final text = controller.text;
    if (text.isNotEmpty) {
      //setState(() => messages.add({'sender': 'user', 'text': text}));
      context.read<ChatBloc>().add(BotEvent(status: BoatStatus.user,msg: text));
      controller.clear();
      final response = await openAIService.generateResponse(text);
      response.fold((l)=>log(l.msg.toString()), (r){
        context.read<ChatBloc>().add(BotEvent(status: BoatStatus.boat,msg: r.result.toString().trim()));
        //setState(() => messages.add({'sender': 'bot', 'text': r.result.toString().trim()}));
      });
    }
  }


  initialize(String val) async{
    // final response = await openAIService.generateResponse(val);
    // response.fold((l)=>log(l.msg.toString()), (r){
    //   setState(() => messages.add({'sender': 'user', 'text': r.result.toString().trim()}));
    // });
    String text="only this sentence translate only no note or no extra explain Hi, I am Chat boat.How can help you?";
    context.read<ChatBloc>().add(BotEvent(status: BoatStatus.boat,msg: text));
  }
  /// This has to happen only once per app
  bool speechEnabled=false;
  void initSpeech() async {
    await speechToText.systemLocale();
   await speechToText.initialize().whenComplete(()=>log("Initialize Speech"));



    Future.delayed(Duration(seconds: 1),(){
      setState(() {});
    });
  }

  /// Each time to start a speech recognition session
  void startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
    log("Start Listen");
  }


  void stopListening() async {
    await speechToText.stop();
    log("Stop Listen");
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      controller.text = result.recognizedWords.toString();

    });
  }
  @override
  void initState() {
    // TODO: implement initState

    initialize("Today Whether details and farmer market Details all vegetable price and fruits with price value from all maharashtra in marathi");
    super.initState();
    //_initSpeech();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepOrange,
          title: Text('Chatbot',style: TextStyle(color: Colors.white))),
      body: SafeArea(child: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc,ChatState>(builder: (context,state){

              return ListView.builder(
                itemCount: state.chats.length,
                itemBuilder: (context, index) {
                  final message = state.chats[index];
                  return Align(
                      alignment: message['sender'] == 'user'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: message['sender'] == 'user'
                              ? Colors.orange.shade200
                              : Colors.cyan.shade200,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: CircleAvatar(
                              maxRadius:25,
                              child: Icon(message['sender']=='user'?HeroiconsSolid.user:HeroiconsSolid.heart),
                            )),
                            SizedBox(width: 10),
                            Expanded(
                                flex:2,
                                child:  Text(message['text'] ?? '',style: TextStyle(color: Color(0xFF333945),fontWeight: FontWeight.w500,fontSize: 16)))
                          ],
                        ),

                      )


                  );
                },
              );


            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: TextFormField(controller: controller,decoration: InputDecoration(
                  border: InputBorder.none,
                  // prefixIcon: IconButton(onPressed: (){
                  //   if(speechEnabled){
                  //     _stopListening();
                  //   }
                  //   else{
                  //     _startListening();
                  //   }
                  //
                  //     setState(() {
                  //       speechEnabled=!speechEnabled;
                  //     });
                  //
                  // }, icon: Icon(speechEnabled==false?Icons.mic_off_sharp:Icons.mic)),
                  hintText: "Send a message",
                  suffixIcon:  IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none
              ),),
            ),
          ),
         
        ],
      )),
    );
  }
}