import 'package:flutter/material.dart';
import 'package:tf/repositories/menu_repository.dart';
import 'package:tf/screens/product_list_screen.dart';
import 'package:tf/utils/collectionArguments.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

List<List<Color>> gradients = [
  [Colors.red, Colors.red.shade300],
  [Colors.blue, Colors.blue.shade300],
  [Colors.orange, Colors.orange.shade300],
  [Colors.green, Colors.green.shade300]
];

class MenuItem extends StatelessWidget {
  static double kMinRadius = 150.0;
  static double kMaxRadius = 350.0;
  static Interval opacityCurve =
      const Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);
  static RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  final BuildContext context;
  final MenuNode menuNode;
  final int totalCount;
  final int index;

  MenuItem(
      {required this.context,
      required this.menuNode,
      required this.totalCount,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kMinRadius,
      height: MediaQuery.of(context).size.height / (totalCount + 1.3),
      child: Hero(
        createRectTween: _createRectTween,
        tag: index.toString(),
        child: RadialExpansion(
          maxRadius: kMaxRadius,
          child: MenuItemDetail(
            description: this.menuNode.title,
            index: index,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder<void>(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (BuildContext context, Widget? child) {
                        return Opacity(
                          opacity: opacityCurve.transform(animation.value),
                          child: _buildPage(context, this.menuNode, index),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static Widget _buildPage(BuildContext context, MenuNode node, int index) {
    return Container(
      child: Material(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.5,
            child: Hero(
              createRectTween: _createRectTween,
              tag: index.toString(),
              child: RadialExpansion(
                maxRadius: kMaxRadius,
                child: MenuItemDetail(
                  index: index,
                  description: node.title,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
          Expanded(
              child: ListView.separated(
            shrinkWrap: true,
            itemCount: node.child.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (BuildContext context, int subItemIndex) {
              return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ProductListScreen.routeName,
                      arguments: CollectionArguments(
                          node.child[subItemIndex].title,
                          node.child[subItemIndex].id),
                    );
                  },
                  child: ListTile(
                    title: Text(node.child[subItemIndex].title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold)),
                  ));
            },
          ))
        ],
      )),
    );
  }
}

class MenuItemDetail extends StatelessWidget {
  const MenuItemDetail({Key? key, required this.description, this.onTap, required this.index})
      : super(key: key);

  final String description;
  final VoidCallback? onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: InkWell(
            onTap: onTap,
            child: new Center(
                child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: new LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradients[index])),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(bottom: 20, left: 20),
                child: Text(description,
                    textScaleFactor: 2,
                    style: new TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: CustomPaint(
                  size: Size(100, 150),
                  painter: CustomCardShapePainter(
                      24,
                      gradients[index][0],
                      gradients[index][1]),
                ),
              ),
              // Positioned(
              //     left: 20,
              //     bottom: 0,
              //     top: 0,
              //     child: CircleAvatar(
              //       radius: 50,
              //       backgroundColor: Colors.white.withOpacity(0.2),
              //       child: Container(
              //           // color: Colors.white.withOpacity(0.2),
              //           child: Image.asset(
              //         'images/menu_item.png',
              //         height: 150.0,
              //         width: 100.0,
              //       )),
              //     )),
            ]))));
  }
}

class RadialExpansion extends StatelessWidget {
  const RadialExpansion({
    Key? key,
    required this.maxRadius,
    this.child,
  })  : clipRectExtent = 2.0 * (maxRadius / math.sqrt2),
        super(key: key);

  final double maxRadius;
  final double clipRectExtent;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(0), child: child);
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 8.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
