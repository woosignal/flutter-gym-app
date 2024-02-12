//  WooGym
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/app/events/add_to_cart_event.dart';
import '/bootstrap/extensions.dart';
import '/bootstrap/helpers.dart';
import '/resources/pages/admin_class_detail_page.dart';
import '/resources/widgets/buttons.dart';
import '/resources/widgets/cached_image_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/product.dart';

class UserClassList extends StatefulWidget {
  final Product gymClass;
  final DateTime day;
  final bool adminViewer;
  UserClassList(
      {super.key,
      required this.gymClass,
      required this.day,
      this.adminViewer = false});

  @override
  createState() => _UserClassListState();
}

class _UserClassListState extends NyState<UserClassList> {
  String image() {
    if (widget.gymClass.images.isNotEmpty) {
      return widget.gymClass.images.first.src ??
          getEnv('PRODUCT_PLACEHOLDER_IMAGE');
    }
    return getEnv('PRODUCT_PLACEHOLDER_IMAGE');
  }

  @override
  Widget build(BuildContext context) {
    bool classAvailable = widget.day.isInFuture();
    if (!checkIfProductIsAvailableOnDate(widget.gymClass, widget.day)) {
      classAvailable = false;
    }

    return InkWell(
      onTap: () async {
        if (widget.adminViewer) {
          routeTo(AdminClassDetailPage.path, data: {
            "product": widget.gymClass,
            "day": formatToDateTime(widget.day)
          });
          return;
        }

        if (!classAvailable) {
          showToastOops(
              title: 'Not available'.tr(),
              description: 'This class is not bookable'.tr());
          return;
        }

        lockRelease('is_class_bookable', perform: () async {
          if (await isClassBookable(
                  product: widget.gymClass, day: widget.day) ==
              false) {
            showToastOops(
                title: 'Not available'.tr(),
                description: 'This class is not bookable'.tr());
            return;
          }

          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            builder: (context) {
              return SafeArea(
                child: Container(
                  height: 500,
                  color: Colors.transparent,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0),
                        ),
                      ),
                      child: Center(
                        child: Stack(
                          children: [
                            Positioned.fill(
                                child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(10.0),
                                topRight: const Radius.circular(10.0),
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(bottom: 36),
                                children: [
                                  Container(
                                    height: 150,
                                    child: CachedImageWidget(
                                      image: image(),
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ).faderBottom(5,
                                        color: ThemeColor.get(context)
                                            .primaryAccent),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      color:
                                          ThemeColor.get(context).primaryAccent,
                                    ),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(widget.gymClass.name ?? "")
                                                .headingMedium(context)
                                                .setColor(context,
                                                    (color) => Colors.white),
                                            Text(
                                              "${"Instructor".tr()}: ${widget.gymClass.instructor}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              widget.gymClass.price.toMoney(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ).expanded(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                widget.gymClass.classTime
                                                        .toTimeString() ??
                                                    "",
                                                style: textTheme.headlineMedium!
                                                    .copyWith(
                                                        color: Colors.white)),
                                            Text(widget.day.toShortDate(),
                                                style: textTheme.headlineSmall!
                                                    .copyWith(
                                                        color: Colors.white)),
                                          ],
                                        )
                                      ],
                                    ).paddingSymmetric(horizontal: 16),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: Text(parseHtmlString(
                                        widget.gymClass.description)),
                                  )
                                ],
                              ),
                            )),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    topRight: const Radius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(0, -3),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: AccentButton(
                                  title: "Book class".tr(),
                                  action: () async {
                                    pop();
                                    await event<AddToCartEvent>(data: {
                                      "gym_class": widget.gymClass,
                                      "day": widget.day
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )).animate().fadeIn(),
                ),
              );
            },
          );
        });
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: !classAvailable
                  ? Colors.grey.shade400
                  : context.colorStyles.primaryAccent),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${"Class".tr()}: ${widget.gymClass.name}",
                  maxLines: 2,
                ).setColor(context, (color) => Colors.black),
                if (widget.day.isInPast())
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Text(
                      'Finished'.tr(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${"Instructor".tr()}: ${widget.gymClass.instructor}",
                ),
                Text(widget.gymClass.classTime.toTimeString() ?? ""),
              ],
            ),
            if (isLocked('is_class_bookable')) Text("${"One moment".tr()}..."),
            if (!isLocked('is_class_bookable') && widget.adminViewer == false)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      classAvailable ? 'Available'.tr() : 'Not Available'.tr()),
                  Text(
                    widget.gymClass.price.toMoney(),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
