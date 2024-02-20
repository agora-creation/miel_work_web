import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/services/organization.dart';

enum AuthStatus {
  authenticated,
  uninitialized,
  authenticating,
  unauthenticated,
}

class LoginProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.uninitialized;
  AuthStatus get status => _status;
  final FirebaseAuth? _auth;
  User? _authUser;
  User? get authUser => _authUser;

  final OrganizationService _organizationService = OrganizationService();
  OrganizationModel? _organization;
  OrganizationModel? get organization => _organization;

  LoginProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<String?> login({
    required String loginId,
    required String password,
  }) async {
    String? error;
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final result = await _auth?.signInAnonymously();
      _authUser = result?.user;
      OrganizationModel? tmpOrganization =
          await _organizationService.selectData(
        loginId: loginId,
        password: password,
      );
      if (tmpOrganization != null) {
        _organization = tmpOrganization;
        await setPrefsString('loginId', loginId);
        await setPrefsString('password', password);
      } else {
        await _auth?.signOut();
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        error = 'ログインIDまたはパスワードが間違ってます';
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      error = 'ログインに失敗しました';
    }
    return error;
  }

  Future logout() async {
    await _auth?.signOut();
    _status = AuthStatus.unauthenticated;
    await allRemovePrefs();
    _organization = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future _onStateChanged(User? authUser) async {
    if (authUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _authUser = authUser;
      _status = AuthStatus.authenticated;
      String? loginId = await getPrefsString('loginId');
      String? password = await getPrefsString('password');
      if (loginId != null && password != null) {
        OrganizationModel? tmpOrganization =
            await _organizationService.selectData(
          loginId: loginId,
          password: password,
        );
        if (tmpOrganization != null) {
          _organization = tmpOrganization;
        } else {
          _authUser = null;
          _status = AuthStatus.unauthenticated;
        }
      } else {
        _authUser = null;
        _status = AuthStatus.unauthenticated;
      }
    }
    notifyListeners();
  }
}
