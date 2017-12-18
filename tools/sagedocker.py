from __future__ import print_function
import pexpect
import webbrowser

print('Launching a Jupyter server.\n')
command = 'docker run -p 8888:8888 -e SAGE_ROOT=/sage computop/sage /sage/src/bin/sage --notebook=jupyter --ip=0.0.0.0'

proc = pexpect.spawn(command)
output = ''
while True:
    try:
        output += proc.read_nonblocking(1024, 1).decode('ascii')
    except pexpect.exceptions.TIMEOUT:
        break
url = None
for line in output.split('\r\n'):
    line = line.strip()
    if line.startswith('http'):
        url = line
        break
if url:
    webbrowser.open(url)
else:
    print('Failed.  Sorry!')
    
print('Select "New->SageMath X.Y" in the Jupyter Home window to begin.')
print('Select "File->Close and Halt" in the Notebook window to end the session.\n')
while True:
    if proc.expect_exact(['Kernel shutdown:', pexpect.TIMEOUT]) == 0:
        break
    
print('Ciao!')
proc.send(b'\003\003\n\004\n\004')
proc.terminate()
