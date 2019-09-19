defmodule Api.CardsTest do
  use Api.DataCase

  alias Api.Cards

  describe "cards" do
    alias Api.Cards.Card

    @valid_attrs %{back_media: "some back_media", back_text: "some back_text", front_media: "some front_media", front_text: "some front_text"}
    @update_attrs %{back_media: "some updated back_media", back_text: "some updated back_text", front_media: "some updated front_media", front_text: "some updated front_text"}
    @invalid_attrs %{back_media: nil, back_text: nil, front_media: nil, front_text: nil}

    def card_fixture(attrs \\ %{}) do
      {:ok, card} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Cards.create_card()

      card
    end

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Cards.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Cards.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      assert {:ok, %Card{} = card} = Cards.create_card(@valid_attrs)
      assert card.back_media == "some back_media"
      assert card.back_text == "some back_text"
      assert card.front_media == "some front_media"
      assert card.front_text == "some front_text"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cards.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      assert {:ok, %Card{} = card} = Cards.update_card(card, @update_attrs)
      assert card.back_media == "some updated back_media"
      assert card.back_text == "some updated back_text"
      assert card.front_media == "some updated front_media"
      assert card.front_text == "some updated front_text"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Cards.update_card(card, @invalid_attrs)
      assert card == Cards.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Cards.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Cards.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Cards.change_card(card)
    end
  end
end
