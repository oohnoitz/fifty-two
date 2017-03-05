defmodule FiftyTwo.Web.ErrorView do
  use FiftyTwo.Web, :view

  def render("changeset.json", %{changeset: changeset}) do
    errors = Enum.map(changeset.errors, fn {field, error} ->
      %{
        source: %{pointer: "/data/attributes/#{field}"},
        detail: render_detail(error),
      }
    end)

    %{errors: errors}
  end

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end

  defp render_detail({message, values}) do
    Enum.reduce(values, message, fn {key, val}, acc ->
      String.replace(acc, "%{#{key}}", to_string(val))
    end)
  end
end
