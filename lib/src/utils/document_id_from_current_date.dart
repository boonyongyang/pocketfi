import 'package:uuid/uuid.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
String documentIdFromUuid() => const Uuid().v4();
