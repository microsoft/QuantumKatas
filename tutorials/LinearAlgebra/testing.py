import random as r
from cmath import sqrt
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

# Generates a random number from -5 to 5
def randnum():
    return (r.random() - 0.5) * r.randint(1, 10)

# Generates a random complex number
def randcomplex():
    return randnum() + randnum() * 1j

# Height (number of rows) is the first dimension for matrices
# Generates a random matrix populated with complex numbers
def gen_complex_matrix(h = -1, w = -1):
    if h == -1: h = r.randint(1, 5)
    if w == -1: w = r.randint(1, 5)
    ans = []
    for i in range(h):
        temp = []
        for j in range(w):
            temp.append(randcomplex())
        ans.append(temp)
    return ans

# ------------------------------------------------------
# Generates a neat message mixing strings and matrices
def gen_matrix_message(matrices, strings):
    # Calculate the length of every string
    strlengths = []
    for s in strings:
        strlengths.append(len(s))
    
    # Find tallest matrix
    hmax = 0
    for mat in matrices:
        h = len(mat)
        if h > hmax: hmax = h
    
    # Calculate the rows where each matrix would be positioned
    starts = []
    ends = []
    lengths = []
    for mat in matrices:
        h = len(mat)
        start = (hmax + 1 - h) // 2
        starts.append(start)
        ends.append(start + h - 1)
        lengths.append((14 if isinstance(mat[0][0], complex) else 7) * len(mat[0]) + 3)
    
    # Start building the string
    middle = hmax // 2
    ans = ""
    for i in range(hmax):
        for j in range(len(matrices)):
            if i == middle:
                ans += strings[j]
            else:
                ans += ' ' * strlengths[j]
            
            if starts[j] <= i <= ends[j]:
                row = i - starts[j]
                ans += '| '
                ans += format_row(matrices[j][row])
                ans += '|'
            else:
                ans += ' ' * lengths[j]
        
        if i == middle:
            ans += strings[-1]
        else:
            ans += ' ' * strlengths[-1]
        
        ans += '\n'
    
    return ans

# Formats the row of a matrix to be evenly spaced
def format_row(row):
    ans = ""
    for num in row:
        if num == ...:
            ans += "     ...     "
            continue
        
        if num.real >= 0:
            ans += ' '
        
        ar = abs(num.real)
        ai = abs(num.imag)
        if ar < 10:
            ans += "{0:.3f}".format(num.real)
        elif ar < 100:
            ans += "{0:.2f}".format(num.real)
        else:
            ans += str(round(num.real))
        
        if num.imag >= 0:
            ans += '+'
        
        if ai < 10:
            ans += "{0:.3f}".format(num.imag)
        elif ai < 100:
            ans += "{0:.2f}".format(num.imag)
        else:
            ans += str(round(num.imag))
        
        ans += 'i '
    return ans

def gen_labeled_message(matrices, labels):
    ans = ""
    for i in range(len(matrices)):
        ans += format_matrix(matrices[i], labels[i]) + '\n'
    return ans

def format_matrix(matrix, label):
    if matrix == ...:
        return label + "..."
    n = len(matrix)
    lsize = len(label)
    ans = ""
    middle = n // 2
    for i in range(n):
        if i == middle:
            ans += label
        else:
            ans += ' ' * lsize
        ans += '| ' + format_row(matrix[i]) + '|\n'
    return ans

# ------------------------------------------------------
# Checks that two matrices are (approximately) equal to each other
def matrix_equal(act, exp):
    if act == ... or exp == ...:
        return False
    
    h = len(act)
    w = len(act[0])
    # Check that sizes match
    if h != len(exp) or w != len(exp[0]):
        return False
    
    for i in range(h):
        if act[i] != approx(exp[i]):
            return False
    return True

# ------------------------------------------------------
# Makes a copy of the target matrix
def matrix_copy(mat):
    ans = []
    for row in mat:
        ans.append(row[:])
    return ans

# Creates an n by m matrix filled with 0s
def create_empty_matrix(n, m):
    ans = []
    for i in range(n):
        ans.append([0] * m)
    return ans

