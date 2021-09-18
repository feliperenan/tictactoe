defmodule TictactoeWeb.PlayerETS do
  @table_name :players_session

  require Logger

  def new do
    :ets.new(@table_name, [:set, :public, :named_table, read_concurrency: true])
  end

  def find_player(session_uuid) do
    case :ets.lookup(@table_name, :"#{session_uuid}") do
      [{_, token}] ->
        case verify_token(token) do
          {:ok, player_name} ->
            player_name

          error ->
            Logger.info("There is an error verifing a player token. Error #{inspect(error)}")
            nil
        end

      _not_found ->
        nil
    end
  end

  defp verify_token(token) do
    Phoenix.Token.verify(TictactoeWeb.Endpoint, signing_salt(), token, max_age: 806_400)
  end

  def insert_player(player) do
    token = Phoenix.Token.sign(TictactoeWeb.Endpoint, signing_salt(), player.name)
    :ets.insert(@table_name, {:"#{player.uuid}", token})
  end

  defp signing_salt do
    TictactoeWeb.Endpoint.config(:live_view)[:signing_salt] ||
      raise TictactoeWeb.AuthenticationError, message: "missing signing_salt"
  end

  def delete_player(session_uuid) do
    :ets.delete(@table_name, :"#{session_uuid}")
  end
end
