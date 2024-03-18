public isolated function getComments(CommentFilterRecord filter) returns CommentRecord[] {
    lock {
        CommentRecord[] comments = [];
        if filter.authorId is int && filter.postId is int {
            comments = from CommentRecord comment in commentTable
                where comment.authorId == filter.authorId && comment.postId == filter.postId
                select comment;
        } else if filter.authorId is int {
            comments = from CommentRecord comment in commentTable
                where comment.authorId == filter.authorId
                select comment;
        } else if filter.postId is int {
            comments = from CommentRecord comment in commentTable
                where comment.authorId == filter.postId
                select comment;
        }
        return comments.cloneReadOnly();
    }
}

public isolated function addPost(string title, string content, int authorId) {
    int id = 0;
    lock {
        id = postTable.length() + 1;
    }
    PostRecord post = {
        id: id,
        title: title,
        content: content,
        authorId: authorId
    };
    lock {
        postTable.add(post);
    }
}

public isolated function getPostByAuthorId(int authorId) returns PostRecord? {
    lock {
        PostRecord[] posts = from PostRecord post in postTable
            where post.authorId == authorId
            select post;
        return posts.pop();
    }
}

public isolated function getPostsByAuthorId(int authorId) returns PostRecord[] {
    lock {
        PostRecord[] posts = from PostRecord post in postTable
            where post.authorId == authorId
            select post;
        return posts.cloneReadOnly();
    }
}

public isolated function getPost(int postId) returns PostRecord|error {
    lock {
        if postTable.hasKey(postId) {
            return postTable.get(postId);
        }
        return error("Post not found!");
    }
}

public isolated function getUser(int userId) returns UserRecord|error {
    lock {
        if userTable.hasKey(userId) {
            return userTable.get(userId);
        }
        return error("User not found!");
    }
}

public isolated function getAuthor(int userId) returns UserRecord {
    lock {
        return userTable.get(userId);
    }
}

public isolated function addComment(int postId, string content, int authorId) returns CommentRecord {
    int commentId = 0;
    lock {
        commentId = commentTable.length() + 1;
    }
    CommentRecord comment = {
        id: commentId,
        content: content,
        postId: postId,
        authorId: authorId
    };
    lock {
        commentTable.add(comment);
    }
    return comment;
}
