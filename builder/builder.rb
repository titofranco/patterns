class CPU; end

class TurboCPU < CPU ; end

class BasicCPU < CPU; end

class Drive
  attr_reader :type #:hard_disk, :cd or :dvd
  attr_reader :size #in MB
  attr_reader :writable # true if this drive is writable

  def initialize(type, size, writable)
    @type = type
    @size = size
    @writable = writable
  end
end

class LaptopDrive < Drive
end

class Motherboard
  attr_accessor :cpu
  attr_accessor :memory_size

  def initialize(cpu=BasicCPU.new, memory_size=1000)
    @cpu = cpu
    @memory_size = memory_size
  end
end

class Computer
  attr_accessor :display
  attr_accessor :motherboard
  attr_reader :drives

  def initialize(display=:crt, motherboard=Motherboard.new, drives=[])
    @motherboard=motherboard
    @drives = drives
    @display = display
  end
end

class DesktopComputer < Computer
  def initialize(motherboard=Motherboard.new, drives=[])
    super(:crt, motherboard, drives)
  end
end

class LaptopComputer < Computer
  def initialize(motherboard=Motherboard.new, drives=[])
    super(:lcd, motherboard, drives)
  end
end


class ComputerBuilder
  attr_reader :computer

  def computer
    raise "Not enough memory" if @computer.motherboard.memory_size < 250
    raise "Too many drives" if @computer.drives.size > 4
    hard_disk = @computer.drives.find { |d| d.type == :hard_disk }
    raise "No hard disk" unless hard_disk
    @computer
  end

  def turbo(has_turbo_cpu=true)
    @computer.motherboard.cpu = TurboCPU.new
  end

  def memory_size=(size_in_mb)
    @computer.motherboard.memory_size = size_in_mb
  end

  def method_missing(name, *args)
    words = name.to_s.split("_")
    return super(name, *args) unless words.shift == "add"
    words.each do |word|
      next if word == "and"
      add_cd if word == "cd"
      add_dvd if word == "dvd"
      add_hard_disk(10000) if word == "harddisk"
      turbo if word == "turbo"
    end
  end
end


class DesktopBuilder < ComputerBuilder
  def initialize
    @computer = DesktopComputer.new
  end

  def display=(display)
    @computer.display = display
  end

  def add_cd(writer=false)
    @computer.drives << Drive.new(:cd, 760, writer)
  end

  def add_dvd(writer=false)
    @computer.drives << Drive.new(:dvd, 4000, writer)
  end

  def add_hard_disk(size_in_mb)
    @computer.drives << Drive.new(:hard_disk, size_in_mb, true)
  end
end

class LaptopBuilder < ComputerBuilder
  def initialize
    @computer = LaptopComputer.new
  end

  def display=(display)
    raise "Laptop display must be lcd" unless display == :lcd
  end

  def add_cd(write=false)
    @computer.drives << LaptopDrive.new(:cd, 760, writer)
  end

  def add_dvd(writer=false)
    @computer.drives << LaptopDrive.new(:dvd, 4000, writer)
  end

  def add_hard_disk(size_in_mb)
    @computer.drives << LaptopDrive.new(:hard_disk, size_in_mb, true)
  end
end

desktop = DesktopBuilder.new
desktop.display = :lcd
desktop.add_cd
desktop.add_dvd
desktop.add_hard_disk(10000)

puts desktop.computer.inspect

laptop = LaptopBuilder.new
laptop.display = :lcd
laptop.add_dvd_and_harddisk_and_turbo

puts laptop.computer.inspect
