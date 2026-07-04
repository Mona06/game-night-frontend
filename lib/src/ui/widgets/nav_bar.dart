import 'package:flutter/material.dart';

class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Text? title;

  const TopNavigationBar({super.key, this.leading, this.title});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'GameNight',
        style: Theme.of(context)
            .textTheme
            .displayLarge
            ?.copyWith(color: Colors.white),
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      leading: leading,
      elevation: 0,
    );
  }
}
