# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

import math as m
import random as r
from pytest import approx

tests = {}

# Exercise decorator, specifying that this function needs to be tested
def exercise(fun):
    tests[fun.__name__](fun)
    return fun

# Test decorator, specifying that this is a test for an exercise
def test(fun):
    tests[fun.__name__[:-5]] = fun
    return fun

# ------------------------------------------------------
# Generates a random complex number in Cartesian form
def prep_random_cartesian():
    real = (r.random() - 0.5) * r.randint(0, 100)
    imag = (r.random() - 0.5) * r.randint(0, 100)
    return (real, imag)

# Generates a random complex number in polar form
def prep_random_polar():
    rad = r.random() * r.randint(0, 100)
    theta = (r.random() - 0.5) * m.pi
    return (rad, theta)

# ------------------------------------------------------
# Assert that checks if the result is a tuple of length 2
def assert_tuple(result):
    if result == None: return "Your function must return a value!"
    if not type(result) is tuple: return "Your function must return a tuple, returned " + type(result).__name__ + "."
    if result[0] == ... or result[1] == ...: return "You should not return an ellipsis (...) as part of your answer."
    if len(result) != 2:
        return "Your function must return a tuple of length 2, but returned tuple is of length " + str(len(result))

# Assert that verifies the output is a valid complex tuple, and checks that it matches expected output
def assert_cartesian(expected, actual, message):
    if actual != approx(expected): return message

# Assert that verifies the output is a valid polar tuple, and checks that it matches expected output
def assert_polar(expected, actual, message):
    (ar, atheta) = actual
    if ar == 0:
        if ar != approx(expected[0]): return message
        if not (-m.pi < atheta <= m.pi): return "Even for 0 + 0i, the phase must be between -pi and pi."
        return
    if actual != approx(expected): return message

# ------------------------------------------------------
# Formats a complex number in Cartesian form neatly
def format_cartesian(x):
    return "{0:.3f}".format(x[0]) + (" + " if x[1] >= 0 else " - ") + "{0:.3f}i".format(abs(x[1]))

# Formats a complex number in polar form neatly
def format_polar(x):
    return "{0:.3f} * e^({1:.3f}i)".format(x[0], x[1])

# ------------------------------------------------------
def imaginary_power_ref(n):
    return 1 if n % 4 == 0 else -1

@test
def imaginary_power_test(fun):
    for i in range(-25, 25):
        n = 2 * i
        expected = imaginary_power_ref(n)
        actual = fun(n)
        if actual == None:
            print("Your function must return a value!")
            return
        if expected != actual:
            message = "Result of exponentiation doesn't seem to match expected value: expected (i)^{0} = {1}, got {2}"
            print(message.format(n, expected, actual))
            return
    print("Success!")

# ------------------------------------------------------
def complex_add_ref(x, y):
    return (x[0] + y[0], x[1] + y[1])

@test
def complex_add_test(fun):
    for i in range(25):
        x = prep_random_cartesian()
        y = prep_random_cartesian()
        expected = complex_add_ref(x, y)
        actual = fun(x, y)
        msg = assert_tuple(actual)
        if msg != None:
            print(msg)
            return
        msg = assert_cartesian(expected, actual,
                               "Sum doesn't seem to match expected value: expected ("
                               + format_cartesian(x)
                               + ") + ("
                               + format_cartesian(y)
                               + ") = "
                               + format_cartesian(expected)
                               + ", got "
                               + format_cartesian(actual))
        if msg != None:
            print(msg)
            return
    print("Success!")

# ------------------------------------------------------
def complex_mult_ref(x, y):
    return ((x[0] * y[0]) - (x[1] * y[1]), (x[0] * y[1]) + (x[1] * y[0]))

