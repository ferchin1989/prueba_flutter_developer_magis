import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

class TestClass {
  int getValue() => 42;
}

@GenerateMocks([TestClass])
void main() {
  test('Simple mock test', () {
    expect(1, 1);
  });
}
