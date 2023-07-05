import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/location_cubit.dart';
import 'package:flutter_journey_diary/blocs/location_state.dart';
import 'package:flutter_journey_diary/blocs/user_cubit.dart';
import 'package:flutter_journey_diary/models/data_state.dart';
import 'package:flutter_journey_diary/ui/screens/login_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
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
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Image.asset('assets/images/logoJourneyDiary.png'),
            ),
            ListTile(
              leading: const Icon(
                Icons.home_outlined,
                color: Colors.black,
              ),
              title: Text(
                'Accueil',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
            Divider(color: Colors.grey.shade300),
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
        title: const Text("Accueil"),
        backgroundColor: const Color(JDColor.congoPink),
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: _SearchLocation(),
            ),
            icon: const Icon(Icons.search_outlined),
          ),
        ],
      ),
    );
  }
}

class _SearchLocation extends SearchDelegate {
  final List<String> searchResults = [
    'Bangalore',
    'Barcelona',
    'Berlin',
    'Dallas',
    'London',
    'New York',
    'Paris',
    'San Francisco',
  ];

  @override
  String get searchFieldLabel => "Recherche";

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear_outlined),
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_outlined),
      );

  @override
  Widget buildResults(BuildContext context) {
    context.read<LocationCubit>().loadLocations(query);

    return Center(
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          switch (state.dataState) {
            case DataState.loading:
              return const CircularProgressIndicator(
                color: Color(JDColor.congoPink),
              );
            case DataState.loaded:
              return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        "${state.locations![index].name} (${state.locations![index].address['stateCode']})"),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: state.locations!.length,
              );
            case DataState.error:
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Aucune ville trouvée',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestions = searchResults.where((searchResult) {
      final String result = searchResult.toLowerCase();
      final String input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final String suggestion = suggestions[index];

        return ListTile(
          title: Text(
            suggestion,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () => query = suggestion,
        );
      },
    );
  }
}
