import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotels/features/guest/explore/widgets/detail_screen.dart';
import 'package:hotels/features/guest/explore/services/obtener_datos.dart';
import '../../../data/models/Alojamientos.dart';

class ExploreScreen extends StatefulWidget{

  const ExploreScreen({super.key});

    @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Explorar',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('alojamientos').snapshots(), 
          builder: (context , snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
              return Center(
                child: Text(
                  "No hay alojamientos disponibles",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              );
            }
            final alojamientos = snapshot.data!.docs.map(
              (doc) {
                final data = doc.data() as Map<String,dynamic>;
                return Alojamientos.fromFirestore(data);
              }
            ).toList();
            return ListView.builder(
              itemCount: alojamientos.length,
              itemBuilder: (context , index){
                final alojamiento = alojamientos[index];
                return CardPassages(alojamientos: alojamiento);
              },
              );   
              }
        )
    );
    }
        
        
        
        /* Para cuando se genera de la API REAL 
        FutureBuilder(
          future:obtenerDestinos(),
          builder: (context, snapshot) {
          if(snapshot.hasData){
        final destinos = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8
          ),
        child: ListView.builder(
          itemCount: destinos.length,
          itemBuilder: (context,index){
            final destino = destinos[index];
            return  CardPassages(destino : destino);
          },
        )
        );
        }
          else if(snapshot.hasError){
            return const Center(
              child:  Text(
                'Error al cargar la información'
            ),
            );

          }
          else {
            return const Center(
              child : CircularProgressIndicator()
            );

          } 
        },
      
        ),
      );
      */
        
}
class CardPassages extends StatelessWidget {
  final Alojamientos alojamientos;

  const CardPassages({super.key, required this.alojamientos});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(destino: alojamientos),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                alojamientos.imagen,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      alojamientos.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(
                    alojamientos.ubicacion,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                bottom: 8.0,
              ),
              child: Text(
                '\$${alojamientos.precio.toString()} por noche',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
