defmodule Chatter.RegistrationController do
  use Chatter.Web, :controller
  alias Chatter.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end
  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Chatter.Registration.create(changeset, Chatter.Repo) do
      {:ok, changeset} ->
        conn
        |> put_session(:current_user, changeset.id)
        |> put_flash(:info, "Your account was created")
        |> redirect(to: "/message")
      {:error, changeset} ->
        conn
        |> put_flash(:info, "This name already exists")
        |> render("new.html", changeset: changeset)
    end
  end
end
