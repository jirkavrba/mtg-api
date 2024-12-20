defmodule MtgApi.Shops.NajadaGames do
  @moduledoc """
  Module implementing card search for najada.games
  """
  alias MtgApi.Shops.CardInStock
  require Logger

  @shop_domain "https://najada.game"
  @search_url "https://najada.games/api/v1/najada2/catalog/mtg-singles/"

  @spec find_cards_in_stock(String.t()) :: [CardInStock.t()]
  def find_cards_in_stock(card_name) do
    Logger.info("Searching for #{card_name} availability on #{@shop_domain}")

    query = %{
      q: card_name,
      o: "-price",
      in_stock: false,
      offset: 0,
      limit: 100,
      article_price_min: 0,
      article_price_max: 100_000_000
    }

    with {:ok, response} <- Req.get(@search_url, params: query) do
      cards =
        response.body
        |> Map.get("results", [])
        |> Enum.flat_map(fn result ->
          full_name = result["name"]
          image_url = result["image_url"]

          result["articles"]
          |> Enum.map(fn article ->
            pieces_in_stock = article["total_availability"]
            price_czk = article["effective_price_czk"] |> round()

            %CardInStock{
              full_name: full_name,
              image_url: image_url,
              pieces_in_stock: pieces_in_stock,
              price_czk: price_czk,
              shop: :najada_games
            }
          end)
        end)

      Logger.info("Found #{length(cards)} different variants of #{card_name} on #{@shop_domain}")

      cards
    end
  end
end
