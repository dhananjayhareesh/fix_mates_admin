import 'package:fix_mates_admin/provider/side_menu_provider.dart';
import 'package:fix_mates_admin/util/responsive.dart';
import 'package:fix_mates_admin/view/categories.dart';
import 'package:fix_mates_admin/view/new_user_request.dart';
import 'package:fix_mates_admin/view/sevice_partner.dart';
import 'package:fix_mates_admin/view/transaction.dart';
import 'package:fix_mates_admin/widget/dashboard_widget.dart';
import 'package:fix_mates_admin/widget/side_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final provider = Provider.of<SideMenuProvider>(context);

    return Scaffold(
      drawer: !isDesktop
          ? const SizedBox(
              width: 250,
              child: SideMenuWidget(),
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: 2,
                child: SizedBox(
                  child: SideMenuWidget(),
                ),
              ),
            Expanded(
              flex: 8,
              child: getSelectedWidget(provider.selectedIndex),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSelectedWidget(int index) {
    switch (index) {
      case 0:
        return const DashboardWidget();
      case 1:
        return const NewUserRequest();
      case 2:
        return const SevricePartner();
      case 3:
        return const Categories();
      case 4:
        return const Transaction();
      default:
        return const DashboardWidget();
    }
  }
}
