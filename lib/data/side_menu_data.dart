import 'package:fix_mates_admin/model/menu_model.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Dashboard'),
    MenuModel(icon: Icons.person, title: 'New User Request'),
    MenuModel(icon: Icons.run_circle, title: 'Service Partners'),
    MenuModel(icon: Icons.category, title: 'Bookings'),
    MenuModel(icon: Icons.money, title: 'Transactions'),
  ];
}
