import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:format/format.dart';

import '../base/styles.dart';
import '../base/widgets.dart';
import '../constants/string_constants.dart';
import '../data/api/models/object/offer_model.dart';
import '../data/api/rest_api.dart';

class DialogApprovePrice extends StatefulWidget {
  final Offer order;

  const DialogApprovePrice({super.key, required this.order});

  @override
  State<StatefulWidget> createState() => _DialogApprovePrice();
}

class _DialogApprovePrice extends State<DialogApprovePrice> {
  late Offer order;
  final GlobalKey<FormState> _keyForm = GlobalKey();
  TextEditingController textControllerPrice = TextEditingController();
  TextEditingController textControllerDescription = TextEditingController();

  double price = 0.0;
  bool isApproveLoad = false;
  bool isReloadList = false;
  late bool isVisibleApproveButton;

  String textApproveButton = StringResources.approve;

  @override
  void initState() {
    order = widget.order;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    textControllerDescription.dispose();
    textControllerPrice.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(StringResources.titleDialogPriceApprove),
      content: SingleChildScrollView(
          child: Form(
              key: _keyForm,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(StringResources.descriptionDialogPriceApprove),
                  const Divider(color: primaryColor, thickness: 1.0),
                  const SizedBox(height: 8.0),
                  Text(
                    format('{}: ' '{:.2f}' '{}', StringResources.textCurrentPrice, order.price, order.currency),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: textControllerPrice,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    onChanged: (text) {
                      if (text.isEmpty) {
                        price = 0.0;
                        setState(() {
                          textApproveButton = StringResources.approve;
                        });
                        return;
                      }
                      setState(() {
                        textApproveButton = StringResources.setNewPriceButton;
                      });
                      price = double.parse(text);
                    },
                    validator: (price) {
                      if (price != null && price.isNotEmpty && double.parse(price) == order.price) {
                        return StringResources.errorPriceApprove;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: StringResources.labelYourPrice,
                        hintText: StringResources.textHintPrice,
                        hintMaxLines: 2,
                        labelStyle: TextStyle(color: primaryColor),
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  SizedBox(
                      height: 100.0,
                      child: TextFormField(
                        controller: textControllerDescription,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        textInputAction: TextInputAction.done,
                        validator: (description) {
                          if (price != order.price && price > 0 && (description == null || description.isEmpty)) {
                            return StringResources.errorEmptyDescription;
                          }
                          return null;
                        },
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(color: primaryColor),
                            labelText: StringResources.labelDescription,
                            hintText: StringResources.textHintDescription,
                            floatingLabelBehavior: FloatingLabelBehavior.always),
                      )),
                  Visibility(
                      visible: isApproveLoad,
                      child: const CupertinoActivityIndicator(
                        color: Colors.white,
                        radius: 12.0,
                      )),
                ],
              ))),
      actions: [
        TextButton(
          style: styleAdditionalButton(),
          onPressed: () {
            if (isApproveLoad || _keyForm.currentState?.validate() == false) return;

            FocusManager.instance.primaryFocus?.unfocus();

            String newPriceText = price == 0.0 ? "" : price.toString();
            String description = textControllerDescription.value.text;
            Apis().approveOfferPrice(order.id, newPriceText, description).then((value) {
              Navigator.of(context).pop(true);
              // _onRefresh();
              isReloadList = true;
              setState(() {
                isApproveLoad = true;
                isVisibleApproveButton = false;
              });
            }).catchError((error) {
              Navigator.of(context).pop(false);
              showErrorSnackBar(context, error.toString());
              setState(() {
                isApproveLoad = false;
              });
            });
          },
          child: Text(textApproveButton),
        ),
      ],
    );
  }
}
