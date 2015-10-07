class Command
  attr_reader :desc
  def initialize(desc)
    @desc = desc
  end

  def execute
    raise NotImplementedError
  end
end

class CompositeCommand
  def initialize
    @commands = []
  end

  def add_command(command)
    @commands << command
  end

  def delete_command(command)
    @commands.delete(command)
  end

  def execute
    @commands.each { |command| command.execute }
  end
end

class CreateFile < Command
  def initialize(path, contents)
    super "Create file: #{path}"
    @path = path
    @contents = contents
  end

  def execute
    f = File.open(@path, 'w')
    f.write(@contents)
    f.close
  end

  def unexecute
    File.delete(@path)
  end
end

class DeleteFile < Command
  def initialize(path)
    super "Delete file: #{path}"
    @path = path
  end

  def execute
    if File.exists?(@path)
      @contents = File.read(@path)
    end
    File.delete(@path)
  end

  def unexecute
    if @contents
      f = File.open(@path, 'w')
      f.write(@contents)
      f.close
    end
  end
end

class CopyFile < Command
  require 'fileutils'
  def initialize(source, target)
    super "Copying a command"
    @source = source
    @target = target
  end

  def execute
    FileUtils.copy(@source, @target)
  end

  def unexecute
    if File.exists?(@target)
      FileUtils.copy(@target, @source)
      File.delete(@target)
    end
  end
end

cmds = CompositeCommand.new
cmds.add_command(CreateFile.new('foo.txt', 'Bar Baz'))
cmds.add_command(CopyFile.new('foo.txt', 'copy-foo.txt'))
cmds.add_command(DeleteFile.new('foo.txt'))
cmds.execute
