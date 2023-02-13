import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nataraja_games/presentation/payment.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final String coinAmount;

  WebViewContainer(this.url, this.coinAmount);

  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final _key = UniqueKey();

  bool show = false;

  _WebViewContainerState(this._url);

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  String urlss ="";

  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    print("WebBalance ${widget.coinAmount}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton:  Visibility(
          visible: show,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FloatingActionButton(
              onPressed: () {
                _dialogBuilder(context);
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            ),
          ),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: WebView(
                key: _key,
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: _url,
              onWebViewCreated: (WebViewController webController) {
                print('pageStatus 01}');
                _controller.complete(webController);
              },
              navigationDelegate: (request) {
                print('pageStatus ${request.url}');
                return NavigationDecision.navigate;
              },
              onPageFinished: (url) {
                print('pageStatus finish, $url');
              },
              onPageStarted: (url){
                print('pageStatus start, $url');

                if(url.contains("deposit.php")){
                  if(mounted)
                  setState(() {
                    show = true;
                  });
                }else{
                  if(mounted)
                    setState(() {
                      show = false;
                    });
                }
                urlss = url;
                print('pageStatus start urlss, $urlss');
              },
             ),
          ),
        ),
       );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deposit Amount'),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 1.0)
            ),
            child: TextFormField(
              controller: amountController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 15),
                hintText: 'Enter Amount',
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Container(
                height: 37,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child:  Text('Deposit',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),),
                ),
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                        height: 200,
                        color: Colors.amber,
                        child: Payment(
                          amount: amountController.text,
                        ));
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
