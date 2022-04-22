# Mastering Bash and Zsh shell

# Basic check commands

Check your hostname

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled.png)

How to search for zsh?

sudo apt search ^zsh

apt show zsh

sudo apt install zsh

# Working with Variables

## Variable SCOPE

### Local variable:

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%201.png)

```bash
sudo apt install vim
EDITOR=vim
```

### Environment variable:

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%202.png)

### Command variable

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%203.png)

<aside>
💡 How to list variables?

</aside>

```bash
set | grep EDITOR     # see the local variable and others
env | grep EDITOR     # only see environment variable
printenv | grep EDITOR
```

Demo with EDITOR as local then promote to env by export

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%204.png)

<aside>
💡 How to repeat the command before?
Use **!!**

</aside>

```bash
crontab -e
# use command variable (local + cmd in same line)
EDITOR=vim **!!**
```

## Declare commands

### Print with declare -p

Test with **set** for all variables and **env** for environment variable

```bash
MYNAME=PHUONG
set | grep MYNAME

export MYLASTNAME=VO
env | grep MYLASTNAME

declare -p MYNAME MYLASTNAME

#clear env variable
unset MYLASTNAME
```

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%205.png)

### Converting case with declare -u or -l (upper/lower)

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%206.png)

### Export and unset env variable with declare -x or +x

declare -x = export

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%207.png)

declare +x = unset

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%208.png)

### Constants Readonly var with declare -r

<aside>
💡 What is constant and why should we use it?

</aside>

Constant is ReadOnly variable - can not be unset - remain for shell session

Use constant for adding security: Unchanged variable

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%209.png)

Integer values with declare -i

<aside>
💡 *Why should we use Integer for a variable?*
Variable only accepts strings at default. Force date-type as an integer can be useful when we accept user input or test for correct input

</aside>

Example for validating input: 1 < days < 30 is true

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%2010.png)

### Arrays with declare -a or declare -A

declare -a: Multiple values array

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%2011.png)

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%2012.png)

declare -A: Associative array (dictionary)

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%2013.png)

## Demo

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%2014.png)

![Untitled](Mastering%20Bash%20and%20Zsh%20shell%207f73fbbc80c64d1b83ddd2f37db3b8c5/Untitled%2015.png)