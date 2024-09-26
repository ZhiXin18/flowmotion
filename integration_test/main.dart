import 'e2e_unsuccessful_register_test.dart' as failed_registration;
import 'e2e_successful_register_test.dart' as passed_registration;

import 'e2e_unauth_test.dart' as failed_login;
import 'e2e_auth_test.dart' as passed_login;

void main() {
  failed_registration.main();
  passed_registration.main();

  failed_login.main();
  passed_login.main();
}