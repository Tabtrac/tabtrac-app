
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/record.model.dart';

class RecordNotifier extends StateNotifier<UserRecord?> {
  RecordNotifier() : super(null);

  void change(UserRecord record) {
    state = record;
  }
}

class RecordListNotifier extends StateNotifier<List<UserRecord>> {
  RecordListNotifier() : super([]);

  void change(List<UserRecord> recordList) {
    state = recordList;
  }
  void add(List<UserRecord> recordList){
    state.addAll(recordList);
  }
}
