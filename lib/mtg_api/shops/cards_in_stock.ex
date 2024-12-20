defmodule MtgApi.Shops.CardsInStock do
  alias MtgApi.Shops
  alias MtgApi.Shops.CardInStock

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          cards: [CardInStock.t()],
          available: boolean(),
          lowest_price: non_neg_integer(),
          highest_price: non_neg_integer(),
          shops_with_cards_in_stock: [Shops.shop_id()]
        }

  defstruct [
    :cards,
    :available,
    :lowest_price,
    :highest_price,
    :shops_with_cards_in_stock
  ]

  @spec create_from_cards([CardInStock.t()]) :: t()
  def create_from_cards(cards) do
    available_cards = Enum.filter(cards, fn card -> card.pieces_in_stock > 0 end)
    available = not Enum.empty?(available_cards)
    shops_with_cards_in_stock = Enum.map(available_cards, fn card -> card.shop end) |> Enum.uniq()

    prices = Enum.map(cards, fn card -> card.price_czk end)
    {lowest_price, highest_price} = Enum.min_max(prices, fn -> {0, 0} end)

    %__MODULE__{
      cards: cards,
      available: available,
      lowest_price: lowest_price,
      highest_price: highest_price,
      shops_with_cards_in_stock: shops_with_cards_in_stock
    }
  end
end
