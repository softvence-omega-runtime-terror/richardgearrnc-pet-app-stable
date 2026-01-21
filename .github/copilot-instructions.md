# Flutter Boilerplate AI Instructions

You are an expert Flutter developer working on a production-grade boilerplate project. Your goal is to maintain the highest standards of code quality, architecture, and maintainability.

**Reference**: For detailed documentation of all reusable components, see `DEVELOPER_GUIDE.md`.

---

## 🤖 Self-Updating Instructions

**This document is a living guide.** When you encounter new patterns, integrations, or conventions that are important for future development, you **MUST** update this file.

### When to Add New Instructions

Add new sections or update existing ones when:

1. **New Core Module Added**: Document the service, its provider, and usage examples
2. **New Reusable Widget Created**: Add to the widgets table with use case and file location
3. **New Constant Category Introduced**: Document in the constants section
4. **New Third-Party Integration**: Document setup, providers, and usage patterns
5. **New Architectural Pattern**: If you establish a new pattern (e.g., pagination, offline-first), document it
6. **New Anti-Pattern Discovered**: Add to the anti-patterns section to prevent future mistakes
7. **Platform-Specific Handling**: Document any iOS/Android specific implementations

### How to Update

1. **Find the relevant section** in this file
2. **Add documentation** following the existing format (tables, code examples, bullet points)
3. **Keep it concise** — focus on what AI needs to know to write correct code
4. **Include examples** — show correct ✅ and incorrect ❌ usage where applicable
5. **Update `DEVELOPER_GUIDE.md`** if the change affects developer-facing documentation

### Example: Adding a New Core Module

If you create a new core module (e.g., `lib/core/push_notifications/`), add:

```markdown
### Push Notifications (`lib/core/push_notifications/`)

| Service                   | Provider                   | Use For                   |
| :------------------------ | :------------------------- | :------------------------ |
| `PushNotificationService` | `pushNotificationProvider` | FCM token & notifications |

**Usage:**
\`\`\`dart
// Register for push notifications
await ref.read(pushNotificationProvider).requestPermission();

// Get FCM token
final token = await ref.read(pushNotificationProvider).getToken();
\`\`\`
```

### Validation Before Completion

Before finishing any task that introduces new reusable patterns:

- [ ] Did I create something that future tasks will need? → **Update this file**
- [ ] Did I add a new constant category? → **Document it**
- [ ] Did I discover a gotcha or edge case? → **Add to anti-patterns**
- [ ] Did I integrate a new package? → **Document the pattern**
- [ ] Did I make a significant change worth noting? → **Update CHANGELOG.md**

### Updating CHANGELOG.md

When making significant changes (new features, bug fixes, breaking changes), update `CHANGELOG.md`:

1. Add entry under `## [Unreleased]` section
2. Use appropriate category: `Added`, `Changed`, `Fixed`, `Removed`, `Security`
3. Keep entries concise but descriptive

```markdown
## [Unreleased]

### Added

- New `useNetworkStatus` hook for connectivity monitoring

### Fixed

- URL validator now correctly rejects URLs without host
```

---

## ⚠️ Critical: Architectural Constraints

### File Size & Organization

**These are guidelines, not hard constraints for pages with private widgets.**

#### For Services / Logic Files

**Strict limit: 200 lines maximum**

- Extract configs, enums, or sub-services if exceeded
- These files should be focused and modular

#### For Pages with Private Widgets

**No hard limit** - Keep pages together if all private widgets serve that page

- Example: `login_page.dart` (421 lines), `otp_verification_page.dart` (508 lines) ✅
- **Reason**: Better discoverability and understanding the complete page structure at a glance
- **Condition**: All private widgets must be tightly scoped to serve the parent page widget
- **Organization**: Page widget first, then private helper widgets in reading order

#### For Reusable Component Files

**Guideline: 250 lines**

- If a reusable widget file exceeds this, extract independent widgets to separate files
- Multiple independent widgets → Each gets its own file
- Related widgets that serve together → Can stay together

#### For Test Files

**Flexible: ~300 lines**

- Split by test group if possible
- Keep related tests together for readability

### One Class Per File Principle

- **Rule**: One public class/widget per file (one responsibility per file)
- **Benefits**: Easier to navigate, maintain, test, and reason about code
- **Exception**: Private helper classes/widgets are acceptable if they only serve one specific parent class

```dart
// ✅ CORRECT - Page with private helper widgets (same file)
// login_page.dart (421 lines)
class LoginPage extends HookConsumerWidget { ... }
class _HeroSection extends HookConsumerWidget { ... }
class _BottomSection extends HookConsumerWidget { ... }
class _PhoneInput extends StatelessWidget { ... }
// All private widgets only serve LoginPage → Good design!

// ✅ CORRECT - Single reusable widget per file
// my_button.dart
class MyButton extends StatelessWidget { ... }

// ❌ AVOID - Multiple independent widgets in one file
// buttons.dart (BAD - widgets don't serve each other)
class MyButton extends StatelessWidget { ... }
class MyCard extends StatelessWidget { ... }
class MyDialog extends StatelessWidget { ... }
// These should each have their own file

// ❌ AVOID - Private widgets that don't serve the parent
// page.dart (BAD STRUCTURE)
class MyPage extends StatelessWidget { ... }
class UnrelatedWidget extends StatelessWidget { ... }  // Doesn't serve MyPage
// UnrelatedWidget should be in its own file
```

### Structure Recommendation for Large Pages

When building complex pages (400+ lines), use this structure:

```
Page file (1 public widget + N private widgets)
├── 1. Main Page Widget (HookConsumerWidget) - top level
├── 2. Hero/Header Section (private) - visual segment
├── 3. Middle/Content Section (private) - main content
├── 4. Bottom/Actions Section (private) - buttons/actions
├── 5. Smaller helpers (private) - headers, inputs, etc.
└── All serve the same page → Cohesive and discoverable!

Result: One file, great structure, easy to understand page flow
```

