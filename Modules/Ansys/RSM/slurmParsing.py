"""
Copyright (C) 2014 ANSYS, Inc. and its subsidiaries.  All Rights Reserved.

$LastChangedDate$
$LastChangedRevision$
$LastChangedBy$
"""

import sys
import os
import generalUtilities
from applicationConfiguration import IsRunningIronPython

from generalUtilities import SUBMIT_OUTPUT_VARIABLE_NAME
from generalUtilities import STATUS_OUTPUT_VARIABLE_NAME
from generalUtilities import QUEUES_OUTPUT_VARIABLE_NAME
from generalUtilities import GENERIC_OUTPUT_VARIABLE_NAME
from generalUtilities import JOBID_INPUT_VARIABLE_NAME
from generalUtilities import QUEUES_INPUT_VARIABLE_NAME

def main(args, environment, enablePrints = False):
    if len(args) == 0:
        raise generalUtilities.NonZeroExitCodeException(1, "Expected a script argument as the type of method to parse: I.E. '-submit' or '-status'")
    
    if len(args) > 2:
        raise generalUtilities.NonZeroExitCodeException(1, "Too many arguments passed to script.  Expected 1 or 2, but was " + len(args))
    
    commandToParse = args[0].upper()
    
    if(len(args) == 2):
        parseMarker = args[1]
    else:
        parseMarker = ""
    
    if(commandToParse == "-SUBMIT"):
        _parseSubmitCommand(environment, parseMarker, generalUtilities.defineRsmVariable, enablePrints)
    elif(commandToParse == "-STATUS"):
        _parseStatusCommand(environment, parseMarker, generalUtilities.defineRsmVariable, enablePrints)
    elif(commandToParse == "-QUEUES"):
        _parseQueuesCommand(environment, parseMarker, generalUtilities.defineRsmVariable, enablePrints)
    elif commandToParse == "-GENERIC":
        generalUtilities.ParseGenericCommand(environment, parseMarker, generalUtilities.defineRsmVariable, enablePrints)
    elif commandToParse == "-ALLSTATUS":
        _parseAllStatusCommand(environment, parseMarker, generalUtilities.defineRsmVariable, enablePrints)
    elif commandToParse == "-ALLQUEUES":
        _parseAllQueuesCommand(environment, parseMarker, generalUtilities.defineRsmVariable, enablePrints)
    elif commandToParse == "-LOAD":
        _parseLoadCommand(environment, parseMarker, generalUtilities.defineRsmVariable, enablePrints)
    else:
        raise generalUtilities.NonZeroExitCodeException(1, "'" + args[0] + "' could not be parsed as a valid method to parse.")
    
    return 0

def _parseSubmitCommand(environment, parseMarkerString, defineRsmVariableFunc, enablePrints):
    # Get the Standard Output
    stdOut = generalUtilities.GetStdOutVariable(environment, disallowBlankStdOut=True)

    # Check to see if the output has the parse marker, if it does, then split the string and set the stdout equal to the half after the Marker String
    stdOut = generalUtilities.ReduceStdOutBasedOnParseMarker(stdOut, parseMarkerString)
    
    # StdoutList is comprised of the lines of stdout from after the parse Marker
    stdOutList = generalUtilities.CreateListByNewlineAndRemoveBlankLines(stdOut)
    
    for line in stdOutList:
        # sbatch: indicates that sbatch has some error...
        if not (line.lstrip().startswith('Submitted')):
            FailedToParseStdOut("Submit", stdOut, 5, enablePrints)
        
        # The fourth item is *exactly* the jobid
        result = line.lstrip().split()[3]
        defineRsmVariableFunc(SUBMIT_OUTPUT_VARIABLE_NAME, result)
        return
    
    generalUtilities.FailedToParseStdOut("Submit", stdOut, 5, enablePrints)
    return

