-- Cursor ------------------------------

-- Generate a report that displays the total number of loans approved for each institution along with the average approved loan amount.

-- drop the cursor LoanCursor if it already exists

IF OBJECT_ID('tempdb..#LoanApprovalReport') IS NOT NULL
    DROP TABLE #LoanApprovalReport;

-- Create Cursor Script:
-- Create a cursor to iterate over the approved loans

DECLARE @UniversityID VARCHAR(10);
DECLARE @TotalLoans INT;
DECLARE @TotalLoanAmount DECIMAL(10, 2);
DECLARE @AverageLoanAmount DECIMAL(10, 2);

-- Create temporary table to store results
CREATE TABLE #LoanApprovalReport (
UniversityID VARCHAR(10),
TotalLoans INT,
AverageLoanAmount DECIMAL(10, 2)
);

-- Initialize cursor
DECLARE LoanCursor CURSOR FOR
SELECT UniversityID
FROM ApprovedLoans;

-- Open cursor
OPEN LoanCursor;

-- Fetch first row
FETCH NEXT FROM LoanCursor INTO @UniversityID;

-- Loop through each row
WHILE @@FETCH_STATUS = 0
BEGIN
    -- current institution
    SELECT @TotalLoans = COUNT(*), @TotalLoanAmount = SUM(ApprovedLoanAmount)
    FROM ApprovedLoans
    WHERE UniversityID = @UniversityID;

    -- Calculate average loan amount
    IF @TotalLoans > 0
    BEGIN
        SET @AverageLoanAmount = @TotalLoanAmount / @TotalLoans;
    END
    ELSE
    BEGIN
        SET @AverageLoanAmount = 0;
    END;

    -- Insert results into temporary table
    INSERT INTO #LoanApprovalReport (UniversityID, TotalLoans, AverageLoanAmount)
    VALUES (@UniversityID, @TotalLoans, @AverageLoanAmount);

    -- Fetch next row
    FETCH NEXT FROM LoanCursor INTO @UniversityID;
END;


-- Close cursor
CLOSE LoanCursor;
DEALLOCATE LoanCursor;


-- Select results from temporary table
SELECT * FROM #LoanApprovalReport;


