defmodule MtgApi.Shops do
  alias MtgApi.Shops.CardsInStock
  alias MtgApi.Shops.CernyRytir
  alias MtgApi.Shops.NajadaGames
  require Logger

  @type shop_id :: :cerny_rytir | :najada_games

  @cache :cards_in_stock
  # 10 minutes
  @cache_expiration 10 * 60 * 1000

  @spec cache_name() :: :atom
  def cache_name(), do: @cache

  @spec find_cards_in_stock(String.t()) :: CardsInStock.t()
  def find_cards_in_stock(card_name) do
    cards =
      case Cachex.exists?(@cache, card_name) do
        {:ok, true} -> Cachex.get!(@cache, card_name)
        {:ok, false} -> find_and_cache(card_name)
      end

    CardsInStock.create_from_cards(cards)
  end

  defp find_and_cache(card_name) do
    Logger.info("Card cache for #{card_name} was missing")

    cards =
      [
        Task.async(fn -> CernyRytir.find_cards_in_stock(card_name) end),
        Task.async(fn -> NajadaGames.find_cards_in_stock(card_name) end)
      ]
      |> Task.await_many(30_000)
      |> Enum.filter(fn cards -> not is_nil(cards) end)
      |> Enum.flat_map(fn cards -> cards end)

    Cachex.put(@cache, card_name, cards, expire: @cache_expiration)

    cards
  end
end
