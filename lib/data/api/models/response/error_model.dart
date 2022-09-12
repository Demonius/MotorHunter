enum ErrorResponseState { CLIENT_ERROR, SERVER_ERROR, NO_CONNECTION, OTHER }

class ErrorModel {
  String? message;
  int? code;
  ErrorResponseState? status;

  ErrorModel({this.message, this.code, this.status});
}
