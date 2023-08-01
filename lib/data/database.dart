import 'dart:async';

import 'package:chart_demo/data/converter/datetime_converter.dart';
import 'package:chart_demo/data/dao/message_dao.dart';
import 'package:chart_demo/data/dao/session_dao.dart';
import 'package:chart_demo/models/message.dart';
import 'package:chart_demo/models/session.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 2, entities: [Message, Session])
@TypeConverters([DateTimeConverter])
abstract class AppDatabase extends FloorDatabase {
  MessageDao get messageDao;
  SessionDao get sessionDao;
}
