import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_journey_diary/blocs/google/google_place_cubit.dart';
import 'package:flutter_journey_diary/blocs/google/google_point_of_interest_cubit.dart';
import 'package:flutter_journey_diary/blocs/notebook/to_visit_cubit.dart';
import 'package:flutter_journey_diary/blocs/notebook/place_cubit.dart';
import 'package:flutter_journey_diary/blocs/auth/user_cubit.dart';
import 'package:flutter_journey_diary/repositories/google/google_place_repository.dart';
import 'package:flutter_journey_diary/repositories/notebook/to_visit_repository.dart';
import 'package:flutter_journey_diary/repositories/notebook/place_repository.dart';
import 'package:flutter_journey_diary/repositories/auth/user_repository.dart';
import 'package:flutter_journey_diary/ui/screens/home_page.dart';
import 'package:flutter_journey_diary/ui/screens/auth/login_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:flutter_journey_diary/ui/shared/fonts.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final ToVisitRepository toVisitRepository = ToVisitRepository(
    FirebaseAuth.instance,
    FirebaseDatabase.instance,
    FirebaseStorage.instance,
  );
  final GooglePlaceRepository googlePlaceRepository = GooglePlaceRepository();
  final PlaceRepository placeRepository = PlaceRepository(
    FirebaseAuth.instance,
    FirebaseDatabase.instance,
    FirebaseStorage.instance,
  );
  final UserRepository userRepository =
      UserRepository(FirebaseAuth.instance, FirebaseFirestore.instance);

  await userRepository.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ToVisitCubit(toVisitRepository),
        ),
        BlocProvider(
          create: (_) => GooglePlaceCubit(googlePlaceRepository),
        ),
        BlocProvider(
          create: (_) => GooglePointOfInterestCubit(googlePlaceRepository),
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
