// import 'package:flutter/material.dart';
// import '../models/post_model.dart';
// import '../services/api_service.dart';
//
// class PostsScreen extends StatefulWidget {
//   const PostsScreen({Key? key}) : super(key: key);
//
//   @override
//   State<PostsScreen> createState() => _PostsScreenState();
// }
//
// class _PostsScreenState extends State<PostsScreen> {
//   late Future<List<PostModel>> _postFuture;
//   final ApiService apiService = ApiService();
//
//   @override
//   void initState() {
//     super.initState();
//     _postFuture = apiService.fetchPosts();
//   }
//
//   void _showDialog(PostModel post) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(post.title),
//         content: Text(post.body),
//         actions: [
//           TextButton(
//             child: const Text('Close'),
//             onPressed: () => Navigator.of(context).pop(),
//           )
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeColor = Theme.of(context).primaryColor;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Posts"),
//         backgroundColor: themeColor,
//       ),
//       body: FutureBuilder<List<PostModel>>(
//         future: _postFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No posts found."));
//           }
//
//           final posts = snapshot.data!;
//
//           return ListView.separated(
//             itemCount: posts.length,
//             separatorBuilder: (_, __) => const Divider(),
//             itemBuilder: (context, index) {
//               final post = posts[index];
//               return ListTile(
//                 title: Text(post.title),
//                 subtitle: Text("Post ID: ${post.id}"),
//                 onTap: () => _showDialog(post),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<List<PostModel>> _postFuture;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _postFuture = apiService.fetchPosts();
  }

  void _showDialog(PostModel post) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: _buildDialogContent(post),
      ),
    );
  }

  Widget _buildDialogContent(PostModel post) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              post.body,
              style: TextStyle(color: Colors.black.withOpacity(0.7)),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        backgroundColor: themeColor,
        elevation: 5,
      ),
      body: FutureBuilder<List<PostModel>>(
        future: _postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingScreen();
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No posts found."));
          }

          final posts = snapshot.data!;

          return ListView.separated(
            itemCount: posts.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final post = posts[index];
              return _buildPostCard(post);
            },
          );
        },
      ),
    );
  }

  Widget _buildPostCard(PostModel post) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showDialog(post),
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.blue.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Post ID: ${post.id}",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ),
    );
  }
}
