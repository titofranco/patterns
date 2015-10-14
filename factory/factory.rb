class Duck
  def initialize(name)
    @name = name
  end

  def eat
    puts "Duck #{@name} is eating."
  end

  def speak
    puts "Duck #{@name} says quack."
  end

  def sleep
    puts "Duck #{@name} sleeps quietly."
  end
end

class Frog
  def initialize(name)
    @name = name
  end

  def eat
    puts "Frog #{@name} is eating."
  end

  def speak
    puts "Frog #{@name} says Croooak."
  end

  def sleep
    puts "Frog #{@name} does not sleep, he croaks all night!"
  end
end

class Pond
  def initialize(number_animals, animal_class, number_plants, plant_class)
    @animal_class = animal_class
    @plant_class = plant_class

    @animals = []
    number_animals.times do |i|
      animal = new_organism(:animal, "Animal#{i}")
      @animals << animal
    end

    @plants = []
    number_plants.times do |i|
      plant = new_organism(:plant, "Plant#{i}")
      @plants << plant
    end
  end

  def simulate_one_day
    @plants.each { |plant| plant.grow }
    @animals.each { |animal| animal.eat }
    @animals.each { |animal| animal.speak }
    @animals.each { |animal| animal.sleep }
  end

  def new_organism(type, name)
    if type == :animal
      @animal_class.new(name)
    elsif type == :plant
      @plant_class.new(name)
    else
      raise "Unknown organism type: #{type}"
    end
  end

end

class DuckPond < Pond
  def new_animal(name)
    Duck.new(name)
  end
end

class FrogPond < Pond
  def new_animal(name)
    Frog.new(name)
  end
end

class WaterLily
  def initialize(name)
    @name = name
  end
  def grow
    puts "The Water lily  #{@name} floats, soaks up the sun, and grows."
  end
end

class Algae
  def initialize(name)
    @name = name
  end
  def grow
    puts "The Algae #{@name} soaks up the sun and grows"
  end
end

pond = Pond.new(3, Duck, 2, WaterLily)
pond.simulate_one_day
