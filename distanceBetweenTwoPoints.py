import matlab.engine

eng = matlab.engine.start_matlab()
point1 = matlab.double([1, 2, 3])
point2 = matlab.double([4, 5, 6])
eng.workspace['p1'] = point1
eng.workspace['p2'] = point2
distance = eng.eval('norm(p2 - p1)', nargout=1)
print("Distance between [1, 2, 3] and [4, 5, 6] is:", distance)
eng.quit()
