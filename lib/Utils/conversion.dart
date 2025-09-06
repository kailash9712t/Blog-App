import 'package:blog/Models/BlogPost/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Conversion {
  _DynamicList get dynamicList => _DynamicList();
  _DocumentSnapShotList get documentSnapshotList => _DocumentSnapShotList();
}

class _DynamicList {
  List<String> toStringList(List<dynamic> list) {
    List<String> data = [];

    list.map((e) {
      data.add(e as String);
    });

    return data;
  }

  // List<Object> toObjectList(List<Object> list) {
  //   List<Object> data = [];

  //   list.map((e) {
  //     data.add(e);
  //   });
  // }

  List<Map<String, dynamic>> toMapList(List<dynamic> data) {
    List<Map<String, dynamic>> list = [];

    for (var data in data) {
      Map<String, dynamic> tempData = data as Map<String, dynamic>;
      list.add(tempData);
    }

    return list;
  }
}

class _DocumentSnapShotList {
  Map<String, BlogPost> toMapList(List<DocumentSnapshot> snapshot) {
    Map<String, BlogPost> post = {};

    for (var data in snapshot) {
      Map<String, dynamic> likedPost = data.data() as Map<String, dynamic>;
      BlogPost currentPost = BlogPost.fromJson(likedPost);
      currentPost.isLiked = true;
      post[currentPost.id] = currentPost;
    }

    return post;
  }
}
