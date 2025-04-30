import 'package:flutter/material.dart';
import 'package:hotels/features/guest/dashboard/guest_dashboard.dart';

class HostDashboard extends StatefulWidget{
  final String correo;
  final String rol;

  const HostDashboard({
    super.key,
    required this.correo,
    required this.rol,
  });
  @override
  State<HostDashboard> createState() => _HostDashboardState();
}

class _HostDashboardState extends State<HostDashboard>{
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context){
    final List<Widget> _pages = [
      Center(child: Text('Anuncios')),
      Center(child: Text('Reservas')),
      Center(child: Text('Cuenta')),
    ];
    return Scaffold(
      body: _pages[currentPageIndex],
      bottomNavigationBar: hostNavigationBar(
        currentIndex: currentPageIndex,
         onTabSelected: (int index){
          setState(() {
            currentPageIndex = index;
          });
         }
         ),
      );
  }
}
Widget hostNavigationBar({required int currentIndex , required Function(int ) onTabSelected}){
  return NavigationBar(
    selectedIndex: currentIndex,
    onDestinationSelected: onTabSelected,
    destinations: const <NavigationDestination>[
      NavigationDestination(
        selectedIcon: Icon(Icons.announcement),
        icon: Icon(Icons.announcement_outlined),
        label: 'Anuncios'
      ), 
         NavigationDestination(
          icon: Icon(Icons.auto_awesome_mosaic_outlined),
          selectedIcon: Icon(Icons.auto_awesome_mosaic),
          label: 'Reservas'
         ),
         NavigationDestination(
        selectedIcon: Icon(Icons.person_2),
        icon: Icon(Icons.person_2_outlined),
        label: 'Cuenta',
         ),
     
     

    ],

  );
}