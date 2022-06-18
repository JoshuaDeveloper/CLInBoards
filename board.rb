require "json"
require_relative "list"

class Board
  attr_reader :id, :lists, :name

  @@id_count = 0
  def initialize(name:, description:, lists: [], id: nil)
    @id = id || @@id_count.next
    @@id_count = @id
    @name = name
    @description = description
    @lists = lists.map { |list| List.new(**list) }
  end

  def details
    array_list = @lists.map do |list|
      "#{list.name}(#{list.cards.size})"
    end
    [@id, @name, @description, array_list.join(", ")]
  end

  def to_json(_optional)
    JSON.pretty_generate({ id: @id, name: @name, description: @description, lists: @lists })
  end

  def update(name:, description:)
    @name = name unless name.empty?
    @description = description unless description.empty?
  end

  def select_list
    puts "Select a list: "
    names_lists = @lists.map(&:name)
    puts names_lists.join(" | ")
    print "> "
    name_new_list = gets.chomp.split.map(&:capitalize).join(" ")

    @lists.find { |list| list.name == name_new_list }
  end

  def max_card_id
    cards = @lists.map(&:cards).flatten(1)
    return 0 if cards.empty?

    card = cards.max { |a, b| a.id <=> b.id }
    card.id
  end

  def card_case(input, card_id)
    return search_card_for_checklist(card_id) if input == "checklist"

    case input
    when "create-card"
      selected_list = select_list
      max_id = max_card_id
      selected_list.create_card(max_id + 1)
    when "update-card"
      selected_list = select_list
      original_list = find_list_of_card(card_id)

      original_list.delete_card(card_id) unless selected_list.name == original_list.name

      selected_list.update_card(card_id)
    when "delete-card"
      list_for_delete_card = find_list_of_card(card_id)
      list_for_delete_card.delete_card(card_id)
    end
  end

  def find_list_of_card(card_id)
    @lists.each { |list| return list if list.cards.find { |card| card.id == card_id } }
  end

  def search_card_for_checklist(card_id)
    @lists.each do |list|
      break if list.select_card(card_id) == true
    end
  end
end
