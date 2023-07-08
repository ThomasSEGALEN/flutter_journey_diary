import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/google/google_place_cubit.dart';
import 'package:flutter_journey_diary/blocs/google/google_place_state.dart';
import 'package:flutter_journey_diary/models/data_state.dart';
import 'package:flutter_journey_diary/models/google_place.dart';
import 'package:flutter_journey_diary/repositories/google/google_place_repository.dart';
import 'package:flutter_journey_diary/ui/screens/google/point_of_interest_list_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:transparent_image/transparent_image.dart';

class GooglePlaceDetailsPage extends StatefulWidget {
  const GooglePlaceDetailsPage(this.placeId, {super.key});

  final String placeId;

  @override
  State<GooglePlaceDetailsPage> createState() => _GooglePlaceDetailsPageState();
}

class _GooglePlaceDetailsPageState extends State<GooglePlaceDetailsPage> {
  final GooglePlaceRepository _googlePlaceRepository = GooglePlaceRepository();
  String placeName = '';

  @override
  void initState() {
    _getName();
    context.read<GooglePlaceCubit>().getPlace(widget.placeId);

    super.initState();
  }

  Future<void> _getName() async {
    final GooglePlace place =
        await _googlePlaceRepository.fetchPlace(widget.placeId);

    setState(() {
      placeName = place.name!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(placeName),
        backgroundColor: const Color(JDColor.congoPink),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<GooglePlaceCubit, GooglePlaceState>(
            builder: (context, state) {
              switch (state.dataState) {
                case DataState.loading:
                  {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                              color: Color(JDColor.congoPink)),
                        ],
                      ),
                    );
                  }
                case DataState.loaded:
                  {
                    return Column(
                      children: [
                        Stack(
                          children: [
                            context
                                    .read<GooglePlaceCubit>()
                                    .getImageUrl(state.place?.photos?[0]
                                        ['photo_reference'])
                                    .isEmpty
                                ? Image.asset(
                                    'assets/images/logoJourneyDiary.png',
                                    height: 350,
                                    width: MediaQuery.of(context).size.width,
                                  )
                                : FadeInImage.memoryNetwork(
                                    image: context
                                        .read<GooglePlaceCubit>()
                                        .getImageUrl(state.place?.photos?[0]
                                            ['photo_reference']),
                                    height: 350,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                    placeholder: kTransparentImage,
                                  ),
                            Positioned(
                              top: 200,
                              left: 20,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: Text(
                                      state.place!.name!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                        color: Colors.white,
                                        shadows: [
                                          const Shadow(
                                            offset: Offset(1, 1),
                                            blurRadius: 20,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: Text(
                                      state.place!.address!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                        color: Colors.white,
                                        shadows: [
                                          const Shadow(
                                            offset: Offset(1, 1),
                                            blurRadius: 20,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    GooglePointOfInterestListPage(state.place!),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                MediaQuery.of(context).size.width - 40,
                                50,
                              ),
                              backgroundColor: const Color(JDColor.congoPink),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'À visiter',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: Colors.white),
                                ),
                                const VerticalDivider(),
                                const Icon(Icons.search),
                              ],
                            ),
                          ),
                        ),
                        state.place?.photos != null
                            ? CarouselSlider.builder(
                                options: CarouselOptions(
                                  height: 200,
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                  aspectRatio: 16 / 9,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enableInfiniteScroll: true,
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  viewportFraction: 0.8,
                                ),
                                itemCount: state.place?.photos?.length,
                                itemBuilder: (BuildContext context, int index,
                                    int realIndex) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(context
                                            .read<GooglePlaceCubit>()
                                            .getImageUrl(
                                                state.place?.photos?[index]
                                                    ['photo_reference'])),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const SizedBox(),
                      ],
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
