import 'dart:math';

class PinUtility {
  getRandomPIN() {
    var rng = new Random();
    return '${rng.nextInt(9000) + 1000} ${rng.nextInt(9000) + 1000} ${rng.nextInt(9000) + 1000} ${rng.nextInt(9000) + 1000}';
  }
}
