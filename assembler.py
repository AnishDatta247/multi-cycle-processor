import os

s = ""
i = 0


def decimal_to_binary(decimal_number, bits):
    binary_string = ""
    isneg = decimal_number < 0
    x = 0
    if isneg:
        x = (1 << bits) + decimal_number
    else:
        x = decimal_number
    while x > 0:
        remainder = x % 2
        binary_string = str(remainder) + binary_string
        x //= 2

    # Pad the binary string with leading zeros to make it 6 bits long
    binary_string = binary_string.zfill(bits)
    return binary_string


with open(os.path.join(os.getcwd(), "BubbleSortMIPS.txt")) as f:
    lines = f.readlines()
    for line in lines:
        s += "mem[" + str(i) + "]" + " <= "
        i += 1
        ins = line.split()[0]
        options = [
            "ADD",
            "ADDI",
            "SUB",
            "SUBI",
            "AND",
            "ANDI",
            "OR",
            "ORI",
            "XOR",
            "XORI",
            "NOT",
            "NOTI",
            "SLA",
            "SLAI",
            "SRA",
            "SRAI",
            "SRL",
            "SRLI",
            "LD",
            "ST",
            "LDSP",
            "STDP",
            "BR",
            "BMI",
            "BPL",
            "BZ",
            "PUSH",
            "POP",
            "CALL",
            "RET",
            "MOVE",
            "HALT",
            "NOP",
        ]

        for pos, option in enumerate(options):
            if ins == option:
                ins = pos

        operands = line.split()[1].split(",")
        print(operands, ins)

        if ins in [18, 19, 20, 21]:
            hasImm = 1
            ins = decimal_to_binary(ins, 6)
            ins += decimal_to_binary(
                int(operands[-1].split("(")[1].split(")")[0][1:]), 5
            )
            if operands[0] == "SP":
                ins += "11111"
            else:
                ins += decimal_to_binary(int(operands[0][1:]), 5)
            ins += decimal_to_binary(int(operands[-1].split("(")[0]), 32 - len(ins))
        else:
            hasImm = operands[-1][0] == "#"
            ins = decimal_to_binary(ins, 6)
            if hasImm:
                if len(operands) == 2:
                    ins += decimal_to_binary(int(operands[0][1:]), 5)
                elif len(operands) == 3:
                    ins += decimal_to_binary(int(operands[1][1:]), 5)
                    ins += decimal_to_binary(int(operands[0][1:]), 5)
                ins += decimal_to_binary(int(operands[-1][1:]), 32 - len(ins))
            else:
                if len(operands) >= 2:
                    ins += decimal_to_binary(int(operands[1][1:]), 5)
                if len(operands) >= 3:
                    ins += decimal_to_binary(int(operands[2][1:]), 5)
                if len(operands) >= 1:
                    ins += decimal_to_binary(int(operands[0][1:]), 5)
                ins += decimal_to_binary(0, 32 - len(ins))

        s += "32'b" + ins + ";\n"
    print(s)
