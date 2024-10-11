USE master
GO
-- drop the AP database if it already exists
IF DB_ID('Scholar_Success_Fund') IS NOT NULL
DROP DATABASE Scholar_Success_Fund
GO
CREATE DATABASE Scholar_Success_Fund
GO
USE Scholar_Success_Fund
GO

-- Table Student Details
CREATE TABLE StudentDetails(
ApplicantID VARCHAR(10) NOT NULL,
CONSTRAINT PK_ApplicantID PRIMARY KEY (ApplicantID),
Name VARCHAR(50) NOT NULL,
Address VARCHAR(100) NOT NULL,
PhoneNumber VARCHAR(10) NOT NULL,
Email VARCHAR(50) NOT NULL,
DateOfBirth DATE,
Disabilitystatus VARCHAR(1) NOT NULL,
Gender VARCHAR(10) NOT NULL,
Race VARCHAR(10) NOT NULL
);



-- Table Co-Borrower Details
CREATE TABLE CoBorrowerDetails(
ApplicantID VARCHAR(10) NOT NULL,
CONSTRAINT FK_ApplicantID FOREIGN KEY (ApplicantID) REFERENCES StudentDetails(ApplicantID),
CoBorrowerID VARCHAR(10) NOT NULL,
CONSTRAINT PK_CoBorrower PRIMARY KEY (CoBorrowerID),
CoBorrowerName VARCHAR(50) NOT NULL,
CoBorrowerAddress VARCHAR(100) NOT NULL,
CoBorrowerPhoneNumber VARCHAR(10) NOT NULL,
CoBorrowerEmail VARCHAR(50) NOT NULL,
Occupation VARCHAR(25) NOT NULL,
RelationshipToStudent VARCHAR(25) NOT NULL,
);


-- Table Co-Borrower Financial Details
CREATE TABLE CoBorrowerFinancialDetails(
CoBorrowerID VARCHAR(10) NOT NULL,
CONSTRAINT PK_CoBorrowerFIN PRIMARY KEY (CoBorrowerID),
CONSTRAINT FK_CoBorrowerIDFIN FOREIGN KEY (CoBorrowerID) REFERENCES CoBorrowerDetails(CoBorrowerID),
Income Decimal(10,2) NOT NULL,
CreditScore INT NOT NULL,
ActiveLoans VARCHAR(1) NOT NULL,
PastLoans VARCHAR(1) NOT NULL
);



-- Table Student Academic Details
CREATE TABLE StudentAcademicDetails(
ApplicantID VARCHAR(10) NOT NULL,
CONSTRAINT PK_ApplicantIDAcademic PRIMARY KEY (ApplicantID),
CONSTRAINT FK_ApplicantIDAcademic FOREIGN KEY (ApplicantID) REFERENCES StudentDetails(ApplicantID),
HighestEducationCompleted VARCHAR(25) NOT NULL,
CurrentEducation VARCHAR(25) NOT NULL,
WorkingProfessional VARCHAR(25) NOT NULL,
GPA DECIMAL(3,2) NOT NULL,
AnyPastScholarship VARCHAR(1)
);



-- Table Student Income Details
CREATE TABLE StudentIncomeDetails(
ApplicantID VARCHAR(10) NOT NULL,
CONSTRAINT PK_ApplicantIDIncome PRIMARY KEY (ApplicantID),
CONSTRAINT FK_ApplicantIDIncome FOREIGN KEY (ApplicantID) REFERENCES StudentDetails(ApplicantID),
Employer VARCHAR(50) NOT NULL,
EmployerContactNumber VARCHAR(10) NOT NULL,
JobTitle VARCHAR(25) NOT NULL,
AnnualIncome DECIMAL(10,2) NOT NULL,
CreditScore INT NOT NULL,
CoBorrowerID VARCHAR(10) NOT NULL,
CONSTRAINT FK_CoBorrowerIDIncome FOREIGN KEY (CoBorrowerID) REFERENCES CoBorrowerDetails(CoBorrowerID),
);


-- Table Approved Institutions
CREATE TABLE ApprovedInstitutions(
UniversityID VARCHAR(10) NOT NULL,
CONSTRAINT PK_UniversityID PRIMARY KEY (UniversityID),
UniversityName VARCHAR(100) NOT NULL,
ApprovedforLoan VARCHAR(1) NOT NULL,
ApprovedforScholarships VARCHAR(1) NOT NULL,
InsitutionTierLevel VARCHAR(10) NOT NULL,
AverageLoanGranted Decimal(10,2) NOT NULL,
AverageScholarshipGranted Decimal(10,2) NOT NULL,
);


-- Table Scholarship Eligibility
CREATE TABLE ScholarshipEligibility(
ScholarshipID VARCHAR(10) NOT NULL,
CONSTRAINT PK_ScholarshipID PRIMARY KEY (ScholarshipID),
ScholarshipName VARCHAR(50) NOT NULL,
Category VARCHAR(50) NOT NULL,
Amount DECIMAL(10,2) NOT NULL
);