---

## 🏗️ Project Architecture

This project follows a **Feature-First Clean Architecture** with **Riverpod** for state management.

### Directory Structure

```
lib/
├── app/                    # App-level setup
│   ├── router/             # GoRouter configuration & routes
│   └── startup/            # App lifecycle & startup state machine
├── config/                 # Environment configuration
├── core/                   # Shared utilities & foundational code (27 modules)
│   ├── analytics/          # Firebase Analytics
│   ├── biometric/          # Biometric authentication
│   ├── cache/              # Offline-first caching (Drift)
│   ├── constants/          # App-wide constants
│   ├── crashlytics/        # Firebase Crashlytics
│   ├── deep_link/          # Deep links & universal links
│   ├── extensions/         # Dart/Flutter extensions
│   ├── feedback/           # Context-free snackbars/dialogs
│   ├── forms/              # Reactive Forms configurations
│   ├── hooks/              # Flutter Hooks utilities
│   ├── localization/       # Locale management & persistence
│   ├── network/            # Dio, interceptors, API client
│   ├── notifications/      # Local notifications
│   ├── performance/        # Firebase Performance
│   ├── permissions/        # Permission handling
│   ├── remote_config/      # Firebase Remote Config
│   ├── result/             # Result monad for error handling
│   ├── review/             # In-app review prompts
│   ├── session/            # Session state management
│   ├── storage/            # Secure storage utilities
│   ├── theme/              # App theming
│   ├── utils/              # Validators, logger, etc.
│   ├── version/            # App version & force update
│   └── widgets/            # Reusable UI components (25+)
├── features/               # Feature modules
│   ├── auth/               # Authentication feature
│   ├── home/               # Home feature
│   ├── onboarding/         # Onboarding feature
│   └── settings/           # Settings feature
└── l10n/                   # Localization files
```

### Feature Module Structure

Each feature **MUST** follow this structure:

```
features/<feature_name>/
├── data/               # Data layer
│   └── repositories/   # Repository implementations
├── domain/             # Domain layer
│   ├── entities/       # Business objects
│   └── repositories/   # Repository interfaces
└── presentation/       # Presentation layer
    ├── pages/          # Full screens
    ├── widgets/        # Feature-specific widgets
    └── providers/      # Riverpod Notifiers
```

---

## 🔄 State Management (Riverpod)

### Widget Class Selection

Choose the appropriate widget class based on your needs:

| Widget Type              | When to Use                                     |
| :----------------------- | :---------------------------------------------- |
| `HookConsumerWidget`     | **Default for pages** - Riverpod + Hooks access |
| `ConsumerWidget`         | Simple widgets needing only Riverpod            |
| `HookWidget`             | Widgets needing only hooks (no Riverpod)        |
| `ConsumerStatefulWidget` | When you need `initState`/`dispose` lifecycle   |
| `StatelessWidget`        | Pure UI with no state or providers              |

**Recommendation**: Use `HookConsumerWidget` for all pages to leverage `useOnMount` for analytics.

### Rules

- **Mandatory**: Use **Riverpod** for all state management.
- **Code Generation**: Use `@riverpod` / `@Riverpod(keepAlive: true)`.
- **Logic Location**: Business logic resides in **Notifiers** (Presentation) or **Services** (Domain/Data).
- **UI Role**: Widgets only `watch` state and `read` methods. No complex logic in `build()`.
- **Avoid**: `StatefulWidget` for logic (use only for animation/input controllers).

### keepAlive Guidelines

Use `@Riverpod(keepAlive: true)` **ONLY** for:

- Global app state (auth, theme, user preferences)
- Expensive services (network clients, database connections)
- State that must survive navigation (audio player, download manager)

**Default to autoDispose** for page-specific providers.

### Example Provider

```dart
@riverpod
class MyFeatureNotifier extends _$MyFeatureNotifier {
  @override
  Future<MyData> build() async {
    final repo = ref.watch(myRepositoryProvider);
    return repo.fetchData();
  }

  Future<void> doSomething() async {
    state = const AsyncLoading();
    final result = await ref.read(myRepositoryProvider).doAction();
    state = result.fold(
      onSuccess: AsyncData.new,
      onFailure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}
```

---

## 🛣️ Routing (GoRouter)

- Use **GoRouter** for all navigation.
- Define routes in `lib/app/router/`.
- Use `AppRoute` enum for type-safe route paths.

### Route Navigation

```dart
// Using extension methods (preferred)
context.goRoute(AppRoute.home);
context.pushRoute(AppRoute.settings);

// With parameters
context.goRouteWith(AppRoute.productDetail, {'id': '123'});

// Standard GoRouter (also works)
context.go('/home');
context.push('/settings');
```

### Adding New Routes

1. Add enum entry to `AppRoute` in `app_router.dart`
2. Create route definition in appropriate file (`auth_routes.dart`, `protected_routes.dart`)
3. Set `requiresAuth` appropriately

---

## 📋 Forms

- Use **`reactive_forms`** for all complex form handling.
- Use pre-built form groups from `lib/core/forms/` (e.g., `AuthForms.login()`).
- Validation logic should be reusable (e.g., `lib/core/utils/validators.dart`).

---

## 📦 Mandatory Reusable Components

**You MUST use these existing components. Do NOT create alternatives.**

### Widgets (`lib/core/widgets/`)

Widgets are organized into separate files. Use barrel exports (`animations.dart`, `dialogs.dart`, `inputs.dart`) for imports.

