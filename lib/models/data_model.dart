import 'package:objectbox/objectbox.dart';

@Entity()
class Vault {
  @Id()
  int id = 0;
  String? singeltonHex;
}

@Entity()
class Pubkey {
  @Id()
  int id = 0;
  String? key;
}
