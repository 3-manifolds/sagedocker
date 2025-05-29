import snappy, regina, hashlib, time
M = snappy.Manifold('K14n1234')  # one cusp
T = regina.Triangulation3(M)
start = time.time()
surfaces = regina.NormalSurfaces(T, regina.NS_QUAD_CLOSED)
print(len(surfaces), time.time() - start)
data = repr([S.detail() for S in surfaces])
assert hashlib.md5(data.encode()).hexdigest() == '5df8cb7a4dee3a3af3fa0be846943ed3'

M = snappy.Manifold('L14n1234')  # has two cusps
T = regina.Triangulation3(M)
start = time.time()
surfaces = regina.NormalSurfaces(T, regina.NS_QUAD_CLOSED)
print(len(surfaces), time.time() - start)
start = time.time()
surfaces = regina.NormalSurfaces(T, regina.NS_QUAD_CLOSED, regina.NS_FUNDAMENTAL)
print(len(surfaces), time.time() - start)
