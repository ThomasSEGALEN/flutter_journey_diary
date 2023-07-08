import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/notebook/place_cubit.dart';
import 'package:flutter_journey_diary/blocs/notebook/place_state.dart';
import 'package:flutter_journey_diary/blocs/auth/user_cubit.dart';
import 'package:flutter_journey_diary/models/data_state.dart';
import 'package:flutter_journey_diary/models/google_prediction.dart';
import 'package:flutter_journey_diary/repositories/google/google_place_repository.dart';
import 'package:flutter_journey_diary/ui/screens/auth/login_page.dart';
import 'package:flutter_journey_diary/ui/screens/google/place_details_page.dart';
import 'package:flutter_journey_diary/ui/screens/notebook/create_place_page.dart';
import 'package:flutter_journey_diary/ui/screens/notebook/place_details_page.dart';
import 'package:flutter_journey_diary/ui/screens/notebook/to_visit_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image.asset(
                'assets/images/logoJourneyDiary.png',
                width: MediaQuery.of(context).size.width,
              ),
            ),
            const Divider(height: 50),
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
                  builder: (context) => const CreatePlacePage(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.favorite_border_outlined,
                color: Colors.black,
              ),
              title: Text(
                'À visiter',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ToVisitPage(),
                ),
              ),
            ),
            const Divider(height: 50),
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
                await context.read<UserCubit>().logout();

                if (!mounted) return;

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Mes voyages"),
        backgroundColor: const Color(JDColor.congoPink),
        actions: [
          IconButton(
            onPressed: () async => await showSearch(
              context: context,
              delegate: GoogleSearch(),
            ),
            icon: const Icon(Icons.search_outlined),
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
                      color: Color(JDColor.congoPink));
                }
              case DataState.loaded:
                {
                  return state.places!.isEmpty
                      ? TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CreatePlacePage(),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: 'Votre carnet de voyages est vide ? ',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: 'Ajoutez un lieu !',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                          color:
                                              const Color(JDColor.congoPink)),
                                ),
                              ],
                            ),
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
                                    itemCount: state.places!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PlaceDetailsPage(
                                                    state.places![index]),
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
                                                state.places![index].urls!
                                                        .isNotEmpty
                                                    ? FadeInImage.memoryNetwork(
                                                        image: state
                                                            .places![index]
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
                                                        state.places![index]
                                                            .name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge,
                                                      ),
                                                      Text(
                                                        state.places![index]
                                                                    .description !=
                                                                null
                                                            ? state
                                                                .places![index]
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
                                                        state.places![index]
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

class GoogleSearch extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Rechercher un lieu';

  @override
  TextStyle get searchFieldStyle => const TextStyle(fontSize: 16);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () => query.isNotEmpty
              ? query = ''
              : Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                ),
          icon: const Icon(Icons.clear_outlined),
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  FutureBuilder<List<GooglePrediction>> _searchBuilder() {
    return FutureBuilder<List<GooglePrediction>>(
      future: GooglePlaceRepository().fetchPlaces(query.trim()),
      builder: (context, AsyncSnapshot<List<GooglePrediction>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].description),
                onTap: () async {
                  close(context, null);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GooglePlaceDetailsPage(
                          snapshot.data![index].placeId!),
                    ),
                  );
                },
              );
            },
            itemCount: snapshot.data?.length, // data is null
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Color(JDColor.congoPink)),
          );
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => _searchBuilder();

  @override
  Widget buildSuggestions(BuildContext context) => _searchBuilder();
}
