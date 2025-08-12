import 'package:blog/Models/BlogPost/post.dart';
import 'package:blog/Models/Hive_Model/UserData/user.dart';
import 'package:blog/Pages/Home/State/home.dart';
import 'package:blog/Pages/User/State/user.dart';
import 'package:blog/Utils/date_and_time.dart';
import 'package:blog/Utils/user_data_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  final bool isUserProfile;
  final String username;
  const UserProfilePage(
      {super.key, required this.isUserProfile, required this.username});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Logger logs = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: PrettyPrinter(methodCount: 1, colors: true),
  );

  @override
  void initState() {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainTask();
      context.read<UserPageModel>().isFollowing = true;
    });
    super.initState();
  }

  void mainTask() async {
    await context
        .read<UserPageModel>()
        .initialTask(context, widget.isUserProfile, widget.username);

    if (!mounted) return;

    context.read<UserPageModel>().loadPost(context);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
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
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Selector<UserPageModel, String?>(
            builder: (_, displayName, __) {
              return Text(
                displayName ?? "user",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
            selector: (_, model) => model.userModel.displayName,
          ),
          Selector<UserPageModel, int>(
            builder: (_, posts, __) {
              return Text(
                '$posts posts',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              );
            },
            selector: (_, model) => model.userModel.posts,
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
    UserModel user = context.read<UserDataProvider>().userModel;
    return SliverToBoxAdapter(
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Consumer<UserDataProvider>(builder: (context, instance, child) {
                return SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    instance.userModel.coverUrl ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Image.asset(
                          "Assets/Image/image_failed_to_load.png",
                          height: 60,
                          width: 60,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                );
              }),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              radius: 50,
                              backgroundColor: Colors.grey,
                              child: ClipOval(
                                child: Consumer<UserDataProvider>(
                                    builder: (context, instance, child) {
                                  logs.i(
                                      "profile url : ${instance.userModel.profileUrl}");
                                  return Image.network(
                                    instance.userModel.profileUrl ?? '',
                                    width: 100,
                                    height: 100,
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
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        if (widget.isUserProfile)
                          _buildActionButton(
                            text: 'Edit Profile',
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              context.push("/profileSetUp1?editPage=true");
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
                              Selector<UserPageModel, bool>(
                                  builder: (_, isFollow, __) {
                                    return _buildActionButton(
                                      text: isFollow ? 'Following' : 'Follow',
                                      onPressed: () {
                                        context
                                            .read<UserPageModel>()
                                            .follow(context, {});
                                      },
                                      isPrimary: !isFollow,
                                    );
                                  },
                                  selector: (__, model) => model.isFollowing),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Selector<UserPageModel, String?>(
                            builder: (_, displayName, __) {
                              return Text(
                                displayName ?? "Failed",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                            selector: (_, model) =>
                                model.userModel.displayName),
                        if (user.isVerify) ...[
                          SizedBox(width: 4),
                          Icon(Icons.verified, color: Colors.blue, size: 20),
                        ],
                      ],
                    ),
                    SizedBox(height: 4),
                    Selector<UserPageModel, String?>(
                        builder: (_, username, __) {
                          return Text(
                            username ?? "Failed",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          );
                        },
                        selector: (_, model) => model.userModel.username),
                    SizedBox(height: 12),
                    Selector<UserPageModel, String?>(
                      builder: (_, bio, __) {
                        return Text(
                          bio ?? "Failed",
                          style: TextStyle(fontSize: 16, height: 1.4),
                        );
                      },
                      selector: (_, model) => model.userModel.bio,
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Selector<UserPageModel, String?>(
                          builder: (_, location, __) {
                            return Text(
                              location ?? "Failed",
                              style: TextStyle(color: Colors.grey[600]),
                            );
                          },
                          selector: (_, model) => model.userModel.location,
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.link, color: Colors.grey[600], size: 16),
                        SizedBox(width: 4),
                        Selector<UserPageModel, String?>(
                          builder: (_, website, __) {
                            return Text(
                              website ?? "kailash.dev",
                              style: TextStyle(color: Colors.blue),
                            );
                          },
                          selector: (_, model) => model.userModel.website,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Selector<UserPageModel, String?>(
                          builder: (_, joiningDate, __) {
                            return Text(
                              'Joined $joiningDate',
                              style: TextStyle(color: Colors.grey[600]),
                            );
                          },
                          selector: (_, model) => model.userModel.joiningDate,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Selector<UserPageModel, int>(
                          builder: (_, following, __) {
                            return _buildStatItem('Following', following);
                          },
                          selector: (_, model) => model.userModel.following,
                        ),
                        SizedBox(width: 20),
                        Selector<UserPageModel, int>(
                          builder: (_, followers, __) {
                            return _buildStatItem('Following', followers);
                          },
                          selector: (_, model) => model.userModel.followers,
                        ),
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
    return SizedBox(
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
    return Consumer<UserPageModel>(builder: (context, instance, child) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: instance.personalPost.length,
        itemBuilder: (context, index) {
          return _buildPostCard(instance.personalPost[index]);
        },
      );
    });
  }

  Widget _buildMediaTab() {
    return Consumer<UserPageModel>(builder: (context, instance, child) {
      final mediaPosts = instance.personalPost
          .where((post) => post.profileUrl != null)
          .toList();

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
                mediaPosts[index].profileUrl!,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildLikesTab() {
    return Consumer<UserPageModel>(builder: (context, instance, child) {
      final likedPosts =
          instance.personalPost.where((post) => post.isLiked).toList();

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: likedPosts.length,
        itemBuilder: (context, index) {
          return _buildPostCard(likedPosts[index]);
        },
      );
    });
  }

  Widget _buildPostCard(BlogPost post) {
    UserModel userData = context.read<UserDataProvider>().userModel;
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
              Consumer<HomePageModel>(builder: (context, instance, child) {
                return _buildPostAction(
                  icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                  count: post.likes,
                  color: post.isLiked ? Colors.red : Colors.grey[600]!,
                  onTap: () =>
                      context.read<UserPageModel>().toggleLike(post.id),
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
    );
  }

  Widget _buildPhotoLayout(List<String> images) {
    final int imageCount = images.length;

    if (imageCount == 1) {
      // Single image - full width
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
      // Two images - side by side
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
      // Three images - first image on left, two stacked on right
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
      // Four images - 2x2 grid
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
      // More than 4 images - show first 3 and "+X more" overlay on the last one
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
