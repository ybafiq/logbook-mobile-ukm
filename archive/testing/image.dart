import 'package:flutter/material.dart';

void main() {
  runApp(const MyImageApp());
}

class MyImageApp extends StatelessWidget {
  const MyImageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Image Example'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 20),
                
                const Text('Network Image'),
                Image.network(
                  'https://www.fgvholdings.com/wp-content/uploads/2019/11/placeholder-logo.png',
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),

                const SizedBox(height: 20),

                const Text('Assets Image'),
                Image.asset(
                  'lib/assets/saji.png',
                  width: 150,
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
          
  

