defmodule FiftyTwo.Abilities do
  alias FiftyTwo.{Challenge, Game, User}

  defimpl Canada.Can, for: User do
    # Only allow users to modify their own data
    def can?(%User{id: id}, _, %User{id: id}), do: true
    def can?(%User{}, action, %User{}) when action in [:show], do: true
    def can?(%User{}, action, User) when action in [:new, :create], do: true

    # Only allow users to modify challenges they own
    def can?(%User{id: user_id}, _, %Challenge{user_id: user_id}), do: true
    def can?(%User{}, action, %Challenge{}) when action in [:show], do: true
    def can?(%User{}, action, Challenge) when action in [:new, :create], do: true

    # Only allow users to modify games they own
    def can?(%User{id: user_id}, _, %Game{challenge: challenge}), do: user_id == challenge.user_id
    def can?(%User{}, action, %Game{}) when action in [:show], do: true
    def can?(%User{}, action, Game) when action in [:new, :create], do: true

    # Fallback
    def can?(%User{}, _, resource) when resource in [nil, []], do: true
    def can?(%User{}, _, _), do: false
  end

  defimpl Canada.Can, for: Atom do
    def can?(nil, action, %User{}) when action in [:show], do: true
    def can?(nil, action, User) when action in [:new, :create], do: true
    def can?(nil, action, %Challenge{}) when action in [:show], do: true
    def can?(nil, action, %Game{}) when action in [:show], do: true

    def can?(nil, _, resource) when resource in [nil, []], do: true
    def can?(nil, _, _), do: false
  end
end
