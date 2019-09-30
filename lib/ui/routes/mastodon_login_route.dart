import 'package:flutter/material.dart';

class MastodonLoginRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = PageController();

    return Scaffold(
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Scaffold(
            body: Column(
                children: <Widget>[
                  Spacer(),
                  Text("Please Enter Mastodon Host"),
                  Padding(
                    padding: EdgeInsets.only(right: 30, left: 30),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "exsample.com",
                      ),
                    ),
                  ),
                  Spacer(),
                ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.arrow_forward),
              onPressed: () {
                controller.animateToPage(
                    1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease
                );
              },
            ),
          ),
          Scaffold(
            body: Column(
              children: <Widget>[
                Spacer(),
                Text("Please Enter Code"),
                Padding(
                  padding: EdgeInsets.only(right: 30, left: 30),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Authorization Code",
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.check),
              onPressed: () {
                controller.animateToPage(
                    0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
