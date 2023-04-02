import 'package:flutter/material.dart';
import 'package:ticket_management/ticket_bloc.dart';

class ShowTickets extends StatelessWidget {
  const ShowTickets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Tickets"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          initialData: bloc.tickets, // The bloc was already instantiated.
          stream: bloc.getStream, // The stream we'd be listing to
          builder: (context, snapshot) {
            // snapshot contains the data of the bloc
            return snapshot.data.isNotEmpty ? tickets(snapshot.data): Center(child: Text("No Ticket Yet....",style: Theme.of(context).textTheme.headlineSmall,),);
          },
        ),
      ),
    );
  }
  Widget tickets(ticket){
    return ListView.builder(
        itemCount: ticket.length,
        shrinkWrap: true,
        reverse: true,
        itemBuilder: (BuildContext context, i){
      return SizedBox(
        height: 120,
        width: 400,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          Text(ticket[i]['projectTitle'])
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(ticket[i]['date'])
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: Text(ticket[i]['projectDescription']))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("Location\t\t${ticket[i]['location']}")
                      ],
                    ),
                    Column(
                      children: [
                        Text("$i.pdf")
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
