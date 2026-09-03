final class CollabNoteChange {
  const CollabNoteChange({
    required this.clientId,
    required this.revision,
    required this.document,
    this.updatedAt,
  });

  factory CollabNoteChange.fromPayload(Map<String, Object?> payload) {
    final clientId = payload['clientId'];
    final revision = payload['revision'];
    final document = payload['document'];
    if (payload['version'] != 2 ||
        clientId is! String ||
        clientId.isEmpty ||
        revision is! int ||
        revision < 0 ||
        document is! List ||
        document.isEmpty) {
      throw const FormatException('Invalid note snapshot');
    }
    return CollabNoteChange(
      clientId: clientId,
      revision: revision,
      document: List<Object?>.unmodifiable(document),
      updatedAt: switch (payload['updatedAt']) {
        final String value => DateTime.tryParse(value),
        _ => null,
      },
    );
  }

  final String clientId;
  final int revision;
  final List<Object?> document;
  final DateTime? updatedAt;

  Map<String, Object?> toPayload() => {
    'version': 2,
    'clientId': clientId,
    'revision': revision,
    'document': document,
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
  };
}
