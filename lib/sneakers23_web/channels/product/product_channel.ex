defmodule Sneakers23Web.ProductChannel do
  use Phoenix.Channel

  def join("product:"<> _sku, %{}, socket) do
    {:ok, socket}
  end

  def notify_product_released(product = %{id: id}) do
    size_html =
      Sneakers23Web.ProductHTML.sizes(%{product: product})
      |> Phoenix.HTML.Safe.to_iodata()
      |> to_string()

    Sneakers23Web.Endpoint.broadcast!("product:#{id}", "released", %{size_html: size_html})

  end

  def notify_item_stock_change(
        previous_item: %{available_count: old},
        current_item: %{available_count: new, id: id, product_id: p_id}
      ) do
    case {
      Sneakers23Web.ProductHTML.availability_to_level(old),
      Sneakers23Web.ProductHTML.availability_to_level(new)
    } do
      {same, same} when same != "out" ->
        {:ok, :no_change}

      {_, new_level} ->
        Sneakers23Web.Endpoint.broadcast!("product:#{p_id}", "stock_change", %{
          product_id: p_id,
          item_id: id,
          level: new_level
        })

        {:ok, :broadcast}
    end
  end

end
