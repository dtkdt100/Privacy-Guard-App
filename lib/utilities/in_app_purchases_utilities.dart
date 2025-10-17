import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

const List<String> _kProductIds = <String>[
  'privacy_guard_normal_donation',
  'privacy_guard_big_donation',
  'privacy_guard_huge_donation',
];

class InAppPurchaseUtilities {
  static final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  static List<ProductDetails> products = [];

  static Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();

    if (!isAvailable) {
      products = [];
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());

    if (productDetailResponse.error != null) {

      products = productDetailResponse.productDetails;
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      products = productDetailResponse.productDetails;
      return;
    }

    products = productDetailResponse.productDetails;
    products.sort((a, b) => a.price.compareTo(b.price));

  }

  static Future<void> purchase(ProductDetails details) async {
    late PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      purchaseParam = GooglePlayPurchaseParam(
          productDetails: details,
          applicationUserName: null,
          changeSubscriptionParam: null);
    } else {
      purchaseParam = PurchaseParam(
        productDetails: details,
        applicationUserName: null,
      );
    }

    _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: Platform.isIOS);
  }
}
