import 'package:equatable/equatable.dart';

class ImageModel extends Equatable {
  final String url;

  ImageModel({required this.url});

  factory ImageModel.from_json(Map<String, dynamic> json) {
    return ImageModel(
      url: json['name'],
    );
  }

  @override
  List<Object?> get props => [url];
}
