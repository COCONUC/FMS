
import 'package:FMS/constants/color_constant.dart';
import 'package:FMS/features/registing_work.dart';
import 'package:FMS/features/user_services.dart';
import 'package:FMS/models/user.dart';
import 'package:FMS/providers/data_class.dart';
import 'package:FMS/screens/staff_screens/staff_regist_work.dart';
import 'package:FMS/screens/staff_screens/view_appointment_page.dart';
import 'package:FMS/screens/staff_screens/view_history_order_page.dart';
import 'package:FMS/screens/widgets/account_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  final UserServices userService = UserServices();
  Future<Account> getUser(accessToken) async {
    return userService.getUserData(accessToken);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider
        .of<DataClass>(context)
        .user;

    final name = "Staff Name";
    final phone = "Staff Phone";
    final urlImage = 'https://www.ascengineersinc.com/uploads/1/3/0/5/13059255/profile-photo-2_orig.jpg';

    return FutureBuilder<Account>(
        future: getUser(user.accessToken),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Drawer(
              child: Material(
                color: navigationDrawerColor,
                child: ListView(
                  children: <Widget>[
                    buildHeader(
                      urlImage: urlImage,
                      name: snapshot.data?.name ?? "",
                      phone: snapshot.data?.phonenum ?? "",
                    ),
                    const SizedBox(height: 40),
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
        });
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

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String phone,
  }) =>
      InkWell(
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phone,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      );

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
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
