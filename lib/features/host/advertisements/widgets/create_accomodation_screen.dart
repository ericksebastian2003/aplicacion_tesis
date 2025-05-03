import 'package:flutter/material.dart';
import 'package:hotels/data/models/Alojamientos.dart';


class CreateAccomadationScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear anuncio'
        ),
      ),
    );
  }
}