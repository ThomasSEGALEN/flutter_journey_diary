import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_journey_diary/blocs/location_cubit.dart';
import 'package:flutter_journey_diary/blocs/place_cubit.dart';
import 'package:flutter_journey_diary/blocs/user_cubit.dart';
import 'package:flutter_journey_diary/models/amadeus.dart';
import 'package:flutter_journey_diary/repositories/location_repository.dart';
import 'package:flutter_journey_diary/repositories/place_repository.dart';
import 'package:flutter_journey_diary/repositories/user_repository.dart';
import 'package:flutter_journey_diary/ui/screens/home_page.dart';
import 'package:flutter_journey_diary/ui/screens/login_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:flutter_journey_diary/ui/shared/fonts.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  await dotenv.load();
  await Amadeus().generateAccessToken();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final LocationRepository locationRepository = LocationRepository();
  final PlaceRepository placeRepository = PlaceRepository(
    FirebaseDatabase.instance,
    FirebaseAuth.instance,
    FirebaseStorage.instance,
  );
  final UserRepository userRepository =
      UserRepository(FirebaseAuth.instance, FirebaseFirestore.instance);

  await userRepository.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LocationCubit(locationRepository),
        ),
        BlocProvider(
          create: (_) => PlaceCubit(placeRepository),
        ),
        BlocProvider(
          create: (_) => UserCubit(userRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journey Diary',
      theme: ThemeData(
        textTheme: TextTheme(
          bodySmall: GoogleFonts.poppins(
            fontWeight: JDFontWeight.regular,
            fontSize: JDFontSize.bodySmall,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontWeight: JDFontWeight.regular,
            fontSize: JDFontSize.bodyMedium,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontWeight: JDFontWeight.regular,
            fontSize: JDFontSize.bodyLarge,
          ),
          labelSmall: GoogleFonts.poppins(
            fontWeight: JDFontWeight.medium,
            fontSize: JDFontSize.labelSmall,
          ),
          labelMedium: GoogleFonts.poppins(
            fontWeight: JDFontWeight.medium,
            fontSize: JDFontSize.labelMedium,
          ),
          labelLarge: GoogleFonts.poppins(
            fontWeight: JDFontWeight.medium,
            fontSize: JDFontSize.labelLarge,
          ),
          titleSmall: GoogleFonts.poppins(
            fontWeight: JDFontWeight.medium,
            fontSize: JDFontSize.titleSmall,
          ),
          titleMedium: GoogleFonts.poppins(
            fontWeight: JDFontWeight.medium,
            fontSize: JDFontSize.titleMedium,
          ),
          titleLarge: GoogleFonts.poppins(
            fontWeight: JDFontWeight.medium,
            fontSize: JDFontSize.titleLarge,
          ),
          headlineSmall: GoogleFonts.poppins(
            fontWeight: JDFontWeight.semiBold,
            fontSize: JDFontSize.headlineSmall,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontWeight: JDFontWeight.semiBold,
            fontSize: JDFontSize.headlineMedium,
          ),
          headlineLarge: GoogleFonts.poppins(
            fontWeight: JDFontWeight.semiBold,
            fontSize: JDFontSize.headlineLarge,
          ),
          displaySmall: GoogleFonts.poppins(
            fontWeight: JDFontWeight.bold,
            fontSize: JDFontSize.displaySmall,
          ),
          displayMedium: GoogleFonts.poppins(
            fontWeight: JDFontWeight.bold,
            fontSize: JDFontSize.displayMedium,
          ),
          displayLarge: GoogleFonts.poppins(
            fontWeight: JDFontWeight.bold,
            fontSize: JDFontSize.displayLarge,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.grey,
          selectionColor: Colors.grey.shade300,
          selectionHandleColor: const Color(JDColor.congoPink),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.resolveWith((state) => Colors.black),
          ),
        ),
      ),
      home: BlocBuilder<UserCubit, bool>(
        builder: (context, state) =>
            state ? const HomePage() : const LoginPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
