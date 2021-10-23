#!python
import csv
import subprocess

stops = ["0:00:00"]
with open("sounds_timestamps.txt") as csv_file:
    reader = csv.reader(csv_file, delimiter=",")
    for row in reader:
        stops.append(row[2])

print("Read stops: ", stops)

ranges = []
for i in range(len(stops) - 1):
    ranges.append((stops[i], stops[i + 1]))

print("Split into ranges: ", ranges)

for i, (start, end) in enumerate(ranges):
    print(f"Processing part {i}: {start} - {end}")
    subprocess.run(["ffmpeg", "-ss", start, "-to", end, "-i", "sounds.wav", f"sound_{i:03d}.wav"])
