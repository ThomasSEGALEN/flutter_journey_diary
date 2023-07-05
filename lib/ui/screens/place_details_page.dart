import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/place_cubit.dart';
import 'package:flutter_journey_diary/models/place.dart';
import 'package:flutter_journey_diary/ui/screens/home_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaceDetailsPage extends StatelessWidget {
  const PlaceDetailsPage(this.place, {super.key});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Détails'),
        backgroundColor: const Color(JDColor.congoPink),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<PlaceCubit>().deletePlace(place);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Column(
        children: [
          Text(
            place.name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w900,
              fontSize: 25,
              color: Colors.grey,
            ),
          ),
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
              if (place.urls != null && place.urls!.isNotEmpty) {
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
              } else {
                return const Placeholder();
              }
            },
          ),
          Text(
            place.locality,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w900,
              fontSize: 25,
              color: const Color(JDColor.terraCotta),
            ),
          ),
          Text(
            place.description!,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w900,
              fontSize: 25,
              color: const Color(JDColor.terraCotta),
            ),
          )
        ],
      ),
    );
  }
}
