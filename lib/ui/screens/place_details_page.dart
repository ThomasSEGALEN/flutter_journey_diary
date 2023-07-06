import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/place_cubit.dart';
import 'package:flutter_journey_diary/models/place.dart';
import 'package:flutter_journey_diary/ui/screens/home_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';

class PlaceDetailsPage extends StatefulWidget {
  const PlaceDetailsPage(this.place, {super.key});

  final Place place;

  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final Place place = widget.place;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Détails'),
        backgroundColor: const Color(JDColor.congoPink),
        actions: [
          IconButton(
            onPressed: () => _dialogBuilder(context),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        CarouselSlider.builder(
                          options: CarouselOptions(
                            height: 300,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                          ),
                          itemCount: place.urls?.length,
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            if (place.urls!.isNotEmpty) {
                              return Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(place.urls![index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 300,
                                width: 300,
                                child: Image.asset(
                                    'assets/images/logoJourneyDiary.png'),
                              );
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                                Icons.drive_file_rename_outline_outlined),
                            const VerticalDivider(),
                            Flexible(
                              child: Text(
                                place.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.description_outlined),
                            const VerticalDivider(),
                            Flexible(
                              child: Text(
                                place.description!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.place_outlined),
                            const VerticalDivider(),
                            Flexible(
                              child: Text(
                                place.locality,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Suppression d'un voyage",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: const Color(JDColor.congoPink)),
          ),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer ce voyage ?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Annuler',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Supprimer',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: const Color(JDColor.congoPink)),
              ),
              onPressed: () async {
                await context.read<PlaceCubit>().deletePlace(widget.place);

                if (!mounted) return;

                print(widget.place);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