-- Table Application
CREATE TABLE Application(
ApplicantID VARCHAR(10) NOT NULL,
CONSTRAINT PK_ApplicantIDApp PRIMARY KEY (ApplicantID),
CONSTRAINT FK_ApplicantIDApp FOREIGN KEY (ApplicantID) REFERENCES StudentDetails(ApplicantID),
ApplicationDate Date NOT NULL,
UniversityName VARCHAR(100) NOT NULL,
Course VARCHAR(25) NOT NULL,
Degree VARCHAR(25) NOT NULL,
AddressUni VARCHAR(100) NOT NULL,    -- Changed name of column from Type to TypeOfScholarship
CourseFees DECIMAL(10,2) NOT NULL,
ScholarshipAmountbyUniversity DECIMAL(10,2) NOT NULL,
StatusOfApplication VARCHAR(10) NOT NULL,
AmountRequested DECIMAL(10,2) NOT NULL
);


-- Table Approved Loans
CREATE TABLE ApprovedLoans(
ApplicantID VARCHAR(10) NOT NULL,
CONSTRAINT PK_ApplicantIDLoans PRIMARY KEY (ApplicantID),
CONSTRAINT FK_ApplicantIDLoans FOREIGN KEY (ApplicantID) REFERENCES StudentDetails(ApplicantID),
UniversityID VARCHAR(10) NOT NULL,
CONSTRAINT FK_UniversityIDALoans FOREIGN KEY (UniversityID) REFERENCES ApprovedInstitutions(UniversityID),
ApprovedLoanAmount DECIMAL(10,2) NOT NULL,
ApprovedScholarshipAmount DECIMAL(10,2),
ValidThrough Date NOT NULL,
InterestRate DECIMAL(5,2) NOT NULL
);


-- Table Disbursement
CREATE TABLE Disbursement(
DisbursementID VARCHAR(10) NOT NULL,
ApplicantID VARCHAR(10) NOT NULL,
CONSTRAINT PK_ApplicantID_Disb PRIMARY KEY (ApplicantID),
CONSTRAINT FK_ApplicantID_Disb FOREIGN KEY (ApplicantID) REFERENCES StudentDetails(ApplicantID),
ScholarshipID VARCHAR(10) NOT NULL,
CONSTRAINT FK_ScholarshipID FOREIGN KEY (ScholarshipID) REFERENCES ScholarshipEligibility(ScholarshipID),
DisbursmentDate Date NOT NULL,
AmountDisbursed DECIMAL(10,2) NOT NULL     -- Changed name of column from Amount to AmountDisbursed
);


-- All the Tables created
select * from StudentDetails;
select * from CoBorrowerDetails;
select * from CoBorrowerFinancialDetails;
select * from StudentIncomeDetails;
select * from StudentAcademicDetails;
select * from ApprovedInstitutions;
select * from ScholarshipEligibility;
select * from Application;
select * from ApprovedLoans;
select * from Disbursement;

