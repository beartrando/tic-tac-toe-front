import 'package:front/src/clients/gateway_client.dart';
import 'package:front/src/contracts/proto/profile.pb.dart';
import 'package:front/src/helpers/parse_proto.dart';
import 'package:logger/logger.dart';

class ProfileClient extends GatewayClient {
  final String jwt;

  ProfileClient(this.jwt, super.config);

  Future<ProfileObject?> getMe() async {
    try {
      final jsonString = await get(
        '/profile/getMe',
        _headers: {'Authorization': 'Bearer ${jwt}'},
      );

      final logger = new Logger();
      logger.d(jsonString);

      return parseProto(() => ProfileResponse(), jsonString).profile;
    } catch (e, st) {
      Logger().e("getProfile failed $e $st");
      return null;
    }
  }

  Future<ProfileObject?> getProfile(String profileId) async {
    try {
      final jsonString = await get(
        '/profile/get?profileId=$profileId',
        _headers: {'Authorization': 'Bearer ${jwt}'},
      );

      final logger = Logger();
      logger.d(jsonString);

      return parseProto(() => ProfileResponse(), jsonString).profile;
    } catch (e, st) {
      Logger().e("getProfile failed $e $st");
      return null;
    }
  }
}
