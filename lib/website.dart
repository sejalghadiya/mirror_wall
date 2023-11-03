import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebSite extends StatefulWidget {
  const WebSite({Key? key}) : super(key: key);

  @override
  State<WebSite> createState() => _WebSiteState();
}

class _WebSiteState extends State<WebSite> {

  InAppWebViewController controller = InAppWebViewController(1, InAppWebView());
   late PullToRefreshController pullToRefreshController;

   String url = 'https://www.google.com/';

   List<dynamic> bookmarks = [];
  @override

  void initState() {
    // TODO: implement initState
    pullToRefreshController = PullToRefreshController(
      onRefresh: (){
        controller.reload();
      }
    );
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        centerTitle: true,
        title: Text('My Browser',style: TextStyle(
          fontSize: 23,color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.5
        ),),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert,color: Colors.black,),
            itemBuilder: (context){
              return [
                PopupMenuItem(
                    child: TextButton.icon(
                        onPressed: () {
                          openBookmark();
                        },
                        icon: Icon(Icons.bookmark_add_outlined),
                        label: Text('All Bookmark'))),
                PopupMenuItem(
                    child: TextButton.icon(
                        onPressed: (){ },
                        icon: Icon(Icons.screen_search_desktop),
                        label: Text('Search Engine'))),
              ];
            },
          )
        ],
      ),
      body:  InAppWebView(
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (cnt){
            controller = cnt;
          },
          initialUrlRequest: URLRequest(url: Uri.parse('https://www.google.com/')),
          onProgressChanged: (controller, progress) {
            if (progress == 100) {
              pullToRefreshController?.endRefreshing();
            }
          }
      ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
             icon: IconButton(
               icon: Icon(Icons.home,color: Colors.black,size: 25,),
               onPressed: () async{
                   await controller.loadUrl(urlRequest: URLRequest(url: Uri.parse(url)));
               },
             ),
              label: ''
            ),
            BottomNavigationBarItem(
                icon: IconButton(
                  icon: Icon(Icons.bookmark_add_outlined,color: Colors.black,size: 25,),
                  onPressed: (){
                    addFavoriteLink(context);
                  },
                ),
                label: ''
            ),
            BottomNavigationBarItem(
                icon: IconButton(
                  icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.black,size: 25,),
                  onPressed: () async{
                   if((
                   await controller?.canGoBack()
                   )??false
                   )
                     await controller.goBack();
                  },
                ),
                label: ''
            ),
            BottomNavigationBarItem(
                icon: IconButton(
                  icon: Icon(Icons.refresh_outlined,color: Colors.black,size: 25,),
                  onPressed: (){
                    controller.reload();
                  },
                ),
                label: ''
            ),

            BottomNavigationBarItem(
                icon: IconButton(
                  icon: Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,size: 25,),
                  onPressed: () async{
                    if((
                        await controller?.canGoForward()
                    )??false
                    )
                      await controller.goForward();
                  },
                ),
                label: ''
            ),
          ],
        )
    );
  }
  void addFavoriteLink(BuildContext context) async {
    final String? newLink = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Add Favorite Link'),
          children: <Widget>[
            TextField(
              onSubmitted: (link)async {
                Navigator.pop(context, link);
                final String? title = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: Text('add'),
                        children: [
                          TextField(
                            onSubmitted: (bookmarkTitle) {
                              Navigator.pop(context, bookmarkTitle);

                            },
                          )
                        ],
                      );
                    }
                );
              }
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async{
                Navigator.pop(context);
                Uri? url = await controller.getUrl();
                if (url != null) {
                  bookmarks.add(url.toString());
                }
              },
            ),
          ],
        );
      },
    );
  }
  void saveBookmark(String link) {
    bookmarks.add(link);
  }
  void openBookmark() async{
    final selectedBookmark = await showDialog<String>(
        context: context,
        builder: (BuildContext context){
          return SimpleDialog(
            title: Text('selected bookmark'),
            children: bookmarks.map((e) => SimpleDialogOption(
              onPressed: (){
                Navigator.pop(context, bookmarks);
              },
              child: Text(e),
            )).toList(),
          );
        });
    if(selectedBookmark != null){
      await controller.loadUrl(urlRequest: URLRequest(
          url: Uri.parse(selectedBookmark)
      ));
    }
  }
}





