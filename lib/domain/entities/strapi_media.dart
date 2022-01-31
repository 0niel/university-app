import 'package:equatable/equatable.dart';

class StrapiMedia extends Equatable {
  const StrapiMedia({
    required this.name,
    required this.alternativeText,
    required this.caption,
    required this.width,
    required this.height,
    required this.formats,
    required this.size,
    required this.url,
  });

  final String name;
  final String? alternativeText;
  final String? caption;
  final int width;
  final int height;
  final Formats formats;
  final double size;
  final String url;

  @override
  List<Object> get props => [name, width, height, formats, size, url];
}

class Formats extends Equatable {
  const Formats({
    required this.large,
    required this.small,
    required this.medium,
    required this.thumbnail,
  });

  final StrapiImage? large;
  final StrapiImage? medium;
  final StrapiImage? small;
  final StrapiImage thumbnail;

  @override
  List<Object> get props => [thumbnail];
}

class StrapiImage extends Equatable {
  const StrapiImage({
    required this.url,
    required this.name,
    required this.size,
    required this.width,
    required this.height,
  });

  final String url;
  final String name;
  final double size;
  final int width;
  final int height;

  @override
  List<Object> get props => [url, name, size, width, height];
}