-- Inserting records into StudentDetails table
INSERT INTO StudentDetails 
(ApplicantID, Name, Address, PhoneNumber, Email, DateOfBirth, Disabilitystatus, Gender, Race)
VALUES
('ST0001', 'Arjun Pandit', '1255 E Univ St, Tempe, AZ, 85281', '1234567890', 'arjun.pandit@gmail.com', '2000-05-15','N', 'Male', 'Asian'),
('ST0002', 'Janet Smith', '4560 Elm St, Mesa, AZ, 85202', '9876543210', 'janet.smith@gmail.com',  '2006-06-11', 'N', 'Female', 'Black'),
('ST0003', 'Michael Johnson', '789 Oak St, Phoenix, AZ, 85007', '4567890123', 'michael.johnson@gmail.com', '1998-11-20', 'Y', 'Male', 'Hispanic'),
('ST0004', 'Anna Mallick', '3210 Lemon St, Gilbert, AZ, 85233', '8901234567', 'anna.mallick@gmail.com', '2004-12-21', 'N', 'Female', 'Asian'),
('ST0005', 'David Murphy', '654 Cedar St, Mesa, AZ, 85212', '2349978901', 'david.murphy@gmail.com', '2005-01-04', 'N', 'Male', 'White'),
('ST0006', 'Emma Martinez', '987 Birch St, Tempe, AZ, 85288', '6789012345', 'emma.martinez@gmail.com', '2001-03-18', 'Y', 'Female', 'Hispanic'),
('ST0007', 'Justin Taylor', '135 S Rural Road, Phoenix, AZ, 85011', '8906734567', 'justin2.taylor@gmail.com','2003-02-27', 'N', 'Male', 'Black'),
('ST0008', 'Olivia Anderson', '246 Walnut St, Mesa, AZ, 85207', '1222561890', 'olivia.anderson@gmail.com', '2003-05-30', 'N', 'Female', 'Asian'),
('ST0009', 'Thomas Kull', '357 Hardy Drive, Tempe, AZ, 85288', '9876289210', 'thomas.kull@gmail.com', '2006-04-28', 'Y', 'Male', 'White'),
('ST0010', 'Sophia Hayat', '468 Spruce St, Tucson, AZ, 85701', '2198678901', 'sophia.hayat@gmail.com',  '1995-08-12', 'N', 'Female', 'Asian'),
('ST0011', 'Alexander Nguyen', '579 Orange St, Scottsdale, AZ, 85250', '6789017925', 'alexander.nguyen@gmail.com', '1998-10-09', 'N', 'Male', 'Asian'),
('ST0012', 'Ava Garcia', '681 Elm St, Scottsdale, AZ, 85251', '8900234560', 'ava.garcia@gmail.com', '2005-06-04', 'N', 'Female', 'White'),
('ST0013', 'Matthew Perry', '792 Maple St, Chandler, AZ, 85224', '1204569990', 'matthew.perry@gmail.com', '1996-07-23', 'Y', 'Male', 'White'),
('ST0014', 'Isabella Kim', '893 Pine St, Tempe, AZ, 85285', '9870143210', 'isabella.kim@gmail.com', '1998-04-28', 'N', 'Female', 'Hispanic'),
('ST0015', 'James Patel', '1904 Terry Ln, Mesa, AZ, 85202', '2010267890', 'james.patel@gmail.com', '2007-01-20', 'N', 'Male', 'Asian'),
('ST0016', 'Martha Brown', '369 Alameda St, Chandler, AZ, 85225', '6787239450', 'martha.brown@gmail.com', '1998-10-13', 'N', 'Female', 'White'),
('ST0017', 'Ethan Miller', '582 Oak St, Tempe, AZ, 85282', '8900204567', 'ethan.miller@gmail.com', '1998-09-15', 'N', 'Male', 'Hispanic'),
('ST0018', 'Alicia Wilson', '753 S Rural St, Tempe, AZ, 85282', '1293476890', 'alicia.wilson@gmail.com', '1997-08-17', 'Y', 'Female', 'Black'),
('ST0019', 'Liam Hemsworth', '846 Cedar St, Mesa, AZ, 85212', '9016548810', 'liam.hemsworth@gmail.com', '1999-05-08', 'N', 'Male', 'White'),
('ST0020', 'Charlotte Jenner', '917 College Ave, Gilbert, AZ, 85233', '2344675891', 'charlotte.jenner@gmail.com',  '1998-07-10', 'N', 'Female', 'Hispanic'),
('ST0021', 'Frank Castle', '268 Maple St, Sedona, AZ, 86336', '6009012225', 'frank.castle@gmail.com',  '2002-02-14', 'N', 'Male', 'White'),
('ST0022', 'Amelia Jordon', '429 Broadway St, Prescott, AZ, 86300', '8321234507', 'amelia.jordon@gmail.com', '2006-04-22', 'N', 'Female', 'Asian'),
('ST0023', 'Aastha Pandey', '572 Chestnut Road, Phoenix, AZ, 85085', '9876051790', 'aastha.pandey@gmail.com', '2000-11-18', 'Y', 'Male', 'Asian'),
('ST0024', 'Emma Watson', '693 Forest Ave, Phoenix, AZ, 85026', '9720344310', 'emma.watson@gmail.com', '1997-03-15', 'N', 'Female', 'White'),
('ST0025', 'Harry Hernandez', '814 Terrace St, Tempe, AZ, 85288', '2388878901', 'harry.hernandez@gmail.com', '1998-05-29', 'N', 'Male', 'Black');


