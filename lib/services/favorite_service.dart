import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const _key = 'favorite_ids';

  Future<List<int>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key)?.map(int.parse).toList() ?? [];
  }

  Future<void> toggleFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getFavoriteIds();
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    prefs.setStringList(_key, current.map((e) => e.toString()).toList());
  }

  Future<bool> isFavorite(int id) async {
    final current = await getFavoriteIds();
    return current.contains(id);
  }
}
