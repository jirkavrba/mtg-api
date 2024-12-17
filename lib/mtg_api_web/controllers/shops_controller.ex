defmodule MtgApiWeb.ShopsController do
  use MtgApiWeb, :controller

  def card(conn, _params) do
    conn
    |> json(%{"result" => true})
  end
end
