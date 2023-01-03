import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasesignup/screen/home/controller/home_controller.dart';
import 'package:firebasesignup/screen/home/modal/home-modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../firebase/firebase_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  HomeController homeController = Get.put(HomeController());

  TextEditingController txtid = TextEditingController();
  TextEditingController txtname = TextEditingController();
  TextEditingController txtmobile = TextEditingController();

  TextEditingController uptxtid = TextEditingController();
  TextEditingController uptxtname = TextEditingController();
  TextEditingController uptxtmobile = TextEditingController();

  List<Homemodal> dataList = [];

  @override
  void initState() {
    // TODO: implement initState
    getProfile();
    homeController.notification();
  }

  void getProfile() async {
    homeController.userData.value = await userProfile();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                logout();
                Get.offNamed('/');
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
          child: Column(
        children: [
          TextField(
            controller: txtid,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: txtname,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: txtmobile,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                instertData(txtid.text, txtname.text, txtmobile.text);
              },
              child: Text("Insert")),
          SizedBox(
            height: 20,
          ),



          ElevatedButton(onPressed: ()async{
            
            var image = ByteArrayAndroidBitmap(await homeController.imageNotification("https://iso.500px.com/wp-content/uploads/2016/11/stock-photo-159533631-1500x1000.jpg"));

            BigPictureStyleInformation big = BigPictureStyleInformation(image);

            AndroidNotificationDetails anroidnoti = AndroidNotificationDetails("10", "android",priority: Priority.high,importance: Importance.max,sound: RawResourceAndroidNotificationSound("sound"),styleInformation: big);
            NotificationDetails nd = NotificationDetails(android: anroidnoti);

            await homeController.flnp!.show(1, "hello", "notification Practice", nd);

          }, child: Text("Notification")),



          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
                stream: readData(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if (snapshot.hasData) {
                    List<QueryDocumentSnapshot> docList = snapshot.data!.docs;
                    dataList.clear();

                    for (var x in docList) {
                      Map finaldata = x.data() as Map<String, dynamic>;
                      String key = x.id;
                      String id = finaldata['id'];
                      String name = finaldata['name'];
                      String mobile = finaldata['mobile'];

                      Homemodal h1 = Homemodal(name: name,id: id,mobile: mobile,key: key);
                      dataList.add(h1);
                    }
                    return ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text("${dataList[index].id}"),
                            title: Text("${dataList[index].name}"),
                            subtitle: Text("${dataList[index].mobile}"),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        deleteData("${dataList[index].key}");
                                      },
                                      icon: Icon(Icons.delete)),

                                  IconButton(onPressed: (){

                                    uptxtid =TextEditingController(text: "${dataList[index].id}");
                                    uptxtname =TextEditingController(text: "${dataList[index].name}");
                                    uptxtmobile =TextEditingController(text: "${dataList[index].mobile}");

                                    Get.defaultDialog(
                                      content: Column(
                                        children: [
                                          TextField(
                                            controller: uptxtid,
                                            decoration: InputDecoration(border: OutlineInputBorder()),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextField(
                                            controller: uptxtname,
                                            decoration: InputDecoration(border: OutlineInputBorder()),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextField(
                                            controller: uptxtmobile,
                                            decoration: InputDecoration(border: OutlineInputBorder()),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                updateData("${dataList[index].key}", uptxtid.text, uptxtname.text, uptxtmobile.text);
                                                Get.back();
                                              },
                                              child: Text("Update")),
                                        ],
                                      ),
                                    );

                                  }, icon: Icon(Icons.edit)),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                  return CircularProgressIndicator();
                }),
          )
        ],
      )),
    ));
  }
}
