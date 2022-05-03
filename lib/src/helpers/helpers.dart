import 'dart:math';

//generate 6-digits sms code
String generateSmsCode() {
  var rng = new Random();
  var code = rng.nextInt(900000) + 100000;
  return code.toString();
}
