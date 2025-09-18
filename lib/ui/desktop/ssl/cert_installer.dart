import 'dart:convert';
import 'dart:io';
import 'package:proxypin/network/util/cert/cert_data.dart';
import 'package:proxypin/network/util/logger.dart';
import 'package:x509_cert_store/x509_cert_store.dart';

class CertInstaller {
  static Future<bool> installCertificate(File certFile) async {
    try {
      // Read the certificate file and encode it to Base64
      final certBytes = await certFile.readAsBytes();
      final certificateBase64 = base64.encode(certBytes);

      // Initialize the X509CertStore plugin
      final x509CertStorePlugin = X509CertStore();

      // Add the certificate to the trusted root store
      final result = await x509CertStorePlugin.addCertificate(
        storeName: X509StoreName.root, // Add to the trusted root store
        certificateBase64: certificateBase64, // Base64-encoded certificate
        addType: X509AddType.addNewer, // Replace if it already exists
        setTrusted: Platform.isMacOS, // Mark the certificate as trusted
      );

      logger.d('Certificate successfully installed to the trusted root store. Result: ${result.code} $result');
      return result.isOk || result.code == X509ErrorCode.alreadyExist.getString();
    } catch (e) {
      logger.e('Failed to install certificate: $e');
      return false;
    }
  }

  /// 检查证书是否已安装
  static Future<bool> isCertInstalled(X509CertificateData caCert) async {
    String commonName = caCert.subject['2.5.4.3'] ?? 'ProxyPin CA';
    String? sha1 = caCert.sha1Thumbprint;
    try {
      if (Platform.isWindows) {
        List<String> args = ['-user', '-store', 'root'];
        if (sha1 != null) {
          args.add(sha1);
        }
        var res = await Process.run('certutil', args);
        return res.stdout.toString().toLowerCase().contains(commonName.toLowerCase());
      } else if (Platform.isMacOS) {
        var res = await Process.run('security', ['find-certificate', '-c', commonName, '-a']);
        return (res.stdout as String).isNotEmpty;
      } else if (Platform.isLinux) {
        // check common locations
        var paths = [
          '/usr/local/share/ca-certificates/$commonName.crt',
          '/etc/ssl/certs/$commonName.crt',
        ];
        for (var p in paths) if (await File(p).exists()) return true;
        // fallback: search /etc/ssl/certs for subject text
        var res = await Process.run('grep', ['-i', commonName, '-R', '/etc/ssl/certs']);
        return (res.stdout as String).isNotEmpty;
      }
    } catch (_) {}
    return false;
  }
}
