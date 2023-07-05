import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/place_cubit.dart';
import 'package:flutter_journey_diary/models/place.dart';
import 'package:flutter_journey_diary/ui/screens/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class PlaceCreationPage extends StatelessWidget {
  PlaceCreationPage({Key? key}) : super(key: key);

  XFile? _image;

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  bool _formSubmit = true;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    _image = pickedFile;
    print(_image?.path);
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
              'Enregistrer un lieu',
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
                            controller: _nameController,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Le champ doit être renseigné'
                                : null,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.drive_file_rename_outline),
                              labelText: 'Nom du lieu',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            controller: _descriptionController,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Le champ doit être renseigné'
                                : null,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.description),
                              labelText: 'Description',
                            ),
                            enableSuggestions: false,
                            autocorrect: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            controller: _localityController,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Le champ doit être renseigné'
                                : null,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.place),
                              labelText: 'Lieu',
                            ),
                            enableSuggestions: false,
                            autocorrect: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ElevatedButton(
                            onPressed: () {
                              getImage();
                              print("afeaefaefafazfaef");
                            },
                            child: Text("Importer une image"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _formSubmit
                        ? () async {
                            if (_formKey.currentState!.validate()) {
                              context.read<PlaceCubit>().getPlaces();
                              List<File> listFile = [];
                              if (_image != null) {
                                File file = File(_image!.path);
                                listFile.add(file);
                              }
                              Place place = Place(
                                locality: _localityController.value.text,
                                name: _nameController.value.text,
                                description: _descriptionController.value.text,
                                images: listFile,
                              );
                              print(place.toString());
                              context
                                  .read<PlaceCubit>()
                                  .placeRepository
                                  .savePlace(place);
                              Navigator.pop(context);
                            }
                          }
                        : null,
                    child: Text(
                      'Enregistrer',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => {
                context.read<PlaceCubit>().getPlaces(),
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                ),
              },
              child: Text(
                'Revenir à la page principale',
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
