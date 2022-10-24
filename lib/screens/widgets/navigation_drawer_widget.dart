import 'package:FMS/constants/color_constant.dart';
import 'package:FMS/features/registing_work.dart';
import 'package:FMS/screens/staff_screens/staff_regist_work.dart';
import 'package:FMS/screens/staff_screens/view_appointment_page.dart';
import 'package:FMS/screens/staff_screens/view_history_order_page.dart';
import 'package:FMS/screens/widgets/account_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: navigationDrawerColor,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 48),
            buildMenuItem(
              text: 'Thông tin tài khoản',
              icon: Icons.people,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Xem lịch hẹn',
              icon: Icons.file_copy,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Đơn đã hoàn thành',
              icon: Icons.update,
              onClicked: () => selectedItem(context, 2),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Đăng ký lịch nghỉ',
              icon: Icons.calendar_month,
              onClicked: () => selectedItem(context, 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch(index){
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AccountScreen(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const StaffViewAppointmentPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HistoryOrder(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const StaffRegistWork(),
        ));
        break;
    }
  }

}
