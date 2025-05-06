import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

typedef WidgetFunction<T> = Widget Function(T value);

class CardSlider extends StatefulWidget {
  // The List of Widgets for slider
  final List<Widget> cards;
  // Optional `blurValue` used for blurring the slider
  final double? blurValue;

  const CardSlider(
      {Key? key,
      required this.cards,
      this.slideChanged,
      this.blurValue = 0,
      this.blurOnClick,
      this.sliderBackGroundWidget,
      this.itemDotWidth = 10,
      this.bottomOffset = .0003,
      this.cardWidth = .9,
      this.cardHeight = .85,
      this.cardWidthOffset = .1,
      this.cardHeightOffset = .01,
      this.containerWidth = double.infinity,
      this.containerHeight = 500,
      this.containerColor = Colors.transparent,
      this.itemDotOffset = 0,
      this.itemDot})
      : super(key: key);

  @override
  State<CardSlider> createState() => _CardSliderState();

  // Optional Event fired when ever slide is changed, `(sliderIndex){  }` sliderIndex has a value of a current slide.
  final ValueChanged<void>? slideChanged;
  // Optional `blurOnClick` is method which listens if users clicks over blurred slider to be able to remove blurry
  final ValueChanged<void>? blurOnClick;
  // Optional widget which placed on the background of slider, can be placed logo or any other image or widget .
  final Widget? sliderBackGroundWidget;
  // Optional is a width of dots under slider showing current location.
  final double? itemDotWidth;
  // Optional is a double value, the height of a bottom of previous slide
  final double? bottomOffset;
  // Optional is a width of a slides
  final double? cardWidth;
  // Optional is a height of a slides
  final double? cardHeight;
  // Optional is a width which is used for how far slide must go on in horizontal distance when swiping or dragging
  final double? cardWidthOffset;
  // Optional is a height which is used for how far slide must go on in vertical distance when swiping or dragging
  final double? cardHeightOffset;
  // Optional is a widget by which can be changed the dots of th slider position
  final WidgetFunction<double>? itemDot;
  // Optional is a width of main Container
  final double? containerWidth;
  // Optional is a height of main Container
  final double? containerHeight;
  // Optional is a color of main Container
  final Color? containerColor;
  // Optional is a distance to position itemDot under slides
  final double? itemDotOffset;
}

