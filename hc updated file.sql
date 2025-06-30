-- Database Creation
CREATE DATABASE HealthyConnect;
USE HealthyConnect;
DROP DATABASE HealthyConnect;

-- Core Tables

-- Patients Table (Core Entity)
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address TEXT NOT NULL,
    insurance_provider_id INT NULL,
    policy_number VARCHAR(50) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- InsuranceProviders Table (Connected to Patients)
CREATE TABLE InsuranceProviders (
    provider_id INT AUTO_INCREMENT PRIMARY KEY,
    provider_name VARCHAR(100) NOT NULL,
    contact_phone VARCHAR(15) NOT NULL,
    contact_email VARCHAR(100),
    website VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Departments Table (Core Entity)
CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    description TEXT,
    head_doctor_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Doctors Table (Connected to Departments)
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department_id INT NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    experience INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Update Departments foreign key after Doctors is created
ALTER TABLE Departments
ADD FOREIGN KEY (head_doctor_id) REFERENCES Doctors(doctor_id);

-- AppointmentTypes Table (Reference Table)
CREATE TABLE AppointmentTypes (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    description TEXT,
    base_price DECIMAL(10,2) NOT NULL,
    duration_minutes INT NOT NULL
);

-- Rooms Table (Resource Table)
CREATE TABLE Rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type ENUM('Consultation', 'Examination', 'Procedure', 'Hospital') NOT NULL,
    department_id INT NULL,
    capacity INT DEFAULT 1,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Appointments Table (Core Transaction Table)
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    room_id INT NULL,
    type_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    FOREIGN KEY (type_id) REFERENCES AppointmentTypes(type_id)
);

-- Payments Table (Connected to Appointments and Insurance)
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    patient_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL DEFAULT 0,
    insurance_covered DECIMAL(10,2) DEFAULT 0,
    payment_date TIMESTAMP NULL,
    payment_method ENUM('Cash', 'Credit Card', 'Debit Card', 'Insurance', 'Bank Transfer') NULL,
    status ENUM('Pending', 'Partial', 'Completed', 'Failed', 'Refunded') DEFAULT 'Pending',
    insurance_claim_id VARCHAR(50) NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- MedicalRecords Table (Connected to Appointments)
CREATE TABLE MedicalRecords (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT NULL,
    diagnosis TEXT NOT NULL,
    treatment TEXT,
    notes TEXT,
    record_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- Prescriptions Table (Connected to Medical Records)
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    record_id INT NOT NULL,
    medication_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(100) NOT NULL,
    frequency VARCHAR(100) NOT NULL,
    duration VARCHAR(100) NOT NULL,
    instructions TEXT,
    prescribed_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Active', 'Completed', 'Cancelled') DEFAULT 'Active',
    FOREIGN KEY (record_id) REFERENCES MedicalRecords(record_id)
);

-- LabTests Table (Reference Table)
CREATE TABLE LabTests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    test_name VARCHAR(100) NOT NULL,
    description TEXT,
    department_id INT NOT NULL,
    standard_cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- LabOrders Table (Connected to Appointments)
