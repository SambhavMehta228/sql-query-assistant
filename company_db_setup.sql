-- Drop database if exists and create new one
DROP DATABASE IF EXISTS company_v2;
CREATE DATABASE company_v2;
USE company_v2;

-- Departments and Organization Structure
CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    dept_code VARCHAR(10) UNIQUE NOT NULL,
    annual_budget DECIMAL(15, 2),
    created_date DATE DEFAULT (CURRENT_DATE),
    is_active TINYINT(1) DEFAULT 1
);

CREATE TABLE locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    is_headquarters TINYINT(1) DEFAULT 0
);

CREATE TABLE department_locations (
    dept_id INT,
    location_id INT,
    start_date DATE NOT NULL,
    end_date DATE,
    is_primary TINYINT(1) DEFAULT 0,
    PRIMARY KEY (dept_id, location_id),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- Employee Management
CREATE TABLE job_grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    grade_level VARCHAR(10) NOT NULL,
    min_salary DECIMAL(12, 2),
    max_salary DECIMAL(12, 2),
    description TEXT
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    grade_id INT,
    salary DECIMAL(12, 2) NOT NULL,
    dept_id INT,
    manager_id INT,
    location_id INT,
    is_active TINYINT(1) DEFAULT 1,
    FOREIGN KEY (grade_id) REFERENCES job_grades(grade_id),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE employee_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    effective_date DATE,
    end_date DATE,
    job_title VARCHAR(100),
    dept_id INT,
    salary DECIMAL(12, 2),
    reason_for_change VARCHAR(100),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE dependents (
    dependent_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    relationship VARCHAR(50) NOT NULL,
    birth_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- Skills and Training
CREATE TABLE skill_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE skills (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(100) NOT NULL,
    category_id INT,
    description TEXT,
    is_technical TINYINT(1) DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES skill_categories(category_id)
);

CREATE TABLE employee_skills (
    emp_id INT,
    skill_id INT,
    proficiency_level INT CHECK (proficiency_level BETWEEN 1 AND 5),
    acquired_date DATE,
    last_used_date DATE,
    is_primary TINYINT(1) DEFAULT 0,
    PRIMARY KEY (emp_id, skill_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
);

-- Projects and Assignments
CREATE TABLE project_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_code VARCHAR(20) UNIQUE NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    category_id INT,
    start_date DATE,
    target_end_date DATE,
    actual_end_date DATE,
    budget DECIMAL(15, 2),
    status ENUM('PLANNED', 'IN_PROGRESS', 'ON_HOLD', 'COMPLETED', 'CANCELLED') NOT NULL,
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') NOT NULL,
    lead_dept_id INT,
    project_manager_id INT,
    FOREIGN KEY (category_id) REFERENCES project_categories(category_id),
    FOREIGN KEY (lead_dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (project_manager_id) REFERENCES employees(emp_id)
);

CREATE TABLE project_assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT,
    emp_id INT,
    role VARCHAR(100),
    start_date DATE,
    end_date DATE,
    hours_allocated DECIMAL(6, 2),
    hourly_rate DECIMAL(10, 2),
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE project_milestones (
    milestone_id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT,
    milestone_name VARCHAR(100) NOT NULL,
    description TEXT,
    target_date DATE,
    actual_date DATE,
    status ENUM('PENDING', 'IN_PROGRESS', 'COMPLETED', 'DELAYED') NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Performance and Reviews
CREATE TABLE review_cycles (
    cycle_id INT PRIMARY KEY AUTO_INCREMENT,
    cycle_name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    status ENUM('UPCOMING', 'IN_PROGRESS', 'COMPLETED') NOT NULL
);

CREATE TABLE performance_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    cycle_id INT,
    reviewer_id INT,
    review_date DATE,
    overall_rating DECIMAL(3, 2) CHECK (overall_rating BETWEEN 1 AND 5),
    comments TEXT,
    status ENUM('DRAFT', 'SUBMITTED', 'ACKNOWLEDGED', 'FINAL') NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (cycle_id) REFERENCES review_cycles(cycle_id),
    FOREIGN KEY (reviewer_id) REFERENCES employees(emp_id)
);

CREATE TABLE performance_goals (
    goal_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    cycle_id INT,
    goal_description TEXT NOT NULL,
    target_date DATE,
    status ENUM('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED') NOT NULL,
    achievement_date DATE,
    comments TEXT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (cycle_id) REFERENCES review_cycles(cycle_id)
);

-- Training and Development
CREATE TABLE training_programs (
    program_id INT PRIMARY KEY AUTO_INCREMENT,
    program_name VARCHAR(100) NOT NULL,
    description TEXT,
    duration_hours INT,
    cost_per_employee DECIMAL(10, 2),
    provider VARCHAR(100),
    is_mandatory TINYINT(1) DEFAULT 0
);

CREATE TABLE employee_training (
    training_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    program_id INT,
    start_date DATE,
    completion_date DATE,
    status ENUM('ENROLLED', 'IN_PROGRESS', 'COMPLETED', 'DROPPED') NOT NULL,
    score DECIMAL(5, 2),
    comments TEXT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (program_id) REFERENCES training_programs(program_id)
);

-- Budget and Expenses
CREATE TABLE budget_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_category_id INT,
    FOREIGN KEY (parent_category_id) REFERENCES budget_categories(category_id)
);

CREATE TABLE department_budgets (
    budget_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_id INT,
    fiscal_year INT NOT NULL,
    category_id INT,
    amount DECIMAL(15, 2) NOT NULL,
    notes TEXT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (category_id) REFERENCES budget_categories(category_id)
);

CREATE TABLE expenses (
    expense_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_id INT,
    category_id INT,
    amount DECIMAL(12, 2) NOT NULL,
    expense_date DATE NOT NULL,
    description TEXT,
    submitted_by INT,
    status ENUM('SUBMITTED', 'APPROVED', 'REJECTED', 'PAID') NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (category_id) REFERENCES budget_categories(category_id),
    FOREIGN KEY (submitted_by) REFERENCES employees(emp_id)
);

-- Indexes for better performance
CREATE INDEX idx_emp_dept ON employees(dept_id);
CREATE INDEX idx_emp_manager ON employees(manager_id);
CREATE INDEX idx_project_status ON projects(status);
CREATE INDEX idx_project_dept ON projects(lead_dept_id);
CREATE INDEX idx_assignment_project ON project_assignments(project_id);
CREATE INDEX idx_assignment_employee ON project_assignments(emp_id);
CREATE INDEX idx_review_employee ON performance_reviews(emp_id);
CREATE INDEX idx_review_cycle ON performance_reviews(cycle_id);
CREATE INDEX idx_expense_dept ON expenses(dept_id);
CREATE INDEX idx_expense_category ON expenses(category_id); 