import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../model/movie_model.dart';
import '../../MovieDetailScreen/view/movie_details.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends StateX<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  _HomeScreenState() : super(controller: HomeController(), useInherited: true) {
    con = controller as HomeController;
  }
  late HomeController con;

  @override
  void initState() {
    super.initState();
    con.loadCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(),
      body: Column(
        children: [
          buildSearchMovie(),
          Expanded(
            child: con.loading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : con.movies.isEmpty
                ? const Center(
                    child: Text(
                      "Search for your favorite movies",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : buildGridViewBody(),
          ),
        ],
      ),
    );
  }

  GridView buildGridViewBody() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.45.r,
        crossAxisSpacing: 11.w,
        mainAxisSpacing: 11.h,
      ),
      itemCount: con.movies.length,
      itemBuilder: (context, index) {
        final movie = con.movies[index];
        final String uniqueTag = "${movie.imdbId}_$index";
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MovieDetailScreen(imdbId: movie.imdbId, heroTag: uniqueTag),
              ),
            );
          },
          child: buildMovieItem(movie),
        );
      },
    );
  }

  Padding buildSearchMovie() {
    return Padding(
      padding: EdgeInsets.all(14.r),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          hintText: "Search Movies",
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
        ),
        onSubmitted: (val) => con.searchMovies(val),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Browse",
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            "Movies",
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.grey),
          onPressed: () {},
        ),
      ],
      centerTitle: false,
    );
  }

  Widget buildMovieItem(Search movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: Hero(
              tag: movie.imdbId,
              child: CachedNetworkImage(imageUrl: movie.poster, fit: BoxFit.cover),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          movie.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          movie.year,
          style: TextStyle(color: Colors.grey, fontSize: 9.sp),
        ),
      ],
    );
  }
}
