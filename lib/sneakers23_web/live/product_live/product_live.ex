defmodule Sneakers23Web.ProductLive do
  use Sneakers23Web, :live_view
  import Sneakers23Web.SizesComponent
  def mount(_params, _session = %{"cart_id" => cart_id}, socket) do
    {:ok, products} = Sneakers23.Inventory.get_complete_products()
    socket = assign(socket, :cart_id, cart_id)
    if connected?(socket) do
      subscribe_to_products(products)
    end

    {:ok, assign(socket, :products, products)}
  end

  defp subscribe_to_products(products) do
    Enum.each(products, fn %{id: id} ->
      Phoenix.PubSub.subscribe(Sneakers23.PubSub, "product:#{id}")
    end)
  end

  def handle_info(%{event: "released"}, socket) do
    {:noreply, load_products_from_memory(socket)}
  end

  def handle_info(%{event: "stock_change"}, socket) do
    {:noreply, load_products_from_memory(socket)}
  end

  defp load_products_from_memory(socket) do
    {:ok, products} = Sneakers23.Inventory.get_complete_products()
    assign(socket, :products, products)
  end
end
