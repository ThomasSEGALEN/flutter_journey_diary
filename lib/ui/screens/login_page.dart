import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_journey_diary/blocs/user_cubit.dart';
import 'package:flutter_journey_diary/ui/screens/register_page.dart';

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
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Se connecter',
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
                              final String username = _emailController.text;
                              final String password = _passwordController.text;

                              context
                                  .read<UserCubit>()
                                  .login(username, password);
                            }
                          }
                        : null,
                    child: Text(
                      'Connexion',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
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
              child: Text(
                'Créer un compte',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
