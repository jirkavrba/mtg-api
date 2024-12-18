defmodule MtgApi.Shops.CernyRytir do
  @moduledoc """
  Module implementing card search for cernyrytir.cz via web scraping.
  Luckily, this shop has not changed its website design since 2008.
  """
  alias MtgApi.Shops.CardInStock

  @shop_domain "https://cernyrytir.cz"
  @search_url "https://cernyrytir.cz/index.php3?akce=3"

  @spec find_cards_in_stock(String.t()) :: [CardInStock.t()]
  def find_cards_in_stock(card_name) do
    form = %{
      edice_magic: "libovolna",
      rarita: "A",
      foil: "A",
      jmenokarty: card_name,
      triditpodle: "ceny",
      submit: "Vyhledej"
    }

    with {:ok, response} <- Req.post(@search_url, form: form),
         {:ok, document} <- Floki.parse_document(response.body) do
      # The page is designed in such a way, that each card info is split across 3 table rows with no parent
      # Peak webdesign at its finest
      table_rows =
        document
        |> Floki.find("table.kusovkytext")
        |> Enum.drop(1)
        |> List.first()
        |> Floki.find("tr")

      cards =
        table_rows
        |> Enum.chunk_every(3, 3, :discard)
        |> Enum.map(fn [top, _, bottom] ->
          full_name =
            Floki.find(top, "td:nth-child(2) > div > font") |> Floki.text()

          [image_url] =
            Floki.find(top, "td:nth-child(1) > a.highslide") |> Floki.attribute("href")

          pieces_in_stock =
            Floki.find(bottom, "td:nth-child(2)")
            |> Floki.text()
            |> String.replace(~r/[^0-9]/, "")
            |> String.to_integer()

          price_czk =
            Floki.find(bottom, "td:nth-child(3)")
            |> Floki.text()
            |> String.replace(~r/[^0-9]/, "")
            |> String.to_integer()

          %CardInStock{
            full_name: full_name,
            image_url: @shop_domain <> image_url,
            pieces_in_stock: pieces_in_stock,
            price_czk: price_czk,
            shop: :cerny_rytir
          }
        end)

      cards
    else
      _ -> []
    end
  end
end