| Widget                               | Use For                                                     | File                        |
| :----------------------------------- | :---------------------------------------------------------- | :-------------------------- |
| `AsyncValueWidget<T>`                | Displaying Riverpod `AsyncValue` (loading/error/data)       | `async_value_widget.dart`   |
| `LoadingWidget`                      | Any loading state                                           | `async_value_widget.dart`   |
| `AppErrorWidget`                     | Any error state with retry action                           | `async_value_widget.dart`   |
| `EmptyWidget`                        | Empty lists / no data states                                | `async_value_widget.dart`   |
| `AppButton`                          | All buttons (use `AppButtonVariant.primary/secondary/text`) | `buttons.dart`              |
| `AppIconButton`                      | All icon buttons                                            | `buttons.dart`              |
| `VerticalSpace` / `HorizontalSpace`  | All spacing (`.xs()`, `.sm()`, `.md()`, `.lg()`, `.xl()`)   | `spacing.dart`              |
| `AppTextField`                       | Text input fields                                           | `text_fields.dart`          |
| `AppSearchField`                     | Search input with clear button                              | `text_fields.dart`          |
| `AppChip`                            | Filter/input chips                                          | `chips.dart`                |
| `AppBadge`                           | Count/status badges                                         | `badges.dart`               |
| `StatusDot`                          | Status indicators (online/offline/busy)                     | `status_indicators.dart`    |
| `AppDivider`                         | Dividers with optional labels                               | `dividers.dart`             |
| `CachedImage`                        | All network images                                          | `cached_image.dart`         |
| `ResponsiveBuilder`                  | Adaptive layouts                                            | `responsive_builder.dart`   |
| `AppDialogs.confirm()`               | Confirmation dialogs                                        | `app_dialogs.dart`          |
| `AppBottomSheets.confirm()`          | Bottom sheet confirmations                                  | `bottom_sheets.dart`        |
| `FadeIn` / `SlideIn` / `ScaleIn`     | Entry animations (use `.staggered()` for lists)             | `entry_animations.dart`     |
| `StaggeredList`                      | Staggered list animations                                   | `staggered_list.dart`       |
| `Bounce` / `Pulse` / `ShakeWidget`   | Attention/feedback animations                               | `attention_animations.dart` |
| `FlipCard`                           | 3D flip transitions                                         | `flip_card.dart`            |
| `ExpandableWidget`                   | Expand/collapse sections                                    | `expandable_widget.dart`    |
| `AnimatedCounter`                    | Animated number changes                                     | `animated_counter.dart`     |
| `AnimatedProgress`                   | Animated progress bars                                      | `animated_progress.dart`    |
| `TypewriterText`                     | Typewriter text effect                                      | `typewriter_text.dart`      |
| `ShimmerLoading` / `ShimmerListTile` | Skeleton loading states                                     | `shimmer_loading.dart`      |

### Constants (`lib/core/constants/`)

| File                 | Contains                          |
| :------------------- | :-------------------------------- |
| `app_constants.dart` | Durations, dimensions, validation |
| `api_endpoints.dart` | API endpoint paths                |
| `assets.dart`        | Image, icon, animation paths      |
| `storage_keys.dart`  | Secure storage and prefs keys     |

| Constant Class                   | Use For               |
| :------------------------------- | :-------------------- |
| `AppConstants.animationFast`     | Fast transitions      |
| `AppConstants.animationNormal`   | Standard animations   |
| `AppConstants.animationSlow`     | Emphasized animations |
| `AppConstants.staggerDelay`      | List item stagger     |
| `AppConstants.counterAnimation`  | Counter animations    |
| `AppConstants.flipAnimation`     | Flip card duration    |
| `AppConstants.bounceAnimation`   | Bounce effects        |
| `AppConstants.expandAnimation`   | Expand/collapse       |
| `AppConstants.shakeAnimation`    | Shake effects         |
| `AppConstants.pulseAnimation`    | Pulse effects         |
| `AppConstants.borderRadiusSM`    | Small border radii    |
| `AppConstants.borderRadiusMD`    | Medium border radii   |
| `AppConstants.borderRadiusLG`    | Large border radii    |
| `AppConstants.iconSizeSM`        | Small icons (16px)    |
| `AppConstants.iconSizeMD`        | Medium icons (24px)   |
| `AppConstants.iconSizeXL`        | Large icons (48px)    |
| `AppConstants.iconSizeXXL`       | XL icons (80px)       |
| `AppConstants.dialogIconSize`    | Dialog icons (48px)   |
| `AppConstants.chipIconSize`      | Chip icons (18px)     |
| `AppConstants.debounceDelay`     | Debounce delays       |
| `AppConstants.defaultPageSize`   | Pagination            |
| `ApiEndpoints.login`             | API endpoint paths    |
| `StorageKeys.accessToken`        | Secure storage keys   |
| `Assets.logo`                    | Asset paths           |
| `AppIcons.home`                  | Icon paths            |
| `AnalyticsEvents.login`          | Analytics event keys  |
| `RemoteConfigKeys.minAppVersion` | Remote config keys    |

### Extensions (`lib/core/extensions/`)

```dart
// ✅ Use extensions (preferred)
context.colorScheme         // instead of Theme.of(context).colorScheme
context.textTheme           // instead of Theme.of(context).textTheme
context.theme               // instead of Theme.of(context)
context.screenWidth         // instead of MediaQuery.of(context).size.width
context.isMobile            // responsive checks
context.unfocus()           // dismiss keyboard
context.showSnackBar(msg)   // show snackbar
context.showErrorSnackBar() // error snackbar
'hello'.capitalized         // string utilities
DateTime.now().timeAgo      // date formatting

// Authentication-aware navigation
context.pushRouteIfAuthenticatedElse(
  authenticatedRoute: AppRoute.settings,
  unauthenticatedRoute: AppRoute.login,
)

context.executeIfAuthenticatedElse(
  action: () => sendNotification(),
  unauthenticatedRoute: AppRoute.login,
)
```

### Hooks (`lib/core/hooks/`)

For `HookWidget` and `HookConsumerWidget` classes. **Prefer `HookConsumerWidget` for pages** as it combines Riverpod access with hooks.