-- Inserting records into CoBorrowerDetails table
INSERT INTO CoBorrowerDetails 
(ApplicantID, CoBorrowerID, CoBorrowerName, CoBorrowerAddress, CoBorrowerPhoneNumber, CoBorrowerEmail, Occupation, RelationshipToStudent)
VALUES
('ST0001', 'CB0001', 'Akshay Pandit', '1255 E Univ St, Tempe, AZ, 85281', '1234567890', 'akshay.pandit@gmail.com', 'Engineer', 'Father'),
('ST0002', 'CB0002', 'Jane Smith', '4560 Elm St, Mesa, AZ, 85202', '9876543890', 'jane.smith@gmail.com', 'Teacher', 'Mother'),
('ST0003', 'CB0003', 'Michael Johnson Jr.', '789 Oak St, Phoenix, AZ, 85007', '4567894123', 'michael.johnsonjr@gmail.com', 'Accountant', 'Father'),
('ST0004', 'CB0004', 'Alicia Mallick', '3210 Lemon St, Gilbert, AZ, 85233', '8901239967', 'alicia.mallick@gmail.com', 'Nurse', 'Mother'),
('ST0005', 'CB0005', 'David Murphy Sr.', '654 Cedar St, Mesa, AZ, 85212', '2349978801', 'david.murphysr@gmail.com', 'Manager', 'Grandfather'),
('ST0006', 'CB0006', 'Almaa Martinez', '987 Birch St, Tempe, AZ, 85288', '6789012381', 'almaa.martinez@gmail.com', 'Lawyer', 'Aunt'),
('ST0007', 'CB0007', 'Theoder Taylor', '135 S Rural Road, Phoenix, AZ, 85011', '8906734567', 'theo.taylor@gmail.com', 'Principal Engineer', 'Father'),
('ST0008', 'CB0008', 'Elena Anderson', '246 Walnut St, Mesa, AZ, 85207', '1222563390', 'elena.anderson@gmail.com', 'Doctor', 'Mother'),
('ST0009', 'CB0009', 'Richard Kull', '357 Hardy Drive, Tempe, AZ, 85288', '9652892101', 'richard.kull@gmail.com', 'Engineer', 'Father'),
('ST0010', 'CB0010', 'Salma Hayat', '468 Spruce St, Tucson, AZ, 85701', '2198622901', 'salma.hayat@gmail.com', 'Professor', 'Sister'),
('ST0011', 'CB0011', 'Alexia Nguyen', '579 Orange St, Scottsdale, AZ, 85250', '6786937925', 'alexia.nguyen@gmail.com', 'Architect', 'Sister'),
('ST0012', 'CB0012', 'Asmaa Garcia', '681 Elm St, Scottsdale, AZ, 85251', '8903964560', 'asmaa.garcia@gmail.com', 'Artist', 'Parent'),
('ST0013', 'CB0013', 'Matthew Perry Sr.', '792 Maple St, Chandler, AZ, 85224', '1204566540', 'matthew.perrysr@gmail.com', 'Chef', 'Parent'),
('ST0014', 'CB0014', 'Katrina Kim', '893 Pine St, Tempe, AZ, 85285', '9870144220', 'katrina.kim@gmail.com', 'Writer', 'Aunt'),
('ST0015', 'CB0015', 'Hardik Patel', '1904 Terry Ln, Mesa, AZ, 85202', '2010267890', 'hardik.patel@gmail.com', 'Manager', 'Parent'),
('ST0016', 'CB0016', 'Laura Brown', '369 Alameda St, Chandler, AZ, 85225', '6789939450', 'laura.brown@gmail.com', 'Nurse', 'Aunt'),
('ST0017', 'CB0017', 'Ross Miller', '582 Oak St, Tempe, AZ, 85282', '8902204567', 'ross.miller@gmail.com', 'Pilot', 'Father'),
('ST0018', 'CB0018', 'Skyler Wilson', '753 S Rural St, Tempe, AZ, 85282', '1299476890', 'skyler.wilson@gmail.com', 'Designer', 'Mother'),
('ST0019', 'CB0019', 'Kris Hemsworth', '846 Cedar St, Mesa, AZ, 85212', '9016545810', 'kris.hemsworth@gmail.com', 'Engineer', 'Brother'),
('ST0020', 'CB0020', 'Kylie Jenner', '917 College Ave, Gilbert, AZ, 85233', '2345675891', 'kylie.jenner@gmail.com', 'Retail Manager', 'Sister'),
('ST0021', 'CB0021', 'James Castle', '268 Maple St, Sedona, AZ, 86336', '6009012245', 'james.castle@gmail.com', 'Lawyer', 'Father'),
('ST0022', 'CB0022', 'Julia Jordon', '429 Broadway St, Prescott, AZ, 86300', '8321234407', 'julia.jordon@gmail.com', 'Artist', 'Mother'),
('ST0023', 'CB0023', 'Stuti Pandey', '572 Chestnut Road, Phoenix, AZ, 85085', '9876051890', 'stuti.pandey@gmail.com', 'Sr Engineering Manager', 'Mother'),
('ST0024', 'CB0024', 'Elzi Watson', '693 Forest Ave, Phoenix, AZ, 85026', '9720834310', 'elzi.watson@gmail.com', 'Doctor', 'Grandmother'),
('ST0025', 'CB0025', 'Felipe Hernandez', '814 Terrace St, Tempe, AZ, 85288', '2388844901', 'felipe.hernandez@gmail.com', 'Manager', 'Uncle');


