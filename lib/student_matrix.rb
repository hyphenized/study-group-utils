class StudentMatrix
  ErrorStudentsWorkedTogether = ArgumentError

  attr_reader :matrix, :groups_formed

  # We expect a students array
  # A student is a hash => { id: "1", name: "Perrón", power: "[1-10]" }
  def initialize(students, group_size)
    @group_size = group_size
    @groups_in_total = (students.size / @group_size).floor
    @matrix = Array.new(students.size) { Array.new(students.size) { 0 } }
    @name_maps_to_pos = {}
    @students = students
    @students.keys.each_with_index { |item, index| @name_maps_to_pos[item] = index }
  end

  # We pass an array of each file
  # Each file is a hash of grouped students by the "study_group" value in the students hash. The value is an array of students.
  # Each member is a hash => {"study_group": "1", "name": "Jorge Luis"}
  def load_ocurrences(past_groups)
    past_groups.each do |file|
      file.each do |_study_group, students|
        students.each do |student|
          i = @name_maps_to_pos[student["name"]]
          students.reject { |me| me == student }.each { |other| j = @name_maps_to_pos[other["name"]]; @matrix[i][j] += 1 }
        end
      end
    end
  end

  def generate_groups!
    students_array = (0..@name_maps_to_pos.size - 1).to_a
    students_with_group = []
    @groups_formed = Array.new(@groups_in_total - 1) { Array.new(@group_size) }
    # Adding the butter in the group
    @groups_formed << Array.new(@group_size + (@name_maps_to_pos.size % @group_size))

    while students_with_group.size < @name_maps_to_pos.size
      students_available = students_array - students_with_group
      random_student_index = students_available.sample
      random_group_index = (0..@groups_in_total - 1).to_a.sample

      if is_group_empty?(@groups_formed[random_group_index])
        @groups_formed[random_group_index][0] = random_student_index
        students_with_group << random_student_index
        students_available.delete(random_student_index)
        students_available.shuffle!

        cursor = 0
        until is_group_full?(@groups_formed[random_group_index])
          worked_together = have_they_worked_together(students_available[cursor], @groups_formed[random_group_index])

          if worked_together
            if students_available.size <= @groups_in_total
              random_other_student = students_available.sample
              students_with_group << random_other_student
              insert_user_in_free_space(random_other_student, groups_formed[random_group_index])
              students_available.delete(random_other_student)
            else
              cursor += 1
            end
          else
            students_with_group << students_available[cursor]
            insert_user_in_free_space(students_available[cursor], groups_formed[random_group_index])
            students_available.delete(students_available[cursor])
            students_available.shuffle!
          end
        end
      end
    end
  end

  # Returns an array of study groups where each study group is an array of student names
  # @return [Array]
  def get_groups
    students_ids = @students.keys
    @groups_formed.map { |group| group.map { |id| students_ids[id] } }
  end

  def insert_user_in_free_space(user, group)
    free_pos = next_pos_available_in_group(group)
    group[free_pos] = user
  end

  def next_pos_available_in_group(group)
    group.each_with_index { |student, index| return index if student.nil? }
    # p "Group is full, there's no position available"
  end

  def have_they_worked_together(guy, group_array)
    group_array.each do |other|
      next if other.nil?
      if @matrix[guy][other] > 0
        # p "#{guy} has worked with #{other}"
        return true
      end
    end
    # p "#{guy} have not worked with #{group_array}"
    false
  end

  def is_group_full?(group)
    group.each { |student| return false if student.nil? }
    # p "Group is full"
    true
  end

  def are_groups_still_clean?(groups)
    groups.each { |group| return true if is_group_empty?(group) }
    # p "Groups are not clean"
    false
  end

  def is_group_empty?(group_array)
    group_array.each { |student| return false unless student.nil? }
    # p "Group is empty"
    true
  end
end
