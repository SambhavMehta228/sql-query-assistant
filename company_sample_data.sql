USE company_v2;

-- Insert Locations
INSERT INTO locations (city, state, country, postal_code, address_line1, is_headquarters) VALUES
('New York', 'NY', 'USA', '10001', '123 Tech Plaza', 1),
('San Francisco', 'CA', 'USA', '94105', '456 Innovation Drive', 0),
('Chicago', 'IL', 'USA', '60601', '789 Business Park', 0),
('Austin', 'TX', 'USA', '73301', '321 Startup Lane', 0),
('Boston', 'MA', 'USA', '02110', '555 Research Way', 0);

-- Insert Departments
INSERT INTO departments (dept_name, dept_code, annual_budget) VALUES
('Executive', 'EXEC', 5000000.00),
('Information Technology', 'IT', 2000000.00),
('Human Resources', 'HR', 1000000.00),
('Finance', 'FIN', 1500000.00),
('Research & Development', 'RND', 3000000.00),
('Marketing', 'MKT', 1800000.00),
('Operations', 'OPS', 2500000.00);

-- Insert Department Locations
INSERT INTO department_locations (dept_id, location_id, start_date, is_primary) VALUES
(1, 1, '2020-01-01', 1),  -- Executive in NY
(2, 2, '2020-01-01', 1),  -- IT in SF
(3, 1, '2020-01-01', 1),  -- HR in NY
(4, 1, '2020-01-01', 1),  -- Finance in NY
(5, 5, '2020-01-01', 1),  -- R&D in Boston
(6, 2, '2020-01-01', 1),  -- Marketing in SF
(7, 3, '2020-01-01', 1);  -- Operations in Chicago

-- Insert Job Grades
INSERT INTO job_grades (grade_level, min_salary, max_salary, description) VALUES
('L1', 40000.00, 60000.00, 'Entry Level'),
('L2', 55000.00, 85000.00, 'Junior Professional'),
('L3', 80000.00, 120000.00, 'Senior Professional'),
('L4', 110000.00, 160000.00, 'Lead/Manager'),
('L5', 150000.00, 250000.00, 'Director'),
('L6', 200000.00, 400000.00, 'Executive');

-- Insert Employees (First insert executives and managers)
INSERT INTO employees (first_name, last_name, email, phone, hire_date, job_title, grade_id, salary, dept_id, location_id) VALUES
-- Executives
('John', 'Smith', 'john.smith@company.com', '555-0101', '2020-01-01', 'CEO', 6, 350000.00, 1, 1),
('Sarah', 'Johnson', 'sarah.j@company.com', '555-0102', '2020-01-15', 'CTO', 6, 300000.00, 2, 2),
('Michael', 'Williams', 'michael.w@company.com', '555-0103', '2020-01-15', 'CFO', 6, 300000.00, 4, 1),
-- Directors
('Emily', 'Brown', 'emily.b@company.com', '555-0104', '2020-02-01', 'HR Director', 5, 200000.00, 3, 1),
('David', 'Miller', 'david.m@company.com', '555-0105', '2020-02-01', 'R&D Director', 5, 220000.00, 5, 5),
('Jennifer', 'Davis', 'jennifer.d@company.com', '555-0106', '2020-02-01', 'Marketing Director', 5, 190000.00, 6, 2),
('Robert', 'Wilson', 'robert.w@company.com', '555-0107', '2020-02-01', 'Operations Director', 5, 195000.00, 7, 3);

-- Update manager_id for executives
UPDATE employees SET manager_id = 1 WHERE job_title IN ('CTO', 'CFO');
UPDATE employees SET manager_id = 1 WHERE job_title LIKE '%Director%';

