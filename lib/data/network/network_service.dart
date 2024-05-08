import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:web_gallery/app/constants/app_strings.dart';
import 'package:web_gallery/app/di/di.dart';

import '../../domain/models/api_response.dart';

class NetworkService{

  Dio dio = instance<Dio>();

  Future<APIResponse<String>>  makeStringGetRequest(String url) async{

    try{
      var res = await  dio.get(url);
      return decodeResponse(res);
    }on DioException catch (e){
      DioException ef = e;
      return decodeResponse(ef.response);
    }

  }

  Future<APIResponse<String>> decodeResponse(dynamic res) async{

    try{
      switch(res.statusCode){
        case 200:
          return APIResponse<String>(jsonEncode(res.data), "", false, responseCode: 200);

        case 401:
          return APIResponse<String>("401", AppString.notAuthenticated, true, responseCode: 401);
        case 403:
          return APIResponse<String>("403", AppString.notAuthorized, true, responseCode: 403);
        case 404:
          return APIResponse<String>("404", AppString.notFound, true, responseCode: 404);
        case 422:
          return APIResponse<String>("422", AppString.badRequest, true, responseCode: 422);
        case 500:
          return APIResponse<String>("500", AppString.serverError, true, responseCode: 500);
        case 503:
          return APIResponse<String>("503", AppString.maintenanceMode, true, responseCode: 503);
        case 304:
          return APIResponse<String>("304", AppString.maintenanceMode, true, responseCode: 304);
        default:
          return APIResponse<String>("505", AppString.somethingWrongHappened, true, responseCode: 505);


      }
    }catch(e){
      return APIResponse<String>("", "Something wrong happened", true, responseCode: 505);
    }
  }


}