def _parseStatusCommand(environment, parseMarkerString, defineRsmVariableFunc, enablePrints):
    # Get the Standard Output and Error
    stdOut = generalUtilities.GetStdOutVariable(environment, disallowBlankStdOut=False)
    stdErr = generalUtilities.GetStdErrVariable(environment)
    # Check to see if the output has the parse marker, if it does, then split the string and set the stdout equal to the half after the Marker String
    stdOut = generalUtilities.ReduceStdOutBasedOnParseMarker(stdOut, parseMarkerString)
    # StdoutList is comprised of the lines of stdout from after the parse Marker
    stdOutList = generalUtilities.CreateListByNewlineAndRemoveBlankLines(stdOut)
    stdErrList = generalUtilities.CreateListByNewlineAndRemoveBlankLines(stdErr)

    # If the output is empty, then this means the job is finished
    if(len(stdOutList) == 0):
        defineRsmVariableFunc(STATUS_OUTPUT_VARIABLE_NAME, 'FINISHED')
        return
    
    # If we get an error that we can not find the job ID anymore then we are finished.
    if(any("Invalid job id" in line for line in stdErrList)):
        defineRsmVariableFunc(STATUS_OUTPUT_VARIABLE_NAME, 'FINISHED')
        return
    
    # If the output isnt blank but is less than 2 lines, then there is some problem.  Should be a 1 line header and an active job line at least..
    if(len(stdOutList) < 2):
        defineRsmVariableFunc(STATUS_OUTPUT_VARIABLE_NAME, 'FINISHED')
        return
    
    # The status is wrapped by one header lines, so they are removed here.
    statusLine = stdOutList[1]
    statusList = statusLine.split()
    if(len(statusList) > 4):
        status = statusList[4]
    else:
        defineRsmVariableFunc(STATUS_OUTPUT_VARIABLE_NAME, 'UNKNOWN')
        generalUtilities.FailedToParseStdOut("Status", stdOut, 5, enablePrints)
        return
    
    # SLURM has no "Failed" option that we parse?
    if(status == 'R'):
        defineRsmVariableFunc(STATUS_OUTPUT_VARIABLE_NAME, 'Running')
        return
    elif(status == 'F'):
        defineRsmVariableFunc(STATUS_OUTPUT_VARIABLE_NAME, 'Failed')
        return
    elif(status == 'PD'):
        defineRsmVariableFunc(STATUS_OUTPUT_VARIABLE_NAME, 'Queued')
        return
    elif(status == 'CA'):
        defineRsmVariableFunc(STATUS_OUTPUT_VARIABLE_NAME, 'Cancelled')
        return
    elif(status == 'CD'):
        defineRsmVariableFunc(STATUS_OUTPUT_VARIABLE_NAME, 'Finished')
        return
    else:
        defineRsmVariableFunc(STATUS_OUTPUT_VARIABLE_NAME, 'UNKNOWN')
        FailedToParseStdOut("Status", stdOut, 5, enablePrints)
        return

def ValidateOutputFromQueuesCommand(environment, parseMarkerString, defineRsmVariableFunc, enablePrints):
    stdErr = generalUtilities.GetStdErrVariable(environment)
    if(not generalUtilities.IsNoneOrWhitespace(stdErr)):
        # if StdErr has some valid content then the command has failed.  We will just ignore the command and go on sucessfully
        defineRsmVariableFunc(QUEUES_OUTPUT_VARIABLE_NAME, 'TRUE')
        return None
    
    # Get the Standard Output and Error if it is blank or doesnt exist
    stdOut = generalUtilities.GetStdOutVariable(environment, disallowBlankStdOut=True)

    # Check to see if the output has the parse marker, if it does, then split the string and set the stdout equal to the half after the Marker String
    stdOut = generalUtilities.ReduceStdOutBasedOnParseMarker(stdOut, parseMarkerString)

    # StdoutList is comprised of the lines of stdout from after the parse Marker
    stdOutList = generalUtilities.CreateListByNewlineAndRemoveBlankLines(stdOut)
    
    # If the output is less than 2 lines, then there is some problem.
    if(len(stdOutList) < 3):
        generalUtilities.FailedToParseStdOut("Queues", stdOut, 0, enablePrints)
        defineRsmVariableFunc(QUEUES_OUTPUT_VARIABLE_NAME, 'TRUE')
        return None
    
    return stdOutList

def _parseAllQueuesCommand(environment, parseMarkerString, defineRsmVariableFunc, enablePrints):
    stdOutList = ValidateOutputFromQueuesCommand(environment, parseMarkerString, defineRsmVariableFunc, enablePrints)
    if stdOutList == None:
        return
    
    queueList = []
    # Dont look at the first line, its a header...
    for line in stdOutList[1:]:
        # We need to strip any leading spaces and then split by spaces and get the first item, it will be the queue name *only*
        queueList.append(line.lstrip().split()[0])
    
    defineRsmVariableFunc(GENERIC_OUTPUT_VARIABLE_NAME, str(queueList))
    return

def _parseQueuesCommand(environment, parseMarkerString, defineRsmVariableFunc, enablePrints):
    stdOutList = ValidateOutputFromQueuesCommand(environment, parseMarkerString, defineRsmVariableFunc, enablePrints)
    if stdOutList == None:
        return
    
    # Get the name of the queue that we are using
    queueName = environment.get(QUEUES_INPUT_VARIABLE_NAME)
    if(queueName == None):
        raise generalUtilities.NonZeroExitCodeException(2, "NonExistant QUEUE Input Variable: '" + QUEUES_INPUT_VARIABLE_NAME + "'")

    # Dont look at the first line, its a header...
    for line in stdOutList[1:]:
        # We need to strip any leading spaces and then split by spaces and get the first item, it will be the queue name *only*
        if(queueName in line.lstrip().split()[0]):
            defineRsmVariableFunc(QUEUES_OUTPUT_VARIABLE_NAME, 'TRUE')
            return

    defineRsmVariableFunc(QUEUES_OUTPUT_VARIABLE_NAME, 'FALSE')
    return

