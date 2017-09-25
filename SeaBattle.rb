
FIELD_SIZE = 10                        # size of game field
SHIPS = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1] # array of ship's lengths

# game field
class Battlefield
  # initialize field by size
  def initialize
    @ships = []
    @battle_field = Array.new(FIELD_SIZE) { |x| Array.new(FIELD_SIZE) { |y| Cell.new(self, x, y) } }
  end

  # get field cell by coordinates
  # return nil if coordinates are out of field
  def [](x, y)
    return nil unless (0...FIELD_SIZE).cover?(x)
    return nil unless (0...FIELD_SIZE).cover?(y)
    @battle_field[x][y]
  end

  # get free horizontal and vertical field pieses
  def free_fields
    free_pieses(@battle_field) + free_pieses(@battle_field.transpose)
  end

  # puts ship on random place
  def put_ship(ship_size)
    free_field = free_fields.select { |field| field.count >= ship_size }.sample
    random = rand(0..free_field.count - ship_size)
    @ships << free_field.slice(random, ship_size)
    @ships.last.each { |cell| cell.ship = '#' }
  end

  # fill field with ships
  def fill_field
    SHIPS.each { |size| put_ship(size) }
  end

  # user friendly output
  def output
    @battle_field.each do |sub|
      sub.each do |cell|
        if cell.ship
          print 'x '
        else
          print '. '
        end
      end
      print "\n"
    end
  end

  # displays field with ships
  def start
    fill_field
    output
  end

    private

  # helper method for #free_fields
  def free_pieses(battle_field)
    battle_field.flat_map do |row|
      row.chunk(&:free?).select(&:first).map(&:last)
    end
  end
end

# field cell
class Cell
  attr_reader :x, :y
  attr_accessor :ship

  # initialize a cell with its coordinates and field, it belongs to
  def initialize(battle_field, x, y)
    @battle_field = battle_field
    @x = x
    @y = y
    @ship = nil
  end

  # get neighbors of this cell
  def neighbors
    neighbors = []
    for row in (x - 1)..(x + 1)
      for col in (y - 1)..(y + 1)
        if (0...FIELD_SIZE).cover?(row) && (0...FIELD_SIZE).cover?(col)
          if row != x || col != y
            neighbors.push(@battle_field[row, col])
          end
        end
      end
    end
    neighbors
  end

  # return true if cell is free and all its neighbors are free
  def free?
    ship.nil? && neighbors.all? { |t| t.ship.nil? }
  end
end

game = Battlefield.new

game.start
