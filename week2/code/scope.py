#!/usr/bin/env python3 

"""Some examples explaining variable scope in python"""

# block 1: illustrate what is global variable and what is local variable
_a_global = 10 # a global variable

if _a_global >= 5:
    _b_global = _a_global + 5 # also a global variable

def a_function():
    """An example function to illustrate variable scope"""
    _a_global = 5 # a local variable
    
    if _a_global >= 5:
        _b_global = _a_global + 5 # also a local variable
    
    _a_local = 4
    
    print("Inside the function, the value of _a_global is ", _a_global)
    print("Inside the function, the value of _b_global is ", _b_global)
    print("Inside the function, the value of _a_local is ", _a_local)
    
    return None

a_function()

print("Outside the function, the value of _a_global is ", _a_global)
print("Outside the function, the value of _b_global is ", _b_global)

# block 2: a variable assigned outside the function is available inside function
_a_global = 10

def a_function():
    """An example function to illustrate variable scope"""
    _a_local = 4
    
    print("Inside the function, the value _a_local is ", _a_local)
    print("Inside the function, the value of _a_global is ", _a_global)
    
    return None

a_function()

print("Outside the function, the value of _a_global is", _a_global)

## block 3: use global keyword to modify a global variable from inside a function
_a_global = 10

print("Outside the function, the value of _a_global is", _a_global)

def a_function():
    """An example function to illustrate global keyword"""
    global _a_global
    _a_global = 5
    _a_local = 4
    
    print("Inside the function, the value of _a_global is ", _a_global)
    print("Inside the function, the value _a_local is ", _a_local)
    
    return None

a_function()

print("Outside the function, the value of _a_global now is", _a_global)

## block 4: in nested functions, global keyword inside the inner function change the global variables in the main workspace,
## but the global variable within the scope remained origin
def a_function():
    """An example function to illustrate nested functions"""
    _a_global = 10

    def _a_function2():
        """An example function to illustrate global keyword in nested functions"""
        global _a_global
        _a_global = 20

    print("Before calling a_function, value of _a_global is ", _a_global)

    _a_function2()

    print("After calling _a_function2, value of _a_global is ", _a_global)

    return None

a_function()

print("The value of _a_global in main workspace / namespace is ", _a_global)


## block 5: an example compared with block 4 to illustrate global keyword in nested functions
_a_global = 10

def a_function():
    """Another example function to illustrate nested functions"""

    def _a_function2():
        """Another example function to illustrate global keyword in nested functions"""
        global _a_global
        _a_global = 20
    
    print("Before calling a_function, value of _a_global is ", _a_global)

    _a_function2()
    
    print("After calling _a_function2, value of _a_global is ", _a_global)

a_function()

print("The value of _a_global in main workspace / namespace is ", _a_global)