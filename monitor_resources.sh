# Step-by-step instructions to automate the CPU, memory, and disk checks in Linux and send the output to an email

# Install the mailx utility on your Linux system if it's not already installed. You can install it using the following command:
sudo apt-get install mailutils

# Create a shell script that performs the CPU, memory, and disk checks and sends the output to an email address. Here's an example script that you can modify according to your needs:
#!/bin/bash

# Check CPU usage
cpu=$(top -bn1 | grep "Cpu(s)" | \
  sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
  awk '{print 100 - $1}')
echo "CPU usage: $cpu%"

# Check memory usage
memory=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }')
echo "Memory usage: $memory"

# Check disk usage
disk=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')
echo "Disk usage: $disk"

# Write the output to a log file
echo "$(date) CPU usage: $cpu%, Memory usage: $memory, Disk usage: $disk" >> /path/to/logfile.log

# Send the output to an email address
cat /path/to/logfile.log | mailx -s "System Resource Usage" user@example.com

# Replace "/path/to/logfile.log" with the actual path to the log file where you want to store the output, and "user@example.com" with the email address to which you want to send the output.

# Make the shell script executable using the following command:
chmod +x /path/to/script.sh

# Open the Cron configuration file using the following command:
crontab -e

# Add the following line at the end of the file to run the script every minute and redirect the output to /dev/null:
* * * * * /path/to/script.sh >/dev/null 2>&1

# Replace "/path/to/script.sh" with the actual path to the shell script that performs the CPU, memory, and disk checks.

# The >/dev/null 2>&1 part at the end of the line redirects the standard output and error to /dev/null, which prevents any output from being displayed on the terminal.

# Save and close the Cron configuration file.

# Now, the system resource usage information will be checked every minute, and the output will be sent to the specified email address. You can check the email inbox to monitor the system resource usage over time.

