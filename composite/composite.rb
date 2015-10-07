class Task
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_time_required
    0.0
  end
end


class AddDryIngredientsTask < Task
  def initialize
    super('Add dry ingredients')
  end

  def get_time_required
    1.0
  end
end

class MixTask < Task
  def initialize
    super('Mix that batter up')
  end

  def get_time_required
    3.0
  end
end

class AddLiquidsTask < Task
  def initialize
    super('Add liquids')
  end

  def get_time_required
    2.0
  end
end

class CompositeTask
  def initialize(name)
    @name = name
    @sub_tasks = []
  end

  def <<(task)
    @sub_tasks << task
  end

  def [](index)
    @sub_tasks[index]
  end

  def []=(index, new_value)
    @sub_tasks[index] = new_value
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
  end

  def get_time_required
    @sub_tasks.inject(0) { |sum, task| sum += task.get_time_required }
  end
end

class MakeBatterTask < CompositeTask
  def initialize
    super('Make batter')
  end
end

composite = CompositeTask.new('Make Batter')
composite << AddDryIngredientsTask.new
composite << AddLiquidsTask.new
composite << MixTask.new
puts composite.get_time_required
