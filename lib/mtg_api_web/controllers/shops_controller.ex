defmodule MtgApiWeb.ShopsController do
  use MtgApiWeb, :controller

  alias MtgApi.Shops.CernyRytir

  def card(conn, %{"name" => card_name}) do
    card_name = String.trim(card_name)

    cards =
      [
        Task.async(fn -> CernyRytir.cards_in_stock(card_name) end)
      ]
      |> Task.await_many(30_000)
      |> Enum.filter(fn cards -> not is_nil(cards) end)
      |> Enum.flat_map(fn cards -> cards end)

    conn
    |> json(cards)
  end
end
