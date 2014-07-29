census = {}
ctrl = 0
i = 0
c = 1
n = 0

year = {}
year.__index = year

types = {}
types.__index = types

record = {}
record.__index = record

function record.create()
	r = {}
	setmetatable(r, record)
	return r
end

function types.create(name,year)
	t = {}
	t.name = name
	t.year = year
	setmetatable(t, types)
	return t
end

function compare(first, second)
	os.execute("cls")
	print("Comparing "..first[2].." with "..second[2])
	wait = io.read()
	ctrl = 0
	for k, v in pairs(first) do
		ctrl = ctrl + 1
		if ctrl > 2 then
			if tonumber(first[ctrl]) > tonumber(second[ctrl]) then
				print(headers[ctrl]..") "..first[ctrl].."  :  "..second[ctrl].."  "..first[2].." is greater than "..second[2].." by ".. (first[ctrl] - second[ctrl]))
			else
				print(headers[ctrl]..") "..first[ctrl].."  :  "..second[ctrl].."  "..second[2].." is greater than "..first[2].." by ".. (second[ctrl] - first[ctrl]))
			end
		else
			print(headers[ctrl]..") "..first[ctrl].."  :  "..second[ctrl])
		end
	end
	wait = io.read()
end

function checkYears(first, second)
	comparab;e = {}
	file = io.open("Datasets/"..first.."/types.txt")
	yearC = ""
	for line in file:lines() do
		yearC = yearC..line
	end
	file = io.open("Datasets/"..second.."/types.txt")
	for line in file:lines() do
		if string.find(yearC, line) ~= nil then
			comparable[#comparable + 1] = line
		end
	end
end

function compareMenu(first, currentYear, headers)
	os.execute("cls")
	print("You are comparing things to : "..first[2])
	for k, v in pairs(census[currentYear.year][currentYear.name]) do
		print("Key : "..v[1].. "  County : "..v[2])
	end
	print('\n  Type the key, including the "", of the selection you would like to make. Type "c" to return to the county menu.')
	x = io.read()
	for k, v in pairs(census[currentYear.year][currentYear.name]) do
		if tostring(x) == v[1] then
			compare(first, v)
		end
	end
	if tostring(x) == "c" then
		currentYear:displayData()
	else
		compareMenu(first, currentYear, headers)
	end

end

function record:display(headers, year)
	os.execute("cls")
	ctrl = 0
	for k, v in pairs(self) do
		ctrl = ctrl + 1
		print(headers[ctrl].." : "..v)
	end
	print("\nType 'c' to compare and anything else to return to the county menu")
	x = io.read()
	if x == "c" then
		compareMenu(self, year, headers)
	end
end

function types:displayData()
	os.execute("cls")
	parseData(self.year, self.name)
	file = io.open("Datasets/"..self.year.."/"..self.name..".txt")
	headers = {}
	ctrl = 0
	for line in file:lines() do
		ctrl = ctrl + 1
		headers[ctrl] = line
	end
	for k, v in pairs(census[self.year][self.name]) do
		print("Key : "..v[1].. "  County : "..v[2])
	end
	print('\nType the key of your selection including the "".  Type "b" to go back.')
	x = io.read()
	for k, v in pairs(census[self.year][self.name]) do
		if tostring(x) == v[1] then
			v:display(headers, self)
		end
	end
	if tostring(x) == "b" then

	else
		self:displayData()
	end

end

function year:loadMenu()
	os.execute("cls")
	file = io.open("Datasets/"..self.name.."/types.txt")
	ctrl = 0
	for line in file:lines() do
		self.types[ctrl] = types.create(line,self.name)
		self.types[ctrl].number = ctrl
		createTypeTable(self.name, self.types[ctrl].name)
		ctrl = ctrl + 1
	end
	ctrls = 0
	for k, v in pairs(self.types) do
		ctrls = ctrls + 1
	end
	for i = 0, ctrls - 1 do
		print(i..")"..self.types[i].name)
	end
	print("\nEnter the selection you would like to make.  Type 'b' to go back to the main menu.")
	x = io.read()
	for k, v in pairs(self.types) do
		if tonumber(x) == v.number then
			v:displayData()
		end
	end
	if tostring(x) == "b" then
		loadMenu()
	else
		self:loadMenu()
	end
end

function year.create(number)
	y = {}
	y.name = number
	setmetatable(y, year)
	return y
end

function createYearTable(year)
	census[year] = {}
end

function createTypeTable(year,type)
	census[year][type] = {}
end

function parseData(year, type)
	file = io.open("Datasets/"..year.."/"..type..".csv")
	ctrl = 0
	for line in file:lines() do
		ctrl = ctrl + 1
		census[year][type][ctrl] = record.create()
		c = 1
		i = 0
		while i < string.len(tostring(line)) do
			i = i + 1
			if string.find(string.sub(tostring(line), c, i), ",") ~= nil then
				pos = string.find(string.sub(tostring(line), c, i), ",") + c
				table.insert(census[year][type][ctrl], string.sub(line, c, i-1))
				c = pos
			end
		end
		table.insert(census[year][type][ctrl], string.sub(line, c, i))
	end
end

function load()
	file = io.open("Datasets/years.txt")
	years = {}
	ctrl = 0
	for line in file:lines() do
		years[ctrl] = year.create(line)
		years[ctrl].number = ctrl + 1
		years[ctrl].types = {}
		f = io.open("Datasets/"..years[ctrl].name.."/types.txt")
		ctrls = 0
		for l in f:lines() do
			years[ctrl].types[ctrls] = l
			ctrls = ctrls + 1
		end
	end
end

function loadMenu()
	os.execute("cls")
	ctrl = 0
	for k, v in pairs(years) do
		ctrl = ctrl + 1
	end
	for i = 0, ctrl - 1 do
		print((i + 1)..") "..years[i].name)
	end
	print("\nEnter the value you would like to select. Enter 'e' to exit.")
	x = io.read()
	for k, v in pairs(years) do
		if tonumber(x) == v.number then
			createYearTable(v.name)
			v:loadMenu()
		end
	end
	if tostring(x) == "e" then
		os.exit()
	else
		loadMenu()
	end
	loadMenu()
end

load()
loadMenu()

--[[for k, v in pairs(census["2001"]["ethnic"][1]) do
	print(v)
	end]]
