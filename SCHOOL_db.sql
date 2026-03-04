-- 0) create database & use it
drop database if exists school_db;
create database school_db;
use school_db;

-- 1) department
create table departments(
dept_id int primary key auto_increment,
dept_name varchar(100) not null unique);

-- 2) teachers
create table teachers(
teacher_id int primary key auto_increment,
teacher_name varchar(100) not null,
dept_id int not null,
foreign key(dept_id) references departments(dept_id));

-- 3) students
create table students(
student_id int primary key auto_increment,
first_name varchar(100) not null,
last_name varchar(100) not null,
city varchar(100) not null);

-- 4)courses
create table courses(
course_id int primary key auto_increment,
course_name varchar(100) not null,
dept_id int not null,
credits tinyint not null check(credits between 1 and 6),
foreign key(dept_id) references departments(dept_id));

-- 5) classes (combining course in a term , taught by ateacher )
create table classes(
class_id int primary key auto_increment,
course_id int not null,
teacher_id int not null,
term varchar(20) not null,
start_date date not null,
end_date date not null,
room varchar(20),
foreign key(course_id) references courses(course_id),
foreign key(teacher_id) references teachers(teacher_id));

-- 6) enrollment table
create table enrollments(
enrollment_id int primary key auto_increment,
student_id int not null,
class_id int not null,
grade char(1) null,
foreign key(student_id) references students(student_id),
foreign key(class_id) references classes(class_id),
unique key uq_student_class(student_id,class_id));

-- 7)course prerequisites
create table prerequisites(
course_id int not null,
prereq_course_id int not null,
primary key(course_id,prereq_course_id),
foreign key(course_id) references courses(course_id),
foreign key(prereq_course_id) references courses(course_id));


-- 
-- Sample Data
INSERT INTO departments (dept_name) VALUES
('Data Science'), ('Full Stack'), ('Web Development');

INSERT INTO teachers (teacher_name, dept_id) VALUES
('Rashmi Joshi', 1),
('Sanjog Meshram', 1),
('Rahul Selokar', 2),
('Madhu Yeole', 3);

INSERT INTO students (first_name, last_name, city) VALUES
('Chaitanya', 'Bhendarkar', 'Delhi'),
('Disha', 'Pandey', 'Mumbai'),
('Jiya', 'Mohod', 'Delhi'),
('Piyush', 'Thool', 'Pune'),
('Prachee', 'Meshram', 'Chennai'),
('Pritish', 'Adak', 'Pune'),
('Sharvari', 'Fulzele', 'Kolkata'),
('Swapnil', 'Meshram', 'Mumbai'),
('Yukti', 'Choudhari', 'Nagpur');

INSERT INTO courses (course_name, dept_id, credits) VALUES
('Python Programming', 1, 3),      -- id 1
('Data Structures', 1, 4),           -- id 2
('Databases', 1, 4),                 -- id 3
('React', 2, 4),                -- id 4
('JavaScript', 2, 4),            -- id 5
('HTML', 3, 3);             -- id 6

-- prerequisites: Data Structures requires Python Programming; Databases requires Data Structures
INSERT INTO prerequisites (course_id, prereq_course_id) VALUES
(2,1), (3,2);

-- Classes (course_id, teacher_id, term, start_date, end_date, room)
INSERT INTO classes (course_id, teacher_id, term, start_date, end_date, room) VALUES
(1, 1, '2025 Spring', '2025-02-01', '2025-05-15', 'DS101'),   -- Python by Rashmi
(2, 2, '2025 Spring', '2025-02-01', '2025-05-15', 'DS201'),   -- DS by Sanjog
(3, 2, '2025 Fall',   '2025-08-10', '2025-12-01', 'DS301'),   -- DB by Sanjog
(4, 3, '2025 Spring', '2025-02-01', '2025-05-15', 'FS101'),   -- React by Rahul
(5, 3, '2025 Fall',   '2025-08-10', '2025-12-01', 'FS201'),   -- JS by Rahul
(6, 4, '2025 Spring', '2025-02-01', '2025-05-15', 'WEB101'),  -- HTML by Madhu
(6, 4, '2025 Fall',   '2025-08-10', '2025-12-01', 'WEB201'),  -- HTML fall
(2, 1, '2025 Fall',   '2025-08-10', '2025-12-01', 'DS202');   -- extra DS by Rashmi

-- Enrollments (some completed grades, some in-progress)
-- Spring term
INSERT INTO enrollments (student_id, class_id, grade) VALUES
(1, 1, 'A'),   -- Chaitanya finished Python
(2, 1, 'B'),   -- Disha finished Python
(3, 1, 'C'),   -- Jiya finished Python
(4, 1, NULL),  -- Piyush still in Python (example)
(1, 2, NULL),  -- Chaitanya taking DS in Spring
(2, 4, 'A'),   -- Disha finished React
(5, 6, 'B');   -- Prachee finished HTML

