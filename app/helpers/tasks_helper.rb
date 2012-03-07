module TasksHelper
  include ActsAsTaggableOn::TagsHelper
  
  def three_type_tasks(tasks)
    coming_tasks = Array.new
    recent_tasks = Array.new
    past_tasks = Array.new
    current_week = Date.today.cweek
    
    tasks.each do |task|
      case task.status
      when Task::TODO
        if task.assigned_to
          recent_tasks << task
        else
          coming_tasks << task
        end
      when Task::DOING then recent_tasks << task
      when Task::DONE
        if task.finish_at.nil? or task.finish_at.to_datetime.cweek < current_week
          past_tasks << task
        else
          recent_tasks << task
        end
      else
        recent_tasks << task
      end
    end
    return coming_tasks, recent_tasks, past_tasks
  end
  
  def task_css(task)
    status_class = ['task-todo', 'task-doing', 'task-done',
                    'task-highest', 'task-high', 'task-canceled', 'task-merged']
    current_week = Date.today.cweek
    "#{status_class[task.status]} status#{task.status}"
  end
  
  def task_sign(task)
    case task.status
      when Task::TODO
      "<i class='icon-chevron-down'></i>"
      when Task::DONE
      "<i class='icon-chevron-up'></i>"
    end
  end
  
end
