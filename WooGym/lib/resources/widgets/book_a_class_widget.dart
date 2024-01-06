//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

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
              child: Image.asset(
                "book_a_class_hero.png",
                fit: BoxFit.cover,
              ).localAsset().faderBottom(3),
            ),
            Positioned.fill(
                child: Container(
              alignment: Alignment.center,
              child: Text("Book a class".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.white)),
            )),
            Positioned(
              child: Container(
                padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                child: Text(getEnv('GYM_TYPE_OF_CLASSES'),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
