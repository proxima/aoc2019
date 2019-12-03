defmodule Wires do
  def read_input() do
    File.read!('input.txt')
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ",", trim: true))
  end

  def dir_and_paces(<<direction::utf8, rest::binary>>), do: {direction, String.to_integer(rest)}

  def apply_movement(acc, origin, command) when is_binary(command), do: apply_movement(acc, origin, dir_and_paces(command))
  def apply_movement(acc, origin, {_, 0}), do: { acc, origin }
  def apply_movement(acc, {x, y}, {?L, paces}), do: apply_movement(MapSet.put(acc, {x, y}), {x - 1, y}, {?L, paces - 1})
  def apply_movement(acc, {x, y}, {?R, paces}), do: apply_movement(MapSet.put(acc, {x, y}), {x + 1, y}, {?R, paces - 1})
  def apply_movement(acc, {x, y}, {?U, paces}), do: apply_movement(MapSet.put(acc, {x, y}), {x, y + 1}, {?U, paces - 1})
  def apply_movement(acc, {x, y}, {?D, paces}), do: apply_movement(MapSet.put(acc, {x, y}), {x, y - 1}, {?D, paces - 1})

  def add_points(acc, _origin, []), do: acc
  def add_points(acc, origin, [ head | rest ]) do
    { coords, new_origin } = apply_movement(acc, origin, head)
    add_points(coords, new_origin, rest)
  end

  def to_coordinates(directions), do: add_points(MapSet.new, {0, 0}, directions)

  def part_one() do
    read_input()
    |> Enum.map(&to_coordinates/1)
    |> IO.inspect()
  end
end

Wires.part_one()
