defmodule TesterTest do
  use ExUnit.Case

  @dir System.user_home!() |> Path.join(".tunelmx")

  defp test_setup_first(actions) do
    for action <- actions do
      {stdout, code} = T.run([action])
      assert stdout == "Panic: Setup first\n"
      assert code == 1
    end
  end

  defp test_not_logged_in(actions) do
    for action <- actions do
      {stdout, code} = T.run([action])
      assert stdout == "Panic: Not logged in\n"
      assert code == 1
    end
  end

  # ssh builder.quick -L 5002:localhost:5002
  defp test_login() do
    {secret, 0} = System.cmd("curl", ["-s", "http://localhost:5002/api/test/login/test@tunel.mx"])
    File.write("#{@dir}/email", "test@tunel.mx")
    File.write("#{@dir}/session", secret)
    {stdout, code} = T.run(["login", "test@tunel.mx"])
    assert stdout =~ "Login success\n"
    assert code == 0
  end

  test "tunel happy path" do
    {stdout, code} = T.run(["wxyz"])
    assert stdout =~ "Panic: Invalid action wxyz"
    assert code == 1

    {stdout, code} = T.run(["help"])
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

    {stdout, code} = T.run(["update"])
    assert stdout =~ "asdf uninstall tunel_cli main"
    assert stdout =~ "asdf plugin update tunel_cli"
    assert stdout =~ "asdf install tunel_cli main"
    assert code == 0

    {stdout, code} = T.run(["setup"])
    assert stdout =~ "\nok\n"
    assert stdout |> String.ends_with?("\nok\n")
    assert code == 0

    test_login()

    {stdout, code} = T.run(["purge"])
    assert stdout =~ "\nok\n"
    assert stdout |> String.ends_with?("\nok\n")
    assert code == 0

    #################################################################
    # CLEAN STATE
    #################################################################

    # setup test
    {stdout, code} = T.run(["setup"])
    assert stdout =~ "\nok\n"
    assert stdout |> String.ends_with?("\nok\n")
    assert code == 0
    assert File.exists?("#{@dir}/host.uuid")
    assert File.exists?("#{@dir}/host.id")

    test_login()

    # purge a clean state
    {stdout, code} = T.run(["purge"])
    assert stdout =~ "\nCurrent session: test@tunel.mx\n"
    assert stdout =~ "\nPanic: Server not found\n"
    assert stdout =~ "\nPanic: Client not found\n"
    assert stdout |> String.ends_with?("\nok\n")
    assert code == 0
    refute File.exists?(@dir)
    {stdout, 0} = System.cmd("sudo", ["wg"])
    refute String.contains?(stdout, "server_tmx")
    # refute String.contains?(stdout, "client_tmx")

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

    {stdout, code} = T.run(["setup"])
    assert stdout =~ "\nok\n"
    assert stdout |> String.ends_with?("\nok\n")
    assert code == 0

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

    test_login()

    {stdout, code} = T.run(["register"])
    assert stdout =~ "Current session: test@tunel.mx\n"
    assert stdout =~ "\nok\n"
    assert stdout |> String.ends_with?("\nok\n")
    assert code == 0
    assert File.exists?("#{@dir}/server.props")
    assert File.read!("#{@dir}/server.link") =~ "enabled"

    assert T.while(10, fn ->
      File.exists?("#{@dir}/server_tmx.conf")
    end)

    assert T.while(10, fn ->
             {stdout, 0} = System.cmd("sudo", ["wg"])
             String.contains?(stdout, "server_tmx")
           end)

    {stdout, code} = T.run(["config", "TestServer", "172.24.9"])
    assert stdout =~ "Current session: test@tunel.mx\n"
    assert stdout =~ "\nok\n"
    assert code == 0

    serid = T.props("#{@dir}/server.props").serid
    {stdout, code} = T.run(["list"])
    assert stdout =~ "Current session: test@tunel.mx\n"
    assert stdout =~ "\n>#{serid}\t"
    assert stdout =~ "\tTestServer\t"
    assert code == 0

    uuid1 = File.read! ("#{@dir}/host.uuid")
    {uuid2, 0} = System.cmd("uuidgen", [])
    File.write!("#{@dir}/host.uuid", uuid2)

    {stdout, code} = T.run(["start", "#{serid}"])
    assert stdout =~ "Current session: test@tunel.mx\n"
    assert stdout =~ "\nok\n"
    assert stdout |> String.ends_with?("\nok\n")
    assert code == 0
    assert File.exists?("#{@dir}/client.props")
    assert File.read!("#{@dir}/client.link") =~ "enabled"

    assert T.while(10, fn ->
      File.exists?("#{@dir}/client_tmx.conf")
    end)

    assert T.while(10, fn ->
            {stdout, 0} = System.cmd("sudo", ["wg"])
            String.contains?(stdout, "client_tmx")
          end)

    {stdout, code} = T.run(["stop"])
    assert stdout =~ "Current session: test@tunel.mx\n"
    assert stdout =~ "\nok\n"
    assert code == 0
    {stdout, 0} = System.cmd("sudo", ["wg"])
    refute String.contains?(stdout, "client_tmx")

    File.write!("#{@dir}/host.uuid", uuid1)
    {stdout, code} = T.run(["remove"])
    assert stdout =~ "Current session: test@tunel.mx\n"
    assert stdout =~ "\nok\n"
    assert code == 0
    {stdout, 0} = System.cmd("sudo", ["wg"])
    refute String.contains?(stdout, "server_tmx")

    {stdout, code} = T.run(["logout"])
    assert stdout =~ "Logout success\n"
    assert code == 0

    test_login()
    {stdout, code} = T.run(["purge"])
    assert stdout =~ "\nCurrent session: test@tunel.mx\n"
    assert stdout =~ "\nPanic: Server not found\n"
    assert stdout =~ "\nPanic: Client not found\n"
    assert stdout |> String.ends_with?("\nok\n")
    assert code == 0
    refute File.exists?(@dir)
  end
end