| Hook                        | Use For                                        |
| :-------------------------- | :--------------------------------------------- |
| `useOnMount(callback)`      | **One-time effect on mount** (analytics, init) |
| `useDebounce(value, delay)` | Debounced values (search fields)               |
| `useToggle(initial)`        | Boolean toggle state                           |
| `usePrevious(value)`        | Previous render's value                        |
| `useTextController()`       | TextEditingController with auto-dispose        |
| `useFocusNode()`            | FocusNode with auto-dispose                    |
| `useScrollController()`     | ScrollController with auto-dispose             |
| `usePageController()`       | PageController with auto-dispose               |

**Critical**: Always use `useOnMount` for analytics tracking, never track in `build()`:

```dart
// ✅ Correct - tracks once on mount
class MyPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'my_page');
    });
    return Scaffold(...);
  }
}

// ❌ Wrong - tracks on every rebuild!
class BadPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(analyticsServiceProvider).logScreenView(screenName: 'bad'); // BAD!
    return Scaffold(...);
  }
}
```

### Firebase Services (`lib/core/`)

| Service                       | Path             | Use For                         |
| :---------------------------- | :--------------- | :------------------------------ |
| `CrashlyticsService`          | `crashlytics/`   | Crash reporting & error logging |
| `AnalyticsService`            | `analytics/`     | User analytics & event tracking |
| `PerformanceService`          | `performance/`   | Performance monitoring & traces |
| `FirebaseRemoteConfigService` | `remote_config/` | Feature flags & A/B testing     |

### Other Core Services (`lib/core/`)

| Service                    | Path             | Use For                          |
| :------------------------- | :--------------- | :------------------------------- |
| `DeepLinkService`          | `deep_link/`     | Universal links & app links      |
| `FeedbackService`          | `feedback/`      | Context-free snackbars & dialogs |
| `InAppReviewService`       | `review/`        | Smart in-app review prompting    |
| `AppVersionService`        | `version/`       | Version check & force update     |
| `LocaleNotifier`           | `localization/`  | Locale management & persistence  |
| `BiometricService`         | `biometric/`     | Face ID / Touch ID auth          |
| `LocalNotificationService` | `notifications/` | Local push notifications         |
| `PermissionService`        | `permissions/`   | Runtime permission handling      |

```dart
// Analytics
ref.read(analyticsServiceProvider).logLogin(method: 'email');
ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.featureUsed);

// Performance (custom traces)
await ref.read(performanceServiceProvider).traceAsync('checkout', () => process());

// Remote Config (feature flags)
ref.read(firebaseRemoteConfigServiceProvider).getBool(RemoteConfigKeys.newFeatureEnabled);
ref.read(firebaseRemoteConfigServiceProvider).isMaintenanceMode;
```

### Authentication Feature (`lib/features/auth/`)

The auth feature demonstrates proper feature-first architecture with both login and OTP verification flows.

**Structure**:

- **Domain**: `User` entity, `AuthRepository` interface
- **Data**: `AuthRepositoryRemote` (API calls), `AuthRepositoryMock` (testing)
- **Presentation**: `AuthNotifier` (state), `LoginPage` & `OTPVerificationPage` (UI)

**Key Implementation Details**:

| Component              | Details                                                             |
| :--------------------- | :------------------------------------------------------------------ |
| **Pages**              | Large pages with private widgets (421-508 lines) - cohesive & clear |
| **State Management**   | `@Riverpod(keepAlive: true)` for global auth state across app       |
| **Error Handling**     | `Result<T>` monad pattern for all repository operations             |
| **Token Management**   | Shared `_handleAuthResponse()` helper prevents duplication          |
| **OTP Resend Timer**   | Uses `useRef<Timer?>` + `useEffect` for proper cleanup              |
| **Analytics Tracking** | `useOnMount()` hook for screen views (not on rebuild)               |
| **Constants**          | All magic numbers extracted to `AppConstants`                       |
| **Localization**       | All strings from `app_en.arb` / `app_bn.arb`                        |

**Magic Number Constants Added** (in `AppConstants`):

```dart
otpLength = 6                              // OTP code length
otpResendTimeoutSeconds = 60               // Resend countdown
otpBoxWidth = 56                           // OTP input box width
otpBoxHeight = 64                          // OTP input box height
otpBoxContentVerticalPadding = 12          // OTP box padding
loginHeroTopSpacingFraction = 0.08         // Login hero top spacing (8%)
otpHeroSectionHeightFraction = 0.45        // OTP hero height (45%)
```

**Usage Pattern**:

```dart
// ❌ WRONG - Magic numbers
width: 56,
height: 64,
Duration(seconds: 60),

// ✅ CORRECT - Use constants
width: AppConstants.otpBoxWidth,
height: AppConstants.otpBoxHeight,
Duration(seconds: AppConstants.otpResendTimeoutSeconds),
```

---

## 📝 Coding Standards & Style

### Hard Constraints

- **No Magic Numbers**: CRITICAL - Every numeric value must use a pre-defined constant (see detailed rules below)
- **No Direct Colors**: Use `context.colorScheme.primary` (via extension).
- **No Raw SizedBox for Spacing**: Use `VerticalSpace.md()` or `HorizontalSpace.sm()`.
- **No Custom Loading Widgets**: Use `LoadingWidget`.
- **No Custom Error Widgets**: Use `AppErrorWidget`.
- **No Hardcoded Strings**: ALL user-facing text must be localized (see section below).
- **Enum Shorthand**: Use Dart 3 enum shorthand syntax (e.g., `variant: .primary` instead of `variant: AppButtonVariant.primary`).

### No Magic Numbers - Detailed Rules

**NEVER use raw numeric values in your code.** Every number must come from a pre-defined constant.

#### Where to find constants:

