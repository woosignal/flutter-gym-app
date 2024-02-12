//  WooGym
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '/app/models/cart.dart';
import '/app/models/cart_line_item.dart';
import '/app/models/checkout_session.dart';
import '/bootstrap/app_helper.dart';
import '/bootstrap/helpers.dart';
import '/resources/themes/styles/color_styles.dart';
import '/resources/widgets/cached_image_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/product.dart';
import 'package:woosignal/models/response/tax_rate.dart';

class CheckoutRowLine extends StatelessWidget {
  const CheckoutRowLine(
      {super.key,
      required this.heading,
      required this.leadImage,
      required this.leadTitle,
      required this.action,
      this.showBorderBottom = true});

  final String heading;
  final String? leadTitle;
  final Widget leadImage;
  final Function() action;
  final bool showBorderBottom;

  @override
  Widget build(BuildContext context) => Container(
        height: 115,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade50,
            border: showBorderBottom == true
                ? Border(
                    bottom: BorderSide(color: Colors.black12, width: 1),
                  )
                : null),
        child: InkWell(
          onTap: action,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                child: Text(
                  heading,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.only(bottom: 8),
              ),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                leadTitle!,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                              margin: EdgeInsets.only(right: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.shade500,
                      size: 18,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}

class TextEditingRow extends StatelessWidget {
  const TextEditingRow({
    super.key,
    this.heading,
    this.controller,
    this.shouldAutoFocus,
    this.keyboardType,
    this.obscureText,
  });

  final String? heading;
  final TextEditingController? controller;
  final bool? shouldAutoFocus;
  final TextInputType? keyboardType;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    ColorStyles colorStyles = ThemeColor.get(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (heading != null)
            Flexible(
              child: Padding(
                child: AutoSizeText(
                  heading!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: ThemeColor.get(context).primaryContent),
                ),
                padding: EdgeInsets.only(bottom: 2),
              ),
            ),
          TextField(
            cursorColor: colorStyles.primaryAccent,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorStyles.primaryAccent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorStyles.primaryAccent),
              ),
            ),
            controller: controller,
            style: TextStyle(color: colorStyles.primaryContent),
            keyboardType: keyboardType ?? TextInputType.text,
            autocorrect: false,
            autofocus: shouldAutoFocus ?? false,
            obscureText: obscureText ?? false,
            textCapitalization: TextCapitalization.sentences,
          ).flexible()
        ],
      ),
      padding: EdgeInsets.all(2),
      height: heading == null ? 50 : 78,
    );
  }
}

class CheckoutMetaLine extends StatelessWidget {
  const CheckoutMetaLine({super.key, this.title, this.amount});

  final String? title, amount;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Container(
                child: AutoSizeText(title!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
              flex: 3,
            ),
            Flexible(
              child: Container(
                child:
                    Text(amount!, style: Theme.of(context).textTheme.bodyLarge),
              ),
              flex: 3,
            )
          ],
        ),
      );
}

List<BoxShadow> wsBoxShadow({double? blurRadius}) => [
      BoxShadow(
        color: Color(0xFFE8E8E8),
        blurRadius: blurRadius ?? 15.0,
        spreadRadius: 0,
        offset: Offset(
          0,
          0,
        ),
      )
    ];

class ProductItemContainer extends StatelessWidget {
  const ProductItemContainer({
    super.key,
    this.product,
    this.onTap,
  });

  final Product? product;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return SizedBox.shrink();
    }

    double height = 280;
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(4),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3.0),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.grey[100],
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    CachedImageWidget(
                      image: (product!.images.isNotEmpty
                          ? product!.images.first.src
                          : getEnv("PRODUCT_PLACEHOLDER_IMAGE")),
                      fit: BoxFit.contain,
                      height: height,
                      width: double.infinity,
                    ),
                    if (isProductNew(product))
                      Container(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          "New",
                          style: TextStyle(color: Colors.white),
                        ),
                        decoration: BoxDecoration(color: Colors.black),
                      ),
                    if (product!.onSale! && product!.type != "variable")
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: '',
                              style: Theme.of(context).textTheme.bodyLarge,
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      "${workoutSaleDiscount(salePrice: product!.salePrice, priceBefore: product!.regularPrice)}% ${trans("off")}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 2, bottom: 2),
              child: Text(
                product!.name!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "${formatStringCurrency(total: product!.price)} ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w800),
                    textAlign: TextAlign.left,
                  ),
                  if (product!.onSale! && product!.type != "variable")
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '${trans("Was")}: ',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 11,
                                  ),
                        ),
                        TextSpan(
                          text: formatStringCurrency(
                            total: product!.regularPrice,
                          ),
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                        ),
                      ]),
                    ),
                ].toList(),
              ),
            ),
          ],
        ),
      ),
      onTap: () => onTap != null
          ? onTap!(product)
          : Navigator.pushNamed(context, "/product-detail", arguments: product),
    );
  }
}

