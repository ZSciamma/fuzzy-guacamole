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

function addTournament(ClassName, RoundLength, QsPerMatch, LastRound)
	local TournamentNo = #Tournament
	local newTournament = {
		TournamentID = TournamentNo + 1,
		ClassName = ClassName,
		RoundLength = RoundLength,
		QsPerMatch = QsPerMatch,
		LastRound = LastRound,
		Ranking = nil
	}
	table.insert(Tournament, newTournament)
	return newTournament.TournamentID
end

function studentNumber(ClassName)					-- Returns the number of students in a class
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

function IsInTournament(ClassName)						-- Checks whether a class currently has a tournament running
	for i,tournament in ipairs(Tournament) do
		if tournament.ClassName == ClassName then
			return true
		end
	end
	return false
end

function UpdateTournamentRanking(ClassName, Ranking) 	-- Stores the final ranking of a tournament in the database
	for i,t in ipairs(Tournament) do
		if t.ClassName == ClassName then
			t.Ranking = loadstring(Ranking)() 
			return true
		end
	end
	return false
end


