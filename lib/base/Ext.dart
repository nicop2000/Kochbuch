import 'package:kochbuch/data/abteilung.dart';
import 'package:kochbuch/data/backanweisung.dart';

extension TemperatureinheitNamen on Temperatureinheit {
  String get showName =>
      name.length > 1 ? name[0].toUpperCase() +
          name.substring(1)
              .toLowerCase() : "°$name";

}

extension AbteilungsNamen on Abteilung {
  String get showName =>
      name[0].toUpperCase() +
          name.substring(1)
              .toLowerCase()
              .replaceAll("ae", "ä")
              .replaceAll("oe", "ö")
              .replaceAll("ue", "ü");

  bool _isInList(List<Abteilung> list) {
    for (Abteilung element in list) {
      if (element.name == name) return true;
    }
    return false;
  }

  bool isBackable() {
    return _isInList([
      Abteilung.gebaeck,
      Abteilung.kekse,
      Abteilung.kuchen,
      Abteilung.torte,
      Abteilung.brot
    ]);
  }
}
