class APIResponse<T>{
  T data;
  bool error;
  String errorMessage;

  int? responseCode;

  APIResponse(this.data, this.errorMessage ,  this.error , {this.responseCode = 200});



}