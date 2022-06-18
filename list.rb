require "json"
require_relative "card"

class List
  attr_reader :id, :name, :cards

  @@id_count = 0
  def initialize(name:, cards: [], id: nil)
    @id = id || @@id_count.next
    @@id_count = @id
    @name = name

    @cards = cards.map { |card| Card.new(**card) }
  end

  def to_json(_optional)
    JSON.pretty_generate({ id: @id, name: @name, cards: @cards })
  end

  def select_card(card_id)
    selected_card = @cards.find { |card| card.id == card_id }
    return false if selected_card.nil?

    selected_card.menu
    true
  end

  def card_form
    print "Title: "
    title = gets.chomp.capitalize
    print "Members: "
    members = gets.chomp.split(", ").map(&:strip)
    print "Labels: "
    labels = gets.chomp.split(", ").map(&:strip)
    print "Due Date: "
    due_date = gets.chomp
    { title:, members:, labels:, due_date: }
  end

  def create_card(card_id)
    card = card_form
    @cards << Card.new(id: card_id, **card)
  end

  def update_card(card_id)
    card_index = find_index_card(card_id)

    card = card_form
    data = Card.new(id: card_id, **card)
    card_index.nil? ? @cards << data : @cards[card_index] = data
  end

  def find_index_card(card_id)
    @cards.index { |card| card.id == card_id }
  end

  def delete_card(card_id)
    card_index = find_index_card(card_id)
    @cards.delete_at(card_index)
  end

  def update(name:)
    @name = name unless name.empty?
  end

  def count_cards; end

  def show_cards; end
end
