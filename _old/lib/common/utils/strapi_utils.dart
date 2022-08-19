import 'package:rtu_mirea_app/domain/entities/strapi_media.dart';

class StrapiUtils {
  static String getLargestImageUrl(Formats imageFormats) {
    if (imageFormats.large != null) return imageFormats.large!.url;
    if (imageFormats.medium != null) return imageFormats.medium!.url;
    if (imageFormats.small != null) return imageFormats.small!.url;
    return imageFormats.thumbnail.url;
  }

  static String getMediumImageUrl(Formats imageFormats) {
    if (imageFormats.medium != null) return imageFormats.medium!.url;
    if (imageFormats.small != null) return imageFormats.small!.url;
    return imageFormats.thumbnail.url;
  }
}
