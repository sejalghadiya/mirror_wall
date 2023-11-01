import 'package:flutter/material.dart';


class MySearchApp extends StatefulWidget {
  const MySearchApp({required Key key}) : super(key: key);

  @override
  _MySearchAppState createState() => _MySearchAppState();
}

class _MySearchAppState extends State<MySearchApp> {
  int _selectedIndex = 0;
  InAppWebViewController controller = InAppWebViewController(1, InAppWebView());
  late PullToRefreshController pullToRefreshController;

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        await controller?.reload();
      },
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: InkWell(
            child: Icon(Icons.home,color: Colors.black),
          ),label: ''),
          BottomNavigationBarItem(
              icon: InkWell(child: Icon(Icons.bookmark_add_outlined,color: Colors.black)),label: ''),
          BottomNavigationBarItem(
              icon: InkWell(child: Icon(Icons.arrow_back_ios_new,color: Colors.black)),label: ''),
          BottomNavigationBarItem(
              icon: InkWell(child: Icon(Icons.refresh,color: Colors.black)),label: ''),
          BottomNavigationBarItem(
              icon: InkWell(child: Icon(Icons.arrow_forward_ios_outlined,color: Colors.black)),label: ''),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      appBar: AppBar(
        title: Center(
          child: Text('My Browser'),
        ),
        // popup menu button
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              // popupmenu item 1
              PopupMenuItem(
                value: 1,
                // row has two child icon and text.
                child: Row(
                  children: [
                    Icon(Icons.bookmark),
                    SizedBox(
                      // sized box with width 10
                      width: 20,
                    ),
                    Text("All  Bookmarks")
                  ],
                ),
              ),
              // popupmenu item 2
              PopupMenuItem(
                value: 2,
                // row has two child icon and text
                child: Row(
                  children: [
                    Icon(Icons.laptop_chromebook_rounded),
                    SizedBox(
                      // sized box with width 10
                      width: 20,
                    ),
                    Text("Search Engine")
                  ],
                ),
              ),
            ],
            offset: Offset(0, 100),
            color: Colors.grey.shade500,
            elevation: 2,
          ),
        ],

      ),


      body: InAppWebView(

        onWebViewCreated: (InAppWebViewController webViewController) {
          controller =  webViewController;
        },
        initialUrlRequest: URLRequest(url: Uri.parse('https://www.google.com/')),
        pullToRefreshController: pullToRefreshController,

        onProgressChanged: (controller,progress) {
          if(progress==100){
            pullToRefreshController?.endRefreshing();
          }
        },

      ),


    );
  }
}