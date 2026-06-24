import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {

  static void shareLink(String url) {

    if (kIsWeb) {
      Share.share("Segue o relatório: $url");
    } else {
      Share.share("Segue o relatório: $url");
    }
  }
}