
# School Management System Database (SCHOOL_db)

A robust, relational SQL database schema designed to manage educational data including departments, teachers, students, courses, and class enrollments. This project demonstrates database normalization, referential integrity, and advanced SQL querying techniques.

## 📌 Project Overview

This repository contains a complete SQL script (`SCHOOL_db.sql`) that initializes a school database. It maps the complex relationships between academic departments, course prerequisites, and student enrollment cycles.

### Key Features:

* **Automated Schema Setup**: Includes `DROP DATABASE` and `CREATE` logic for easy environment resetting.
* **Data Integrity**: Implements primary keys, foreign keys, and unique constraints (e.g., preventing a student from enrolling in the same class twice).
* **Prerequisite Logic**: A self-referencing relationship in the `courses` table to handle academic dependencies.
* **Sample Data**: Populated with realistic records for students, teachers, and multi-term classes (Spring/Fall 2025).

---

## 🛠️ Database Schema

The database consists of **7 core tables**:

1. **`departments`**: Academic units (e.g., Data Science, Web Development).
2. **`teachers`**: Faculty members linked to specific departments.
3. **`students`**: Personal details and geographic data of enrolled students.
4. **`courses`**: Catalog of subjects with credit hour constraints.
5. **`classes`**: Specific instances of courses taught by a teacher in a specific term/room.
6. **`enrollments`**: The bridge between students and classes, including grading.
7. **`prerequisites`**: Mapping of course dependencies.

---

## 🚀 Key Queries & Use Cases

The script includes several complex queries used to extract meaningful insights:

* **Multi-Table Joins**: Connecting 4+ tables to determine which teacher is instructing which student.
* **Prerequisite Mapping**: Using `LEFT JOIN` on the same table to list courses alongside their requirements.
* **Enrollment Analytics**:
* Identifying "Ghost Students" (enrolled students with no classes) via `LEFT JOIN`.
* Calculating class headcounts using `COUNT` and `GROUP BY`.
* Identifying the "Most Popular Course" using `LIMIT`.


* **Geographic Analysis**: Using `SELF JOIN` to find pairs of students living in the same city.

---

## 🚦 How to Use

1. **Clone the repository**:
```bash
git clone https://github.com/yourusername/school-db-management.git

```


2. **Run the script**:
Open your preferred SQL client (MySQL Workbench, DBeaver, or Command Line) and execute the file:
```sql
SOURCE path/to/SCHOOL_db.sql;

```


3. **Explore**:
The script concludes with several `SELECT` statements that demonstrate the database's relationships.

---

## 📊 Sample Insights

| Course Name | Total Enrollments |
| --- | --- |
| Python Programming | 4 |
| Data Structures | 2 |
| React | 1 |

---

## 📝 Technical Implementation Details

* **Engine**: MySQL / MariaDB compatible.
* **Constraints**: Uses `CHECK(credits between 1 and 6)` to ensure data validity.
* **Auto-Increment**: Primary keys are handled automatically for ease of data entry.

