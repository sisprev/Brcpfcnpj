defmodule Brcpfcnpj.Changeset do
  @moduledoc """
  Define funções para serem utilizadas em conjunto com a API de changeset do Ecto.
  """

  import Ecto.Changeset, only: [validate_change: 3, get_field: 2]

  @type t :: %{valid?: boolean(), changes: %{atom => term}, errors: [error]}

  @type error :: {atom, error_message}
  @type error_message :: String.t() | {String.t(), Keyword.t()}

  @doc """
  Valida se essa mudação é um cnpj válido.

  ## Options

    * `:message` - A mensagem em caso de erro, o default é "Invalid Cnpj"

  ## Examples

      validate_cnpj(changeset, :cnpj)

  """
  @spec validate_cnpj(Ecto.Changeset.t(), atom, Keyword.t()) :: Ecto.Changeset.t()
  def validate_cnpj(changeset, field, opts \\ []) when is_atom(field) do
    case get_field(changeset, :cnpj) do
      nil ->
        changeset

      __ ->
        validate_change(changeset, field, fn _, value ->
          if Brcpfcnpj.cnpj_valid?(%Cnpj{number: value}),
            do: [],
            else: [{field, {message(opts, "Invalid Cnpj"), []}}]
        end)
    end
  end

  @doc """
  Valida se essa mudação é um cpf válido.

  ## Options

    * `:message` - A mensagem em caso de erro, o default é "Invalid Cpf"

  ## Examples

      validate_cpf(changeset, :cpf)

  """
  @spec validate_cpf(Ecto.Changeset.t(), atom, Keyword.t()) :: Ecto.Changeset.t()
  def validate_cpf(changeset, field, opts \\ []) when is_atom(field) do
    validate_change(changeset, field, fn _, value ->
      if Brcpfcnpj.cpf_valid?(%Cpf{number: value}),
        do: [],
        else: [{field, {message(opts, "Invalid Cpf"), []}}]
    end)
  end

  defp message([message: msg], _), do: msg
  defp message(_, default), do: default
end
