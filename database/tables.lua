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
		FinalRanking = nil
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
		if tournament.ClassName == ClassName and not tournament.FinalRanking then
			return true
		end
	end
	return false
end

function UpdateTournamentRanking(ClassName, Ranking) 	-- Stores the final ranking of a tournament in the database
	for i,t in ipairs(Tournament) do
		if t.ClassName == ClassName then
			t.FinalRanking = loadstring(Ranking)()
			return true
		end
	end
	return false
end

function FetchTournamentRanking(ClassName)				-- Returns the tournament ranking for the tournament finished by the class
	for i,t in ipairs(Tournament) do
		if t.ClassName == ClassName then
			return t.FinalRanking
		end
	end
	return false
end

function ReturnRankedStudents(Ranking)
	rank = {}
	for i,j in pairs(Ranking) do
		print(j.ID)
		local name = FindStudentName(j.ID)
		print(name or "no name")
		table.insert(rank, { Name = name, Score = j.score })
		print()
	end
	return rank
end

function FindStudentName(StudentID)
	for i,student in ipairs(StudentAccount) do
		print("So: ")
		print(student.StudentID)
		print(StudentID)
		print("End")
		if tonumber(student.StudentID) == tonumber(StudentID) then
			print("Name: "..student.Forename.." "..student.Surname)
			return student.Forename.." "..student.Surname
		end
		print()
	end
	return false
end
