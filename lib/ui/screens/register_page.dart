import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "S'inscrire",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 24,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            controller: _emailController,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Le champ doit être renseigné'
                                : null,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              labelText: 'Adresse e-mail',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            controller: _passwordController,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Le champ doit être renseigné'
                                : null,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.key),
                              labelText: 'Mot de passe',
                            ),
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _formSubmit
                        ? () async {
                            if (_formKey.currentState!.validate()) {
                              final String email = _emailController.text;
                              final String password = _passwordController.text;
                              final checkSignUp = await context
                                  .read<UserCubit>()
                                  .signup(email, password);

                              if (!mounted) return;

                              late final SnackBar snackBar;

                              if (checkSignUp) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );

                                snackBar = SnackBar(
                                  content: const Text("Inscription réussie"),
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
                    child: Text(
                      'Inscription',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    ),
                    child: Text(
                      "J'ai déjà un compte",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
