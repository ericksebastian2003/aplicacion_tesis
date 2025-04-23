import 'package:flutter/material.dart';

import '../../../../models/Destino.dart';
class DetailScreen extends StatelessWidget{
  final Destino destino;
  const DetailScreen({
    super.key,
    required this.destino,
  });
  void reserveDestine(BuildContext context)  {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:  Text('Se ha reservado con éxito'),
        backgroundColor:Colors.grey,

    ),
    );
        
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(destino.nombre),
        leading: IconButton(
          icon : const Icon(Icons.arrow_back,
          color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              destino.imagen,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => 
              const Icon(Icons.image_not_supported),
            ),
            const SizedBox(height: 16),
            Text(
              destino.nombre.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            

              ),
                const SizedBox( height: 12
            ),
            Text(destino.descripcion,
            style: const TextStyle(
              fontSize: 16,
            ),),
            const SizedBox(height: 12),
            ElevatedButton(
              style:ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                
              ),
              onPressed: () => reserveDestine(context) , 
              child: const Text(
                'Reservar',
                style:  TextStyle(
                  color:  Color(0xFF021337),

                ) ,
              )
              )

          ],
        ),
      ),
    );
  }
}