import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:trivia/QuestionModel.dart';

class CardSwiperList extends StatelessWidget {
  List<Answer> answers;

  final SwiperController swiperController = SwiperController();

  CardSwiperList({required this.answers});

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height / 2.7;
    double cardWidth = MediaQuery.of(context).size.width / 1.8;
    const Color mediumYellow = Color(0xffFDB846);

    return SizedBox(
      height: cardHeight,
      child: Swiper(
        itemCount: answers.length,
        itemBuilder: (_, index) {
          return ProductCard(
              height: cardHeight, width: cardWidth, product: answers[index]);
        },
        scale: 0.8,
        controller: swiperController,
        viewportFraction: 0.6,
        loop: false,
        fade: 0.5,
        pagination: SwiperCustomPagination(
          builder: (context, config) {
            if (config.itemCount > 20) {
              print(
                  "The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotSwiperPaginationBuilder in this sitituation");
            }
            Color activeColor = mediumYellow;
            Color color = Colors.grey.withOpacity(.3);
            double size = 10.0;
            double space = 5.0;

            if (config.indicatorLayout != PageIndicatorLayout.NONE &&
                config.layout == SwiperLayout.DEFAULT) {
              return new PageIndicator(
                count: config.itemCount,
                controller: config.pageController!,
                layout: config.indicatorLayout,
                size: size,
                activeColor: activeColor,
                color: color,
                space: space,
              );
            }

            List<Widget> dots = [];

            int itemCount = config.itemCount;
            int activeIndex = config.activeIndex;

            for (int i = 0; i < itemCount; ++i) {
              bool active = i == activeIndex;
              dots.add(Container(
                key: Key("pagination_$i"),
                margin: EdgeInsets.all(space),
                child: ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? activeColor : color,
                    ),
                    width: size,
                    height: size,
                  ),
                ),
              ));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: dots,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Answer product;
  final double height;
  final double width;

  const ProductCard({
    required this.product,
    required this.height,
    required this.width,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Color defaultGrayColor = const Color.fromARGB(68, 68, 68, 68);
  Color answerColor = Color.fromARGB(68, 68, 68, 68);
  String responseAnswer = "";
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('hi');
      },
      onLongPress: () {
        setState(() {
          if (widget.product.isCorrect) {
            answerColor = Colors.blue;
            responseAnswer = "Correcta";
          } else {
            answerColor = Colors.red;
            responseAnswer = "Incorrecta";
          }
        });
      },
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 30),
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: defaultGrayColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.abc),
                  onPressed: () {},
                  color: const Color.fromARGB(68, 68, 68, 68),
                ),
                Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.product.text,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16.0),
                          ),
                        )),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 12.0, 4.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          color: answerColor,
                        ),
                        child: Text(
                          responseAnswer,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            child: Hero(
              tag: widget.product.image,
              child: Image.network(
                widget.product.image,
                height: widget.height / 1.7,
                width: widget.width / 1.4,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
