import 'package:chart_demo/models/session.dart';
import 'package:floor/floor.dart';

@dao
abstract class SessionDao {
  @Query('SELECT * FROM Session ORDER BY id DESC')
  Future<List<Session>> findAllSessions();

  @Query('SELECT * FROM Session WHERE id = :id')
  Future<Session?> findSessionById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> upsertSession(Session session);

  @delete
  Future<void> deleteSession(Session session);
}
