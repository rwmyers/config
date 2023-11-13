import argparse
import re

start_regex = re.compile("Periodic Syncs:")
end_regex = re.compile("^\s*$")
# Job parsing regular expressions
regex_job = re.compile(r"JobId=.* \[(.*)\] PERIODIC Reason=Periodic \(period=(.*) flex=(.*)\) Owner={\w* ([\w\.]*)\s")

class Job:
    def __init__(self, data):
        self.name = data[0]
        self.period = data[1]
        self.flex = data[2]
        self.owner = data[3]

def main():
    parser = argparse.ArgumentParser(
        prog='Sync Adapter Parser',
        description='Reformats sync adapters into a structured view')
    parser.add_argument('filename')
    args = parser.parse_args()

    jobs_text = parse_file(args.filename)
    jobs = parse_jobs(jobs_text)
    for job in jobs:
        csv_job(job)


def parse_file(filename):
    jobs_text = []
    with open(filename) as f:

        # Remove prefix text
        for line in f:
            if start_regex.search(line):
                break

        for line in f:
            if end_regex.search(line):
                break
            jobs_text.append(line)
    return jobs_text

def parse_jobs(text):
    jobs = []
    for line in text:
        result = regex_job.search(line)
        if result:
            jobs.append(Job(result.groups()))

    return jobs

def csv_job(job):
    print(
        "{0},{1},{2},{3}"
        .format(
            job.name,
            job.period,
            job.flex,
            job.owner
        ))


if __name__ == "__main__":
    main()