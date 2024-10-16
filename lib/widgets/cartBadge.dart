import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShoppingCartBadge extends StatelessWidget {
  final int itemCount;
  const ShoppingCartBadge({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.shopping_bag_outlined,size: 30,color: Colors.black,),
          onPressed: () {
          },
        ),
        Positioned(
          right: 0,
          top: 0,
          child: itemCount > 0
              ? Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              itemCount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
