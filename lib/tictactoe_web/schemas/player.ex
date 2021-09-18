defmodule TictactoeWeb.Player do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  schema "player" do
    field :uuid, :binary_id
    field :name, :string
  end

  def changeset(changeset, params \\ %{}) do
    fields = __schema__(:fields)

    changeset
    |> cast(params, fields)
    |> validate_required(fields)
  end
end
