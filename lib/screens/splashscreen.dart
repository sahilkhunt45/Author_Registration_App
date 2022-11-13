import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('homepage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              "https://png.pngtree.com/png-vector/20191003/ourmid/pngtree-best-writer-prize-icon-black-simple-style-png-image_1788295.jpg",
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              color: Colors.deepPurple,
              strokeWidth: 5,
            ),
          ],
        ),
      ),
    );
  }
}
