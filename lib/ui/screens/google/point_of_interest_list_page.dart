import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/google/google_place_cubit.dart';
import 'package:flutter_journey_diary/blocs/google/google_point_of_interest_cubit.dart';
import 'package:flutter_journey_diary/blocs/google/google_point_of_interest_state.dart';
import 'package:flutter_journey_diary/models/data_state.dart';
import 'package:flutter_journey_diary/models/google_place.dart';
import 'package:flutter_journey_diary/ui/screens/google/point_of_interest_details_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:transparent_image/transparent_image.dart';

class GooglePointOfInterestListPage extends StatefulWidget {
  const GooglePointOfInterestListPage(this.place, {super.key});

  final GooglePlace place;

  @override
  State<GooglePointOfInterestListPage> createState() =>
      _GooglePointOfInterestListPageState();
}

class _GooglePointOfInterestListPageState
    extends State<GooglePointOfInterestListPage> {
  @override
  void initState() {
    context
        .read<GooglePointOfInterestCubit>()
        .getPointsOfInterest(widget.place);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Points d'intérêts"),
        backgroundColor: const Color(JDColor.congoPink),
      ),
      body: SafeArea(
        child: Center(
          child: BlocBuilder<GooglePointOfInterestCubit,
              GooglePointOfInterestState>(
            builder: (context, state) {
              switch (state.dataState) {
                case DataState.loading:
                  {
                    return const CircularProgressIndicator(
                        color: Color(JDColor.congoPink));
                  }
                case DataState.loaded:
                  {
                    return RefreshIndicator(
                      color: const Color(JDColor.congoPink),
                      backgroundColor: Colors.white,
                      onRefresh: () => context
                          .read<GooglePointOfInterestCubit>()
                          .getPointsOfInterest(widget.place),
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: state.pointsOfInterest!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PointOfInterestDetailsPage(
                                        state.pointsOfInterest![index]),
                              ),
                            ),
                            leading: context
                                    .read<GooglePlaceCubit>()
                                    .getImageUrl(state.pointsOfInterest?[index]
                                        .photos?[0]['photo_reference'])
                                    .isEmpty
                                ? Image.asset(
                                    'assets/images/logoJourneyDiary.png',
                                    height: 100,
                                    width: 100,
                                  )
                                : FadeInImage.memoryNetwork(
                                    image: context
                                        .read<GooglePlaceCubit>()
                                        .getImageUrl(state
                                            .pointsOfInterest?[index]
                                            .photos?[0]['photo_reference']),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    placeholder: kTransparentImage,
                                  ),
                            title:
                                Text(state.pointsOfInterest?[index].name ?? ''),
                            subtitle: RatingBar.builder(
                              initialRating: state
                                      .pointsOfInterest?[index].rating
                                      ?.toDouble() ??
                                  0.0,
                              minRating: 1,
                              maxRating: 5,
                              ignoreGestures: true,
                              itemSize: 25.0,
                              itemBuilder: (BuildContext context, int index) =>
                                  const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (double value) {},
                            ),
                            trailing: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                case DataState.error:
                  {
                    return Text(
                      "Une erreur est survenue, veuillez relancer l'application",
                      style: Theme.of(context).textTheme.labelMedium,
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
