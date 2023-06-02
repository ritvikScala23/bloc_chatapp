import 'package:flutter/material.dart';

class MessageBubbble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "sender",
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          Material(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              elevation: 5,
              color: Colors.lightBlueAccent,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Text(
                  "mesage",
                  style: TextStyle(color: Colors.white),
                ),
              )),
          // Text(
          //   '${DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000)}',
          //   // add this only if you want to show the time along with the email. If you dont want this then don't add this DateTime thing
          //   style: TextStyle(color: Colors.black54, fontSize: 10),
          // ),
        ],
      ),
    );
  }
}
