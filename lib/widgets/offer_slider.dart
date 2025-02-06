import 'package:flutter/material.dart';

class OfferSlider extends StatefulWidget {
  const OfferSlider({Key? key}) : super(key: key);

  @override
  _OfferSliderState createState() => _OfferSliderState();
}

class _OfferSliderState extends State<OfferSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  final List<Map<String, String>> offers = [
    {"image": "assets/images/food2.jpg", "title": "Buy 1 Get 1 Free!"},
    {"image": "assets/images/food1.jpg", "title": "Flat 50% Off on Burgers"},
    {
      "image": "assets/images/lemon_food.jpg",
      "title": "Pizza Mania - Extra Cheese Free!"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _pageController,
            itemCount: offers.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          offers[index]["image"]!,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Text(
                          offers[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            offers.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
