if love.filesystem.exists("StudentAccountSave") then
	StudentAccount = loadstring(love.filesystem.read("StudentAccountSave"))()
	Class = loadstring(love.filesystem.read("ClassSave"))()
else
	StudentAccount = {}
	Class = {}
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
	return newStudent.StudentID
end

function addClass(ClassName, JoinCode)
	local ClassNo = #Class
	local newClass = {
		ClassName = ClassName,
		JoinCode = JoinCode
	}
	table.insert(Class, newClass)
	return newClass.ClassID
end

