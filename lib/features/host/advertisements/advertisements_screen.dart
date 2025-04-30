import 'package:flutter/material.dart';
import 'package:hotels/features/auth/models/Destino.dart';
import './widgets/detail_accomodation.dart';
import '../../auth/models/Destino.dart';
import './services/get_accomodations.dart';
import './widgets/create_accomodation_screen.dart';
class AdvertisementsScreen extends StatefulWidget{
  const AdvertisementsScreen({
    super.key,
  });
  @override
  State<AdvertisementsScreen> createState() => _AdvertisementsScreenState();

}
class _AdvertisementsScreenState extends State<AdvertisementsScreen>{
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Anuncios',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          ),
          backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: getAccommodations(),
        builder: (context , snapshot){
          if(snapshot.hasData){
            final accommodations = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: ListView.builder(
                itemCount: accommodations.length,
                itemBuilder: (context,index){
                  final accomodation = accommodations[index];
                  return CardAccomodations(destino : accomodation);

                },

              ),
              );
          }
          else if(snapshot.hasError){
            return const Center(
              child:  Text(
                'Error al cargar la información'
            ),
            );

          }
          else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
        },
      ),
      floatingActionButton : FloatingActionButton(
            onPressed: () {
              Navigator.push(context , 
              MaterialPageRoute(
                builder: (context) => CreateAccomadationScreen(),
              )
              );
            },
            
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.add),
            tooltip : 'Agregar alojamiento',
    )
    );

  }
}
class CardAccomodations extends StatelessWidget{
  final Destino destino;
  //final Accomodation accomodation;
  const CardAccomodations({
    super.key,
    required this.destino,
    //required this.accomodation
  });
  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: (){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DetailAccomodation(accommodation : destino),
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
                borderRadius: BorderRadius.vertical(
                top: Radius.circular(12)
              ),
              child: Image.network(
                destino.imagen ,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context , error , stackTrace) =>
                const Icon(Icons.image_not_supported),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                destino.nombre,
                style:  TextStyle(
                  fontWeight:  FontWeight.bold, 
                ),
    
              ),
              )
          ],
        ),
        ),
    );
  }
}