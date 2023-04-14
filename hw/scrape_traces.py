"""
    socet115 / zlagpaca@purdue.edu
    Zach Lagpacan

    script to scrape through rtlsim trace log of Vortex and questa trace log of Vortex for given hex file 
    and compare memory requests

    usage:
        commandline:
            python3 scrape_traces.py <rtlsim trace file> <questa trace file> <flags>

        flags:
            -p = print debugging info
            -out <output file name> = override output file name (and directory)

    general script flow:
        - parse rtlsim trace file for memory requests
        - parse questa trace file for memory requests
        - compare the memory requests
        - write findings to output file
"""

###########################################################################################################
# imports
import sys

###########################################################################################################
# consts:

DO_PRINTS = False

###########################################################################################################
# classes:

# ~struct for mem transactions
class MEM_Trans():
    
    # init
    def __init__(self, string):
        self.string = string
        self.get_attributes()

    # get attributes based on string
    def get_attributes(self):
        pass

# ~struct for mem read requests
class MEM_Rd_Req():

    # init
    def __init__(self, string, addr, tag):
        self.type = "Rd_Req"
        self.string = string[:string.index(", byteen=")] + "\n"     # don't care about byteen
        self.get_attributes()
    
    # get attributes based on string
    def get_attributes(self):
        self.addr = self.string[self.string.index("addr="):self.string.index(", tag=")]
        self.tag = self.string[self.string.index("tag="):self.string.index("\n")]

# ~struct for mem write requests
class MEM_Wr_Req():

    # init
    def __init__(self, string, addr, tag, byteen, data):
        self.type = "Wr_Req"
        self.string = string
        self.get_attributes()

    # get attributes based on string
    def get_attributes(self):
        self.addr = self.string[self.string.index("addr="):self.string.index(", tag=")]
        self.tag = self.string[self.string.index("tag="):self.string.index(", byteen=")]
        self.byteen = self.string[self.string.index("byteen="):self.string.index(" data=")]     # just space between byteen and data for some reason
        self.data = self.string[self.string.index("data="):self.string.index("\n")]

# ~struct for mem responses
class MEM_Rsp():

    # init
    def __init__(self, string, tag, data):
        self.type = "Rsp"
        self.string = string
        self.get_attributes()

    # get attributes based on string
    def get_attributes(self):
        self.tag = self.string[self.string.index("tag="):self.string.index(", data=")]
        self.data = self.string[self.string.index("data="):self.string.index("\n")]

# class for storing scraped
class Scrape():

    # instance vars:
    # mem_trans_list -> list of mem_req objects

    # methods:

    # init
    def __init__(self, file_name):
        self.file_name = file_name

        self.MEM_Trans_list = []

        self.MEM_Rd_Req_list = []

        self.MEM_Wr_Req_list = []

        self.MEM_Rsp_list = []
        
    # interpret trace line
    def interpret_line(self, line):

        # check if mem transaction
        if ("MEM" in line):

            # if (DO_PRINTS):
            #     print("MEM in line")

            # mem read req
            if ("Rd" in line):

                # if (DO_PRINTS):
                #     print("Rd in line")

                # collect mem read req
                try:
                    # get string
                    string = line[line.index("MEM"):]

                    # instantiate MEM_Rd_Req
                    new_mem_trans = MEM_Rd_Req(string=string, addr="", tag="")
                    self.MEM_Trans_list.append(new_mem_trans)
                    self.MEM_Rd_Req_list.append(new_mem_trans)
                    
                except:
                    # bad mem transaction
                    return False

            # MEM Wr Req
            elif ("Wr" in line):

                # if (DO_PRINTS):
                #     print("Wr in line")
                
                # collect mem write req
                try:
                    # get string
                    string = line[line.index("MEM"):]

                    # instantiate MEM_Rd_Req
                    new_mem_trans = MEM_Wr_Req(string=string, addr="", tag="", byteen="", data="")
                    self.MEM_Trans_list.append(new_mem_trans)
                    self.MEM_Wr_Req_list.append(new_mem_trans)

                except:
                    # bad mem transaction
                    return False

            # MEM Rsp
            elif ("Rsp" in line):

                # if (DO_PRINTS):
                #     print("Rsp in line")
                
                # collect mem read req
                try:
                    # get string
                    string = line[line.index("MEM"):]

                    # instantiate MEM_Rsp
                    new_mem_trans = MEM_Rsp(string=string, tag="", data="")
                    self.MEM_Trans_list.append(new_mem_trans)
                    self.MEM_Rsp_list.append(new_mem_trans)

                except:
                    # bad mem transaction
                    return False

        # either got good mem transaction or no mem transaction, so success
        return True

    # print/file write output --> whenever str() called on object
    def __repr__(self):
        # output_string = f"scrape for {self.file_name}\n"
        output_string = ""

        # give all memory transactions
        output_string += "all memory transactions:\n"

        counter = 0
        for mem_trans in self.MEM_Trans_list:
            counter += 1
            output_string += str(counter) + ": " + mem_trans.string

        output_string += "\n"

        # give memory read transactions
        output_string += "memory read request transactions:\n"

        counter = 0
        for mem_trans in self.MEM_Rd_Req_list:
            counter += 1
            output_string += str(counter) + ": " + mem_trans.string

        output_string += "\n"

        # give memory write transactions
        output_string += "memory write request transactions:\n"

        counter = 0
        for mem_trans in self.MEM_Wr_Req_list:
            counter += 1
            output_string += str(counter) + ": " + mem_trans.string

        output_string += "\n"

        # give memory response transactions
        output_string += "memory response transactions:\n"

        counter = 0
        for mem_trans in self.MEM_Rsp_list:
            counter += 1
            output_string += str(counter) + ": " + mem_trans.string

        output_string += "\n"

        return output_string

