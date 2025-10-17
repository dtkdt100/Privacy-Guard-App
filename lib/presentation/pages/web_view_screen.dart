import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:privacy_guard/utilities/shared_preferences_utilities.dart';
import 'package:privacy_guard/utilities/web_view_utilities.dart';
import '../bloc/home_buttons_bloc.dart';
import '../../utilities/privacy_item_info.dart';
import '../widgets/web_view.dart';

class WebViewScreen extends StatefulWidget {
  final PrivacyItemInfo privacyItemInfo;

  WebViewScreen({
    required this.privacyItemInfo,
  });

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  GlobalKey<WebViewInnerState> webViewKey = GlobalKey();
  bool loadWebView = false;
  bool showUrl = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WebViewUtilities.appBar(text: widget.privacyItemInfo.label),
      floatingActionButtonLocation: WebViewUtilities.floatingActionButtonLocation,
      floatingActionButton: WebViewUtilities.floatingActionButton(
          privacyItemInfo: widget.privacyItemInfo,
          showUrl: showUrl,
          webViewKey: webViewKey,
          setState: () {
            setState(() {
              showUrl = !showUrl;
            });
          }),
      body: WebViewInner(
        key: webViewKey,
        startUrl: widget.privacyItemInfo.url,
        showUrl: widget.privacyItemInfo.showUrl != null,
        jsForWebViewFunction: (InAppWebViewController controller) async {
          await controller.evaluateJavascript(
              source: widget.privacyItemInfo.javaScriptDesign);

          if (!showUrl) {
            if (widget.privacyItemInfo.javaScriptAction == ""){
              Uri? url = await controller.getUrl();
              context.read<HomeButtonsBloc>().changeComplete(
                HomeButtonsBloc.where(
                    widget.privacyItemInfo.label),
                change: !url.toString().contains("ServiceLogin"),
              );
            } else {
              var responseForAction = await controller.evaluateJavascript(
                  source: widget.privacyItemInfo.javaScriptAction);

              context.read<HomeButtonsBloc>().changeComplete(
                  HomeButtonsBloc.where(widget.privacyItemInfo.label),
                  change: responseForAction == "false");
            }
          }
        },
      ),
    );
  }
}
