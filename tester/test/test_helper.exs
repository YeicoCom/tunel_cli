ExUnit.start()

defmodule T do
  def run(args) do
    IO.inspect args
    File.cwd!()
    |> Path.join("../bin/tunel")
    |> Path.expand()
    |> System.cmd(args, stderr_to_stdout: true)
  end

  def while(secs, done) do
    with {:dl, false} <- {:dl, secs <= 0},
         {:done, false} <- {:done, done.()} do
      Process.sleep(1000)
      while(secs - 1, done)
    else
      {:done, _} -> true
      {:dl, _} -> false
    end
  end

  def props(file) do
    File.read!(file)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line = String.trim(line)
      [key, value] = String.split(line, "=", parts: 2)
      {key |> String.downcase() |> String.to_atom(), value |> String.trim()}
    end)
    |> Enum.into(%{})
  end
end
