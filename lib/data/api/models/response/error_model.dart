enum ErrorResponseState { clientError, serverError, noConnection, other }

class ErrorModel {
  String? message;
  int? code;
  ErrorResponseState? status;

  ErrorModel({this.message, this.code, this.status});
}