| Category               | Constants Class | Location               | Examples                                                                |
| :--------------------- | :-------------- | :--------------------- | :---------------------------------------------------------------------- |
| **Animations**         | `AppConstants`  | `lib/core/constants/`  | `animationNormal` (300ms), `pageIndicatorAnimation` (200ms)             |
| **Spacing**            | `AppSpacing`    | `lib/core/extensions/` | `.xs()`, `.sm()`, `.md()`, `.lg()`, `.xl()`                             |
| **Border Radius**      | `AppConstants`  | `lib/core/constants/`  | `borderRadiusSM` (4px), `borderRadiusMD` (8px), `borderRadiusXL` (16px) |
| **Icon Sizes**         | `AppConstants`  | `lib/core/constants/`  | `iconSizeSM` (16px), `iconSizeMD` (24px), `iconSizeLG` (32px)           |
| **Component Heights**  | `AppConstants`  | `lib/core/constants/`  | `buttonHeight` (48px), `inputHeight` (56px)                             |
| **Component Widths**   | `AppConstants`  | `lib/core/constants/`  | `pageIndicatorActiveWidth` (24px), `pageIndicatorInactiveWidth` (8px)   |
| **Opacity/Alpha**      | `AppConstants`  | `lib/core/constants/`  | `pageIndicatorInactiveOpacity` (0.3)                                    |
| **Timeouts**           | `AppConstants`  | `lib/core/constants/`  | `connectTimeout`, `receiveTimeout`                                      |
| **Validation Lengths** | `AppConstants`  | `lib/core/constants/`  | `minPasswordLength` (8), `minUsernameLength` (3)                        |
| **API Config**         | `ApiEndpoints`  | `lib/core/constants/`  | API paths and endpoints                                                 |
| **Storage Keys**       | `StorageKeys`   | `lib/core/constants/`  | Secure storage and shared prefs keys                                    |
| **Asset Paths**        | `Assets`        | `lib/core/constants/`  | Image, icon, animation file paths                                       |

#### Examples of violations (❌ WRONG):

```dart
// ❌ Raw duration
AnimatedContainer(duration: const Duration(milliseconds: 200))

// ❌ Raw numbers for dimensions
width: 24,
height: 8,

// ❌ Raw opacity
color.withValues(alpha: 0.3)

// ❌ Raw border radius
borderRadius: BorderRadius.circular(4)

// ❌ Raw spacing
padding: const EdgeInsets.all(16)
```

#### Examples of correct usage (✅ CORRECT):

```dart
// ✅ Use AppConstants for animations
AnimatedContainer(duration: AppConstants.pageIndicatorAnimation)

// ✅ Use AppConstants for dimensions
width: AppConstants.pageIndicatorActiveWidth,
height: AppConstants.pageIndicatorHeight,

// ✅ Use AppConstants for opacity
color.withValues(alpha: AppConstants.pageIndicatorInactiveOpacity)

// ✅ Use AppConstants for border radius
borderRadius: BorderRadius.circular(AppConstants.borderRadiusSM)

// ✅ Use AppSpacing for spacing
padding: const EdgeInsets.all(AppSpacing.md)
```

#### Before submitting code:

1. **Search for any numeric literals** in your code (regex: `\d+` for numbers in contexts like dimensions, opacity, duration)
2. **Check if a constant exists** - look in `AppConstants`, `AppSpacing`, `ApiEndpoints`, `StorageKeys`, or `Assets`
3. **If no constant exists, CREATE IT** - add it to the appropriate constants file with proper documentation
4. **Replace all raw numbers** with the corresponding constant
5. **Never add a magic number thinking "it's just this once"** - the boilerplate is a template that will be reused across projects

### Naming Conventions

| Type            | Convention  | Example                |
| :-------------- | :---------- | :--------------------- |
| Files           | snake_case  | `user_repository.dart` |
| Classes         | PascalCase  | `UserRepository`       |
| Variables       | camelCase   | `userData`             |
| Private Members | \_camelCase | `_privateField`        |
| Constants       | camelCase   | `maxRetryAttempts`     |
| JSON Fields     | snake_case  | `user_name`            |

### API Endpoint Constants

**CRITICAL: NEVER hardcode API paths in code. ALWAYS use `ApiEndpoints` constants.**

All API endpoints must be defined in `lib/core/constants/api_endpoints.dart` and used throughout repositories:

```dart
// ❌ WRONG - Hardcoded API path
final response = await apiClient.post('/auth/login', data: {...});

// ✅ CORRECT - Use ApiEndpoints constant
final response = await apiClient.post(ApiEndpoints.login, data: {...});
```

**Why this matters:**

- Single source of truth for all API paths
- Easy to find/update endpoints when API changes
- Prevents typos and inconsistencies
- Enables environment-specific URL configuration

**Common Authentication Endpoints:**

| Constant                          | Path                | Use For                    |
| :-------------------------------- | :------------------ | :------------------------- |
| `ApiEndpoints.login`              | `/auth/login`       | Email/password login       |
| `ApiEndpoints.loginPhone`         | `/auth/login/phone` | Phone number login request |
| `ApiEndpoints.verifyOtp`          | `/auth/verify-otp`  | OTP verification           |
| `ApiEndpoints.resendOtp`          | `/auth/resend-otp`  | Resend OTP code            |
| `ApiEndpoints.currentUserProfile` | `/auth/me`          | Get current user profile   |
| `ApiEndpoints.logout`             | `/auth/logout`      | Logout/invalidate session  |
| `ApiEndpoints.refreshToken`       | `/auth/refresh`     | Refresh auth token         |

**Pattern in Repositories:**

```dart
import 'package:petzy_app/core/constants/api_endpoints.dart';

class AuthRepositoryRemote implements AuthRepository {
  @override
  Future<Result<User>> login(String email, String password) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.login,  // ✅ Use constant
      data: {'email': email, 'password': password},
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.fold(
      onSuccess: _handleAuthResponse,
      onFailure: Failure.new,
    );
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _apiClient.post<void>(ApiEndpoints.logout);  // ✅ Use constant
    } catch (_) {
      // Ignore logout errors
    }
    return _clearTokens();
  }
}
```

