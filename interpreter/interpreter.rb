require 'find'

class Expression
end

class All < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p
    end
    results
  end
end

class Not < Expression
  def initialize(expression)
    @expression = expression
  end

  def evaluate(dir)
    All.new.evaluate(dir).to_a - @expression.evaluate(dir).to_a
  end
end

class Or < Expression
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def evaluate(dir)
    result1 = @expression1.evaluate(dir).to_a
    result2 = @expression2.evaluate(dir).to_a
    puts (result1 + result2).sort.uniq
  end
end

class FileName < Expression
  def initialize(pattern)
    @pattern = pattern
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      name = File.basename(p)
      results << p if File.fnmatch(@pattern, name)
    end
    puts results
  end
end

class Writable < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p if File.writable?(p)
    end
  end
end

class Bigger
  def initialize(bytes)
    @bytes = bytes
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |f|
      next unless File.file?(f)
      results << f if File.size(f) > @bytes
    end
    puts results
  end
end

dir = "#{Dir.home}/dev/patterns/interpreter"

puts "Exp"
expr_rb = FileName.new('*.rb')
rbs = expr_rb.evaluate(dir)

puts "\nNot"
small_exp = Not.new(Bigger.new(2048))
small_files = small_exp.evaluate(dir)

puts "\nOR"
txt_or_rb_exp = Or.new(FileName.new('*.rb'), FileName.new('*.txt'))
txt_or_rb_files = txt_or_rb_exp.evaluate(dir)
