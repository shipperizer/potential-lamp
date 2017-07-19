defmodule Server.Repo do
  use Ecto.Repo, otp_app: :server

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def init(_, config) do
    config = case Confex.Resolver.resolve(config) do
        {:ok, config} -> config
        {:error, _} -> raise "Config not parseable"
      end

    unless config[:database] do
      raise "Set DB_NAME environment variable!"
    end

    unless config[:username] do
      raise "Set DB_USER environment variable!"
    end

    unless config[:password] do
      raise "Set DB_PASSWORD environment variable!"
    end

    unless config[:hostname] do
      raise "Set DB_HOST environment variable!"
    end

    unless config[:port] do
      raise "Set DB_PORT environment variable!"
    end

    {:ok, config}
  end

  def login(conn, user) do
    conn
    |> Guardian.Plug.api_sign_in(user)
    |> Guardian.Plug.current_token
  end

  def verify_user(conn, username, password) do
    user = Server.User |> Server.Repo.get_by(username: username)
    cond do
      user && checkpw(password, user.password) ->
        {:ok, login(conn, user), conn}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end
end
