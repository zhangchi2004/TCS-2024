#!/usr/bin/env python3

# Boolean
#
# Terms land and lnot represents logical AND and NOT connectives
#
# Function church2bool converts lambda terms representing true and false to the
# Boolean type in Python

true = lambda x: lambda y: x
false = lambda x: lambda y: y
land = lambda x: lambda y: x(y)(false)
lnot = lambda b: lambda x: lambda y: b(y)(x)

church2bool = lambda b: b(True)(False)

print('Booleans')
print('--------')
print(f'The logical NOT of True is {church2bool(lnot(true))}.')
print(f'The logical NOT of False is {church2bool(lnot(false))}.')
print(f'The logical AND of True and True is {church2bool(land(true)(true))}.')
print(f'The logical AND of True and False is {church2bool(land(true)(false))}.')
print(f'The logical AND of False and True is {church2bool(land(false)(true))}.')
print(f'The logical AND of False and False is {church2bool(land(false)(false))}.\n')

# Church numerals

zero = lambda f: lambda x: x

succ = lambda n: lambda f: lambda x: f(n(f)(x))

one = succ(zero)
two = succ(one)
three = succ(two)
four = succ(three)
five = succ(four)

iszero = lambda n: lambda x: lambda y: n(lambda z: y)(x)

# Addition, multiplication, and exponential functions

add = lambda m: lambda n: lambda f: lambda x: n(f)(m(f)(x))

mult = lambda m: lambda n: lambda f: lambda x: n(m(f))(x)

exp = lambda m: lambda n: n(m)

# Function church2int converts Church numerals to the integer type in Python

church2int = lambda n: n(lambda x: x + 1)(0)

# Function church2int converts the integer type in Python to Church numerals

def int2church(i):
    if i == 0:
        return zero
    else:
        return succ(int2church(i - 1))

print('Numbers')
print('-------')
print(f'4 + 3 = {church2int(add(four)(three))}.')
print(f'23 * 23 = {church2int(mult(int2church(23))(int2church(23)))}.\n')

# Demonstration of fixed-point combinators

print('Fixed-point Combinators')
print('-----------------------')

# Y Combinator, which does not work due to eager reduction strategy of Python
#
# If you use Y instead of Z in the following examples, Python will report
# RecursionError

Y = lambda f: (lambda x: f(x(x)))(lambda x: f(x(x)))

# Z Combinator is a variant of Y that works in Python
#
# The extra lambda s delays the evaluations inside

Z = lambda f: (lambda x: f(lambda s: x(x)(s)))(lambda x: f(lambda s: x(x)(s)))

# Define a function fib whose fixed-point is the function computing the n-th
# Fibonacci number
#
# For simplicity, we mixed the use of lambda calculus and standard Python code

fib  = lambda x: lambda n: n-1 if n <= 2 else x(n-1) + x(n-2)

print('The first ten Fibonacci numbers are:', end='')
for i in range(1,11):
    print(f' {Z(fib)(i)}', end='')
print('.\n')

print('Pairs and Lists')
print('---------------')
pair = lambda a: lambda b: lambda x: x(a)(b)

fst = lambda p: p(true)
snd = lambda p: p(false)

nil = lambda x: true
head = fst
tail = snd
empty = lambda l: l(lambda x: lambda y: false)

# Reduce and map functions
#
# The extra lambda x in reduce is also for delaying the evaluation

red = lambda s: lambda l: lambda f: lambda z: empty(l)(z)(lambda x:f(head(l))(s(tail(l))(f)(z))(x))
reduce = Z(red) # override reduce
cons = pair
map = lambda l: lambda f: reduce(l)(lambda a: lambda b: cons(f(a))(b))(nil) # override map
filter = lambda l: lambda f: reduce(l)(lambda a: lambda b: f(a)(cons(a)(b))(b))(nil) # override filter
size = lambda l: reduce(l)(lambda a: lambda b: succ(b))(zero)

# Set l to be the list (2, 4, 1, 3).

l = cons(two)(cons(four)(cons(one)(cons(three)(nil))))

print(f'The first entry of the pair <4, 5> is {church2int(fst(pair(four)(five)))}.')
print(f'The second entry of the pair <4, 5> is {church2int(snd(pair(four)(five)))}.\n')

print('The list l is set to 2 :: 4 :: 1 :: 3 :: nil.')
print(f'Is the list l empty? {church2bool(empty(l))}.')
print(f'Is the list nil empty? {church2bool(empty(nil))}.')
print(f'The length of the list l is {church2int(size(l))}.')
print(f'The sum of elements in the list l is {church2int(reduce(l)(add)(zero))}.')
print(f'The product of elements in the list l is {church2int(reduce(l)(mult)(one))}.')
