


import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'check.dart';
import 'package:logbook1_0_0/providers.dart';
const uuid = Uuid(); //ref pub.dev\uuid-3.0.7\lib\uuid.dart
//class Checklist, list of Check
class Checklist extends StateNotifier<List<Check>> {
  /*Checklist(): super([]); Checklist(super.state);*/
  Checklist(List<Check> initialChecks) : super(initialChecks);

  void addCheck(String title, String? description) {
    state = [
      ...state,
      Check(uuid.v4(), title, false, description),
    ];
  }

  void toggle(String id, bool checked) {
    state = [
      for (final check in state)
        if (check.id == id)
          Check(
            check.id,
            check.title,
            checked,
            check.description,
          )
        else
          check
    ];
  }
}
