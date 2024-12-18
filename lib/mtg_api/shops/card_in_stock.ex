defmodule MtgApi.Shops.CardInStock do
  @moduledoc """
  Module representing a single card in stock.
  For a given card search, multiple instances can be returned.
  This is due to foils, special prints and cards in various conditions/languages.
  """

  @type shop :: :cerny_rytir | :najada_games

  @type t :: %__MODULE__{
          full_name: String.t(),
          image_url: String.t(),
          price_czk: non_neg_integer(),
          pieces_in_stock: non_neg_integer(),
          shop: shop()
        }

  @derive Jason.Encoder

  defstruct [
    :full_name,
    :image_url,
    :price_czk,
    :pieces_in_stock,
    :shop
  ]
end
