String fileTypeBadge(String fileName, String? mimeType) {
  final extension = fileName.split('.').lastOrNull?.toUpperCase();
  if (extension != null &&
      extension.isNotEmpty &&
      extension != fileName.toUpperCase()) {
    return extension.length <= 4 ? extension : extension.substring(0, 3);
  }
  if (mimeType?.startsWith('image/') ?? false) return 'IMG';
  if (mimeType == 'application/pdf') return 'PDF';
  return 'DOC';
}
