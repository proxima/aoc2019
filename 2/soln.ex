defmodule Opcodes do
  defp read_input() do
    program = File.read!('input.txt')
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    Stream.zip(Stream.iterate(0, &(&1+1)), program)
    |> Enum.into(%{})
  end

  def operation(program, 1, lhs, rhs, dst), do: {:cont, Map.put(program, dst, Map.get(program, lhs) + Map.get(program, rhs))}
  def operation(program, 2, lhs, rhs, dst), do: {:cont, Map.put(program, dst, Map.get(program, lhs) * Map.get(program, rhs))}
  def operation(program, 99, _lhs, _rhs, _dst), do: {:done, program}

  def cycle(program, instruction_pointer) do
    opcode = program[instruction_pointer]
    lhs = program[instruction_pointer + 1]
    rhs = program[instruction_pointer + 2]
    dst = program[instruction_pointer + 3]

    case operation(program, opcode, lhs, rhs, dst) do
      {:cont, revised_program} -> cycle(revised_program, instruction_pointer + 4)
      {:done, revised_program} -> revised_program
    end
  end

  def part_one() do
    read_input()
    |> Map.put(1, 12)
    |> Map.put(2, 2)
    |> cycle(0)
    |> Map.get(0)
    |> IO.puts()
  end

  def part_two() do
    initial_program = read_input()
    for noun <- 1..99, verb <- 1..99 do
      case initial_program
        |> Map.put(1, noun)
        |> Map.put(2, verb)
        |> cycle(0)
        |> Map.get(0) do
        19690720 -> { noun, verb }
        _ -> nil
      end
    end
    |> Enum.reject(&is_nil/1)
    |> IO.inspect()
  end
end

Opcodes.part_one()
Opcodes.part_two()