### Error Handling

Always use the `Result<T>` monad for operations that can fail:

```dart
// Repository
Future<Result<User>> fetchUser(String id) async {
  try {
    final response = await apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.userById + '/$id',  // ✅ Use constant for base path
    );
    return response.map((data) => User.fromJson(data));
  } catch (e) {
    return Failure(UnexpectedException(message: e.toString()));
  }
}

// Usage
final result = await repo.fetchUser('123');
result.fold(
  onSuccess: (user) => handleUser(user),
  onFailure: (error) => showError(error.message),
);
```

### Validation

Use `Validators.compose()` for form validation:

```dart
TextFormField(
  validator: Validators.compose([
    Validators.required('Email is required'),
    Validators.email('Invalid email format'),
  ]),
)
```

**Note**: `Validators.strongPassword()` requires 8+ characters with uppercase, lowercase, number, and special character. Don't add redundant `minLength` validators.

---

## 🌍 Localization & i18n

- **All user-facing text MUST be localized** in `lib/l10n/` files (`.arb` format)
- Use `AppLocalizations.of(context)` to access localized strings
- Never hardcode UI text like button labels, titles, or messages
- Support at least English and one additional language (Bengali in this boilerplate)

```dart
// ✅ Correct
Text(AppLocalizations.of(context).loginButtonLabel)

// ❌ Wrong - hardcoded string
Text('Login')
```

---

## 📊 Analytics & Screen Tracking

- **Track screen views** for all new pages using `useOnMount` hook (HookConsumerWidget):

```dart
class MyPage extends HookConsumerWidget {
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // Track screen view once on mount (not on every rebuild!)
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'my_feature');
    });

    return Scaffold(...);
  }
}
```

For `ConsumerStatefulWidget`, use `initState`:

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(analyticsServiceProvider).logScreenView(screenName: 'my_feature');
  });
}
```

- **Track user actions** like button clicks and form submissions:

```dart
ref.read(analyticsServiceProvider).logEvent(
  AnalyticsEvents.featureUsed,
  parameters: {'feature_name': 'checkout'},
);
```

---

## 🛠️ Development Workflow

### Adding a New Feature

**Always use the generator script:**

```bash
make feature NAME=my_feature
```

Then implement:

1. Define `Entity` in `domain/entities/`.
2. Define `Repository Interface` in `domain/repositories/`.
3. Implement `Repository` in `data/repositories/`.
4. Create `Provider` in `presentation/providers/`.
5. Build `Page` in `presentation/pages/`.
6. Add entry to `AppRoute` enum.

### Build Commands

```bash
make gen       # Run code generation (build_runner + l10n)
make format    # Format code & apply fixes
make lint      # Run static analysis
make test      # Run all tests
make prepare   # Full setup (clean + l10n + gen)
```

### Testing Guidelines

#### Test Organization

- **Unit Tests**: For business logic, repositories, and services (no UI)
- **Widget Tests**: For UI components and pages (uses `testWidgets()`)
- **Pattern**: Arrange-Act-Assert (AAA) for all tests
- **Shared Mocks**: Place in `test/helpers/mocks.dart`
- **Mocking Library**: Use `mocktail` for all mocking
- **Test Structure**: 1 test file per domain/service, feature pages get their own test file

#### Unit Tests (Repositories & Services)

```dart
void main() {
  group('AuthRepository', () {
    late MockApiClient mockApiClient;
    late AuthRepositoryRemote repository;

    setUp(() {
      mockApiClient = MockApiClient();
      repository = AuthRepositoryRemote(apiClient: mockApiClient);
    });

    test('loginWithPhone returns Success with user data', () async {
      // Arrange
      const phoneNumber = '+821234567890';
      final mockResponse = {'id': '1', 'name': 'John'};
      when(() => mockApiClient.post<Map>('/login', data: any(named: 'data')))
          .thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.loginWithPhone(phoneNumber);

      // Assert
      expect(result, isA<Success>());
      expect(result.fold(onSuccess: (data) => data.id, onFailure: (_) => ''), '1');
      verify(() => mockApiClient.post<Map>('/login', data: any(named: 'data')))
          .called(1);
    });

    test('loginWithPhone returns Failure on network error', () async {
      // Arrange
      const phoneNumber = '+821234567890';
      when(() => mockApiClient.post<Map>('/login', data: any(named: 'data')))
          .thenThrow(Exception('Network error'));

      // Act
      final result = await repository.loginWithPhone(phoneNumber);

      // Assert
      expect(result, isA<Failure>());
      expect(result.fold(onSuccess: (_) => false, onFailure: (e) => true), true);
    });
  });
}
```

#### Widget/Page Tests (UI Components)

```dart
void main() {
  group('LoginPage', () {
    late ProviderContainer providerContainer;

    setUp(() {
      // Create a test provider container with overrides
      providerContainer = ProviderContainer(
        overrides: [
          analyticsServiceProvider.overrideWithValue(MockAnalyticsService()),
          authProvider.overrideWithValue(MockAuthNotifier()),
        ],
      );
    });

    testWidgets('displays phone input and login button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: providerContainer,
          child: const MaterialApp(home: LoginPage()),
        ),
      );

      // Assert
      expect(find.byType(InternationalPhoneNumberInput), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('shows error snackbar on invalid phone number', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: providerContainer,
          child: const MaterialApp(home: LoginPage()),
        ),
      );

      // Act - Try to login without entering phone number
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('calls login when button pressed with valid phone', (WidgetTester tester) async {
      // Arrange
      final mockAuthNotifier = MockAuthNotifier();
      providerContainer = ProviderContainer(
        overrides: [
          authProvider.overrideWithValue(mockAuthNotifier),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: providerContainer,
          child: const MaterialApp(home: LoginPage()),
        ),
      );

      // Act - Enter phone number
      await tester.enterText(find.byType(TextField), '+821234567890');
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockAuthNotifier.loginWithPhone('+821234567890')).called(1);
    });
  });
}
```

#### Riverpod Provider Tests

```dart
void main() {
  group('AuthNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(MockAuthRepository()),
        ],
      );
    });

    test('loginWithPhone updates state correctly', () async {
      // Arrange
      final mockRepo = MockAuthRepository();
      when(() => mockRepo.loginWithPhone(any()))
          .thenAnswer((_) async => Success(testUser));

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );

      // Act
      await container.read(authProvider.notifier).loginWithPhone('+821234567890');

      // Assert
      final state = container.read(authProvider);
      expect(state.maybeWhen(
        data: (user) => user?.id == testUser.id,
        orElse: () => false,
      ), true);
    });
  });
}
```

#### Mocking Results

```dart
// ✅ Correct - mock Result success
when(() => repo.getData())
    .thenAnswer((_) async => Success(testData));

