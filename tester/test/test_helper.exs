ExUnit.start()

defmodule Cmd do
  def run(args) do
    File.cwd!()
    |> Path.join("../bin/tunel")
    |> Path.expand()
    |> System.cmd(args, stderr_to_stdout: true)
  end

  def track(args, tracker) do
    Process.flag(:trap_exit, true)

    path =
      File.cwd!()
      |> Path.join("../bin/tunel")
      |> Path.expand()

    Port.open({:spawn_executable, path}, [:binary, args: args])
    |> loop("", tracker)
  end

  defp loop(port, stdout, tracker) do
    receive do
      {^port, {:data, data}} ->
        stdout = IO.iodata_to_binary([stdout, data])

        with data <- tracker.(port, stdout), false <- is_nil(data) do
          Port.command(port, data)
        end

        loop(port, stdout, tracker)

      {:EXIT, ^port, :normal} ->
        {stdout, 0}

      {:EXIT, ^port, _reason} ->
        {stdout, 1}
    end
  end
end
