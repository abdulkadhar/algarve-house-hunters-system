import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlRenderer extends StatelessWidget {
  final String html;

  const HtmlRenderer({super.key, required this.html});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: html,
      style: {
        "body": Style(
          margin: Margins.all(0),
          padding: HtmlPaddings.all(0),
          fontSize: FontSize(16),
          lineHeight: LineHeight.number(1.5),
        ),
        "h1": Style(margin: Margins.only(bottom: 12)),
        "h2": Style(margin: Margins.only(bottom: 10)),
        "p": Style(margin: Margins.only(bottom: 8)),
      },
      onLinkTap: (url, _, __) async {
        if (url == null) return;
        // Web: open in new tab
        await launchUrl(
          Uri.parse(url),
          webOnlyWindowName: '_blank',
          mode: LaunchMode.platformDefault,
        );
      },
      // onImageTap: (url, _, __, ___) async {
      //   if (url == null) return;
      //   await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
      // },
      // Optional: whitelist/disable dangerous elements if content is untrusted
      // tagsList: Html.tags..removeWhere((t) => t == 'script' || t == 'iframe'),
    );
  }
}
