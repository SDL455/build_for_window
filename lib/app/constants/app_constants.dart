/// Application-wide constants for the Admin console.
class AppConstants {
  static const String usersCollection = 'users';
  static const String categoriesCollection = 'categories';
  static const String restaurantsCollection = 'restaurants';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String reviewsCollection = 'reviews';

  static const String roleAdmin = 'admin';
  static const String roleCustomer = 'customer';
  static const String roleMerchant = 'merchant';
  static const String roleRider = 'rider';

  static const String orderPending = 'pending';
  static const String orderAccepted = 'accepted';
  static const String orderPreparing = 'preparing';
  static const String orderReady = 'ready';
  static const String orderPickedUp = 'picked_up';
  static const String orderDelivered = 'delivered';
  static const String orderCancelled = 'cancelled';

  static const String appName = 'FoodPanda Admin';
  static const String boxAuth = 'fp_admin_auth';
  static const String keyUserId = 'admin_id';
  static const String keyIsLoggedIn = 'admin_logged_in';
}
