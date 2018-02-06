if love.filesystem.exists("StudentAccountSave") then
	StudentAccount = loadstring(love.filesystem.read("StudentAccountSave"))()
	Class = loadstring(love.filesystem.read("ClassSave"))()
	Tournament = loadstring(love.filesystem.read("TournamentSave"))()
else
	StudentAccount = {}
	Class = {}
	Tournament = {}
end

function addStudentAccount(Forename, Surname, EmailAddress, ClassName)
	local StudentNo = #StudentAccount
	local newStudent = {
		StudentNum = StudentNo + 1,
		Forename = Forename,
		Surname = Surname,
		EmailAddress = EmailAddress,
		ClassName = ClassName
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
end

function addTournament(ClassName, MaxDuration, Matches)
	local TournamentNo = #Tournament
	local newTournament = {
		TournamentNum = TournamentNo + 1,
		ClassName = ClassName,
		MaxDuration = MaxDuration,			-- In days
		Matches = Matches					-- Number of matches per player
	}
	table.insert(Tournament, newTournament)
	return TournamentNum
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
				StudentNum = StudentNum,
				Forename = student.Forename,
				Surname = student.Surname,
			})
		end
	end
	return students
end

function ValidateTournament(ClassName)
	for i,tournament in ipairs(Tournament) do
		if tournament.ClassName == ClassName then
			return false
		end
	end
	return true
end
