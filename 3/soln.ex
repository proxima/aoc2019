defmodule Wires do
  def read_input() do
    File.read!('input.txt')
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ",", trim: true))
  end

  def origin(), do: {0, 0}

  def dir_and_paces(<<direction::utf8, rest::binary>>), do: {direction, String.to_integer(rest)}

  def neighbor({x, y}, ?L), do: {x - 1, y}
  def neighbor({x, y}, ?R), do: {x + 1, y}
  def neighbor({x, y}, ?U), do: {x, y + 1}
  def neighbor({x, y}, ?D), do: {x, y - 1}

  def apply_movement(acc, origin, distance, command) when is_binary(command),
    do: apply_movement(acc, origin, distance, dir_and_paces(command))

  def apply_movement(acc, point, distance, {_, 0}) do
    {MapSet.put(acc, {point, distance}), point, distance}
  end

  def apply_movement(acc, point, distance, {direction, paces}) do
    apply_movement(
      MapSet.put(acc, {point, distance}),
      neighbor(point, direction),
      distance + 1,
      {direction, paces - 1}
    )
  end

  def add_points(acc, _origin, _distance, []), do: acc

  def add_points(acc, origin, distance, [head | rest]) do
    {coords, new_origin, new_distance} = apply_movement(acc, origin, distance, head)
    add_points(coords, new_origin, new_distance, rest)
  end

  def manhattan_distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  def to_coordinates(directions), do: add_points(MapSet.new(), origin(), 0, directions)

  def part_one() do
    [wire1, wire2] =
      read_input()
      |> Enum.map(&to_coordinates/1)

    wire1 = for {point, _} <- wire1, into: MapSet.new(), do: point
    wire2 = for {point, _} <- wire2, into: MapSet.new(), do: point

    MapSet.intersection(wire1, wire2)
    |> Enum.map(fn point ->
      {point, manhattan_distance(point, origin())}
    end)
    |> Enum.sort_by(&elem(&1, 1))
    |> Enum.drop(1)
    |> hd
    |> IO.inspect()
  end

  def part_two() do
    [weighted_wire1, weighted_wire2] =
      read_input()
      |> Enum.map(&to_coordinates/1)
      |> Enum.map(&MapSet.to_list/1)
      |> Enum.map(fn pieces ->
        Enum.sort_by(pieces, &{elem(&1, 0), elem(&1, 1)})
      end)
      |> Enum.map(fn pieces ->
        Enum.dedup_by(pieces, &elem(&1, 0))
      end)

    wire1 = for {point, _} <- weighted_wire1, into: MapSet.new(), do: point
    wire2 = for {point, _} <- weighted_wire2, into: MapSet.new(), do: point
    distances1 = for {point, distance} <- weighted_wire1, into: %{}, do: {point, distance}
    distances2 = for {point, distance} <- weighted_wire2, into: %{}, do: {point, distance}

    best_intersection =
      MapSet.intersection(wire1, wire2)
      |> Enum.sort_by(fn point ->
        Map.get(distances1, point) + Map.get(distances2, point)
      end)
      |> Enum.drop(1)
      |> hd

    IO.puts(
      Map.get(distances1, best_intersection) +
        Map.get(distances2, best_intersection)
    )
  end
end

Wires.part_one()
Wires.part_two()
