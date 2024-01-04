import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../pages/book_a_class_page.dart';

class BookAClass extends StatelessWidget {
  const BookAClass({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                "https://womensfitness.co.uk/wp-content/uploads/sites/3/2020/06/shutterstock_1221827803.jpg",
                fit: BoxFit.cover,
              ).faderBottom(3),
            ),
            Positioned.fill(
                child: Container(
              alignment: Alignment.center,
              child: Text("Book a class",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.white)),
            )),
            Positioned(
              child: Container(
                padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                child: Text('HIIT, Strength, Yoga, Pilates, and more',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white.withOpacity(0.8))),
              ),
              bottom: 0,
              left: 0,
              right: 0,
            )
          ],
        ),
      ),
    ).onTapRoute(BookAClassPage.path);
  }
}
