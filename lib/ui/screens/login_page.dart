import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/user_cubit.dart';
import 'package:flutter_journey_diary/ui/screens/home_page.dart';
import 'package:flutter_journey_diary/ui/screens/register_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:flutter_journey_diary/ui/shared/fonts.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _formSubmit = false;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() => setState(() => _formSubmit =
        _emailController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty));

    _passwordController.addListener(() => setState(() => _formSubmit =
        _passwordController.text.isNotEmpty &&
            _emailController.text.isNotEmpty));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(JourneyColor.white),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    'Se connecter',
                    style: GoogleFonts.poppins(
                      color: const Color(JourneyColor.black),
                      fontWeight: FontWeight.w600,
                      fontSize: JourneyFont.xxl,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Le champ doit être renseigné'
                                      : null,
                              showCursor: false,
                              style: const TextStyle(
                                color: Color(JourneyColor.black),
                                fontSize: JourneyFont.sm,
                                decorationThickness: 0,
                              ),
                              decoration: const InputDecoration(
                                icon: Icon(Icons.person_outlined),
                                iconColor: Color(JourneyColor.vomitOrange),
                                labelText: 'Adresse e-mail',
                                labelStyle: TextStyle(
                                  color: Color(JourneyColor.vomitOrange),
                                  fontSize: JourneyFont.m,
                                  fontWeight: FontWeight.w600,
                                  decorationThickness: 0,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(JourneyColor.vomitOrange),
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Le champ doit être renseigné'
                                      : null,
                              showCursor: false,
                              style: const TextStyle(
                                color: Color(JourneyColor.black),
                                fontSize: JourneyFont.sm,
                                decorationThickness: 0,
                              ),
                              decoration: const InputDecoration(
                                icon: Icon(Icons.key_outlined),
                                iconColor: Color(JourneyColor.vomitOrange),
                                labelText: 'Mot de passe',
                                labelStyle: TextStyle(
                                  color: Color(JourneyColor.vomitOrange),
                                  fontSize: JourneyFont.m,
                                  fontWeight: FontWeight.w600,
                                  decorationThickness: 0,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(JourneyColor.vomitOrange),
                                  ),
                                ),
                              ),
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: ElevatedButton(
                          onPressed: _formSubmit
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    final String username =
                                        _emailController.text;
                                    final String password =
                                        _passwordController.text;
                                    final bool checkLogin = await context
                                        .read<UserCubit>()
                                        .login(username, password);

                                    if (!mounted) return;

                                    late final SnackBar snackBar;

                                    if (checkLogin) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage(),
                                        ),
                                      );
                                    } else {
                                      snackBar = SnackBar(
                                        content: const Text(
                                            "Identifiants invalides"),
                                        action: SnackBarAction(
                                          label: 'Cacher',
                                          onPressed: () {},
                                        ),
                                      );
                                    }

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(JourneyColor.vomitOrange),
                            disabledBackgroundColor: Colors.black12,
                          ),
                          child: Text(
                            'Connexion',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: JourneyFont.m,
                              color: const Color(JourneyColor.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  ),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.transparent,
                    ),
                  ),
                  child: Text(
                    "Je me crée un compte",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: JourneyFont.xs,
                      color: const Color(JourneyColor.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