// ✅ Correct - mock Result failure
when(() => repo.getData())
    .thenAnswer((_) async => Failure(NetworkException()));

// ✅ Correct - mock void success
when(() => repo.logout())
    .thenAnswer((_) async => const Success(null));
```

#### Best Practices

- **Always use setUp()**: Initialize mocks and providers before each test
- **Test one thing per test**: Each test should verify one behavior
- **Use descriptive names**: Test names should describe what they test
- **Mock external dependencies**: Never make real network/storage calls in tests
- **Use `pumpAndSettle()`**: After tapping buttons to wait for animations
- **Test error cases**: Not just happy paths
- **Clean up resources**: Dispose controllers and providers in tearDown()
- **Test analytics tracking**: Verify `logScreenView` and events are called

---

## 🎨 Visual Design & Theming

### Material 3

- **ThemeData**: Centralized in `lib/core/theme/`.
- **ColorScheme**: Uses `ColorScheme.light()` and `ColorScheme.dark()`.
- **Dark Mode**: Support `ThemeMode.system`, `light`, and `dark`.

### Layout Best Practices

- **Responsiveness**: Use `ResponsiveBuilder` or `context.responsive()`.
- **Spacing**: Use `VerticalSpace` / `HorizontalSpace` widgets.
- **Lists**: Use `ListView.builder` for performance.
- **Safe Areas**: Respect `SafeArea`.

---

## 📱 Responsive Layout Guidelines

### Critical Rules for Overflow Prevention

**NEVER allow layout overflow errors.** These indicate a broken UI that won't work on all devices.

#### Row Widgets - ALWAYS Use Flexible/Expanded

```dart
// ❌ WRONG - Will overflow on small screens
Row(
  children: [
    Text('Very long text that might overflow'),
    Icon(Icons.check),
  ],
)

// ✅ CORRECT - Text will truncate gracefully
Row(
  children: [
    Flexible(
      child: Text(
        'Very long text that might overflow',
        overflow: TextOverflow.ellipsis,
      ),
    ),
    Icon(Icons.check),
  ],
)

// ✅ CORRECT - Text will wrap or scale
Row(
  children: [
    Expanded(
      child: Text(
        'Very long text',
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    ),
    const HorizontalSpace.sm(),
    Icon(Icons.check),
  ],
)
```

#### When to Use Flexible vs Expanded

| Widget      | Use When                                         |
| :---------- | :----------------------------------------------- |
| `Flexible`  | Child can be smaller than available space        |
| `Expanded`  | Child should fill all remaining space            |
| `FittedBox` | Scale down content to fit (icons, images)        |
| `Wrap`      | Items should wrap to next line when space is low |

#### Button Content - Always Constrain Text

```dart
// ❌ WRONG - Button text can overflow
OutlinedButton(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.google),
      SizedBox(width: 8),
      Text('Sign in with Google'), // Can overflow!
    ],
  ),
)

// ✅ CORRECT - Text is constrained
OutlinedButton(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.google),
      const HorizontalSpace.sm(),
      Flexible(
        child: Text(
          'Sign in with Google',
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  ),
)
```

#### Headers with Icons - Space Between Pattern

```dart
// ❌ WRONG - No flex handling
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('Phone Number'),
    Row(children: [Icon(Icons.pets), Icon(Icons.pets)]),
  ],
)

// ✅ CORRECT - Text can shrink, icons stay fixed
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Flexible(
      child: Text(
        'Phone Number',
        overflow: TextOverflow.ellipsis,
      ),
    ),
    Row(
      mainAxisSize: MainAxisSize.min, // Don't expand!
      children: [Icon(Icons.pets), Icon(Icons.pets)],
    ),
  ],
)
```

### Screen Size Breakpoints

Use these breakpoints for responsive design:

| Breakpoint | Width     | Device Type      |
| :--------- | :-------- | :--------------- |
| Mobile     | < 600dp   | Phones           |
| Tablet     | 600-900dp | Small tablets    |
| Desktop    | > 900dp   | Large tablets/PC |

```dart
// Check screen size
if (context.screenWidth < 600) {
  // Mobile layout
} else if (context.screenWidth < 900) {
  // Tablet layout
} else {
  // Desktop layout
}