def _parseAllStatusCommand(environment, parseMarkerString, defineRsmVariableFunc, enablePrints):
    # Get the Standard Output and Error
    stdOut = generalUtilities.GetStdOutVariable(environment, disallowBlankStdOut=False)
    # Check to see if the output has the parse marker, if it does, then split the string and set the stdout equal to the half after the Marker String
    stdOut = generalUtilities.ReduceStdOutBasedOnParseMarker(stdOut, parseMarkerString)
    # StdoutList is comprised of the lines of stdout from after the parse Marker
    stdOutList = generalUtilities.CreateListByNewlineAndRemoveBlankLines(stdOut)
    
    if len(stdOutList) == 0:
        statusDict = {}
        statusDict['-1'] = ['UNKNOWN']
        defineRsmVariableFunc(GENERIC_OUTPUT_VARIABLE_NAME, str(statusDict))
        return
    
    # Must be some weird output that is unparsible...
    if len(stdOutList) < 3:
        generalUtilities.FailedToParseStdOut("getAllStatus", stdOut, 5, enablePrints)
    
    statusDict = {}
    status = ""
    cores = "-1"
    queue = ""
    username = ""
    jobname = ""
    for line in stdOutList[2:]:
        statusList = line.split()
        if(len(statusList) > 4):
            statusChar = statusList[4]
            # SLURM has no "Failed" option that we parse?
            if(statusChar == 'R'):
                status = 'RUNNING'
            elif(statusChar == 'F'):
                status = 'FAILED'
            elif(statusChar == 'PD'):
                status = 'PENDING'
            else:
                continue
            # Only add data to the dictionary if the line can be sucessfully parsed.
            # Skip cores for now
            queue = statusList[1].strip()
            username = statusList[3].strip()
            jobname = statusList[2].strip()
            statusDict[statusList[0].strip()] = [status, cores, queue, username, jobname]
    
    defineRsmVariableFunc(GENERIC_OUTPUT_VARIABLE_NAME, str(statusDict))
    return

def _parseLoadCommand(environment, parseMarkerString, defineRsmVariableFunc, enablePrints):
    # Get the Standard Output
    stdOut = generalUtilities.GetStdOutVariable(environment, True)
    
    # Check to see if the output has the parse marker, if it does, then split the string and set the stdout equal to the half after the Marker String
    stdOut = generalUtilities.ReduceStdOutBasedOnParseMarker(stdOut, parseMarkerString)
    
    # StdoutList is comprised of the lines of stdout from after the parse Marker
    stdOutList = generalUtilities.CreateListByNewlineAndRemoveBlankLines(stdOut)
    
    if len(stdOutList) < 2:
        generalUtilities.FailedToParseStdOut("getLoad", stdOut, 5, enablePrints)
    
    loadDict = {}
    machineName = None
    hostParameter = False
    for line in stdOutList:
        # Skip the note at the bottom of the list
        if line.startswith("  "):
            hostParameter = True
        else:
            hostParameter = False
            machineName = line
            state = None
            freeCores = None
            totalCores = None
            continue
        
        if hostParameter:
            # If we see a node in a broken state, then we dont need to bother with the other parameters.  We will return 0,0
            if state != None and ("offline" in state or "down" in state or "unknown" in state):
                loadDict[machineName] = [ 0, 0 ]
                
            # If all the important parameters are found, then update the dictionary.
            if state != None and freeCores != None and totalCores != None:
                if not machineName in loadDict:
                    busyPercent = int((totalCores - freeCores) * 100 / totalCores) 
                    loadDict[machineName] = [ busyPercent, totalCores ]
                else:
                    # if the loadDictionary already has this item, just skip lines until we get to the next host.
                    continue
            
            splitLine = line.strip().split()
            if len(splitLine) < 3:
                print "Invalid machineName parameter found on machineName " + machineName + "\n" + line
                continue
            if splitLine[0].startswith("state"):
                state = splitLine[2]
            elif splitLine[0].startswith("resources_available.ncpus"):
                freeCores = int(splitLine[2])
            elif splitLine[0].startswith("pcpus"):
                totalCores = int(splitLine[2])

    defineRsmVariableFunc(GENERIC_OUTPUT_VARIABLE_NAME, str(loadDict))
    return

try:
    if IsRunningIronPython:
        exitCode = main(ipyArgv, ipyEnviron)
        sys.exit(exitCode)
    else:
        if __name__ == '__main__':
            exitCode = main(sys.argv[1:], os.environ)
            sys.exit(exitCode)
except generalUtilities.NonZeroExitCodeException as e:
    generalUtilities.customPrint("RSM_HPC_ERROR=" + e.message, True)
    sys.exit(e.exitCode)

