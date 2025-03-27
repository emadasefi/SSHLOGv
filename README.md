# SSHLOGv Script (SSH Log Viewer)
====================================

This script is an SSH Log Viewer, a powerful tool for system administrators to monitor and analyze SSH login attempts on Linux systems using systemd's journalctl.
<br><br>


## 🌟 Description
The SSH Log Viewer is a bash script designed to provide system administrators with an efficient way to monitor and analyze SSH login activities on Linux systems that use systemd's journalctl for logging. It offers a user-friendly interface with multiple viewing and filtering options, making it easier to track successful logins, failed attempts, and potential security threats.

The script utilizes journalctl to access SSH logs and presents them in a formatted, easy-to-read table. It dynamically adjusts to the terminal width, ensuring optimal display across different environments. The script extracts key information from each log entry, including date, time, session type, username, authentication method, source IP, and more.

With its menu-driven interface, users can easily switch between different viewing modes and apply various filters. The script also includes a save functionality, allowing users to export filtered logs for further analysis or record-keeping.
<br><br>

## 🎯 Features
<li><strong>Live Stream:</strong> Real-time monitoring of SSH login attempts</li>
<li><strong>Last 10 Logs:</strong> Quick view of recent SSH activities</li>
<li><strong>User Filtering:</strong> Analyze logs for specific users</li>
<li><strong>Failed Sessions Filtering:</strong> Focus on unsuccessful login attempts</li>
<li><strong>Date Filtering:</strong> Examine logs from a specific date</li>
<li><strong>Save Functionality:</strong> Export filtered logs to a file</li>
<li><strong>Responsive Design:</strong> Adapts to terminal width for optimal display</li>
<li><strong>Detailed Log Information:</strong> Extracts and displays key details from each log entry</li>
<li><strong>User-friendly Interface:</strong> Easy-to-navigate menu system</li>
<li><strong>Error Handling:</strong> Checks for journalctl availability and provides appropriate error messages</li>
<br><br>


## 🖼️ ScreenShots :
<img src="https://raw.githubusercontent.com/emadasefi/SSHLOGv/refs/heads/main/SSHLOGvScreen.gif" alt="SSH Log Viewer"> 
<br><br>


## 💡 How to Install and Run It :
<li>Save the script to a file (e.g., sshlogv.sh)</li>
<li>Make the script executable:</li>

```shell
chmod +x sshlogv.sh
```
<li>Run the script with sudo privileges</li>

```shell
sudo ./sshlogv.sh
```
<li>Navigate through the menu options using the number keys</li>
<li>Follow on-screen prompts to filter, view, and save logs</li>
<br><br>


## 📜 Note
<li>This script requires journalctl, which is typically available on systems using systemd. Ensure you have the necessary permissions to access SSH logs. The script will check for journalctl availability and provide an error message if it's not found.</li>
<br><br>


## — Feedback ❤️—
Please leave a comment if you have any comments, suggestions or problems.








