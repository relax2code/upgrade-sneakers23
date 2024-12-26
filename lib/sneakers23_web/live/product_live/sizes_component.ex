defmodule Sneakers23Web.SizesComponent do
  use Phoenix.Component

  def sizes(assigns) do
    ~H"""
    <form class="size-container" action="/cart/add" method="POST">
      <%= for size <- product_size_options(@product) do %>
        <button
          type="submit"
          class={"size-container__entry
              size-container__entry--level-#{size.level}"}
          name="item_id"
          value={"#{size.id}"}
          disabled={size.disabled?}
        >
          {size.text}
        </button>
      <% end %>
    </form>
    """
  end

  def product_size_options(product) do
    product.items
    |> Enum.map(fn item ->
      %{
        text: item.size,
        id: item.id,
        level: availability_to_level(item.available_count),
        disabled?: item.available_count == 0
      }
    end)
  end

  def availability_to_level(count) when count == 0, do: "out"
  def availability_to_level(count) when count < 150, do: "low"
  def availability_to_level(count) when count < 500, do: "medium"
  def availability_to_level(_), do: "high"
end
