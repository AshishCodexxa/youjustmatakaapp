import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nataraja_games/api_files/shared_preferense.dart';
import 'package:nataraja_games/api_files/wallet_response.dart';
import 'package:upi_india/upi_india.dart';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  final String amount;

  const Payment({super.key, required this.amount});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Future<UpiResponse>? _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  @override
  void initState() {
    print("PayBalance ${widget.amount}");
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "bharatpe09891517390@yesbankltd"/*Q363433541@ybl*/,
      receiverName: 'You Just Mataka',
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'You Just Mataka Recharge Amount',
      amount: double.parse(widget.amount),
    );
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return Center(child: CircularProgressIndicator());
    } else if (apps!.length == 0) {
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    } else {
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        getWalletUsers();
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
              child: Text(
                body,
                style: value,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          displayUpiApps(),
          FutureBuilder(
            future: _transaction,
            builder:
                (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      _upiErrorHandler(snapshot.error.runtimeType),
                      style: header,
                    ), // Print's text message on screen
                  );
                }

                // If we have data then definitely we will have UpiResponse.
                // It cannot be null
                UpiResponse _upiResponse = snapshot.data!;

                // Data in UpiResponse can be null. Check before printing
                String txnId = _upiResponse.transactionId ?? 'N/A';
                String resCode = _upiResponse.responseCode ?? 'N/A';
                String txnRef = _upiResponse.transactionRefId ?? 'N/A';
                String status = _upiResponse.status ?? 'N/A';
                String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';

                _checkTxnStatus(status);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      // displayTransactionData('Transaction Id', txnId),
                      // displayTransactionData('Response Code', resCode),
                      // displayTransactionData('Reference Id', txnRef),
                      // displayTransactionData('Status', status.toUpperCase()),
                      // displayTransactionData('Approval No', approvalRef),
                    ],
                  ),
                );
              } else
                return Center(
                  child: Text(''),
                );
            },
          )
        ],
      ),
    );
  }

  Future<WalletResponse> getWalletUsers() async {

    String userName = await AppPreferences.getUserName();
    try {
      final result = await http.post(
          Uri.parse("https://natarajgames.codingwala.com/wallet_api.php"),
          body: {
            "username": userName,
            "amount": widget.amount.toString(),
          });

      print("username $userName ");

      print("Payment:" + result.body);
      print("statusCode:" + result.statusCode.toString());


      Map<String, dynamic> body = jsonDecode(result.body);

      print("DOneeee");

      if(body['message'] == "Balance Point ${widget.amount} Successfully deposited by you"){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${body['message']}")));
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(coin: body['balance'].toString(),)));
      }
      else{
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${body['message']}")));
      }

      return walletResponseFromJson(result.body);
    } catch (e) {
      rethrow;
    }
  }
}
