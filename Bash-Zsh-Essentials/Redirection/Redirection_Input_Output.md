# REDIRECTION
## OUTPUT REDIRECTION OPERATORS
 `>` : Create a file
```
 ls -lrt /etc/securetty > demo.txt
```
`>>`: To append the file
```
 ls -lrt >> demo.txt
```
## INPUT REDIRECTION OPERATORS
`<`: To provide the input
```
 cat < demo.txt
```
## Pipeline: Combine input & output redirection
```ls -lrt | awk '{print $1'}```

# How to separate STOUT and STDERR
## Using File descriptors
### 0 for STDIN
### 1 for STDOUT
### 2 for STDERR
```
ls 1>success_output.txt      # store output in success
ls 2>error.txt # store errors in error
java -version 1>jav_ver 2>jav_err.txt
```
## What is 2>&1 stands for?
Please store my errors (STDERR {2}) the same ```destination for STDOUT``` { &1 }
```convention: 1>file_name 2>&1```
```
java -version 1> jav_var.txt 2>&1
cat jav_var.txt
```

## What is &> stands for?
Please store my STDERR and STDOUT in the same destination
```
java -version &> jav_var.txt; cat jav_var.txt
```