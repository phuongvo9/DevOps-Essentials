#!/usr/bin/env python3

def convert_time(seconds):
    hour = seconds // 3600
    minute = (seconds - hour * 3600) // 60
    remain_second = seconds - hour * 3600 - minute * 60
    return hour, minute, remain_second


def main():
    hours, minutes, seconds = convert_time(5000)
    print(hours, minutes, seconds)

main()