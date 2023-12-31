import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  //final int time;
 // final String image;


  const MessageTile(
      {Key? key,
        //required this.image,
        required this.message,
        required this.sender,
        required this.sentByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {

 // var time = DateTime.now();
  DateTime ntpTime =DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadNTPTime();
  }

  void _loadNTPTime() async{
     setState(() async {
       ntpTime = await NTP.now();
     });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Card(elevation: 3,
            child: Text('${DateFormat.yMEd().format(ntpTime.toUtc())}')),
        Container(                                    //body Container
          padding: EdgeInsets.only(
              top: 0,
              bottom: 60,
              left: widget.sentByMe ? 0 : 24,
              right: widget.sentByMe ? 24 : 0),
          alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            children: [

              Text('${DateFormat('Hms').format(ntpTime.toUtc())}'),
              Container(                              //message Container
                margin: widget.sentByMe
                    ? const EdgeInsets.only(left: 30)
                    : const EdgeInsets.only(right: 30),
                padding:
                const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: widget.sentByMe
                        ? const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    )
                        : const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: widget.sentByMe
                        ? Theme.of(context).primaryColor
                        : Colors.grey[700]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.sender.toUpperCase(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5),
                    ),

                    //image

                    const SizedBox(
                      height: 8,
                    ),
                    Text(widget.message,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }




}