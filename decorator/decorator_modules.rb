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

module NumberingWriter
  def write_line(data)
    @line_number = 1 unless @line_number
    super("#{@line_number}: #{data}")
    @line_number += 1
  end
end

class CheckSummingWriter < WriterDecorator
  attr_reader :checksum
  def write_line(line)
    @check_sum = 0 unless @check_sum

    line.each_byte {|byte| @check_sum = (@check_sum + byte) % 256 }
    @check_sum += "\n"[0].to_i % 256
    super(line)
  end
end

module TimeStampingWriter
  def write_line(data)
    super "#{Time.new}: #{data}"
  end
end

w = SimpleWriter.new('with_modules.txt')
w.extend(NumberingWriter)
w.extend(TimeStampingWriter)
# The last module added will be the first one called
w.write_line("decorator with modules")
# Be careful you can not "un-include" modules
