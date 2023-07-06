import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_journey_diary/blocs/place_cubit.dart';
import 'package:flutter_journey_diary/blocs/place_state.dart';
import 'package:flutter_journey_diary/blocs/user_cubit.dart';
import 'package:flutter_journey_diary/models/data_state.dart';
import 'package:flutter_journey_diary/ui/screens/login_page.dart';
import 'package:flutter_journey_diary/ui/screens/place_creation_page.dart';
import 'package:flutter_journey_diary/ui/screens/place_details_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:google_maps_webservice/places.dart' as gmw;
import 'package:google_place/google_place.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart' as gpf;
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _googleApiKey = dotenv.env['GOOGLE_TOKEN'] as String;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _googleController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _googleController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    context.read<PlaceCubit>().getPlaces();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DrawerHeader(
              child: Image.asset(
                'assets/images/logoJourneyDiary.png',
                width: MediaQuery.of(context).size.width,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.travel_explore_outlined,
                color: Colors.black,
              ),
              title: Text(
                'Mes voyages',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.place_outlined,
                color: Colors.black,
              ),
              title: Text(
                'Ajouter un lieu',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlaceCreationPage(),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(width: MediaQuery.of(context).size.width),
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                color: Colors.black,
              ),
              title: Text(
                'Se déconnecter',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () async {
                final bool checkLogout =
                    await context.read<UserCubit>().logout();

                if (!mounted) return;
                if (!checkLogout) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Mes voyages"),
        backgroundColor: const Color(JDColor.congoPink),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: _googleController,
              googleAPIKey: _googleApiKey,
              inputDecoration:
                  const InputDecoration(labelText: "Vous voulez voyager ?"),
              debounceTime: 800,
              countries: const ["in", "fr"],
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (gpf.Prediction prediction) {
                print("placeDetails${prediction.lng}");
              },
              // this callback is called when isLatLngRequired is true
              itmClick: (gpf.Prediction prediction) async {
                gmw.GoogleMapsPlaces places =
                    gmw.GoogleMapsPlaces(apiKey: _googleApiKey);

                gmw.PlacesDetailsResponse detail =
                    await places.getDetailsByPlaceId(prediction.placeId!);

                double latitude = detail.result.geometry!.location.lat;
                double longitude = detail.result.geometry!.location.lng;

                GooglePlace googlePlace =
                    GooglePlace(dotenv.env["GOOGLE_TOKEN"]!);
                var result = await googlePlace.search.getNearBySearch(
                    Location(lat: latitude, lng: longitude), 5000,
                    keyword: "point of interest");

                print(result?.results);

                result?.results?.forEach(
                  (element) {
                    print(element.name);
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<PlaceCubit, PlaceState>(
          builder: (context, state) {
            switch (state.dataState) {
              case DataState.loading:
                {
                  return const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(JDColor.congoPink)),
                  );
                }
              case DataState.loaded:
                {
                  return state.placesList!.isEmpty
                      ? TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PlaceCreationPage(),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Votre carnet de voyages est vide ? ",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                              Text(
                                "Ajoutez un lieu !",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        color: const Color(JDColor.congoPink)),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: RefreshIndicator(
                                  color: const Color(JDColor.congoPink),
                                  backgroundColor: Colors.white,
                                  onRefresh: () =>
                                      context.read<PlaceCubit>().getPlaces(),
                                  child: ListView.separated(
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const SizedBox(width: 20),
                                    itemCount: state.placesList!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PlaceDetailsPage(
                                                    state.placesList![index]),
                                          ),
                                        ),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                state.placesList![index].urls!
                                                        .isNotEmpty
                                                    ? FadeInImage.memoryNetwork(
                                                        image: state
                                                            .placesList![index]
                                                            .urls![0],
                                                        height: 100,
                                                        width: 100,
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            kTransparentImage,
                                                      )
                                                    : SizedBox(
                                                        height: 100,
                                                        width: 100,
                                                        child: Image.asset(
                                                            'assets/images/logoJourneyDiary.png'),
                                                      ),
                                                const VerticalDivider(
                                                    width: 20),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        state.placesList![index]
                                                            .name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge,
                                                      ),
                                                      Text(
                                                        state.placesList![index]
                                                                    .description !=
                                                                null
                                                            ? state
                                                                .placesList![
                                                                    index]
                                                                .description!
                                                            : '',
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                                color: Colors
                                                                    .grey),
                                                      ),
                                                      Text(
                                                        state.placesList![index]
                                                            .locality,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                                color: const Color(
                                                                    JDColor
                                                                        .congoPink)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