@test
def complex_mult_test(fun):
    for i in range(25):
        x = prep_random_cartesian()
        y = prep_random_cartesian()
        expected = complex_mult_ref(x, y)
        actual = fun(x, y)
        msg = assert_tuple(actual)
        if msg != None:
            print(msg)
            return
        msg = assert_cartesian(expected, actual,
                               "Product doesn't seem to match expected value: expected ("
                               + format_cartesian(x)
                               + ") * ("
                               + format_cartesian(y)
                               + ") = "
                               + format_cartesian(expected)
                               + ", got "
                               + format_cartesian(actual))
        if msg != None:
            print(msg)
            return
    print("Success!")

# ------------------------------------------------------
def conjugate_ref(x):
    return (x[0], -x[1])

@test
def conjugate_test(fun):
    for i in range(25):
        x = prep_random_cartesian()
        expected = conjugate_ref(x)
        actual = fun(x)
        msg = assert_tuple(actual)
        if msg != None:
            print(msg)
            return
        msg = assert_cartesian(expected, actual,
                               "Conjugate doesn't seem to match expected value: expected conjugate of "
                               + format_cartesian(x)
                               + " to be "
                               + format_cartesian(expected)
                               + ", got "
                               + format_cartesian(actual))
        if msg != None:
            print(msg)
            return
    print("Success!")

# ------------------------------------------------------
def complex_div_ref(x, y):
    ybar = conjugate_ref(y)
    numer = complex_mult_ref(x, ybar)
    denom = complex_mult_ref(y, ybar)[0]
    return complex_mult_ref(numer, (1 / denom, 0))

@test
def complex_div_test(fun):
    for i in range(25):
        x = prep_random_cartesian()
        y = (0, 0)
        while y == (0, 0):
            y = prep_random_cartesian()
        expected = complex_div_ref(x, y)
        actual = fun(x, y)
        msg = assert_tuple(actual)
        if msg != None:
            print(msg)
            return
        msg = assert_cartesian(expected, actual,
                               "Quotient doesn't seem to match expected value: expected ("
                               + format_cartesian(x)
                               + ") / ("
                               + format_cartesian(y)
                               + ") = "
                               + format_cartesian(expected)
                               + ", got "
                               + format_cartesian(actual))
        if msg != None:
            print(msg)
            return
    print("Success!")

# ------------------------------------------------------
def modulus_ref(x):
    return m.sqrt(complex_mult_ref(x, conjugate_ref(x))[0])

@test
def modulus_test(fun):
    for i in range(25):
        x = prep_random_cartesian()
        expected = modulus_ref(x)
        actual = fun(x)
        if actual == None:
            print("Your function must return a value!")
            return
        if not (type(actual) is float or type(actual) is int):
            print("Your function must return a number, returned " + type(actual).__name__ + ".")
            return
        if actual != approx(expected):
            print("Modulus doesn't seem to match expected value: expected |"
                  + format_cartesian(x)
                  + "| = {0:.3f}, got {1:.3f}".format(expected, actual))
            return
    print("Success!")

# ------------------------------------------------------
def complex_exp_ref(x):
    realpow = m.e ** x[0]
    return (realpow * m.cos(x[1]), realpow * m.sin(x[1]))

@test
def complex_exp_test(fun):
    for i in range(25):
        x = prep_random_cartesian()
        expected = complex_exp_ref(x)
        actual = fun(x)
        msg = assert_tuple(actual)
        if msg != None:
            print(msg)
            return
        msg = assert_cartesian(expected, actual,
                               "Result of exponentiation doesn't seem to match expected value: expected e^("
                               + format_cartesian(x)
                               + ") = "
                               + format_cartesian(expected)
                               + ", got "
                               + format_cartesian(actual))
        if msg != None:
            print(msg)
            return
    print("Success!")

# ------------------------------------------------------
def complex_exp_real_ref(r, x):
    if r == 0: return (0, 0)
    lnr = m.log(r)
    return complex_exp_ref(complex_mult_ref((lnr, 0), x))