# ------------------------------------------------------
def matrix_add_ref(a, b):
    n = len(a)
    m = len(a[0])
    ans = create_empty_matrix(n, m)
    for i in range(n):
        for j in range(m):
            ans[i][j] = a[i][j] + b[i][j]
    
    return ans

@test
def matrix_add_test(fun):
    for i in range(10):
        a = gen_complex_matrix()
        b = gen_complex_matrix(len(a), len(a[0]))
        expected = matrix_add_ref(a, b)
        actual = fun(a, b)
        if actual == None:
            print("Your function must return a value!")
            return
        if not matrix_equal(actual, expected):
            print("Unexpected results of addition: \n"
                  + gen_labeled_message([a, b, expected, actual],
                                        ["A: ", "B: ", "Expected: ", "You returned: "])
                  + "Try again!")
            return
    print("Success!")

# ------------------------------------------------------
def scalar_mult_ref(x, a):
    ans = []
    for row in a:
        temp = []
        for elem in row:
            temp.append(elem * x)
        ans.append(temp)
    return ans

@test
def scalar_mult_test(fun):
    for i in range(10):
        a = gen_complex_matrix()
        x = randcomplex()
        expected = scalar_mult_ref(x, a)
        actual = fun(x, a)
        if actual == None:
            print("Your function must return a value!")
            return
        if not matrix_equal(actual, expected):
            print("Unexpected results of scalar multiplication: \nScalar: {0:.3f}\n\n".format(x)
                  + gen_labeled_message([a, expected, actual],
                                        ["A: ", "Expected: ", "You returned: "])
                  + "Try again!")
            return
    print("Success!")

# ------------------------------------------------------
def matrix_mult_ref(a, b):
    h = len(a)
    common = len(a[0]) # = len(b)
    w = len(b[0])
    ans = create_empty_matrix(h, w)
    for i in range(h):
        for j in range(w):
            for k in range(common):
                ans[i][j] += a[i][k] * b[k][j]
    return ans

@test
def matrix_mult_test(fun):
    for i in range(10):
        a = gen_complex_matrix()
        b = gen_complex_matrix(len(a[0]))
        expected = matrix_mult_ref(a, b)
        actual = fun(a, b)
        if actual == None:
            print("Your function must return a value!")
        if not matrix_equal(actual, expected):
            print("Unexpected results of matrix multiplication: \n"
                  + gen_labeled_message([a, b, expected, actual],
                                        ["A: ", "B: ", "Expected: ", "You returned: "])
                  + "Try again!")
            return
    print("Success!")

# ------------------------------------------------------
def matrix_inverse_ref(m):
    a = m[0][0]
    b = m[0][1]
    c = m[1][0]
    d = m[1][1]
    det = (a * d) - (b * c)
    return [[d / det, -b / det], [-c / det, a / det]]

@test
def matrix_inverse_test(fun):
    for i in range(10):
        a = None
        det = 0
        while det == 0:
            a = gen_complex_matrix(2,2)
            det = (a[0][0] * a[1][1]) - (a[0][1] * a[1][0])
        expected = matrix_inverse_ref(a)
        actual = fun(a)
        if actual == None:
            print("Your function must return a value!")
        if not matrix_equal(actual, expected):
            print("Inverse doesn't seem to match expected:\n"
                  + gen_labeled_message([a, expected, actual],
                                        ["A: ", "Expected: ", "You returned: "])
                  + "Try again!")
            return
    print("Success!")

# ------------------------------------------------------
def transpose_ref(a):
    ans = []
    n = len(a)
    m = len(a[0])
    for i in range(m):
        row = []
        for j in range(n):
            row.append(a[j][i])
        ans.append(row)
    return ans

@test
def transpose_test(fun):
    for i in range(10):
        a = gen_complex_matrix()
        expected = transpose_ref(a)
        actual = fun(a)
        if actual == None:
            print("Your function must return a value!")
            return
        if not matrix_equal(actual, expected):
            print("Unexpected result of a transpose:\n"
                  + gen_labeled_message([a, expected, actual],
                                        ["A: ", "Expected: ", "You returned: "])
                  + "Try again!")
            return
    print("Success!")

