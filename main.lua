census = {}
ctrl = 0
i = 0
c = 1
n = 0

year = {}
year.__index = year

types = {}
types.__index = types

function types.create(name)
	t = {}
	t.name = name
	setmetatable(t, types)
	return t
end

function year:loadMenu()
	os.execute("cls")
	file = io.open("Datasets/"..self.name.."/types.txt")
	ctrl = 0
	for line in file:lines() do
		self.types[ctrl] = types.create(line)
		createTypeTable(self.name, self.types[ctrl].name)
	end
	ctrls = 0
	for k, v in pairs(self.types) do
		ctrls = ctrls + 1
	end
	for i = 0, ctrl do
		print(i..")"..self.types[ctrl].name)
	end
	print("\nEnter the selection you would like to make")

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
	for line in file:lines() do
		ctrl = ctrl + 1
		census[year][type][ctrl] = {}
		while i < string.len(line) do
			i = i + 1
			if string.find(string.sub(line, c, i), ",") ~= nil then
				pos = string.find(string.sub(line, c, i), ",") + c
				table.insert(census[year][type][ctrl], string.sub(line, c, i-1))
				c = pos
				n = n + 1
			end
		end
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
	ctrl = 0
	for k, v in pairs(years) do
		ctrl = ctrl + 1
	end
	for i = 0, ctrl - 1 do
		print((i + 1)..") "..years[i].name)
	end
	print("\nEnter the value you would like to select.")
	x = io.read()
	for k, v in pairs(years) do
		if x == v.number then
			createYearTable(v.name)
		end
	end
end

load()
loadMenu()

--[[for k, v in pairs(census["2001"]["ethnic"][1]) do
	print(v)
	end]]
