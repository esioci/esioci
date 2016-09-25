defmodule EsioCi.Buildlog do
  require Logger

  @doc """
    This is alternative logger, used to write build log to file.
    'type' => log severity, can be :error, :info, :warn
    'txt'  => text to write
    `file` => log filename
    DateTime is in UTC
    returns `:ok`
  """
  def log(type, txt, file) do
    {:ok, log} = File.open file, [:write]
    datetime = DateTime.utc_now |> DateTime.to_string
    IO.binwrite log, "#{datetime} - #{type} - #{txt}"
    File.close log
    :ok  
  end
  
end