# ------------------------------------------------------
def conjugate_ref(a):
    ans = []
    for row in a:
        temp = []
        for num in row:
            temp.append(num.real - (num.imag * 1j))
        ans.append(temp)
    return ans

@test
def conjugate_test(fun):
    for i in range(10):
        a = gen_complex_matrix()
        expected = conjugate_ref(a)
        actual = fun(a)
        if actual == None:
            print("Your function must return a value!")
            return
        if not matrix_equal(actual, expected):
            print("Unexpected result of matrix conjugate:\n"
                  + gen_labeled_message([a, expected, actual],
                                        ["A: ","Expected: ","You returned: "])
                  + "Try again!")
            return
    print("Success!")

# ------------------------------------------------------
def adjoint_ref(a):
    return conjugate_ref(transpose_ref(a))

@test
def adjoint_test(fun):
    for i in range(10):
        a = gen_complex_matrix()
        expected = adjoint_ref(a)
        actual = fun(a)
        if actual == None:
            print("Your function must return a value!")
            return
        if not matrix_equal(actual, expected):
            print("Unexpected result of adjoint operation:\n"
                  + gen_labeled_message([a, expected, actual],
                                        ["A: ","Expected: ","You returned: "])
                  + "Try again!")
            return
    print("Success!")

# ------------------------------------------------------
# Projection operator - returns (<v,w>/<v,v>)*v
def projection(v,w):
    return scalar_mult_ref(inner_prod_ref(w,v) / inner_prod_ref(v,v), v)

# Appends a vector as the next column in a matrix
def append_vector(m,v):
    for i in range(len(m)):
        m[i].append(v[i][0])

# Generates a unitary matrix via the Gram-Schmidt process
def gen_unitary_matrix(n = -1):
    if n == -1: n = r.randint(1, 5)
    temp = gen_complex_matrix(n, n)
    
    # Split the generated matrix into vectors
    vectors = []
    for i in range(n):
        v = []
        for j in range(n):
            v.append([temp[j][i]])
        vectors.append(v)
    
    vectors2 = []
    for i in range(n):
        v = matrix_copy(vectors[i])
        for j in range(i-1,-1,-1):
            v = matrix_add_ref(v, scalar_mult_ref(-1, projection(vectors2[j], vectors[i])))
        vectors2.append(v)
    
    ans = []
    for i in range(n): ans.append([])
    for v in vectors2:
        append_vector(ans, normalize_ref(v))
    
    return ans

edge_unitary_matrices = [[[0, 0], [0, 0]], [[1/sqrt(2), 1/sqrt(2)], [1/sqrt(2), 1/sqrt(2)]]]

def is_matrix_unitary_ref(a):
    n = len(a)
    prod = matrix_mult_ref(a, adjoint_ref(a))
    for i in range(n):
        for j in range(n):
            if i == j:
                if prod[i][j] != approx(1): return False
            else:
                if prod[i][j] != approx(0): return False
    return True

@test
def is_matrix_unitary_test(fun):
    for testId in range(12):
        a = []
        # The first two tests are edge cases, after that unitary and non-unitary matrices alternate
        if testId < 2:
            a = edge_unitary_matrices[testId]
        elif testId % 2 == 0:
            a = gen_unitary_matrix()
        else:
            n = r.randint(1,5)
            a = gen_complex_matrix(n,n)
        expected = is_matrix_unitary_ref(a)
        actual = fun(a)
        if actual == None:
            print("Your function must return a value!")
            return
        if actual != expected:
            print("Unexpected result:\n"
                  + gen_matrix_message([a],
                                       ["Matrix ", (" is " if expected else " is not ")
                                                   + "unitary, but misidentified as " 
                                                   + ("unitary" if actual else "not unitary")]))
            return
    print("Success!")

# ------------------------------------------------------
def inner_prod_ref(v, w):
    return matrix_mult_ref(adjoint_ref(v), w)[0][0]