wsModalBottom(BuildContext context,
    {String? title, Widget? bodyWidget, Widget? extraWidget}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (builder) {
      return SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ThemeColor.get(context).background,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow:
                          (Theme.of(context).brightness == Brightness.light)
                              ? wsBoxShadow()
                              : null,
                      color: ThemeColor.get(context).background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: bodyWidget,
                  ),
                ),
                if (extraWidget != null) extraWidget
              ],
            ),
          ),
        ),
      );
    },
  );
}

class CheckoutTotal extends StatelessWidget {
  const CheckoutTotal({super.key, this.title, this.taxRate});

  final String? title;
  final TaxRate? taxRate;

  @override
  Widget build(BuildContext context) => NyFutureBuilder<String>(
        future: CheckoutSession.getInstance
            .total(withFormat: true, taxRate: taxRate),
        child: (BuildContext context, data) => Padding(
          child: CheckoutMetaLine(title: title, amount: data),
          padding: EdgeInsets.only(bottom: 0, top: 15),
        ),
        loading: SizedBox.shrink(),
      );
}

class CheckoutTaxTotal extends StatelessWidget {
  const CheckoutTaxTotal({super.key, this.taxRate});

  final TaxRate? taxRate;

  @override
  Widget build(BuildContext context) => NyFutureBuilder<String>(
        future: Cart.getInstance.taxAmount(taxRate),
        child: (BuildContext context, data) => (data == "0"
            ? Container()
            : Padding(
                child: CheckoutMetaLine(
                  title: trans("Tax"),
                  amount: formatStringCurrency(total: data),
                ),
                padding: EdgeInsets.only(bottom: 0, top: 0),
              )),
      );
}

class CheckoutSubtotal extends StatelessWidget {
  const CheckoutSubtotal({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) => NyFutureBuilder<String>(
        future: Cart.getInstance.getSubtotal(withFormat: true),
        child: (BuildContext context, data) => Padding(
          child: CheckoutMetaLine(
            title: title,
            amount: data,
          ),
          padding: EdgeInsets.only(bottom: 0, top: 0),
        ),
        loading: SizedBox.shrink(),
      );
}

class CartItemContainer extends StatelessWidget {
  const CartItemContainer({
    super.key,
    required this.cartLineItem,
    required this.actionIncrementQuantity,
    required this.actionDecrementQuantity,
    required this.actionRemoveItem,
  });

  final CartLineItem cartLineItem;
  final void Function() actionIncrementQuantity;
  final void Function() actionDecrementQuantity;
  final void Function() actionRemoveItem;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(bottom: 7),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black12,
              width: 1,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: CachedImageWidget(
                    image: (cartLineItem.imageSrc == ""
                        ? getEnv("PRODUCT_PLACEHOLDER_IMAGE")
                        : cartLineItem.imageSrc),
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  flex: 2,
                ),
                Flexible(
                  child: Padding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          cartLineItem.name!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        (cartLineItem.variationOptions != null
                            ? Text(cartLineItem.variationOptions!,
                                style: Theme.of(context).textTheme.bodyLarge)
                            : Container()),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              (cartLineItem.stockStatus == "outofstock"
                                  ? trans("Out of stock")
                                  : trans("In Stock")),
                              style: (cartLineItem.stockStatus == "outofstock"
                                  ? Theme.of(context).textTheme.bodySmall
                                  : Theme.of(context).textTheme.bodyMedium),
                            ),
                            Text(
                              formatDoubleCurrency(
                                total: parseWcPrice(cartLineItem.total),
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(left: 8),
                  ),
                  flex: 5,
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: actionDecrementQuantity,
                      highlightColor: Colors.transparent,
                    ),
                    Text(cartLineItem.quantity.toString(),
                        style: Theme.of(context).textTheme.titleLarge),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: actionIncrementQuantity,
                      highlightColor: Colors.transparent,
                    ),
                  ],
                ),
                IconButton(
                  alignment: Alignment.centerRight,
                  icon: Icon(Icons.delete_outline,
                      color: Colors.deepOrangeAccent, size: 20),
                  onPressed: actionRemoveItem,
                  highlightColor: Colors.transparent,
                ),
              ],
            )
          ],
        ),
      );
}

class StoreLogo extends StatelessWidget {
  const StoreLogo(
      {super.key,
      this.height = 100,
      this.width = 100,
      this.color = Colors.black,
      this.placeholder = const CircularProgressIndicator(),
      this.fit = BoxFit.contain,
      this.showBgWhite = true});

  final bool showBgWhite;
  final double height;
  final double width;
  final Widget placeholder;
  final BoxFit fit;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            image: NetworkImage(
              AppHelper.instance.appConfig?.appLogo ?? "https://woosignal.com/images/woosignal_logo_stripe_blue.png",
            ),
          ),
        ),
      );
}
