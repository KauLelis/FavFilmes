import 'package:shared_preferences/shared_preferences.dart';

class WatchLaterService {
  static const _key = 'watch_later_ids';

  Future<List<int>> getWatchLaterIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key)?.map(int.parse).toList() ?? [];
  }

  Future<void> toggleWatchLater(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getWatchLaterIds();
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    prefs.setStringList(_key, current.map((e) => e.toString()).toList());
  }

  Future<bool> isInWatchLater(int id) async {
    final current = await getWatchLaterIds();
    return current.contains(id);
  }
}