import 'dart:io';

class CookieDto {
  CookieDto._({String name, String value, this.originalCookie})
      : _name = name,
        _value = value;
  static CookieDto fromCookie(Cookie cookie) {
    return CookieDto._(originalCookie: cookie);
  }

  static CookieDto fromJson(dynamic json) {
    return CookieDto._(
      name: json['name'],
      value: json['value'],
    );
  }

  final String _name;
  final String _value;

  final Cookie originalCookie;

  String get name => originalCookie?.name ?? _name;
  String get value => originalCookie?.value ?? _value;
  bool get hasOriginalCookie => originalCookie != null;

  Cookie toCookie() => Cookie(name, value);
  Map<String, String> toJson() =>
      <String, String>{'name': name, 'value': value};

  @override
  String toString() => toCookie().toString();
}
