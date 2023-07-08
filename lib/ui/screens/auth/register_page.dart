import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/auth/user_cubit.dart';
import 'package:flutter_journey_diary/ui/screens/auth/login_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top),
                height: 220,
                width: MediaQuery.of(context).size.width,
                color: const Color(JDColor.congoPink),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 100,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Créer son compte",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(color: Colors.white),
                      ),
                      Text(
                        'Journey Diary',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
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
                                          content: Text(
                                            'Inscription réussie',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(color: Colors.white),
                                          ),
                                          action: SnackBarAction(
                                            label: 'Cacher',
                                            textColor:
                                                const Color(JDColor.congoPink),
                                            onPressed: () {},
                                          ),
                                        );
                                      } else {
                                        snackBar = SnackBar(
                                          content: Text(
                                            "Erreur lors de l'inscription",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(color: Colors.white),
                                          ),
                                          action: SnackBarAction(
                                            label: 'Cacher',
                                            textColor:
                                                const Color(JDColor.congoPink),
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
                                        const Color(JDColor.congoPink),
                                  ),
                                  child: Text(
                                    'Inscription',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Vous avez déjà un compte ? ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: Colors.grey),
                                    children: [
                                      TextSpan(
                                        text: 'Se connecter !',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                            color:
                                            const Color(JDColor.congoPink)),
                                      ),
                                    ],
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
