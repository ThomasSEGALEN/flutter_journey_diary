import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:flutter_journey_diary/ui/shared/fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_journey_diary/blocs/user_cubit.dart';
import 'package:flutter_journey_diary/ui/screens/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(JourneyColor.congoPink),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 220,
              width: MediaQuery.of(context).size.width,
              color: const Color(JourneyColor.congoPink),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Créer son compte",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: JourneyFont.xxl,
                      ),
                    ),
                    Text(
                      'Journey Diary',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'Le champ doit être renseigné'
                                            : null,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      labelText: 'Adresse e-mail',
                                      labelStyle:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  TextFormField(
                                    controller: _passwordController,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'Le champ doit être renseigné'
                                            : null,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      labelText: 'Mot de passe',
                                      labelStyle:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    obscureText: true,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final bool checkRegister = await context
                                          .read<UserCubit>()
                                          .register(
                                            _emailController.text.trim(),
                                            _passwordController.text.trim(),
                                          );

                                      if (!mounted) return;

                                      late final SnackBar snackBar;

                                      if (checkRegister) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage(),
                                          ),
                                        );

                                        snackBar = SnackBar(
                                          content:
                                              const Text('Inscription réussie'),
                                          action: SnackBarAction(
                                            label: 'Cacher',
                                            textColor: const Color(
                                                JourneyColor.congoPink),
                                            onPressed: () {},
                                          ),
                                        );
                                      } else {
                                        snackBar = SnackBar(
                                          content: const Text(
                                              "Erreur lors de l'inscription"),
                                          action: SnackBarAction(
                                            label: 'Cacher',
                                            textColor: const Color(
                                                JourneyColor.congoPink),
                                            onPressed: () {},
                                          ),
                                        );
                                      }

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                      MediaQuery.of(context).size.width - 40,
                                      50,
                                    ),
                                    backgroundColor:
                                        const Color(JourneyColor.congoPink),
                                  ),
                                  child: Text(
                                    'Inscription',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: JourneyFont.m,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Vous avez déjà un compte ? ",
                                      style: GoogleFonts.poppins(
                                        fontSize: JourneyFont.xs,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Se connecter !",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: JourneyFont.xs,
                                        color:
                                            const Color(JourneyColor.congoPink),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