-- Insert regular employees
INSERT INTO employees (first_name, last_name, email, phone, hire_date, job_title, grade_id, salary, dept_id, manager_id, location_id) VALUES
-- IT Department
('James', 'Anderson', 'james.a@company.com', '555-0108', '2020-03-01', 'Senior Developer', 3, 115000.00, 2, 2, 2),
('Lisa', 'Thomas', 'lisa.t@company.com', '555-0109', '2020-03-15', 'System Architect', 4, 135000.00, 2, 2, 2),
('Kevin', 'Martin', 'kevin.m@company.com', '555-0110', '2020-04-01', 'Developer', 2, 75000.00, 2, 8, 2),
-- HR Department
('Patricia', 'White', 'patricia.w@company.com', '555-0111', '2020-03-01', 'HR Manager', 4, 125000.00, 3, 4, 1),
('Joseph', 'Clark', 'joseph.c@company.com', '555-0112', '2020-03-15', 'HR Specialist', 2, 65000.00, 3, 11, 1),
-- Finance Department
('Nancy', 'Lee', 'nancy.l@company.com', '555-0113', '2020-03-01', 'Financial Analyst', 3, 95000.00, 4, 3, 1),
('Steven', 'Walker', 'steven.w@company.com', '555-0114', '2020-03-15', 'Accountant', 2, 70000.00, 4, 13, 1),
-- R&D Department
('Margaret', 'Hall', 'margaret.h@company.com', '555-0115', '2020-03-01', 'Research Scientist', 4, 140000.00, 5, 5, 5),
('Donald', 'Young', 'donald.y@company.com', '555-0116', '2020-03-15', 'Research Engineer', 3, 110000.00, 5, 15, 5),
-- Marketing Department
('Sandra', 'King', 'sandra.k@company.com', '555-0117', '2020-03-01', 'Marketing Manager', 4, 130000.00, 6, 6, 2),
('Christopher', 'Wright', 'chris.w@company.com', '555-0118', '2020-03-15', 'Marketing Specialist', 2, 72000.00, 6, 17, 2),
-- Operations Department
('Betty', 'Lopez', 'betty.l@company.com', '555-0119', '2020-03-01', 'Operations Manager', 4, 128000.00, 7, 7, 3),
('Richard', 'Hill', 'richard.h@company.com', '555-0120', '2020-03-15', 'Operations Analyst', 2, 68000.00, 7, 19, 3);

-- Insert Dependents
INSERT INTO dependents (emp_id, first_name, last_name, relationship, birth_date) VALUES
(1, 'Jane', 'Smith', 'Spouse', '1975-05-15'),
(1, 'Tommy', 'Smith', 'Child', '2010-02-20'),
(2, 'Mark', 'Johnson', 'Spouse', '1978-08-25'),
(4, 'James', 'Brown', 'Spouse', '1980-03-10'),
(4, 'Emma', 'Brown', 'Child', '2012-07-30'),
(8, 'Mary', 'Anderson', 'Spouse', '1982-11-05'),
(15, 'Helen', 'Hall', 'Spouse', '1979-09-15');

-- Insert Skill Categories
INSERT INTO skill_categories (category_name, description) VALUES
('Technical', 'Technical and programming skills'),
('Management', 'Leadership and management skills'),
('Soft Skills', 'Communication and interpersonal skills'),
('Domain Knowledge', 'Industry and business knowledge'),
('Certifications', 'Professional certifications');

-- Insert Skills
INSERT INTO skills (skill_name, category_id, description, is_technical) VALUES
('Java Programming', 1, 'Java programming language', 1),
('Python Programming', 1, 'Python programming language', 1),
('Project Management', 2, 'Project management methodologies', 0),
('Team Leadership', 2, 'Team leadership and management', 0),
('Communication', 3, 'Written and verbal communication', 0),
('Problem Solving', 3, 'Analytical and problem-solving skills', 0),
('Finance', 4, 'Financial analysis and management', 0),
('Marketing', 4, 'Marketing strategies and analysis', 0),
('PMP Certification', 5, 'Project Management Professional', 0),
('AWS Certification', 5, 'Amazon Web Services', 1);

