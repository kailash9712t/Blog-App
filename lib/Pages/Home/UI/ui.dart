import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class BlogHomeScreen extends StatefulWidget {
  const BlogHomeScreen({super.key});

  @override
  _BlogHomeScreenState createState() => _BlogHomeScreenState();
}

class _BlogHomeScreenState extends State<BlogHomeScreen>
    with TickerProviderStateMixin {
  final TextEditingController _postController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isPostExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final String currentUserName = "John Doe";
  final String currentUserHandle = "@johndoe";
  final String currentUserAvatar =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgWkA3X9cdGn3tggpvy_hnWe0QmRZW-DjwHw&s";

  List<BlogPost> posts = [
    BlogPost(
      id: "1",
      userName: "Alice Johnson",
      userHandle: "@alice_j",
      userAvatar:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgWkA3X9cdGn3tggpvy_hnWe0QmRZW-DjwHw&s",
      timeAgo: "2h",
      content:
          "Just finished reading an amazing article about Flutter development. The way widgets compose together is truly beautiful! 🚀",
      imageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTZB3inQS_rlFHLkaHoCVN7aXs4ZiYNySBtg&s",
      likes: 24,
      comments: 5,
      reposts: 12,
      isLiked: false,
    ),
    BlogPost(
      id: "2",
      userName: "Tech Blogger",
      userHandle: "@techblogger",
      userAvatar:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCwYtl1tFUwEbfdDLVzOmud-NVp1vrzzunyMdPsCIHWH6UWEbI_Ua-I_1GOvpDYFCDgpQ&usqp=CAU",
      timeAgo: "4h",
      content:
          "The future of mobile development is here! What do you think about the latest updates in cross-platform frameworks?",
      likes: 89,
      comments: 23,
      reposts: 34,
      isLiked: true,
    ),
    BlogPost(
      id: "3",
      userName: "Sarah Wilson",
      userHandle: "@sarah_codes",
      userAvatar:
          "https://blog.texasbar.com/files/2013/09/JessicaMangrum_smaller1.jpg",
      timeAgo: "6h",
      content:
          "Building beautiful UIs has never been easier. Here's my latest project showcase!",
      imageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTZB3inQS_rlFHLkaHoCVN7aXs4ZiYNySBtg&s",
      likes: 156,
      comments: 67,
      reposts: 23,
      isLiked: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _postController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _togglePostExpansion() {
    setState(() {
      _isPostExpanded = !_isPostExpanded;
    });
    HapticFeedback.lightImpact();
  }

  void _addPhoto() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Photo picker would open here'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _publishPost() {
    if (_postController.text.trim().isNotEmpty) {
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Post published successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _postController.clear();
      setState(() {
        _isPostExpanded = false;
      });
    }
  }

  void _toggleLike(String postId) {
    setState(() {
      final post = posts.firstWhere((p) => p.id == postId);
      post.isLiked = !post.isLiked;
      post.likes += post.isLiked ? 1 : -1;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildPostComposer(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshFeed,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return _buildPostCard(posts[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        'BlogSpace',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.grey[600]),
          onPressed: () {
            HapticFeedback.selectionClick();
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              context.push('/userProfile');
            },
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(currentUserAvatar),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostComposer() {
    return Container(
      margin: EdgeInsets.all(16),
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(currentUserAvatar),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _postController,
                      decoration: InputDecoration(
                        hintText: "What's happening?",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      style: TextStyle(fontSize: 18),
                      maxLines: _isPostExpanded ? 6 : 3,
                      onTap: _togglePostExpansion,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isPostExpanded) ...[
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.photo_library,
                      color: Colors.blue,
                      onTap: _addPhoto,
                    ),
                    SizedBox(width: 16),
                    _buildActionButton(
                      icon: Icons.emoji_emotions,
                      color: Colors.orange,
                      onTap: () {
                        HapticFeedback.selectionClick();
                      },
                    ),
                    SizedBox(width: 16),
                    _buildActionButton(
                      icon: Icons.location_on,
                      color: Colors.green,
                      onTap: () {
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _publishPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Post',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildPostCard(BlogPost post) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                radius: 20,
                backgroundImage: NetworkImage(post.userAvatar),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          post.userHandle,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '• ${post.timeAgo}',
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
          if (post.imageUrl != null) ...[
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
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
              _buildPostAction(
                icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                count: post.likes,
                color: post.isLiked ? Colors.red : Colors.grey[600]!,
                onTap: () => _toggleLike(post.id),
              ),
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
    );
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

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _togglePostExpansion,
      backgroundColor: Colors.blue,
      child: Icon(Icons.add, color: Colors.white),
    );
  }

  Future<void> _refreshFeed() async {
    await Future.delayed(Duration(seconds: 1));
    HapticFeedback.lightImpact();
  }
}

class BlogPost {
  final String id;
  final String userName;
  final String userHandle;
  final String userAvatar;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  int likes;
  final int comments;
  final int reposts;
  bool isLiked;

  BlogPost({
    required this.id,
    required this.userName,
    required this.userHandle,
    required this.userAvatar,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.reposts,
    required this.isLiked,
  });
}
