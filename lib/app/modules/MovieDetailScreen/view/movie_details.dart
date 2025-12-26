import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:state_extended/state_extended.dart';

import '../controller/movie_details_controller.dart';

class MovieDetailScreen extends StatefulWidget {
  final String imdbId;
  final String heroTag;

  const MovieDetailScreen({super.key, required this.imdbId, required this.heroTag});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends StateX<MovieDetailScreen> {
  late MovieDetailController con;

  _MovieDetailScreenState()
    : super(controller: MovieDetailController(), useInherited: true) {
    con = controller as MovieDetailController;
  }

  @override
  void initState() {
    super.initState();
    con.fetchMovieDetails(widget.imdbId);
  }

  @override
  Widget build(BuildContext context) {
    if (con.loading) {
      return circularIndicator();
    }

    final Map<String, dynamic>? data = con.movieData;

    if (data == null) {
      return movieNotAvail();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          buildPositioned(data),

          buildAlign(context, data),

          buildPositionedNavigation(context),
        ],
      ),
    );
  }

  Positioned buildPositionedNavigation(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: EdgeInsets.all(6.r),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
    );
  }

  Align buildAlign(BuildContext context, Map<String, dynamic> data) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.58,
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.5),
              Colors.black.withValues(alpha: 0.7),
              Colors.black,
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['Title'] ?? '',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 6.h),

                Row(
                  children: [
                    Icon(Icons.star_border, color: Colors.grey, size: 16.sp),
                    Text(
                      ' ${data['imdbRating'] ?? 'N/A'} ',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                    SizedBox(width: 15.w),
                    Icon(Icons.access_time, color: Colors.grey, size: 16.sp),
                    Text(
                      ' ${data['Runtime'] ?? ''}',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hologram",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: (data['Genre'] as String)
                          .split(',')
                          .map(
                            (g) => Container(
                              margin: EdgeInsets.only(right: 8.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                g.trim(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),
                Divider(color: Colors.grey.withValues(alpha: 30)),
                SizedBox(height: 10.h),

                Text(
                  data['Plot'] ?? '',
                  style: TextStyle(
                    color: Colors.grey.withValues(alpha: 10),
                    height: 1.5,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 18.h),

                _detailRow('Director', data['Director']),
                _detailRow('Writer', data['Writer']),
                _detailRow('Actors', data['Actors']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned buildPositioned(Map<String, dynamic> data) {
    return Positioned.fill(
      child: Hero(
        tag: widget.heroTag,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(data['Poster'] ?? '', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0),
                    Colors.black.withValues(alpha: 0),
                    Colors.black.withValues(alpha: 0.9),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold movieNotAvail() {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text('Movie details not available', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Scaffold circularIndicator() {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  Widget _detailRow(String label, dynamic value) {
    if (value == null || value.toString().isEmpty) return const SizedBox();

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                color: Colors.grey.withValues(alpha: 10),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value.toString(),
              style: TextStyle(color: Colors.grey.withValues(alpha: 10)),
            ),
          ],
        ),
      ),
    );
  }
}
