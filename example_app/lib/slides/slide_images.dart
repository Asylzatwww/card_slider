import 'package:card_slider/card_slider.dart';
import 'package:flutter/material.dart';

class SlideImages extends StatelessWidget {
  const SlideImages({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> valuesWidget = [];

    List<String> valuesUrl = [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Shaqi_jrvej.jpg/1200px-Shaqi_jrvej.jpg',
      'https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg',
      'https://www.eea.europa.eu/themes/biodiversity/state-of-nature-in-the-eu/state-of-nature-2020-subtopic/image_print'
    ];

    for (int i = 0; i < valuesUrl.length; i++) {
      valuesWidget.add(
        Image.network(valuesUrl[i]),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Gallery",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF33a000)),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF33a000),
          ),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CardSlider(
        cards: valuesWidget,
        bottomOffset: .0008,
        itemDotWidth: 14,
        itemDotOffset: 0.15,
        itemDot: (itemDotWidth) {
          return Container(
              margin: const EdgeInsets.all(5),
              width: 8 + itemDotWidth,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF33a000),
              ));
        },
      ),
    );
  }
}
