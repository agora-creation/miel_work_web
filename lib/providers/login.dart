import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/organization.dart';
import 'package:miel_work_web/services/organization_group.dart';
import 'package:miel_work_web/services/user.dart';

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

  final UserService _userService = UserService();
  final OrganizationService _organizationService = OrganizationService();
  final OrganizationGroupService _groupService = OrganizationGroupService();
  UserModel? _user;
  UserModel? get user => _user;
  OrganizationModel? _organization;
  OrganizationModel? get organization => _organization;
  OrganizationGroupModel? _group;
  OrganizationGroupModel? get group => _group;

  LoginProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    String? error;
    if (email == '') return 'メールアドレスを入力してください';
    if (password == '') return 'パスワードを入力してください';
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final result = await _auth?.signInAnonymously();
      _authUser = result?.user;
      UserModel? tmpUser = await _userService.selectData(
        email: email,
        password: password,
      );
      if (tmpUser != null) {
        OrganizationModel? tmpOrganization =
            await _organizationService.selectData(
          userId: tmpUser.id,
        );
        if (tmpOrganization != null) {
          _user = tmpUser;
          _organization = tmpOrganization;
          OrganizationGroupModel? tmpGroup = await _groupService.selectData(
            organizationId: tmpOrganization.id,
            userId: tmpUser.id,
          );
          if (tmpGroup != null) {
            _group = tmpGroup;
          }
          await setPrefsString('email', email);
          await setPrefsString('password', password);
        } else {
          await _auth?.signOut();
          _status = AuthStatus.unauthenticated;
          notifyListeners();
          error = 'メールアドレスまたはパスワードが間違ってます';
        }
      } else {
        await _auth?.signOut();
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        error = 'メールアドレスまたはパスワードが間違ってます';
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
    _user = null;
    _organization = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future reload() async {
    String? email = await getPrefsString('email');
    String? password = await getPrefsString('password');
    if (email != null && password != null) {
      UserModel? tmpUser = await _userService.selectData(
        email: email,
        password: password,
      );
      if (tmpUser != null) {
        OrganizationModel? tmpOrganization =
            await _organizationService.selectData(
          userId: tmpUser.id,
        );
        if (tmpOrganization != null) {
          _user = tmpUser;
          _organization = tmpOrganization;
          OrganizationGroupModel? tmpGroup = await _groupService.selectData(
            organizationId: tmpOrganization.id,
            userId: tmpUser.id,
          );
          if (tmpGroup != null) {
            _group = tmpGroup;
          }
        }
      }
    }
    notifyListeners();
  }

  Future _onStateChanged(User? authUser) async {
    if (authUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _authUser = authUser;
      _status = AuthStatus.authenticated;
      String? email = await getPrefsString('email');
      String? password = await getPrefsString('password');
      if (email != null && password != null) {
        UserModel? tmpUser = await _userService.selectData(
          email: email,
          password: password,
        );
        if (tmpUser != null) {
          OrganizationModel? tmpOrganization =
              await _organizationService.selectData(
            userId: tmpUser.id,
          );
          if (tmpOrganization != null) {
            _user = tmpUser;
            _organization = tmpOrganization;
            OrganizationGroupModel? tmpGroup = await _groupService.selectData(
              organizationId: tmpOrganization.id,
              userId: tmpUser.id,
            );
            if (tmpGroup != null) {
              _group = tmpGroup;
            }
          } else {
            _authUser = null;
            _status = AuthStatus.unauthenticated;
          }
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
