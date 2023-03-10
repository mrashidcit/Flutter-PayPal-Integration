import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:paypal_integration_app/constants.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:paypal_integration_app/helpers/ui_helper.dart';

bool debugShowCheckedModeBanner = false;
const localeEnglish = [Locale('en', '')];

// void main() {
//   // runApp(const MyApp());
//   void main() => OnePlatform.app = () => MyApp();
// }

void main() => OnePlatform.app = () => MyApp();

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    print('>> MyApp2 loaded!');
    OneContext().key = GlobalKey<NavigatorState>();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    log('>> MyApp - build()');
    // Place that widget on most top

    return OneNotification(
      builder: (_, __) => MaterialApp(
        title: 'Flutter Demo',
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        builder: OneContext().builder,
        navigatorKey: OneContext().key,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PayPal Integration Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => UsePaypal(
                          sandboxMode: true,
                          clientId: "${Constants.clientId}",
                          secretKey: "${Constants.secretKey}",
                          returnURL: "${Constants.returnURL}",
                          cancelURL: "${Constants.cancelURL}",
                          transactions: const [
                            {
                              "amount": {
                                "total": '10.12',
                                "currency": "USD",
                                "details": {
                                  "subtotal": '10.12',
                                  "shipping": '0',
                                  "shipping_discount": 0
                                }
                              },
                              "description":
                                  "The payment transaction description.",
                              // "payment_options": {
                              //   "allowed_payment_method":
                              //       "INSTANT_FUNDING_SOURCE"
                              // },
                              "item_list": {
                                "items": [
                                  {
                                    "name": "A demo product",
                                    "quantity": 1,
                                    "price": '10.12',
                                    "currency": "USD"
                                  }
                                ],

                                // shipping address is not required though
                                "shipping_address": {
                                  "recipient_name": "Jane Foster",
                                  "line1": "Travis County",
                                  "line2": "",
                                  "city": "Austin",
                                  "country_code": "US",
                                  "postal_code": "73301",
                                  "phone": "+00000000",
                                  "state": "Texas"
                                },
                              }
                            }
                          ],
                          note: "Contact us for any questions on your order.",
                          onSuccess: (Map params) async {
                            print("onSuccess: $params");
                            UIHelper.showAlertDialog('Payment Successfully',
                                title: 'Success');
                          },
                          onError: (error) {
                            print("onError: $error");
                            UIHelper.showAlertDialog(
                                'Unable to completet the Payment',
                                title: 'Error');
                          },
                          onCancel: (params) {
                            print('cancelled: $params');
                            UIHelper.showAlertDialog('Payment Cannceled',
                                title: 'Cancel');
                          }),
                    ),
                  );
                },
                child: Text('Pay With PayPal'))
          ],
        ),
      ),
    );
  }
}
