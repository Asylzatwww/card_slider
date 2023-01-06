import 'package:card_slider/card_slider.dart';
import 'package:flutter/material.dart';

class SlideWidget extends StatelessWidget {
  const SlideWidget({super.key});

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
        valuesWidget.add(
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: valuesDataColors[i],
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text( i.toString(), style: const TextStyle( fontSize: 28,  ), ),
              )
            )
        );
      }

    return
        Scaffold(
          backgroundColor: const Color(0xFF1560BD),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text("Cards",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white,),
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body:
          CardSlider(
            cards: valuesWidget,
            bottomOffset: .0003,
            cardHeight: 0.75,
          )
    );
  }
}