defmodule StorexWeb.BookController do
  use StorexWeb, :controller
  alias Storex.Store
  plug StorexWeb.Plugs.AdminOnly when action in [:new, :create]

  def index(conn, _params) do
    render conn, "index.html", books: Store.list_books()
  end

  def show(conn, %{"id" => book_id}) do
    render conn, "show.html", book: Store.get_book(book_id)
  end

  def new(conn, _params) do
    changeset = Store.change_book()
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{ "book" => book_params }) do
    case Store.create_book(book_params) do
      {:ok, _book} ->
        conn
        |> put_flash(:info, "Book created")
        |> redirect(to: "/")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Please fix the errors below.")
        |> render("new.html", changeset: changeset)
    end
  end
end

