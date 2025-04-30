import 'package:flutter/material.dart';
import '../../../../data/models/Destino.dart';

class DetailAccomodation extends StatelessWidget{
  final Destino accommodation;
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