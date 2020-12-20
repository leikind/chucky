defmodule Chucky do
  use Application
  require Logger

  def start(type, _args) do
    children = [%{id: Chucky.Server, start: {Chucky.Server, :start_link, []}}]

    this_node = node()

    case type do
      :normal ->
        Logger.info("OTP application `chucky` is started on #{this_node}")

      {:takeover, old_node} ->
        Logger.info(
          "#{this_node} is taking over #{old_node} and starting OTP application `chucky`"
        )

      {:failover, old_node} ->
        Logger.info("#{old_node} is failing over to #{this_node}")
    end

    Supervisor.start_link(children, strategy: :one_for_one, name: {:global, Chucky.Supervisor})
  end

  def fact, do: Chucky.Server.fact()
end
