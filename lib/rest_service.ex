defmodule RestService do
  use Plug.Router
  require SkinAPI1
  require SkinAPI2

  @weapon_types [
    "CZ75-Auto",
    "Desert Eagle",
    "Dual Berettas",
    "Five-SeveN",
    "Glock-18",
    "P2000",
    "P250",
    "R8 Revolver",
    "Tec-9",
    "USP-S",
    "MAG-7",
    "Nova",
    "Sawed-Off",
    "XM1014",
    "M249",
    "Negev",
    "MAC-10",
    "MP5-SD",
    "MP7",
    "MP9",
    "P90",
    "PP-Bizon",
    "UMP-45",
    "AK-47",
    "AUG",
    "FAMAS",
    "Galil AR",
    "M4A1-S",
    "M4A4",
    "SG 553",
    "SSG 08",
    "AWP",
    "G3SG1",
    "SCAR-20",
    "Zeus x27",
    "M9 Bayonet",
    "Butterfly Knife",
    "Bowie Knife",
    "Classic Knife",
    "Falchion Knife",
    "Flip Knife",
    "Gut Knife",
    "Huntsman Knife",
    "Karambit",
    "Kukri Knife",
    "Navaja Knife",
    "Nomad Knife",
    "Paracord Knife",
    "Shadow Daggers",
    "Skeleton Knife",
    "Stiletto Knife",
    "Survival Knife",
    "Talon Knife",
    "Ursus Knife"
  ]

  plug(:match)
  plug(:dispatch)

  def map_to_html(map, weapon_type) do
    [first | _] = map
    team = first["team"]["name"]

    begining = """
    <!DOCTYPE html>
    <html lang="pl">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Formularz broni</title>
    </head>
    <body>
    <header style="position: fixed; top: 0; left: 0; width: 100%; z-index: 99; background-color:gray; padding: 15px;">
      <h1>Found #{length(map)} skins for #{weapon_type}!!</h1>
      <button onclick="window.location.href=`/home`;">
          Go back to the front
      </button>
      <p>Team: #{team}</p>
    </header>
    <ul style="margin-top: 200px">\n
    """

    map
    |> Enum.map(&record_to_html(&1))
    |> Enum.join("\n")
    |> (&(begining <> &1 <> "\n</ul>\n</body>")).()
  end

  def record_to_html(record) do
    """
    <li>
      <h3> #{record["name"]} </h3>
      <img src='#{record["image"]}' alt='image'/>
      <p>#{String.replace(record["description"], ~r/\\n/, "<br/>")}</i></i></p>
      <p>date added to the game: #{record["date-added"]["text"]} </p>
      <p> Float: #{record["min_float"]} to #{record["max_float"]} </p>
      <p> Possible in: </p>
      <ul>
        <li>StatTrak™: #{if record["stattrak"], do: "✔", else: "❌"}</li>
        <li>Souvenir: #{if record["souvenir"], do: "✔", else: "❌"}</li>
      </ul>
      <br/>
      <button onclick="window.location.href='#{record["inspect"]["link"]}';">
        Look at it in game!
      </button>
    </li>
    """
  end

  def get_skins(conn, weapon_type, number_of_records) do
    if weapon_type not in @weapon_types do
      conn
      |> put_resp_content_type("text/html")
      |> send_resp(404, "<h1>404</h1> \nInvalid weapon type!")
    end

    client1 = SkinAPI1.client()
    client2 = SkinAPI2.client()

    case SkinAPI1.fetch_skins(client1) do
      {:ok, skins} ->
        filtered_skins =
          skins
          |> Enum.filter(fn skin -> skin["weapon"]["name"] == weapon_type end)
          |> Enum.map(
            &Map.drop(&1, [
              "collections",
              "crates",
              "id",
              "rarity",
              "wears",
              "types",
              "legacy_model",
              "paint_index",
              "pattern",
              "weapon",
              "possible",
              "color"
            ])
          )
          |> Enum.slice(1..number_of_records)

        case SkinAPI2.fetch_skins(client2) do
          {:ok, skins2} ->
            skins2 = Jason.decode!(skins2)

            new_skins =
              filtered_skins
              |> Enum.map(fn skin ->
                {_, info} =
                  Enum.find(skins2, fn {_, s} ->
                    s["name"] == skin["name"]
                  end) || {%{}, %{}}

                info =
                  Map.drop(info, [
                    "type",
                    "exterior",
                    "image",
                    "full-name",
                    "weapon",
                    "weapon-catalog",
                    "csgostash-id",
                    "finish",
                    "is-doppler",
                    "finish-catalog",
                    "finish-style",
                    "rarity",
                    "float-caps",
                    "possible"
                  ])

                Map.merge(skin, info)
              end)

            html_content = map_to_html(new_skins, weapon_type)

            conn
            |> put_resp_content_type("text/html")
            |> send_resp(200, html_content)

          {:error, reason} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(
              500,
              Jason.encode!(%{"error" => "Failed to fetch skins", "reason" => reason})
            )
        end

      {:error, reason} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          500,
          Jason.encode!(%{"error" => "Failed to fetch skins", "reason" => reason})
        )
    end
  end

  def sticker_map_to_html(sticker_map, start_index, end_index) do
    begining = """
    <!DOCTYPE html>
    <html lang="pl">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Formularz broni</title>
    </head>
    <body>
    <header style="position: fixed; top: 0; left: 0; width: 100%; z-index: 99; background-color:gray; padding: 15px;">
      <h1>Found #{length(sticker_map)} stickers between #{start_index} and #{end_index} !!</h1>
      <button onclick="window.location.href=`/home`;">
          Go back to the front
      </button>
    </header>
    <ul style="margin-top: 200px">\n
    """

    sticker_map
    |> Enum.map(&sticker_record_to_html(&1))
    |> Enum.join("\n")
    |> (&(begining <> &1 <> "\n</ul>\n</body>")).()
  end

  def sticker_record_to_html(record) do
    """
    <li>
      <h3> #{record["name"]} </h3>
      <img src='#{record["image"]}' alt='image'/>
      <p>Type: #{record["type"]}</p>
    </li>
    """
  end

  def get_stickers(conn, start_index, end_index) do
    if start_index > end_index or end_index > 7984 or start_index < 0 do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        # yes
        418,
        Jason.encode!(%{"error" => "Invalid range"})
      )
    end

    client = SkinAPI1.client()

    case SkinAPI1.fetch_stickers(client) do
      {:ok, stickers} ->
        filtered_stickers =
          stickers
          |> Enum.map(
            &Map.drop(
              &1,
              [
                "id",
                "description",
                "rarity",
                "crates"
              ]
            )
          )
          |> Enum.slice(start_index..end_index)

        conn
        |> put_resp_content_type("text/html")
        |> send_resp(
          200,
          sticker_map_to_html(filtered_stickers, start_index, end_index)
        )

      {:error, reason} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          500,
          Jason.encode!(%{"error" => "Failed to fetch skins", "reason" => reason})
        )
    end
  end

  get "/v1/stickers/:from/:to" do
    case Integer.parse(conn.params["from"]) do
      {start_index, _rest} ->
        case Integer.parse(conn.params["to"]) do
          {end_index, _rest} ->
            get_stickers(conn, start_index, end_index)

          :error ->
            send_resp(conn, 404, "Endpoint Not found")
        end

      :error ->
        send_resp(conn, 404, "Endpoint Not found")
    end
  end

  get "/v1/weapon/:weapon_type/:num" when num in ~w(all) do
    weapon_type = conn.path_params["weapon_type"]

    get_skins(conn, weapon_type, 100)
  end

  get "/v1/weapon/:weapon_type/:num" do
    case Integer.parse(conn.params["num"]) do
      {number_of_records, _rest} ->
        weapon_type = conn.path_params["weapon_type"]

        get_skins(conn, weapon_type, number_of_records)

      :error ->
        send_resp(conn, 404, "Endpoint Not found")
    end
  end

  get "/home" do
    select_options =
      Enum.map(@weapon_types, fn weapon ->
        "<option value=\"#{weapon}\">#{weapon}</option>"
      end)
      |> Enum.join("\n")

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(
      200,
      """
      <!DOCTYPE html>
      <html lang="pl">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Formularz broni</title>
            <script>
              function submitForm() {
                const weaponType = document.getElementById("weapon_type").value;
                const num = document.getElementById("num").value;

                const numParam = num.trim() === "" || isNaN(num) ? "all" : num;

                const url = `/v1/weapon/${weaponType}/${numParam}`;
                window.location.href = url;
              };

              function submitStickerForm() {
                const start_index = document.getElementById("start_index").value;
                const end_index = document.getElementById("end_index").value;

                const start_param = start_index.trim() === "" || isNaN(start_index) ? "10" : start_index;
                const end_param = end_index.trim() === "" || isNaN(end_index) ? String(parseInt(start_param) + 10) : end_index;

                const url = `/v1/stickers/${start_param}/${end_param}`;
                window.location.href = url;
              }
            </script>
      </head>
      <body>
        <h1>Weapon database! =^.^=</h1>
        <h2>Select weapon type and number of record you want to see</h2>
        <form onsubmit="event.preventDefault(); submitForm();">
          <label for="weapon_type">Typ broni:</label>
          <select name="weapon_type" id="weapon_type">
            #{select_options}
          </select>
          <br><br>
          <label for="num">Liczba rekordów:</label>
          <input type="text" id="num" name="num" placeholder="np. 10 lub 'all'"><br><br>

          <input type="submit" value="Wyślij">
        </form>

        <br><hr><br>
        <h2>If you want to look at Stickers instead:</h2>
        <form onsubmit="event.preventDefault(); submitStickerForm();">
          <label for="start_index">Od:</label>
          <input type="text" id="start_index" name="start_index" placeholder="np. 69">
          <label for="end_index">Do:</label>
          <input type="text" id="end_index" name="end_index" placeholder="np. 420">
          <br>
          <input type="submit" value="Wyślij">
        </form>
      </body>
      </html>
      """
    )
  end

  get "/test" do
    response =
      "<img src='https://raw.githubusercontent.com/ByMykel/counter-strike-image-tracker/main/static/panorama/images/econ/default_generated/weapon_cz75a_an_silver_light_png.png' alt='cz silver_light'>"

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, response)
  end

  match _ do
    send_resp(conn, 404, ":(")
  end
end
