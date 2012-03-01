module TasksHelper
  include ActsAsTaggableOn::TagsHelper
  
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