// Or use ResponsiveBuilder
ResponsiveBuilder(
  mobile: (context) => MobileLayout(),
  tablet: (context) => TabletLayout(),
  desktop: (context) => DesktopLayout(),
)
```

### Third-Party Widget Constraints

Some third-party widgets (like `InternationalPhoneNumberInput`) have internal `Row` widgets that can overflow. When using them:

1. **Wrap in ConstrainedBox** if needed
2. **Test on small screens** (320dp width minimum)
3. **Consider alternatives** if not responsive

### Testing Responsive Layouts

Always test layouts at multiple sizes:

```dart
testWidgets('layout works on small screens', (tester) async {
  // Set small screen size (320dp is minimum supported)
  tester.view.physicalSize = const Size(320, 568);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(MyWidget());
  await tester.pumpAndSettle();

  // Should not throw overflow errors
  expect(tester.takeException(), isNull);
});
```

### Anti-Patterns for Layouts

1. **🔴 Don't** use `Row` without `Flexible`/`Expanded` for text content
2. **🔴 Don't** assume fixed widths for text (fonts can vary)
3. **🔴 Don't** ignore overflow errors in tests - they're real bugs
4. **🔴 Don't** use `mainAxisSize: MainAxisSize.max` for nested Rows
5. **✅ Do** always add `overflow: TextOverflow.ellipsis` to constrained text
6. **✅ Do** test on 320dp width minimum
7. **✅ Do** use `mainAxisSize: MainAxisSize.min` for icon rows

### Accessibility

- **Contrast**: Ensure 4.5:1 ratio.
- **Semantics**: Use `Semantics` widgets where necessary.
- **Scaling**: Test with dynamic text scaling.

---

## 🔐 Security Best Practices

### Secure Storage

- Use `FlutterSecureStorage` for sensitive data (tokens, credentials).
- Never log sensitive information.
- iOS Keychain data persists across reinstalls — use `FreshInstallHandler`.

### Network Security

- Auth tokens are automatically injected via `AuthInterceptor`.
- 401 responses trigger automatic token refresh with `Completer` coordination.
- Failed requests retry with exponential backoff.

---

## 📱 Platform Considerations

### iOS

- Keychain accessibility: `first_unlock_this_device`.
- Handle fresh install scenarios (clear stale keychain data).

### Android

- Encrypted SharedPreferences for secure storage.
- Native Cronet adapter for HTTP/3 support (release mode).

---

## ❌ Anti-Patterns to Avoid

1. **Don't** use `StatefulWidget` for business logic
2. **Don't** call `ref.read` in `build()` — use `ref.watch`
3. **Don't** create custom loading/error widgets
4. **🔴 CRITICAL: Don't** hardcode API paths. **ALWAYS** use `ApiEndpoints` constants:
   - ❌ `await apiClient.post('/auth/login', ...)`
   - ✅ `await apiClient.post(ApiEndpoints.login, ...)`
   - Check `lib/core/constants/api_endpoints.dart` for available endpoints
   - If endpoint doesn't exist, ADD IT to the constants file
   - **Rule**: Every API call must use an `ApiEndpoints` constant
5. **🔴 CRITICAL: Don't** use magic numbers for spacing/dimensions/durations/opacity. **ALWAYS** use constants from `AppConstants`, `AppSpacing`, `ApiEndpoints`, `StorageKeys`, or `Assets`. This includes:
   - Durations: Use `AppConstants.animationNormal` instead of `Duration(milliseconds: 300)`
   - Stagger delays: Use `AppConstants.staggerDelay * N` instead of `Duration(milliseconds: N * 50)`
   - Icon sizes: Use `AppConstants.iconSizeMD` (24px), `iconSizeXL` (48px), `iconSizeXXL` (80px)
   - Dimensions: Use `AppConstants.pageIndicatorActiveWidth` instead of `24`
   - Opacity: Use `AppConstants.pageIndicatorInactiveOpacity` instead of `0.3`
   - Border radius: Use `AppConstants.borderRadiusSM` instead of `4`
   - Spacing: Use `AppSpacing.md` instead of `16`
   - **Rule**: Before submitting, search your code for numeric literals and replace with constants
6. **Don't** store tokens in plain SharedPreferences
7. **Don't** ignore `Result` failures
8. **Don't** use `!` bang operator without checking null first
9. **🔴 CRITICAL: Don't** hardcode ANY user-facing strings in code. **ALL** text must use localization keys from `app_en.arb` and `app_bn.arb`. This includes:
   - Button labels, titles, descriptions
   - Dialog/snackbar messages
   - Placeholder texts, error messages
   - ANY text displayed to users
   - **Rule**: Before submitting code, search for quoted strings and ensure they use `l10n.<key>` instead
10. **🔴 CRITICAL: Don't** track analytics in `build()` methods - use `useOnMount()` hook for `HookConsumerWidget` or `initState()` with `addPostFrameCallback` for `ConsumerStatefulWidget`. Analytics in build() will fire on every rebuild!
11. **Don't** bypass file size limits — refactor immediately if exceeded
12. **Don't** forget try-catch blocks for operations that can fail (especially async operations)
13. **🔴 CRITICAL: Don't** let timers run indefinitely. **ALWAYS** cancel timers when they're no longer needed:
    - Store timer in `useRef<Timer?>` (not useState) to persist across rebuilds without triggering them
    - Cancel existing timer before starting a new one: `timerRef.value?.cancel()`
    - **Zombie Timer Bug**: If a timer keeps running after hitting 0, it will cause infinite rebuilds every second
    - **Pattern**: Use `useEffect` with cleanup function to cancel timer on unmount
    - **Example**: See `_ResendCodeSection` in `otp_verification_page.dart` for correct implementation
14. **Don't** duplicate authentication logic. **ALWAYS** extract shared token handling:
    - Use `_handleAuthResponse()` helper for both login and OTP verification
    - Centralizes token storage, user parsing, and error handling
    - Reduces duplication and ensures consistency across auth methods
    - **Example**: See `auth_repository_remote.dart` for correct DRY pattern
15. **Don't** use inconsistent JSON field naming. **ALWAYS** ensure JSON serialization matches backend:
    - Backend uses snake_case (e.g., `is_email_verified`, `created_at`)
    - Freezed automatically converts with proper `@JsonKey` annotations
    - Apply `fieldRename` at class level for consistency (or manually tag each field)
    - Test with backend to ensure JSON keys match: `json['field_name']` ↔ `fieldName` property
    - **Example**: See `user.dart` for correct Freezed JSON configuration
16. **Do** use `.staggered()` factories for list animations instead of manually calculating delays
