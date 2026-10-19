import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/kit/kit_image_picker_parser.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacAppImagePickerParser extends StacParser<KitModel> {
  const StacAppImagePickerParser();

  @override
  String get type => 'appImagePicker';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => KitImagePicker(
    key: ValueKey('imagePicker:${stringOf(model, 'id', stateKeyOf(model))}'),
    model: model,
  );
}
