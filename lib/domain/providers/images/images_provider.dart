
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_gallery/domain/usecase/fetch_images_usecase.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/di/di.dart';
import 'images_state.dart';
import 'package:web_gallery/domain/models/image.dart' as ImageModel;

final imagesStateNotifierProvider = StateNotifierProvider<ImagesStateNotifier, ImagesState>((ref) => ImagesStateNotifier());

class ImagesStateNotifier extends StateNotifier<ImagesState> {
  ImagesStateNotifier() : super(ImagesState()) {
    getImages(init: true,);
  }

  final FetchImagesUseCase _useCase = instance<FetchImagesUseCase>();

   String searchQuery = "";

   String lastQuery = "";

   List<ImageModel.Image> initImages = [];


  getImages({bool isSearch = false, String query = "", bool init = false})async{
    state = state.copyWith(isLoading: true);
    lastQuery = query;
    if(isSearch){

      //search the images using the query provided
      searchQuery = "${AppConstants.SEARCH_URL}&q=${lastQuery}&image_type=photos&page=1";

    }else{
      // fetch all the images
    searchQuery = "${AppConstants.SEARCH_URL}&page=1";
    }

    final response = await _useCase.execute(searchQuery);
    
    response.fold((l){
      //handle request failure
      state = state.copyWith(isLoading: false, isError: true, errorMessage: l.message,);
    }, (r){
      if(init){
        initImages = r;
        state = state.copyWith(isLoading: false, isError: false, images: r, currentPage: 1);
      }else{
        if(isSearch){
          state = state.copyWith(isLoading: false, isError: false, images: r, currentPage: 1);
        }else{
          state = state.copyWith(isLoading: false, isError: false, images: r, currentPage: 1);
        }
      }
    });
  }

  void dismissSearch(){
    //restore the loaded images before the search was initiated
    state = state.copyWith(isLoading: false, isError: false, images: initImages, currentPage: 1);
  }

  void loadMore()async{
    int nextPage = state.currentPage + 1;
    if(lastQuery.isNotEmpty){
      //load more search results
      searchQuery = "${AppConstants.SEARCH_URL}&q=${lastQuery}&image_type=photos&page=${nextPage}";
    }else{
      //load more general results
      searchQuery = "${AppConstants.SEARCH_URL}&image_type=photos&page=${nextPage}";

    }

    final response = await _useCase.execute(searchQuery);

    response.fold((l){
      //handle request failure
      state = state.copyWith(isLoading: false, isError: true, errorMessage: l.message,);
    }, (r){
      //add the loaded images to the images list
      state = state.copyWith(isLoading: false, isError: false, images: [...?state.images, ...r], currentPage: nextPage);


    });
  }
}