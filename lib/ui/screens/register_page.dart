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
                    "S'inscrire",
                    style: GoogleFonts.poppins(
                      color: const Color(JourneyColor.vomitOrange),
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
                                    final String email = _emailController.text;
                                    final String password =
                                        _passwordController.text;
                                    final bool checkRegister = await context
                                        .read<UserCubit>()
                                        .register(email, password);

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
                                            const Text("Inscription réussie"),
                                        action: SnackBarAction(
                                          label: 'Cacher',
                                          onPressed: () {},
                                        ),
                                      );
                                    } else {
                                      snackBar = SnackBar(
                                        content: const Text(
                                            "Erreur lors de l'inscription"),
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
                            'Inscription',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: JourneyFont.m,
                              color: const Color(JourneyColor.white),
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
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.transparent,
                          ),
                        ),
                        child: Text(
                          "J'ai déjà un compte",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
