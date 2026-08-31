class StacBridgeConfig {
  const StacBridgeConfig({
    required this.proxyUrl,
    required this.organizationId,
    required this.onAccessTokenRequested,
  });

  final String proxyUrl;
  final String organizationId;
  final Future<String?> Function() onAccessTokenRequested;
}
