import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:privacy_guard/utilities/shared_preferences_utilities.dart';
import 'package:privacy_guard/utilities/web_view_utilities.dart';
import '../bloc/home_buttons_bloc.dart';
import '../../utilities/privacy_item_info.dart';
import 'web_view.dart';
import '../../const.dart';

class StartScreen extends StatefulWidget {
  final List<PrivacyItemInfo> buttons;

  StartScreen(this.buttons);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final PageController pageController = PageController();
  double pageIndex = 0.0;
  late List<bool> showUrls;
  late List<GlobalKey<WebViewInnerState>> webViewKeys;
  List<PrivacyItemInfo>? newButtons;

  @override
  void initState() {
    super.initState();
    webViewKeys = List.generate(widget.buttons.length, (index) => GlobalKey());
    showUrls = List.generate(widget.buttons.length, (index) => false);
    pageController.addListener(() {
      setState(() {
        pageIndex = pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WebViewUtilities.appBar(
        text: widget.buttons[pageIndex.round()].label,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: WebViewUtilities.floatingActionButton(
          privacyItemInfo: widget.buttons[pageIndex.round()],
          showUrl: showUrls[pageIndex.round()],
          webViewKey: webViewKeys[pageIndex.round()],
          setState: () {
            showUrls[pageIndex.round()] = !showUrls[pageIndex.round()];
            setState(() {});
          }),
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          widget.buttons.length,
          (index) => BlocProvider(
            create: (_) => HomeButtonsBloc(),
            child: widget.buttons[index].child ??
                WebViewInner(
                  key: webViewKeys[index],
                  showUrl: widget.buttons[index].showUrl != null,
                  startUrl: widget.buttons[index].url,
                  jsForWebViewFunction:
                      (InAppWebViewController controller) async {
                    await controller.evaluateJavascript(
                        source: widget.buttons[index].javaScriptDesign);

                    if (!showUrls[index]) {
                      if (widget.buttons[index].javaScriptAction == "") {
                        Uri? url = await controller.getUrl();
                        context.read<HomeButtonsBloc>().changeComplete(
                              HomeButtonsBloc.where(
                                  widget.buttons[index].label),
                              change: !url.toString().contains("ServiceLogin"),
                            );
                      } else {
                        var responseForAction =
                            await controller.evaluateJavascript(
                                source: widget.buttons[index].javaScriptAction);

                        context.read<HomeButtonsBloc>().changeComplete(
                            HomeButtonsBloc.where(widget.buttons[index].label),
                            change: responseForAction == "false");
                      }
                    }
                  },
                ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, -2.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                pageController.previousPage(
                    duration: CONTAINER_ANIMATION_DURATION, curve: Curves.ease);
              },
              child: pageIndex == 0.0
                  ? Text("               ")
                  : Row(
                      children: [
                        Icon(Icons.arrow_back_ios),
                        Text("Back"),
                      ],
                    ),
            ),
            DotsIndicator(
              onTap: (page) {
                pageController.animateToPage(page.toInt(),
                    duration: CONTAINER_ANIMATION_DURATION, curve: Curves.ease);
              },
              dotsCount: widget.buttons.length,
              position: pageIndex,
              decorator: DotsDecorator(
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
            TextButton(
              onPressed: () {
                if (pageIndex.round() == widget.buttons.length - 1) {
                  pageIndex = 0.0;
                  Navigator.pop(context);
                } else {
                  pageController.nextPage(
                      duration: CONTAINER_ANIMATION_DURATION,
                      curve: Curves.ease);
                }
              },
              child: Row(
                children: [
                  Text(pageIndex.round() == widget.buttons.length - 1
                      ? "Done"
                      : "Next"),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
