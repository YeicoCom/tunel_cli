defmodule TesterTest do
  use ExUnit.Case

  @dir System.user_home!() |> Path.join(".tunelmx")

  defp test_setup_first(actions) do
    for action <- actions do
      {stdout, code} = Cmd.run([action])
      assert stdout == "Panic: Setup first\n"
      assert code == 1
    end
  end

  defp test_not_logged_in(actions) do
    for action <- actions do
      {stdout, code} = Cmd.run([action])
      assert stdout == "Panic: Not logged in\n"
      assert code == 1
    end
  end

  test "tunel happy path" do
    {stdout, code} = Cmd.run(["wxyz"])
    assert stdout =~ "Panic: Invalid action wxyz"
    assert code == 1

    {stdout, code} = Cmd.run(["help"])
    assert stdout =~ "    help"
    assert stdout =~ "    update | bash"
    assert stdout =~ "    setup"
    assert stdout =~ "    purge"
    assert stdout =~ "    login <email>"
    assert stdout =~ "    logout"
    assert stdout =~ "    list"
    assert stdout =~ "    register"
    assert stdout =~ "    config <name> <network>"
    assert stdout =~ "    remove"
    assert stdout =~ "    start <server_id>"
    assert stdout =~ "    stop"
    assert stdout =~ "    status <client|server>"
    assert code == 0

    {stdout, code} = Cmd.run(["update"])
    assert stdout =~ "asdf uninstall tunel_cli main"
    assert stdout =~ "asdf plugin update tunel_cli"
    assert stdout =~ "asdf install tunel_cli main"
    assert code == 0

    {stdout, code} = Cmd.run(["setup"])
    assert stdout |> String.ends_with?("\nok\n")
    assert code == 0

    # get secret over ssh with api responding to localhost only
    # {stdout, code} = Cmd.run(["login", "samuel.ventura@yeico.com"])
    # assert stdout =~ "ok\n"
    # assert code == 0
    IO.puts("Press enter after login...")
    IO.read(:stdio, :line)

    {stdout, code} = Cmd.run(["purge"])
    assert stdout == "ok\n"
    assert code == 0
    refute File.exists?(@dir)

    test_setup_first([
      "login",
      "logout",
      "status",
      "list",
      "register",
      "config",
      "remove",
      "start",
      "stop"
    ])

    {stdout, code} = Cmd.run(["setup"])
    assert stdout =~ "\nok\n"
    assert stdout |> String.ends_with?("\nok\n")
    assert code == 0
    assert File.exists?(@dir)

    test_not_logged_in([
      "logout",
      "status",
      "list",
      "register",
      "config",
      "remove",
      "start",
      "stop"
    ])
  end
end
