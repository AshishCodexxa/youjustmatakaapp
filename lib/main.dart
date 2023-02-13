import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nataraja_games/presentation/webViewController.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String url = 'https://youjustmatka.com/app/login.php';
    return MaterialApp(
      title: 'You Just Mataka',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/frame': (BuildContext context) => WebViewContainer(url, ""),
        }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // var _url;
  // final _key = UniqueKey();
  //
  // String _links = 'https://youjustmatka.com/app/login.php';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(image: AssetImage("assets/images/ng_icon.png"),
        height: 200,
        width: 200,),
      ),
    );
  }


  void navigateParentPage() {
    Navigator.of(context).pushReplacementNamed('/frame');
  }

  startTimer() async {
    var durtaion = const Duration(seconds: 3);
    return Timer(durtaion, navigateParentPage);
  }

  // startTimer() async {
  //   var durtaion = const Duration(seconds: 3);
  //   return Timer(durtaion,  (){
  //     print("Hiiii");
  //     _handleURLButtonPress(_links, "");
  //   } );
  // }
  //
  // void _handleURLButtonPress(String url, String coin) {
  //   Navigator.push(context,
  //       MaterialPageRoute(builder: (context) => WebViewContainer(url, "")));
  // }

}
