defmodule FiftyTwo.Web.AuthView do
  use FiftyTwo.Web, :view

  def render("error.json", %{pointer: pointer, detail: detail}) do
    %{
      errors: [
        %{
          source: %{pointer: pointer},
          detail: detail,
        }
      ]
    }
  end

  def render("login.json", %{user: user, jwt: jwt}) do
    %{
      data: %{
        user: user,
        auth: jwt,
      }
    }
  end
end
