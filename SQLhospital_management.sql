

CREATE DATABASE IF NOT EXISTS hospital_management;
USE hospital_management;

-- Delete tables in the correct order if rerunning this script.
DROP TABLE IF EXISTS Billing;
DROP TABLE IF EXISTS Medical_Records;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Doctor_Department;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Doctors;
DROP TABLE IF EXISTS Patients;

-- 1. TABLES
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    gender VARCHAR(20),
    phone_number VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(200),
    registration_date DATE NOT NULL
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    email VARCHAR(100),
    available_days VARCHAR(100),
    consultation_fee DECIMAL(10,2) NOT NULL,
    experience_years INT NOT NULL
);

CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- Mapping table: a doctor can be connected to one or more departments.
CREATE TABLE Doctor_Department (
    doctor_id INT,
    department_id INT,
    PRIMARY KEY (doctor_id, department_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Medical_Records (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    diagnosis VARCHAR(255),
    prescription TEXT,
    treatment_date DATE NOT NULL,
    admission_date DATE,
    discharge_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Billing (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    appointment_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('Paid', 'Pending', 'Cancelled') DEFAULT 'Pending',
    payment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- 2. SAMPLE DATA
INSERT INTO Patients (name, dob, gender, phone_number, email, address, registration_date) VALUES
('Aarav Shah','1990-05-12','Male','9876500001','aarav@example.com','Pune','2025-01-10'),
('Meera Patel','1985-11-23','Female',NULL,'meera@example.com','Mumbai','2025-03-15'),
('Rohan Desai','2000-02-09','Male','9876500003','rohan@example.com','Pune','2025-06-20'),
('Sara Khan','1995-08-30','Female','9876500004','sara@example.com','Nashik','2024-12-05'),
('Kabir Joshi','1978-01-17','Male','9876500005','kabir@example.com','Pune','2025-08-12'),
('Isha Rao','2002-07-04','Female','9876500006','isha@example.com','Mumbai','2026-01-04'),
('Dev Kulkarni','1969-09-19','Male',NULL,'dev@example.com','Nagpur','2024-05-22'),
('Anaya Singh','1992-04-25','Female','9876500008','anaya@example.com','Pune','2025-11-01'),
('Neel Shah','1988-12-01','Male','9876500009','neel@example.com','Mumbai','2026-02-12'),
('Tara Mehta','2001-06-15','Female','9876500010','tara@example.com','Nashik','2023-09-18');

INSERT INTO Doctors (name, specialization, phone_number, email, available_days, consultation_fee, experience_years) VALUES
('Dr. Amit Rao','Cardiology','9000000001','amit@hospital.com','Mon,Wed,Fri',1200,18),
('Dr. Neha Shah','Dermatology','9000000002','neha@hospital.com','Tue,Thu,Sat',800,8),
('Dr. Kunal Mehta','Neurology','9000000003','kunal@hospital.com','Mon,Thu',1500,22),
('Dr. Priya Desai','Orthopedics','9000000004','priya@hospital.com','Tue,Wed,Fri',1000,12),
('Dr. Sameer Khan','Dermatology','9000000005','sameer@hospital.com','Mon,Sat',750,4),
('Dr. Ritu Joshi','General Medicine','9000000006','ritu@hospital.com','Mon,Tue,Wed,Thu,Fri',600,16);

INSERT INTO Departments (department_name) VALUES
('Cardiology'),('Dermatology'),('Neurology'),('Orthopedics'),('General Medicine');

INSERT INTO Doctor_Department VALUES
(1,1),(2,2),(3,3),(4,4),(5,2),(6,5);

INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status) VALUES
(1,1,'2025-01-15 10:00:00','Completed'),
(2,2,'2025-03-20 11:00:00','Completed'),
(3,3,'2025-07-01 09:30:00','Completed'),
(4,2,'2025-01-05 12:00:00','Completed'),
(5,4,'2025-08-20 15:00:00','Completed'),
(1,1,'2025-02-10 10:00:00','Completed'),
(6,5,'2026-02-10 11:00:00','Completed'),
(7,3,'2024-06-01 09:00:00','Completed'),
(8,6,'2025-11-10 13:00:00','Scheduled'),
(9,1,'2026-02-20 10:30:00','Scheduled'),
(10,4,'2023-10-02 14:00:00','Completed'),
(2,2,'2025-04-01 11:00:00','Cancelled'),
(3,3,'2025-07-10 09:30:00','Completed'),
(5,4,'2025-09-01 15:00:00','Completed'),
(1,6,'2025-03-01 10:00:00','Completed'),
(4,5,'2025-02-01 12:00:00','Completed'),
(7,6,'2024-06-15 09:00:00','Completed'),
(8,6,'2025-12-01 13:00:00','Completed'),
(9,1,'2026-03-01 10:30:00','Cancelled'),
(10,2,'2024-01-10 14:00:00','Completed');

INSERT INTO Medical_Records (patient_id, doctor_id, diagnosis, prescription, treatment_date, admission_date, discharge_date) VALUES
(1,1,'Hypertension','Lifestyle changes and medication','2025-01-15','2025-01-15','2025-01-17'),
(1,1,'Follow-up cardiac check','Continue medication','2025-02-10',NULL,NULL),
(1,6,'Routine check','Vitamin supplements','2025-03-01',NULL,NULL),
(1,1,'Cardiac review','Review in six months','2025-06-10',NULL,NULL),
(1,6,'General check','Exercise and diet','2025-08-10',NULL,NULL),
(2,2,'Skin allergy','Antihistamine','2025-03-20',NULL,NULL),
(2,2,'Dermatitis','Skin cream','2025-04-15',NULL,NULL),
(2,2,'Skin follow-up','Continue treatment','2025-05-20',NULL,NULL),
(3,3,'Migraine','Pain management','2025-07-01',NULL,NULL),
(3,3,'Migraine follow-up','Lifestyle advice','2025-07-10',NULL,NULL),
(3,3,'Neurological review','Further tests','2025-08-10',NULL,NULL),
(4,2,'Acne','Topical treatment','2025-01-05',NULL,NULL),
(4,5,'Skin review','Follow-up treatment','2025-02-01',NULL,NULL),
(5,4,'Knee pain','Physiotherapy','2025-08-20','2025-08-20','2025-08-25'),
(5,4,'Knee follow-up','Continue exercises','2025-09-01',NULL,NULL),
(6,5,'Skin rash','Medication','2026-02-10',NULL,NULL),
(7,3,'Neurological assessment','Diagnostic tests','2024-06-01','2024-06-01','2024-06-04'),
(7,6,'General follow-up','Routine care','2024-06-15',NULL,NULL),
(8,6,'General consultation','Medication','2025-11-10',NULL,NULL),
(8,6,'General follow-up','Diet advice','2025-12-01',NULL,NULL),
(10,4,'Fracture review','Rest','2023-10-02','2023-10-02','2023-10-12'),
(10,2,'Skin check','Routine care','2024-01-10',NULL,NULL);

INSERT INTO Billing (patient_id, appointment_id, amount, payment_status, payment_date) VALUES
(1,1,1200,'Paid','2025-01-15'),
(2,2,800,'Paid','2025-03-20'),
(3,3,1500,'Paid','2025-07-01'),
(4,4,800,'Paid','2025-01-05'),
(5,5,1000,'Pending',NULL),
(1,6,1200,'Paid','2025-02-10'),
(6,7,750,'Paid','2026-02-10'),
(7,8,1500,'Paid','2024-06-01'),
(8,9,600,'Pending',NULL),
(9,10,1200,'Pending',NULL),
(10,11,1000,'Paid','2023-10-02'),
(3,13,1500,'Paid','2025-07-10'),
(5,14,1000,'Paid','2025-09-01'),
(1,15,600,'Paid','2025-03-01'),
(4,16,750,'Paid','2025-02-01'),
(7,17,600,'Paid','2024-06-15'),
(8,18,600,'Paid','2025-12-01'),
(9,19,1200,'Cancelled',NULL),
(10,20,800,'Paid','2024-01-10');

-- ============================================================
-- 3. CRUD OPERATIONS
-- ============================================================

-- CREATE: Add a patient.
INSERT INTO Patients (name, dob, gender, phone_number, email, address, registration_date)
VALUES ('Maya Nair','1998-03-21','Female','9876500011','maya@example.com','Pune',CURDATE());

-- READ: View patients.
SELECT * FROM Patients;

-- UPDATE: Update a patient's address.
UPDATE Patients
SET address = 'Bengaluru'
WHERE patient_id = 1;

-- DELETE: Example delete of a cancelled appointment older than 6 months.
-- First preview matching rows. The delete is commented out to protect sample data.
SELECT * FROM Appointments
WHERE status = 'Cancelled'
  AND appointment_date < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- DELETE FROM Appointments
-- WHERE status = 'Cancelled'
--   AND appointment_date < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- ============================================================
-- 4. WHERE, HAVING, LIMIT
-- ============================================================

-- Patients registered in the last year.
SELECT *
FROM Patients
WHERE registration_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- Top 5 patients by total billed amount.
SELECT p.patient_id, p.name, SUM(b.amount) AS total_billed
FROM Patients p
JOIN Billing b ON p.patient_id = b.patient_id
WHERE b.payment_status <> 'Cancelled'
GROUP BY p.patient_id, p.name
ORDER BY total_billed DESC
LIMIT 5;

-- Doctors whose consultation fee is more than 1000.
SELECT * FROM Doctors
WHERE consultation_fee > 1000;

-- HAVING: departments with revenue greater than 1000.
SELECT d.department_name, SUM(b.amount) AS revenue
FROM Departments d
JOIN Doctor_Department dd ON d.department_id = dd.department_id
JOIN Doctors doc ON dd.doctor_id = doc.doctor_id
JOIN Appointments a ON doc.doctor_id = a.doctor_id
JOIN Billing b ON a.appointment_id = b.appointment_id
WHERE b.payment_status = 'Paid'
GROUP BY d.department_id, d.department_name
HAVING SUM(b.amount) > 1000;

-- ============================================================
-- 5. AND, OR, NOT
-- ============================================================

-- Scheduled appointments for doctor number 3.
SELECT *
FROM Appointments
WHERE status = 'Scheduled' AND doctor_id = 3;

-- Doctors specializing in Cardiology OR Neurology.
SELECT *
FROM Doctors
WHERE specialization = 'Cardiology' OR specialization = 'Neurology';

-- Patients who have NOT visited during the last year.
SELECT p.*
FROM Patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM Appointments a
    WHERE a.patient_id = p.patient_id
      AND a.status = 'Completed'
      AND a.appointment_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);

-- ============================================================
-- 6. ORDER BY, GROUP BY
-- ============================================================

-- Doctors sorted by specialization.
SELECT * FROM Doctors
ORDER BY specialization, name;

-- Number of completed appointments for each doctor.
SELECT doc.doctor_id, doc.name, COUNT(a.appointment_id) AS completed_visits
FROM Doctors doc
LEFT JOIN Appointments a
    ON doc.doctor_id = a.doctor_id AND a.status = 'Completed'
GROUP BY doc.doctor_id, doc.name
ORDER BY completed_visits DESC;

-- Revenue per department (paid bills).
SELECT d.department_name, SUM(b.amount) AS revenue
FROM Departments d
JOIN Doctor_Department dd ON d.department_id = dd.department_id
JOIN Doctors doc ON dd.doctor_id = doc.doctor_id
JOIN Appointments a ON doc.doctor_id = a.doctor_id
JOIN Billing b ON a.appointment_id = b.appointment_id
WHERE b.payment_status = 'Paid'
GROUP BY d.department_id, d.department_name
ORDER BY revenue DESC;

-- ============================================================
-- 7. AGGREGATE FUNCTIONS
-- ============================================================

-- Total paid revenue.
SELECT SUM(amount) AS total_revenue
FROM Billing
WHERE payment_status = 'Paid';

-- Most visited doctor (based on completed appointments).
SELECT doc.doctor_id, doc.name, COUNT(*) AS visit_count
FROM Doctors doc
JOIN Appointments a ON doc.doctor_id = a.doctor_id
WHERE a.status = 'Completed'
GROUP BY doc.doctor_id, doc.name
ORDER BY visit_count DESC
LIMIT 1;

-- Average consultation fee.
SELECT AVG(consultation_fee) AS average_consultation_fee
FROM Doctors;

-- Also demonstrate COUNT, MIN and MAX.
SELECT COUNT(*) AS doctor_count,
       MIN(consultation_fee) AS lowest_fee,
       MAX(consultation_fee) AS highest_fee
FROM Doctors;

-- ============================================================
-- 8. JOINs
-- ============================================================

-- INNER JOIN: Doctors and their department names.
SELECT doc.name AS doctor_name, d.department_name
FROM Doctors doc
INNER JOIN Doctor_Department dd ON doc.doctor_id = dd.doctor_id
INNER JOIN Departments d ON dd.department_id = d.department_id;

-- LEFT JOIN: All patients, including patients without completed appointments.
SELECT p.patient_id, p.name, a.appointment_id, a.status
FROM Patients p
LEFT JOIN Appointments a
    ON p.patient_id = a.patient_id AND a.status = 'Completed';

-- RIGHT JOIN: Appointments that have no matching billing row.
-- Since Billing's appointment_id is a foreign key, unmatched appointments are allowed.
SELECT a.appointment_id, a.patient_id, a.doctor_id, b.invoice_id
FROM Billing b
RIGHT JOIN Appointments a ON b.appointment_id = a.appointment_id
WHERE b.invoice_id IS NULL;

-- FULL OUTER JOIN equivalent in MySQL: LEFT JOIN + unmatched RIGHT side using UNION.
-- Show all patients and medical records, including unmatched records on either side.
SELECT p.patient_id, p.name, mr.record_id, mr.diagnosis
FROM Patients p
LEFT JOIN Medical_Records mr ON p.patient_id = mr.patient_id
UNION
SELECT p.patient_id, p.name, mr.record_id, mr.diagnosis
FROM Patients p
RIGHT JOIN Medical_Records mr ON p.patient_id = mr.patient_id;

-- ============================================================
-- 9. SUBQUERIES
-- ============================================================

-- Doctors who have handled more than 50 patients.
-- The sample data may not have 50 patients per doctor; the query is still valid.
SELECT doc.doctor_id, doc.name
FROM Doctors doc
WHERE doc.doctor_id IN (
    SELECT doctor_id
    FROM Appointments
    WHERE status = 'Completed'
    GROUP BY doctor_id
    HAVING COUNT(DISTINCT patient_id) > 50
);

-- Patient who has spent the most on paid invoices.
SELECT p.patient_id, p.name, SUM(b.amount) AS paid_total
FROM Patients p
JOIN Billing b ON p.patient_id = b.patient_id
WHERE b.payment_status = 'Paid'
GROUP BY p.patient_id, p.name
HAVING SUM(b.amount) = (
    SELECT MAX(patient_total)
    FROM (
        SELECT SUM(amount) AS patient_total
        FROM Billing
        WHERE payment_status = 'Paid'
        GROUP BY patient_id
    ) AS totals
);

-- Appointments with doctors specializing in Dermatology.
SELECT a.*
FROM Appointments a
WHERE a.doctor_id IN (
    SELECT doctor_id
    FROM Doctors
    WHERE specialization = 'Dermatology'
);

-- ============================================================
-- 10. DATE AND TIME FUNCTIONS
-- ============================================================

-- Number of appointments per month.
SELECT MONTH(appointment_date) AS month_number,
       MONTHNAME(appointment_date) AS month_name,
       COUNT(*) AS appointment_count
FROM Appointments
GROUP BY MONTH(appointment_date), MONTHNAME(appointment_date)
ORDER BY month_number;

-- Hospital stay duration in days (records with admission/discharge dates).
SELECT record_id, patient_id, admission_date, discharge_date,
       DATEDIFF(discharge_date, admission_date) AS stay_days
FROM Medical_Records
WHERE admission_date IS NOT NULL AND discharge_date IS NOT NULL;

-- Display treatment dates in DD-MM-YYYY format.
SELECT record_id, DATE_FORMAT(treatment_date, '%d-%m-%Y') AS formatted_date
FROM Medical_Records;

-- ============================================================
-- 11. STRING FUNCTIONS
-- ============================================================

-- Patient names in uppercase.
SELECT UPPER(name) AS uppercase_name
FROM Patients;

-- Trim whitespace from doctor names (also shown as an UPDATE).
SELECT TRIM(name) AS cleaned_name
FROM Doctors;

-- Fill missing phone numbers with "Not Available".
SELECT name, COALESCE(phone_number, 'Not Available') AS phone
FROM Patients;

-- ============================================================
-- 12. WINDOW FUNCTIONS
-- ============================================================

-- Rank doctors by number of completed visits.
SELECT name, completed_visits,
       RANK() OVER (ORDER BY completed_visits DESC) AS doctor_rank
FROM (
    SELECT doc.doctor_id, doc.name, COUNT(a.appointment_id) AS completed_visits
    FROM Doctors doc
    LEFT JOIN Appointments a
        ON doc.doctor_id = a.doctor_id AND a.status = 'Completed'
    GROUP BY doc.doctor_id, doc.name
) AS visit_counts;

-- Monthly paid revenue and cumulative revenue by month.
SELECT revenue_month, monthly_revenue,
       SUM(monthly_revenue) OVER (ORDER BY revenue_month) AS cumulative_revenue
FROM (
    SELECT DATE_FORMAT(payment_date, '%Y-%m') AS revenue_month,
           SUM(amount) AS monthly_revenue
    FROM Billing
    WHERE payment_status = 'Paid' AND payment_date IS NOT NULL
    GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
) AS monthly_data;

-- Running appointment count (ordered by appointment date).
SELECT appointment_id, appointment_date,
       COUNT(*) OVER (ORDER BY appointment_date, appointment_id) AS running_appointment_count
FROM Appointments;

-- ============================================================
-- 13. CASE EXPRESSIONS
-- ============================================================

-- Risk level based on the number of medical records for each patient.
SELECT p.patient_id, p.name, COUNT(mr.record_id) AS record_count,
       CASE
           WHEN COUNT(mr.record_id) > 5 THEN 'High'
           WHEN COUNT(mr.record_id) BETWEEN 3 AND 5 THEN 'Medium'
           ELSE 'Low'
       END AS Patient_Risk_Level
FROM Patients p
LEFT JOIN Medical_Records mr ON p.patient_id = mr.patient_id
GROUP BY p.patient_id, p.name;

-- Doctor experience category.
SELECT name, experience_years,
       CASE
           WHEN experience_years > 15 THEN 'Senior'
           WHEN experience_years BETWEEN 5 AND 15 THEN 'Mid-Level'
           ELSE 'Junior'
       END AS experience_category
FROM Doctors;


