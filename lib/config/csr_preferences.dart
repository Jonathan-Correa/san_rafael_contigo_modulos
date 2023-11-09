abstract class CsrPreferences {
  const CsrPreferences();

  Future<void> setToken(String token);
  Future<String> getToken();

  Future<void> setIsDarkTheme(bool isDarkTheme);
  Future<bool> getIsDarkTheme();

  Future<void> setRoleId(int? roleId);
  Future<int?> getRoleId();
  Future<String> getRoleName();

  Future<void> setInformedConsent(String documentNumber);
  Future<bool> getInformedConsent(String documentNumber);
  Future<void> deleteInformedConsent(String documentNumber);

  Future<void> deleteAll();
  Future<Map<String, String>> getAll();
}
