import 'package:flutter/material.dart';

void main() {
  runApp(PersonalCard());
}

class PersonalCard extends StatelessWidget {
  const PersonalCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Personal Card",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 115,
                backgroundImage: AssetImage('images/ubermarginal.jpg'),
              ),
              const SizedBox(height: 10),
              const Text(
                "Eldaras Zutautas",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'DancingScript',
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: const Color.fromARGB(255, 172, 218, 240),
                  width: 325,
                  height: 128,
                  padding: const EdgeInsets.all(10.0),
                  child: const Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 3),
                            Text(
                              "Student at Linnaeus University",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.mail, color: Color.fromARGB(255, 143, 141, 140)),
                            SizedBox(width: 7),
                            Text(
                              "E-mail: ez222eq@student.lnu.se",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.phone, color: Color.fromARGB(255, 143, 141, 140)),
                            SizedBox(width: 7),
                            Text(
                              "Phone: 0470 - 33 88 90",
                                style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.web_asset_outlined, color: Color.fromARGB(255, 143, 141, 140)),
                            SizedBox(width: 7),
                            Text(
                              "Github: @Aquses",
                                style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}