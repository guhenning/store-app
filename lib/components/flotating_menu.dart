import 'package:flutter/material.dart';
import 'package:store/providers/product_list.dart';

import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/prime.dart';

class FlotatingMenu extends StatefulWidget {
  const FlotatingMenu({super.key});

  @override
  State<FlotatingMenu> createState() => _FlotatingMenuState();
}

class _FlotatingMenuState extends State<FlotatingMenu> {
  final isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.titleMedium?.color);
    return SpeedDial(
      elevation: 0.0,
      icon: CupertinoIcons.slider_horizontal_3,
      activeIcon: Icons.close_rounded,
      //animatedIcon: AnimatedIcons.menu_close,
      activeBackgroundColor: Theme.of(context).hintColor,
      backgroundColor: Theme.of(context)
          .hintColor
          .withOpacity(0.6), //Theme.of(context).hintColor

      foregroundColor: Theme.of(context).iconTheme.color,
      // overlayColor: Colors.black,
      // overlayOpacity: 0.4,
      spacing: 10,
      spaceBetweenChildren: 12,
      openCloseDial: isDialOpen,
      children: [
        SpeedDialChild(
          //shape: const CircleBorder(),
          //backgroundColor: Colors.black,
          label: 'Restore Original Order',
          child: const Icon(Icons.abc_rounded),
          labelStyle: textStyle,
          onTap: () {
            Provider.of<ProductList>(context, listen: false)
                .restoreOriginalOrder(context);
          },
        ),
        SpeedDialChild(
          label: 'Short By Store Name Z - A',
          child: const Iconify(
            Prime.sort_alpha_up,
          ),
          labelStyle: textStyle,
          onTap: () {
            Provider.of<ProductList>(context, listen: false)
                .reorderProductsByStoreNameZA();
          },
        ),
        SpeedDialChild(
          label: 'Short By Store Name A - Z',
          child: const Iconify(
            Prime.sort_alpha_down,
          ),
          labelStyle: textStyle,
          onTap: () {
            Provider.of<ProductList>(context, listen: false)
                .reorderProductsByStoreNameAZ();
          },
        ),
        SpeedDialChild(
          label: 'Short By Price High to Low',
          child: const Iconify(
            Prime.sort_numeric_up,
          ),
          labelStyle: textStyle,
          onTap: () {
            Provider.of<ProductList>(context, listen: false)
                .reorderProductsByPriceHighToLow();
          },
        ),
        SpeedDialChild(
          label: 'Short By Price Low To High',
          child: const Iconify(
            Prime.sort_numeric_down,
          ),
          labelStyle: textStyle,
          onTap: () {
            Provider.of<ProductList>(context, listen: false)
                .reorderProductsByPriceLowToHigh();
          },
        ),
        SpeedDialChild(
          label: 'Short By Product Name Z - A',
          child: const Icon(Icons.sort_by_alpha),
          labelStyle: textStyle,
          onTap: () {
            Provider.of<ProductList>(context, listen: false)
                .reorderProductsByNameZA();
          },
        ),
        SpeedDialChild(
          label: 'Short By Product Name A - Z',
          child: const Icon(Icons.sort_by_alpha),
          labelStyle: textStyle,
          onTap: () {
            Provider.of<ProductList>(context, listen: false)
                .reorderProductsByNameAZ();
          },
        ),
      ],
    );
  }
}
