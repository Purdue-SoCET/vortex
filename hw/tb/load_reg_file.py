"""
    socet115 / zlagpaca@purdue.edu
    Zach Lagpacan

    script to create faking ram_fake_reg_file.sv source for given .hex file which interfaces directly with ]
    Vortex memory interfacing signals

    usage:
    
    commandline:
    python3 load_reg_file.py <.hex file name> <flags>

    flags:
        -p = print debugging info

    general process:
        - parse intelhex file, putting contiguous chunks of data into different register files
            -> TODO: limit max register file size? -> more groupings but less in group
        - create binary hash and other simple combinational logic to route top level Vortex memory 
            interface I/O to given register files
"""

# imports
import sys

# consts:
WORD_W = 32
DO_PRINTS = False

# classes:

# class for classifying chunk of data
class Chunk():

    # instance vars:
    # start_addr -> starting address for chunk
    # id -> number corresponding to chunk, starting from 1
    # word_list -> list of data words starting from addr
    # word_size -> number of contiguous words in chunk
    # byte_size -> number of contiguous bytes in chunk
    # NUM_BYTES -> 2 ** ceil(log2(number of words)) = total number of words for reg size  
    # SEL_W -> ceil(log2(number of words)) = number of bits needed to select word for reg size

    # methods:

    # init
    def __init__(self, id, start_addr):
        self.start_addr = start_addr
        self.bin_start_addr = hex_str_to_bin_str(self.start_addr)
        self.id = id
        self.word_list = []
        self.word_size = 0
        self.byte_size = 0
        self.NUM_BYTES = 0
        self.SEL_W = 0
        
    # add word to chunk
    def append(self, word):
        self.word_list.append(word)
        self.word_size += 1

    # update class variables
    def update_vars(self):
        self.byte_size = self.word_size * 4
        self.SEL_W = bits_needed(self.word_size)
        self.NUM_WORDS = 1 << self.SEL_W

    # print output
    def __repr__(self):
        return  f"chunk start address:\n" + \
                f"    hex:              {self.start_addr}\n" + \
                f"    bin:              {self.bin_start_addr}\n" + \
                f"chunk id:             {self.id}\n" + \
                f"chunk word size:      {self.word_size}\n" + \
                f"chunk byte size:      {self.byte_size}\n" + \
                f"chunk NUM_WORDS:      {self.NUM_WORDS}\n" + \
                f"chunk SEL_W:          {self.SEL_W}\n" + \
                f"chunk word list:      {self.word_list}\n"


# funcs:

def hex_str_to_bin_str(hex_str):
    """
    function for converting hex string to binary string

    parameters: 
        hex_str: string of hex digits (no 0x)

    output:
        bin_str: string of binary digits (no 0b)
    """
    bin_str = ""

    for char in hex_str:
        hex_to_bin = bin(int(char, 16))[2:]
        if (len(hex_to_bin) < 4):
            hex_to_bin = (4 - len(hex_to_bin)) * "0" + hex_to_bin
        bin_str += hex_to_bin

    return bin_str

def bits_needed(n):
    """
    function calculating the number of bits needed to represent n different things

    parameters:
        n: number of things to represent

    output:
        number of bits needed to represent n things
    """
    return (n - 1).bit_length()


def word_match_start(word_list):
    """
    function to give longest starting bit string common to all words in word_list

    parameters: 
        word_list: list of word-length hex character strings

    outputs:
        bin_string: binary character string common to beginning of all words in word_list
    """
    
    bin_string = ""
    break_loop = False
    bin_word_list = [hex_str_to_bin_str(word) for word in word_list]

    if (DO_PRINTS):
        print(word_list)
        print(bin_word_list)

    # iterate through increasing bit sequence
    for i in range(WORD_W):

        # check all words for no match
        for bin_word in bin_word_list:
            if not(bin_word.startswith(bin_string)):
                break_loop = True
                break

        if (break_loop):
            break
        
        # all words match, add this bit to bin_string
        bin_string += bin_word_list[0][i]

    if (DO_PRINTS):
        print(f"bin_string: {bin_string}")

    return bin_string


