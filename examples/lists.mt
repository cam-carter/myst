memory = [1, 1]

n = 200
x = 2
while x <= n
  memory[x] = memory[x-1] + memory[x-2]
  x = x + 1
end

puts(memory[n])

puts([1, 2, 3] == [1, 2, 3])

puts([1, 2, 3])