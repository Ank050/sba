import 'package:convert/convert.dart';

import "board.dart";

class Cluster {
  late final String title;
  late final String ip;
  late final String key;
  late final List<int> _ieee;
  late List<Board> _boards;

  Cluster(this.title, this.ip, this.key, this._ieee, this._boards);

  Cluster.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        ip = json['ip'],
        key = json['key'],
        _ieee = json['ieee'],
        _boards = json['boards'];

  Map<String, dynamic> toJson() =>
      {'title': title, 'ip': ip, 'key': key, 'ieee': _ieee, 'boards': _boards};

  List<Board> get boards {
    return [..._boards];
  }

  String get ieee {
    return hex.encode(_ieee);
  }

  bool condition(int a) {
    if (_ieee[7] == a) {
      return true;
    } else {
      return false;
    }
  }

  void deleteBoard(int i) {
    _boards.removeAt(i);
  }

  void addBoard(Board board) {
    bool boardAlreadyExists =
        _boards.any((existingBoard) => existingBoard.ieee == board.ieee);
    bool isBoardTypeValid = board.type != 0;
    if (!boardAlreadyExists && isBoardTypeValid) {
      _boards.add(board);
    }
  }

  void getBoards(List<int> data) {
    int numb = (data[5] * 10) + data[6];
    for (int i = 0; i < numb; i++) {
      final ieee = '3cc1f606000000${hex.encode([data[10 + (i * 4)]])}';
      if (_boards.indexWhere((e) => e.ieee == ieee) == -1) {
        _boards.add(Board(ieee, [], '', 0));
      }
    }
  }
}
