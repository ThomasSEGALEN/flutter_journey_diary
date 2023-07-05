import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/location_cubit.dart';
import 'package:flutter_journey_diary/blocs/user_cubit.dart';
import 'package:flutter_journey_diary/ui/screens/login_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:flutter_journey_diary/ui/shared/fonts.dart';
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
              leading: const Icon(Icons.home_outlined),
              title: const Text('Accueil'),
              onTap: () {},
            ),
            const Divider(color: Colors.black),
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
      ),
    );
  }
}
