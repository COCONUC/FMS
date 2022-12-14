
import 'package:FMS/constants/color_constant.dart';
import 'package:FMS/constants/utils.dart';
import 'package:FMS/features/address_services.dart';
import 'package:FMS/features/booking_services.dart';
import 'package:FMS/models/computer_type_object.dart';
import 'package:FMS/screens/widgets/custom_button.dart';
import 'package:FMS/screens/widgets/multi_select_widget.dart';
import 'package:FMS/screens/widgets/pick_address_widget.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';
import '../../features/service_services.dart';
import '../../models/hcm_address_data.dart';
import '../../models/services_data.dart';
import '../../providers/data_class.dart';

class SubmitAppointment extends StatefulWidget {
  static const String routeName = '/submit-appointment';
  final String time;
  const SubmitAppointment({Key? key,required this.time}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubmitAppointmentState();
}

class _SubmitAppointmentState extends State<SubmitAppointment> {
  final _submitKey = GlobalKey<FormState>();
  final BookingServices bookingServices = BookingServices();
  final TextEditingController username = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController ward = TextEditingController();
  final TextEditingController street = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController services = TextEditingController();
  final TextEditingController status = TextEditingController();
  late List<Service> futureService;
  late List<String> serviceName = [];
  late List<Address> address;
  late List<String> districts =[];
  late List<String> wards =[];
  List<String> _selectedItems = [];
  late String selectedDistrict;
  late String selectedWard;
  late String selectedComType;
  late String selectedComBrand;

  Future<void> getListDropdownData(token) async {
    address = await fetchHCMAddress();
    for(int i =0; i< address.length;i++){
      districts.add(address[i].name.toString());
    }

    futureService = await ServiceServices().fetchServices(token);
    for(int i =0; i < futureService.length;i++){
      serviceName.add(futureService[i].name.toString());
    }


  }

  void getWardsData() async{
    for(int i =0; i< address.length;i++){
      if(address[i].name==selectedDistrict){
        for (var element in address[i].wards) {wards.add(element.name); }
      }
    }
  }

//  late Address? selectedWard;
  void _showDistrictSelected() async {
    final String results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return PickAddress(items: districts, title: "Ch???n qu???n",);
      },
    );
    if (results != '') {
      setState(() {
        wards.clear();
        selectedWard ='';
        selectedDistrict = results;
        getWardsData();
      });
    }
  }

  void _showWardSelected() async {
    if(wards.isNotEmpty) {
      final String results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return PickAddress(items: wards, title: "Ch???n ph?????ng/khu v???c",);
        },
      );
      if (results != '') {
        setState(() {
          selectedWard = results;
        });
      }
    }
  }

  void _showMultiSelect() async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: serviceName, title: "d???ch v???",);
      },
    );
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }


  @override
  void initState() {
    final userProvider = Provider.of<DataClass>(context, listen: false);
    super.initState();
    phone.text = userProvider.user.username;
    selectedDistrict = '';
    selectedWard = '';
    selectedComType = deviceType.first;
    selectedComBrand = deviceBranch.first;
    getListDropdownData(userProvider.user.accessToken);
    // time.text = '22/7/2022';
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<DataClass>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.orangeAccent,
          title: const Text(
            "Nh???p th??ng tin h???n",
            style: TextStyle(
              fontSize: 23,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: mBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _submitKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Th???i gian h???n:",
                                style: TextStyle(fontSize: 16, fontFamily: 'Regular')),
                            Text(parseDateNoUTC(widget.time),
                                style: const TextStyle(fontSize: 16, fontFamily: 'Regular')),
                          ],
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'T??n ng?????i h???n:'),
                          controller: username,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'S??? ??i???n tho???i:'),
                          controller: phone,
                        ),
                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                             Text("Qu???n:",
                                style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6), fontFamily: 'Regular')),
                            ElevatedButton(
                              onPressed: _showDistrictSelected,
                              child: const Text('Ch???n qu???n', style: TextStyle(fontSize: 12),),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(selectedDistrict, style: const TextStyle(fontSize: 16, fontFamily: 'Regular',),),
                          ],
                        ),

                        Divider(thickness: 1,color: Colors.black.withOpacity(0.4),),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Ph?????ng/khu v???c:",
                                style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6), fontFamily: 'Regular')),
                            ElevatedButton(
                              onPressed: _showWardSelected,
                              child: const Text('Ch???n ph?????ng/khu v???c', style: TextStyle(fontSize: 12),),
                            ),

                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(selectedWard, style: const TextStyle(fontSize: 16, fontFamily: 'Regular',),),
                          ],
                        ),
                        Divider(thickness: 1,color: Colors.black.withOpacity(0.4),),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'S??? nh??, ???????ng:'),
                          controller: street,
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                 Text("D???ch v???:",
                                    style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6), fontFamily: 'Regular')),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: _showMultiSelect,
                                      child: const Text('Ch???n d???ch v???',  style: TextStyle(fontSize: 12),),
                                    ),
                                  ],
                                ),
                                // display selected items
                              ],
                            ),
                            Column(
                              children: [
                                Wrap(
                                  children: _selectedItems
                                      .map((e) => Chip(
                                    label: Text(e),
                                  ))
                                      .toList(),
                                ),
                              ],
                            ),
                            Divider(thickness: 1,color: Colors.black.withOpacity(0.4),),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Lo???i m??y:', style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6), fontFamily: 'Regular')),
                            DropdownButton(
                              // Initial Value
                              value: selectedComType,
                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),
                              // Array list of items
                              items: deviceType.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width / 6,
                                    child: Text(items,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedComType = newValue!;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            Text('H??ng m??y:', style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6), fontFamily: 'Regular')),
                            DropdownButton(
                              // Initial Value
                              value: selectedComBrand,
                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),
                              // Array list of items
                              items: deviceBranch.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width / 5,
                                    child: Text(items,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedComBrand = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8,),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'M?? t??? v???n ?????:'),
                          controller: description,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: '?????t l???ch',
                          onTap: () {
                            if (_submitKey.currentState!.validate()) {
                              String desc = '$selectedComType-$selectedComBrand ${description.text}';
                              AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.QUESTION,
                                  title: 'X??c nh???n ?????t l???ch?',
                                  dismissOnTouchOutside: false,
                                  btnCancelOnPress: (){},
                                  btnOkOnPress: () {
                                    bookingServices.createBooking(
                                        context,
                                        userProvider.user.accessToken,
                                        street.text,
                                        selectedWard,
                                        selectedDistrict,
                                        'H??? Ch?? Minh',
                                        username.text,
                                        phone.text,
                                        _selectedItems,
                                        desc,
                                        widget.time);
                                  },
                              ).show();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
