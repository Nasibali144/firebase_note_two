import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_note_two/models/post_model.dart';

class RTDBService {
  static final database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> storePost(Post post) async {
    await database.child("posts").push().set(post.toJson());
    return database.onChildAdded;
  }

  static Future<List<Post>> loadPosts(String id) async {
    List<Post> items = [];
    Query query = database.child("posts").orderByChild("userId").equalTo(id);
    var snapshot = await query.once();
    var result = snapshot.snapshot.children;

    for(DataSnapshot item in result) {
      if(item.value != null) {
        items.add(Post.fromJson(Map<String, dynamic>.from(item.value as Map)));
      }
    }

    return items;
  }

  static List<Post> parseSnapshot(DatabaseEvent? event) {
    List<Post> items = [];
    if(event == null) return items;

    var result = event.snapshot.children;

    for(DataSnapshot item in result) {
      if(item.value != null) {
        items.add(Post.fromJson(Map<String, dynamic>.from(item.value as Map)));
      }
    }
    return items;
  }
}