


import 'dart:convert';

import 'package:dartz/dartz.dart';

import 'package:web_gallery/domain/models/image.dart';

import '../../app/di/di.dart';
import '../../data/network/network_service.dart';
import '../models/failure.dart';
import 'base_usecase.dart';

class FetchImagesUseCase extends BaseUseCase{

  NetworkService  get networkService => instance<NetworkService>();
  @override
  Future<Either<Failure, List<Image>>> execute(url)async {

    final response = await networkService.makeStringGetRequest(url);

    if(response.error){

      if(response.responseCode == 304){
        return   const Right([]);
      }else {
        return left(Failure(200, response.errorMessage));
      }
    }else {
      var jsonData = jsonDecode(response.data);

      List<Image> fetched = [];

      var fetchedImages = jsonData['hits'] as List;

      fetchedImages.forEach((image) {
        Image i = Image.fromJson(image);
        fetched.add(i);
      });
      return right(fetched);
    }
  }

}