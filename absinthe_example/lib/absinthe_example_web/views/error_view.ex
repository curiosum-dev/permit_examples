defmodule AbsintheExample.ErrorView do
  def render("500.json", assigns) do
    message = extract_error_message(assigns)
    %{errors: [%{message: message}]}
  end

  def render("500.html", assigns) do
    message = extract_error_message(assigns)
    escaped_message = escape_html(message)
    """
    <!DOCTYPE html>
    <html>
    <head>
      <title>Internal Server Error</title>
      <meta charset="utf-8">
    </head>
    <body>
      <h1>Internal Server Error</h1>
      <p>#{escaped_message}</p>
    </body>
    </html>
    """
  end

  def render("404.json", _assigns) do
    %{errors: [%{message: "Not found"}]}
  end

  def render("404.html", _assigns) do
    """
    <!DOCTYPE html>
    <html>
    <head>
      <title>Not Found</title>
      <meta charset="utf-8">
    </head>
    <body>
      <h1>Not Found</h1>
      <p>The requested resource could not be found.</p>
    </body>
    </html>
    """
  end

  def render("403.json", _assigns) do
    %{errors: [%{message: "Forbidden"}]}
  end

  def render("403.html", _assigns) do
    """
    <!DOCTYPE html>
    <html>
    <head>
      <title>Forbidden</title>
      <meta charset="utf-8">
    </head>
    <body>
      <h1>Forbidden</h1>
      <p>You don't have permission to access this resource.</p>
    </body>
    </html>
    """
  end

  def template_not_found(template, _assigns) do
    %{errors: [%{message: Phoenix.Controller.status_message_from_template(template)}]}
  end

  defp extract_error_message(%{reason: %{message: message}}) when is_binary(message) do
    message
  end

  defp extract_error_message(%{reason: reason}) do
    inspect(reason)
  end

  defp extract_error_message(_assigns) do
    "Internal server error"
  end

  defp escape_html(text) when is_binary(text) do
    text
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\"", "&quot;")
    |> String.replace("'", "&#39;")
  end

  defp escape_html(other) do
    escape_html(inspect(other))
  end
end
