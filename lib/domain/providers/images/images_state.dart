import 'dart:io';

import 'package:web_gallery/domain/models/image.dart';

class ImagesState {
  bool? isLoading;
  bool? isError;
  String? errorMessage;
  List<Image>? images;
  int currentPage;

  ImagesState({this.isLoading, this.isError, this.errorMessage, this.images, this.currentPage = 1});

  ImagesState copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    List<Image>? images,
    int? currentPage,
  }) {
    return ImagesState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      images: images ?? this.images,
      currentPage: currentPage ?? this.currentPage
    );
  }

  @override
  String toString() {
    return 'ImagesState(isLoading: $isLoading, isError: $isError,errorMessage: $errorMessage, images: $images)';
  }

  bool compare(ImagesState compareState) {
    return isLoading == compareState.isLoading &&
        isError == compareState.isError &&
        errorMessage == compareState.errorMessage &&
        images == compareState.images;
  }
}