@test
def inner_prod_test(fun):
    for i in range(10):
        v = gen_complex_matrix(w = 1)
        w = gen_complex_matrix(len(v), 1)
        expected = inner_prod_ref(v, w)
        actual = fun(v, w)
        if type(actual) == list:
            print("You should return a number, not a matrix")
            return
        if actual == None or actual == ...:
            print("Your function must return a value!")
            return
        if actual != approx(expected):
            print("Unexpected result of inner product:\n"
                  + gen_labeled_message([v, w], ["V: ", "W: "])
                  + "Expected: {0:.3f}\n\n".format(expected)
                  + "You returned: {0:.3f}\n\nTry again!".format(actual))
            return
    print("Success!")

# ------------------------------------------------------
def normalize_ref(v):
    return scalar_mult_ref(1 / sqrt(inner_prod_ref(v,v).real), v)

@test
def normalize_test(fun):
    for i in range(10):
        v = None
        norm = 0
        while norm == 0:
            v = gen_complex_matrix(w = 1)
            norm = inner_prod_ref(v, v)
        expected = normalize_ref(v)
        actual = fun(v)
        if actual == None:
            print("Your function must return a value!")
            return
        if not matrix_equal(actual, expected):
            print("Unexpected result of normalization:\n"
                  + gen_labeled_message([v, expected, actual], ["V: ", "Expected: ", "You returned: "])
                  + "Try again!")
            return
    print("Success!")

# ------------------------------------------------------
def outer_prod_ref(v, w):
    return matrix_mult_ref(v, adjoint_ref(w))

@test
def outer_prod_test(fun):
    for i in range(10):
        v = gen_complex_matrix(w = 1)
        w = gen_complex_matrix(w = 1)
        expected = outer_prod_ref(v, w)
        actual = fun(v, w)
        if actual == None:
            print("Your function must return a value!")
            return
        if not matrix_equal(actual, expected):
            print("Unexpected result of outer product:\n"
                  + gen_labeled_message([v, w, expected, actual],
                                        ["V: ", "W: ", "Expected: ", "You returned: "])
                  + "Try again!")
            return
    print("Success!")

# ------------------------------------------------------
def tensor_product_ref(a, b):
    n = len(a)
    m = len(a[0])
    k = len(b)
    l = len(b[0])
    
    ans = []
    for i in range(n * k):
        row = [0] * m * l
        ans.append(row)
    
    for i in range(n):
        for j in range(m):
            for o in range(k):
                for p in range(l):
                    ans[i * k + o][j * l + p] = a[i][j] * b[o][p]
    
    return ans

@test
def tensor_product_test(fun):
    for i in range(10):
        (a, b) = ([[1, 1, 1]], [[1, 1, 1]])
        while len(a[0]) * len(b[0]) >= 8:
            a = gen_complex_matrix()
            b = gen_complex_matrix()
        expected = tensor_product_ref(a, b)
        actual = fun(a, b)
        if actual == None:
            print("Your function must return a value!")
            return
        if not matrix_equal(actual, expected):
            print("Unexpected result of tensor product:\n"
                  + gen_labeled_message([a, b, expected, actual],
                                        ["A: ", "B: ", "Expected: ", "You returned: "])
                  + "Try again!")
            return
    print("Success!")

# ------------------------------------------------------
edge_matrices = [
    [[4, -6, 6], [3, -5, 3], [3, -3, 1]], 
    [[1, 5, 0], [2, -6, 0], [1, 2, 3]],
    [[3, -2], [-3, 2]],
    [[0,0], [0,2]],
    [[2,0], [0,0]]]
    
edge_values = [-2, 3, 0, 2, 2]
edge_vectors = [[[0], [1], [1]], [[0], [0], [-2]], [[2], [3]], [[0], [-1]], [[1], [0]]]

