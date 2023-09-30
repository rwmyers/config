#!/usr/bin/python3
import subprocess
import os

class Stats:
    def __init__(self, pid, name, uptime):
        self.pid = pid
        self.name = name
        split = uptime.split()
        self.utime = int(split[13]) / tick_per_sec #user mode ticks / ticks per sec
        self.stime = int(split[14]) / tick_per_sec #kernel mode ticks / ticks per sec
        self.sumtime = self.utime + self.stime

pids = [pid for pid in os.listdir('/proc') if pid.isdigit()]
tick_per_sec=100
proc_stats = []
for pid in pids:
    with open('/proc/{pid}/cmdline'.format(pid = pid)) as cmdline:
        name = cmdline.read()
    with open('/proc/{pid}/stat'.format(pid = pid)) as stats:
        uptime = stats.read()
    

    proc_stats.append(Stats(pid, name, uptime))

proc_stats.sort(key=lambda x: x.sumtime)

for stat in proc_stats:
    print("{pid} {name} {total} {utime} {stime}".format(
        pid = stat.pid,
        name = stat.name,
        total = stat.sumtime,
        utime = stat.utime,
        stime = stat.stime
    ))