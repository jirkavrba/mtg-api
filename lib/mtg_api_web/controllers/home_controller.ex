defmodule MtgApiWeb.HomeController do
  use MtgApiWeb, :controller

  def index(conn, _params) do
    redirect(conn, external: "https://github.com/jirkavrba/mtg-api")
  end

  def options(conn, _params) do
    conn |> text("You shall (not) pass")
  end
end
