defmodule ChangesetTest do
  use ExUnit.Case
  import Brcpfcnpj.Changeset
  import Ecto.Changeset, only: [cast: 3]

  defmodule Company do
    use Ecto.Schema

    @primary_key false
    schema "company" do
      field(:cnpj)
    end
  end

  defp changeset(schema \\ %Schema{}, params) do
    cast(schema, params, ~w(cpf cnpj)a)
  end

  test "changeset with invalid cpf" do
    changeset = changeset(%{cpf: "1234"}) |> validate_cpf(:cpf)
    refute changeset.valid?
    %{errors: errors} = changeset
    assert errors[:cpf] == {"Invalid Cpf", []}
  end

  test "changeset with valid cpf" do
    changeset = changeset(%{cpf: Brcpfcnpj.cpf_generate()}) |> validate_cpf(:cpf)
    assert changeset.valid?
  end

  test "changeset with invalid cnpj" do
    changeset = changeset(%{cnpj: "1234"}) |> validate_cnpj(:cnpj)
    refute changeset.valid?
    %{errors: errors} = changeset
    assert errors[:cnpj] == {"Invalid Cnpj", []}
  end

  test "changeset with valid cnpj" do
    changeset = changeset(%{cnpj: Brcpfcnpj.cnpj_generate()}) |> validate_cnpj(:cnpj)
    assert changeset.valid?
  end

  test "custom error message" do
    changeset =
      changeset(%{cnpj: "1234", cpf: "123"})
      |> validate_cnpj(:cnpj, message: "Cnpj Inválido")
      |> validate_cpf(:cpf, message: "Cpf Inválido")

    %{errors: errors} = changeset
    assert errors[:cnpj] == {"Cnpj Inválido", []}
    assert errors[:cpf] == {"Cpf Inválido", []}
  end
end