-- Insert Employee Skills
INSERT INTO employee_skills (emp_id, skill_id, proficiency_level, acquired_date) VALUES
(8, 1, 5, '2018-01-01'),  -- James - Java
(8, 2, 4, '2019-01-01'),  -- James - Python
(9, 1, 5, '2017-01-01'),  -- Lisa - Java
(10, 2, 3, '2019-06-01'), -- Kevin - Python
(11, 3, 4, '2018-01-01'), -- Patricia - Project Management
(13, 7, 5, '2017-01-01'), -- Nancy - Finance
(15, 6, 5, '2016-01-01'), -- Margaret - Problem Solving
(17, 8, 4, '2018-01-01'); -- Sandra - Marketing

-- Insert Project Categories
INSERT INTO project_categories (category_name, description) VALUES
('Software Development', 'Software and application development projects'),
('Infrastructure', 'IT infrastructure and networking projects'),
('Research', 'Research and development projects'),
('Marketing Campaign', 'Marketing and advertising campaigns'),
('Process Improvement', 'Business process improvement projects');

-- Insert Projects
INSERT INTO projects (project_code, project_name, category_id, start_date, target_end_date, budget, status, priority, lead_dept_id, project_manager_id) VALUES
('SFDEV001', 'Customer Portal', 1, '2023-01-01', '2023-06-30', 500000.00, 'IN_PROGRESS', 'HIGH', 2, 9),
('INFRA001', 'Network Upgrade', 2, '2023-02-01', '2023-07-31', 300000.00, 'IN_PROGRESS', 'MEDIUM', 2, 8),
('RES001', 'Product Innovation', 3, '2023-01-15', '2023-12-31', 800000.00, 'IN_PROGRESS', 'HIGH', 5, 15),
('MKT001', 'Brand Refresh', 4, '2023-03-01', '2023-08-31', 400000.00, 'IN_PROGRESS', 'MEDIUM', 6, 17),
('OPS001', 'Process Automation', 5, '2023-02-15', '2023-09-30', 350000.00, 'IN_PROGRESS', 'HIGH', 7, 19);

-- Insert Project Assignments
INSERT INTO project_assignments (project_id, emp_id, role, start_date, end_date, hours_allocated) VALUES
(1, 8, 'Technical Lead', '2023-01-01', '2023-06-30', 120),
(1, 9, 'Project Manager', '2023-01-01', '2023-06-30', 80),
(1, 10, 'Developer', '2023-01-01', '2023-06-30', 160),
(2, 8, 'Infrastructure Lead', '2023-02-01', '2023-07-31', 100),
(3, 15, 'Research Lead', '2023-01-15', '2023-12-31', 140),
(3, 16, 'Research Associate', '2023-01-15', '2023-12-31', 160),
(4, 17, 'Marketing Lead', '2023-03-01', '2023-08-31', 120),
(4, 18, 'Marketing Associate', '2023-03-01', '2023-08-31', 160),
(5, 19, 'Operations Lead', '2023-02-15', '2023-09-30', 100),
(5, 20, 'Operations Analyst', '2023-02-15', '2023-09-30', 160);

-- Insert Project Milestones
INSERT INTO project_milestones (project_id, milestone_name, description, target_date, status) VALUES
(1, 'Requirements Gathering', 'Complete requirements documentation', '2023-02-01', 'COMPLETED'),
(1, 'Development Phase 1', 'Core functionality development', '2023-04-01', 'IN_PROGRESS'),
(2, 'Network Assessment', 'Current infrastructure assessment', '2023-03-01', 'COMPLETED'),
(2, 'Hardware Upgrade', 'Install new network hardware', '2023-05-01', 'IN_PROGRESS'),
(3, 'Research Phase 1', 'Initial research and analysis', '2023-04-15', 'IN_PROGRESS'),
(4, 'Market Research', 'Complete market analysis', '2023-04-01', 'COMPLETED'),
(4, 'Campaign Design', 'Design new brand elements', '2023-06-01', 'IN_PROGRESS'),
(5, 'Process Analysis', 'Current process documentation', '2023-03-15', 'COMPLETED'),
(5, 'Automation Design', 'Design automation workflow', '2023-05-15', 'IN_PROGRESS');

