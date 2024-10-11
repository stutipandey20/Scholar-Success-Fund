-- Creating a function here

USE Scholar_Success_Fund
GO
-- drop the function CheckLoanAndScholarshipEligibility if it already exists
IF OBJECT_ID('dbo.CheckLoanAndScholarshipEligibility') IS NOT NULL
	DROP FUNCTION dbo.CheckLoanAndScholarshipEligibility;
GO


CREATE FUNCTION CheckLoanAndScholarshipEligibility 
(
    -- Parameters directly related to loan and scholarship determination
    @GPA DECIMAL(3,2),
	@DisabilityStatus VARCHAR(1),
	@Gender VARCHAR(10),
	@Race VARCHAR(10),
    @ProvideUniversityName VARCHAR(100),
    @CourseFees DECIMAL(10,2),
	@Degree VARCHAR(20),
    @AnnualIncomeofCoborrower DECIMAL(10,2),
    @CreditScore INT,
	@ScholarshipAmountbyUniversity DECIMAL(10,2)
)
RETURNS @EligibilityDetails TABLE
(
    LoanAmount VARCHAR(100),
    InterestRate DECIMAL(5,2),
	ScholarshipAmountbyUs DECIMAL(10,2)
)
AS
BEGIN
    -- Determine scholarship based on different Criterias

	DECLARE @ScholarshipAmountbyUs DECIMAL(10,2) = 0;
	SELECT @ScholarshipAmountbyUs = MAX(Amount)
FROM ScholarshipEligibility
WHERE Category IN 
(
    SELECT DISTINCT CASE 
        WHEN @GPA >= 3.5 AND @DisabilityStatus = 'Y' AND Category = 'Disability and Academic' THEN 'Disability and Academic'
        WHEN @GPA >= 3.5 AND @Gender = 'Female' AND Category = 'Gender-Academic' THEN 'Gender-Academic'
        WHEN @GPA >= 3.5 AND Category = 'Academic' THEN 'Academic'
        WHEN @DisabilityStatus = 'Y' AND Category = 'Disability' THEN 'Disability'
        WHEN @Gender = 'Female' AND Category = 'Gender Based' THEN 'Gender Based'
        WHEN @Race = 'Black' AND Category = 'Black-Ethinicity Based' THEN 'Black-Ethinicity Based'
        WHEN @Race = 'Native American' AND Category = 'Native American-Ethinicity Based' THEN 'Native American-Ethinicity Based'
        WHEN @Race = 'International' AND Category = 'International-Ethinicity Based' THEN 'International-Ethinicity Based'
    END
    WHERE Category IS NOT NULL
);

    -- Assume default scholarship if none applicable
    IF @ScholarshipAmountbyUs IS NULL
        SET @ScholarshipAmountbyUs = 0;

    -- Initialize loan variables
    DECLARE @LoanAmount DECIMAL(10,2) = 0;
    DECLARE @InterestRate DECIMAL(5,2) = 0;
    DECLARE @Approved VARCHAR(1);

    -- Check if the university is approved
    SELECT @Approved = ApprovedforLoan
    FROM ApprovedInstitutions
    WHERE UniversityName = @ProvideUniversityName;

	-- To check the fees for 1 year, we will need to understand the degree
	DECLARE @OneYearFees DECIMAL(10,2);
	SELECT @OneYearFees = CASE 
                        WHEN @Degree = 'Bachelor' THEN (@CourseFees / 4)
                        WHEN @Degree = 'Master' THEN (@CourseFees / 2)
                        WHEN @Degree = 'Doctorate' THEN (@CourseFees / 5)
                        ELSE 0 -- In case no matching condition
                      END;


    -- Determine loan eligibility
    IF @Approved = 'Y' AND @GPA > 3.0 AND @CreditScore >= 650 AND ((@OneYearFees) * 2) < @AnnualIncomeofCoborrower
    BEGIN
        SET @LoanAmount = CASE 
					WHEN @CourseFees > @ScholarshipAmountbyUniversity THEN @CourseFees - @ScholarshipAmountbyUniversity 
					ELSE 0 
	END;
        -- Calculate the interest rate based on the formula provided
        SET @InterestRate = ( (@CourseFees / @AnnualIncomeofCoborrower) * @CreditScore) / 100;
    END

	IF @LoanAmount = 0
	BEGIN 
		SET @ScholarshipAmountbyUs = 0			-- IF Loan is not approved, scholarship is also 0
	END;

    -- Insert calculated financial details into the table to be returned
    INSERT INTO @EligibilityDetails (LoanAmount, InterestRate, ScholarshipAmountbyUs)
    VALUES (@LoanAmount, @InterestRate, @ScholarshipAmountbyUs);

    RETURN;
END
GO

