# process hierarchy

- agent
    - run service wrapper
        - run start.ps1
            - run garden-windows.exe

PROBLEM:
we wouldn't have a handle on garden-windows.exe, so we couldn't stop
garden-windows.exe, only start.ps1. child processes don't die when their parents
do

SOLUTION:
- agent
    - run service wrapper
        - create job object
        - run start.ps1 in job object
            - run garden-windows.exe (inherits job object)

Now the service wrapper can kill the job object on stop, which will kill the
script and the subprocess


# multiple processes per job

Not really sure how to solve this with the model of one start.ps1 script per
job. We can't start multiple processes per script because then we'd lose the
ability to monitor them individually. 
