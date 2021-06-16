import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';


class Ar extends StatefulWidget {
  @override
  _ArState createState() => _ArState();
}

class _ArState extends State<Ar> {
  ArCoreController arCoreController;

  @override
  Widget build(BuildContext context) {
    void planeTap(List<ArCoreHitTestResult> hits){
      final hit=hits.first;
      final moonMaterial=ArCoreMaterial(color: Color(0xFFF5F5F5));
      final moonShape=ArCoreSphere(
        materials: [moonMaterial],
        radius: 0.03,
      );
      final moon=ArCoreNode(
        shape: moonShape,
        position: Vector3(0.2, 0, 0),
        rotation: Vector4(0, 0, 0, 0),
      );
      final earthMaterial = ArCoreMaterial(
          color: Color.fromARGB(120, 66, 134, 244));

      final earthShape = ArCoreSphere(
        materials: [earthMaterial],
        radius: 0.1,
      );

      final earth = ArCoreNode(
          shape: earthShape,
          children: [moon],
          position: hit.pose.translation + Vector3(0.0, 1.0, 0.0),
          rotation: hit.pose.rotation);

      arCoreController.addArCoreNodeWithAnchor(earth);
    }
    void onTap(String name){
      showDialog(context: context, builder: (context) =>
          AlertDialog(content: Text('Tapped on $name'),),);
    }
    void arCreated(ArCoreController controller){
      arCoreController=controller;
      arCoreController.onNodeTap=(name)=>onTap(name);
      arCoreController.onPlaneTap=planeTap;
    }


    return Scaffold(
      appBar: AppBar(title: Text('Ar'),),
      body: ArCoreView(
        onArCoreViewCreated: arCreated,
        enableTapRecognizer: true,
      )
    );
  }
}

