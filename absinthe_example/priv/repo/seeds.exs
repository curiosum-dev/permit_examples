# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

alias AbsintheExample.Repo
alias AbsintheExample.Accounts.User
alias AbsintheExample.Content.{Note, Comment}

# Clear existing data
Repo.delete_all(Comment)
Repo.delete_all(Note)
Repo.delete_all(User)

# Create users with bearer tokens
user1 =
  Repo.insert!(%User{
    name: "Alice Smith",
    email: "alice@example.com",
    token: "alice-token-123"
  })

user2 =
  Repo.insert!(%User{
    name: "Bob Jones",
    email: "bob@example.com",
    token: "bob-token-456"
  })

user3 =
  Repo.insert!(%User{
    name: "Charlie Brown",
    email: "charlie@example.com",
    token: "charlie-token-789"
  })

# Create notes
note1 =
  Repo.insert!(%Note{
    user_id: user1.id,
    title: "My First Note",
    content: "This is Alice's first note. It's public!",
    public: true
  })

note2 =
  Repo.insert!(%Note{
    user_id: user1.id,
    title: "Private Thoughts",
    content: "This is Alice's private note.",
    public: false
  })

note3 =
  Repo.insert!(%Note{
    user_id: user2.id,
    title: "Bob's Ideas",
    content: "Some brilliant ideas from Bob.",
    public: true
  })

note4 =
  Repo.insert!(%Note{
    user_id: user3.id,
    title: "Shopping List",
    content: "Milk, eggs, bread, coffee.",
    public: false
  })

# Create comments
Repo.insert!(%Comment{
  user_id: user2.id,
  note_id: note1.id,
  title: "Great note!",
  content: "I really enjoyed reading this, Alice!"
})

Repo.insert!(%Comment{
  user_id: user3.id,
  note_id: note1.id,
  title: "Thanks for sharing",
  content: "Very insightful content."
})

Repo.insert!(%Comment{
  user_id: user1.id,
  note_id: note3.id,
  title: "Love it!",
  content: "These are indeed brilliant ideas, Bob!"
})

Repo.insert!(%Comment{
  user_id: user2.id,
  note_id: note3.id,
  title: "Follow up",
  content: "Let me add some more thoughts on this..."
})

IO.puts("Seed data created successfully!")
IO.puts("\nTest Users:")
IO.puts("  Alice: Bearer alice-token-123")
IO.puts("  Bob:   Bearer bob-token-456")
IO.puts("  Charlie: Bearer charlie-token-789")
