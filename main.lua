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

function displayYearCompareData(firstYear, secondYear, county, headers)
	os.execute("cls")
	parseData(secondYear.year, secondYear.name)
	file = io.open("Datasets/"..secondYear.year.."/"..secondYear.name..".txt")
	ctrl = 0
	jointHeaders = {}
	for line in file:lines() do
		ctrl = ctrl + 1
		ctrls = 0
		f = io.open("Datasets/"..firstYear.year.."/"..firstYear.name..".txt")
		for lined in f:lines() do
			ctrls = ctrls + 1
			if line == lined then
				jointHeaders[ctrl] = {ctrl, ctrls, line}
			end
		end
	end
	for k, v in pairs(census[firstYear.year][firstYear.name]) do
		if v[2] == county[2] then
			for keys, values in pairs(census[secondYear.year][secondYear.name]) do
				if ('"'..values[2]..'"') == v[2] then
					print(firstYear.year.." to "..secondYear.year)
					for i = 1, #values do
						if jointHeaders[i] then
							print(jointHeaders[i][3]..") "..v[(jointHeaders[i][2])].." to "..values[(jointHeaders[i][1])])
						end
					end
					wait = io.read()
				end
			end
		end
	end
end

function compare(first, second)
	os.execute("cls")
	print("Comparing "..first[2].." with "..second[2].."\n\n")
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

function checkYears(firstYear, secondYear, types)
	file = io.open("Datasets/"..firstYear.."/types.txt")
	yearC = ""
	for line in file:lines() do
		if line == tostring(types) then
			yearC = true
		end
	end
	if yearC == true then
		file = io.open("Datasets/"..secondYear.."/types.txt")
		for line in file:lines() do
			if line == tostring(types) then

				return true
			end
		end
	end
end

function compareYearMenu(firstYear, county, headers)
	os.execute("cls")
	print("These years contain "..firstYear.name..".\n\n")
	for k,  v in pairs(years) do
		if v ~= nil then
			if checkYears(firstYear.year, v.name, firstYear.name) then
				print(v.name)
			end
		end
	end
	print("\nType the name of your selection.  Type 'b'")
	x = io.read()
	--takes apart years table
	for k, v in pairs(years) do
		if tostring(x) == v.name then
				ctrl = 0
				for key, value in pairs(v) do
					ctrl = ctrl + 1
						if ctrl == 3 then
							ctrls = 0
							--ka/ke is key va/ve is value in table
							for ke, va in pairs(value) do
								ctrls = 0
								for ka, ve in pairs(va) do
									ctrls = ctrls + 1
									if tostring(ve) == firstYear.name then
										displayYearCompareData(firstYear, va, county, headers)
									end
								end
							end

						end
				end
		end
	end
	if tostring(x) == "b" then
		compareMenu(county, firstYear, headers)
	else
		compareYearMenu(firstYear, county, headers)
	end

end

function compareMenu(first, currentYear, headers)
	os.execute("cls")
	print("You are comparing things to : "..first[2])
	for k, v in pairs(census[currentYear.year][currentYear.name]) do
		print("Key : "..v[1].. "  County : "..v[2])
	end
	print('\n  Type the key of the selection you would like to make. Type "c" to return to the county menu.  Type "y" to compare to the same county in a different census.')
	x = io.read()
	sm1, sm2 = string.find(x,'"')
	sm3, sm4 = string.find(census[currentYear.year][currentYear.name][1][1], '"')
	if sm3 ~= nil and sm4 ~= nil then
		if sm1 ~= nil and sm2 ~= nil then
			for k, v in pairs(census[currentYear.year][currentYear.name]) do
				if tostring(x) == v[1] then
					compare(first, v)
				end
			end
		else
			for k, v in pairs(census[currentYear.year][currentYear.name]) do
				if '"'..tostring(x)..'"' == v[1] then
					compare(first, v)
				end
			end
		end
	else
		for k, v in pairs(census[currentYear.year][currentYear.name]) do
				if tostring(x) == v[1] then
					compare(first, v)
				end
			end
	end
	if tostring(x) == "c" then
		currentYear:displayData()
	elseif tostring(x) == "y" then
		compareYearMenu(currentYear, first, headers)
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
	print('\nType the key of your selection.  Type "b" to go back.')
	x = io.read()
	sm1, sm2 = string.find(x, '"')
	sm3, sm4 = string.find(census[self.year][self.name][1][1], '"')
	if sm3 ~= nil and sm4 ~= nil then
		if sm1 ~= nil and sm2 ~= nil then
			for k, v in pairs(census[self.year][self.name]) do
				if x == v[1] then
					v:display(headers, self)
				end
			end
		else
			for k, v in pairs(census[self.year][self.name]) do
				if '"'..x..'"' == v[1] then
					v:display(headers, self)
				end
			end
		end
	else
		for k, v in pairs(census[self.year][self.name]) do
			if x == v[1] then
				v:display(headers, self)
			end
		end
	end
	if tostring(x) == "b" then

	else
		self:displayData()
	end

end

function year:load()
	file = io.open("Datasets/"..self.name.."/types.txt")
	ctrld = 0
	for line in file:lines() do
		self.types[ctrld] = types.create(line, self.name)
		self.types[ctrld].number = ctrld
		createTypeTable(self.name, self.types[ctrld].name)
		ctrld = ctrld + 1
	end
end

function year:loadMenu()
	os.execute("cls")
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
		createYearTable(years[ctrl].name)
		years[ctrl]:load()
		ctrl = ctrl + 1
	end
	loadMenu()
end

function loadMenu()
	os.execute("cls")
	ctrl = 1
	for k, v in pairs(years) do
		print(v.number..") "..v.name)
		ctrl = ctrl + 1
	end
	print("\nEnter the value you would like to select. Enter 'e' to exit.")
	x = io.read()
	for k, v in pairs(years) do
		if tonumber(x) == v.number then
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

--[[for k, v in pairs(years) do
	ctrl = 0
	for key, value in pairs(v) do
		ctrl = ctrl + 1
		print(value)
		if ctrl == 3 then
			for ke, va in pairs(value) do
				print(va)
			end
		end
	end
	wait = io.read()
end]]--
