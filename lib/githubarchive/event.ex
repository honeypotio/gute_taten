defmodule Githubarchive.Event do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "events" do
    field :type, :string
    field :public, :boolean
    field :payload, :map
    field :repo, :map
    field :actor, :map
    field :org, :map
    field :created_at, :utc_datetime
    field :id, :string
    field :other, :map

    timestamps
  end
end
