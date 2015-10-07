class SimpleWriter
  def initialize(path)
    @file = File.open(path, 'w')
  end

  def write_line(line)
    @file.print(line)
    @file.print("\n")
  end

  def pos
    @file.pos
  end

  def rewind
    @file.rewind
  end

  def close
    @file.close
  end
end

require 'forwardable'

class WriterDecorator
  extend Forwardable

  def_delegators :@real_writer, :write_line, :rewind, :pos, :close
  def initialize(real_writer)
    @real_writer = real_writer
  end
end

class NumberingWriter < WriterDecorator
  def initialize(real_writer)
    super(real_writer)
    @line_number = 1
  end

  def write_line(data)
    @real_writer.write_line("#{@line_number}: #{data}")
    @line_number += 1
  end
end

class CheckSummingWriter < WriterDecorator
  attr_reader :checksum

  def initialize(real_writer)
    super(real_writer)
    @check_sum = 0
  end

  def write_line(data)
    data.each_byte {|byte| @check_sum = (@check_sum + byte) % 256 }
    @check_sum += "\n"[0].to_i % 256
    @real_writer.write_line(data)
  end
end

class TimeStampingWriter < WriterDecorator
  def write_line(data)
    @real_writer.write_line "#{Time.new}: #{data}"
  end
end

writer = SimpleWriter.new('final.txt')
numbering = NumberingWriter.new(writer)
numbering.write_line('Hello out there')

timestamp = TimeStampingWriter.new(writer)
timestamp.write_line('With timestamp')

composed = CheckSummingWriter.new(TimeStampingWriter.new(NumberingWriter.new(SimpleWriter.new('composed.txt'))))
composed.write_line('I am a composed line')
