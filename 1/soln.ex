defmodule Fuel do
  defp read_input() do
    {:ok, contents} = File.read('input.txt')

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp fuel_requirement(mass), do: max(floor(div(mass, 3)) - 2, 0)

  # 8 is the last number requiring no additional fuel
  defp cascading_fuel_requirement(mass, sum) when mass <= 8, do: sum
  defp cascading_fuel_requirement(mass, sum) do
    fuel = fuel_requirement(mass)
    cascading_fuel_requirement(fuel, sum + fuel)
  end

  defp cascading_fuel_requirement(mass), do: cascading_fuel_requirement(mass, 0)

  def part_one() do
    Enum.map(read_input(), &fuel_requirement/1)
    |> Enum.sum()
    |> IO.puts
  end

  def part_two() do
    Enum.map(read_input(), &cascading_fuel_requirement/1)
    |> Enum.sum()
    |> IO.puts()
  end
end

Fuel.part_one()
Fuel.part_two()
