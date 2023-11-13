import argparse
import re

start_regex = None
end_regex = re.compile(":")
job_start_regex = re.compile("JOB")
sanitize="<change to protect email>"

regex_receiver = re.compile(r"[a-f0-9]+ (.*)$")

def main():
    parser = argparse.ArgumentParser(
        prog='Broadcast Receiver Parser',
        description='Reformats receivers into a structured view')
    parser.add_argument('filename')
    parser.add_argument('action')

    args = parser.parse_args()
    action = args.action
    start_regex = re.compile("{action}:".format(action = action))
    receivers_text = parse_file(args.filename, start_regex)
    receivers = parse_receivers(receivers_text)
    for receiver in receivers:
        csv_receiver(receiver)


def parse_file(filename, start_regex):
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

def parse_receivers(text):
    receivers = []
    for line in text:
        result = regex_receiver.search(line)
        if result:
            receivers.append(result.group(1))

    return receivers

def csv_receiver(receiver):
    print(
        "{0}"
        .format(
            receiver
        ))


if __name__ == "__main__":
    main()