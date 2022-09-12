import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motor_hunter/base/styles.dart';
import 'package:motor_hunter/base/widgets.dart';

import '../constants/string_constants.dart';
import '../data/api/models/response/error_model.dart';
import '../data/api/models/response/offer_model_response.dart';
import '../data/api/rest_api.dart';
import '../data/clients/mappers.dart';

class DialogWithPhoto extends StatefulWidget {
  final String pathPhoto, title, description;

  const DialogWithPhoto({Key? key, required this.title, required this.description, required this.pathPhoto}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogWithPhotoState();
}

class _DialogWithPhotoState extends State<DialogWithPhoto> {
  String description = "";
  bool isEnable = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: contentBox(context),
    );
  }

  void _onDescriptionTextChange(String text) {
    setState(() {
      description = text;
    });
  }

  contentBox(context) {
    TextButton cancelButton = TextButton(
      style: styleAdditionalButton(),
      onPressed: () {
        if (!isEnable) return;

        Navigator.pop(context, false);
      },
      child: const Text(StringResources.cancel),
    );

    TextButton aproveButton = TextButton(
      style: styleSecondaryButton(),
      onPressed: () {
        if (!isEnable) return;

        setState(() {
          isEnable = false;
        });
        Apis().createOffer(widget.pathPhoto, description).then((CreatedOffer offer) => Navigator.pop(context, true)).catchError((error) {
          Navigator.pop(context, false);
          ErrorModel errorModel = Mappers().mapErrorState(error);
          showErrorSnackBar(context, errorModel.message ?? "");
        });
      },
      child: const Text(StringResources.create),
    );
    double radiusCard = 8.0;
    return Stack(children: [
      Container(
        decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.white, borderRadius: BorderRadius.circular(4.0), boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
        ]),
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                SizedBox(
                    width: 60,
                    height: 120,
                    child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radiusCard),
                        ),
                        child: Center(child: ClipRRect(borderRadius: BorderRadius.circular(radiusCard), child: Image.file(File(widget.pathPhoto)))))),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                    child: SizedBox(
                        height: 120.0,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          onChanged: _onDescriptionTextChange,
                          enabled: isEnable,
                          textInputAction: TextInputAction.done,
                          decoration:
                              const InputDecoration(hintText: StringResources.textHintDescription, helperText: StringResources.textHelperPassword),
                        ))),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                cancelButton,
                const SizedBox(width: 8.0),
                aproveButton,
                const SizedBox(width: 8.0),
                Visibility(
                    visible: !isEnable,
                    child: const CupertinoActivityIndicator(
                      color: primaryColor,
                      radius: 12.0,
                    ))
              ],
            ),
          ],
        )),
      ),
    ]);
  }
}
