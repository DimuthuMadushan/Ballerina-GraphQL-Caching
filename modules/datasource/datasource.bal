isolated table<UserRecord> key(id) userTable = table [
    {id:1, username: "john", email: "john@gmail.com"},
    {id:2, username: "jane", email: "jane@gmail.com"}
];

isolated table<PostRecord> key(id) postTable = table [
    {id:1, title: "Post 1", content: "Content 1", authorId:1},
    {id:2, title: "Post 2", content: "Content 2", authorId:2}
];

isolated table<CommentRecord> key(id) commentTable = table [
    {id:1, content: "Comment 1", postId: 1, authorId: 1},
    {id:2, content: "Comment 2", postId: 1, authorId: 2},
    {id:3, content: "Comment 3", postId: 2, authorId: 1},
    {id:4, content: "Comment 4", postId: 2, authorId: 2}
];
