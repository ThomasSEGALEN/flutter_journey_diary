import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/google/google_point_of_interest_cubit.dart';
import 'package:flutter_journey_diary/blocs/notebook/to_visit_cubit.dart';
import 'package:flutter_journey_diary/models/google_point_of_interest.dart';
import 'package:flutter_journey_diary/ui/screens/home_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';

class PointOfInterestDetailsPage extends StatefulWidget {
  const PointOfInterestDetailsPage(this.pointOfInterest, {super.key});

  final GooglePointOfInterest pointOfInterest;

  @override
  State<PointOfInterestDetailsPage> createState() =>
      _PointOfInterestDetailsPageState();
}

class _PointOfInterestDetailsPageState
    extends State<PointOfInterestDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.pointOfInterest.name!),
        backgroundColor: const Color(JDColor.congoPink),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () async {
              widget.pointOfInterest.isPlanned
                  ? await context
                      .read<ToVisitCubit>()
                      .removeFromVisits(widget.pointOfInterest)
                  : await context
                      .read<ToVisitCubit>()
                      .addToVisits(widget.pointOfInterest);

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    widget.pointOfInterest.isPlanned
                        ? 'Ajouté dans la catégorie À visiter'
                        : 'Retiré de la catégorie À visiter',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white),
                  ),
                  action: SnackBarAction(
                    label: 'Cacher',
                    textColor: const Color(JDColor.congoPink),
                    onPressed: () {},
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: RichText(
                  text: TextSpan(
                    text: 'Cliquez sur le ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: 'coeur ',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: const Color(JDColor.congoPink)),
                      ),
                      TextSpan(
                        text: 'pour ajouter ce lieu à la catégorie ',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextSpan(
                        text: 'À visiter !',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: const Color(JDColor.congoPink)),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            widget.pointOfInterest.name!,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(color: Colors.black),
                          ),
                          Text(
                            widget.pointOfInterest.vicinity!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            "${widget.pointOfInterest.rating!}/5",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            "${widget.pointOfInterest.totalRating!} avis",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              widget.pointOfInterest.photos != null
                  ? CarouselSlider.builder(
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
                      itemCount: widget.pointOfInterest.photos?.length ?? 0,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(context
                                  .read<GooglePointOfInterestCubit>()
                                  .getImageUrl(widget.pointOfInterest
                                      .photos?[index]['photo_reference'])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    )
                  : const SizedBox(),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    text: "Revenir à l'écran d'",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'accueil',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: const Color(JDColor.congoPink)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
