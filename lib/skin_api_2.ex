defmodule SkinAPI2 do
  def client do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, "https://raw.githubusercontent.com/qwkdev/csapi"},
      Tesla.Middleware.JSON
    ])
  end

  def fetch_skins(client) do
    case Tesla.get(client, "/main/data2.json") do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body}
      {:ok, %Tesla.Env{status: status}} -> {:error, "HTTP error: #{status}"}
      {:error, reason} -> {:error, reason}
    end
  end
end
