import 'package:flutter/material.dart';
import '../../../../data/models/Alojamientos.dart';

class DetailAccomodation extends StatelessWidget{
  final Alojamientos accommodation;
  const DetailAccomodation({
    super.key,
    required this.accommodation,
});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          accommodation.nombre
        ),
      ),
    );
  }
}