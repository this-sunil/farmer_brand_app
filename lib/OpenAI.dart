import 'dart:convert';
import 'dart:io';
import 'package:farmer_brand/ChatBloc/ChatBloc.dart';
import 'package:farmer_brand/Model/ChatModel.dart';
import 'package:http/http.dart';
import 'package:either_dart/either.dart';
import 'package:farmer_brand/Model/Failure.dart';
import 'package:farmer_brand/Model/Success.dart';

class OpenAIService {

  final String apiKey = 'AIzaSyBL2_R1WHTMFLp12S_6iqfpHzn8NzkVCg4';

  Future<Either<Failure, Success>> generateResponse(String prompt) async {
    try {
      final response = await post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent',
        ),
        headers: {'X-goog-api-key': apiKey, 'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": "$prompt in english in short"},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = chatModelFromJson(response.body);
        return Right(
          Success(
            status: ChatStatus.completed,
            msg: "Fetch Successfully",
            result: data.candidates[0].content.parts[0].text,
          ),
        );
      } else {
        return Left(Failure(
            msg: 'Failed to generate response', status: ChatStatus.error));
      }
    }
    on FormatException catch(e){
      throw Exception(e.message);
    }
    on SocketException catch(e){
      throw Exception(e.message.toString());
    }
    catch (e) {
      throw Exception(e);
    }
  }
}
