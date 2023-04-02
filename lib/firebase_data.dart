import 'package:firebase_database/firebase_database.dart';
import 'ticket_bloc.dart';
import 'package:ticket_management/ticket_bloc.dart';

class TicketData{

 void getTicketData() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('tickets').get();
    print(snapshot.value.runtimeType);
    if(snapshot.exists){
    if(snapshot.value is Map){
        bloc.addTicket(snapshot.value);
      }
      else {
        if(snapshot.value is List){
          bloc.setListOfTicket(snapshot.value);
        }
      }
    }
    else {
    print("No data");
    }
  }

  Future<void> pushTicketData(newTicket,key) async {
    DatabaseReference ticketList = FirebaseDatabase.instance.ref("tickets/$key");
    ticketList.set(newTicket);

  }
}