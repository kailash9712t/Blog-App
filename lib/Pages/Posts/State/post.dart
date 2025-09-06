import 'package:blog/Firebase/firebase.dart';
import 'package:blog/Models/BlogPost/comments.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';

class PostPageState extends ChangeNotifier {
  late String postId;
  Map<String, Comments>? comments = {};
  Logger logs = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: PrettyPrinter(methodCount: 1, colors: true),
  );

  void initialTask(String postId) {
    postId = postId;
  }

  void loadComments(String commentOwnerName, String postId) async {
    try {
      comments =
          await CommentsOperation().loadComments(commentOwnerName, postId);

      if (comments == null) return;
      notifyListeners();
    } catch (error) {
      logs.i("PostPageState.loadComments ${error.toString()}");
    }
  }

  void addComments(Comments comment, String commentOwnerUsername,String postId) async {
    try {
      comments?[comment.commentId] = comment;

      await CommentsOperation().addComment(comment, commentOwnerUsername,postId);
      notifyListeners();
    } catch (error) {
      logs.i("PostPageState.loadComments ${error.toString()}");
    }
  }
}
