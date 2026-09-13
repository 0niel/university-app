final class ModuleDescriptor {
  const ModuleDescriptor({
    required this.id,
    required this.title,
    required this.description,
    required this.organizationIds,
    this.apiVersion = currentApiVersion,
    this.localize,
  });

  static const currentApiVersion = 1;

  final String id;
  final String title;
  final String description;
  final Set<String> organizationIds;
  final int apiVersion;
  final ModulePresentation Function(String languageCode)? localize;

  ModulePresentation presentationFor(String languageCode) =>
      localize?.call(languageCode) ??
      ModulePresentation(title: title, description: description);

  bool supports(String organizationId) =>
      apiVersion == currentApiVersion &&
      organizationId.isNotEmpty &&
      organizationIds.contains(organizationId);

  bool get isValid =>
      RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(id) &&
      id.length <= 80 &&
      title.trim().isNotEmpty &&
      organizationIds.isNotEmpty &&
      organizationIds.every(
        (id) => RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(id),
      );
}

final class ModulePresentation {
  const ModulePresentation({required this.title, required this.description});
  final String title;
  final String description;
}
