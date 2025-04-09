class Destino {
  final String nombre;
  final String imagen;
  final int precio;
  final String descripcion;
  final int numeroHabitacion;
  final int numeroCamas;
  final int numeroHuespedes;
  final int numeroBanios;



  Destino({
    required this.nombre,
    required this.imagen,
    required this.descripcion,
    required this.numeroBanios,
    required this.numeroCamas,
    required this.numeroHabitacion,
    required this.numeroHuespedes,
    required this.precio,

   

  });
  factory Destino.fromJson(Map<String,dynamic> json){
    return Destino(
      nombre:json['name'],
      imagen: json['sprites']?['front_default'] ?? '',
      numeroBanios: 2,
      numeroCamas: 3,
      numeroHuespedes: 5,
      numeroHabitacion: 4,
      precio: 13,
      descripcion: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ',

      );
  }

}