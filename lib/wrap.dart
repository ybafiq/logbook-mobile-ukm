import 'package:flutter/material.dart';

void main() {
  runApp(const MyWrapApp());
}

class MyWrapApp extends StatelessWidget {
  const MyWrapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wrap Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wrap Demo'),
        ),
        body: Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,

            children: [
              Container(
                width: 80,
                height: 80,
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.blue,
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.green,
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.black,
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.teal,
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.grey,
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
