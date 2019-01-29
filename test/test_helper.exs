ExUnit.start()

defmodule Schema do
  use Ecto.Schema

  @primary_key false
  schema "schema" do
    field(:cpf)
    field(:cnpj)
  end
end
