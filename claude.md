# Sirsak Pop Nasabah - Architecture Documentation

## Project Overview
Flutter mobile application using **Riverpod MVVM** architecture with feature-based folder organization.

## Architecture Decision: Riverpod with Simple MVVM

### Why Riverpod over Stacked?
- **Better testability**: Easy provider overrides without global service locator
- **Explicit dependencies**: Clear what each component needs
- **Automatic rebuilds**: No manual `rebuildUi()` calls
- **Highly composable**: Providers naturally depend on other providers
- **No code generation required**: (though we use Freezed for state classes)
- **Superior DevTools**: Better debugging experience

### Why Simple MVVM (Not Clean Architecture)?
- **Faster development**: 3-4 files per feature instead of 8-10
- **Less boilerplate**: No separate entities, use cases, or repository abstractions
- **Still testable**: ViewModels and Services can be easily mocked
- **Flexible**: Can add repositories/caching later if needed
- **Easier to understand**: Flat learning curve for new developers

---

## Folder Structure

```
lib/
├── core/                              # Core utilities (shared across app)
│   ├── router/
│   │   └── app_router.dart           # GoRouter configuration
│   ├── constants/
│   │   ├── app_constants.dart        # App-wide constants
│   │   └── route_path.dart           # Route path constants
│   └── theme/
│       ├── app_colors.dart           # Color constants
│       └── app_theme.dart            # Theme configuration
│
├── models/                            # Shared data models (JSON serializable)
│   └── user_model.dart               # Example: User data model
│
├── services/                          # API services (shared across features)
│   └── auth_service.dart             # Example: Authentication API calls
│
├── features/                          # Features organized by folder (MVVM)
│   ├── splash/
│   │   ├── splash_view.dart          # UI
│   │   ├── splash_viewmodel.dart     # Business logic
│   │   └── splash_provider.dart      # Riverpod provider
│   ├── auth/
│   │   └── login/
│   │       ├── login_view.dart       # Login UI
│   │       ├── login_viewmodel.dart  # Login business logic
│   │       ├── login_provider.dart   # Login providers
│   │       └── login_state.dart      # Freezed state class
│   └── home/
│       └── home_view.dart            # Home screen
│
├── shared/                            # Shared UI components
│   ├── widgets/
│   │   ├── custom_button.dart        # Reusable button
│   │   └── custom_text_field.dart    # Reusable text field
│   └── ui_helpers.dart               # UI utility functions
│
└── main.dart                          # App entry point
```

---

## MVVM Pattern with Riverpod

### Components

#### 1. View (UI Layer)
- Uses `ConsumerWidget` or `ConsumerStatefulWidget`
- Watches providers for state changes
- Displays UI based on state
- Calls ViewModel methods for actions

```dart
class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: viewModel.setEmail,
          ),
          ElevatedButton(
            onPressed: viewModel.login,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

#### 2. ViewModel (Business Logic Layer)
- Extends `StateNotifier<State>` or `Notifier<State>`
- Manages feature state
- Contains business logic
- Validates user input
- Calls services for data operations

```dart
class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(const LoginState());

  void setEmail(String email) {
    state = state.copyWith(email: email, emailError: null);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password, passwordError: null);
  }

  Future<void> login() async {
    if (!_validateForm()) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Call service here
      await Future.delayed(Duration(seconds: 1)); // Mock delay
      // Navigate on success
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  bool _validateForm() {
    // Validation logic
    return true;
  }
}
```

#### 3. State (Data Layer)
- Uses `freezed` for immutability
- Contains all UI state
- Provides `copyWith` for updates

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isLoading,
    String? errorMessage,
    String? emailError,
    String? passwordError,
  }) = _LoginState;
}
```

