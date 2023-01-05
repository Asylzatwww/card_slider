import 'dart:io';

import 'package:example/slides/slide_images.dart';
import 'package:example/slides/slide_widget.dart';
import 'package:flutter/material.dart';
import 'package:card_slider/card_slider.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MaterialApp(home: MainPage(title: "Card Slider",)));
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
    if (1 == 2)
    for (int i = 0; i < valuesDataColors.length; i++)
      valuesWidget.add(
          Container(
          color: valuesDataColors[i],
          child: Text( i.toString() ),
          )
      );

    List<String> valuesUrl = [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Shaqi_jrvej.jpg/1200px-Shaqi_jrvej.jpg',
      'https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg',
      'https://www.eea.europa.eu/themes/biodiversity/state-of-nature-in-the-eu/state-of-nature-2020-subtopic/image_print'
    ];

    for (int i = 0; i < valuesUrl.length; i++)
      valuesWidget.add(
        Image.network( valuesUrl[i] ),
      );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:

      Scaffold(
        backgroundColor:
        Colors.white,
        //Color(0xFF1560BD),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          //backgroundColor: Color(0x44000000),
          elevation: 0,
          title: Text("Gallery",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF33a000)),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF33a000),),
            tooltip: 'Back',
            onPressed: () {
              // handle the press
            },
          ),
        ),
        body:

        CardSlider(
          cards: valuesWidget,
          bottomOffset: .0006,
          itemDotWidth: 14,

          itemDot:

              (itemDotWidth){
            return Container(
                margin: EdgeInsets.all(5),
                width: 8 + itemDotWidth,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF33a000),
                )
            );
          }

          ,

        )
        //const MyHomePage(title: 'Flutter Demo Home Page')
        ,
      )
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            TextButton(
              onPressed: () {

                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        SlideImages()
                ));

              },
              child: Text("Slide images"),
            ),

            SizedBox(height: 20,),

            TextButton(
              onPressed: () {

                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    SlideWidget()
                ));

              },
              child: Text("Slide widget"),
            ),

          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