CREATE TABLE LabOrders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    test_id INT NOT NULL,
    doctor_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Ordered', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Ordered',
    notes TEXT,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id),
    FOREIGN KEY (test_id) REFERENCES LabTests(test_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- LabResults Table (Connected to Lab Orders)
CREATE TABLE LabResults (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    result_value VARCHAR(255) NOT NULL,
    result_notes TEXT,
    result_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    technician_id INT NULL,
    FOREIGN KEY (order_id) REFERENCES LabOrders(order_id)
);

-- Staff Table (Connected to Departments)
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(50) NOT NULL,
    department_id INT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- EmergencyContacts Table (Connected to Patients)
CREATE TABLE EmergencyContacts (
    contact_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    contact_name VARCHAR(100) NOT NULL,
    relationship VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- DoctorSchedules Table (Connected to Doctors)
CREATE TABLE DoctorSchedules (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_recurring BOOLEAN DEFAULT TRUE,
    valid_from DATE NOT NULL,
    valid_to DATE NULL,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- DoctorTimeOff Table (Connected to Doctors)
CREATE TABLE DoctorTimeOff (
    timeoff_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason VARCHAR(255),
    is_approved BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- PatientAllergies Table (Connected to Patients)
CREATE TABLE PatientAllergies (
    allergy_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    allergy_name VARCHAR(100) NOT NULL,
    severity ENUM('Mild', 'Moderate', 'Severe') NOT NULL,
    reaction_description TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- MedicationInventory Table (Standalone but connected to Prescriptions)
CREATE TABLE MedicationInventory (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    medication_name VARCHAR(100) NOT NULL,
    generic_name VARCHAR(100),
    dosage_form VARCHAR(50) NOT NULL,
    strength VARCHAR(50) NOT NULL,
    manufacturer VARCHAR(100),
    current_stock INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 10,
    unit_price DECIMAL(10,2) NOT NULL,
    last_restocked DATE
);

-- Add foreign key from Patients to InsuranceProviders
ALTER TABLE Patients
ADD FOREIGN KEY (insurance_provider_id) REFERENCES InsuranceProviders(provider_id);

ALTER TABLE Prescriptions
ADD COLUMN medication_id INT NULL AFTER record_id,
ADD CONSTRAINT fk_prescription_medication
FOREIGN KEY (medication_id) REFERENCES MedicationInventory(medication_id);












-- Insert into InsuranceProviders
INSERT INTO InsuranceProviders (provider_name, contact_phone, contact_email, website) VALUES
('Blue Cross', '800-555-1001', 'info@bluecross.com', 'www.bluecross.com'),
('Aetna', '800-555-1002', 'support@aetna.com', 'www.aetna.com'),
('United Health', '800-555-1003', 'help@unitedhealth.com', 'www.unitedhealth.com'),
('Medicare', '800-555-1004', 'contact@medicare.gov', 'www.medicare.gov'),
('Kaiser Permanente', '800-555-1005', 'service@kaiser.org', 'www.kaiser.org');

-- Insert into Departments
INSERT INTO Departments (department_name, description) VALUES
('Cardiology', 'Heart and cardiovascular system care'),
('Neurology', 'Nervous system disorders'),
('Pediatrics', 'Child healthcare'),
('Orthopedics', 'Musculoskeletal system'),
('Oncology', 'Cancer treatment and care'),
('Radiology', 'Medical imaging'),
('Laboratory', 'Diagnostic testing');

-- Insert into Doctors
INSERT INTO Doctors (first_name, last_name, department_id, specialization, phone, email, license_number, experience) VALUES
('John', 'Smith', 1, 'Cardiologist', '555-1001', 'jsmith@hospital.com', 'MD12345', 15),
('Sarah', 'Johnson', 2, 'Neurologist', '555-1002', 'sjohnson@hospital.com', 'MD12346', 12),
('Michael', 'Williams', 3, 'Pediatrician', '555-1003', 'mwilliams@hospital.com', 'MD12347', 10),
('Emily', 'Brown', 4, 'Orthopedic Surgeon', '555-1004', 'ebrown@hospital.com', 'MD12348', 8),
('David', 'Jones', 5, 'Oncologist', '555-1005', 'djones@hospital.com', 'MD12349', 20),
('Jennifer', 'Davis', 1, 'Cardiologist', '555-1006', 'jdavis@hospital.com', 'MD12350', 7),
('Robert', 'Miller', 6, 'Radiologist', '555-1007', 'rmiller@hospital.com', 'MD12351', 9);

-- Update Departments with head doctors
UPDATE Departments SET head_doctor_id = 1 WHERE department_id = 1;
UPDATE Departments SET head_doctor_id = 2 WHERE department_id = 2;
UPDATE Departments SET head_doctor_id = 3 WHERE department_id = 3;
UPDATE Departments SET head_doctor_id = 4 WHERE department_id = 4;
UPDATE Departments SET head_doctor_id = 5 WHERE department_id = 5;
UPDATE Departments SET head_doctor_id = 7 WHERE department_id = 6;

-- Insert into Patients
INSERT INTO Patients (first_name, last_name, dob, gender, phone, email, address, insurance_provider_id, policy_number) VALUES
('James', 'Wilson', '1980-05-15', 'Male', '555-2001', 'james.wilson@email.com', '123 Main St, Anytown', 1, 'BC123456789'),
('Mary', 'Taylor', '1975-08-22', 'Female', '555-2002', 'mary.taylor@email.com', '456 Oak Ave, Somewhere', 2, 'AE987654321'),
('William', 'Anderson', '1990-03-10', 'Male', '555-2003', 'william.anderson@email.com', '789 Pine Rd, Nowhere', 3, 'UH456789123'),
('Patricia', 'Thomas', '1985-11-30', 'Female', '555-2004', 'patricia.thomas@email.com', '321 Elm St, Anywhere', 1, 'BC987654321'),
('Richard', 'Jackson', '1972-07-04', 'Male', '555-2005', 'richard.jackson@email.com', '654 Maple Dr, Everywhere', NULL, NULL),
('Jennifer', 'White', '1995-02-18', 'Female', '555-2006', 'jennifer.white@email.com', '987 Cedar Ln, Someplace', 4, 'MC123456789'),
('Charles', 'Harris', '1988-09-25', 'Male', '555-2007', 'charles.harris@email.com', '159 Birch Blvd, Noplace', 5, 'KP987654321'),
('Linda', 'Martin', '1978-12-05', 'Female', '555-2008', 'linda.martin@email.com', '753 Spruce Ct, Anyplace', 2, 'AE123456789'),
('Thomas', 'Garcia', '1965-06-20', 'Male', '555-2009', 'thomas.garcia@email.com', '852 Willow Way, Everyplace', NULL, NULL),
('Susan', 'Martinez', '1992-04-12', 'Female', '555-2010', 'susan.martinez@email.com', '963 Aspen Trl, Nowhere', 3, 'UH789123456');

-- Insert into EmergencyContacts
INSERT INTO EmergencyContacts (patient_id, contact_name, relationship, phone_number, is_primary) VALUES
(1, 'Lisa Wilson', 'Spouse', '555-3001', TRUE),
(2, 'Robert Taylor', 'Husband', '555-3002', TRUE),
(3, 'Jessica Anderson', 'Mother', '555-3003', TRUE),
(4, 'Daniel Thomas', 'Father', '555-3004', TRUE),
(5, 'Karen Jackson', 'Wife', '555-3005', TRUE),
(6, 'Mark White', 'Brother', '555-3006', TRUE),
(7, 'Nancy Harris', 'Sister', '555-3007', TRUE),
(8, 'Paul Martin', 'Husband', '555-3008', TRUE),
(9, 'Maria Garcia', 'Wife', '555-3009', TRUE),
(10, 'Kevin Martinez', 'Father', '555-3010', TRUE),
(1, 'Michael Wilson', 'Son', '555-3011', FALSE),
(3, 'Sarah Anderson', 'Sister', '555-3012', FALSE);

-- Insert into PatientAllergies
INSERT INTO PatientAllergies (patient_id, allergy_name, severity, reaction_description) VALUES
(1, 'Penicillin', 'Severe', 'Anaphylaxis'),
(2, 'Peanuts', 'Severe', 'Difficulty breathing, hives'),
(3, 'Shellfish', 'Moderate', 'Swelling, itching'),
(4, 'Latex', 'Mild', 'Skin irritation'),
(5, 'Aspirin', 'Moderate', 'Stomach pain, nausea'),
(6, 'Iodine', 'Severe', 'Anaphylaxis'),
(7, 'Sulfa drugs', 'Moderate', 'Rash, fever'),
(8, 'Eggs', 'Mild', 'Hives'),
(9, 'Dust mites', 'Mild', 'Sneezing, runny nose'),
(10, 'Pollen', 'Moderate', 'Sneezing, itchy eyes');

-- Insert into Rooms
INSERT INTO Rooms (room_number, room_type, department_id, capacity) VALUES
('101', 'Consultation', 1, 1),
('102', 'Consultation', 2, 1),
('103', 'Consultation', 3, 1),
('104', 'Consultation', 4, 1),
('105', 'Consultation', 5, 1),
('201', 'Examination', 1, 2),
('202', 'Examination', 2, 2),
('203', 'Examination', 3, 2),
('204', 'Examination', 4, 2),
('205', 'Examination', 5, 2),
('301', 'Procedure', 1, 1),
('302', 'Procedure', 2, 1),
('303', 'Procedure', 3, 1),
('304', 'Procedure', 4, 1),
('305', 'Procedure', 5, 1),
('401', 'Hospital', NULL, 4),
('402', 'Hospital', NULL, 2),
('403', 'Hospital', NULL, 1);

-- Insert into AppointmentTypes
INSERT INTO AppointmentTypes (type_name, description, base_price, duration_minutes) VALUES
('Initial Consultation', 'First visit with specialist', 150.00, 30),
('Follow-up', 'Routine follow-up visit', 75.00, 15),
('Annual Checkup', 'Comprehensive annual exam', 200.00, 60),
('Procedure', 'Medical procedure', 300.00, 60),
('Emergency', 'Urgent care visit', 250.00, 30),
('Lab Test', 'Diagnostic testing', 100.00, 15),
('Vaccination', 'Immunization', 50.00, 10);

-- Insert into Appointments
INSERT INTO Appointments (patient_id, doctor_id, room_id, type_id, appointment_date, end_time, status, notes) VALUES
(1, 1, 1, 1, '2023-06-01 09:00:00', '2023-06-01 09:30:00', 'Completed', 'Patient complained of chest pain'),
(2, 2, 2, 1, '2023-06-01 10:00:00', '2023-06-01 10:30:00', 'Completed', 'Headaches and dizziness'),
(3, 3, 3, 3, '2023-06-02 09:00:00', '2023-06-02 10:00:00', 'Completed', 'Annual pediatric checkup'),
(4, 4, 4, 2, '2023-06-02 11:00:00', '2023-06-02 11:15:00', 'Completed', 'Follow-up on knee surgery'),
(5, 5, 5, 1, '2023-06-03 14:00:00', '2023-06-03 14:30:00', 'Completed', 'Concerns about mole'),
(6, 1, 1, 2, '2023-06-03 15:00:00', '2023-06-03 15:15:00', 'Completed', 'Follow-up on heart medication'),
(7, 2, 2, 4, '2023-06-04 10:00:00', '2023-06-04 11:00:00', 'Completed', 'Spinal tap procedure'),
(8, 3, 3, 3, '2023-06-04 13:00:00', '2023-06-04 14:00:00', 'Completed', 'Child wellness exam'),
(9, 4, 4, 5, '2023-06-05 08:00:00', '2023-06-05 08:30:00', 'Completed', 'Emergency for broken arm'),
(10, 5, 5, 6, '2023-06-05 11:00:00', '2023-06-05 11:15:00', 'Completed', 'Blood work ordered'),
(1, 1, 1, 2, '2023-06-15 09:00:00', '2023-06-15 09:15:00', 'Scheduled', 'Follow-up on heart condition'),
(2, 2, 2, 2, '2023-06-15 10:00:00', '2023-06-15 10:15:00', 'Scheduled', 'Follow-up on migraine treatment'),
(3, 3, 3, 7, '2023-06-16 09:00:00', '2023-06-16 09:10:00', 'Scheduled', 'Flu vaccination'),
(4, 4, 4, 4, '2023-06-16 11:00:00', '2023-06-16 12:00:00', 'Scheduled', 'Knee injection'),
(5, 5, 5, 2, '2023-06-17 14:00:00', '2023-06-17 14:15:00', 'Scheduled', 'Follow-up on biopsy results'),
(6, 6, 6, 1, '2023-06-18 09:00:00', '2023-06-18 09:30:00', 'Scheduled', 'First visit with cardiologist'),
(7, 7, 7, 6, '2023-06-18 10:00:00', '2023-06-18 10:15:00', 'Scheduled', 'X-ray follow-up'),
(8, 1, 1, 2, '2023-06-19 11:00:00', '2023-06-19 11:15:00', 'Scheduled', 'Heart medication check'),
(9, 2, 2, 3, '2023-06-19 13:00:00', '2023-06-19 14:00:00', 'Scheduled', 'Annual neurological exam'),
(10, 3, 3, 5, '2023-06-20 08:00:00', '2023-06-20 08:30:00', 'Scheduled', 'Emergency pediatric visit');

-- Insert into MedicalRecords
INSERT INTO MedicalRecords (patient_id, doctor_id, appointment_id, diagnosis, treatment, notes) VALUES
(1, 1, 1, 'Hypertension', 'Prescribed beta-blocker, recommended low-sodium diet', 'Patient has family history of heart disease'),
(2, 2, 2, 'Migraine', 'Prescribed triptans, recommended stress management', 'Patient reports 2-3 migraines per month'),
(3, 3, 3, 'Healthy child', 'Recommended annual vaccinations', 'Child is meeting all developmental milestones'),
(4, 4, 4, 'Post-operative knee surgery', 'Physical therapy recommended', 'Patient recovering well from ACL reconstruction'),
(5, 5, 5, 'Suspicious mole', 'Biopsy ordered', 'Mole shows irregular borders and color variation'),
(6, 1, 6, 'Atrial fibrillation', 'Prescribed anticoagulants', 'Patient to monitor for dizziness or fainting'),
(7, 2, 7, 'Meningitis', 'Lumbar puncture performed, antibiotics prescribed', 'Patient admitted for observation'),
(8, 3, 8, 'Childhood asthma', 'Prescribed inhaler, allergy testing recommended', 'Parents to monitor for triggers'),
(9, 4, 9, 'Compound fracture of radius', 'Arm set and cast applied', 'Follow-up in 6 weeks for cast removal'),
(10, 5, 10, 'Routine blood work', 'Blood drawn for CBC and metabolic panel', 'Results pending');

-- Insert into LabTests
INSERT INTO LabTests (test_name, description, department_id, standard_cost) VALUES
('CBC', 'Complete Blood Count', 7, 25.00),
('Basic Metabolic Panel', 'Glucose, electrolytes, kidney function', 7, 35.00),
('Lipid Panel', 'Cholesterol and triglycerides', 7, 30.00),
('Liver Function Test', 'Liver enzymes and proteins', 7, 40.00),
('Thyroid Stimulating Hormone', 'TSH level', 7, 45.00),
('Hemoglobin A1C', '3-month glucose average', 7, 50.00),
('Urinalysis', 'Urine screening', 7, 20.00),
('Culture and Sensitivity', 'Infection identification', 7, 60.00),
('Biopsy', 'Tissue examination', 7, 150.00),
('X-ray', 'Basic imaging', 6, 75.00),
('MRI', 'Magnetic resonance imaging', 6, 500.00),
('CT Scan', 'Computed tomography', 6, 350.00);

-- Insert into LabOrders
INSERT INTO LabOrders (appointment_id, test_id, doctor_id, status, notes) VALUES
(10, 1, 5, 'Completed', 'Routine blood work'),
(10, 2, 5, 'Completed', 'Routine blood work'),
(5, 9, 5, 'Completed', 'Mole biopsy'),
(7, 8, 2, 'Completed', 'CSF culture'),
(7, 1, 2, 'Completed', 'Infection monitoring'),
(6, 3, 1, 'Completed', 'Cholesterol check'),
(4, 10, 4, 'Completed', 'Knee imaging'),
(9, 10, 4, 'Completed', 'Fracture confirmation'),
(3, 7, 3, 'Completed', 'Child wellness urinalysis'),
(8, 4, 3, 'Completed', 'Asthma monitoring');

-- Insert into LabResults
INSERT INTO LabResults (order_id, result_value, result_notes, technician_id) VALUES
(1, 'WBC: 6.5, RBC: 4.7, HGB: 14.2', 'Normal ranges', 1),
(2, 'Glucose: 95, Na: 140, K: 4.0', 'All values within normal limits', 1),
(3, 'Benign nevus', 'No signs of malignancy', 2),
(4, 'Streptococcus pneumoniae', 'Bacterial growth detected', 2),
(5, 'WBC: 12.8, RBC: 4.5, HGB: 13.8', 'Elevated white count', 1),
(6, 'Total Cholesterol: 210, HDL: 45, LDL: 140', 'Borderline high LDL', 1),
(7, 'No fractures or abnormalities', 'Normal knee joint', 3),
(8, 'Fracture at distal radius', 'Clean break, well-aligned', 3),
(9, 'pH: 6.5, Protein: negative, Glucose: negative', 'Normal urinalysis', 2),
(10, 'ALT: 25, AST: 22, Albumin: 4.2', 'Normal liver function', 1);

-- Insert into Staff
INSERT INTO Staff (first_name, last_name, role, department_id, phone, email, hire_date) VALUES
('Lisa', 'Thompson', 'Nurse', 1, '555-4001', 'lthompson@hospital.com', '2020-01-15'),
('Mark', 'Roberts', 'Nurse', 2, '555-4002', 'mroberts@hospital.com', '2019-05-20'),
('Anna', 'Clark', 'Nurse', 3, '555-4003', 'aclark@hospital.com', '2021-03-10'),
('Paul', 'Lewis', 'Nurse', 4, '555-4004', 'plewis@hospital.com', '2018-11-05'),
('Rachel', 'Walker', 'Nurse', 5, '555-4005', 'rwalker@hospital.com', '2022-02-18'),
('Kevin', 'Allen', 'Lab Technician', 7, '555-4006', 'kallen@hospital.com', '2020-07-22'),
('Jessica', 'Young', 'Lab Technician', 7, '555-4007', 'jyoung@hospital.com', '2021-09-14'),
('Daniel', 'Scott', 'Radiology Technician', 6, '555-4008', 'dscott@hospital.com', '2019-04-30'),
('Amanda', 'Green', 'Administrator', NULL, '555-4009', 'agreen@hospital.com', '2017-08-12'),
('Steven', 'Adams', 'Receptionist', NULL, '555-4010', 'sadams@hospital.com', '2022-01-05');

-- Insert into DoctorSchedules
INSERT INTO DoctorSchedules (doctor_id, day_of_week, start_time, end_time, is_recurring, valid_from, valid_to) VALUES
(1, 'Monday', '09:00:00', '17:00:00', TRUE, '2023-01-01', NULL),
(1, 'Wednesday', '09:00:00', '17:00:00', TRUE, '2023-01-01', NULL),
(1, 'Friday', '09:00:00', '13:00:00', TRUE, '2023-01-01', NULL),
(2, 'Tuesday', '08:00:00', '16:00:00', TRUE, '2023-01-01', NULL),
(2, 'Thursday', '08:00:00', '16:00:00', TRUE, '2023-01-01', NULL),
(3, 'Monday', '09:00:00', '17:00:00', TRUE, '2023-01-01', NULL),
(3, 'Wednesday', '09:00:00', '17:00:00', TRUE, '2023-01-01', NULL),
(3, 'Friday', '09:00:00', '17:00:00', TRUE, '2023-01-01', NULL),
(4, 'Tuesday', '08:00:00', '18:00:00', TRUE, '2023-01-01', NULL),
(4, 'Thursday', '08:00:00', '18:00:00', TRUE, '2023-01-01', NULL),
(5, 'Monday', '10:00:00', '16:00:00', TRUE, '2023-01-01', NULL),
(5, 'Wednesday', '10:00:00', '16:00:00', TRUE, '2023-01-01', NULL),
(5, 'Friday', '10:00:00', '16:00:00', TRUE, '2023-01-01', NULL),
(6, 'Tuesday', '09:00:00', '17:00:00', TRUE, '2023-01-01', NULL),
(6, 'Thursday', '09:00:00', '17:00:00', TRUE, '2023-01-01', NULL),
(7, 'Monday', '08:00:00', '16:00:00', TRUE, '2023-01-01', NULL),
(7, 'Wednesday', '08:00:00', '16:00:00', TRUE, '2023-01-01', NULL),
(7, 'Friday', '08:00:00', '16:00:00', TRUE, '2023-01-01', NULL);

-- Insert into DoctorTimeOff
INSERT INTO DoctorTimeOff (doctor_id, start_date, end_date, reason, is_approved) VALUES
(1, '2023-07-01', '2023-07-14', 'Vacation', TRUE),
(2, '2023-08-15', '2023-08-22', 'Conference', TRUE),
(3, '2023-06-26', '2023-06-30', 'Family event', TRUE),
(4, '2023-09-05', '2023-09-12', 'Medical leave', FALSE),
(5, '2023-12-20', '2024-01-02', 'Holiday break', TRUE);

-- Insert into MedicationInventory
INSERT INTO MedicationInventory (medication_name, generic_name, dosage_form, strength, manufacturer, current_stock, reorder_level, unit_price, last_restocked) VALUES
('Lisinopril', 'Lisinopril', 'Tablet', '10mg', 'Generic', 500, 100, 0.50, '2023-05-15'),
('Lipitor', 'Atorvastatin', 'Tablet', '20mg', 'Pfizer', 300, 50, 2.00, '2023-05-20'),
('Propranolol', 'Propranolol', 'Tablet', '40mg', 'Generic', 400, 100, 0.75, '2023-05-10'),
('Amoxicillin', 'Amoxicillin', 'Capsule', '500mg', 'Generic', 600, 200, 0.30, '2023-06-01'),
('Ibuprofen', 'Ibuprofen', 'Tablet', '200mg', 'Generic', 1000, 300, 0.10, '2023-05-25'),
('Sumatriptan', 'Sumatriptan', 'Tablet', '50mg', 'GlaxoSmithKline', 200, 50, 5.00, '2023-05-18'),
('Warfarin', 'Warfarin', 'Tablet', '5mg', 'Generic', 350, 100, 0.80, '2023-05-22'),
('Albuterol', 'Albuterol', 'Inhaler', '90mcg', 'Teva', 150, 50, 15.00, '2023-06-05'),
('Omeprazole', 'Omeprazole', 'Capsule', '20mg', 'Generic', 450, 150, 0.60, '2023-05-30'),
('Metformin', 'Metformin', 'Tablet', '500mg', 'Generic', 550, 200, 0.25, '2023-06-02');

-- Update Prescriptions with medication_id
UPDATE MedicalRecords SET record_id = record_id; -- This is just to ensure records exist before adding prescriptions

INSERT INTO Prescriptions (record_id, medication_id, medication_name, dosage, frequency, duration, instructions, status) VALUES
(1, 3, 'Propranolol', '1 tablet', 'Twice daily', '30 days', 'Take with food', 'Active'),
(2, 6, 'Sumatriptan', '1 tablet', 'As needed for migraine', '10 tablets', 'Take at first sign of migraine', 'Active'),
(3, NULL, 'Multivitamin', '1 chewable', 'Daily', '90 days', 'For general health', 'Active'),
(4, 5, 'Ibuprofen', '1 tablet', 'Every 6 hours as needed', '7 days', 'For pain and inflammation', 'Completed'),
(5, NULL, 'Biopsy site care', 'Apply thin layer', 'Twice daily', 'Until healed', 'Keep area clean and dry', 'Active'),
(6, 7, 'Warfarin', '1 tablet', 'Daily', '30 days', 'Monitor for bleeding', 'Active'),
(7, 4, 'Amoxicillin', '1 capsule', 'Three times daily', '10 days', 'Take until finished', 'Completed'),
(8, 8, 'Albuterol', '2 puffs', 'Every 4-6 hours as needed', '30 days', 'Use before exercise if needed', 'Active'),
(9, 5, 'Ibuprofen', '1 tablet', 'Every 8 hours as needed', '14 days', 'For pain management', 'Active'),
(10, NULL, 'Vitamin D', '1000 IU', 'Daily', '90 days', 'For general health', 'Active');

-- Insert into Payments
INSERT INTO Payments (appointment_id, patient_id, amount, amount_paid, insurance_covered, payment_date, payment_method, status, insurance_claim_id) VALUES
(1, 1, 150.00, 150.00, 0.00, '2023-06-01 10:00:00', 'Credit Card', 'Completed', NULL),
(2, 2, 150.00, 30.00, 120.00, '2023-06-01 11:00:00', 'Insurance', 'Completed', 'AET-789456'),
(3, 3, 200.00, 50.00, 150.00, '2023-06-02 11:00:00', 'Insurance', 'Completed', 'UH-123456'),
(4, 4, 75.00, 75.00, 0.00, '2023-06-02 12:00:00', 'Debit Card', 'Completed', NULL),
(5, 5, 150.00, 150.00, 0.00, '2023-06-03 15:00:00', 'Cash', 'Completed', NULL),
(6, 6, 75.00, 15.00, 60.00, '2023-06-03 16:00:00', 'Insurance', 'Completed', 'MC-654321'),
(7, 7, 300.00, 50.00, 250.00, '2023-06-04 12:00:00', 'Insurance', 'Completed', 'KP-987654'),
(8, 8, 200.00, 40.00, 160.00, '2023-06-04 15:00:00', 'Insurance', 'Completed', 'AET-321654'),
(9, 9, 250.00, 250.00, 0.00, '2023-06-05 09:00:00', 'Bank Transfer', 'Completed', NULL),
(10, 10, 100.00, 20.00, 80.00, '2023-06-05 12:00:00', 'Insurance', 'Completed', 'UH-456789'),
(11, 1, 75.00, 0.00, 0.00, NULL, NULL, 'Pending', NULL),
(12, 2, 75.00, 0.00, 0.00, NULL, NULL, 'Pending', NULL),
(13, 3, 50.00, 0.00, 0.00, NULL, NULL, 'Pending', NULL),
(14, 4, 300.00, 0.00, 0.00, NULL, NULL, 'Pending', NULL),
(15, 5, 75.00, 0.00, 0.00, NULL, NULL, 'Pending', NULL);

SELECT * FROM appointments;
SELECT * FROM appointmenttypes;
SELECT * FROM departments;
SELECT * FROM doctors;
SELECT * FROM doctorschedules;
SELECT * FROM doctortimeoff;
SELECT * FROM emergencycontacts;
SELECT * FROM insuranceproviders;
SELECT * FROM laborders;
SELECT * FROM labresults;
SELECT * FROM labtests;
SELECT * FROM medicalrecords;
SELECT * FROM medicationinventory;
SELECT * FROM patientallergies;
SELECT * FROM patients;
SELECT * FROM payments;
SELECT * FROM prescriptions;
SELECT * FROM rooms;
SELECT * FROM staff;





-- Udhva Rakeshbhai Patel's Complex Queries

-- Complex Query 1
-- This Query Shows the total number of patients attended by specific doctor in desending order
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(DISTINCT a.patient_id) AS total_patients_attended
FROM 
    Doctors d
    LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
WHERE 
    a.status != 'Cancelled'
    AND a.appointment_date IS NOT NULL
GROUP BY 
    d.doctor_id, doctor_name
ORDER BY 
    total_patients_attended DESC;

-- Complex Query 2 
-- This Query shows the past appointments which payment status is pending 
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    a.appointment_id,
    at.type_name AS appointment_type,
    a.appointment_date,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    dep.department_name,
    py.amount AS total_charge,
    py.amount_paid,
    py.insurance_covered,
    (py.amount - py.amount_paid - py.insurance_covered) AS balance_due,
    py.status AS payment_status,
    DATEDIFF(CURDATE(), a.appointment_date) AS days_overdue
FROM 
    Payments py
    JOIN Appointments a ON py.appointment_id = a.appointment_id
    JOIN Patients p ON a.patient_id = p.patient_id
    JOIN Doctors d ON a.doctor_id = d.doctor_id
    JOIN Departments dep ON d.department_id = dep.department_id
    JOIN AppointmentTypes at ON a.type_id = at.type_id
WHERE 
    py.status = 'Pending'
    AND a.appointment_date < CURDATE()
    AND (py.amount - py.amount_paid - py.insurance_covered) > 0
ORDER BY 
    a.appointment_date ASC;


-- Dhruv Pechetty's Complex Queries

-- Complex query 1
-- displays the patient and doctor name and his specialisation and appointment's notes
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    a.appointment_date,
    a.notes AS appointment_notes,
    at.type_name AS appointment_type,
    a.status AS appointment_status
FROM
    Appointments a
    JOIN Patients p ON a.patient_id = p.patient_id
    JOIN Doctors d ON a.doctor_id = d.doctor_id
    JOIN AppointmentTypes at ON a.type_id = at.type_id
WHERE
    a.notes IS NOT NULL
    AND a.notes != ''
ORDER BY
    a.appointment_date DESC;


-- Complex Query 2
-- Retrieve the emergency contacts for patients whose payments are pending
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.phone AS patient_phone,
    p.email AS patient_email,
    ec.contact_name AS emergency_contact,
    ec.relationship,
    ec.phone_number AS emergency_phone,
    ec.is_primary,
    COUNT(py.appointment_id) AS pending_payments_count,
    SUM(py.amount - py.amount_paid - py.insurance_covered) AS total_balance_due
FROM 
    Payments py
    JOIN Appointments a ON py.appointment_id = a.appointment_id
    JOIN Patients p ON a.patient_id = p.patient_id
    JOIN EmergencyContacts ec ON p.patient_id = ec.patient_id
WHERE 
    py.status = 'Pending'
    AND (py.amount - py.amount_paid - py.insurance_covered) > 0
GROUP BY 
    p.patient_id, p.first_name, p.last_name, p.phone, p.email, 
    ec.contact_id, ec.contact_name, ec.relationship, ec.phone_number, ec.is_primary
ORDER BY 
    total_balance_due DESC, patient_name;



-- Pranav Vanam's Complex Queries

-- Complex Query 1
-- This query will return all the patients who have had an appointment with doctors in the Cardiology department.
SELECT DISTINCT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.dob,
    p.gender,
    p.phone,
    p.email,
    COUNT(a.appointment_id) AS cardiology_appointments_count,
    MAX(a.appointment_date) AS last_cardiology_visit
FROM
    Patients p
    JOIN Appointments a ON p.patient_id = a.patient_id
    JOIN Doctors d ON a.doctor_id = d.doctor_id
    JOIN Departments dep ON d.department_id = dep.department_id
WHERE
    dep.department_name = 'Cardiology'
    AND a.status != 'Cancelled'
GROUP BY
    p.patient_id, p.first_name, p.last_name, p.dob, p.gender, p.phone, p.email
ORDER BY
    last_cardiology_visit DESC;

-- Complex Query 2
-- This query calculates the total amount paid for each doctor’s appointments or total revenue of each docotor.
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    COUNT(DISTINCT a.appointment_id) AS total_appointments,
    (SUM(py.amount_paid) + SUM(py.insurance_covered)) AS total_revenue
FROM 
    Doctors d
    JOIN Departments dep ON d.department_id = dep.department_id
    LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
    LEFT JOIN Payments py ON a.appointment_id = py.appointment_id
WHERE 
    a.status != 'Cancelled'
    AND py.status IN ('Completed', 'Partial')
GROUP BY 
    d.doctor_id, doctor_name, d.specialization, dep.department_name
ORDER BY 
    total_revenue DESC;
    
-- Yuanwei Wu's Complex Queries

-- Complex Query 1
-- Show next available doctor (Yuanwei)
SELECT DISTINCT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    ds.day_of_week AS day,
    TIME_FORMAT(ds.start_time, '%H:%i') AS start_time,
    TIME_FORMAT(ds.end_time, '%H:%i') AS end_time
FROM 
    Doctors d
    JOIN DoctorSchedules ds ON d.doctor_id = ds.doctor_id
WHERE 
    ds.day_of_week = DAYNAME(CURDATE())
    AND TIME(NOW()) BETWEEN ds.start_time AND ds.end_time
    AND (ds.valid_from <= CURDATE() AND (ds.valid_to IS NULL OR ds.valid_to >= CURDATE()));
    
-- Complex Query 2
-- Show docstors who have more than 10 years of experience (Yuanwei)
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    dep.department_name,
    d.experience AS years_of_experience,
    d.license_number,
    d.email,
    d.phone
FROM 
    Doctors d
    JOIN Departments dep ON d.department_id = dep.department_id
WHERE 
    d.experience > 10
ORDER BY 
    d.experience DESC;
    
    
    
-- Sai Vikram Karthikeyan's Complex Queries

-- Complex Query 1
-- query will count and display the total number of appointments grouped by month in descending order.
SELECT 
    DATE_FORMAT(appointment_date, '%Y-%m') AS month,
    COUNT(*) AS total_appointments
FROM 
    Appointments
WHERE 
    status != 'Cancelled'  -- Exclude cancelled appointments
GROUP BY 
    DATE_FORMAT(appointment_date, '%Y-%m')
ORDER BY 
    month DESC;
    
-- Complex Query 2
-- this query will return all patient details along with the appointment details for the patient who has appointment_id = 5.

SELECT 
    P.*,
    A.*,
    CONCAT(D.first_name, ' ', D.last_name) AS doctor_name,
    D.specialization,
    AT.type_name AS appointment_type,
    R.room_number
FROM 
    Patients P
JOIN 
    Appointments A ON P.patient_id = A.patient_id
JOIN 
    Doctors D ON A.doctor_id = D.doctor_id
JOIN 
    AppointmentTypes AT ON A.type_id = AT.type_id
LEFT JOIN 
    Rooms R ON A.room_id = R.room_id
WHERE 
    A.appointment_id = 5;
    
------------------------------------------------------------------------------------------------------------------------------
-- Get Patients Who Have Spent the Most on Payments
SELECT P.patient_id, P.first_name, P.last_name, SUM(Pay.amount) AS total_spent
FROM Patients P
JOIN Appointments A ON P.patient_id = A.patient_id
JOIN Payments Pay ON A.appointment_id = Pay.appointment_id
GROUP BY P.patient_id
ORDER BY total_spent DESC
LIMIT 5;
---------------------------------------------------------------------------------------------------------------------------------






-- procedures


-- 1.(Procedure) This Procedure to schedule a new appointment with validation (Udhva Patel)
DELIMITER //

CREATE PROCEDURE ScheduleAppointment(
    IN p_patient_id INT,
    IN p_doctor_id INT,
    IN p_type_id INT,
    IN p_appointment_datetime DATETIME,
    OUT p_result VARCHAR(255)
)
BEGIN
    DECLARE v_duration INT;
    DECLARE v_end_time DATETIME;
    DECLARE v_doctor_available INT;
    DECLARE v_conflict_count INT;
    DECLARE v_room_id INT;
    DECLARE v_patient_exists INT;
    DECLARE v_doctor_exists INT;
    DECLARE v_type_exists INT;

    -- Check if patient exists
    SELECT COUNT(*) INTO v_patient_exists FROM Patients WHERE patient_id = p_patient_id;
    IF v_patient_exists = 0 THEN
        SET p_result = 'Error: Patient does not exist';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Patient does not exist';
    END IF;

    -- Check if doctor exists
    SELECT COUNT(*) INTO v_doctor_exists FROM Doctors WHERE doctor_id = p_doctor_id;
    IF v_doctor_exists = 0 THEN
        SET p_result = 'Error: Doctor does not exist';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Doctor does not exist';
    END IF;

    -- Check if appointment type exists
    SELECT COUNT(*) INTO v_type_exists FROM AppointmentTypes WHERE type_id = p_type_id;
    IF v_type_exists = 0 THEN
        SET p_result = 'Error: Appointment type does not exist';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Appointment type does not exist';
    END IF;

    -- Get appointment duration
    SELECT duration_minutes INTO v_duration 
    FROM AppointmentTypes 
    WHERE type_id = p_type_id;

    SET v_end_time = DATE_ADD(p_appointment_datetime, INTERVAL v_duration MINUTE);

    -- Check doctor schedule availability
    SELECT COUNT(*) INTO v_doctor_available
    FROM DoctorSchedules
    WHERE doctor_id = p_doctor_id
    AND day_of_week = DAYNAME(p_appointment_datetime)
    AND TIME(p_appointment_datetime) BETWEEN start_time AND end_time
    AND (valid_from <= DATE(p_appointment_datetime) AND (valid_to IS NULL OR valid_to >= DATE(p_appointment_datetime)))
    AND NOT EXISTS (
        SELECT 1 FROM DoctorTimeOff 
        WHERE doctor_id = p_doctor_id 
        AND DATE(p_appointment_datetime) BETWEEN start_date AND end_date
        AND is_approved = TRUE
    );

    IF v_doctor_available = 0 THEN
        SET p_result = 'Error: Doctor is not available at this time';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Doctor is not available at this time';
    END IF;

    -- Check for appointment conflicts
    SELECT COUNT(*) INTO v_conflict_count
    FROM Appointments
    WHERE doctor_id = p_doctor_id
    AND (
        (p_appointment_datetime BETWEEN appointment_date AND end_time)
        OR (v_end_time BETWEEN appointment_date AND end_time)
        OR (appointment_date BETWEEN p_appointment_datetime AND v_end_time)
    )
    AND status != 'Cancelled';

    IF v_conflict_count > 0 THEN
        SET p_result = 'Error: Doctor already has an appointment during this time';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Doctor already has an appointment during this time';
    END IF;

    -- Find available room
    SELECT room_id INTO v_room_id
    FROM Rooms
    WHERE department_id = (SELECT department_id FROM Doctors WHERE doctor_id = p_doctor_id)
    AND room_id NOT IN (
        SELECT room_id FROM Appointments
        WHERE (
            (p_appointment_datetime BETWEEN appointment_date AND end_time)
            OR (v_end_time BETWEEN appointment_date AND end_time)
            OR (appointment_date BETWEEN p_appointment_datetime AND v_end_time)
        )
        AND status != 'Cancelled'
        AND room_id IS NOT NULL
    )
    LIMIT 1;

    -- Schedule the appointment
    INSERT INTO Appointments (
        patient_id,
        doctor_id,
        room_id,
        type_id,
        appointment_date,
        end_time,
        status,
        created_at
    ) VALUES (
        p_patient_id,
        p_doctor_id,
        v_room_id,
        p_type_id,
        p_appointment_datetime,
        v_end_time,
        'Scheduled',
        NOW()
    );

    SET p_result = CONCAT('Appointment scheduled successfully. Appointment ID: ', LAST_INSERT_ID());
END //

DELIMITER ;

-- Call the procedure with parameters
CALL ScheduleAppointment(
    7,          -- Replace with actual patient ID (e.g., 1)
    3,           -- Replace with actual doctor ID (e.g., 3)
    5,             -- Replace with appointment type ID (e.g., 2)
    '2025-07-16 12:20:00', -- Appointment datetime (e.g., '2023-12-15 14:00:00')
    @result              -- Output variable to store the result
);

-- View the result
SELECT @result AS AppointmentResult;

SELECT * FROM doctorschedules;
SELECT * FROM doctortimeoff;



-- 2.(Procedure) This Procedure to generate doctor's schedule for a week (Udhva Patel)

DELIMITER //

CREATE PROCEDURE GenerateDoctorWeeklySchedule(
    IN p_doctor_id INT,
    IN p_start_date DATE
)
BEGIN
    -- Temporary table to store the schedule
    DROP TEMPORARY TABLE IF EXISTS temp_doctor_schedule;
    CREATE TEMPORARY TABLE temp_doctor_schedule (
        schedule_date DATE,
        day_name VARCHAR(10),
        start_time TIME,
        end_time TIME,
        availability_status VARCHAR(20),
        appointment_count INT,
        appointment_details TEXT
    );

    -- Generate schedule for each day of the week
    INSERT INTO temp_doctor_schedule
    SELECT 
        DATE_ADD(p_start_date, INTERVAL n.day_num DAY) AS schedule_date,
        DAYNAME(DATE_ADD(p_start_date, INTERVAL n.day_num DAY)) AS day_name,
        ds.start_time,
        ds.end_time,
        CASE
            WHEN dto.timeoff_id IS NOT NULL THEN 'On Leave'
            WHEN ds.schedule_id IS NULL THEN 'Not Scheduled'
            ELSE 'Available'
        END AS availability_status,
        COUNT(a.appointment_id) AS appointment_count,
        GROUP_CONCAT(
            CONCAT(
                TIME_FORMAT(a.appointment_date, '%H:%i'), ' - ',
                TIME_FORMAT(a.end_time, '%H:%i'), ' (',
                p.first_name, ' ', p.last_name, ')'
            ) 
            SEPARATOR ' | '
        ) AS appointment_details
    FROM 
        (SELECT 0 AS day_num UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 
         UNION SELECT 4 UNION SELECT 5 UNION SELECT 6) AS n
    LEFT JOIN DoctorSchedules ds ON 
        ds.doctor_id = p_doctor_id AND 
        ds.day_of_week = DAYNAME(DATE_ADD(p_start_date, INTERVAL n.day_num DAY)) AND
        (ds.valid_from <= DATE_ADD(p_start_date, INTERVAL n.day_num DAY) AND 
         (ds.valid_to IS NULL OR ds.valid_to >= DATE_ADD(p_start_date, INTERVAL n.day_num DAY)))
    LEFT JOIN DoctorTimeOff dto ON 
        dto.doctor_id = p_doctor_id AND 
        DATE_ADD(p_start_date, INTERVAL n.day_num DAY) BETWEEN dto.start_date AND dto.end_date AND
        dto.is_approved = TRUE
    LEFT JOIN Appointments a ON 
        a.doctor_id = p_doctor_id AND
        DATE(a.appointment_date) = DATE_ADD(p_start_date, INTERVAL n.day_num DAY) AND
        a.status != 'Cancelled'
    LEFT JOIN Patients p ON a.patient_id = p.patient_id
    GROUP BY 
        schedule_date, day_name, ds.start_time, ds.end_time, availability_status
    ORDER BY 
        schedule_date;

    -- Return the generated schedule
    SELECT 
        schedule_date AS 'Date',
        day_name AS 'Day',
        TIME_FORMAT(start_time, '%H:%i') AS 'Start Time',
        TIME_FORMAT(end_time, '%H:%i') AS 'End Time',
        availability_status AS 'Status',
        appointment_count AS 'Appointments',
        appointment_details AS 'Scheduled Appointments'
    FROM 
        temp_doctor_schedule;

    -- Clean up
    DROP TEMPORARY TABLE IF EXISTS temp_doctor_schedule;
END //

DELIMITER ;

CALL GenerateDoctorWeeklySchedule(5, '2023-12-11');






-- 3.(Procedure) This Procedure give complete view of all upcoming appointments with all relevant details (Udhva Patel)




DELIMITER //

CREATE PROCEDURE GetUpcomingAppointmentsWithDetails()
BEGIN
    SELECT 
        a.appointment_id,
        CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
        CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
        d.specialization,
        DATE_FORMAT(a.appointment_date, '%Y-%m-%d') AS appointment_date,
        DATE_FORMAT(a.appointment_date, '%h:%i %p') AS appointment_time,
        at.type_name AS appointment_type,
        r.room_number,
        a.status
    FROM 
        Appointments a
    JOIN 
        Patients p ON a.patient_id = p.patient_id
    JOIN 
        Doctors d ON a.doctor_id = d.doctor_id
    JOIN 
        AppointmentTypes at ON a.type_id = at.type_id
    LEFT JOIN 
        Rooms r ON a.room_id = r.room_id
    WHERE 
        a.appointment_date > NOW()
        AND a.status != 'Cancelled'
    ORDER BY 
        a.appointment_date ASC;
END //

DELIMITER ;

-- to call GetUpcomingAppointmentsWithDetails procedure.
CALL GetUpcomingAppointmentsWithDetails();



-- Data security and AI implementation - Two Paragraph



-- Functions 


-- Triggers
----Prevent Overbooking a Room Based on Capacity
DELIMITER $$

CREATE TRIGGER trg_check_room_capacity
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN
  DECLARE current_appointments INT;
  DECLARE room_cap INT;

  -- Get overlapping appointments
  SELECT COUNT(*) INTO current_appointments
  FROM Appointments
  WHERE room_id = NEW.room_id
    AND appointment_date < NEW.end_time
    AND end_time > NEW.appointment_date;

  -- Get room capacity
  SELECT capacity INTO room_cap
  FROM Rooms
  WHERE room_id = NEW.room_id;

  -- If capacity exceeded, raise error
  IF current_appointments >= room_cap THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Room capacity exceeded. Choose a different time or room.';
  END IF;
END$$

DELIMITER ;
---------------------------------------------------------------------------------------


DELIMITER $$

CREATE TRIGGER trg_prevent_double_booking
BEFORE INSERT ON appointments
FOR EACH ROW
BEGIN
  DECLARE count_appointments INT;

  SELECT COUNT(*) INTO count_appointments
  FROM appointments
  WHERE doctor_id = NEW.doctor_id
    AND appointment_time = NEW.appointment_time;

  IF count_appointments > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Doctor already has an appointment at this time';
  END IF;
END$$

DELIMITER ;
------------------------------------------------------------------------------------------------------
Trigger: Prevent Duplicate Allergy Entries
Avoid inserting the same allergy twice for a patient.

DELIMITER $$

CREATE TRIGGER trg_prevent_duplicate_allergy
BEFORE INSERT ON patientallergies
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM patientallergies
        WHERE patient_id = NEW.patient_id AND allergy_name = NEW.allergy_name
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duplicate allergy entry for this patient is not allowed.';
    END IF;
END$$

DELIMITER ;
------------------------------------------------------------------------------------------------------------
Trigger: Auto-assign Default Doctor for Appointments

DELIMITER $$

CREATE TRIGGER trg_auto_assign_doctor
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN
    -- Declare a variable to store the doctor_id
    DECLARE assigned_doctor_id INT;
    DECLARE department_id INT;

    IF NEW.doctor_id IS NULL THEN
        -- Retrieve department_id from Doctors table based on the doctor_id (if available)
        SELECT department_id
        INTO department_id
        FROM Doctors
        WHERE doctor_id = NEW.doctor_id;

        -- Assign doctor from the same department
        SELECT doctor_id
        INTO assigned_doctor_id
        FROM Doctors
        WHERE department_id = department_id
        LIMIT 1;

        -- Set the doctor_id for the new appointment
        SET NEW.doctor_id = assigned_doctor_id;
    END IF;
END$$

DELIMITER ;

-- Get Patients Who Have Spent the Most on Payments
SELECT P.patient_id, P.first_name, P.last_name, SUM(Pay.amount) AS total_spent
FROM Patients P
JOIN Appointments A ON P.patient_id = A.patient_id
JOIN Payments Pay ON A.appointment_id = Pay.appointment_id
GROUP BY P.patient_id
ORDER BY total_spent DESC
LIMIT 5; explain this code briefly
