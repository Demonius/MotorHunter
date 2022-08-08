abstract class JsonConversion {
  static bool _intToBool(int value) => value == 1;

  static bool _stringToBool(String value) => value == "1";

  static int _boolToInt(bool value) => value ? 1 : 0;

  static String _boolToString(bool value) => value ? "1" : "0";

  static double _stringToDouble(String value) => double.tryParse(value) ?? 0.0;

  static String _doubleToString(double? value) => value.toString() ?? "";
}
