defmodule SkinAPI1 do
  def client do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, "https://bymykel.github.io/CSGO-API/api/en"},
      Tesla.Middleware.JSON
    ])
  end

  def fetch_skins(client) do
    case Tesla.get(client, "/skins.json") do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body}
      {:ok, %Tesla.Env{status: status}} -> {:error, "HTTP error: #{status}"}
      {:error, reason} -> {:error, reason}
    end
  end
end
