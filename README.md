# Ballerina-GraphQL-Server-Side-Caching
A Ballerina GraphQL Example with Server-side Caching.

This example includes a simple GraphQL service that enables server-side caching. It demonstrates how to add the configurations, how to over-write the configurations and cache eviction.

## Configurations
> NOTE: This example runs only on Ballerina versions greater than `2201.8.5`.

Example can be run using following command.
```shell
$ bal run
```

#### GrpahiQL
To access the service via GraphiQL, click the `url` logged in in the terminal.
```shell
GraphiQL client ready at http://localhost:9000/graphiql
```

## GraphQL Schema
```graphql
type Query {
  user(id: ID!): User
  post(id: ID!): Post
  postsByUser(userId: ID!): [Post!]!
}

type User {
  id: ID!
  username: String!
  email: String!
  posts: [Post!]!
}

type Post {
  id: ID!
  title: String!
  content: String!
  author: User!
  comments(filter: CommentFilter! = {}): [Comment!]!
}

type Comment {
  id: Int!
  content: String!
  author: User!
}

input CommentFilter {
  authorId: Int
  postId: Int
}

type Mutation {
  createPost(title: String!, content: String!, authorId: ID!): Post!
  createComment(postId: ID!, content: String!, authorId: ID!): Comment!
}
```


