import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_journey_diary/models/place.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class PlacePage extends StatelessWidget {
  const PlacePage(this.place, {super.key});
  
  final Place place;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Text(place.name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w900,
              fontSize: 25,
              color: Colors.grey,
            ),),
          CarouselSlider.builder(

            options: CarouselOptions(
                height: 180.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,

          ),
            itemCount: place.urls?.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              if (place.urls != null && place.urls!.isNotEmpty ) {
                return Container(
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(place.urls![index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
              }
              else {
                return const Placeholder();
              }
            },
          ),
        Text(place.locality,style: GoogleFonts.poppins(
          fontWeight: FontWeight.w900,
          fontSize: 25,
          color: const Color(JourneyColor.terraCotta),
        ),),
          Text(place.description!,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w900,
              fontSize: 25,
              color: const Color(JourneyColor.terraCotta),
            ),)
        ],
      ),
    );
  }
}
