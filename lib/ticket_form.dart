import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ticket_management/show_tickets.dart';
import 'package:ticket_management/ticket_bloc.dart';
import 'package:ticket_management/firebase_data.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TicketForm extends StatefulWidget {
  const TicketForm({Key? key}) : super(key: key);

  @override
  State<TicketForm> createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {


  @override
  void initState() {
    // TODO: implement initState
    TicketData().getTicketData();
    notification();
    super.initState();
  }

  notification(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('A new onMessage event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print(message.notification?.body);
      if (message.notification != null) {
        print('Message also contained a notification: ${message.data['screen']}');
        print('Message also contained a notification: ${message.data}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print(message.notification?.body);
      if (message.notification != null) {
        print('Message also contained a notification: ${message.data['screen']}');
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      print("FirebaseMessaging.getInitialMessage ${message?.notification?.body}");
      if (message?.notification != null) {
        print('Message also contained a notification: ${message?.data['screen']}');
      }
    });
  }

  final ticketFormKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController date = TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

      return GestureDetector(
        onTap: ()=>FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("Create Ticket"),
            elevation: 0,
            centerTitle: true,
          ),
          body: Form(
            key: ticketFormKey,
            child: Padding(
              padding:  EdgeInsets.only(left: width*0.04,right: width*0.04),
              child: Column(
                children: [
                  SizedBox(height: height*0.05),
                  SizedBox(
                    width: width * 0.9,
                    child: TextFormField(
                      controller: title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                      decoration:
                      const InputDecoration(
                          hintText: 'Enter title',
                          labelText: 'Problem Title'),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  SizedBox(
                    width: width * 0.9,
                    child: TextFormField(
                      controller: description,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                      maxLines: 2,
                      decoration:
                      const InputDecoration(
                          hintText: 'Enter Description',
                          labelText: 'Problem Description'),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  SizedBox(
                    width: width * 0.9,
                    child: TextFormField(
                      controller: location,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter location';
                        }
                        return null;
                      },
                      decoration:
                      const InputDecoration(labelText: 'Location',hintText: 'Enter location'),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  SizedBox(
                    width: width * 0.9,
                    height: height * 0.07,
                    child: TextFormField(
                      controller: date,
                      decoration:
                       const InputDecoration(labelText: 'Reported date'),
                      enabled: false,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  Row(
                    children: [
                      SizedBox(width:  width*0.02,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Attachment",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          ElevatedButton.icon(
                              onPressed: (){
                                _pickFile();
                              }, icon: const Icon(Icons.file_open_outlined,color: Colors.black,),
                              label: const Text("Choose file",style: TextStyle(color: Colors.black),),
                              ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 3.0,
                        fixedSize: const Size(400, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                    backgroundColor: Colors.blue
                    ),
                      onPressed: (){
                        if (ticketFormKey.currentState!.validate()) {
                          Map temp = {'projectTitle':title.text,'projectDescription':description.text,'location':location.text,'date':date.text};
                          int key = bloc.tickets.length;
                          TicketData().pushTicketData(temp,key);
                          bloc.addTicket(temp);
                          clearForm();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ticket Raised Successfully!')),
                          );
                        }
                      }, child: const Text("Submit Ticket")),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ShowTickets()));
          },
          child: const Icon(Icons.ads_click),
          ),
        ),
      );
  }
  void _pickFile() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    // if no file is picked
    if (result == null) return;

    // we will log the name, size and path of the
    // first picked file (if multiple are selected)
    print(result.files.first.name);
    print(result.files.first.size);
    print(result.files.first.path);
  }

  clearForm(){
    title.clear();
    description.clear();
    location.clear();
  }

}
