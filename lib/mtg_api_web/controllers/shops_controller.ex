defmodule MtgApiWeb.ShopsController do
  use MtgApiWeb, :controller

  alias MtgApi.Shops

  def card(conn, %{"name" => card_name}) do
    card_name = String.trim(card_name)
    cards = Shops.find_cards_in_stock(card_name)

    conn
    |> json(cards)
  end
end
