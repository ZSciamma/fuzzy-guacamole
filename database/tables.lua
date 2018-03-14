StudentAccount = {}
Class = {}
Tournament = {}

function addStudentAccount(StudentID, Forename, Surname, ClassName, Level)
	local newStudent = {
		StudentID = StudentID,
		Forename = Forename,
		Surname = Surname,
		ClassName = ClassName,
		Level = Level
	}
	table.insert(StudentAccount, newStudent)
	return newStudent.StudentNo
end

function addClass(ClassName, JoinCode)
	local newClass = {
		ClassName = ClassName,
		JoinCode = JoinCode
	}
	table.insert(Class, newClass)
	return 
end

function addTournament(ClassName, RoundTime, StartDate)
	local TournamentNo = #Tournament
	local newTournament = {
		TournamentID = TournamentNo + 1,
		ClassName = ClassName,
		RoundTime = RoundTime,						-- In days
		StartDate = StartDate,
		WinnerID = nil
	}
	table.insert(Tournament, newTournament)
	return newTournament.TournamentID
end

function studentNumber(ClassName)
	local number = 0
	for i,student in ipairs(StudentAccount) do
		if student.ClassName == ClassName then
			number = number + 1
		end
	end
	return number
end

function studentList(ClassName)
	local students = {}
	for i,student in ipairs(StudentAccount) do
		if student.ClassName == ClassName then
			table.insert(students, { 
				StudentID = StudentID,
				Forename = student.Forename,
				Surname = student.Surname,
			})
		end
	end
	return students
end

function IsInTournament(ClassName)
	for i,tournament in ipairs(Tournament) do
		if tournament.ClassName == ClassName then
			return true
		end
	end
	return false
end