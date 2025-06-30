-- Database Creation (Udhva)

CREATE DATABASE HospitalAppointmentSystem;
USE HospitalAppointmentSystem;

-- Creating Tables for Database (Udhva & Dhruv)

-- Patients Table
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Doctors Table

CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    experience INT NOT NULL,
    available_days VARCHAR(100) NOT NULL,  -- Example: 'Monday, Wednesday, Friday'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Appointments Table

CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE
);

-- Payments Table

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT UNIQUE,
    patient_id INT,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Cash', 'Credit Card', 'Insurance'),
    status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE
);

-- MedicalRecords Table

CREATE TABLE MedicalRecords (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_id INT,
    diagnosis TEXT NOT NULL,
    prescription TEXT NOT NULL,
    record_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

-- Departments Table 

CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- AppointmentsHistory Table

CREATE TABLE AppointmentsHistory (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

-- AppointmentTypes Table

CREATE TABLE AppointmentTypes (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL
);

-- InsuranceProviders Table

CREATE TABLE InsuranceProviders (
    provider_id INT AUTO_INCREMENT PRIMARY KEY,
    provider_name VARCHAR(100) NOT NULL,
    contact_info TEXT
);

-- PaymentsHistory Table

CREATE TABLE PaymentsHistory (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT,
    amount DECIMAL(10,2),
    payment_date TIMESTAMP,
    status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id) ON DELETE CASCADE
);

-- Prescriptions Table 

CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    doctor_id INT,
    medication_name VARCHAR(100),
    dosage VARCHAR(100),
    instructions TEXT,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- DoctorsSchedules Table
CREATE TABLE DoctorsSchedules (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT,
    day VARCHAR(15),
    start_time TIME,
    end_time TIME,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- PatientVisits Table
CREATE TABLE PatientVisits (
    visit_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    visit_date DATETIME,
    symptoms TEXT,
    diagnosis TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- EmergencyContacts Table
CREATE TABLE EmergencyContacts (
    emergency_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    contact_name VARCHAR(100),
    relationship VARCHAR(50),
    phone_number VARCHAR(15),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- LabResults Table
CREATE TABLE LabResults (
    lab_result_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    test_type VARCHAR(100),
    result VARCHAR(255),
    result_date DATETIME,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- Staff Table
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    role VARCHAR(50),
    department VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(100),
    hire_date DATE
);

-- RoomAssignments Table
CREATE TABLE RoomAssignments (
    room_assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    room_number VARCHAR(10),
    assignment_date DATETIME,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);






-- Data Insertion (Udhva)

INSERT INTO Patients (first_name, last_name, dob, gender, phone, email, address)
VALUES
('John', 'Doe', '1980-05-12', 'Male', '9876543210', 'john.doe@example.com', '123 Oak Street, Springfield, IL'),
('Jane', 'Smith', '1992-07-22', 'Female', '9123456789', 'jane.smith@example.com', '456 Pine Avenue, Chicago, IL'),
('Emily', 'Davis', '1985-03-11', 'Female', '9456728390', 'emily.davis@example.com', '789 Maple Road, Decatur, IL'),
('Michael', 'Johnson', '1978-10-30', 'Male', '9735462100', 'michael.johnson@example.com', '321 Elm Drive, Naperville, IL'),
('Sarah', 'Lee', '1990-02-17', 'Female', '9638527410', 'sarah.lee@example.com', '654 Cedar Lane, Joliet, IL'),
('David', 'Martinez', '1987-04-05', 'Male', '9867314200', 'david.martinez@example.com', '876 Birch Boulevard, Peoria, IL'),
('Laura', 'Gonzalez', '1983-08-14', 'Female', '9513586740', 'laura.gonzalez@example.com', '132 Cherry Street, Rockford, IL'),
('James', 'Wilson', '1995-01-25', 'Male', '9075468213', 'james.wilson@example.com', '890 Ashwood Drive, Champaign, IL'),
('Maria', 'Taylor', '1972-09-19', 'Female', '9236874310', 'maria.taylor@example.com', '432 Willow Way, Bloomington, IL'),
('William', 'Brown', '1991-11-12', 'Male', '9123675489', 'william.brown@example.com', '567 Redwood Road, Normal, IL');

INSERT INTO Doctors (first_name, last_name, specialization, phone, email, experience, available_days)
VALUES
('Dr. Robert', 'White', 'Cardiology', '9134567890', 'dr.robert.white@example.com', 15, 'Monday, Wednesday, Friday'),
('Dr. Emma', 'Green', 'Dermatology', '9235678901', 'dr.emma.green@example.com', 10, 'Tuesday, Thursday, Saturday'),
('Dr. Liam', 'Clark', 'Neurology', '9312345678', 'dr.liam.clark@example.com', 12, 'Monday, Thursday, Sunday'),
('Dr. Olivia', 'Adams', 'Pediatrics', '9456789012', 'dr.olivia.adams@example.com', 8, 'Wednesday, Friday, Saturday'),
('Dr. Daniel', 'Scott', 'Orthopedics', '9547890123', 'dr.daniel.scott@example.com', 20, 'Monday, Tuesday, Thursday'),
('Dr. Lily', 'Baker', 'General Medicine', '9078234567', 'dr.lily.baker@example.com', 18, 'Monday, Wednesday, Friday'),
('Dr. Noah', 'Hall', 'Surgery', '9134786235', 'dr.noah.hall@example.com', 22, 'Tuesday, Thursday, Sunday'),
('Dr. Ava', 'Young', 'Psychiatry', '9312456789', 'dr.ava.young@example.com', 10, 'Wednesday, Saturday, Sunday'),
('Dr. Mason', 'King', 'Gastroenterology', '9098765432', 'dr.mason.king@example.com', 14, 'Monday, Thursday, Friday'),
('Dr. Isabella', 'Wright', 'Ophthalmology', '9123894567', 'dr.isabella.wright@example.com', 11, 'Tuesday, Friday, Saturday');

INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, notes)
VALUES
(1, 2, '2025-03-22 10:00:00', 'Scheduled', 'Skin rash on arm'),
(2, 1, '2025-03-23 14:00:00', 'Scheduled', 'Heart palpitations and dizziness'),
(3, 4, '2025-03-24 09:30:00', 'Scheduled', 'Routine pediatric check-up'),
(4, 3, '2025-03-25 16:00:00', 'Scheduled', 'Headaches and sleep disturbances'),
(5, 5, '2025-03-26 11:00:00', 'Scheduled', 'Knee pain after exercise'),
(6, 6, '2025-03-27 15:30:00', 'Scheduled', 'Annual health check-up'),
(7, 7, '2025-03-28 08:45:00', 'Scheduled', 'Consultation for anxiety'),
(8, 8, '2025-03-29 17:00:00', 'Scheduled', 'Fatigue and mood swings'),
(9, 9, '2025-03-30 10:15:00', 'Scheduled', 'Stomach discomfort after meals'),
(10, 10, '2025-03-31 13:30:00', 'Scheduled', 'Routine eye exam');

INSERT INTO Payments (appointment_id, patient_id, amount, payment_date, payment_method, status)
VALUES
(1, 1, 120.50, '2025-03-22 11:00:00', 'Credit Card', 'Completed'),
(2, 2, 150.00, '2025-03-23 14:30:00', 'Insurance', 'Completed'),
(3, 3, 80.00, '2025-03-24 10:00:00', 'Cash', 'Completed'),
(4, 4, 100.00, '2025-03-25 17:15:00', 'Credit Card', 'Completed'),
(5, 5, 90.00, '2025-03-26 12:00:00', 'Insurance', 'Pending'),
(6, 6, 200.00, '2025-03-27 16:00:00', 'Cash', 'Completed'),
(7, 7, 75.00, '2025-03-28 09:00:00', 'Credit Card', 'Pending'),
(8, 8, 110.00, '2025-03-29 18:00:00', 'Insurance', 'Completed'),
(9, 9, 85.00, '2025-03-30 11:30:00', 'Credit Card', 'Completed'),
(10, 10, 150.00, '2025-03-31 14:30:00', 'Cash', 'Completed');

INSERT INTO MedicalRecords (patient_id, doctor_id, appointment_id, diagnosis, prescription)
VALUES
(1, 2, 1, 'Skin rash', 'Hydrocortisone cream'),
(2, 1, 2, 'Palpitations', 'Beta-blockers'),
(3, 4, 3, 'Pediatric routine check-up', 'Multivitamins'),
(4, 3, 4, 'Chronic headache', 'Pain relievers, sleep hygiene advice'),
(5, 5, 5, 'Knee injury', 'Rest, ice, compression, elevation'),
(6, 6, 6, 'Routine check-up', 'Healthy diet, exercise plan'),
(7, 7, 7, 'Anxiety disorder', 'Therapy, anxiety medications'),
(8, 8, 8, 'Fatigue and low mood', 'Antidepressants'),
(9, 9, 9, 'Gastrointestinal discomfort', 'Probiotics, dietary changes'),
(10, 10, 10, 'Routine eye exam', 'Glasses prescription');


INSERT INTO Departments (department_name)
VALUES
('Cardiology'),
('Dermatology'),
('Neurology'),
('Pediatrics'),
('Orthopedics'),
('General Medicine'),
('Surgery'),
('Psychiatry'),
('Gastroenterology'),
('Ophthalmology');

INSERT INTO AppointmentsHistory (appointment_id, patient_id, doctor_id, appointment_date, status)
VALUES
(1, 1, 2, '2025-03-22 10:00:00', 'Completed'),
(2, 2, 1, '2025-03-23 14:00:00', 'Completed'),
(3, 3, 4, '2025-03-24 09:30:00', 'Completed'),
(4, 4, 3, '2025-03-25 16:00:00', 'Completed'),
(5, 5, 5, '2025-03-26 11:00:00', 'Completed'),
(6, 6, 6, '2025-03-27 15:30:00', 'Completed'),
(7, 7, 7, '2025-03-28 08:45:00', 'Completed'),
(8, 8, 8, '2025-03-29 17:00:00', 'Completed'),
(9, 9, 9, '2025-03-30 10:15:00', 'Completed'),
(10, 10, 10, '2025-03-31 13:30:00', 'Completed');

INSERT INTO AppointmentTypes (type_name)
VALUES
('Consultation'),
('Follow-up'),
('Emergency'),
('Routine Check-up'),
('Specialized Consultation'),
('Surgery'),
('Therapy'),
('Laboratory Test'),
('Diagnostic Imaging'),
('Post-surgery Follow-up');


INSERT INTO InsuranceProviders (provider_name, contact_info)
VALUES
('Blue Cross Blue Shield', 'Contact: 800-123-4567'),
('Aetna', 'Contact: 800-234-5678'),
('Cigna', 'Contact: 800-345-6789'),
('UnitedHealthcare', 'Contact: 800-456-7890'),
('Humana', 'Contact: 800-567-8901'),
('Kaiser Permanente', 'Contact: 800-678-9012'),
('Anthem', 'Contact: 800-789-0123'),
('MetLife', 'Contact: 800-890-1234'),
('Prudential', 'Contact: 800-901-2345'),
('Guardian Life', 'Contact: 800-012-3456');

INSERT INTO PaymentsHistory (payment_id, amount, payment_date, status)
VALUES
(1, 120.50, '2025-03-22 11:30:00', 'Completed'),
(2, 150.00, '2025-03-23 14:30:00', 'Completed'),
(3, 80.00, '2025-03-24 10:30:00', 'Completed'),
(4, 100.00, '2025-03-25 17:30:00', 'Completed'),
(5, 90.00, '2025-03-26 12:30:00', 'Pending'),
(6, 200.00, '2025-03-27 16:30:00', 'Completed'),
(7, 75.00, '2025-03-28 09:30:00', 'Pending'),
(8, 110.00, '2025-03-29 18:30:00', 'Completed'),
(9, 85.00, '2025-03-30 11:45:00', 'Completed'),
(10, 150.00, '2025-03-31 14:45:00', 'Completed');


INSERT INTO Prescriptions (appointment_id, doctor_id, medication_name, dosage, instructions)
VALUES
(1, 2, 'Hydrocortisone cream', 'Apply twice daily', 'Use for rash on the arm'),
(2, 1, 'Beta-blockers', '1 tablet daily', 'Take after meals for palpitations'),
(3, 4, 'Multivitamins', '1 tablet daily', 'For pediatric check-up and growth support'),
(4, 3, 'Pain relievers', '1 tablet every 6 hours', 'For chronic headaches'),
(5, 5, 'Ice pack', 'Apply to knee', 'Use every 2 hours for 20 minutes'),
(6, 6, 'Vitamin D supplements', '1 tablet weekly', 'For general health and bone support'),
(7, 7, 'Anxiolytic medications', 'Take as needed', 'For anxiety management'),
(8, 8, 'Antidepressants', '1 tablet daily', 'For mood regulation and fatigue'),
(9, 9, 'Probiotics', '1 capsule daily', 'For gastrointestinal health'),
(10, 10, 'Glasses prescription', 'N/A', 'Use for better vision');


INSERT INTO DoctorsSchedules (doctor_id, day, start_time, end_time)
VALUES
(1, 'Monday', '09:00:00', '12:00:00'),
(2, 'Tuesday', '10:00:00', '13:00:00'),
(3, 'Wednesday', '08:00:00', '12:00:00'),
(4, 'Thursday', '11:00:00', '14:00:00'),
(5, 'Friday', '09:00:00', '13:00:00'),
(6, 'Monday', '10:00:00', '14:00:00'),
(7, 'Wednesday', '09:00:00', '12:00:00'),
(8, 'Thursday', '13:00:00', '17:00:00'),
(9, 'Friday', '08:00:00', '12:00:00'),
(10, 'Saturday', '14:00:00', '17:00:00');

INSERT INTO PatientVisits (patient_id, doctor_id, visit_date, symptoms, diagnosis)
VALUES
(1, 2, '2025-03-22 09:00:00', 'Skin rash', 'Contact dermatitis'),
(2, 1, '2025-03-23 14:30:00', 'Heart palpitations', 'Arrhythmia'),
(3, 4, '2025-03-24 10:15:00', 'Routine pediatric check-up', 'Healthy growth'),
(4, 3, '2025-03-25 16:00:00', 'Frequent headaches', 'Migraine'),
(5, 5, '2025-03-26 11:30:00', 'Knee pain', 'Sprain'),
(6, 6, '2025-03-27 15:00:00', 'General check-up', 'Normal health'),
(7, 7, '2025-03-28 08:30:00', 'Anxiety and stress', 'Generalized anxiety disorder'),
(8, 8, '2025-03-29 17:00:00', 'Fatigue, low mood', 'Depression'),
(9, 9, '2025-03-30 10:00:00', 'Stomach discomfort', 'Irritable bowel syndrome'),
(10, 10, '2025-03-31 13:00:00', 'Routine eye exam', 'Mild astigmatism');

INSERT INTO EmergencyContacts (patient_id, contact_name, relationship, phone_number)
VALUES
(1, 'Jane Doe', 'Wife', '9876543210'),
(2, 'Michael Smith', 'Brother', '9123456789'),
(3, 'Emily Davis', 'Mother', '9456728390'),
(4, 'Sarah Johnson', 'Wife', '9735462100'),
(5, 'David Lee', 'Father', '9638527410'),
(6, 'Laura Martinez', 'Sister', '9513586740'),
(7, 'James Gonzalez', 'Husband', '9075468213'),
(8, 'Maria Wilson', 'Friend', '9236874310'),
(9, 'William Brown', 'Brother', '9123675489'),
(10, 'Isabella Taylor', 'Mother', '9123894567');

INSERT INTO LabResults (appointment_id, test_type, result, result_date)
VALUES
(1, 'Blood Test', 'Normal', '2025-03-22 11:00:00'),
(2, 'ECG', 'Abnormal - Mild arrhythmia', '2025-03-23 15:00:00'),
(3, 'Urine Test', 'Normal', '2025-03-24 12:00:00'),
(4, 'MRI Scan', 'No abnormalities found', '2025-03-25 17:30:00'),
(5, 'X-Ray', 'Mild sprain in knee', '2025-03-26 14:00:00'),
(6, 'Blood Test', 'Normal', '2025-03-27 16:30:00'),
(7, 'Psychiatric Evaluation', 'Anxiety and stress', '2025-03-28 09:00:00'),
(8, 'Blood Test', 'Low iron levels', '2025-03-29 18:30:00'),
(9, 'Endoscopy', 'Mild gastritis', '2025-03-30 12:00:00'),
(10, 'Eye Test', 'Presbyopia', '2025-03-31 14:30:00');

INSERT INTO Staff (first_name, last_name, role, department, phone, email, hire_date)
VALUES
('John', 'Miller', 'Nurse', 'Cardiology', '9876543210', 'john.miller@hospital.com', '2020-04-15'),
('Sarah', 'Williams', 'Receptionist', 'General', '9123456789', 'sarah.williams@hospital.com', '2018-09-10'),
('David', 'Wilson', 'Technician', 'Radiology', '9456728390', 'david.wilson@hospital.com', '2021-03-23'),
('Emily', 'Martinez', 'Pharmacist', 'Pharmacy', '9735462100', 'emily.martinez@hospital.com', '2019-11-05'),
('Michael', 'Jones', 'Nurse', 'Orthopedics', '9638527410', 'michael.jones@hospital.com', '2022-07-30'),
('Laura', 'Gonzalez', 'Administrator', 'General', '9513586740', 'laura.gonzalez@hospital.com', '2017-06-14'),
('James', 'Taylor', 'Medical Assistant', 'Pediatrics', '9075468213', 'james.taylor@hospital.com', '2023-02-20'),
('Isabella', 'Clark', 'Laboratory Technician', 'Laboratory', '9236874310', 'isabella.clark@hospital.com', '2021-12-11'),
('William', 'Brown', 'Surgeon', 'Surgery', '9123675489', 'william.brown@hospital.com', '2015-08-17'),
('Olivia', 'Davis', 'Psychiatrist', 'Psychiatry', '9123894567', 'olivia.davis@hospital.com', '2016-03-12');

INSERT INTO RoomAssignments (patient_id, room_number, assignment_date)
VALUES
(1, '101', '2025-03-22 09:00:00'),
(2, '102', '2025-03-23 14:30:00'),
(3, '103', '2025-03-24 10:15:00'),
(4, '104', '2025-03-25 16:00:00'),
(5, '105', '2025-03-26 11:30:00'),
(6, '106', '2025-03-27 15:00:00'),
(7, '107', '2025-03-28 08:30:00'),
(8, '108', '2025-03-29 17:00:00'),
(9, '109', '2025-03-30 10:00:00'),
(10, '110', '2025-03-31 13:00:00');

--Count Total Appointments by Status
SELECT status, COUNT(*) AS total_appointments 
FROM Appointments 
GROUP BY status;

--Upcoming Appointments (Future Dates Only)
SELECT * FROM Appointments 
WHERE appointment_date >= NOW();

--Total Revenue from Payments
SELECT SUM(amount) AS total_revenue FROM Payments;

--total appointment per month
SELECT DATE_FORMAT(appointment_date, '%Y-%m') AS month, COUNT(*) AS total_appointments
FROM Appointments
GROUP BY month
ORDER BY month DESC;

-- Get Patients Who Have Spent the Most on Payments
SELECT P.patient_id, P.first_name, P.last_name, SUM(Pay.amount) AS total_spent
FROM Patients P
JOIN Appointments A ON P.patient_id = A.patient_id
JOIN Payments Pay ON A.appointment_id = Pay.appointment_id
GROUP BY P.patient_id
ORDER BY total_spent DESC
LIMIT 5;

--Patient Details for a Specific Appointment
SELECT * 
FROM Patients P
JOIN Appointments A ON P.patient_id = A.patient_id
WHERE A.appointment_id = 5;

CREATE TABLE DoctorDepartments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT,
    department_id INT,
    assignment_date DATE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE CASCADE
);

INSERT INTO DoctorDepartments (doctor_id, department_id, assignment_date)
VALUES
(1, 1, '2025-02-10'),  -- Dr. Robert White → Cardiology
(2, 2, '2025-03-15'),  -- Dr. Emma Green → Dermatology
(3, 3, '2025-04-20'),  -- Dr. Liam Clark → Neurology
(4, 4, '2025-05-05'),  -- Dr. Olivia Adams → Pediatrics
(5, 5, '2025-06-18'),  -- Dr. Daniel Scott → Orthopedics
(6, 6, '2025-07-22'),  -- Dr. Lily Baker → General Medicine
(7, 7, '2025-08-30'),  -- Dr. Noah Hall → Surgery
(8, 8, '2025-09-12'),  -- Dr. Ava Young → Psychiatry
(9, 9, '2025-10-25'),  -- Dr. Mason King → Gastroenterology
(10, 10, '2025-11-08'); -- Dr. Isabella Wright → Ophthalmology

DROP database ;
show tables;
describe appointmenttypes;
use hospitalappointmentsystem;


