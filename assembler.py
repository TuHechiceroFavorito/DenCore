# Assembler for my CPU


# Array to store the code
code = []

with open("Assembly/algo.asm", "r") as f:
    code = f.read()

code = code.split("\n")

# Remove all comments
code_no_comments = []
for line in code:
    comment_position = line.find("//")
    if comment_position != -1:
        new_instruction = line[:comment_position].strip()
    else:
        new_instruction = line.strip()
    if new_instruction == "":
        continue

    code_no_comments.append(new_instruction)

binary = ""
instr = []

# Dictonary that translates an assembly mnemonic into binary
translation = {"NOP":"00000",
                "LI":"00001",
                "SI":"00010",
                "LB":"00011",
                "SB":"00100",
                "J":"00101",
                "BEQ":"00110",
                "BNQ":"00111",
                "BGT":"01000",
                "AND":"10000",
                "OR":"10001",
                "XOR":"10010",
                "NOT":"10011",
                "ADD":"10100",
                "SUB":"10101",
                "MULT":"10110",
                "DIV":"10111",
                "SR":"11000",
                "SL":"11001",
                "EQ":"11010",
                "GT":"11011",
                "A":"00",
                "B":"01",
                "r0":"10",
                "r1":"11"}


jumps = []          # Tags of each address to jump to
addresses = {}      # Address in memory where each instruction is stored
current_address = 0 # Address in memory where the last instruction has been stored

# Necesary for encoding negative numbers
def twos_complement(n, bits):
    return format(n & ((1 << bits) - 1), f'0{bits}b')

# Translate all code into binary, taking care of branching
for line in code_no_comments:
    print(current_address)
    if line[:2] == "LC":        # Encode a number. If negative need to do the 2s complement
        if line[-1] == "h":
            number = format(int(line[3:-1], 16), "b")
        else:
            number = twos_complement(int(line[3:]), 7)
        binary += number
        binary += "1\n" # Add a 1 at the end, as this is the type bit of the instruction
        instr.append(binary)
        current_address += 1    # Move address forward
    elif (line[0] == "J"):      # Jump
        jumps.append(line[2:])  # Store the tag of the address to jump to
        binary += (line)        
        instr.append(binary)    # Append the instruction.
        current_address += 2
    elif (line[0] == "B"):      # Conditional branch
        jumps.append(line[4:])
        binary += (line)
        instr.append(binary)
        current_address += 2
    elif (line[-1] == ":"):     # Store the address corresponding to the tag
        if current_address != 0:
            addresses[line[:-1]] = current_address
        else:
            addresses[line[:-1]] = 0
    else:                       # Translate all mnemonics
        for mnemonic in line.split(" "):
            binary += translation[mnemonic]
        binary += "0\n"         # It's an operation, therefore las bit is a 0
        current_address += 1
        instr.append(binary)
    binary = ""
print(current_address)
print(instr)
print(jumps)
print(addresses)

# Convert all address tags into their corresponding address number
binary_jumps = ""
for i in range(len(instr)):
    if instr[i][0] == "J":
        number = str(bin(addresses[instr[i][2:]]))[2:]
        binary += number
        binary += "1\n"
        binary += translation["J"] + "000\n"
    elif instr[i][0] == "B":
        number = str(bin(addresses[instr[i][4:]]))[2:]
        binary += number
        binary += "1\n"
        binary += translation[instr[i][:3]] + "000\n"
    else:
        binary += instr[i]

print(binary)

# Fill the rest of the memory with 0s, which is equivalent to NOP
for i in range(256-len(code_no_comments)):
    binary += "0\n"

# Write the final binary to a file
with open("rom_image.mem", "w") as f:
    f.write(binary)