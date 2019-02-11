require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :id, :name, :grade

  def initialize(id = nil, name, grade)
  	@grade = grade
  	@name = name
  	@id = id
  end

  def self.create_table
  	sql = <<-SQL
  	CREATE TABLE IF NOT EXISTS students (
  	id INTEGER PRIMARY KEY,
  	name TEXT,
  	grade INTEGER
  	);
  	SQL

  	DB[:conn].execute(sql)
  end

  def self.drop_table
  	sql = <<-SQL
  	DROP TABLE students;
  	SQL

  	DB[:conn].execute(sql)
  end

  def save
  	if self.id
  		self.update
  	else
  		sql = <<-SQL
  			INSERT INTO students (name, grade)
  			VALUES (?, ?)
  		SQL

  		DB[:conn].execute(sql, self.name, self.grade)

  		@id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  	end
  end

  def self.create(name, grade)
  	student = self.new(nil, name, grade)
  	student.save
  	student
  end

  def self.new_from_db(row)
  	student = self.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
  	sql = <<-SQL
  	SELECT * FROM students WHERE name = ?
  	SQL

  	row = DB[:conn].execute(sql, name)[0]

  	self.new_from_db(row)
  end

  def update
  	sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"

  	DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
