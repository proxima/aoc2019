defmodule Password do
  @doc """
  --- Day 4: Secure Container ---
  You arrive at the Venus fuel depot only to discover it's protected by a password. The Elves had written the password on a sticky note, but someone threw it out.

  However, they do remember a few key facts about the password:

  It is a six-digit number.
  The value is within the range given in your puzzle input.
  Two adjacent digits are the same (like 22 in 122345).
  Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
  Other than the range rule, the following are true:

  111111 meets these criteria (double 11, never decreases).
  223450 does not meet these criteria (decreasing pair of digits 50).
  123789 does not meet these criteria (no double).
  How many different passwords within the range given in your puzzle input meet these criteria?

  Your puzzle input is 372304-847060.
  """
  def increasing?(x, prev) when x < 10 and x <= prev, do: true

  def increasing?(x, prev) do
    lhs = div(x, 10)
    rhs = rem(x, 10)

    case prev >= rhs do
      true -> increasing?(lhs, rhs)
      false -> false
    end
  end

  def increasing?(x), do: increasing?(x, 10)

  def filtered_chunks(start, finish) do
    start..finish
    |> Enum.filter(&increasing?/1)
    |> Enum.map(&Integer.digits(&1))
    |> Enum.map(fn digits ->
      Enum.chunk_by(digits, fn x -> x end)
    end)
    |> Enum.map(fn digits ->
      Enum.map(digits, &length(&1))
    end)
  end

  def part_one(start, finish) do
    filtered_chunks(start, finish)
    |> Enum.count(fn chunk ->
      Enum.any?(chunk, fn x -> x > 1 end)
    end)
    |> IO.puts()
  end

  def part_two(start, finish) do
    filtered_chunks(start, finish)
    |> Enum.count(fn chunk ->
      Enum.member?(chunk, 2)
    end)
    |> IO.puts()
  end
end

Password.part_one(372_304, 847_060)
Password.part_two(372_304, 847_060)