class _CardSliderState extends State<CardSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double alignmentCenterY = Alignment.center.y;

  late Alignment _dragAlignment;
  late Alignment _dragAlignmentBack;
  double _dragAlignmentCenter = 0;

  late Animation<Alignment> _dragAlignmentAnim;
  late Animation<double> _dragAlignmentCenterAnim;
  late Animation<double> _containerSizeWidthAnim;
  late Animation<double> _containerSizeHeightAnim;
  late Animation<double> _itemDotWidthAnim;

  double _containerSizeWidth = 0;
  double _containerSizeHeight = 0;

  int _animationPhase = 0;
  bool animationPhase3 = false;

  List<int> valuesDataIndex = [];

  bool directionX = false;
  bool directionY = false;
  bool directionNegative = false;

  late double _cardWidth;
  late double _cardWidthOffset;
  late double _cardHeight;
  late double _cardHeightOffset;

  late double _bottomOffset;
  static const double _slideRightOffset = -18.0;
  static const double _slideLeftOffset = 5.55;
  static const double _slideTopOffset = -1.6;
  static const double _slideBottomOffset = 1.9;

  /// Calculates and runs a [SpringSimulation].
  void _cardToBackAnimation(Offset pixelsPerSecond, Size size) {
    directionY = false;
    directionX = false;

    _dragAlignmentAnim = _controller.drive(
      AlignmentTween(
          begin: _dragAlignment,
          end: Alignment(
              Alignment.center.x,
              alignmentCenterY +
                  0 //(showHide ? 0.1 * ((valuesData.length - 1) - 0) : 0)
              )),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 60,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  // move the card to a specific position, when the user finishes dragging,
  // 1. (first action) the card must be positioned to move the farthest location
  // 2. (second action) the card must be positioned to move to the initial position
  Alignment getTheAlignment(bool directionNegative,
      [bool withOutDirection = false]) {
    Alignment dragAlignmentSelect =
        directionNegative ? _dragAlignmentBack : _dragAlignment;

    return Alignment(
        Alignment.center.x +
            (directionX || withOutDirection
                ? (dragAlignmentSelect.x == 0 ||
                        dragAlignmentSelect.x.abs() < 0.1
                    ? 0
                    : (dragAlignmentSelect.x > 0
                        ? _slideLeftOffset
                        : _slideRightOffset))
                : 0),
        alignmentCenterY +
            (directionY || withOutDirection
                ? (dragAlignmentSelect.y + alignmentCenterYOffset * -1 == 0 ||
                        (dragAlignmentSelect.y + alignmentCenterYOffset * -1)
                                .abs() <
                            0.1
                    ? 0
                    : (dragAlignmentSelect.y + alignmentCenterYOffset * -1 > 0
                        ? _slideBottomOffset
                        : _slideTopOffset))
                : 0));
  }

  // When the user drag finished, if the distance is more than minimum to start the animation,
  // than the static animation process is initialized.
  // This is the first phase of animation start
  void _cardToStartAnimation(Offset pixelsPerSecond, Size size) {
    _dragAlignmentAnim = _controller.drive(
      AlignmentTween(
          begin: directionNegative ? _dragAlignmentBack : _dragAlignment,
          end: getTheAlignment(directionNegative)),
    );

    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 60,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller
        .animateWith(simulation)
        .then((value) => {_cardToFinishAnimation(pixelsPerSecond, size)});
  }

  // Set all values to initial state
  void _setInitialValues() {
    _containerSizeWidth = 0;
    _containerSizeHeight = 0;
    _dragAlignmentCenter = 0;

    directionY = false;
    directionX = false;

    if (widget.slideChanged != null) {
      widget.slideChanged!(valuesDataIndex.isEmpty ? 1 : valuesDataIndex[0]);
    }
  }

  // This is the second (last) phase of animation start
  void _cardToFinishAnimation(Offset pixelsPerSecond, Size size) {
    _setInitialValues();

    _animationPhase = 3;
    animationPhase3 = true;

    if (directionNegative) {
      int i = valuesDataIndex[valuesDataIndex.length - 1];
      valuesDataIndex.removeAt(valuesDataIndex.length - 1);
      valuesDataIndex.insert(0, i);

      _dragAlignment = _dragAlignmentBack;
      _dragAlignmentBack = Alignment(Alignment.center.x,
          alignmentCenterY + getAlignment(valuesDataIndex.length - 1));
    } else {
      int i = valuesDataIndex[0];
      valuesDataIndex.removeAt(0);
      valuesDataIndex.add(i);

      _dragAlignmentBack = _dragAlignment;
      _dragAlignment = Alignment(Alignment.center.x, alignmentCenterY);
    }

    _dragAlignmentCenterAnim =
        _controller.drive(Tween<double>(begin: 0, end: -1 * _bottomOffset));

    _itemDotWidthAnim =
        _controller.drive(Tween<double>(begin: 0, end: _itemDotWidth));

    _containerSizeWidthAnim =
        _controller.drive(Tween<double>(begin: 0, end: _cardWidthOffset));

    _containerSizeHeightAnim =
        _controller.drive(Tween<double>(begin: 0, end: _cardHeightOffset));

    _dragAlignmentAnim = _controller.drive(
      AlignmentTween(
          begin: getTheAlignment(!directionNegative, true),
          end: directionNegative
              ? Alignment(Alignment.center.x, alignmentCenterY)
              : Alignment(Alignment.center.x,
                  alignmentCenterY + getAlignment(valuesDataIndex.length - 1))),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 60,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation).then((value) => {
          _animationPhase = 0,
        });
  }

  @override
  void initState() {
    super.initState();

    _setInitialValues();

    alignmentCenterY += alignmentCenterYOffset;

    _dragAlignment = Alignment(Alignment.center.x, alignmentCenterY);
    _dragAlignmentBack = Alignment(Alignment.center.x, alignmentCenterY);

    for (int i = 0; i < widget.cards.length; i++) {
      valuesDataIndex.add(i);
    }

    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        if (_animationPhase == 0 || _animationPhase == 1) {
          directionNegative
              ? _dragAlignmentBack = _dragAlignmentAnim.value
              : _dragAlignment = _dragAlignmentAnim.value;
        }
        if (_animationPhase == 3) {
          directionNegative
              ? _dragAlignment = _dragAlignmentAnim.value
              : _dragAlignmentBack = _dragAlignmentAnim.value;

          _dragAlignmentCenter = _dragAlignmentCenterAnim.value;
          _containerSizeWidth = _containerSizeWidthAnim.value;
          _containerSizeHeight = _containerSizeHeightAnim.value;
          _itemDotWidth = _itemDotWidthAnim.value;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late var _size;

  bool runOnlyOnce = false;

  @override
  Widget build(BuildContext context) {
    if (!runOnlyOnce) {
      _size = MediaQuery.of(context).size;
      _itemDotWidth = widget.itemDotWidth ?? 10;
      _cardWidth = _size.width * widget.cardWidth;
      _cardHeight = _size.width * widget.cardHeight;
      _cardWidthOffset = _size.width * widget.cardWidthOffset;
      _cardHeightOffset = _size.width * widget.cardHeightOffset;
      _bottomOffset = _size.width * widget.bottomOffset;
      _dragAlignmentBack = Alignment(Alignment.center.x,
          alignmentCenterY + getAlignment(valuesDataIndex.length - 1));
      runOnlyOnce = true;
    }

    return Container(
        color: widget.containerColor,
        height: widget.containerHeight,
        width: widget.containerWidth,
        child: Stack(
          children: _sliderBody(),
        ));
  }

  // the main body, gesture detector, slide widgets
  List<Widget> _sliderBody() {
    return [
      if (widget.sliderBackGroundWidget != null) widget.sliderBackGroundWidget!,
      animatedBackCards(),
      GestureDetector(
        onPanDown: (details) {
          if (_animationPhase == 0) _controller.stop();
        },
        onPanUpdate: (details) {
                  if (_animationPhase == 0 && widget.blurValue == 0) {
            // Only allow right swipes (positive dx)
            if (details.delta.dx > 0) {
              if (!directionX && !directionY) {
                if (details.delta.dx != 0.0 && details.delta.dy != 0.0) {
                  directionX = details.delta.dx.abs() > details.delta.dy.abs();
                  directionY = !directionX;
                  directionNegative = details.delta.dx < 0;
                }
              }

              if (directionX) {
                setState(() {
                  _dragAlignment += Alignment(
                      details.delta.dx / (_size.width / 2),
                      0); // Only update horizontal position
                });
              }
            }
          }
        },
        onPanEnd: (details) {
 if (_animationPhase == 0 && widget.blurValue == 0) {
    if (details.velocity.pixelsPerSecond.dx < 0) {
    // Block left swipe animations completely
    return;
    }
    _cardToStartAnimation(details.velocity.pixelsPerSecond, _size);
    }
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: widget.blurValue!, sigmaY: widget.blurValue!),
          child: Container(
            width: _size.width,
            height: _size.height,
            color: const Color(0x0000ff77),
          ),
        ),
      ),
    ];
  }

  // each card which goes after must be located below
  double getAlignment(int i) {
    double bottomOffset = 0;
    if (i > 1) {
      bottomOffset += _bottomOffset * 2;
    } else if (i > 0) {
      bottomOffset += _bottomOffset;
    }

    return bottomOffset;
  }

  // each card which goes after must smaller
  // to make illusion if it was 3d or to show the user there is more cards to swipe
  double getWidth(int i) {
    double width = _cardWidth;

    if (i > 1) {
      width -= _cardWidthOffset * 2;
    } else if (i > 0) {
      width -= _cardWidthOffset;
    }

    return width;
  }

  // each card which goes after must smaller
  // to make illusion if it was 3d or to show the user there is more cards to swipe
  double getHeight(int i) {
    double height = _cardHeight;

    if (i > 1) {
      height -= _cardHeightOffset * 2;
    } else if (i > 0) {
      height -= _cardHeightOffset;
    }

    return height;
  }

  double alignmentCenterYOffset = -0.6;
  double _itemDotWidth = 10;

  // Optional is a widget by which can be changed the dots of th slider position
  Widget itemDot(double itemDotWidth) {
    return Container(
        margin: const EdgeInsets.all(5),
        width: 5 + itemDotWidth,
        height: 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ));
  }

  // navigation dots, slider not moving slides - background
  Widget animatedBackCards() {
    return Stack(
      children: [
        Align(
          alignment: Alignment(
              Alignment.center.x,
              Alignment.center.y +
                  alignmentCenterYOffset / 2 +
                  0.65 +
                  widget.itemDotOffset!),
          child: Row(
            children: [
              const Spacer(),
              for (int i = 0; i < valuesDataIndex.length; i++)
                (widget.itemDot != null
                    ? widget
                        .itemDot!((valuesDataIndex[0] == i ? _itemDotWidth : 0))
                    : itemDot((valuesDataIndex[0] == i ? _itemDotWidth : 0))),
              const Spacer()
            ],
          ),
        ),
        for (int i = (widget.cards.length - 1); i >= 0; i--)
          Align(
            alignment: (i == 0 || i == widget.cards.length - 1)
                ? (i == 0
                    ? Alignment(
                        _dragAlignment.x,
                        _dragAlignment.y +
                            _dragAlignmentCenter +
                            (animationPhase3 ? _bottomOffset : 0))
                    : _dragAlignmentBack)
                : Alignment(
                    Alignment.center.x,
                    alignmentCenterY +
                        getAlignment(i) +
                        _dragAlignmentCenter +
                        (animationPhase3 ? _bottomOffset : 0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                //color: valuesDataColors[valuesDataIndex[i]],
              ),
              width: getWidth(i) +
                  _containerSizeWidth +
                  (animationPhase3 ? -1 * _cardWidthOffset : 0),
              height: getHeight(i) +
                  _containerSizeHeight +
                  (animationPhase3 ? -1 * _cardHeightOffset : 0),
              child: widget.cards[valuesDataIndex[i]],
            ),
          )
      ],
    );
  }
}
