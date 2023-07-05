import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/place_cubit.dart';
import 'package:flutter_journey_diary/blocs/place_state.dart';
import 'package:flutter_journey_diary/blocs/user_cubit.dart';
import 'package:flutter_journey_diary/models/data_state.dart';
import 'package:flutter_journey_diary/ui/screens/login_page.dart';
import 'package:flutter_journey_diary/ui/screens/place_creation_page.dart';
import 'package:flutter_journey_diary/ui/screens/place_details_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();

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
                Icons.home_outlined,
                color: Colors.black,
              ),
              title: Text(
                'Mon carnet',
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
        title: const Text("Mon carnet"),
        backgroundColor: const Color(JDColor.congoPink),
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
                                "Votre carnet est vide ? ",
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
                      : Column(
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
                                              const VerticalDivider(width: 20),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      state.placesList![index]
                                                          .name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                    Text(
                                                      state.placesList![index]
                                                          .locality,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
