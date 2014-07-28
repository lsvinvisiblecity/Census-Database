census = {}
ctrl = 0
i = 0
c = 1
n = 0

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

createYearTable("2001")
createTypeTable("2001", "ethnic")
parseData("2001", "ethnic")

for k, v in pairs(census["2001"]["ethnic"][1]) do
	print(v)
end
wait = io.read()
