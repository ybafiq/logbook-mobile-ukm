import 'package:flutter/material.dart';

void main() {
  runApp(const MyColumnApp());
}

class MyColumnApp extends StatelessWidget {
  const MyColumnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Column Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 80,
                  color: Colors.teal,
                  child: const Center(child: Text (
                                                    'Box 1', 
                                                     style:TextStyle(color: Colors.white, 
                                                     letterSpacing: 2,wordSpacing: 2, 
                                                     shadows: [ 
                                                                Shadow(
                                                                color: Colors.black45,
                                                                offset: Offset(2, 2),
                                                                blurRadius: 3,
                                                              ),
                                                            ],
                                                        )
                                                      )
                                                    )
                                                  ),
              const SizedBox(height: 20),
              

              Container(
                width: 150,
                height: 80,
                  color: Colors.orange,
                  child: const Center(child: Text (
                                                    'Box 2',
                                                    style:TextStyle(color: Colors.white, 
                                                    letterSpacing: 2,wordSpacing: 2, 
                                                    shadows: [ 
                                                                Shadow(
                                                                color: Colors.black45,
                                                                offset: Offset(2, 2),
                                                                blurRadius: 3,
                                                              ),
                                                            ],
                                                        )
                                                      )
                                                    )
                                                  ),
              const SizedBox(height: 20),

              Container(
                width: 150,
                height: 80,
                  color: Colors.purple,
                  child: const Center(child: Text (
                                                    'Box 3',
                                                    style:TextStyle(color: Colors.white, 
                                                    letterSpacing: 2,wordSpacing: 2, 
                                                    shadows: [ 
                                                                Shadow(
                                                                color: Colors.black45,
                                                                offset: Offset(2, 2),
                                                                blurRadius: 3,
                                                              ),
                                                            ],
                                                        )
                                                      )
                                                    )
                                                  ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}