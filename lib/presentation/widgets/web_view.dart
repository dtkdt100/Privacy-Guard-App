import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:privacy_guard/presentation/widgets/dialogs.dart';
import '../../const.dart';

typedef JsForWebViewFunction = void Function(InAppWebViewController controller);

int counterTimesWithSignInDialog = 0;

class WebViewInner extends StatefulWidget {
  final String startUrl;
  final JsForWebViewFunction jsForWebViewFunction;
  final bool showUrl;

  WebViewInner({
    required this.startUrl,
    required this.jsForWebViewFunction,
    this.showUrl = false,
    Key? key,
  }) : super(key: key);

  @override
  WebViewInnerState createState() => WebViewInnerState();
}

class WebViewInnerState extends State<WebViewInner> {
  InAppWebViewController? webViewController;
  late InAppWebViewGroupOptions options;
  double progress = 0;
  bool loadWebView = false;

  bool dialogShow = false;

  @override
  void initState() {
    super.initState();
    options = InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
        ),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
        ),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
        ));
    Future.delayed(CONTAINER_ANIMATION_DURATION + CONTAINER_ANIMATION_DURATION,
        () {
      setState(() {
        loadWebView = true;
      });
    });
  }

  Widget circularProgressIndicator() => progress < 1.0
      ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()),
        )
      : Container();

  Widget linearProgressIndicator() =>
      progress < 1.0 ? LinearProgressIndicator(value: progress) : Container();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        !loadWebView
            ? SizedBox()
            : Column(
                children: [
                  Expanded(
                    child: InAppWebView(
                      initialUrlRequest:
                          URLRequest(url: Uri.parse(widget.startUrl)),
                      initialUserScripts: UnmodifiableListView<UserScript>([]),
                      initialOptions: options,
                      onWebViewCreated: (controller) {
                        setState(() {
                          webViewController = controller;
                        });
                      },
                      androidOnPermissionRequest:
                          (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading:
                          (controller, navigationAction) async {
                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        widget.jsForWebViewFunction(controller);

                        var serviceLogin = await controller.evaluateJavascript(
                            source:
                                "document.getElementsByClassName('jXeDnc ')[0]");

                        if (url.toString().contains("ServiceLogin") &&
                            serviceLogin != 'null' &&
                            !dialogShow) {
                          dialogShow = true;
                          if (counterTimesWithSignInDialog % 3 == 0) {
                            Future.delayed(Duration(seconds: 1), () async {
                              SignInWarningDialog(context).show();
                            });
                          }
                          counterTimesWithSignInDialog++;
                        }
                      },
                      onProgressChanged: (controller, progress) {
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                      onConsoleMessage: (c, m) {
                        print(m.message);
                      },
                    ),
                  ),
                  widget.showUrl
                      ? SizedBox(
                          height: 50,
                        )
                      : SizedBox(),
                ],
              ),
        circularProgressIndicator(),
        linearProgressIndicator(),
      ],
    );
  }
}
