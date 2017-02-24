defmodule FiftyTwo.Api.ErrorView do
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

  defp render_detail({message, values}) do
    Enum.reduce(values, message, fn {key, val}, acc ->
      String.replace(acc, "%{#{key}}", to_string(val))
    end)
  end
end
