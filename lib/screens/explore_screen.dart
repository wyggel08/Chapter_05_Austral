import 'dart:developer'; // Add this import

import 'package:flutter/material.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../api/mock_fooderlich_service.dart';

class ExploreScreen extends StatefulWidget { // 1. Change to StatefulWidget
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late ScrollController _controller; // 2. Add ScrollController

  // 3. Add scrollListener
  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      log('I am at the bottom!');
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      log('I am at the top!');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(); // 4. Initialize ScrollController
    _controller.addListener(_scrollListener); // 5. Add scroll listener
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener); // 6. Remove scroll listener
    _controller.dispose(); // Dispose of the controller to avoid memory leaks
    super.dispose();
  }

  final mockService = MockFooderlichService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mockService.getExploreData(),
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView(
            controller: _controller, // 7. Set the ScrollController
            scrollDirection: Axis.vertical,
            children: [
              TodayRecipeListView(recipes: snapshot.data?.todayRecipes ?? []),
              const SizedBox(height: 16),
              FriendPostListView(friendPosts: snapshot.data?.friendPosts ?? []),
              Container(
                height: 400,
                color: Colors.green,
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}