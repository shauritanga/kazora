enum UserRole {
  tenant('tenant'),
  landlord('landlord'),
  admin('admin');

  const UserRole(this.value);

  final String value;

  static UserRole fromString(String? value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.tenant,
    );
  }
}
