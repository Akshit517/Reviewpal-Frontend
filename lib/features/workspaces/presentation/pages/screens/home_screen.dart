import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
          child: Row(children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(8), 
                child: Column(
                  children: [
                    Circul
                  ],
                ),)),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                
              ]))
          ],),
        );
        }
      ),
    );
  }
}