-- Fall term
INSERT INTO enrollments (student_id, class_id, grade) VALUES
(1, 3, NULL),  -- Chaitanya taking Databases in Fall
(2, 8, NULL),  -- Disha taking DS in Fall (Rashmi)
(3, 5, NULL),  -- Jiya taking JavaScript
(6, 7, NULL);  -- Pritish taking HTML in Fall


-- 
select * from classes;
select * from courses;
select * from students;
select * from departments;
select * from prerequisites;
select * from teachers;
select * from enrollments;

-- inner join: list students with the classes they are enrolled in(name + term)
select s.first_name,s.last_name,c.class_id,c.term
from students s
 join enrollments e on e.student_id = s.student_id
 join classes c on c.class_id = e.class_id
 order by s.last_name,s.first_name,c.term;
 
 -- inner join (3 tables) : classes with course titles and teacher names
 select c.class_id,co.course_name,t.teacher_name,c.term,c.room
 from classes c
 join courses co on co.course_id = c.course_id
 join teachers t on t.teacher_id = c.teacher_id
 order by c.term,c.class_id;
 
 -- left join : students with no enrollment
 select s.student_id,s.first_name,s.last_name
 from students s
 left join enrollments e on e.student_id = s.student_id
 where e.enrollment_id is null
 order by s.student_id;
 
 -- left join : llist courses with their prerequisites if any
 select co.course_name as course,prereq.course_name as prerequisite
 from courses co
 left join prerequisites p on p.course_id = co.course_id
 left join courses prereq on prereq.course_id = p.prereq_course_id
 order by course;
 
 -- self join:pair student from the same city (unique pairs)
 select a.first_name as student_a, b.first_name as student_b,a.city
 from students a
 join students b on a.city=b.city and a.student_id<b.student_id
 order by a.city, student_a,student_b;
 
 -- right join: show all class and(if exists) there course names(same as left join as courses)
 select co.course_name, c.class_id,c.term
 from courses co
 right join classes c on c.course_id=co.course_id
 order by c.class_id;
 
 -- cross join :all
 select t.teacher_name,co.course_name
 from (select *from teachers where dept_id=1)t
 cross join (select *from courses where dept_id=1)co
 order by t.teacher_name, co.course_name;
 
 -- join..using(): join classes
 select c.class_id,c.term,course_name,credits
 from classes c
 join courses using (course_id)
 order by c.class_id;
 
 -- left join: classes in fail 2025 and who is enrolled (including empty)
 select c.class_id,c.term,s.first_name,s.last_name
 from classes c
 left join enrollments e on e.class_id=c.class_id
 left join students s on s.student_id=e.student_id
 where c.term='2025fail'
 order by c.class_id,s.last_name;
 
 -- aggregation with left join: headcount per class(includes class with 0 students)
 select c.class_id,c.term,count(e.enrollment_id) as num_students
 from classes c
 left join enrollments e on e.class_id=c.class_id
 group by c.class_id, c.term
 order by num_students desc,c.class_id;
 
 --
 select co.course_name, count(e.enrollment_id) as total_enrollments
 from courses co
 left join classes c on c.course_id=co.course_id
 left join enrollments e on e.class_id=c.class_id
 group by co.course_id, co.course_name
 order by total_enrollments desc, co.course_name;
 
 -- top n with join: the most popular course by enrollments
select co.course_name, count(e.enrollment_id) as total_enrollments
 from courses co
 left join classes c on c.course_id=co.course_id
 left join enrollments e on e.class_id=c.class_id
 group by co.course_id, co.course_name
 order by total_enrollments desc
 limit 1;
 
 -- fill outer join courses with no classes union classes with no course(should be none because of foreign key)
 select co.course_id, course_name,c.class_id,c.term
 from courses co 
 left join classes c on c.course_id=co.course_id
 where c.class_id is null
 union
 select co.course_id, course_name,c.class_id,c.term
 from courses co 
 right join classes c on c.course_id=co.course_id
 where c.class_id is null;
 
 -- 4 table join: student->enrollment->class->teacher(who teacher whom)
 select s.first_name, s.last_name,t.teacher_name,co.course_name,c.term
 from students s
 join enrollments e on e.student_id=s.student_id
 join classes c on c.class_id=e.class_id
 join courses co on co.course_id=c.teacher_id
 join teachers t on t.teacher_id=c.teacher_id
 order by s. last_name, s.first_name,c.term;