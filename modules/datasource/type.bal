public type UserRecord readonly & record {|
    int id;
    string username;
    string email;
|};

public type PostRecord readonly & record {|
    int id;
    string title;
    string content;
    int authorId;
|};

public type CommentRecord readonly & record {|
    int id;
    string content;
    int authorId;
    int postId;
|};

public type CommentFilterRecord readonly & record {|
    int authorId?;
    int postId?;
|};

public type CommentType readonly & record {|
    int id;
    string content;
    UserRecord author;
|};