-- Inserting records into CoBorrowerFinancialDetails table
INSERT INTO CoBorrowerFinancialDetails 
(CoBorrowerID, Income, CreditScore, ActiveLoans, PastLoans)
VALUES
('CB0001', 100000.00, 750, 'Y', 'N'),
('CB0002', 60000.00, 700, 'N', 'N'),
('CB0003', 55000.00, 740, 'Y', 'Y'),
('CB0004', 48000.00, 640, 'N', 'Y'),
('CB0005', 52000.00, 730, 'Y', 'Y'),
('CB0006', 75000.00, 750, 'Y', 'Y'),
('CB0007', 125000.00, 760, 'N', 'Y'),
('CB0008', 95000.00, 770, 'Y', 'Y'),
('CB0009', 91000.00, 740, 'N', 'Y'),
('CB0010', 130000.00, 720, 'N', 'Y'),
('CB0011', 85000.00, 710, 'N', 'N'),
('CB0012', 50000.00, 750, 'Y', 'Y'),
('CB0013', 79000.00, 730, 'Y', 'N'),
('CB0014', 40000.00, 700, 'N', 'N'),
('CB0015', 68000.00, 750, 'N', 'N'),
('CB0016', 65000.00, 720, 'N', 'N'),
('CB0017', 80000.00, 730, 'N', 'Y'),
('CB0018', 60000.00, 740, 'N', 'Y'),
('CB0019', 95000.00, 750, 'N', 'N'),
('CB0020', 69000.00, 760, 'N', 'N'),
('CB0021', 75000.00, 720, 'N', 'Y'),
('CB0022', 55000.00, 690, 'Y', 'Y'),
('CB0023', 170000.00, 760, 'Y', 'N'),
('CB0024', 90000.00, 750, 'Y', 'Y'),
('CB0025', 85000.00, 740, 'N', 'Y');


-- Inserting records into StudentAcademicDetails table
INSERT INTO StudentAcademicDetails 
(ApplicantID, HighestEducationCompleted, CurrentEducation, WorkingProfessional, GPA, AnyPastScholarship)
VALUES
('ST0001', 'Bachelors', 'Masters', 'No', 3.5, 'Y'),
('ST0002', 'High School', 'Bachelors', 'No', 3.2, 'Y'),
('ST0003', 'Masters', 'PhD', 'Yes', 3.8, 'Y'),
('ST0004', 'Bachelors', 'Masters', 'No', 3.4, 'N'),
('ST0005', 'High School', 'Associate', 'No', 3.6, 'N'),
('ST0006', 'Bachelors', 'Masters', 'Yes', 3.7, 'Y'),
('ST0007', 'High School', 'Bachelors', 'No', 3.3, 'Y'),
('ST0008', 'Bachelors', 'Masters', 'Yes', 3.9, 'N'),
('ST0009', 'High School', 'Associate', 'No', 3.1, 'Y'),
('ST0010', 'Masters', 'PhD', 'No', 3.8, 'Y'),
('ST0011', 'Bachelors', 'Masters', 'Yes', 2.9, 'N'),
('ST0012', 'High School', 'Bachelors', 'No', 3.4, 'Y'),
('ST0013', 'Masters', 'PhD', 'Yes', 3.7, 'Y'),
('ST0014', 'Bachelors', 'Masters', 'Yes', 3.3, 'N'),
('ST0015', 'High School', 'Bachelors', 'No', 3.2, 'Y'),
('ST0016', 'Bachelors', 'Masters', 'Yes', 3.6, 'N'),
('ST0017', 'High School', 'Bachelors', 'No', 3.5, 'Y'),
('ST0018', 'Masters', 'PhD', 'Yes', 3.8, 'Y'),
('ST0019', 'Bachelors', 'Masters', 'Yes', 3.9, 'N'),
('ST0020', 'High School', 'Bachelors', 'No', 3.3, 'Y'),
('ST0021', 'Bachelors', 'Masters', 'Yes', 3.7, 'N'),
('ST0022', 'High School', 'Associate', 'No', 3.4, 'Y'),
('ST0023', 'Bachelors', 'Masters', 'Yes', 3.8, 'Y'),
('ST0024', 'Masters', 'PhD', 'Yes', 3.5, 'Y'),
('ST0025', 'Bachelors', 'Masters', 'Yes', 3.9, 'Y');


-- Inserting records into StudentIncomeDetails table
INSERT INTO StudentIncomeDetails 
(ApplicantID, Employer, EmployerContactNumber, JobTitle, AnnualIncome, CreditScore, CoBorrowerID)
VALUES
('ST0003', 'ABC Corp', '1234509872', 'Software Engineer', 95000.00, 750, 'CB0003'),
('ST0006', 'XYZ Inc', '9833223210', 'Associate Developer', 55000.00, 700, 'CB0006'),
('ST0008', 'PQR Ltd', '4567801223', 'Accountant', 65000.00, 720, 'CB0008'),
('ST0011', 'DEF Company', '8901253861', 'Nurse', 55000.00, 680, 'CB0011'),
('ST0013', 'GHI Corporation', '2342789901', 'Senior Engineer', 120000.00, 710, 'CB0013'),
('ST0014', 'LMN LLC', '6789057535', 'Lawyer', 90000.00, 730, 'CB0014'),
('ST0016', 'JKL Technologies', '8906655267', 'Software Developer', 85000.00, 760, 'CB0016'),
('ST0018', 'RST Enterprises', '1996561890', 'Associate Professor', 100000.00, 740, 'CB0018'),
('ST0019', 'MNO Industries', '9228789210', 'Engineer', 75000.00, 720, 'CB0019'),
('ST0021', 'UVW Corporation', '2189438901', 'Construction Engineer', 65000.00, 750, 'CB0021'),
('ST0023', 'Spartex Solutions Ltd.', '4809678901', 'Sales Associate', 69000.00, 690, 'CB0023'),
('ST0024', 'NET Corp Ltd.', '6028699031', 'Engineering Manager', 95000.00, 750, 'CB0024'),
('ST0025', 'UVW Corporation', '4846776871', 'Technical Writer', 50000.00, 710, 'CB0025');


