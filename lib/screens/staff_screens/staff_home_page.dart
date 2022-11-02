
import 'package:FMS/constants/color_constant.dart';
import 'package:FMS/constants/utils.dart';
import 'package:FMS/features/order_services.dart';
import 'package:FMS/models/order_staff_data.dart';
import 'package:FMS/providers/data_class.dart';
import 'package:FMS/screens/customer_screens/product_screen.dart';
import 'package:FMS/screens/staff_screens/staff_regist_work.dart';
import 'package:FMS/screens/staff_screens/view_appointment_details.dart';
import 'package:FMS/screens/staff_screens/view_appointment_page.dart';
import 'package:FMS/screens/staff_screens/view_history_order_page.dart';
import 'package:FMS/screens/widgets/custom_button.dart';
import 'package:FMS/screens/widgets/navigation_drawer_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/account_screen.dart';
import '../../features/user_services.dart';
import '../../models/user.dart';

class StaffHomePage extends StatefulWidget {
  static const String routeName = '/staff_home_page';
  const StaffHomePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {

  int _selectedItemIndex = 0;
  int currentPage = 1;
  late Future<List<OrderStaff>> futureOrderStaff;

  @override
  Widget build(BuildContext context) {

    String token = Provider.of<DataClass>(context).user.accessToken;
    futureOrderStaff = OrderServices().getOrderListForStaff(token,context);
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      //App Bar
      backgroundColor: themeColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: themeColor,
        title: const Text(
          "Furniture Services",
          style: TextStyle(
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),
      //--------------------Body------
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: mBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<List<OrderStaff>>(
              future: OrderServices().getOrderListForStaff(token, context),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return snapshot.data!.isNotEmpty ? Align(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(5),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Text(parseDateDownLine(snapshot.data![index].orderId?.bookingId?.time),textAlign: TextAlign.center,),
                            title: Text('Khách hàng: ${snapshot.data![index].orderId?.bookingId?.cusName}'),
                            subtitle:
                            Text('Địa chỉ: ${printAddress(snapshot.data![index].orderId?.bookingId?.cusAddress?.street,
                                snapshot.data![index].orderId?.bookingId?.cusAddress?.ward,
                                snapshot.data![index].orderId?.bookingId?.cusAddress?.district)}'),
                            trailing:
                            Column(
                              children: [
                                const SizedBox(height: 5,),
                                Text(""/*'${snapshot.data![index].orderId?.status}', style: TextStyle(color: getOrderStatusColor(snapshot.data![index].orderId?.status)),*/),
                                const SizedBox(height: 5,),
                                if(snapshot.data![index].orderId!.status == "Đang xử lí")
                                  InkWell(onTap: (){
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.SCALE,
                                      dialogType: DialogType.WARNING,
                                      title: 'Báo bận',
                                      desc: 'Gửi thông báo bận cho quản lí?',
                                      btnCancelOnPress: () {
                                      },
                                      btnCancelText: 'Hủy',
                                      btnOkText: 'Xác nhận',
                                      btnOkOnPress: () {
                                        OrderServices().sendBusyOrder(context, token, snapshot.data![index].orderId!.id);
                                      },
                                    ).show();
                                  },child: const Icon(Icons.event_busy, color: Colors.redAccent,),)
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StaffViewAppointmentDetailsPage(
                                        order: snapshot.data![index],
                                        token: token,
                                      )));
                            },
                          ),
                        );
                      },
                    ),
                  ) : const Center(child: Text('Chưa có lịch hẹn'),);
                }
              }),
        ),
      ),
      // Bottom Navigation----------------
      bottomNavigationBar: Row(
        children: <Widget>[
          buildNavBarItem(Icons.home, 0),
          buildNavBarItem(Icons.list_alt, 1),
          buildNavBarItem(Icons.schedule, 2),
          buildNavBarItem(Icons.person, 3)
        ],
      ),
      // This is Background Color
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
        });
        if(_selectedItemIndex == 1){
          Navigator.pushNamedAndRemoveUntil(
            context,
            StaffViewAppointmentPage.routeName,
                (route) => false,
          );
        }
        if(_selectedItemIndex == 0){
          Navigator.pushNamedAndRemoveUntil(
            context,
            StaffHomePage.routeName,
                (route) => false,
          );
        }
        if(_selectedItemIndex == 2){
          Navigator.pushNamedAndRemoveUntil(
            context,
            StaffRegistWork.routeName,
                (route) => false,
          );
        }
        if(_selectedItemIndex == 3){
          Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => const AccountScreen()
          ));
        }
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / 4,
        decoration: index == _selectedItemIndex
            ? BoxDecoration(
                border: const Border(
                  bottom: BorderSide(width: 4, color: Colors.orangeAccent),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.015),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ))
            : const BoxDecoration(),
        child: Icon(
          icon,
          color: index == _selectedItemIndex ? Colors.redAccent : Colors.white,
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class StaffRegistWork extends StatefulWidget {
//   static const String routeName = '/staff_regist_work';
//   const StaffRegistWork({Key? key}) : super(key: key);
//   @override
//   _StaffRegistWorkState createState() => _StaffRegistWorkState();
// }

// class _StaffRegistWorkState extends State<StaffRegistWork> {
//   int _selectedItemIndex = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Bottom Navigation----------------
//       bottomNavigationBar: Row(
//         children: <Widget>[
//           buildNavBarItem(Icons.home, 0),
//           buildNavBarItem(Icons.list_alt, 1),
//           buildNavBarItem(Icons.notifications, 2),
//           buildNavBarItem(Icons.person, 3)
//         ],
//       ),
//       // This is Background Color
//     );
//   }

//   Widget buildNavBarItem(IconData icon, int index) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedItemIndex = index;
//         });
//       },
//       child: Container(
//         height: 60,
//         width: MediaQuery.of(context).size.width / 4,
//         decoration: index == _selectedItemIndex
//             ? BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(width: 4, color: Colors.orangeAccent),
//                 ),
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.white.withOpacity(0.3),
//                     Colors.white.withOpacity(0.015),
//                   ],
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                 ))
//             : BoxDecoration(),
//         child: Icon(
//           icon,
//           color: index == _selectedItemIndex ? Colors.redAccent : Colors.white,
//         ),
//       ),
//     );
//   }
// }

