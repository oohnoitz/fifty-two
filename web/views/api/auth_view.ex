defmodule FiftyTwo.Api.AuthView do
  use FiftyTwo.Web, :view

  def render("error.json", %{success: success, message: message}) do
    %{
      success: success,
      message: message,
    }
  end

  def render("login.json", %{user: user, jwt: jwt, exp: exp}) do
    %{
      success: true,
      data: %{
        user: user,
        jwt: jwt,
        exp: exp,
      }
    }
  end

  def render("logout.json", %{success: success, message: message}) do
    %{
      success: success,
      message: message,
    }
  end
end
