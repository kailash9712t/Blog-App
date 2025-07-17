import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isFollowing = false;
  bool _isOwnProfile = true; 

  final UserProfile userProfile = UserProfile(
    name: "John Doe",
    handle: "@johndoe",
    avatar: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgWkA3X9cdGn3tggpvy_hnWe0QmRZW-DjwHw&s",
    coverImage:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTZB3inQS_rlFHLkaHoCVN7aXs4ZiYNySBtg&s",
    bio:
        "Flutter Developer & Tech Enthusiast 🚀\nBuilding beautiful mobile experiences\n📍 San Francisco, CA",
    location: "San Francisco, CA",
    website: "johndoe.dev",
    joinDate: "March 2020",
    following: 892,
    followers: 1247,
    posts: 348,
    isVerified: true,
  );

  // default user

  List<BlogPost> userPosts = [
    BlogPost(
      id: "1",
      userName: "John Doe",
      userHandle: "@johndoe",
      userAvatar: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgWkA3X9cdGn3tggpvy_hnWe0QmRZW-DjwHw&s",
      timeAgo: "3h",
      content:
          "Just shipped a new Flutter app! The development experience keeps getting better with each update. 🔥",
      imageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTZB3inQS_rlFHLkaHoCVN7aXs4ZiYNySBtg&s",
      likes: 156,
      comments: 23,
      reposts: 45,
      isLiked: false,
    ),
    BlogPost(
      id: "2",
      userName: "John Doe",
      userHandle: "@johndoe",
      userAvatar: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgWkA3X9cdGn3tggpvy_hnWe0QmRZW-DjwHw&s",
      timeAgo: "1d",
      content:
          "Working on some exciting new features. Can't wait to share them with you all! Stay tuned... 👀",
      likes: 89,
      comments: 12,
      reposts: 8,
      isLiked: true,
    ),
    BlogPost(
      id: "3",
      userName: "John Doe",
      userHandle: "@johndoe",
      userAvatar: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgWkA3X9cdGn3tggpvy_hnWe0QmRZW-DjwHw&s",
      timeAgo: "2d",
      content:
          "Beautiful sunset today! Sometimes you need to step away from the code and enjoy the simple things in life. 🌅",
      imageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTZB3inQS_rlFHLkaHoCVN7aXs4ZiYNySBtg&s",
      likes: 234,
      comments: 67,
      reposts: 23,
      isLiked: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
      if (_isFollowing) {
        userProfile.followers++;
      } else {
        userProfile.followers--;
      }
    });
    HapticFeedback.lightImpact();
  }

  void _toggleLike(String postId) {
    setState(() {
      final post = userPosts.firstWhere((p) => p.id == postId);
      post.isLiked = !post.isLiked;
      post.likes += post.isLiked ? 1 : -1;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              _buildSliverAppBar(),
              _buildSliverProfileHeader(),
              _buildSliverTabBar(),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [_buildPostsTab(), _buildMediaTab(), _buildLikesTab()],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      pinned: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          HapticFeedback.selectionClick();
          Navigator.pop(context);
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userProfile.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${userProfile.posts} posts',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {
            HapticFeedback.selectionClick();
            _showOptionsBottomSheet();
          },
        ),
      ],
    );
  }

  Widget _buildSliverProfileHeader() {
    return SliverToBoxAdapter(
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // background image
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(userProfile.coverImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // profile info
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // avatar
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Transform.translate(
                          offset: Offset(0, -40),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(userProfile.avatar),
                            ),
                          ),
                        ),
                        Spacer(),
                        if (_isOwnProfile)
                          _buildActionButton(
                            text: 'Edit Profile',
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              _showEditProfileDialog();
                            },
                            isPrimary: false,
                          )
                        else
                          Row(
                            children: [
                              _buildActionButton(
                                text: 'Message',
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                },
                                isPrimary: false,
                              ),
                              SizedBox(width: 8),
                              _buildActionButton(
                                text: _isFollowing ? 'Following' : 'Follow',
                                onPressed: _toggleFollow,
                                isPrimary: !_isFollowing,
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // user info
                    Row(
                      children: [
                        Text(
                          userProfile.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (userProfile.isVerified) ...[
                          SizedBox(width: 4),
                          Icon(Icons.verified, color: Colors.blue, size: 20),
                        ],
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      userProfile.handle,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 12),
                    // bio
                    Text(
                      userProfile.bio,
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                    SizedBox(height: 12),
                    // location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          userProfile.location,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.link, color: Colors.grey[600], size: 16),
                        SizedBox(width: 4),
                        Text(
                          userProfile.website,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // join date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Joined ${userProfile.joinDate}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // state
                    Row(
                      children: [
                        _buildStatItem('Following', userProfile.following),
                        SizedBox(width: 20),
                        _buildStatItem('Followers', userProfile.followers),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Container(
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.blue : Colors.transparent,
          foregroundColor: isPrimary ? Colors.white : Colors.blue,
          elevation: 0,
          side: BorderSide(color: Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
      },
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: count.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextSpan(
              text: ' $label',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverTabBarDelegate(
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey[600],
          labelStyle: TextStyle(fontWeight: FontWeight.w600),
          tabs: [Tab(text: 'Posts'), Tab(text: 'Media'), Tab(text: 'Likes')],
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: userPosts.length,
      itemBuilder: (context, index) {
        return _buildPostCard(userPosts[index]);
      },
    );
  }

  Widget _buildMediaTab() {
    final mediaPosts =
        userPosts.where((post) => post.imageUrl != null).toList();

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: mediaPosts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              mediaPosts[index].imageUrl!,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLikesTab() {
    final likedPosts = userPosts.where((post) => post.isLiked).toList();

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: likedPosts.length,
      itemBuilder: (context, index) {
        return _buildPostCard(likedPosts[index]);
      },
    );
  }

  Widget _buildPostCard(BlogPost post) {
    return Container(
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
          // post header
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
          // content
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
          // action
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

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Share Profile'),
                onTap: () {
                  Navigator.pop(context);
                  HapticFeedback.selectionClick();
                },
              ),
              ListTile(
                leading: Icon(Icons.block),
                title: Text('Block User'),
                onTap: () {
                  Navigator.pop(context);
                  HapticFeedback.selectionClick();
                },
              ),
              ListTile(
                leading: Icon(Icons.report),
                title: Text('Report User'),
                onTap: () {
                  Navigator.pop(context);
                  HapticFeedback.selectionClick();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Text(
            'Profile editing functionality would be implemented here.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

class UserProfile {
  final String name;
  final String handle;
  final String avatar;
  final String coverImage;
  final String bio;
  final String location;
  final String website;
  final String joinDate;
  final int following;
  int followers;
  final int posts;
  final bool isVerified;

  UserProfile({
    required this.name,
    required this.handle,
    required this.avatar,
    required this.coverImage,
    required this.bio,
    required this.location,
    required this.website,
    required this.joinDate,
    required this.following,
    required this.followers,
    required this.posts,
    required this.isVerified,
  });
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
