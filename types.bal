import ballerina/graphql;
import sm_backend.datasource as ds;

public distinct isolated service class Post {
    private final readonly & ds:PostRecord post;

    isolated function init(ds:PostRecord postRecord) {
        self.post = postRecord;
    }

    isolated resource function get id() returns @graphql:ID int {
        return self.post.id;
    }

    @graphql:ResourceConfig {
        cacheConfig: {
            maxAge: 60
        }
    }
    isolated resource function get title() returns string {
        return self.post.title;
    }

    isolated resource function get content() returns string {
        return self.post.content;
    }

    isolated resource function get author() returns User|error {
        ds:UserRecord user = check ds:getUser(self.post.authorId);
        return new (user);
    }

    @graphql:ResourceConfig {
        cacheConfig: {
            enabled: false
        }
    }
    isolated resource function get comments(CommentFilter filter = {}) returns Comment[] {
        record {|
            int id;
            string content;
            int authorId;
            int postId;
        |}[] comments = ds:getComments({postId: self.post.id, ...filter});
        return from var comment in comments
            select {
                id: comment.id,
                content: comment.content,
                author: new User(ds:getAuthor(comment.authorId))
            };
    }
}

public distinct isolated service class User {
    private final readonly & ds:UserRecord user;

    isolated function init(ds:UserRecord userRecord) {
        self.user = userRecord;
    }
    isolated resource function get id() returns @graphql:ID int {
        return self.user.id;
    }

    isolated resource function get username() returns string {
        return self.user.username;
    }

    isolated resource function get email() returns string {
        return self.user.email;
    }

    isolated resource function get posts() returns Post[] {
        return ds:getPostsByAuthorId(self.user.id).'map(isolated function(ds:PostRecord post) returns Post => new (post));
    }
}

public type CommentFilter record {|
    int authorId?;
|};

public type Comment record {|
    int id;
    string content;
    User author;
|};
