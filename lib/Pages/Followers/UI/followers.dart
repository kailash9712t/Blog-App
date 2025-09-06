import 'package:flutter/material.dart';

class TwitterFollower {
  final String id;
  final String name;
  final String username;
  final String avatarUrl;
  final bool isVerified;
  final bool isFollowing;
  final bool followsYou;
  final String bio;

  TwitterFollower({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarUrl,
    this.isVerified = false,
    this.isFollowing = false,
    this.followsYou = false,
    required this.bio,
  });
}

class FollowersPage extends StatefulWidget {
  final String username;
  final int followersCount;

  const FollowersPage({
    Key? key,
    required this.username,
    required this.followersCount,
  }) : super(key: key);

  @override
  State<FollowersPage> createState() => _TwitterFollowersPageState();
}

class _TwitterFollowersPageState extends State<FollowersPage>
    with TickerProviderStateMixin {
  List<TwitterFollower> followers = [];
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFollowers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadFollowers() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        followers = [
          TwitterFollower(
            id: '1',
            name: 'Elon Musk',
            username: 'elonmusk',
            avatarUrl: 'https://i.pravatar.cc/150?img=12',
            isVerified: true,
            isFollowing: false,
            followsYou: false,
            bio: 'CEO of SpaceX and Tesla',
          ),
          TwitterFollower(
            id: '2',
            name: 'Flutter',
            username: 'FlutterDev',
            avatarUrl: 'https://i.pravatar.cc/150?img=13',
            isVerified: true,
            isFollowing: true,
            followsYou: true,
            bio: 'Google\'s UI toolkit for building natively compiled applications 💙',
          ),
          TwitterFollower(
            id: '3',
            name: 'John Doe',
            username: 'johndoe',
            avatarUrl: 'https://i.pravatar.cc/150?img=14',
            isVerified: false,
            isFollowing: false,
            followsYou: true,
            bio: 'Software Developer | React & Flutter enthusiast | Coffee lover ☕',
          ),
          TwitterFollower(
            id: '4',
            name: 'Sarah Wilson',
            username: 'sarah_wilson',
            avatarUrl: 'https://i.pravatar.cc/150?img=15',
            isVerified: true,
            isFollowing: true,
            followsYou: false,
            bio: 'Product Designer @Google | UX/UI | Creating delightful experiences ✨',
          ),
          TwitterFollower(
            id: '5',
            name: 'TechCrunch',
            username: 'TechCrunch',
            avatarUrl: 'https://i.pravatar.cc/150?img=16',
            isVerified: true,
            isFollowing: false,
            followsYou: false,
            bio: 'Startup and technology news. Part of Verizon Media.',
          ),
          TwitterFollower(
            id: '6',
            name: 'Mark Johnson',
            username: 'markj_dev',
            avatarUrl: 'https://i.pravatar.cc/150?img=17',
            isVerified: false,
            isFollowing: true,
            followsYou: true,
            bio: 'Full Stack Developer | Open Source Contributor | Building cool stuff 🚀',
          ),
          TwitterFollower(
            id: '7',
            name: 'Lisa Chen',
            username: 'lisa_codes',
            avatarUrl: 'https://i.pravatar.cc/150?img=18',
            isVerified: false,
            isFollowing: false,
            followsYou: true,
            bio: 'iOS Developer | Swift | SwiftUI | Tech blogger',
          ),
          TwitterFollower(
            id: '8',
            name: 'GitHub',
            username: 'github',
            avatarUrl: 'https://i.pravatar.cc/150?img=19',
            isVerified: true,
            isFollowing: true,
            followsYou: false,
            bio: 'Where the world builds software. Need help? @GitHubSupport',
          ),
        ];
        isLoading = false;
      });
    });
  }

  void _toggleFollow(String followerId) {
    setState(() {
      followers = followers.map((follower) {
        if (follower.id == followerId) {
          return TwitterFollower(
            id: follower.id,
            name: follower.name,
            username: follower.username,
            avatarUrl: follower.avatarUrl,
            isVerified: follower.isVerified,
            isFollowing: !follower.isFollowing,
            followsYou: follower.followsYou,
            bio: follower.bio,
          );
        }
        return follower;
      }).toList();
    });
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.username,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '@${widget.username.toLowerCase()}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF1DA1F2),
            indicatorWeight: 2,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(text: '${_formatCount(widget.followersCount)} Followers'),
              Tab(text: '${_formatCount(892)} Following'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Followers Tab
          _buildFollowersList(),
          // Following Tab
          _buildFollowingList(),
        ],
      ),
    );
  }

  Widget _buildFollowersList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1DA1F2)),
        ),
      );
    }

    return ListView.builder(
      itemCount: followers.length,
      itemBuilder: (context, index) {
        return _buildFollowerTile(followers[index]);
      },
    );
  }

  Widget _buildFollowingList() {
    final followingList = followers.where((f) => f.isFollowing).toList();
    
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1DA1F2)),
        ),
      );
    }

    return ListView.builder(
      itemCount: followingList.length,
      itemBuilder: (context, index) {
        return _buildFollowerTile(followingList[index]);
      },
    );
  }

  Widget _buildFollowerTile(TwitterFollower follower) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE1E8ED), width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(follower.avatarUrl),
                backgroundColor: Colors.grey[300],
              ),
            ],
          ),
          const SizedBox(width: 12),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Username Row
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              follower.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (follower.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              color: Color(0xFF1DA1F2),
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Username and Follow Badge
                Row(
                  children: [
                    Text(
                      '@${follower.username}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    if (follower.followsYou) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Follows you',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // Bio
                if (follower.bio.isNotEmpty)
                  Text(
                    follower.bio,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          
          // Follow Button
          const SizedBox(width: 12),
          _buildFollowButton(follower),
        ],
      ),
    );
  }

  Widget _buildFollowButton(TwitterFollower follower) {
    if (follower.isFollowing) {
      return SizedBox(
        height: 32,
        child: OutlinedButton(
          onPressed: () => _toggleFollow(follower.id),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFCFD9DE)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text(
            'Following',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 32,
        child: ElevatedButton(
          onPressed: () => _toggleFollow(follower.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            elevation: 0,
          ),
          child: const Text(
            'Follow',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
  }
}

// Usage example:
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter Followers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Helvetica',
      ),
      home: FollowersPage(
        username: 'john_doe',
        followersCount: 1247,
      ),
    );
  }
}