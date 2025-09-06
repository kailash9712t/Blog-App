// ignore_for_file: non_constant_identifier_names

class Comments {
  String? userHandle;
  String? userAvatar;
  String commentId;
  String username;
  String content;
  int likes;
  String timeStamp;
  int comments;

  Comments(
      {required this.commentId,
      required this.username,
      required this.content,
      required this.likes,
      required this.timeStamp,
      required this.comments,
      this.userAvatar,
      this.userHandle});

  factory Comments.fromJson(Map<String, dynamic> comments) {
    return Comments(
        commentId: comments["commentId"],
        username: comments["username"],
        content: comments["content"],
        likes: comments["likes"],
        timeStamp: comments["timeStamp"],
        comments: comments["comments"],
        userHandle: comments["userHandle"],
        userAvatar: comments["userAvatar"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "commentId": commentId,
      "username": username,
      "content": content,
      "likes": likes,
      "timeStamp": timeStamp,
      "comments": comments,
      "userHandle" : userHandle,
      "userAvatar" : userAvatar
    };
  }
}
