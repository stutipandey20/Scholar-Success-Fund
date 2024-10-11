--  Audit Table ---------------------

-- Creating the audit table ------------

CREATE TABLE ApprovedInstitutionsAudit (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    UniversityID VARCHAR(10) NOT NULL,
    UniversityName VARCHAR(100) NOT NULL,
    ApprovedforLoan VARCHAR(1) NOT NULL,
    ApprovedforScholarships VARCHAR(1) NOT NULL,
    InsitutionTierLevel VARCHAR(10) NOT NULL,
    AverageLoanGranted DECIMAL(10,2) NOT NULL,
    AverageScholarshipGranted DECIMAL(10,2) NOT NULL,
    OperationType VARCHAR(10) NOT NULL,
    ChangedDateTime DATETIME NOT NULL
);

GO

-- Creating Trigger for Insert ------------

CREATE TRIGGER InsertApprovedInstitutionsAudit
ON ApprovedInstitutions
AFTER INSERT
AS
BEGIN
    INSERT INTO ApprovedInstitutionsAudit (
        UniversityID,
        UniversityName,
        ApprovedforLoan,
        ApprovedforScholarships,
        InsitutionTierLevel,
        AverageLoanGranted,
        AverageScholarshipGranted,
        OperationType,
        ChangedDateTime
    )
    SELECT
        UniversityID,
        UniversityName,
        ApprovedforLoan,
        ApprovedforScholarships,
        InsitutionTierLevel,
        AverageLoanGranted,
        AverageScholarshipGranted,
        'INSERT',
        GETDATE()
    FROM
        inserted;
END;

GO

-- Creating Trigger for Update:------------

CREATE TRIGGER UpdateApprovedInstitutionsAudit
ON ApprovedInstitutions
AFTER UPDATE
AS
BEGIN
    INSERT INTO ApprovedInstitutionsAudit (
        UniversityID,
        UniversityName,
        ApprovedforLoan,
        ApprovedforScholarships,
        InsitutionTierLevel,
        AverageLoanGranted,
        AverageScholarshipGranted,
        OperationType,
        ChangedDateTime
    )
    SELECT
        UniversityID,
        UniversityName,
        ApprovedforLoan,
        ApprovedforScholarships,
        InsitutionTierLevel,
        AverageLoanGranted,
        AverageScholarshipGranted,
        'UPDATE',
        GETDATE()
    FROM
        inserted;
END;

GO

-- Creating Trigger for Delete:------------

CREATE TRIGGER DeleteApprovedInstitutionsAudit
ON ApprovedInstitutions
AFTER DELETE
AS
BEGIN
    INSERT INTO ApprovedInstitutionsAudit (
        UniversityID,
        UniversityName,
        ApprovedforLoan,
        ApprovedforScholarships,
        InsitutionTierLevel,
        AverageLoanGranted,
        AverageScholarshipGranted,
        OperationType,
        ChangedDateTime
    )
    SELECT
        UniversityID,
        UniversityName,
        ApprovedforLoan,
        ApprovedforScholarships,
        InsitutionTierLevel,
        AverageLoanGranted,
        AverageScholarshipGranted,
        'DELETE',
        GETDATE()
    FROM
        deleted;
END;

GO

-- TEST: ---------------------------------

-- Insert a new record into the ApprovedInstitutions table
INSERT INTO ApprovedInstitutions 
(UniversityID, UniversityName, ApprovedforLoan, ApprovedforScholarships, 
InsitutionTierLevel, AverageLoanGranted, AverageScholarshipGranted)
VALUES ('UNI001', 'ABC University', 'Y', 'N', 'Tier 1', 15000.00, 5000.00);

-- Update an existing record in the ApprovedInstitutions table
UPDATE ApprovedInstitutions
SET AverageLoanGranted = 20000.00
WHERE UniversityID = 'UNI001';

-- Delete a record from the ApprovedInstitutions table
DELETE FROM ApprovedInstitutions
WHERE UniversityID = 'UNI001';

-- Check the data in the audit table after performing the operations
SELECT * FROM ApprovedInstitutionsAudit;