-- Inserting records into ApprovedInstitutions table
INSERT INTO ApprovedInstitutions 
(UniversityID, UniversityName, ApprovedforLoan, ApprovedforScholarships, InsitutionTierLevel, AverageLoanGranted, AverageScholarshipGranted)
VALUES 
('UID001', 'Arizona State University', 'Y', 'Y', 'Tier 2', 50000.00, 5000.00),
('UID002', 'Alabama State University', 'Y', 'Y', 'Tier 2', 28000.00, 3000.00),
('UID003', 'University of Alaska System', 'Y', 'Y', 'Tier 2', 25000.00, 3500.00),
('UID004', 'University of Arizona', 'Y', 'Y', 'Tier 2', 50000.00, 4000.00),
('UID005', 'John Brown University', 'Y', 'Y', 'Tier 2', 60000.00, 6000.00),
('UID006', 'California Pacific University', 'Y', 'Y', 'Tier 2', 25000.00, 2500.00),
('UID007', 'San Jose State University', 'Y', 'Y', 'Tier 2', 35000.00, 3500.00),
('UID008', 'San Diego State University', 'Y', 'Y', 'Tier 2', 30000.00, 3000.00),
('UID009', 'Stanford University', 'Y', 'Y', 'Tier 1', 100000.00, 10000.00),
('UID010', 'University of San Francisco', 'Y', 'Y', 'Tier 2', 25000.00, 1500.00),
('UID011', 'Colorado State University', 'Y', 'Y', 'Tier 2', 50000.00, 5000.00),
('UID012', 'Yale University', 'Y', 'Y', 'Tier 1', 100000.00, 10000.00),
('UID013', 'University of the District of Columbia', 'Y', 'Y', 'Tier 3', 30000.00, 2900.00),
('UID014', 'Florida Institute of Technology', 'Y', 'Y', 'Tier 3', 20000.00, 2000.00),
('UID015', 'Florida State University', 'Y', 'Y', 'Tier 2', 28000.00, 2600.00),
('UID016', 'Idaho State University', 'Y', 'Y', 'Tier 3', 27000.00, 2700.00),
('UID017', 'DePaul University', 'Y', 'Y', 'Tier 2', 29000.00, 2400.00),
('UID018', 'Illinois Institute of Technology', 'Y', 'Y', 'Tier 2', 24000.00, 2400.00),
('UID019', 'Indiana State University', 'Y', 'Y', 'Tier 2', 22000.00, 2200.00),
('UID020', 'Purdue University', 'Y', 'Y', 'Tier 1', 50000.00, 5000.00),
('UID021', 'Oregon State University', 'Y', 'Y', 'Tier 2', 28000.00, 2300.00),
('UID022', 'Harvard University', 'Y', 'Y', 'Tier 1', 150000.00, 25000.00),
('UID023', 'Drake University', 'Y', 'Y', 'Tier 3', 80000.00, 8000.00),
('UID024', 'Cambridge College', 'Y', 'Y', 'Tier 2', 90000.00, 9000.00),
('UID025', 'Michigan State University', 'Y', 'Y', 'Tier 2', 16000.00, 1000.00),
('UID026', 'Oakland University', 'Y', 'Y', 'Tier 3', 28000.00, 2300.00),
('UID027', 'Massachusetts Institute of Technology', 'Y', 'Y', 'Tier 1', 200000.00, 20000.00),
('UID028', 'Princeton University', 'Y', 'Y', 'Tier 1', 180000.00, 18000.00);


-- Inserting records into ScholarshipEligibility table
INSERT INTO ScholarshipEligibility (ScholarshipID, ScholarshipName, Category, Amount)
VALUES 
('SCE001', 'Merit-Based Scholarship', 'Academic', 2000.00),
('SCE002', 'Physical-Disability Scholarship', 'Disability', 3000.00),
('SCE003', 'Female Scholarship', 'Gender-Academic', 4000.00),
('SCE004', 'Ethinicity-Based Scholarship', 'Black-Ethinicity Based', 3000.00),
('SCE005', 'Ethinicity-Based Scholarship', 'Native American-Ethinicity Based', 2000.00),
('SCE006', 'Ethinicity-Based Scholarship', 'International-Ethinicity Based', 1500.00),
('SCE007', 'Merit-Based Scholarship', 'Financial Aid', 10000.00),
('SCE008', 'Female Scholarship', 'Gender Based', 2000.00),
('SCE009', 'Physical and Merit Scholarship', 'Disability and Academic', 6000.00),
('SCE010', 'Minority Scholarship', 'Diversity', 4000.00),
('SCE011', 'No-Scholarship', 'Not Eligible', 0.00);