#### 4. Provider (Glue Layer)
- Connects View to ViewModel
- Manages dependencies
- Enables testing through overrides

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel();
});
```

---

## Coding Patterns & Conventions

### File Naming
- **Views**: `feature_view.dart` (e.g., `login_view.dart`)
- **ViewModels**: `feature_viewmodel.dart` (e.g., `login_viewmodel.dart`)
- **Providers**: `feature_provider.dart` (e.g., `login_provider.dart`)
- **State**: `feature_state.dart` (e.g., `login_state.dart`)
- **Services**: `service_name_service.dart` (e.g., `auth_service.dart`)
- **Models**: `model_name_model.dart` (e.g., `user_model.dart`)

### Class Naming
- **Views**: `FeatureView` (e.g., `LoginView`)
- **ViewModels**: `FeatureViewModel` (e.g., `LoginViewModel`)
- **State**: `FeatureState` (e.g., `LoginState`)
- **Services**: `ServiceNameService` (e.g., `AuthService`)
- **Models**: `ModelNameModel` (e.g., `UserModel`)

### Provider Naming
- **ViewModels**: `featureViewModelProvider`
- **Services**: `serviceNameServiceProvider`
- **Simple State**: `featureStateProvider`

### State Management Rules
1. **Immutable State**: Always use `freezed` for state classes
2. **No Direct Mutation**: Use `copyWith` to update state
3. **Single Source of Truth**: One provider per feature state
4. **Explicit Dependencies**: Inject dependencies through provider refs

### Navigation
- Use **GoRouter** for declarative routing
- Define routes in `lib/core/router/app_router.dart`
- **IMPORTANT**: Define route paths as constants in `lib/core/constants/route_path.dart`
- Access router through `context.go()` or `context.push()`
- For navigation in ViewModels, access router via ref

#### Route Path Constants
All route paths must be defined in `route_path.dart` for maintainability and type safety:

```dart
// lib/core/constants/route_path.dart
/// SApp Route path name
class SAppRoutePath {
  static const login = '/login';
  static const home = '/home';
  static const profile = '/profile';
  static const settings = '/settings';
}
```

**Naming Convention**:
- Use `static const` for route path variables
- Use camelCase for variable names (e.g., `login`, `home`, `userProfile`)
- Use descriptive names that match the feature (e.g., `productDetail`, not `detail`)
- Always start paths with `/` (e.g., `'/login'`, not `'login'`)

#### Navigation Usage

```dart
// In View
context.go(SAppRoutePath.home);
context.push(SAppRoutePath.profile);

// In ViewModel
final router = ref.read(routerProvider);
router.go(SAppRoutePath.home);

// With parameters
context.push('${SAppRoutePath.productDetail}/$productId');
```

#### Router Configuration
Always use route path constants when defining routes:

```dart
// lib/core/router/app_router.dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: SAppRoutePath.login,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: SAppRoutePath.home,
      builder: (context, state) => const HomeView(),
    ),
  ],
);
```

---

## Dependencies

### Main Dependencies
```yaml
dependencies:
  flutter_riverpod: ^2.5.1      # State management
  go_router: ^14.2.7            # Routing
  freezed_annotation: ^2.4.1    # Immutable state
  json_annotation: ^4.8.1       # JSON serialization
  dio: ^5.4.0                   # HTTP client (when needed)
```

### Dev Dependencies
```yaml
dev_dependencies:
  freezed: ^2.4.6               # Code generation for state
  json_serializable: ^6.7.1     # JSON code generation
  build_runner: ^2.4.7          # Code generation runner
  riverpod_lint: ^2.3.13        # Linting rules
```

### Generate Code
```bash
# Generate Freezed and JSON serializable code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (regenerates on save)
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## Testing Guidelines

### Unit Testing ViewModels

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('LoginViewModel should update email', () {
    // Create container for testing
    final container = ProviderContainer();

    // Get ViewModel
    final viewModel = container.read(loginViewModelProvider.notifier);

    // Act
    viewModel.setEmail('test@example.com');

    // Assert
    final state = container.read(loginViewModelProvider);
    expect(state.email, 'test@example.com');

    // Cleanup
    container.dispose();
  });

  test('LoginViewModel should validate email format', () {
    final container = ProviderContainer();
    final viewModel = container.read(loginViewModelProvider.notifier);

    viewModel.setEmail('invalid-email');
    viewModel.login();

    final state = container.read(loginViewModelProvider);
    expect(state.emailError, isNotNull);

    container.dispose();
  });
}
```

### Widget Testing with Provider Overrides

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('LoginView should display error message', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override provider for testing
          loginViewModelProvider.overrideWith((ref) => MockLoginViewModel()),
        ],
        child: MaterialApp(home: LoginView()),
      ),
    );

    // Interact with UI
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Assert
    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}
```

