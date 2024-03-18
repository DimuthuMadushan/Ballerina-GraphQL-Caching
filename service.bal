import sm_backend.datasource as ds;
import ballerina/graphql;
import ballerina/log;

@graphql:ServiceConfig {
    cacheConfig: {
        enabled: true,
        maxSize: 30,
        maxAge: 120
    },
    maxQueryDepth: 20,
    graphiql: {
        enabled: true
    }
}
service /sm_backend on new graphql:Listener(9000) {
    resource function get user(@graphql:ID int id) returns User? {
        ds:UserRecord|error user = ds:getUser(id);
        if user is ds:UserRecord {
            return new (user);
        }
        return;
    }

    resource function get post(@graphql:ID int id) returns Post? {
        ds:PostRecord|error post = ds:getPost(id);
        if post is ds:PostRecord {
            return new (post);
        }
        return;
    }

    resource function get postsByUser(@graphql:ID int userId) returns Post[] {
        return ds:getPostsByAuthorId(userId).'map(function(ds:PostRecord post) returns Post {
            return new (post);
        });
    }

    remote function createPost(graphql:Context context, string title, string content, @graphql:ID int authorId) returns Post|error {
        error? cache = context.invalidate("user.posts");
        if cache is error {
            log:printInfo(string `Error occured while removing the cache: ${cache.message()}`);
        } else {
            log:printInfo("Cache removed successfully");
        }
        ds:addPost(title, content, authorId);
        ds:PostRecord? post = ds:getPostByAuthorId(authorId);
        if post is () {
            return error graphql:Error("Failed to create the post!");
        }
        return new (post);
    }

    remote function createComment(@graphql:ID int postId, string content, @graphql:ID int authorId) returns Comment|error {
        ds:UserRecord|error user = ds:getUser(authorId);
        ds:PostRecord|error post = ds:getPost(postId);
        if post is ds:PostRecord && user is ds:UserRecord {
            ds:CommentRecord comment = ds:addComment(postId, content, authorId);
            return {
                id: comment.id,
                content: comment.content,
                author: new User(user)
            };
        }
        return error graphql:Error("Failed to create the comment!");
    }
}
