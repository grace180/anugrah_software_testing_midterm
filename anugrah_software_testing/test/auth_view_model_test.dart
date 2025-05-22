import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:anugrah_software_testing/model/user.dart';
import 'package:anugrah_software_testing/model/authService.dart';
import 'package:anugrah_software_testing/viewmodel/authViewModel.dart';

import 'auth_view_model_test.mocks.dart';

@GenerateMocks([AuthService])
void main() {
  late AuthViewModel viewModel;
  late MockAuthService mockAuthService;
  final mockUser = User(
    id: 1,
    username: 'emilys',
    email: 'emily@example.com',
    firstName: 'Emily',
    lastName: 'Smith',
    gender: 'female',
    image: 'https://example.com/image.jpg',
    token: 'valid_token',
    refreshToken: 'valid_refresh_token',
  );

  setUp(() {
    mockAuthService = MockAuthService();
    viewModel = AuthViewModel(authService: mockAuthService);
  });

  // TC_AUTH_VM_001: Empty username validation
  test('TC_AUTH_VM_001: Empty username returns error', () {
    expect(viewModel.validateUsername(''), 'Username cannot be empty');
  });

  // TC_AUTH_VM_002: Short password validation
  test('TC_AUTH_VM_002: Short password returns error', () {
    expect(viewModel.validatePassword('123'), 'Password must be at least 6 characters');
  });

  // TC_AUTH_VM_003: Successful login
  test('TC_AUTH_VM_003: Valid login updates user state', () async {
    when(mockAuthService.login(
      username: 'emilys',
      password: 'emilyspass',
      expiresInMins: 30,
    )).thenAnswer((_) async => mockUser);

    await viewModel.login('emilys', 'emilyspass');

    expect(viewModel.currentUser, mockUser);
    expect(viewModel.errorMessage, isNull);
  });

  // TC_AUTH_VM_004: Failed login
    test('TC_AUTH_VM_004: Invalid login sets error', () async {
    when(mockAuthService.login(
      username: 'invalid',
      password: 'invalid',
      expiresInMins: 30,
    )).thenThrow(Exception('Invalid credentials'));

    await viewModel.login('invalid', 'invalid');

    expect(viewModel.currentUser, isNull);
    expect(viewModel.errorMessage, 'Invalid credentials'); // Updated expectation
  });


  // TC_AUTH_VM_005: Logout functionality
  test('TC_AUTH_VM_005: Logout clears user state', () async {
    // First login
    when(mockAuthService.login(
      username: 'emilys',
      password: 'emilyspass',
      expiresInMins: 30,
    )).thenAnswer((_) async => mockUser);
    await viewModel.login('emilys', 'emilyspass');
    expect(viewModel.currentUser, isNotNull);

    // Then logout
    await viewModel.logout();
    expect(viewModel.currentUser, isNull);
  });

  // TC_AUTH_VM_006: Username boundary values
  test('TC_AUTH_VM_006: Username length validation', () {
    expect(viewModel.validateUsername('a' * 20), isNull); // Max allowed
    expect(viewModel.validateUsername('a' * 21), 'Username cannot exceed 20 characters');
  });

  // TC_AUTH_VM_007: Password boundary values
  test('TC_AUTH_VM_007: Password length validation', () {
    expect(viewModel.validatePassword('a' * 6), isNull); // Min allowed
    expect(viewModel.validatePassword('a' * 50), isNull); // Max allowed
    expect(viewModel.validatePassword('a' * 5), 'Password must be at least 6 characters');
    expect(viewModel.validatePassword('a' * 51), 'Password cannot exceed 50 characters');
  });

  // TC_AUTH_VM_008: Special characters in username
  test('TC_AUTH_VM_008: Username special characters', () {
    expect(viewModel.validateUsername('user@name'), 
        'Username can only contain alphanumeric characters');
    expect(viewModel.validateUsername('user name'), 
        'Username can only contain alphanumeric characters');
  });

  // Additional test for token refresh
  test('Token refresh updates session', () async {
    when(mockAuthService.refreshToken(expiresInMins: 30))
        .thenAnswer((_) async => mockUser);

    await viewModel.refreshToken();
    expect(viewModel.currentUser, mockUser);
  });


  
  // TC_AUTH_VM_007: Password Length Boundary Values
   group('Password Length Boundary Values', () {
    test('TC_AUTH_VM_007.1: Minimum length password (6 chars) is valid', () {
      expect(viewModel.validatePassword('123456'), isNull);
    });

    test('TC_AUTH_VM_007.2: Maximum length password (50 chars) is valid', () {
      expect(viewModel.validatePassword('a' * 50), isNull);
    });

    test('TC_AUTH_VM_007.3: Password too short (5 chars) returns error', () {
      expect(viewModel.validatePassword('12345'), 
          'Password must be at least 6 characters');
    });

    test('TC_AUTH_VM_007.4: Password too long (51 chars) returns error', () {
      expect(viewModel.validatePassword('a' * 51), 
          'Password cannot exceed 50 characters');
    });
  });
  // TC_AUTH_VM_008: Login with Special Characters in Username
  group('Username Special Characters', () {
    test('TC_AUTH_VM_008.1: Alphanumeric username is valid', () {
      expect(viewModel.validateUsername('user123'), isNull);
    });

    test('TC_AUTH_VM_008.2: Username with @ symbol returns error', () {
      expect(viewModel.validateUsername('user@name'), 
          'Username can only contain alphanumeric characters');
    });

    test('TC_AUTH_VM_008.3: Username with space returns error', () {
      expect(viewModel.validateUsername('user name'), 
          'Username can only contain alphanumeric characters');
    });

    test('TC_AUTH_VM_008.4: Username with hyphen returns error', () {
      expect(viewModel.validateUsername('user-name'), 
          'Username can only contain alphanumeric characters');
    });
  });

  // TC_AUTH_VM_009: Login with SQL Injection Attempt
   group('SQL Injection Protection', () {
    setUp(() {
      // Reset state before each test
      viewModel.errorMessage = null;
      viewModel.currentUser = null;
    });

    test('TC_AUTH_VM_009.1: SQL injection in username is rejected by validation', () async {
      const sqlInjection = "' OR '1'='1";
      await viewModel.login(sqlInjection, 'any');
      
      // Should be caught by username validation, not API
      expect(viewModel.errorMessage, 'Username can only contain alphanumeric characters');
      verifyNever(mockAuthService.login(
        username: anyNamed('username'),
        password: anyNamed('password'),
        expiresInMins: anyNamed('expiresInMins'),
      ));
    });

    test('TC_AUTH_VM_009.2: SQL injection in password is rejected by API', () async {
      const sqlInjection = "' OR '1'='1";
      when(mockAuthService.login(
        username: 'validuser',
        password: sqlInjection,
        expiresInMins: 30,
      )).thenThrow(Exception('Invalid credentials'));

      await viewModel.login('validuser', sqlInjection);
      expect(viewModel.errorMessage, 'Invalid credentials');
    });

    test('TC_AUTH_VM_009.3: System remains secure after injection attempt', () async {
      // First attempt with SQL injection
      const sqlInjection = "'; DROP TABLE users;--";
      when(mockAuthService.login(
        username: 'validuser',
        password: sqlInjection,
        expiresInMins: 30,
      )).thenThrow(Exception('Invalid credentials'));

      await viewModel.login('validuser', sqlInjection);
      expect(viewModel.currentUser, isNull);

      // Then verify normal login still works
      when(mockAuthService.login(
        username: 'validuser',
        password: 'validpass',
        expiresInMins: 30,
      )).thenAnswer((_) async => mockUser);

      await viewModel.login('validuser', 'validpass');
      expect(viewModel.currentUser, mockUser);
    });
  });

  // TC_AUTH_VM_010: Login with Empty Fields
  group('Empty Field Validation', () {
    test('TC_AUTH_VM_010.1: Empty username returns error', () async {
      await viewModel.login('', 'password');
      expect(viewModel.errorMessage, contains('Username cannot be empty'));
    });

    test('TC_AUTH_VM_010.2: Empty password returns error', () async {
      await viewModel.login('username', '');
      expect(viewModel.errorMessage, contains('Password cannot be empty'));
    });

    test('TC_AUTH_VM_010.3: Both fields empty returns username error', () async {
      await viewModel.login('', '');
      expect(viewModel.errorMessage, contains('Username cannot be empty'));
    });

    test('TC_AUTH_VM_010.4: API not called when fields are empty', () async {
      await viewModel.login('', '');
      verifyNever(mockAuthService.login(
        username: anyNamed('username'),
        password: anyNamed('password'),
        expiresInMins: anyNamed('expiresInMins'),
      ));
    });
  });
}