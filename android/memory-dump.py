#!/usr/bin/python
import os
import argparse

parsing_commands = {
	"graphics" : "grep Graphics %s | awk '{ print $2 }'",
	"code" : "grep Code %s | awk '{ print $2 }'",
	"privatedirty" : "grep TOTAL %s -m 1 | awk '{print $3}'",
	"javaheap" : "grep 'Java Heap:' %s | awk '{print $3}'",
	"nativeheap" : "grep 'Native Heap:' %s | awk '{print $3}'",
	"dex" : "grep '.dex mmap' %s | awk '{print $5}'",
	"art" : "grep '.art mmap' %s | awk '{print $5}'",
	"ttf" : "grep '.ttf mmap' %s | awk '{print $5}'",
	"so" : "grep '.so mmap' %s | awk '{print $5}'",
}
 
parser = argparse.ArgumentParser(description='Reads a newline delimited list of processes and produces allocations in an output file.')
parser.add_argument('-i','--input', help='Input file name',required=True)
parser.add_argument('-o','--output',help='Output file name', required=True)
parser.add_argument('-a','--all_values', help='Provide all values', action='store_true', required=False)
parser.add_argument('-d','--debug', help='Debug flag', action='store_true', required=False)
parser.add_argument('-v','--values',choices=parsing_commands.keys(), nargs='+', required=False)
args = parser.parse_args()

DEBUG = args.debug

if DEBUG:
	print "all? %s" % args.all_values
	print "values = %s" % args.values

if args.all_values:
	args.values = parsing_commands.keys()
elif not args.values:
	argparse.print_help()
	exit(1)

with open(args.input) as processes_file:
	processes = processes_file.readlines()

processes = [p.strip() for p in processes]

results = []
sums = {}
for val in args.values:
	sums[val] = 0

def store_value_and_sum(result, key, dumpfile):
	result[key] = ""
	cmd = parsing_commands[key] % dumpfile
	if DEBUG:
		print cmd
	result[key] = os.popen(cmd).read().strip()
	store_sum(key, result[key], result["process"])


def store_sum(key, val, process):
	if DEBUG:
		print "key=%s, val=%s" % (key, val) 
	sums[key] += int(val) if val.isdigit() else 0


for process in processes:
	dumpfile = process + '-dump'
	print "Processing %s" % process
	cmd = "adb shell dumpsys meminfo %s > %s" % (process, dumpfile)
	if DEBUG:
		print cmd
	os.popen(cmd)

	result = { "process" : process }
	for val in args.values:
		store_value_and_sum(result, val, dumpfile)

	os.remove(dumpfile)

	results.append(result)

with open(args.output, 'w') as results_file:
	results_file.write("process")
	for val in args.values:
		results_file.write(",%s" % val)
	results_file.write("\n")
	for result in results:
		results_file.write("%s" % result["process"])
		for val in args.values:
			results_file.write(',%s' % result[val])
		results_file.write("\n")

	results_file.write("TOTAL")
	for val in args.values:
		results_file.write(",%s" % sums[val])
	results_file.write("\n")