### Testing Services

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

void main() {
  late AuthService authService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    authService = AuthService(mockDio);
  });

  test('AuthService login should return user on success', () async {
    // Arrange
    when(mockDio.post(any, data: anyNamed('data')))
        .thenAnswer((_) async => Response(
          data: {'id': 1, 'name': 'Test User'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ));

    // Act
    final user = await authService.login('test@example.com', 'password');

    // Assert
    expect(user.name, 'Test User');
    verify(mockDio.post(any, data: anyNamed('data'))).called(1);
  });
}
```

---

## Best Practices

### State Management
1. **Keep State Flat**: Avoid deeply nested state objects
2. **Use Freezed**: Always use `@freezed` for state classes
3. **Immutability**: Never mutate state directly
4. **Loading States**: Always include loading and error states
5. **Error Handling**: Handle errors gracefully with user-friendly messages

### Code Organization
1. **Feature Folders**: Group related files by feature
2. **Shared Code**: Extract reusable widgets to `shared/`
3. **Constants**: Define constants in `core/constants/`
4. **One Class Per File**: Keep files focused and small

### Performance
1. **Provider Scope**: Use minimal provider scopes
2. **Selective Watching**: Use `select` to watch specific state fields
3. **Avoid Rebuilds**: Don't watch providers in build unless needed

```dart
// Bad: Rebuilds on any state change
final state = ref.watch(loginViewModelProvider);
Text(state.email);

// Good: Only rebuilds when email changes
final email = ref.watch(loginViewModelProvider.select((s) => s.email));
Text(email);
```

### Error Handling
1. **Try-Catch**: Always wrap async operations
2. **User-Friendly Messages**: Display clear error messages
3. **Logging**: Log errors for debugging (use logger package)
4. **Retry Logic**: Provide retry options for failed operations

---

## Common Patterns

### Loading States
```dart
@freezed
class FeatureState with _$FeatureState {
  const factory FeatureState({
    @Default(false) bool isLoading,
    String? errorMessage,
    DataModel? data,
  }) = _FeatureState;
}
```

### Form Validation
```dart
bool _validateEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (email.isEmpty) {
    state = state.copyWith(emailError: 'Email is required');
    return false;
  }
  if (!emailRegex.hasMatch(email)) {
    state = state.copyWith(emailError: 'Invalid email format');
    return false;
  }
  return true;
}
```

### Dependent Providers
```dart
// Service provider
final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.read(dioProvider);
  return AuthService(dio);
});

// ViewModel that depends on service
final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final authService = ref.read(authServiceProvider);
  return LoginViewModel(authService);
});
```

---

## Migration Notes

### From Stacked to Riverpod
- `BaseViewModel` → `StateNotifier<State>`
- `StackedView<T>` → `ConsumerWidget`
- `rebuildUi()` → Automatic (via `state = ...`)
- `locator<Service>()` → `ref.read(serviceProvider)`
- `NavigationService` → `GoRouter` / `context.go()`
- `@StackedApp` → Manual provider setup

---

## Resources

- [Riverpod Documentation](https://riverpod.dev)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Flutter Best Practices](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options)

---

## Team Guidelines

### Before Starting a New Feature
1. Create feature folder in `lib/features/`
2. Define state class with Freezed
3. Create ViewModel with business logic
4. Create Provider to expose ViewModel
5. Build View using ConsumerWidget
6. Write unit tests for ViewModel

### Code Review Checklist
- [ ] State classes use Freezed
- [ ] No direct state mutation
- [ ] Error handling implemented
- [ ] Loading states managed
- [ ] Tests written for business logic
- [ ] No logic in View files
- [ ] Consistent naming conventions
- [ ] No hardcoded strings (use constants)
- [ ] Route paths defined in `route_path.dart` (not hardcoded in router/views)

---

**Last Updated**: 2026-01-09
**Architecture Version**: 1.0
**Flutter Version**: 3.29.0
**Dart Version**: 3.7.0
