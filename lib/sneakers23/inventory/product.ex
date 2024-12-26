defmodule Sneakers23.Inventory.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :sku, :string
    field :order, :integer
    field :brand, :string
    field :name, :string
    field :color, :string
    field :price_usd, :integer
    field :main_image_url, :string
    field :released, :boolean, default: false

    timestamps()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:sku, :order, :brand, :name, :color, :price_usd, :main_image_url, :released])
    |> validate_required([
      :sku,
      :order,
      :brand,
      :name,
      :color,
      :price_usd,
      :main_image_url,
      :released
    ])
  end
end
