import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_note_two/models/post_model.dart';
import 'package:firebase_note_two/pages/detail_page.dart';
import 'package:firebase_note_two/services/auth_service.dart';
import 'package:firebase_note_two/services/rtdb_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const id = "/home_page";

  void _logout(BuildContext context) {
    AuthService.signOutUser(context);
  }

  void _openDetailPage(BuildContext context) {
    Navigator.pushNamed(context, DetailPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Post"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: StreamBuilder<DatabaseEvent>(
        stream: RTDBService.database.child("posts").onValue,
        builder: (context, snapshot) {
          List<Post> posts = RTDBService.parseSnapshot(snapshot.data);

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return _itemOfList(posts[index]);
            },
          );
        }
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDetailPage(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _itemOfList(Post post) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      title: Text(post.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
      subtitle: Text(post.content, style: const TextStyle(fontSize: 18),),
    );
  }
}