@test
def complex_exp_real_test(fun):
    for i in range(25):
        base = r.random() * r.randint(1, 100)
        if i == 0:
            base = 0
        x = prep_random_cartesian()
        expected = complex_exp_real_ref(base, x)
        actual = fun(base, x)
        msg = assert_tuple(actual)
        if msg != None:
            print(msg)
            return
        msg = assert_cartesian(expected, actual,
                               "Result of exponentiation doesn't seem to match expected value: "
                               + "expected {0:.3f}^(".format(base)
                               + format_cartesian(x)
                               + ") = "
                               + format_cartesian(expected)
                               + ", got "
                               + format_cartesian(actual))
        if msg != None:
            print(msg)
            return
    print("Success!")

# ------------------------------------------------------
def polar_convert_ref(x):
    return (modulus_ref(x), m.atan2(x[1], x[0]))

@test
def polar_convert_test(fun):
    for i in range(25):
        x = prep_random_cartesian()
        if i == 0:
            x = (0, 0)
        expected = polar_convert_ref(x)
        actual = fun(x)
        msg = assert_tuple(actual)
        if msg != None:
            print(msg)
            return
        msg = assert_polar(expected, actual,
                           "Polar conversion doesn't seem to match expected value: expected "
                           + format_cartesian(x)
                           + " to be converted to "
                           + format_polar(expected)
                           + ", got "
                           + format_polar(actual))
        if msg != None:
            print(msg)
            return
    print("Success!")

# ------------------------------------------------------
def cartesian_convert_ref(x):
    return (x[0] * m.cos(x[1]), x[0] * m.sin(x[1]))

@test
def cartesian_convert_test(fun):
    for i in range(25):
        x = prep_random_polar()
        expected = cartesian_convert_ref(x)
        actual = fun(x)
        msg = assert_tuple(actual)
        if msg != None:
            print(msg)
            return
        msg = assert_cartesian(expected, actual,
                               "Cartesian conversion doesn't seem to match expected value: expected "
                               + format_polar(x)
                               + " to be converted to "
                               + format_cartesian(expected)
                               + ", got "
                               + format_cartesian(actual))
        if msg != None:
            print(msg)
            return
    print("Success!")

# ------------------------------------------------------
def polar_mult_ref(x, y):
    angle = x[1] + y[1]
    if angle > m.pi: angle -= 2 * m.pi
    elif angle <= -m.pi: angle += 2 * m.pi
    return (x[0] * y[0], angle)

@test
def polar_mult_test(fun):
    for i in range(25):
        x = prep_random_polar()
        y = prep_random_polar()
        if i == 0:
            x = (3, 2)
            y = x
        elif i == 1:
            x = (3, -2)
            y = x
        expected = polar_mult_ref(x, y)
        actual = fun(x, y)
        msg = assert_tuple(actual)
        if msg != None:
            print(msg)
            return
        msg = assert_polar(expected, actual,
                           "Product doesn't seem to match expected value: expected ("
                           + format_polar(x)
                           + ") * ("
                           + format_polar(y)
                           + ") = "
                           + format_polar(expected)
                           + ", got "
                           + format_polar(actual))
        if msg != None:
            print(msg)
            return
    print("Success!")

# ------------------------------------------------------
def complex_exp_arbitrary_ref(x, y):
    xp = polar_convert_ref(x)
    return complex_mult_ref(complex_exp_real_ref(xp[0], y), complex_exp_ref(complex_mult_ref((0, xp[1]), y)))

@test
def complex_exp_arbitrary_test(fun):
    for i in range(25):
        x = prep_random_cartesian()
        y = prep_random_cartesian()
        if i == 0:
            x = (0, 0)
        expected = complex_exp_arbitrary_ref(x, y)
        actual = fun(x, y)
        msg = assert_tuple(actual)
        if msg != None:
            print(msg)
            return
        msg = assert_cartesian(expected, actual,
                               "Result of exponentiation doesn't seem to match expected value: expected ("
                               + format_cartesian(x)
                               + ")^("
                               + format_cartesian(y)
                               + ") = "
                               + format_cartesian(expected)
                               + ", got "
                               + format_cartesian(actual))
        if msg != None:
            print(msg)
            return
    print("Success!")

print("Success!")