-- Inserting records into Application table
INSERT INTO Application 
(ApplicantID, ApplicationDate, UniversityName, Course, Degree, AddressUni, CourseFees, ScholarshipAmountbyUniversity, StatusOfApplication, AmountRequested)
VALUES
('ST0001', '2024-04-01', 'Arizona State University', 'Computer Science', 'Bachelor', '123 Main St, Tempe, AZ', 80000.00, 5000.00, 'Applied',75000.00),
('ST0002', '2024-04-01', 'Alabama State University', 'Engineering', 'Master', '456 Elm St, Montgomery, AL', 40000.00, 3000.00, 'Applied', 37000.00),
('ST0003', '2024-04-02', 'University of Alaska System', 'Business Administration', 'Bachelor', '789 Oak St, Fairbanks, AK', 70000.00, 3500.00, 'Applied', 66500.00),
('ST0004', '2024-04-02', 'University of Arizona', 'Psychology', 'Master', '321 Lemon St, Tucson, AZ', 35000.00, 4000.00, 'Applied', 31500.00),
('ST0005', '2024-04-03', 'John Brown University', 'Nursing', 'Bachelor', '654 Cedar St, Siloam Springs, AR', 85000.00, 6000.00, 'Applied', 79000.00),
('ST0006', '2024-04-03', 'California Pacific University', 'Environmental Science', 'Master', '987 Birch St, San Francisco, CA', 38000.00, 2500.00, 'Applied', 35500.00),
('ST0007', '2024-04-04', 'San Jose State University', 'Mechanical Engineering', 'Master', '135 Rural Rd, San Jose, CA', 35000.00, 3500.00, 'Applied', 31500.00),
('ST0008', '2024-04-04', 'San Diego State University', 'History', 'Master', '246 Walnut St, San Diego, CA', 38500.00, 3000.00, 'Applied', 35500.00),
('ST0009', '2024-04-05', 'Stanford University', 'Computer Engineering', 'Doctorate', '357 Hardy Dr, Stanford, CA', 50000.00, 10000.00, 'Applied', 40000.00),
('ST0010', '2024-04-05', 'University of San Francisco', 'Biotechnology', 'Master', '468 Spruce St, San Francisco, CA', 32000.00, 1500.00, 'Applied', 30500.00),
('ST0011', '2024-04-06', 'Colorado State University', 'Journalism', 'Bachelor', '579 Orange St, Fort Collins, CO', 35000.00, 5000.00, 'Applied', 30000.00),
('ST0012', '2024-04-06', 'Yale University', 'Law', 'Doctorate', '681 Elm St, New Haven, CT', 60000.00, 10000.00, 'Applied', 50000.00),
('ST0013', '2024-04-07', 'University of the District of Columbia', 'Public Health', 'Master', '792 Maple St, Washington, DC', 32000.00, 2900.00, 'Applied', 29100.00),
('ST0014', '2024-04-07', 'Florida Institute of Technology', 'Aerospace Engineering', 'Bachelor', '893 Pine St, Melbourne, FL', 85000.00, 2000.00, 'Applied', 83000.00),
('ST0015', '2024-04-08', 'Florida State University', 'Chemistry', 'Master', '1904 Terry Ln, Tallahassee, FL', 38000.00, 2600.00, 'Applied', 35400.00),
('ST0016', '2024-04-08', 'Idaho State University', 'Civil Engineering', 'Bachelor', '369 Alameda St, Pocatello, ID', 83000.00, 2700.00, 'Applied', 80300.00),
('ST0017', '2024-04-09', 'DePaul University', 'Economics', 'Master', '582 Oak St, Chicago, IL', 34000.00, 2400.00, 'Applied', 31600.00),
('ST0018', '2024-04-09', 'Illinois Institute of Technology', 'Computer Science', 'Bachelor', '753 Rural St, Chicago, IL', 70000.00, 2400.00, 'Applied', 67600.00),
('ST0019', '2024-04-10', 'Indiana State University', 'Education', 'Master', '846 Cedar St, Terre Haute, IN', 41000.00, 2200.00, 'Applied', 38800.00),
('ST0020', '2024-04-10', 'Purdue University', 'Electrical Engineering', 'Doctorate', '917 College Ave, West Lafayette, IN', 90000.00, 5000.00, 'Applied', 85000.00),
('ST0021', '2024-04-11', 'Oregon State University', 'Forestry', 'Master', '268 Maple St, Corvallis, OR', 30000.00, 2300.00, 'Applied', 27700.00),
('ST0022', '2024-04-11', 'Drake University', 'Marketing', 'Bachelor', '429 Broadway St, Des Moines, IA', 90000.00, 8000.00, 'Applied', 82000.00),
('ST0023', '2024-04-12', 'Cambridge College', 'Information Technology', 'Master', '572 Chestnut Rd, Cambridge, MA', 45000.00, 9000.00, 'Applied', 36000.00),
('ST0024', '2024-04-12', 'Michigan State University', 'Agriculture', 'Bachelor', '693 Forest Ave, East Lansing, MI', 75000.00, 1000.00, 'Applied', 74000.00),
('ST0025', '2024-04-13', 'University of Chicago', 'Mechanical Engineering', 'Master', '814 Terrace St, Rochester, MI', 33000.00, 2300.00, 'Applied', 30700.00);


