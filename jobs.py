import argparse
import re

start_regex = re.compile("Registered .* jobs:")
end_regex = re.compile("^\s*$")
job_start_regex = re.compile("JOB")
sanitize="<change to protect email>"

# Job parsing regular expressions
regex_service = re.compile(r"Service: (.*)$")
regex_periodic = re.compile(r"PERIODIC: interval=(.*) flex=(.*)$")
regex_priority = re.compile(r"Priority: (.*)$")
regex_requires = re.compile(r"charging=(true|false) batteryNotLow=(true|false) deviceIdle=(true|false)")
regex_tag = re.compile(r"tag=(.*)$")
regex_backoff = re.compile(r"Backoff: policy=(.*) initial=(.*)$")
regex_delay = re.compile(r"Max execution delay: (.*)$")
regex_network = re.compile(r"Network type: NetworkRequest \[ (.*) id=")

class Job:
    def __init__(self, data):
        self.service = Job.parse_line(data, regex_service)
        self.tag = Job.parse_line(data, regex_tag)
        if self.tag:
            self.tag = self.tag.replace(sanitize, "<USER_EMAIL>")
        periodic = Job.parse_groups(data, regex_periodic)
        if periodic:
            self.periodic, self.flex = periodic
        else:
            self.periodic = None
            self.flex = None
        self.priority = Job.parse_line(data, regex_priority)
        self.requires_charging, self.requires_battery, self.requires_idle = Job.parse_groups(data, regex_requires)
        self.backoff_policy, self.backoff_initial = Job.parse_groups(data, regex_backoff)
        self.execution_delay = Job.parse_line(data, regex_delay)
        self.network = Job.parse_line(data, regex_network)

    def parse_line(data, expression):
        for line in data:
            result = expression.search(line)
            if result:
                return result.group(1)

    def parse_groups(data, expression):
        for line in data:
            result = expression.search(line)
            if result:
                return result.groups()

def main():
    parser = argparse.ArgumentParser(
        prog='Job Parser',
        description='Reformats jobs into a structured view')
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
    data = []
    for line in text:
        if job_start_regex.search(line):
            if data:
                jobs.append(Job(data))
            data = []
            continue

        data.append(line)

    return jobs

def csv_job(job):
    print(
        "{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11}"
        .format(
            job.service,
            job.tag,
            job.periodic,
            job.flex,
            job.priority,
            job.requires_charging,
            job.requires_battery,
            job.requires_idle,
            job.backoff_policy,
            job.backoff_initial,
            job.execution_delay,
            job.network
        ))


if __name__ == "__main__":
    main()