class BlogPost {
  final String id;
  final String userName;
  final String? userHandle;
  final String? userAvatar;
  final String timeAgo;
  final String content;
  final String? profileUrl;
  final int likes; // add final
  final int comments;
  final int reposts;
  final bool isLiked; // add final
  final List<String> contentImage;

  BlogPost(
      {required this.id,
      required this.userName,
      this.userHandle,
      this.userAvatar,
      required this.timeAgo,
      required this.content,
      this.profileUrl,
      required this.likes,
      required this.comments,
      required this.reposts,
      required this.isLiked,
      this.contentImage = const []}); // add const

  // json deserialization

  factory BlogPost.fromJson(Map<String, dynamic> json) {

    return BlogPost(
        id: json["postID"] as String,
        userName: json["userName"] as String,
        userAvatar: json["userAvatar"] as String?,
        timeAgo: json["timeAgo"].toString(),
        content: json["content"] as String,
        likes: json["likes"] as int,
        comments: json["comments"] as int,
        reposts: json["reposts"] as int,
        isLiked: false,
        userHandle: json["displayName"] as String,
        contentImage: (json["imageUrl"] as List<dynamic>)
            .map((e) => e as String)
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "userHandle": userHandle,
      "postID": id,
      "profileUrl": profileUrl,
      "timeAgo": timeAgo,
      "content": content,
      "likes": likes,
      "comments": comments,
      "reposts": reposts,
      "isLiked": isLiked,
      "imageUrl": contentImage
    };
  }

  BlogPost copyWith(
      {String? id,
      String? userName,
      String? userHandle,
      String? userAvatar,
      String? timeAgo,
      String? content,
      int? likes,
      int? comments,
      int? reposts,
      bool? isLiked,
      List<String>? contentImage}) {
    return BlogPost(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        userAvatar: userAvatar ?? this.userAvatar,
        timeAgo: timeAgo ?? this.timeAgo,
        content: content ?? this.content,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        reposts: reposts ?? this.reposts,
        isLiked: isLiked ?? this.isLiked,
        contentImage: contentImage ?? this.contentImage);
  }
}
