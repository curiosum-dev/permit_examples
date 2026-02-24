# Permit.Absinthe Example

A GraphQL API built with Absinthe, Ecto, and Phoenix that demonstrates bearer-token authentication, authorization with Permit, and nested data loading with Dataloader.

## Features

- GraphQL API
- Bearer token authentication
- Fine-grained permission control on queries and mutations
- Dataloader integration
- Entities:
  - `User`: Basic user accounts with authentication tokens
  - `Note`: User-created notes with public/private flags
  - `Comment`: Comments on notes

## Authorization rules

- **Notes**:
  - Browse: Requires authentication, shows own notes + public notes
  - Create: Authenticated users only (auto-assigned to user)
  - Update/Delete: Only your own notes
  
- **Comments**:
  - Browse: Only comments on public notes
  - Create: Only on public notes
  - Update: Only your own comments
  - Delete: Your own comments OR any comments on your notes

## Setup

1. Install dependencies:
   ```bash
   mix deps.get
   ```

2. Create and migrate the database:
   ```bash
   mix ecto.create
   mix ecto.migrate
   ```

3. Seed the database with test data:
   ```bash
   mix run priv/repo/seeds.exs
   ```

4. Start the server:
   ```bash
   mix phx.server
   ```

The API will be available at:
- GraphQL endpoint: `http://localhost:4000/api/graphql`
- GraphiQL interface: `http://localhost:4000/api/graphiql`

## Test Users

After seeding, you'll have three test users with bearer tokens:

- **Alice**: `alice-token-123`
- **Bob**: `bob-token-456`
- **Charlie**: `charlie-token-789`

## Authentication

Include the bearer token in the Authorization header:

```
Authorization: Bearer alice-token-123
```

## GraphQL Examples

### List all notes

```graphql
query {
  notes {
    id
    title
    content
    public
    user {
      name
      email
    }
    comments {
      id
      title
      content
      user {
        name
      }
    }
  }
}
```

### Get a specific note

```graphql
query {
  note(id: 1) {
    id
    title
    content
    public
    user {
      name
    }
  }
}
```

### Create a note (requires authentication)

```graphql
mutation {
  createNote(input: {
    title: "New Note"
    content: "This is my new note content"
    public: true
  }) {
    id
    title
    content
    public
  }
}
```

### Update a note

```graphql
mutation {
  updateNote(id: 1, input: {
    title: "Updated Title"
    content: "Updated content"
  }) {
    id
    title
    content
  }
}
```

### Delete a note

```graphql
mutation {
  deleteNote(id: 1)
}
```

### List all comments

```graphql
query {
  comments {
    id
    title
    content
    user {
      name
    }
    note {
      title
    }
  }
}
```

### Create a comment (requires authentication)

```graphql
mutation {
  createComment(input: {
    noteId: 1
    title: "Great article!"
    content: "I really enjoyed reading this."
  }) {
    id
    title
    content
    note {
      title
    }
  }
}
```

### Update a comment

```graphql
mutation {
  updateComment(id: 1, input: {
    title: "Updated comment title"
    content: "Updated comment content"
  }) {
    id
    title
    content
  }
}
```

### Delete a comment

```graphql
mutation {
  deleteComment(id: 1)
}
```
