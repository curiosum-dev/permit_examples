defmodule Notes.CommentsTest do
  use Notes.DataCase

  alias Notes.Content.Comments

  describe "comments" do
    alias Notes.Content.Comment

    import Notes.AccountsFixtures, only: [user_scope_fixture: 0]
    import Notes.ContentFixtures
    import Notes.CommentsFixtures

    @invalid_attrs %{title: nil, text: nil}

    test "list_comments/2 returns all comments for a note" do
      scope = user_scope_fixture()
      note = note_fixture(scope)
      other_note = note_fixture(scope, %{name: "other note"})
      comment = comment_fixture(scope, note)
      _other_comment = comment_fixture(scope, other_note)

      assert Comments.list_comments(scope, note.id) == [comment]
    end

    test "get_comment!/2 returns the comment with given id" do
      scope = user_scope_fixture()
      note = note_fixture(scope)
      comment = comment_fixture(scope, note)

      assert Comments.get_comment!(scope, comment.id) == comment
    end

    test "create_comment/2 with valid data creates a comment" do
      scope = user_scope_fixture()
      note = note_fixture(scope)
      valid_attrs = %{title: "some title", text: "some text", note_id: note.id}

      assert {:ok, %Comment{} = comment} = Comments.create_comment(scope, valid_attrs)
      assert comment.title == "some title"
      assert comment.text == "some text"
      assert comment.note_id == note.id
      assert comment.user_id == scope.user.id
    end

    test "create_comment/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(scope, @invalid_attrs)
    end

    test "update_comment/3 with valid data updates the comment" do
      scope = user_scope_fixture()
      note = note_fixture(scope)
      comment = comment_fixture(scope, note)
      update_attrs = %{title: "updated title", text: "updated text"}

      assert {:ok, %Comment{} = comment} = Comments.update_comment(scope, comment, update_attrs)
      assert comment.title == "updated title"
      assert comment.text == "updated text"
    end

    test "update_comment/3 with other user's scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      note = note_fixture(scope)
      comment = comment_fixture(scope, note)

      assert_raise MatchError, fn ->
        Comments.update_comment(other_scope, comment, %{title: "nope"})
      end
    end

    test "update_comment/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      note = note_fixture(scope)
      comment = comment_fixture(scope, note)

      assert {:error, %Ecto.Changeset{}} =
               Comments.update_comment(scope, comment, @invalid_attrs)
    end

    test "delete_comment/2 deletes the comment" do
      scope = user_scope_fixture()
      note = note_fixture(scope)
      comment = comment_fixture(scope, note)

      assert {:ok, %Comment{}} = Comments.delete_comment(scope, comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(scope, comment.id) end
    end

    test "change_comment/2 returns a comment changeset" do
      scope = user_scope_fixture()
      note = note_fixture(scope)
      comment = comment_fixture(scope, note)

      assert %Ecto.Changeset{} = Comments.change_comment(scope, comment)
    end
  end
end
