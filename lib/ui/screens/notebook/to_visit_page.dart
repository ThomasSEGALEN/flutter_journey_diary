import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/google/google_place_cubit.dart';
import 'package:flutter_journey_diary/blocs/notebook/to_visit_cubit.dart';
import 'package:flutter_journey_diary/blocs/notebook/to_visit_state.dart';
import 'package:flutter_journey_diary/models/data_state.dart';
import 'package:flutter_journey_diary/ui/screens/google/point_of_interest_details_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:transparent_image/transparent_image.dart';

class ToVisitPage extends StatefulWidget {
  const ToVisitPage({Key? key}) : super(key: key);

  @override
  State<ToVisitPage> createState() => _ToVisitPageState();
}

class _ToVisitPageState extends State<ToVisitPage> {
  @override
  void initState() {
    context.read<ToVisitCubit>().getVisits();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("À visiter"),
        backgroundColor: const Color(JDColor.congoPink),
      ),
      body: Center(
        child: BlocBuilder<ToVisitCubit, ToVisitState>(
          builder: (context, state) {
            switch (state.dataState) {
              case DataState.loading:
                {
                  return const CircularProgressIndicator(
                      color: Color(JDColor.congoPink));
                }
              case DataState.loaded:
                {
                  return state.visits!.isNotEmpty
                      ? RefreshIndicator(
                          color: const Color(JDColor.congoPink),
                          backgroundColor: Colors.white,
                          onRefresh: () =>
                              context.read<ToVisitCubit>().getVisits(),
                          child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            itemCount: state.visits!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PointOfInterestDetailsPage(
                                            state.visits![index]),
                                  ),
                                ),
                                leading: context
                                        .read<GooglePlaceCubit>()
                                        .getImageUrl(state.visits?[index]
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
                                            .getImageUrl(state.visits?[index]
                                                .photos?[0]['photo_reference']),
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        placeholder: kTransparentImage,
                                      ),
                                title: Text(state.visits?[index].name ?? ''),
                                subtitle: RatingBar.builder(
                                  initialRating:
                                      state.visits?[index].rating?.toDouble() ??
                                          0.0,
                                  minRating: 1,
                                  maxRating: 5,
                                  ignoreGestures: true,
                                  itemSize: 25.0,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
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
                        )
                      : RichText(
                          text: TextSpan(
                            text: 'Votre liste de lieux ',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: Colors.grey),
                            children: [
                              TextSpan(
                                text: 'à visiter ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        color: const Color(JDColor.congoPink)),
                              ),
                              TextSpan(
                                text: 'est vide.',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
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
    );
  }
}
