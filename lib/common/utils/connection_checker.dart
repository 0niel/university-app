import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// The default parameters for DNS lookups
const Map<String, String> dnsParameters = {
  'name': 'ya.ru',
  'type': 'A',
  'dnssec': '1',
};

/// The default headers for DNS lookups
const Map<String, String> dnsHeaders = {
  'Accept': 'application/dns-json',
  'Cache-Control': 'no-cache',
  'Content-Type': 'application/json',
};

final List<AddressCheckOptions> defaultAddresses = [
  AddressCheckOptions(
    Uri.parse('https://yandex.cloudflare-dns.com/dns-query').replace(
      queryParameters: dnsParameters,
    ),
    headers: dnsHeaders,
  ),
  AddressCheckOptions(
    Uri.parse('https://mozilla.cloudflare-dns.com/dns-query').replace(
      queryParameters: dnsParameters,
    ),
    headers: dnsHeaders,
  ),
];
