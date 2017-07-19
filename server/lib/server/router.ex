defmodule Server.Router do
  @moduledoc """
  Documentation for Server.
  """
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/api/v1/login" do
    conn
    |> send_resp(200, "Nothing here")
    |> halt
  end

  post "/api/v1/login" do
    {:ok, json, conn} = conn |> Plug.Conn.read_body
    data = json |> Poison.Parser.parse!(keys: :atoms!)

    case Map.keys(data) do
      [:password, :username] ->
        nil
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(:bad_request, Poison.encode!(%{message: "Bad Json format"}))
        |> halt
    end

    case Server.Repo.verify_user(conn, data.username, data.password) do
      {:ok, jwt, conn} ->
         conn
         |> put_resp_content_type("application/json")
         |> send_resp(:ok, Poison.encode!(%{jwt: jwt}))
         |> halt
      {:error, :unauthorized, conn} ->
        conn
        |> send_resp(:unauthorized, Poison.encode!(%{message: "Could not login"}))
        |> halt
      {:error, :not_found, conn} ->
        conn
        |> send_resp(:not_found, Poison.encode!(%{message: "User not found"}))
        |> halt
      {_, _, _} ->
        conn
        |> send_resp(:internal_server_error, Poison.encode!(%{message: "Internal Server Error"}))
        |> halt
    end
  end
end
