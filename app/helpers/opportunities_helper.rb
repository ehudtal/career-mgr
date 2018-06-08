module OpportunitiesHelper
  def new_task_fields index
    <<-TASK_FIELDS
      <li class="removeable_fields">
        <div class="field">
          <label for="opportunity_tasks_attributes_#{index}_name">Name</label>
          <input type="text" name="opportunity[tasks_attributes][#{index}][name]" id="opportunity_tasks_attributes_#{index}_name" />
        </div>
    
        <div class="field">
          <label for="opportunity_tasks_attributes_#{index}_due_at">Due at</label>
          <input class="datetime" type="text" name="opportunity[tasks_attributes][#{index}][due_at]" id="opportunity_tasks_attributes_#{index}_due_at" /><br>

          <input class="remove_hidden" type="hidden" value="false" name="opportunity[tasks_attributes][#{index}][_destroy]" id="opportunity_tasks_attributes_#{index}__destroy" />
          <a class="remove" href="#">remove</a>
        </div>
      </li>
    TASK_FIELDS
  end
end
