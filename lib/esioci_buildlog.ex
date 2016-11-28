defmodule EsioCi.Buildlog do
  @moduledoc """
  Alternative logger
  """
  require Logger

  @doc """
    This is alternative logger, used to write build log to file.
    
    `type` => log severity, can be :error, :info, :warn

    `txt`  => text to write

    `file` => log filename

    DateTime is in UTC

    Returns `:ok`
  """
  def log(type, txt, file) do
    {:ok, log} = File.open file, [:append]
    datetime = DateTime.utc_now |> DateTime.to_string
    IO.binwrite log, "#{datetime} - #{type} - #{txt} \n"
    File.close log
    :ok  
  end
  
end