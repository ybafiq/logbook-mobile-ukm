import 'package:flutter/material.dart';

void main() {
  runApp(const MyStackApp());
}

class MyStackApp extends StatelessWidget {
  const MyStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stack Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stack Demo'),
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,

            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.red,
                    shape:BoxShape.circle,
                    border: Border.all(
                      color: Colors.black26,
                      width: 4,),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(5, 5),
                        ),
                      ],
                    //borderRadius: BorderRadius.circular(100),
                ),
              ),

              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                ),
              ),

              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(100),
                ),
              ),
              
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(100),
                ),
              ),

              const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 40,
              ),

              /*const Text(
                'Centered Text',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),*/
            ],
          ),
        ),
      ),  
    );
  }
}
