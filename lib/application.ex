defmodule RestService.Application do
  use Application
  require Logger

  def start(_type, _args) do
    webserver = {Plug.Cowboy, plug: RestService, scheme: :http, options: [port: 4000]}

    children = [webserver]

    opts = [strategy: :one_for_one, name: RestService.Supervisor]
    Logger.info("Plug now running on http://localhost:4000")

    Supervisor.start_link(children, opts)
  end
end
