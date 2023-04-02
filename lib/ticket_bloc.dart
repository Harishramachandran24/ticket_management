import 'dart:async';
import 'package:ticket_management/firebase_data.dart';

class CartItemsBloc {

  final ticketStreamController = StreamController.broadcast();

  Stream get getStream => ticketStreamController.stream;


  final List tickets = [];

  void addTicket(newTicket) {
    tickets.add(newTicket);
    ticketStreamController.sink.add(tickets);
  }
  
  void setListOfTicket(newTickets){
    for(var element in newTickets){
      tickets.add(element);
      ticketStreamController.sink.add(tickets);
    }
  }

  void dispose() {
    ticketStreamController.close(); // close our StreamController
  }
}

final bloc = CartItemsBloc();