-- Insert Review Cycles
INSERT INTO review_cycles (cycle_name, start_date, end_date, status) VALUES
('2023 Mid-Year Review', '2023-06-01', '2023-07-31', 'IN_PROGRESS'),
('2023 Annual Review', '2023-12-01', '2024-01-31', 'UPCOMING');

-- Insert Performance Reviews
INSERT INTO performance_reviews (emp_id, cycle_id, reviewer_id, review_date, overall_rating, status) VALUES
(8, 1, 2, '2023-06-15', 4.5, 'SUBMITTED'),
(9, 1, 2, '2023-06-15', 4.2, 'SUBMITTED'),
(10, 1, 8, '2023-06-16', 3.8, 'SUBMITTED'),
(11, 1, 4, '2023-06-15', 4.0, 'SUBMITTED'),
(13, 1, 3, '2023-06-15', 4.3, 'SUBMITTED');

-- Insert Training Programs
INSERT INTO training_programs (program_name, description, duration_hours, cost_per_employee, provider, is_mandatory) VALUES
('New Employee Orientation', 'Orientation for new hires', 16, 200.00, 'Internal', 1),
('Project Management Basics', 'Fundamentals of project management', 24, 500.00, 'PMI', 0),
('Leadership Development', 'Leadership skills workshop', 40, 1500.00, 'Leadership Institute', 0),
('Technical Skills Workshop', 'Advanced technical training', 32, 1000.00, 'Tech Training Inc', 0),
('Compliance Training', 'Annual compliance refresher', 8, 100.00, 'Internal', 1);

-- Insert Employee Training
INSERT INTO employee_training (emp_id, program_id, start_date, completion_date, status, score) VALUES
(10, 1, '2023-04-01', '2023-04-02', 'COMPLETED', 95.00),
(12, 1, '2023-04-01', '2023-04-02', 'COMPLETED', 92.00),
(8, 2, '2023-05-01', '2023-05-03', 'COMPLETED', 88.00),
(9, 3, '2023-05-15', NULL, 'IN_PROGRESS', NULL),
(11, 3, '2023-05-15', NULL, 'IN_PROGRESS', NULL);

-- Insert Budget Categories
INSERT INTO budget_categories (category_name, description) VALUES
('Salaries', 'Employee salaries and wages'),
('Benefits', 'Employee benefits and insurance'),
('Equipment', 'Office and technical equipment'),
('Training', 'Employee training and development'),
('Operations', 'General operational expenses');

-- Insert Department Budgets
INSERT INTO department_budgets (dept_id, fiscal_year, category_id, amount) VALUES
(1, 2023, 1, 2000000.00),
(2, 2023, 1, 1500000.00),
(2, 2023, 3, 300000.00),
(3, 2023, 1, 800000.00),
(4, 2023, 1, 1000000.00),
(5, 2023, 1, 1200000.00),
(6, 2023, 1, 900000.00),
(7, 2023, 1, 1100000.00);

-- Insert Expenses
INSERT INTO expenses (dept_id, category_id, amount, expense_date, description, submitted_by, status) VALUES
(2, 3, 25000.00, '2023-03-15', 'Development Workstations', 2, 'APPROVED'),
(2, 4, 15000.00, '2023-04-01', 'Team Training Workshop', 2, 'APPROVED'),
(3, 4, 5000.00, '2023-04-15', 'HR Conference Registration', 4, 'APPROVED'),
(5, 3, 50000.00, '2023-05-01', 'Research Equipment', 5, 'APPROVED'),
(6, 5, 20000.00, '2023-05-15', 'Marketing Materials', 6, 'APPROVED'); 