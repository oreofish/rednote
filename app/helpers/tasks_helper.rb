module TasksHelper
  include ActsAsTaggableOn::TagsHelper
  
  def three_type_tasks(tasks)
    coming_tasks = Array.new
    recent_tasks = Array.new
    past_tasks = Array.new
    current_week = Date.today.cweek
    
    tasks.each do |task|
      case task.status
      when Task::BACKLOG then coming_tasks << task
      when Task::TODO then recent_tasks << task
      when Task::DOING then recent_tasks << task
      when Task::DONE then past_tasks << task
      end
    end
    return coming_tasks, recent_tasks, past_tasks
  end
  
  def task_css(task, addon)
    status_class = ['task-backlog', 'task-todo', 'task-doing', 'task-done', 'task-cancel']
    time_css = ['task-past', 'task-recent', 'task-coming']
  
    current_week = Date.today.cweek
    tasktime = case task.status
               when Task::BACKLOG then 2
               when Task::TODO then 1
               when Task::DOING then 1
               when Task::DONE
                 if task.finish_at.nil?
                   1
                 elsif task.finish_at.to_datetime.cweek == current_week
                   1
                 else
                   0
                 end
               else 0
               end
    
    "#{addon} #{status_class[task.status]} #{time_css[tasktime]}"
  end
  
  def task_sign(task)
    case task.status
      when Task::BACKLOG
      "<i class='icon-chevron-down'></i>"
      when Task::TODO
      "<i class='icon-time'></i>"
      when Task::DOING
      "<i class='icon-screenshot'></i>"
      when Task::DONE
      "<i class='icon-ok'></i>"
    end
  end
  
end
