# Square to find
sq = 2

# Initial guesses
x1 = 0
x2 = 30
y1 = x1*x1 - sq
y2 = x2*x2 - sq
counter = 0     # Count number of iterations
limit = 20      # Limit the iterations
tolerance = 0.00001


# Stop when the limit is reached, the difference between the two guesses is small enough or a solution is found
while (counter < limit and abs(x1-x2)>tolerance):     
    # Find middle point and evaluate solution
    xm = (x1 + x2) / 2
    ym = xm * xm - sq

    # Stop if solution found
    if abs(ym) < tolerance:
        break

    # Update new value depending on sign
    if ym < 0: # Different sign
        x1 = xm
        y1 = ym
    else:
        x2 = xm
        y2 = ym
    print(y1, y2, x1, x2)
    counter+=1

print(xm, ym)