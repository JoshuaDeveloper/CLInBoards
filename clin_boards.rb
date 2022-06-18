require "json"
require "terminal-table"

require_relative "list"
require_relative "store"
require_relative "board"
require_relative "utils/utilities"

class ClinBoards
  include Utilities

  def initialize
    @store = Store.new("store.json")
  end

  def welcome_message
    puts "#" * 36
    puts "##{' ' * 6}Welcome to CLIn Boards#{' ' * 6}#"
    puts "#" * 36
  end

  def goodbye_message
    puts "#" * 36
    puts "##{' ' * 3}Thanks for using CLIn Boards#{' ' * 3}#"
    puts "#" * 36
  end

  # * Detecting if a list option or card option
  def list_or_card(board, input, id)
    regexp_card = /.*card|checklist/
    regexp_list = /.*list/

    if input.match(regexp_card)
      board.card_case(input, id.to_i)
    elsif input.match(regexp_list)
      option_list(board, input, id)
    end
  end

  # * show a list, then another list, ....list, ...list, Nlist
  def show_list_per_list(lists)
    lists.each do |list|
      print_table(lists: list.cards, title: list.name,
                  headings: %w[ID Title Members Labels Due_Date Checklist])
    end
  end

  def board_form
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp
    { name:, description: }
  end

  def create_board
    board_hash = board_form

    new_board = Board.new(**board_hash)
    @store.add_board(new_board)
  end

  def input_for_lits_or_card
    input = gets.chomp.split
    option = input.slice!(0)
    name = input.map(&:capitalize).join(" ")

    [option, name]
  end

  def show_board(id)
    board = @store.find_board(id)
    input = ""
    until input == "back"
      show_list_per_list(board.lists)
      list_options = ["create-list", "update-list LISTNAME", "delete-list LISTNAME"]
      card_options = ["create-card", "checklist ID", "update-card ID", "delete-card ID"]
      puts "List options: #{list_options.join(' | ')}"
      puts "Card options: #{card_options.join(' | ')}"
      puts "back"
      print "> "
      input, id = input_for_lits_or_card

      list_or_card(board, input, id)
      @store.save
    end
  end

  def update_board(id)
    board_hash = board_form
    @store.update_board(id, board_hash)
  end

  def delete_board(id)
    @store.delete_board(id)
  end

  # * Methods for list
  def option_list(board, input, id)
    case input
    when "create-list" then create_list(board)
    when "update-list" then update_list(id, board)
    when "delete-list" then delete_list(id, board)
    else
      puts "inavalid action"
    end
  end

  def form_list
    print "name: "
    name = gets.chomp.split.map(&:capitalize).join(" ")
    { name: }
  end

  def create_list(board)
    hash_list = form_list
    new_list = List.new(**hash_list)
    @store.add_list(new_list, board.id)
  end

  def update_list(name, board)
    list_data = form_list
    @store.update_list(name, list_data, board.id)
  end

  def delete_list(name, board)
    @store.delete_list(name, board.id)
  end
  # * ---------------------------------------------

  def start
    welcome_message
    action = ""
    until action == "exit"
      print_table(lists: @store.boards, title: "CLIn Boards  ",
                  headings: ["ID", "List", "Description", "List(#cards)"])
      options = ["create", "show ID", "update ID", "delete ID", "exit"]
      action, id = choose_option(options)
      case action
      when "create" then create_board
      when "show" then show_board(id)
      when "update" then update_board(id)
      when "delete" then delete_board(id)
      when "exit" then goodbye_message
      else
        puts "Invalid action"
      end
    end
  end
end

# get the command-line arguments if neccesary
# filename = ARGV.shift

