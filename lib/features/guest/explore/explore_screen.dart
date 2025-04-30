import 'package:flutter/material.dart';
import 'package:hotels/features/guest/explore/widgets/detail_screen.dart';
import 'package:hotels/features/guest/explore/services/obtener_datos.dart';
import '../../auth/models/Destino.dart';

class ExploreScreen extends StatefulWidget{

  const ExploreScreen({super.key});

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
        body: FutureBuilder(
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
        
}
}
class CardPassages extends StatelessWidget{
  final Destino destino;
  const CardPassages({super.key , required this.destino});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => DetailScreen(destino: destino),
          ),
          );
      },
    child:  Card(
              elevation: 4,
              margin : const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12)
                    ),
                    child: Image.network(
                      destino.imagen ,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.image_not_supported),
                      ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(destino.nombre ,
                    style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                      ),
                    ),
    
  
              const Padding(
                padding:  EdgeInsets.all(8.0),
                child: 
                  Text(
                    'Esta es una tarjeta'
                  )
              ),
            ],
      
          ),
        )
    );
    }
  }
