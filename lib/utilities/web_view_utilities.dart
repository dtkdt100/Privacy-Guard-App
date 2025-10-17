import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:privacy_guard/presentation/bloc/home_buttons_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'privacy_item_info.dart';
import '../../presentation/widgets/web_view.dart';

class WebViewUtilities {
  static AppBar appBar({String? text, Widget? child}) =>
      AppBar(centerTitle: true, title: child ?? Text(text!));

  static Widget floatingActionButton(
          {required PrivacyItemInfo privacyItemInfo,
          required bool showUrl,
          required GlobalKey<WebViewInnerState> webViewKey,
          VoidCallback? setState}) =>
      privacyItemInfo.showUrl == null
          ? SizedBox()
          : FloatingActionButton.extended(
              backgroundColor: Colors.black,
              onPressed: callBackForFloatingActionButton(
                  showUrl, webViewKey, privacyItemInfo, setState),
              label: Text(
                  textForFloatingActionButton(showUrl, privacyItemInfo.label)),
            );

  static String textForFloatingActionButton(bool showUrl, String name) =>
      "${showUrl ? "Remove" : "Show"} $name";

  static VoidCallback callBackForFloatingActionButton(
          bool showUrl,
          GlobalKey<WebViewInnerState> webViewKey,
          PrivacyItemInfo privacyItemInfo,
          VoidCallback? setState) =>
      () {
        webViewKey.currentState!.webViewController!.loadUrl(
            urlRequest: URLRequest(
                url: Uri.parse(
                    showUrl ? privacyItemInfo.url : privacyItemInfo.showUrl!)));
        if (setState != null) setState();
      };

  static Future<void> handleJavaScript(InAppWebViewController controller,
      PrivacyItemInfo privacyItemInfo, BuildContext context, bool showUrl) async {
    await controller.evaluateJavascript(
        source: privacyItemInfo.javaScriptDesign);

    if (!showUrl) {
      if (privacyItemInfo.javaScriptAction == "") {
        context.read<HomeButtonsBloc>().changeComplete(
          HomeButtonsBloc.where(privacyItemInfo.label),
        );
      } else {
        var responseForAction = await controller.evaluateJavascript(
            source:privacyItemInfo.javaScriptAction);

        context.read<HomeButtonsBloc>().changeComplete(
            HomeButtonsBloc.where(privacyItemInfo.label),
            change: responseForAction == "false");
      }
    }
  }

  static FloatingActionButtonLocation floatingActionButtonLocation =
      FloatingActionButtonLocation.centerFloat;
}
