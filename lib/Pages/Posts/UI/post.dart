import 'package:blog/Models/BlogPost/post.dart';
import 'package:blog/Models/Hive_Model/UserData/user.dart';
import 'package:blog/Models/User/user_profile.dart';
import 'package:blog/Pages/User/State/user.dart';
import 'package:blog/Utils/date_and_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TweetDetailPage extends StatefulWidget {
  BlogPost post;
  TweetDetailPage({super.key, required this.post});

  @override
  _TweetDetailPageState createState() => _TweetDetailPageState();
}

class _TweetDetailPageState extends State<TweetDetailPage> {
  bool isLiked = true;
  int likeCount = 1;
  TextEditingController commentController = TextEditingController();
  List<Comment> comments = [
    Comment(
      username: "john_dev",
      handle: "@johndev",
      comment: "Nice room design! The green blocks look really cool 👍",
      timeAgo: "2h",
      avatar: "J",
    ),
    Comment(
      username: "sarah_ui",
      handle: "@sarahui",
      comment: "Love the minimalist style. What software did you use for this?",
      timeAgo: "1h",
      avatar: "S",
    ),
    Comment(
      username: "mike_designer",
      handle: "@mikedesign",
      comment: "The lighting and shadows look realistic. Great work!",
      timeAgo: "45m",
      avatar: "M",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Post',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main Tweet Card
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey,
                          child: ClipOval(
                            child: Image.network(
                              widget.post.profileUrl ?? '',
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, trace) {
                                return Image.asset(
                                  "Assets/Image/default_user.png",
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                );
                              },
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.post.userHandle}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${widget.post.userName} • ${DateAndTime(). timeDifference(DateAndTime().stringTimeStampToDateTime(widget.post.timeAgo))}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Tweet Text
                    Text(
                      widget.post.content,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Images Grid
                    _buildPhotoLayout(widget.post.contentImage),
                    SizedBox(height: 16),

                    // Engagement Stats
                    Row(
                      children: [
                        Text(
                          DateAndTime().dateTimeToPostFormat(DateAndTime().stringTimeStampToDateTime(widget.post.timeAgo)),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(color: Colors.grey[200]),
                    SizedBox(height: 12),

                    // Stats Row
                    Row(
                      children: [
                        Text(
                          '${widget.post.likes}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Like',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          '${comments.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Comments',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(color: Colors.grey[200]),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.repeat,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              isLiked = !isLiked;
                              likeCount =
                                  isLiked ? likeCount + 1 : likeCount - 1;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.share_outlined,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Container(
              height: 8,
              color: Colors.grey[100],
            ),

            // Comments Section
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Add Comment
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue[400],
                          radius: 20,
                          child:
                              Text('U', style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: 'Tweet your reply',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (commentController.text.isNotEmpty) {
                              setState(() {
                                comments.insert(
                                    0,
                                    Comment(
                                      username: "you",
                                      handle: "@you",
                                      comment: commentController.text,
                                      timeAgo: "now",
                                      avatar: "U",
                                    ));
                                commentController.clear();
                              });
                            }
                          },
                          child: Text(
                            'Reply',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey[200], height: 1),

                  // Comments List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[200]!,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: _getAvatarColor(comment.avatar),
                              radius: 20,
                              child: Text(
                                comment.avatar,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        comment.username,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        comment.handle,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '• ${comment.timeAgo}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    comment.comment,
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        icon: Icon(
                                          Icons.chat_bubble_outline,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        onPressed: () {},
                                      ),
                                      SizedBox(width: 20),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        icon: Icon(
                                          Icons.favorite_border,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(BlogPost post) {
    UserModel userData = context.read<UserProfileState>().model;
    return GestureDetector(
      onTap: () {
        context.push("/posts");
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey,
                  child: ClipOval(
                    child: Image.network(
                      userData.profileUrl ?? '',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, trace) {
                        return Image.asset(
                          "Assets/Image/default_user.png",
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        );
                      },
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.userHandle ?? "username",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            post.userName,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '• ${DateAndTime().timeDifference(DateAndTime().stringTimeStampToDateTime(post.timeAgo))}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(post.content, style: TextStyle(fontSize: 16, height: 1.4)),
            if (post.contentImage.isNotEmpty) ...[
              SizedBox(height: 12),
              _buildPhotoLayout(post.contentImage),
            ],
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPostAction(
                  icon: Icons.chat_bubble_outline,
                  count: post.comments,
                  color: Colors.grey[600]!,
                  onTap: () {
                    HapticFeedback.selectionClick();
                  },
                ),
                _buildPostAction(
                  icon: Icons.repeat,
                  count: post.reposts,
                  color: Colors.grey[600]!,
                  onTap: () {
                    HapticFeedback.selectionClick();
                  },
                ),
                Consumer<UserPageModel>(builder: (context, instance, child) {
                  return _buildPostAction(
                    icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                    count: post.likes,
                    color: post.isLiked ? Colors.red : Colors.grey[600]!,
                    onTap: () => context
                        .read<UserPageModel>()
                        .toggleLike(post.userName, post.id, context),
                  );
                }),
                _buildPostAction(
                  icon: Icons.share,
                  count: 0,
                  color: Colors.grey[600]!,
                  onTap: () {
                    HapticFeedback.selectionClick();
                  },
                  showCount: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoLayout(List<String> images) {
    final int imageCount = images.length;

    if (imageCount == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          images[0],
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
            );
          },
        ),
      );
    } else if (imageCount == 2) {
      return Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                images[0],
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey[600]),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                images[1],
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey[600]),
                  );
                },
              ),
            ),
          ),
        ],
      );
    } else if (imageCount == 3) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                images[0],
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey[600]),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    images[1],
                    height: 98,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 98,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
                SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    images[2],
                    height: 98,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 98,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (imageCount == 4) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    images[0],
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    images[1],
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    images[2],
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    images[3],
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      final int remainingCount = imageCount - 3;
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                images[0],
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey[600]),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    images[1],
                    height: 98,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 98,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
                SizedBox(height: 4),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        images[2],
                        height: 98,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 98,
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey[600]),
                          );
                        },
                      ),
                    ),
                    if (remainingCount > 0)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '+$remainingCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildPostAction({
    required IconData icon,
    required int count,
    required Color color,
    required VoidCallback onTap,
    bool showCount = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            if (showCount && count > 0) ...[
              SizedBox(width: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor(String avatar) {
    switch (avatar) {
      case 'J':
        return Colors.purple;
      case 'S':
        return Colors.pink;
      case 'M':
        return Colors.orange;
      case 'U':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class Comment {
  final String username;
  final String handle;
  final String comment;
  final String timeAgo;
  final String avatar;

  Comment({
    required this.username,
    required this.handle,
    required this.comment,
    required this.timeAgo,
    required this.avatar,
  });
}

class CheckerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final squareSize = 8.0;

    for (int i = 0; i < (size.width / squareSize).ceil(); i++) {
      for (int j = 0; j < (size.height / squareSize).ceil(); j++) {
        paint.color = (i + j) % 2 == 0 ? Colors.white : Colors.black;
        canvas.drawRect(
          Rect.fromLTWH(
            i * squareSize,
            j * squareSize,
            squareSize,
            squareSize,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