# parse intel hex str lines into list of chunks of words and accompanying info
def parse_intelhex(intelhex_lines):
    """
    function to parse out intel hex str lines into list of chunks

    parameters:
        intelhex_lines: list of strings of stripped intel hex file lines

    outputs:
        chunk_list: list of chunk objects with info on chunks and words in chunk
    """
        
    # iterate through intel hex str lines, checking for different record types, making corresponding chunks
    chunk_list = []
    chunk_num = 0
    line_num = 0
    for line in intelhex_lines:
        line_num += 1

        # check for eof
        if (line[7:8 +1] == "01"):
            if (DO_PRINTS):
                print("intelhex: eof\n")
            break

        # check for PC start line
        elif (line[7:8 +1] == "05"):
            if (DO_PRINTS):
                print(f"intelhex: PC should start at 0x{line[9:16 +1]}")
        
        # check for extended addr line
        elif (line[7:8 +1] == "04"):

            # prep for new chunk
            last_line = "addr"
            last_addr = line[9:12 +1] + "0000"

        # check for data line
        elif (line[7:8 +1] == "00"):

            # check for last line extended addr line, meaning have new chunk
            if (last_line == "addr"):

                # start new chunk at corresponding addr
                if (DO_PRINTS):
                    print(f"intelhex: new given chunk at 0x{last_addr[0:3 +1] + line[3:6 +1]}")
                new_chunk = Chunk(chunk_num, last_addr[0:3 +1] + line[3:6 +1]) 
                chunk_num += 1
                word_index_count = 0
                for word_index in range(int(line[1:2 +1], base=16) // 4):
                    word_index_count += 1
                    # get next word (8-char string) from data section
                    new_chunk.append(line[9 + 8*word_index:9 + 8*(word_index + 1)])
                chunk_list.append(new_chunk)
                last_line = "data"
                last_addr = last_addr[0:3 +1] + line[3:6 +1]
                last_incr = word_index_count * 4

            # check for data in same chunk (last addr + 16 == this addr)
            elif ((int(last_addr[4:7 +1], base=16) + last_incr) == int(line[3:6 +1], base=16)):  
                
                # continue chunk
                word_index_count = 0
                for word_index in range(int(line[1:2 +1], base=16) // 4):
                    word_index_count += 1
                    # get next word (8-char string) from data section
                    new_chunk.append(line[9 + 8*word_index:9 + 8*(word_index + 1)])
                last_line = "data"
                last_addr = last_addr[0:3 +1] + line[3:6 +1]
                last_incr = word_index_count * 4

            # check for data in diff chunk (last addr + 16 < this addr)
            elif ((int(last_addr[4:7 +1], base=16) + last_incr) < int(line[3:6 +1], base=16)):

                # start new chunk at corresponding addr
                if (DO_PRINTS):
                    print(f"intelhex: new parsed chunk at 0x{last_addr[0:3 +1] + line[3:6 +1]}")
                new_chunk = Chunk(chunk_num, last_addr[0:3 +1] + line[3:6 +1]) 
                chunk_num += 1
                word_index_count = 0
                for word_index in range(int(line[1:2 +1], base=16) // 4):
                    word_index_count += 1
                    # get next word (8-char string) from data section
                    new_chunk.append(line[9 + 8*word_index:9 + 8*(word_index + 1)])
                chunk_list.append(new_chunk)
                last_line = "data"
                last_addr = last_addr[0:3 +1] + line[3:6 +1]
                last_incr = word_index_count * 4

            # otherwise, have address before
            else:
                print(f"parsing line {line_num} gives address before")
                quit()

        # otherwise, can't parse this
        else:
            print(f"don't know how to parse line {line_num} of intel hex")
            quit()

    # done parsing lines, return chunk_list
    return chunk_list


# recursive function for selecting reg file chunks for given mem req addr
def recursive_bin_select(reg_file_hashing_lines, remaining_chunk_list, depth):
    """
    recursive function to create binary decision structure for selecting given reg file chunk to recieve 
    mem interface address

    parameters:
        remaining_chunk_list: list of chunks which are yet to be differentiated in recursive binary tree
        reg_file_hashing_lines: list of lines which will be appended for each binary differentiation
    outputs:
        none
    """

    # bad case
    if (len(remaining_chunk_list) < 1):
        print("remaining_chunk_list < 1")

    # base case 1: 1 remaining chunks
    elif (len(remaining_chunk_list) == 1):

        # guaranteed take in this branch
        reg_file_hashing_lines += [
            "\t\t" + depth*"\t" + f"chunk_sel = {remaining_chunk_list[0].id}",
        ]

    # base case 2: 2 remaining chunks
    elif (len(remaining_chunk_list) == 2):

        # find bit to differentiate at
        bin_len = len(word_match_start([chunk.start_addr for chunk in remaining_chunk_list]))

        # check for bad differentiation
        if (remaining_chunk_list[0].bin_start_addr[bin_len-1] == 
            remaining_chunk_list[1].bin_start_addr[bin_len-1]):
            print("bad differentiation, diff bits are equal")
            quit()

        # first chunk
        bin_addr = remaining_chunk_list[0].bin_start_addr
        reg_file_hashing_lines += [
            "\t\t" + depth*"\t" + f"if (mem_req_addr[{bin_len-1}] == 1'b{bin_addr[bin_len-1]})",
            "\t\t" + depth*"\t" + f"begin",
            "\t\t" + depth*"\t" + f"    chunk_sel = {remaining_chunk_list[0].id}",
            "\t\t" + depth*"\t" + f"end",
        ]

        # second chunk
        bin_addr = remaining_chunk_list[1].bin_start_addr
        reg_file_hashing_lines += [
            "\t\t" + depth*"\t" + f"else if (mem_req_addr[{bin_len-1}] == 1'b{bin_addr[bin_len-1]})",
            "\t\t" + depth*"\t" + f"begin",
            "\t\t" + depth*"\t" + f"    chunk_sel = {remaining_chunk_list[1].id}",
            "\t\t" + depth*"\t" + f"end",
        ]

    # otherwise, further split up
    else:
        bin_len = len(word_match_start([chunk.start_addr for chunk in remaining_chunk_list]))
        one_list = []
        zero_list = []
        
        # iterate through 3+ chunks, splitting into 0 at critical address and 1 at critical address 
        for chunk in remaining_chunk_list:

            # check for 1 list
            if (chunk.bin_start_addr[bin_len-1] == "1"):
                one_list.append(chunk)

            # check for 0 list
            elif (chunk.bin_start_addr[bin_len-1] == "0"):
                zero_list.append(chunk)

            # otherwise, invalid char
            else:
                print("non-binary char in bin_start_addr")

        # one branch:
        # pre print
        reg_file_hashing_lines += [
            "\t\t" + depth*"\t" + f"// bit = 1 branch",
            "\t\t" + depth*"\t" + f"if (mem_req_addr[{bin_len-1}] == 1'b1)",
            "\t\t" + depth*"\t" + f"begin",
        ]
        # recursive call for one
        recursive_bin_select(reg_file_hashing_lines, one_list, depth+1)
        # post print
        reg_file_hashing_lines += [
            "\t\t" + depth*"\t" + f"end",
        ]

        # zero branch:
        reg_file_hashing_lines += [
            "\t\t" + depth*"\t" + f"// bit = 0 branch",
            "\t\t" + depth*"\t" + f"else if (mem_req_addr[{bin_len-1}] == 1'b0)",
            "\t\t" + depth*"\t" + f"begin",
        ]
        # recursive call for zero
        recursive_bin_select(reg_file_hashing_lines, zero_list, depth+1)
        # post print
        reg_file_hashing_lines += [
            "\t\t" + depth*"\t" + f"end",
        ]

        # should be unreached branch
        reg_file_hashing_lines += [
            "\t\t" + depth*"\t" + f"else",
            "\t\t" + depth*"\t" + f"begin",
            "\t\t" + depth*"\t" + f'    $display("error: got to else in high-level branch")',
            "\t\t" + depth*"\t" + f"end",
        ]

# parse list of chunks to construct .sv source file
def construct_reg_file_sv(ram_fake_shell_lines, chunk_list):
    """
    function to parse out chunk_list to construct reg file instantiation of .sv and complete 
    ram_fake_reg_file.sv with ram_fake_shell.txt

    parameters:
        ram_fake_shell_lines: lines in ram_fake_shell.txt file wrapping around logic to be constructd
        chunk_list: list of chunk objects with info on chunks and words in chunk
    
    outputs:
        reg_file_sv_lines: lines which make up source file for ram_fake_reg_file.sv
    """

    ############################
    # make reg file instances: #
    ############################
    
    reg_file_instance_lines = []

    # make reg file for each chunk
    for chunk in chunk_list:

        # make required signals for chunk
        reg_file_instance_lines += [
            f"\t",
            f"\t// chunk {chunk.id}",
            f"\tlogic wen_{chunk.id}_{chunk.start_addr};",
            f"\tlogic [{chunk.SEL_W}-1:0] wsel_{chunk.id}_{chunk.start_addr};",
            f"\tlogic [{WORD_W}-1:0] wdata_{chunk.id}_{chunk.start_addr};",
            f"\tlogic [{chunk.SEL_W}-1:0] rsel_{chunk.id}_{chunk.start_addr};",
            f"\tlogic [{WORD_W}-1:0] rdata_{chunk.id}_{chunk.start_addr};",
            f"\t",
        ]

        # make reg chunk instance:

        # parameters
        reg_file_instance_lines += [
            f"\treg_file #(",
            f"\t\t.WORD_W ({WORD_W}),",
            f"\t\t.NUM_WORDS ({chunk.NUM_WORDS}),",
            f"\t\t.SEL_W ({chunk.SEL_W}),",
            "\t\t.RESET_WORDS ({",
        ]
        
        # RESET_WORDS parameter
        RESET_WORDS = "\t\t\t"
        # go through words in intelhex file
        for i in range(chunk.word_size):
            RESET_WORDS += f"32'h{chunk.word_list[i]}, "
        # fill in 0's for rest of words
        RESET_WORDS += (chunk.NUM_WORDS - chunk.word_size) * "32'h00000000, "
        RESET_WORDS = RESET_WORDS[:-2] + "\n\t\t})"
        reg_file_instance_lines.append(RESET_WORDS)

        # instance name and I/O
        reg_file_instance_lines += [
            f"\t) reg_file_{chunk.id}_{chunk.start_addr} (",
            f"\t\t.clk (clk), .reset (reset),",
            f"\t\t.wen (wen_{chunk.id}_{chunk.start_addr}),",
            f"\t\t.wsel (wsel_{chunk.id}_{chunk.start_addr}),",
            f"\t\t.wdata (wdata_{chunk.id}_{chunk.start_addr}),",
            f"\t\t.rsel (rsel_{chunk.id}_{chunk.start_addr}),",
            f"\t\t.rdata (rdata_{chunk.id}_{chunk.start_addr})",
            f"\t);",
        ]

    # need selection signal wide enough for all instances
    reg_file_instance_lines += [
        f"\t",
        f"\t// need reg file/chunk selection signal",
        f"\tlogic [{bits_needed(len(chunk_list))}-1:0] chunk_sel;",
    ]

    # add newlines to end of each line and replace \t tabs with 4 spaces
    reg_file_instance_lines = [line.replace("\t", "    ") + "\n" for line in reg_file_instance_lines]

    #################################
    # make binary hashing function: #
    #################################

    reg_file_hashing_lines = []

    # delete later
    # word_match_start([chunk.start_addr for chunk in chunk_list])

    # iterate until have unique encodings for each chunk
    recursive_bin_select(reg_file_hashing_lines, chunk_list.copy(), 0)

    # hardwired outputs
    reg_file_hashing_lines += [
        f"\t\t",
        f"\t\t// hardwired outputs:",
    ]
    for chunk in chunk_list:
        reg_file_hashing_lines += [
            f"\t\t// hardwiring for chunk {chunk.id}",
            f"\t\twsel_{chunk.id}_{chunk.start_addr} = mem_req_addr[{chunk.SEL_W}-1:0];",
            f"\t\twdata_{chunk.id}_{chunk.start_addr} = mem_req_data[{chunk.SEL_W}-1:0];",
            f"\t\trsel_{chunk.id}_{chunk.start_addr} = mem_req_addr[{chunk.SEL_W}-1:0];",
        ]

    # default outputs
    reg_file_hashing_lines += [
        f"\t\t",
        f"\t\t// default outputs:",
        f"\t\tmem_rsp_data = '0;",
        f"\t\ttb_addr_out_of_bounds = 1'b0;"
        f"\t\t// chunk wen's:",
    ]
    for chunk in chunk_list:
        reg_file_hashing_lines += [
            f"\t\twen_{chunk.id}_{chunk.start_addr} = 1'b0;",
        ]

    # case for routing to diff reg file chunks:
    reg_file_hashing_lines += [
        f"\t\t",
        f"\t\t// case for routing to diff reg file chunks",
        f"\t\tcasez (chunk_sel)",
        f"\t\t",
    ]
    # iterate through cases to determine behavior
    for chunk in chunk_list:
        reg_file_hashing_lines += [
            f"\t\t    // select chunk {chunk.id}",
            f"\t\t    {chunk.id}:",
            f"\t\t    begin",
            f"\t\t        // write routing",
            f"\t\t        wen_{chunk.id}_{chunk.start_addr} = mem_req_rw;",

            f"\t\t",
            f"\t\t        // read routing",
            f"\t\t        mem_rsp_data = rdata_{chunk.id}_{chunk.start_addr};",
            f"\t\t    end",
            f"\t\t",
        ]
    # end case
    reg_file_hashing_lines += [
        f"\t\t    // shouldn't get here",
        f"\t\t    default:",
        f"\t\t    begin",
        f"\t\t        mem_rsp_data = '0;",
        f"\t\t        tb_addr_out_of_bounds = 1'b1;",
        f"\t\t    end",
        f"\t\tendcase",
    ]

    # add newlines to end of each line and replace \t tabs with 4 spaces
    reg_file_hashing_lines = [line.replace("\t", "    ") + "\n" for line in reg_file_hashing_lines]

    ##########################
    # compile lines of file: #
    ##########################

    # get indices in shell file
    reg_file_instance_index = ram_fake_shell_lines.index("< instances here >\n")
    reg_file_hashing_index = ram_fake_shell_lines.index("< hashing here >\n")

    # add up shell pieces and instance and hashing pieces
    reg_file_sv_lines = ram_fake_shell_lines[:reg_file_instance_index]
    reg_file_sv_lines += reg_file_instance_lines
    reg_file_sv_lines += ram_fake_shell_lines[reg_file_instance_index +1:reg_file_hashing_index]
    reg_file_sv_lines += reg_file_hashing_lines
    reg_file_sv_lines += ram_fake_shell_lines[reg_file_hashing_index +1:]

    # return completed lines of file
    return reg_file_sv_lines


# overall function to take in hex file and output corresponding register file 
def intelhex_to_ram_fake_sv(hex_file_name, reg_file_sv_name):
    """
    function to take in intelhex file and make ram faking register file top module, utilizing
    ram_fake_shell.txt and reg_file.sv

    parameters:
        hex_file_name: name of intelhex .hex file to be used as memory space for ram fake 
        reg_file_sv_name: name of SystemVerilog .sv source file to be output defining top ram fake module

    outputs:
        none
    """

    # try to get ram fake source shell
    try:
        ram_fake_shell_fp = open("ram_fake_shell.txt", "r")
        ram_fake_shell_lines = ram_fake_shell_fp.readlines()
        ram_fake_shell_fp.close()

    except:
        print("need ram_fake_shell.txt")
        quit()

    # try to get .hex file and 
    try:
        # get .hex lines
        intelhex_fp = open(hex_file_name, "r")
        intelhex_lines = intelhex_fp.readlines()
        intelhex_lines = [line.strip() for line in intelhex_lines]
        intelhex_fp.close()

    except:
        print("couldn't find .hex file")
        quit()

    # translate intelhex_lines to list of chunks with address and data info
    chunk_list = parse_intelhex(intelhex_lines)
    for chunk in chunk_list:
        chunk.update_vars()

    if (DO_PRINTS):
        for chunk in chunk_list:
            print(chunk)

    # generating source .sv lines for reg file
    reg_file_sv_lines = construct_reg_file_sv(ram_fake_shell_lines, chunk_list)

    # try to write source .sv file
    try:
        # get .hex lines
        reg_file_sv_fp = open(reg_file_sv_name, "w")
        reg_file_sv_fp.writelines(reg_file_sv_lines)
        reg_file_sv_fp.close()

    except:
        print("couldn't write .sv file")
        quit()

    
# main
if __name__ == "__main__":

    # check for 1 commandline argument with python load_reg_file.py
    if (len(sys.argv) < 2):
        print("required format:")
        print("python load_reg_file.py <.hex file name>  <flags>")
        quit()

    if (not sys.argv[1].endswith(".hex")):
        print("input must be intel hex file")
        quit()
    
    if (len(sys.argv) > 2 and (sys.argv[2] in ["-p", "-DO_PRINTS"])):
        DO_PRINTS = True

    # run .sv source builder
    intelhex_to_ram_fake_sv(sys.argv[1], "ram_fake_reg_file.sv")
