import 'package:fix_mates_admin/util/responsive.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.menu,
                  color: Colors.grey,
                  size: 25,
                ),
              ),
            ),
          ),
        if (Responsive.isMobile(context))
          InkWell(
            onTap: () => Scaffold.of(context).openEndDrawer(),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.asset(
                "assets/userr.png",
                width: 32,
              ),
            ),
          ),
      ],
    );
  }
}
