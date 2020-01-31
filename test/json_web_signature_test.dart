import 'dart:convert';

import 'package:test/test.dart';
import 'package:start_jwt/json_web_signature.dart';


void main() {
  group("The JWS spec", () {
    test("allows signing of messages", () {
      final header = {
        'typ': 'JWT',
        'alg': 'HS256'
      };

      final payload = {
        'iss': 'joe',
        'exp': 1300819380,
        'http://example.com/is_root': true
      };

      final secret = "GawgguFyGrWKav7AX4VKUg";

      final jws = new JsonWebSignatureCodec(header: header, secret: secret);
      final token = jws.encode(jsonEncode(payload).codeUnits);
      final parts = token.split('.');

      expect(parts[0], equals('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9'));
      expect(parts[1], equals('eyJpc3MiOiJqb2UiLCJleHAiOjEzMDA4MTkzODAsImh0dHA6Ly9leGFtcGxlLmNvbS9pc19yb290Ijp0cnVlfQ=='));
      expect(jws.isValid(token), isTrue);
      expect(jsonDecode(new String.fromCharCodes(jws.decode(token))), equals(payload));
    });
  });
}
