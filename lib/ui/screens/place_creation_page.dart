import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/place_cubit.dart';
import 'package:flutter_journey_diary/models/place.dart';
import 'package:flutter_journey_diary/ui/screens/home_page.dart';
import 'package:flutter_journey_diary/ui/shared/colors.dart';
import 'package:image_picker/image_picker.dart';

class PlaceCreationPage extends StatefulWidget {
  const PlaceCreationPage({Key? key}) : super(key: key);

  @override
  State<PlaceCreationPage> createState() => _PlaceCreationPageState();
}

class _PlaceCreationPageState extends State<PlaceCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  List<XFile>? _images;

  Future<void> importImages() async => _images = await picker.pickMultiImage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Ajouter un lieu"),
        backgroundColor: const Color(JDColor.congoPink),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                              TextFormField(
                                controller: _nameController,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Le champ doit être renseigné'
                                        : null,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  prefixIcon: const Icon(
                                      Icons.drive_file_rename_outline_outlined),
                                  prefixIconColor: Colors.grey,
                                  labelText: 'Nom',
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  prefixIcon:
                                      const Icon(Icons.description_outlined),
                                  prefixIconColor: Colors.grey,
                                  labelText: 'Description',
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                controller: _localityController,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Le champ doit être renseigné'
                                        : null,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  prefixIcon: const Icon(Icons.place_outlined),
                                  prefixIconColor: Colors.grey,
                                  labelText: 'Lieu',
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton.icon(
                                onPressed: () => importImages(),
                                icon: const Icon(Icons.image_outlined),
                                label: Text(
                                  'Importer',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                    MediaQuery.of(context).size.width - 40,
                                    50,
                                  ),
                                  backgroundColor:
                                      const Color(JDColor.congoPink),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      late final List<File> files = [];

                                      if (_images != null) {
                                        for (XFile image in _images!) {
                                          files.add(File(image.path));
                                        }
                                      }

                                      final Place place = Place(
                                        name: _nameController.text,
                                        description:
                                            _descriptionController.text,
                                        images: files,
                                        locality: _localityController.text,
                                      );

                                      context
                                          .read<PlaceCubit>()
                                          .savePlace(place);

                                      if (!mounted) return;

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage(),
                                        ),
                                      );
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
                                    'Enregistrer',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(color: Colors.white),
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
