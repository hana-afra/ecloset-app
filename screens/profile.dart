import 'package:ecloset/constants/endpoints.dart';
import 'package:ecloset/models/product.dart';
import 'package:ecloset/screens/signup.dart';
import 'package:ecloset/tabs/profileitems.dart';
import 'package:ecloset/widgets/buttom_navbar.dart';
import 'package:ecloset/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final Product product;

  ProfilePage({required this.product});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences _prefs;
  late String _userId;
  TextEditingController _idController = TextEditingController();
  bool isFollowing = false;
  int followersCount = 0;
  int followingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchFollowersCount();
    fetchFollowingCount();
    checkIfFollowing();
  }

  Future<void> _loadUserData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _idController.text = _prefs.getString('user_id') ?? '';
    });
  }

  Future<void> followUser(String followerId, String followedId) async {
    try {
      final response = await dio.get(
        '$api_endpoint_follow_user?follower_id=$followerId&followed_id=$followedId',
      );
      if (response.statusCode == 200) {
        print("success");
      } else {
        print("fail");
        print("Error: ${response.statusCode}, ${response.statusCode}");
      }
    } catch (e) {
      print('Error executing query: $e');
    }
  }

  Future<void> unfollowUser(String followerId, String followedId) async {
    try {
      final response = await dio.get(
        '$api_endpoint_unfollow_user?follower_id=$followerId&followed_id=$followedId',
      );
      if (response.statusCode == 200) {
        print("success");
      } else {
        print("fail");
        print("Error: ${response.statusCode}, ${response.statusCode}");
      }
    } catch (e) {
      print('Error executing query: $e');
    }
  }

  Future<bool> isFollowingCurrentUser(String currentUserId, String targetUserId) async {
    print('Checking if following: $currentUserId -> $targetUserId');
    try {
      final response = await dio.get(
        '$api_endpoint_check_follow_user?follower_id=$currentUserId&followed_id=$targetUserId',
      );
      if (response != null && response.data != null) {
        print('Following: ${response.data}');
        return true;
      } else {
        print('Not following');
        return false;
      }
    } catch (error) {
      print('Error checking if following: $error');
      return false;
    }
  }

  Future<void> fetchFollowersCount() async {
    String userId = widget.product.ownerId;
    try {
      final response = await dio.get(
        '$api_endpoint_get_followers_count?id_user=$userId',
      );
      if (response.statusCode == 200) {
        setState(() {
          followersCount = response.data['followers_count'];
        });
      } else {
        print('Error fetching followers count: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching followers count: $e');
    }
  }

  Future<void> fetchFollowingCount() async {
    String userId = widget.product.ownerId;
    try {
      final response = await dio.get(
        '$api_endpoint_get_following_count?user_id=$userId',
      );
      if (response.statusCode == 200) {
        setState(() {
          followingCount = response.data['following_count'];
        });
      } else {
        print('Error fetching following count: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching following count: $e');
    }
  }

  Future<void> checkIfFollowing() async {
    String currentUserId = _idController.text;
    bool following = await isFollowingCurrentUser(currentUserId, widget.product.ownerId);
    print(following);
    setState(() {
      isFollowing = following;
    });
  }

  Future<void> handleFollowClick() async {
    String currentUserId = _idController.text;
    print(isFollowing);
    if (isFollowing) {
      await unfollowUser(currentUserId, widget.product.ownerId);
      print("unfollowed");
    } else {
      await followUser(currentUserId, widget.product.ownerId);
      print("followed");
    }
    await checkIfFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            elevation: 0,
            pinned: true,
            expandedHeight: 25.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 8, bottom: 1),
              title: Text(
                widget.product.ownerName,
                style: GoogleFonts.birthstone(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 36,
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
                      child: Row(
                        children: [
                          CircleAvatar( 
                             
                            backgroundImage: 
                                NetworkImage(widget.product.ownerProfilePicture), 
                            radius: 70, 
                          ),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '    $followersCount',
                                        style: GoogleFonts.birthstone(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 28,
                                        ),
                                      ),
                                      Text(
                                        'Followers',
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 40),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '    $followingCount',
                                        style: GoogleFonts.birthstone(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 28,
                                        ),
                                      ),
                                      Text(
                                        'Following',
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: handleFollowClick,
                                    child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                                  ),
                                  SizedBox(width: 10),
                                  ButtonP(text: 'Message'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'What I sell? ',
                        style: GoogleFonts.birthstone(
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFB38586),
                          fontSize: 44,
                        ),
                      ),
                    ),
                    ProfileItem(id: widget.product.ownerId),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
