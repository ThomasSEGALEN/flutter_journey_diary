import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/place_state.dart';
import 'package:flutter_journey_diary/blocs/user_cubit.dart';
import 'package:flutter_journey_diary/models/data_state.dart';
import 'package:flutter_journey_diary/ui/screens/login_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:flutter_journey_diary/ui/screens/place_creation_page.dart';
import '../../blocs/place_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

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
  Widget build(BuildContext context) {
    context.read<PlaceCubit>().getPlaces();
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  child: Image.asset("assets/images/logoJourneyDiary.png")),
              ListTile(
                  leading: const Icon(Icons.bed),
                  title: Text(
                    'Ajouter un lieu',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlaceCreationPage()));
                  }),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Accueil'),
                onTap: () {},
              ),
              const Divider(
                color: Color(JourneyColor.black),
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: Text(
                  'Se déconnecter',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
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
        backgroundColor: const Color(JourneyColor.congoPink),
        title: const Text("Accueil"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  'Trouvez un lieu mémorable',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: JourneyFont.l,
                  ),
                ),
                Text(
                  'dans la ville de votre choix',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: JourneyFont.l,
                  ),
                ),
              ],
            ),
            TextField(
              controller: _locationController,
              showCursor: false,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                labelText: 'Recherche',
                labelStyle: const TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  onPressed: () async {
                    print('search');

                    await context
                        .read<LocationCubit>()
                        .loadLocations(_locationController.text.trim());
                  },
                  icon: const Icon(Icons.search_outlined),
                ),
                suffixIconColor: Colors.grey,
              ),
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Journey"),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color(JourneyColor.lightOrange)
          ),
            child: Column(
          children: [
            Text(
              "Vos Voyages",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w900,
                fontSize: 25,
                color: Colors.grey,
              ),
            ),
            BlocBuilder<PlaceCubit, PlaceState>(builder: (context, state) {
              switch (state.dataState) {
                case DataState.loading:
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color(JourneyColor.vomitOrange)),
                  );
                case DataState.error:
                  return const Icon(Icons.error);
                case DataState.loaded:
                  return Expanded(
                    child: SizedBox(
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: state.placesList!.length,
                        itemBuilder: (BuildContext contexte, int index) {
                          return Column(
                            children: [
                              Card(
                                // Define the shape of the card
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                // Define how the card's content should be clipped
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                // Define the child widget of the card
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Add padding around the row widget
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          if (!state
                                              .placesList![index].urls!.isEmpty)
                                            Image.network(
                                              state.placesList![index].urls![0],
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            )
                                          else
                                            SizedBox(
                                              width: 100,
                                              height: 100,
                                            ),
                                          // Add an image widget to display an image
                                          // Add some spacing between the image and the text
                                          Container(width: 20),
                                          // Add an expanded widget to take up the remaining horizontal space
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                // Add some spacing between the top of the card and the title
                                                Container(height: 5),
                                                // Add a title widget
                                                Text(
                                                  state.placesList![index].name,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                // Add some spacing between the title and the subtitle
                                                Container(height: 5),
                                                // Add a subtitle widget
                                                Text(
                                                  state.placesList![index]
                                                      .locality,
                                                  style: const TextStyle(
                                                    color: Color(JourneyColor
                                                        .vomitOrange),
                                                  ),
                                                ),
                                                // Add some spacing between the subtitle and the text
                                                Container(height: 10),
                                                // Add a text widget to display some text
                                                Text(
                                                  state.placesList![index]
                                                              .description ==
                                                          null
                                                      ? ""
                                                      : state.placesList![index]
                                                          .description!,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext contexte, int index) {
                          return const SizedBox(width: 20);
                        },
                      ),
                    ),
                  );
              }
            })
          ],
        )));
  }
}
