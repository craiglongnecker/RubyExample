# An example of a ruby console project
# Menu Module
module Menu
  
  def menu # Menu method for To Do List to display options
    'Here are the Menu Options for your To Do List:
    1 - Add Task to the To Do List
    2 - Show all of the Tasks currently in the To Do List
    3 - Update a Task on the current To Do List
    4 - Delete a Task from the To Do List
    5 - Save the current To Do List to a File
    6 - Read a Previous To Do List File and add to the current List
    7 - Toggle Status whether Task is completed or not
    Q - Quit the Program'
  end
  
  def show # Show method
    menu # Show menu method above
  end
  
end

#Promptable module
module Promptable
  
  def prompt(message = 'What would you like to do?', symbol = ':> ') # Prompt method to prompt the user and accept user input
     print message
     print symbol
     gets.chomp
  end
  
end

# List Class
class List
  attr_reader :all_tasks # Attribute reader method that stores all tasks
  
  def initialize # Initialize method that is similar to a Constructor in Java
    @all_tasks = [] # Method includes an array that stores all tasks
  end
  
  def add(task) # Add task method
    unless task.to_s.chomp.empty? # Checks to see if array is empty
      all_tasks << task # Adds/Pushes a task to the all tasks array
    end
  end
  
  def show # Show tasks method
    all_tasks.map.with_index { |l, i| "(#{i.next}): #{l}"} # Show all tasks array in numerical order and whether a task is completed
  end
  
  def delete(task_number)
    all_tasks.delete_at(task_number  - 1) # Deletes Task number selected
    puts "Task (#{task_number}) has been deleted" # Confirms that Task has been deleted
  end
  
  def update(task_number, task) # Update task based on task number
    all_tasks[task_number -1] = task # Updates task
  end
  
  def write_to_file(filename) # Take name and status of file, output and save it to a new file
    completed =  @all_tasks.map(&:to_machine).join("\n")
    IO.write(filename, completed)
  end
  
  def read_from_file(filename) # Input existing file
    IO.readlines(filename).each do |line|
      status, *description = line.split(':')
      status = status.upcase.include?('X')
      add(Task.new(description.join(':').strip, status))
      puts line
    end
  end
  
  def toggle(task_number) # Toggle method that calls the toggle_status method on the appropriate task from the all_tasks array
    all_tasks[task_number - 1].toggle_status
  end 
  
end

# Task Class
class Task
  attr_reader :description # Attribute reader method for description
  attr_accessor :completed_status # Attribute accessor method for status
    
  def initialize(description, completed_status = false) # Initialize method that is similar to a Constructor in Java
    @description = description # Method initializes each task object with a description
    @completed_status = completed_status # Boolean value to determine whether task is complete or not complete
  end
  
  def completed? # Is task completed? method
    completed_status # True or false
  end
  
  def to_machine # To_machine method to display completion status and description of Task
    "#{represent_status} : #{description}"
  end
  
  def toggle_status # Toggle status method that negates the completed? method above
    @completed_status = !completed?
  end
  
  def to_s # Method to display completion status and description of Task
    "#{represent_status} : #{description}"
  end
  
  private # Private methods follow
  
  def represent_status # Private represent status method to determine if task is completed or not
    "#{completed? ? '[X]' : '[ ]'}" # Boolean with [X] is complete, [ ] is not complete
  end

end


# Run Program
if __FILE__ == $PROGRAM_NAME # Create new list file when program is run
  include Menu # Include Menu module
  include Promptable # Include Promptable module
  todo_list = List.new # Create new List
  puts 'Please choose from the following list:'
    until ['Q'].include?(user_input = prompt(show).upcase) # Until statement to continue to run program until user enters 'Q' or 'q' to quit program
      case user_input # Begin case statements from user input
        when '1' # Case statement when '1' (add task to List) is entered
          todo_list.add(Task.new(prompt('What is the Task description you would like to add to your List?')))          
        when '2' # Case statement when '2' (show all tasks in List) is entered
          puts todo_list.show
        when '3' # Case statement when '3' (update task from List) is entered
          todo_list.update(prompt('What is the number of the Task in the List you wish to update?').to_i,
            Task.new(prompt('What is the new Task description?')))     
        when '4' # Case statement when '4' (delete Task from List) is entered
          todo_list.delete(prompt('What is the number of the Task in the List you wish to delete?').to_i)
        when '5' # Case statement when '5' (save List to text file) is entered
          todo_list.write_to_file(prompt('What is the name of the file for the List you wish to save?'))
        when '6' # Case statement when '6' (open existing List text file) is entered
          begin # Read file if correct file name is provided
            todo_list.read_from_file(prompt('What is the name of the List file you wish to view and add to List?'))
          rescue Errno::ENOENT # Error statement if incorrect file name is provided
            puts('File name not found.  Please verify your file name and path')
          end
        when '7' # Case statement when '7' (to toggle between completed or not completed Task) is entered
          puts todo_list.show
          todo_list.toggle(prompt('Which Task number would you like to toggle between [X] currently complete and [ ] for currently not complete?').to_i)         
      else # Else statement to catch invalid input
          puts 'Sorry, your input was not valid.'
      end
      prompt('Press enter to continue', '') # Prompt method
    end
  puts 'Goodbye! - Thanks for using this To Do List program!' # End of program
end
