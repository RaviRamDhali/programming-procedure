https://www.isumsoft.com/computer/how-to-clear-all-event-logs-in-event-viewer.html

To Clear All the Event Logs in Command Prompt

You can choose to quickly clear all the event logs by executing command in Command Prompt.

Step 1: Open Command Prompt and run it as administrator.
Run command Prompt as an administrator

Step 2: If it prompted by UAC, click on Yes.
Allow to run this program

Step 3: Then copy and past command below into the elevated command prompt, and press Enter.

for /F "tokens=*" %1 in ('wevtutil.exe el') DO wevtutil.exe cl "%1"

Clear all the Event Viewer log in Command Prompt

Step 4: The event logs will be cleared. Then, close the command prompt when finished.
