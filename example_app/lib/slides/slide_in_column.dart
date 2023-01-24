import 'package:card_slider/card_slider.dart';
import 'package:flutter/material.dart';

class SlideInColumn extends StatefulWidget {
  const SlideInColumn({super.key});

  @override
  State<SlideInColumn> createState() => _SlideInColumnState();
}

class _SlideInColumnState extends State<SlideInColumn> {
  bool _dragOverMap = false;
  final GlobalKey _pointerKey = GlobalKey();

  _checkDrag(Offset position, bool up) {
    if (!up) {
      // find your widget
      RenderBox box =
          _pointerKey.currentContext!.findRenderObject() as RenderBox;

      //get offset
      Offset boxOffset = box.localToGlobal(Offset.zero);

      // check if your pointerdown event is inside the widget (you could do the same for the width, in this case I just used the height)
      if (position.dy > boxOffset.dy &&
          position.dy < boxOffset.dy + box.size.height) {
        setState(() {
          _dragOverMap = true;
        });
      }
    } else {
      setState(() {
        _dragOverMap = false;
      });
    }
  }

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
      appBar: AppBar(
        title: const Text("Slide inside column widget"),
      ),
      body: Listener(
        onPointerUp: (ev) {
          _checkDrag(ev.position, true);
        },
        onPointerDown: (ev) {
          _checkDrag(ev.position, false);
        },
        child: ListView(
          // if dragging over your widget, disable scroll, otherwise allow scrolling
          physics: _dragOverMap
              ? const NeverScrollableScrollPhysics()
              : const ScrollPhysics(),
          children: [
            Column(
              children: [
                for (int i = 0; i < 3; i++)
                  const ListTile(title: Text("Tile to scroll")),
                const Divider(),
              ],
            ),
            // Your widget that you want to prevent to scroll the Listview
            Container(
              color: Colors.amberAccent,
              key: _pointerKey, // key for finding the widget
              height: 350,
              width: double.infinity,
              child: CardSlider(
                cards: valuesWidget,
                bottomOffset: .0008,
                cardHeight: 0.75,
                containerHeight: MediaQuery.of(context).size.height - 100,
                itemDotOffset: 0.55,
              ),
            ),
            Column(
              children: [
                for (int i = 0; i < 3; i++)
                  const ListTile(title: Text("Tile to scroll")),
                const Divider(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
