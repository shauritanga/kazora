import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/storage/local_storage.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/bookings/presentation/screens/bookings_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/home/presentation/screens/tenant_shell_screen.dart';
import '../../features/landlord/presentation/add_property/screens/add_property_screen.dart';
import '../../features/landlord/presentation/dashboard/screens/landlord_dashboard_screen.dart';
import '../../features/landlord/presentation/edit_property/screens/edit_property_screen.dart';
import '../../features/landlord/presentation/inquiries/screens/inquiries_screen.dart';
import '../../features/landlord/presentation/properties/screens/landlord_properties_screen.dart';
import '../../features/messages/presentation/screens/messages_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/role_selection_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/properties/presentation/screens/property_details_screen.dart';
import '../../features/properties/presentation/screens/properties_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import 'route_names.dart';

const _authFlow = {
  RouteNames.onboarding,
  RouteNames.roleSelection,
  RouteNames.auth,
};

final routerProvider = Provider<GoRouter>((ref) {
  final signedIn = ref.watch(sessionProvider.select((s) => s.isSignedIn));
  return GoRouter(
    initialLocation: RouteNames.onboarding,
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (!signedIn) {
        if (_authFlow.contains(location)) return null;
        return LocalStorage.instance.onboardingDone
            ? RouteNames.auth
            : RouteNames.onboarding;
      }
      if (_authFlow.contains(location)) return RouteNames.home;
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: RouteNames.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const TenantShellScreen(),
      ),
      GoRoute(
        path: RouteNames.properties,
        builder: (context, state) => const PropertiesScreen(),
      ),
      GoRoute(
        path: '${RouteNames.propertyDetails}/:id',
        builder: (context, state) =>
            PropertyDetailsScreen(propertyId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: RouteNames.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: RouteNames.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: RouteNames.messages,
        builder: (context, state) => const MessagesScreen(),
      ),
      GoRoute(
        path: RouteNames.bookings,
        builder: (context, state) => const BookingsScreen(),
      ),
      GoRoute(
        path: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.landlordDashboard,
        builder: (context, state) => const LandlordDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.landlordProperties,
        builder: (context, state) => const LandlordPropertiesScreen(),
      ),
      GoRoute(
        path: RouteNames.addProperty,
        builder: (context, state) => const AddPropertyScreen(),
      ),
      GoRoute(
        path: '${RouteNames.editProperty}/:id',
        builder: (context, state) =>
            EditPropertyScreen(propertyId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: RouteNames.inquiries,
        builder: (context, state) => const InquiriesScreen(),
      ),
    ],
  );
});
