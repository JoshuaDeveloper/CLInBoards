require "json"
require_relative "board"

class Store
  attr_reader :boards

  def initialize(filename = "store.json")
    @filename = filename
    @boards = load_board
  end

  # Metodos para board
  def find_board(id)
    @boards.find { |board| board.id == id }
  end

  def add_board(board)
    @boards << board
    save
  end

  def update_board(id, data)
    board_found = find_board(id)
    board_found.update(**data)
    save
  end

  def delete_board(id)
    board_found = find_board(id)
    @boards.delete(board_found)
    save
  end

  # * methods to list
  def find_list(board, name)
    board.lists.find { |list| list.name == name }
  end

  def add_list(new_list, id)
    board_list = find_board(id)
    board_list.lists.push(new_list)
    save
  end

  def update_list(name, new_data, board_id)
    board_list = find_board(board_id)
    # p board_list
    list_name = find_list(board_list, name)
    # p list_name
    list_name.update(**new_data)
    save
  end

  def delete_list(name, board_id)
    board_list = find_board(board_id)
    board_list.lists.delete_if { |list| list.name == name }
    save
  end
  # * ------------------------------------------------

  def load_board
    data = JSON.parse(File.read(@filename), { symbolize_names: true })
    data.map { |board_hash| Board.new(**board_hash) }
  end

  def save
    File.write(@filename, @boards.to_json)
  end
end

# store = Store.new("store.json")
# p store.boards