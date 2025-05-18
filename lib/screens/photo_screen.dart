// import 'package:flutter/material.dart';
// import '../models/photo_model.dart';
// import '../services/api_service.dart';
//
// class PhotosScreen extends StatefulWidget {
//   const PhotosScreen({Key? key}) : super(key: key);
//
//   @override
//   State<PhotosScreen> createState() => _PhotosScreenState();
// }
//
// class _PhotosScreenState extends State<PhotosScreen> {
//   final ApiService apiService = ApiService();
//   final ScrollController _scrollController = ScrollController();
//
//   List<PhotoModel> _photos = [];
//   bool _isLoading = false;
//   bool _hasMore = true;
//   int _page = 1;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchPhotos();
//     _scrollController.addListener(_onScroll);
//   }
//
//   void _fetchPhotos() async {
//     if (_isLoading) return;
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final newPhotos = await apiService.fetchPhotos(page: _page);
//       setState(() {
//         _isLoading = false;
//         if (newPhotos.isNotEmpty) {
//           _photos.addAll(newPhotos);
//           _page++;
//         } else {
//           _hasMore = false;
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       print("Error fetching photos: $e");
//     }
//   }
//
//   void _onScroll() {
//     if (_isLoading || !_hasMore) return;
//     final position = _scrollController.position;
//     if (position.pixels == position.maxScrollExtent) {
//       _fetchPhotos();
//     }
//   }
//
//   void _showImageDialog(String imageUrl, String title) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.network(
//                   imageUrl,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Text(
//                       'Failed to load image',
//                       style: TextStyle(color: Colors.red),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   title,
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 6),
//                 const Text(
//                   'Tap anywhere to close',
//                   style: TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Photos"),
//         backgroundColor: Theme.of(context).primaryColor,
//         elevation: 5,
//       ),
//       body: _photos.isEmpty && !_isLoading
//           ? _buildDefaultImage()
//           : NotificationListener<ScrollNotification>(
//         onNotification: (scrollNotification) {
//           if (scrollNotification is ScrollUpdateNotification) {
//             _onScroll();
//           }
//           return false;
//         },
//         child: ListView.separated(
//           controller: _scrollController,
//           itemCount: _photos.length + (_hasMore ? 1 : 0),
//           separatorBuilder: (_, __) => const Divider(),
//           itemBuilder: (context, index) {
//             if (index == _photos.length) {
//               return _buildLoadingIndicator();
//             }
//             final photo = _photos[index];
//             return GestureDetector(
//               onTap: () => _showImageDialog(photo.url, photo.title),
//               child: _buildPhotoCard(photo),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPhotoCard(PhotoModel photo) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 photo.thumbnailUrl,
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Icon(Icons.broken_image, size: 60, color: Colors.grey);
//                 },
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     photo.title,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Photo ID: ${photo.id}',
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     photo.url,
//                     style: const TextStyle(fontSize: 12, color: Colors.blue),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingIndicator() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       child: Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDefaultImage() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.network(
//             'https://via.placeholder.com/150/92c952',
//             width: 150,
//             height: 150,
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'No photos found',
//             style: TextStyle(fontSize: 18, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }



import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/photo_model.dart';
import '../services/api_service.dart';
import 'photo_detail_screen.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  final ApiService apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<PhotoModel> _photos = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  void _fetchPhotos() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final newPhotos = await apiService.fetchPhotos(page: _page);
      setState(() {
        _isLoading = false;
        if (newPhotos.isNotEmpty) {
          _photos.addAll(newPhotos);
          _page++;
        } else {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching photos: $e");
    }
  }

  void _onScroll() {
    if (_isLoading || !_hasMore) return;
    final position = _scrollController.position;
    if (position.pixels == position.maxScrollExtent) {
      _fetchPhotos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPhotos = _photos.where((photo) =>
        photo.title.toLowerCase().contains(_searchQuery)).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search photos...",
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 5,
      ),
      body: _photos.isEmpty && !_isLoading
          ? _buildDefaultImage()
          : NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            _onScroll();
          }
          return false;
        },
        child: ListView.separated(
          controller: _scrollController,
          itemCount: filteredPhotos.length + (_hasMore ? 1 : 0),
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            if (index == filteredPhotos.length) {
              return _buildLoadingIndicator();
            }
            final photo = filteredPhotos[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PhotoDetailScreen(photo: photo),
                  ),
                );
              },
              child: _buildPhotoCard(photo),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPhotoCard(PhotoModel photo) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                photo.thumbnailUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 60, color: Colors.grey);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Photo ID: ${photo.id}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    photo.url,
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            Container(width: 60, height: 60, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, color: Colors.white, margin: const EdgeInsets.only(bottom: 6)),
                  Container(height: 12, color: Colors.white),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://via.placeholder.com/150/92c952',
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 10),
          const Text(
            'No photos found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
