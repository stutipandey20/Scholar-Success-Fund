-- This script uses function CheckLoanAndScholarshipEligibility

USE Scholar_Success_Fund
GO
-- Check if the stored procedure exists and drop it if it does
IF OBJECT_ID('dbo.LoanAndScholarshipEligibilityChecking', 'P') IS NOT NULL
    DROP PROCEDURE dbo.LoanAndScholarshipEligibilityChecking;
GO

-- Create the stored procedure
CREATE PROCEDURE dbo.LoanAndScholarshipEligibilityChecking
    @GPA DECIMAL(3,2),
    @DisabilityStatus VARCHAR(1),
    @Gender VARCHAR(10),
    @Race VARCHAR(10),
    @UniversityName VARCHAR(100),
    @CourseFees DECIMAL(10,2),
    @Degree VARCHAR(20),
    @AnnualIncome DECIMAL(10,2),
    @CreditScore INT,
    @ScholarshipUniversity DECIMAL(10,2)
AS
BEGIN
    -- Call the function and return its results
    SELECT * FROM dbo.CheckLoanAndScholarshipEligibility
	(@GPA, @DisabilityStatus, @Gender, @Race, @UniversityName, @CourseFees, @Degree, @AnnualIncome, @CreditScore, @ScholarshipUniversity);
END;
GO


-- To test this

EXEC dbo.LoanAndScholarshipEligibilityChecking
    3.8, 'N', 'Male', 'Black', 'Arizona State University', '40000.00', 'Master', '60000.00', '715', '3000.00';
