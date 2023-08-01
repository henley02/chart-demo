import 'package:chart_demo/models/message.dart';
import 'package:floor/floor.dart';

@dao
abstract class MessageDao {
  @Query('SELECT * FROM Message')
  Future<List<Message>> findAllMessages();

  @Query('SELECT * FROM Message WHERE id = :id')
  Future<Message?> findMessageById(String id);

  @Query('SELECT * FROM Message WHERE session_id = :sessionId')
  Stream<Message?> findMessagesBySessionId(int sessionId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertMessage(Message message);

  @delete
  Future<void> deleteMessage(Message message);
}
