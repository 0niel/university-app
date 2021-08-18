import 'package:equatable/equatable.dart';

class Image_model extends Equatable {
  final String url;

  Image_model({required this.url});

  factory Image_model.from_json(Map<String, dynamic> json) {
    return Image_model(
      url: json['name'],
    );
  }

  @override
  List<Object?> get props => [url];
}
