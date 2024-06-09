import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hershield/app/modules/map/model/MapModel.dart';
import 'package:hershield/shared/easyloading.dart';

class MapRepository {
  Future<void> addMapData(MapModel model) async {
    Loading.showLoading();
    print(model.toJson());
    try {
      FirebaseFirestore.instance
          .collection(
              'mapData') // Choose the collection where you want to add the data
          .add(model.toJson())
          .then((value) {
        print('Data added successfully!');
        Loading.showSuccess();
      }).catchError((error) {
        print('Failed to add data: $error');
      });
    } catch (e) {
      Loading.showError();
      Loading.dismissLoading();
    }
  }

  Stream<List<MapModel>> getAllMapStream() {
    var data = FirebaseFirestore.instance
        .collection("mapData")
        // .where("YsUid", isEqualTo: ysCurrentUser)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) {
              var mapData = MapModel.fromJson(e.data());
              print(mapData.toJson());
              return mapData;
            }).toList());
    return data;
  }
}