-- Inserting records into ApprovedLoans table
INSERT INTO ApprovedLoans 
(ApplicantID, UniversityID, ApprovedLoanAmount, ApprovedScholarshipAmount, ValidThrough, InterestRate)
VALUES
('ST0001', 'UID001', 75000.00, 0, '2029-04-01', 6.0),
('ST0002', 'UID002', 37000.00, 3000, '2027-04-01', 4.66),
('ST0003', 'UID003', 66500.00, 6000, '2029-04-02', 4.03),
('ST0005', 'UID005', 79000.00, 2000, '2029-04-03', 11.93),
('ST0006', 'UID006', 35500.00, 6000, '2027-04-03', 3.8),
('ST0007', 'UID007', 31500.00, 3000, '2029-04-04', 2.12),
('ST0008', 'UID008', 35500.00, 4000, '2027-04-04', 3.12),
('ST0009', 'UID009', 40000.00, 3000, '2030-04-05', 4.06),
('ST0010', 'UID010', 30500.00, 4000, '2027-04-05', 1.93),
('ST0012', 'UID012', 50000.00, 2000, '2030-04-06', 9.00),
('ST0013', 'UID013', 29100.00, 6000, '2027-04-07', 3.51),
('ST0015', 'UID015', 35400.00, 0, '2027-04-08', 4.19),
('ST0016', 'UID016', 80300.00, 4000, '2029-04-08', 9.19),
('ST0017', 'UID017', 31600.00, 0, '2027-04-09', 3.10),
('ST0018', 'UID018', 67600.00, 6000, '2029-04-09', 8.63),
('ST0019', 'UID019', 38800.00, 2000, '2027-04-10', 3.23),
('ST0020', 'UID020', 85000.00, 2000, '2030-04-10', 10.68),
('ST0021', 'UID021', 27700.00, 2000, '2027-04-11', 2.88),
('ST0022', 'UID022', 82000.00, 2000, '2029-04-11', 11.29),
('ST0023', 'UID023', 36000.00, 6000, '2027-04-12', 2.01),
('ST0024', 'UID024', 74000.00, 2000, '2029-04-12', 6.25);


-- Inserting records into Disbursement table
INSERT INTO Disbursement
(DisbursementID, ApplicantID, ScholarshipID, DisbursmentDate, AmountDisbursed) 
VALUES
('DSB001','ST0001', 'SCE011', '2029-04-11', 9375.00),
('DSB002','ST0002', 'SCE004', '2027-04-11', 9250.00),
('DSB003','ST0003', 'SCE002', '2029-04-12', 8312.50),
('DSB004','ST0005', 'SCE001', '2029-04-12', 9875.00),
('DSB005','ST0006', 'SCE009', '2027-04-13', 8875.00),
('DSB006','ST0007', 'SCE004', '2029-04-14', 7875.00),
('DSB007','ST0008', 'SCE003', '2027-04-14', 8875.00),
('DSB008','ST0009', 'SCE002', '2030-04-15', 4000.00),
('DSB009','ST0010', 'SCE003', '2027-04-15', 7625.00),
('DSB010','ST0012', 'SCE008', '2030-04-16', 5000.00),
('DSB011','ST0013', 'SCE009', '2027-04-17', 7275.00),
('DSB012','ST0015', 'SCE011', '2027-04-17', 8850.00),
('DSB013','ST0016', 'SCE003', '2029-04-17', 10037.50),
('DSB014','ST0017', 'SCE011', '2027-04-18', 7900.00),
('DSB015','ST0018', 'SCE009', '2029-04-18', 8450.00),
('DSB016','ST0019', 'SCE001', '2027-04-19', 9700.00),
('DSB017','ST0020', 'SCE008', '2030-04-19', 8500.00),
('DSB018','ST0021', 'SCE001', '2027-04-20', 6925.00),
('DSB019','ST0022', 'SCE008', '2029-04-20', 10250.00),
('DSB020','ST0023', 'SCE009', '2027-04-21', 9000.00),
('DSB021','ST0024', 'SCE008', '2029-04-21', 9250.00);

-- All the Tables created
select * from StudentDetails;
select * from CoBorrowerDetails;
select * from CoBorrowerFinancialDetails;
select * from StudentIncomeDetails;
select * from StudentAcademicDetails;
select * from ApprovedInstitutions;
select * from ScholarshipEligibility;
select * from Application;
select * from ApprovedLoans;
select * from Disbursement;