#!/usr/bin/env python3
# Input: 
    # list of tuples [("phuongvo9@gmail.com", "Phuong Vo"), ("Tuxuong@yahoo.com","Tu Xuong")]
# Output:
    # Phuong Vo <phuongvo9@gmail.com>
    # Tu Xuong <Tuxuong@yahoo.com>

def parse_full_emails(people):
    result = []
    for person in people:
        full_email = "{} <{}>".format(person[1],person[0])
        result.append(full_email)
    return result

def main():
    people = [("phuongvo9@gmail.com", "Phuong Vo"), ("Tuxuong@yahoo.com","Tu Xuong")]
    result=parse_full_emails(people)
    print("\n".join(result))

main()
    