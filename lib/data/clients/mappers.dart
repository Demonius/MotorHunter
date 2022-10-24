import 'package:dio/dio.dart';
import 'package:motor_hunter/constants/string_constants.dart';
import 'package:motor_hunter/data/api/models/response/offer_model_response.dart';

import '../api/models/object/offer_model.dart';
import 'package:intl/intl.dart';

import '../api/models/response/error_model.dart';

class Mappers {
  Offer mapOffers(OfferResponse offerResponse) => Offer(
      id: offerResponse.id ?? -1,
      image: offerResponse.image ?? "",
      licensePlate: offerResponse.licensePlate ?? "Not scanned",
      createdAt: offerResponse.createdAt,
      isRequestedMedia: offerResponse.isRequestedMedia,
      managerComment: offerResponse.managerComment,
      supplierComment: offerResponse.supplierComment,
      photos: offerResponse.photos,
      video: offerResponse.video ?? "",
      price: offerResponse.price,
      messageStatus: offerResponse.statusMessage,
      idStatus: offerResponse.mobileStatus,
      uiState: offerResponse.uiState,
      colorBorder: offerResponse.borderColor != null ? int.tryParse(offerResponse.borderColor!) : null,
      currency: offerResponse.currency);

  String convertDateToString(DateTime currentDateTime) {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
    return dateFormat.format(currentDateTime);
  }

  String returnStringFromInt(int value) {
    StringBuffer element = StringBuffer();
    if (value < 10) {
      element.write("0");
    }
    element.write(value);
    return element.toString();
  }

  String getNameStatusById(int apiStatusId) {
    switch (apiStatusId) {
      case 5:
        return StringResources.statusScanningPhoto;
      case 15:
        return StringResources.statusPlacedForSale;
      default:
        return StringResources.statusEmpty;
    }
  }

  ErrorModel mapErrorState(DioError error) {
    int? statusCode = error.response?.statusCode ?? -1;
    String message = error.error.toString() ?? "";
    ErrorResponseState status = ErrorResponseState.other;
    if (statusCode >= 400 && statusCode < 500) {
      status = ErrorResponseState.clientError;
    } else if (statusCode >= 500) {
      status = ErrorResponseState.serverError;
    }
    return ErrorModel(message: message, code: statusCode, status: status);
  }
}