###########################################################################################################
# funcs:

# generate scrape corresponding to trace file
def scrape_trace(file_name, trace_file_lines):
    
    # find lines that correspond to a memory transaction
    mem_trans_scrape = Scrape(file_name)
    for line_index in range(len(trace_file_lines)):

        # interpret this line
        success = mem_trans_scrape.interpret_line(trace_file_lines[line_index])
        if (not success):
            print(f"ERROR: failed to scrape line {line_index + 1}")
            return False

    # return scrape object
    return mem_trans_scrape

# compare rtlsim and questa scrape objects
def compare_scrapes(rtlsim_scrape, questa_scrape):

    

    # run comparison algo

    return

# overall function to scrape rtlsim, scrape questa, compare scrapes, and write output files
def compare_trace_files(rtlsim_trace_file_name, questa_trace_file_name, output_file_name):

    # try to read rtlsim file lines
    try:
        with open(rtlsim_trace_file_name, "r") as rtlsim_trace_file_fp:
            rtlsim_trace_file_lines = rtlsim_trace_file_fp.readlines()
    except:
        print("ERROR: couldn't find rtlsim trace file")
        quit()

    # scrape rtlsim trace file
    rtlsim_scrape = scrape_trace(rtlsim_trace_file_name, rtlsim_trace_file_lines)

    # check for bad scrape
    if (not rtlsim_scrape):
        print("ERROR: failed rtlsim scrape")
        quit()

    if (DO_PRINTS):
        print("rtlsim scrape:")
        print(str(rtlsim_scrape))
        print()

    # try to read questa file lines
    try:
        with open(questa_trace_file_name, "r") as questa_trace_file_fp:
            questa_trace_file_lines = questa_trace_file_fp.readlines()
    except:
        print("ERROR: couldn't find questa trace file")
        quit()

    # scrape questa trace file
    questa_scrape = scrape_trace(questa_trace_file_name, questa_trace_file_lines)

    # check for bad scrape
    if (not questa_scrape):
        print("ERROR: failed questa scrape")
        quit()

    if (DO_PRINTS):
        print("questa scrape:")
        print(str(questa_scrape))
        print()

    # output respective scrape files (simplified trace) for commandline diff:

    # scrape file names based on input file names (can't do prefix if there is directory at beginning)
    rtlsim_scrape_file_name = rtlsim_trace_file_name + ".scrape.log"
    questa_scrape_file_name = questa_trace_file_name + ".scrape.log"
    
    # try to write rtlsim scrape file
    try:
        with open(rtlsim_scrape_file_name, "w") as rtlsim_scrape_file_fp:
            rtlsim_scrape_file_fp.write(str(rtlsim_scrape))

    except: 
        print("ERROR: couldn't write rtlsim scrape file")
        quit()

    # try to write questa scrape file
    try:
        with open(questa_scrape_file_name, "w") as questa_scrape_file_fp:
            questa_scrape_file_fp.write(str(questa_scrape))

    except:
        print("ERROR: couldn't write questa scrape file")
        quit()

    # compare rtlsim and questa scrapes and generate output file
    # output_file_lines = compare_scrapes(rtlsim_scrape, questa_scrape)

    # # try to write output file
    # try:
    #     with open(output_file_name, "w") as output_file_fp:
    #         output_file_fp.writelines(output_file_lines)
    # except:
    #     print("couldn't write output file")
    #     quit()

    # done program
    return

###########################################################################################################
# main:

if __name__ == "__main__":

    # check for don't have required commandline arguments
    if (len(sys.argv) < 3):
        print("ERROR: need to follow commandline format:")
        print("python3 scrape_traces.py <rtlsim trace file> <questa trace file> <flags>")
        quit()

    if ("-p" in sys.argv):
        DO_PRINTS = True

    if ("-out" in sys.argv):
        output_file_name_index = sys.argv.index("-out") + 1
        output_file_name = sys.argv[output_file_name_index]
    else:
        output_file_name = "trace_diff.log"

    if (DO_PRINTS):
        print(f"DO_PRINTS = {DO_PRINTS}")
        print(f"output file = {output_file_name}")
        print()

    # run program
    compare_trace_files(sys.argv[1], sys.argv[2], output_file_name)