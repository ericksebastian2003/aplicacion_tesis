import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../data/models/Destino.dart';
//Obtener los datos de los luagres
Future<List<Destino>> obtenerDestinos() async {
  final String url = 'https://pokeapi.co/api/v2/pokemon?limit=20';
  try
  {

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
        final data = json.decode(response.body);
        final List results = data['results'];
        List<Destino> respuestas = [];
        for (var item in results){
          final res = await http.get(Uri.parse(item['url']));
          if(res.statusCode == 200){
            final dataFinal = json.decode(res.body);
            if(dataFinal['sprites'] != null &&  dataFinal ['sprites']['front_default'] != null){
              respuestas.add(Destino.fromJson(dataFinal));
            } 
            
          }
        }
        return respuestas;
  }
  else{
    throw Exception('Error , al cargar los destinos');

  }
  }
  catch(e){
    throw Exception('Error de conexión: $e');
  }
}