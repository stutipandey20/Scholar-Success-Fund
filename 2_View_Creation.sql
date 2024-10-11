-- View to check approved Loans & the details about loans such as the amount of loan, the co-borrower details where Loan amount is greater than 50,000:

CREATE VIEW ApprovedLoansDetails AS
	SELECT AL.ApplicantID, AL.UniversityID, AL.ApprovedLoanAmount,
		AL.ApprovedScholarshipAmount, AL.ValidThrough, AL.InterestRate,
		CD.CoBorrowerID, CD.CoBorrowerName, CD.CoBorrowerAddress,
		CD.CoBorrowerPhoneNumber, CD.CoBorrowerEmail, CD.Occupation,
		CD.RelationshipToStudent
	FROM ApprovedLoans AL
		INNER JOIN CoBorrowerDetails CD ON AL.ApplicantID = CD.ApplicantID
	WHERE AL.ApprovedLoanAmount >= 50000.00;

GO

select * from ApprovedLoansDetails;

GO

-- How much disbursement is remaining and how much is given:

CREATE VIEW DisbursementStatus AS
	SELECT D.ApplicantID,
		(SELECT SUM(AmountRequested) FROM Application WHERE ApplicantID = D.ApplicantID) AS TotalRequested,
			(SELECT SUM(ApprovedLoanAmount) FROM ApprovedLoans 
				WHERE ApplicantID = D.ApplicantID) AS TotalAllocated,
				SUM(D.AmountDisbursed) AS TotalDisbursed,
			(SELECT SUM(ApprovedLoanAmount) FROM ApprovedLoans 
				WHERE ApplicantID = D.ApplicantID) - SUM(D.AmountDisbursed) AS RemainingDisbursement
	FROM 
	Disbursement D
	GROUP BY 
	D.ApplicantID;

GO

select * from DisbursementStatus;

GO

-- University Scholarship Allocation: This view will report how much amount of scholarships allocated to students by university for a given university:

CREATE VIEW UniversityScholarshipAllocation AS
	SELECT
		A.UniversityName,
		SUM(A.ScholarshipAmountbyUniversity) AS TotalScholarshipAllocated
		FROM
		Application A
	WHERE UniversityName = 'Arizona State University'
	GROUP BY
	A.UniversityName;

GO

select * from UniversityScholarshipAllocation;