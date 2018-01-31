StudentAccount = {}
TeacherAccount = {}
Class = {}
Tournament = {}
TournamentMatch = {}
StudentMatch = {}

function addStudentAccount(Forename, Surname, EmailAddress, ClassName)
	local StudentNo = #StudentAccount
	local newStudent = {
		StudentID = StudentNo + 1,
		Forename = Forename,
		Surname = Surname,
		EmailAddress = EmailAddress,
		ClassName = ClassName
	}
	table.insert(StudentAccount, newStudent)
	return newStudent.StudentID
end

function addClass(ClassName)
	local ClassNo = #Class
	local newClass = {
		ClassName = ClassName,
		ClassID = ClassNo + 1
	}
	table.insert(Class, newClass)
	return newClass.ClassID
end

function addStudentMatch(StudentID, TournamentID)
	local MatchNo = #StudentMatch
	local newMatch = {
		StudentMatchID = MatchNo + 1,
		StudentID = StudentID,
		TournamentID = TournamentID
	}
	table.insert(StudentMatch, newMatch)
	return newMatch.StudentMatchID
end

function addTournamentMatch(StudentMatch1, StudentMatch2, TournamentID)
	local MatchNo = #TournamentMatch
	local newMatch = {
		MatchID = MatchNo + 1,
		StudentMatch1 = StudentMatch1,
		StudentMatch2 = StudentMatch2,
		TournamentID = TournamentID
	}
	table.insert(TournamentMatch, newMatch)
	return newMatch.MatchID
end

function addTournament(TeacherID, WinnerID)
	local TournamentNo = #Tournament
	local newTournament = {
		TournamentID = TournamentNo + 1,
		WinnerID = WinnerID,
		TeacherID = TeacherID
	}
	table.insert(Tournament, TournamentNo)
	return newTournament.TournamentID
end

function TournamentWinner(TournamentID, WinnerID)
	for i,T in ipairs(Tournament) do
		if T.TournamentID == TournamentID then
			T.WinnerID = WinnerID
		end
	end
	return 
end

function ClassExists(ClassName)
	for i,j in ipairs(Class) do
		if j.ClassName == ClassName then return true end
	end
	return false
end



