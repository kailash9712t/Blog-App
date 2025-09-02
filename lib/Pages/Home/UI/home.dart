// ignore_for_file: non_constant_identifier_names

import 'package:blog/Models/BlogPost/post.dart';
import 'package:blog/Models/User/user_profile.dart';
import 'package:blog/Pages/Home/State/home.dart';
import 'package:blog/Utils/user_data_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

class BlogHomeScreen extends StatefulWidget {
  const BlogHomeScreen({super.key});

  @override
  _BlogHomeScreenState createState() => _BlogHomeScreenState();
}

class _BlogHomeScreenState extends State<BlogHomeScreen>
    with TickerProviderStateMixin {
  final TextEditingController _postController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final String currentUserName = "John Doe";
  final String currentUserHandle = "@johndoe";
  String? currentUserAvatar;

  Logger logs = Logger(
      level: kReleaseMode ? Level.off : Level.debug,
      printer: PrettyPrinter(methodCount: 1, colors: true));

  @override
  void initState() {
    currentUserAvatar = UserDataProvider().userModel.profileUrl;

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _postController.dispose();
    _scrollController.dispose();
    super.dispose();
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
                  itemCount: context.read<HomePageModel>().posts.length,
                  itemBuilder: (context, index) {
                    return _buildPostCard(
                        context.read<HomePageModel>().posts[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
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
              context.push(
                  '/userProfile?username=${context.read<UserDataProvider>().userModel.username}&isUserProfile=true');
            },
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey,
              child: ClipOval(
                child: Selector<UserProfileState, String?>(
                    builder: (_, profile_url, __) {
                      return Image.network(
                        profile_url ?? '',
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
                          return SizedBox(
                            height: 5,
                            width: 5,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          );
                        },
                      );
                    },
                    selector: (_, model) => model.model.profileUrl),
              ),
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
                backgroundColor: Colors.grey,
                child: ClipOval(child: Selector<UserProfileState,String?>(builder: (_,profile_url,__){
                  return Image.network(
                    profile_url ?? '',
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
                  );
                }, selector: (_,model) => model.model.profileUrl)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<HomePageModel>(
                        builder: (context, instance, child) {
                      return TextField(
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
                        maxLines: instance.isPostExtend ? 6 : 3,
                        onTap: instance.togglePostExpansion,
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
          Consumer<HomePageModel>(builder: (context, instance, child) {
            if (!instance.isPostExtend) return SizedBox.shrink();
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    return SizedBox(
                        height: 70,
                        width: constraints.maxHeight,
                        child: Consumer<HomePageModel>(
                            builder: (context, instance, child) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: instance.imageInList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  height: 40,
                                  width: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Image.file(
                                            instance.imageInList[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 2,
                                          right: 2,
                                          child: Container(
                                            width: 27,
                                            height: 27,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              shape: BoxShape.circle,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                logs.i(index);
                                                context
                                                    .read<HomePageModel>()
                                                    .removeImage(index);
                                              },
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.red,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }));
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildActionButton(
                            icon: Icons.photo_library,
                            color: Colors.blue,
                            onTap: () {
                              context
                                  .read<HomePageModel>()
                                  .pickImageFromSource();
                            },
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
                      Selector<HomePageModel, Map<String, UploadStatus>>(
                          builder: (_, values, __) {
                            return ElevatedButton(
                                onPressed: values["uploadPost"] ==
                                        UploadStatus.notStart
                                    ? () {
                                        context
                                            .read<HomePageModel>()
                                            .publishPost(
                                                _postController.text, context);

                                        _postController.clear();
                                      }
                                    : () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                                child: values["uploadPost"] ==
                                        UploadStatus.notStart
                                    ? Text(
                                        'Post',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      )
                                    : SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ));
                          },
                          selector: (_, model) => model.values)
                    ],
                  ),
                ]);
          })
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
          GestureDetector(
            onTap: () {
              print(post.userHandle);
              context.push(
                  "/userProfile?username=${post.userHandle}&isUserProfile=${post.userHandle == context.read<UserDataProvider>().userModel.username ? true : false}");
            },
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: ClipOval(
                        child: Image.network(
                          post.userAvatar ?? "",
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
                                post.userName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                post.userHandle ?? "user",
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
                if (post.profileUrl != null) ...[
                  SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      post.profileUrl ?? '',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'Assets\Image\failed_image.png',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  )
                ],
              ],
            ),
          ),
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
                onTap: () => context.read<HomePageModel>().toggleLike(post.id),
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

  Future<void> _refreshFeed() async {
    await Future.delayed(Duration(seconds: 1));
    HapticFeedback.lightImpact();
  }
}
