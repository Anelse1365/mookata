import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart'; // Import Mockito for creating mock objects
import 'package:sembast/sembast.dart';
import 'package:flutter_database/reserve/reserve.dart';


class MockDatabase extends Mock implements Database {} // Create a mock database class
class MockStore extends Mock implements StoreRef<int, Map<String, dynamic>> {} // Create a mock store class and implement the required methods

void main() {
  testWidgets('Submitting reservation adds record to database', (WidgetTester tester) async {
    // Create mock instances of required dependencies
    final MockDatabase mockDatabase = MockDatabase();
    final MockStore mockStore = MockStore();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: ReservationPage(database: mockDatabase, store: mockStore)));

    // Find the submit button
    final submitButtonFinder = find.widgetWithText(ElevatedButton, 'Submit Reservation');

    // Tap the submit button.
    await tester.tap(submitButtonFinder);
    await tester.pump();

    // Verify that the _storeRecord method is called with the correct arguments
    verify(mockStore.add(mockDatabase, String as Map<String, dynamic>)).called(1); // Verify the call with correct arguments
  });
}