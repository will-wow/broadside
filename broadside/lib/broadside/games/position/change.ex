defmodule Broadside.Game.Position.Change do
  alias __MODULE__

  @type change_type :: :velocity | :heading

  @type t :: %Change{
          attribute: change_type,
          direction: -1 | 1
        }

  defstruct [:attribute, :direction]
end
