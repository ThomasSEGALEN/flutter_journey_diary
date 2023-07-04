import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_journey_diary/blocs/place_cubit.dart';
import 'package:flutter_journey_diary/blocs/user_cubit.dart';
import 'package:flutter_journey_diary/models/amadeus.dart';
import 'package:flutter_journey_diary/repositories/place_repository.dart';
import 'package:flutter_journey_diary/repositories/user_repository.dart';
import 'package:flutter_journey_diary/ui/screens/home_page.dart';
import 'package:flutter_journey_diary/ui/screens/login_page.dart';

Future<void> main() async {
  await dotenv.load();
  await Amadeus().generateAccessToken();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final UserRepository userRepository =
      UserRepository(FirebaseAuth.instance, FirebaseFirestore.instance);
  final PlaceRepository placeRepository = PlaceRepository(
    FirebaseDatabase.instance,
    FirebaseAuth.instance,
    FirebaseStorage.instance,
  );

  await userRepository.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserCubit(userRepository),
        ),
        BlocProvider(
          create: (_) => PlaceCubit(placeRepository),
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
      theme: ThemeData(useMaterial3: true),
      home: BlocBuilder<UserCubit, bool>(
        builder: (context, state) =>
            state ? const HomePage() : const LoginPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
