import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled_tec_game/utils/log_handler.dart';

class PersistentData {
  static SharedPreferences? preferences;

  /// Initializes the shared preferences instance for persistent data storage.
  ///
  /// This method must be called before accessing or modifying any persistent
  /// data using the [PersistentData] class. It retrieves an instance of
  /// [SharedPreferences] and assigns it to the [preferences] variable.
  ///
  /// Returns a [Future] that completes when the initialization is done.
  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  /// Saves the given [bodyValues] to persistent storage using the provided [keys] in the shared preferences.
  /// Values will be saved a string.
  /// Parameters:
  /// - [keys] list of strings representing the keys to be saved.
  /// - [bodyValues] map containing the key-value pairs to be saved.
  ///
  /// Returns a [Future] that completes with a boolean value indicating whether the data was successfully saved.
  /// If an error occurs during the saving process, the function returns `false`.
  static Future<bool> saveMany(List<String> keys, Map<String, dynamic> bodyValues) async {
    try {
      for(String key in keys) {
        await preferences!.setString(key, bodyValues[key]);
      }
      
      return true; 
    } catch (e) {
      return false;
    }
  }
  
  /// Saves a single key-value pair to persistent storage as a string value.
  ///
  /// @param {String} key - The key to save.
  /// @param {String} value - The value to save.
  /// @return {Future<bool>} - A Future that completes with a boolean value indicating whether the data was successfully saved.
  static Future<bool> save(String key, String value) async {
    try {
      await preferences!.setString(key, value);
      
      return true; 
    } catch (e) {
      return false;
    }
  }
  
  /// Saves a counter value to persistent storage.
  /// 
  /// Parameters:
  ///   - [numberKey] The key to save the counter value under. It creates the key if it doesn't exist.
  ///   - [value] The counter value to save. Defaults to 0. Useful to reset a counter too.
  /// 
  /// Returns a [Future] that completes with a boolean value indicating whether the data was successfully saved.
  static Future<bool> saveNumber({required String numberKey, int value = 0}) async {
    try {
      await preferences!.setInt(numberKey, value);
      
      return true; 
    } catch (e) {
      return false;
    }
  }

    /// Increases the counter value associated with the given [countKey] in persistent storage.
  /// 
  /// Parameters:
  ///   - [countKey] The key to increase the counter value under.
  ///   - [by] The amount to increase the counter value by. It creates the key if it doesn't exist. Defaults to 1.
  /// 
  /// Returns a [Future] that completes with a boolean value indicating whether the data was successfully increased.
  static Future<int> increaseCounter({required String countKey, int by = 1}) async {
    try {
      final actualValue = preferences!.getInt(countKey) ?? 0;
      await preferences!.setInt(countKey, actualValue + by);
      
      return actualValue + by; 
    } catch (e) {
      return 0;
    }
  }

  /// Retrieves the persistent data associated with the given [key] as string from the shared preferences.
  ///
  /// Returns a [Future] that completes with the value associated with the [key] in the shared preferences.
  static Future<String?> obtain(String key) async {
    try {
      return preferences!.getString(key);
    } catch (e) {
      return null;
    }
  }
  
  /// Retrieves the persistent data associated with the given [key] as int from the shared preferences.
  ///
  /// Returns a [Future] that completes with the value associated with the [key] in the shared preferences.
  static Future<int?> obtainInt(String key) async {
    try {
      return preferences!.getInt(key);
    } catch (e) {
      return null;
    }
  }

  /// Removes the user tokens from the shared preferences.
  ///
  /// Returns a `Future<bool>` that completes with `true` if the tokens were
  /// successfully removed, and `false` otherwise.
  static Future<bool> remove(String key) async {
    try {
      await preferences!.remove(key);

      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Removes the user tokens from the shared preferences.
  ///
  /// Returns a `Future<bool>` that completes with `true` if the tokens were
  /// successfully removed, and `false` otherwise.
  static Future<bool> removeMany(List<String> keys) async {
    try {
      for(String key in keys) {
        await preferences!.remove(key);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clears all key-value pairs from the shared preferences.
  ///
  /// Returns a `Future<bool>` that completes with `true` if the data was
  /// successfully cleared, and `false` otherwise.
  static Future<bool> clear() async {
    try {
      final result = preferences!.clear();
      println("clear result: $result");

      return result;
    } catch (e) {
      return false;
    }
}
}
