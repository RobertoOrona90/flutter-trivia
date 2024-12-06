import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:trivia/QuestionModel.dart';
import 'package:trivia/widgets/answer_card.dart';

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
          return AnswerdCard(
              height: cardHeight, width: cardWidth, answer: answers[index]);
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
            Color activeColor = Colors.white;
            Color color = Colors.grey.withOpacity(.3);
            double size = 10.0;
            double space = 5.0;
            if (config.indicatorLayout != PageIndicatorLayout.NONE &&
                config.layout == SwiperLayout.DEFAULT) {
              return PageIndicator(
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