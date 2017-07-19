defmodule Server.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :username
    field :password
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
    |> hash_password()
  end

  @doc """
  Hash password with comeonin
  """
  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Comeonin.Bcrypt.hashpwsalt(pass))
      _ -> changeset
    end
  end
end
