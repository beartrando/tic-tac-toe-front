import 'package:front/domain/profile/value_objects/profile_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileId', () {
    test('creates ProfileId with value', () {
      const id = ProfileId('profile-123');

      expect(id.value, 'profile-123');
    });

    test('equality works for same value', () {
      const id1 = ProfileId('profile-123');
      const id2 = ProfileId('profile-123');

      expect(id1 == id2, isTrue);
      expect(id1.hashCode == id2.hashCode, isTrue);
    });

    test('equality fails for different values', () {
      const id1 = ProfileId('profile-123');
      const id2 = ProfileId('profile-456');

      expect(id1 == id2, isFalse);
    });

    test('identical returns true for same instance', () {
      const id = ProfileId('profile-123');

      expect(identical(id, id), isTrue);
    });

    test('toString returns value', () {
      const id = ProfileId('profile-123');

      expect(id.toString(), 'profile-123');
    });
  });
}
