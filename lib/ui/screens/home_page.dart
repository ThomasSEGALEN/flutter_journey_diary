import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/user_cubit.dart';
import 'package:flutter_journey_diary/ui/screens/login_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                      (route) => false);
                }
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Journey"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(JourneyColor.white),
              Color(JourneyColor.lightOrange)
            ],
          ),
        ),
      ),
    );
  }
}