# Computes determinant of a matrix (recursive)
def determinant(mat):
    n = len(mat)
    if n == 1:
        return mat[0][0]
    else:
        ans = 0
        coeff = 1
        for i in range(n):
            temp = []
            for j in range(1, n):
                row = []
                for k in range(n):
                    if k != i:
                        row.append(mat[j][k])
                temp.append(row)
            ans += coeff * mat[0][i] * determinant(temp)
            coeff *= -1
        return ans

# Generates a matrix and an eigenvalue by generating a square matrix,
# taking the top right element as the eigenvalue, and solving for what to replace it with
def gen_eigenmatrix(n = -1):
    if n == -1: n = r.randint(2, 5)
    
    ans = [[0]]
    while ans[0][-1] == 0:
        ans = gen_complex_matrix(n, n)
    eigen = ans[0][-1]
    ans[0][-1] = 0
    
    for i in range(n):
        ans[i][i] -= eigen
    
    part_det = determinant(ans)
    topright = part_det / determinant(ans[1:])
    if n % 2 == 1: topright *= -1
    
    ans[0][-1] = topright
    for i in range(n):
        ans[i][i] += eigen
    
    return (ans, eigen)

# Adds a row of a matrix multiplied by a factor to the target row
def row_add(target, row, factor):
    for i in range(len(target)):
        target[i] += row[i] * factor

# Brings a matrix to reduced row-echelon form (used to find eigenvectors)
def row_reduce(mat):
    n = len(mat)
    m = len(mat[0])
    for i in range(n):
        row = mat[i]
        if row[i] == approx(0) and i == n-1:
            row[i] = 0
            return
        while row[i] == approx(0):
            row[i] = 0
            mat.append(row)
            mat.pop(i)
            row = mat[i]
        factor = 1 / row[i]
        for j in range(m):
            row[j] *= factor
        for j in range(i+1, n):
            row_add(mat[j], row, -mat[j][i])
    for i in range(n-1, -1, -1):
        for j in range(i):
            row_add(mat[j], mat[i], -mat[j][i])

def find_eigenvector_ref(a, x):
    n = len(a)
    mat = matrix_copy(a)
    for i in range(n):
        mat[i][i] -= x
    row_reduce(mat)
    mat.pop()
    for row in mat:
        row.append(-row[0])
        row.pop(0)
    row_reduce(mat)
    ans = [[1]]
    for row in mat:
        ans.append([row[-1]])
    return ans

@test
def find_eigenvalue_test(fun):
    for i in range(10):
        (a, expected, v) = (None, None, None)
        if i < 3:
            (a, expected) = (edge_matrices[i], edge_values[i])
            v = edge_vectors[i]
        else:
            (a, expected) = gen_eigenmatrix()
            v = find_eigenvector_ref(a, expected)
        actual = fun(a, v)
        if actual == None or actual == ...:
            print("Your function must return a value!")
            return
        if actual != approx(expected):
            print("Wrong eigenvalue!\n"
                  + gen_labeled_message([a, v], ["A: ", "V: "])
                  + "Expected "
                  + "{0:.3f}\n\n".format(expected)
                  + "You returned: {0:.3f}\n\n".format(actual)
                  + "Try again!")
            return
    print("Success!")

# ------------------------------------------------------
@test
def find_eigenvector_test(fun):
    for i in range(10):
        (a, x) = (None, None)
        if i < 3:
            (a, x) = (edge_matrices[-1-i], edge_values[-1-i])
        else:
            (a, x) = gen_eigenmatrix(2)
        
        result = fun(a, x)
        if result == None or result == ...:
            print("Your function must return a value!")
            return
        if result == [[0], [0]]:
            print("The eigenvector must be non-zero!")
            return
        matrix_product = matrix_mult_ref(a, result)
        scalar_product = scalar_mult_ref(x, result)
        if not matrix_equal(matrix_product, scalar_product):
            print("Wrong eigenvector!\nEigenvalue: {0:.3f}\n\n".format(x)
                  + gen_labeled_message([a, result, matrix_product, scalar_product], ["A: ", "You returned V: ", "Matrix product AV:", "Scalar product xV: "])
                  + "Try again!")
            return
    print("Success!")

print("Success!")
