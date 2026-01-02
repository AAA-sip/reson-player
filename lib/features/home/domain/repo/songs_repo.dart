import 'package:reson/features/home/domain/entity/song_entity.dart';

abstract class SongsRepo {
  Future<List<SongEntity>> getSongs();
}
