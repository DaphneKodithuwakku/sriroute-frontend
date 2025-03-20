import 'package:flutter/material.dart';


class WelcomePage3 extends StatelessWidget {
  const WelcomePage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/welcomepage3.png', fit: BoxFit.fitWidth, alignment: Alignment.topCenter),
          ),
          // Bottom Card with Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 325,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    " A Journey Through Hindu Devotion",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      height: 1,
                      fontSize: 35,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 12), // Added more space
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Experience the beauty of kovils, vibrant festivals, and timeless traditions.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.2,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  SizedBox(height: 25), // Added more space
                  // Navigation Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        child: Icon(
                          Icons.circle,
                          size: 10,
                          color: index == 0 ? Colors.black : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 45),
                  // Buttons Row with Centered FAB
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                          ), // Placeholder space for alignment
                        ],
                      ),
                      // Centered FAB
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WelcomePage3(),
                            ),
                          );
                        },
                        backgroundColor: Colors.black,
                        shape: CircleBorder(),
                        child: Icon(Icons.arrow_right_alt, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
