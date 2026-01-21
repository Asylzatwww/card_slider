import 'package:flutter/material.dart';
import 'package:card_slider/card_slider.dart';

void main() {
  runApp(const MaterialApp(home: MainPage()));
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    List<Color> valuesDataColors = [
      Colors.purple,
      Colors.yellow,
      Colors.green,
      Colors.red,
      Colors.grey,
      Colors.blue,
    ];

    List<Widget> valuesWidget = [];
    for (int i = 0; i < valuesDataColors.length; i++) {
      valuesWidget.add(Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: valuesDataColors[i],
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              i.toString(),
              style: const TextStyle(
                fontSize: 28,
              ),
            ),
          )));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1560BD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Cards",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: CardSlider(
        cards: valuesWidget,
        slideChanged: (index){
          debugPrint("Current index of slide is");
          debugPrint(index.toString());
        },
        bottomOffset: .0003,
        cardHeight: 0.75,
        containerHeight: MediaQuery.of(context).size.height - 100,
        itemDotOffset: -0.05,
      ),
    );
  }
}
