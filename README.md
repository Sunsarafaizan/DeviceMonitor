# 📋 Complete README.md — Single Copy-Paste Block

Copy **everything** below the line and paste it directly into your `README.md` file.

---

```markdown
# 🖥️ Device Monitor

> 📡 A PowerShell script that monitors network devices via ping and sends email alerts when a device goes **DOWN** 🔴 or comes back **UP** 🟢.

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?logo=powershell)
![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?logo=windows)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📖 Table of Contents

- [✨ Features](#-features)
- [📁 Files](#-files)
- [🧰 Requirements](#-requirements)
- [🚀 Quick Start](#-quick-start)
- [🔑 How to Generate Gmail App Password](#-how-to-generate-gmail-app-password)
- [✏️ What to Change in the Script](#️-what-to-change-in-the-script)
- [📊 How to Make the CSV File](#-how-to-make-the-csv-file)
- [⚙️ How the Script Works](#️-how-the-script-works)
- [📧 Email Format](#-email-format)
- [🖥️ Auto-Start at Windows Boot](#️-auto-start-at-windows-boot)
- [🐛 Troubleshooting](#-troubleshooting)
- [🔐 Security Best Practices](#-security-best-practices)
- [📜 License](#-license)

---

## ✨ Features

- 🔄 Pings every device in `details.csv` every **10 seconds**
- 🚫 Ignores the first **4 consecutive failures** (avoids false alarms)
- 🔴 Sends a **DOWN** email on the **5th consecutive failure**
- 🟢 Sends an **UP** email with total downtime when the device recovers
- 📧 Supports **multiple recipients** per device (separate with `;` or `,`)
- 🕐 Times shown in **Indian Standard Time (IST)**
- 📝 Logs all events to `DeviceMonitor.log`
- 🔐 Works with Gmail App Password (2FA-safe)
- 🪟 Runs silently in the background via Task Scheduler

---

## 📁 Files

| 📄 File | 📝 Purpose |
|---------|-----------|
| `DeviceMonitor.ps1` | 🎯 Main monitoring script |
| `details.csv` | 📊 Device list (name, IP, email) |
| `README.md` | 📘 This documentation |
| `LICENSE` | ⚖️ MIT License |

---

## 🧰 Requirements

Before running, make sure you have:

- 🪟 **Windows 10 or 11**
- ⚡ **Windows PowerShell 5.1** (built into Windows)
- 🌐 **Internet connection** (for sending emails)
- 📧 **Gmail account** with **2-Step Verification** enabled
- 🔑 **Gmail App Password** (we'll generate it in a moment)
- 🔧 **Administrator access** (to run PowerShell ISE as admin)

---

## 🚀 Quick Start

### 🔹 Step 1 — Download the script

Clone this repository or download the ZIP:

```powershell
git clone https://github.com/YOUR-USERNAME/DeviceMonitor.git
cd DeviceMonitor
```

Or just **download** the 4 files from this page and put them in one folder, e.g.:

```
C:\DeviceMonitor\
```

### 🔹 Step 2 — Open PowerShell ISE as Administrator

1. Press `Win + R` 🪟
2. Type: `powershell_ise`
3. Press `Ctrl + Shift + Enter` ⚡ (this opens it **as Administrator**)
4. Click **Yes** on the UAC prompt ✅

### 🔹 Step 3 — Allow script execution

In the **ISE console pane** (bottom half), paste this and press `Enter`:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

When prompted, type `Y` and press `Enter`.

### 🔹 Step 4 — Open the script

In ISE:

- **File → Open** → select `DeviceMonitor.ps1`

Or paste this in the console:

```powershell
notepad "C:\DeviceMonitor\DeviceMonitor.ps1"
```

### 🔹 Step 5 — Edit your credentials

Change **two lines** inside the script (see [What to Change in the Script](#️-what-to-change-in-the-script)):

```powershell
$SenderEmail    = "your_email@gmail.com"
$SenderPassword = "your_16_char_app_password"
```

### 🔹 Step 6 — Create your CSV

Create `details.csv` with your devices (see [How to Make the CSV File](#-how-to-make-the-csv-file)).

### 🔹 Step 7 — Run the script

Click inside the script editor and press **`F5`** ▶️

Or in PowerShell:

```powershell
C:\DeviceMonitor\DeviceMonitor.ps1
```

You should see:

```
2026-10-15 14:00:00 - ==== Device Monitor Started ====
2026-10-15 14:00:00 - Loaded 5 device(s) from CSV.
```

✅ **The script is now running.**

### 🔹 Step 8 — Stop the script

Press **`Ctrl + C`** in the console pane.

---

## 🔑 How to Generate Gmail App Password

⚠️ **Gmail blocks regular passwords for scripts.** You must use an **App Password** — a special 16-character password just for this script.

### 🔸 Step-by-Step (Line by Line)

**1️⃣ Go to your Google Account security page:**

```
👉 https://myaccount.google.com/security
```

**2️⃣ Under "How you sign in to Google", click:**

```
👉 2-Step Verification
```

**3️⃣ Turn ON 2-Step Verification:**

- Follow Google's prompts (phone verification, etc.)
- Once enabled, you'll see a green checkmark ✅

> ⚠️ **You cannot create App Passwords without 2-Step Verification.**

**4️⃣ Now go to the App Passwords page:**

```
👉 https://myaccount.google.com/apppasswords
```

**5️⃣ In the "App name" field, type:**

```
DeviceMonitor
```

**6️⃣ Click the blue "Create" button.**

**7️⃣ Google shows a yellow box with a 16-character password:**

```
abcd efgh ijkl mnop
```

**8️⃣ Copy that password and REMOVE ALL SPACES:**

```
abcdefghijklmnop
```

✅ This is your **App Password** — 16 characters, no spaces.

**9️⃣ Paste it into the script:**

```powershell
$SenderPassword = "abcdefghijklmnop"
```

### 🔒 Security Tips

- 🔐 **Never share** your App Password with anyone
- 🚫 **Never commit** it to GitHub
- 🔄 **Revoke** it anytime at https://myaccount.google.com/apppasswords
- 📸 **Never screenshot** a screen that shows your App Password

---

## ✏️ What to Change in the Script

Open `DeviceMonitor.ps1` in Notepad or PowerShell ISE.

### 🔸 Change #1 — Your Email Address

**Find this line:**

```powershell
$SenderEmail    = "your_senderemail@gmail.com"
```

**Replace with your real Gmail address:**

```powershell
$SenderEmail    = "anythingurmail@gmail.com"
```

### 🔸 Change #2 — Your Gmail App Password

**Find this line:**

```powershell
$SenderPassword = "YOUR_GMAIL_APP_PASSWORD"
```

**Replace with your 16-character App Password (no spaces):**

```powershell
$SenderPassword = "abcdefghijklmnop"
```

### 🔸 Change #3 — Your CSV Path (optional)

If your CSV is not in the same folder as the script, update:

```powershell
$CsvPath        = "C:\Users\HP\OneDrive\Desktop\details.csv"
```

Change to wherever your CSV lives:

```powershell
$CsvPath        = "C:\DeviceMonitor\details.csv"
```

### 🔸 Change #4 — Your Log Path (optional)

```powershell
$LogPath        = "C:\Users\HP\OneDrive\Desktop\DeviceMonitor.log"
```

Change to wherever you want the log file:

```powershell
$LogPath        = "C:\DeviceMonitor\DeviceMonitor.log"
```

### 🔸 Change #5 — Monitoring Settings (optional)

```powershell
$PingIntervalSeconds = 10     # 🔄 How often to ping (seconds)
$FailureThreshold    = 5      # 🔴 Fail count before marking DOWN
$IgnoreFirstFailures = 4      # 🚫 Ignore first N failures
```

> 💡 **Tip:** Leave these at defaults unless you know what you're doing.

### 🔸 Change #6 — SMTP Settings (usually no change needed)

```powershell
$SmtpServer     = "smtp.gmail.com"   # 📧 Gmail SMTP server
$SmtpPort       = 587                # 🔌 Standard TLS port
```

If port 587 is blocked by your network, try `465`:

```powershell
$SmtpPort       = 465
```

---

## 📊 How to Make the CSV File

The CSV file tells the script **which devices to monitor** and **who to email**.

### 🔸 Step 1 — Open Microsoft Excel

Launch **Excel** and create a new blank workbook. 📗

### 🔸 Step 2 — Enter the headers in Row 1

| A | B | C | D |
|---|---|---|---|
| `Sr. No.` | `Device Name` | `IP Address` | `Email Address` |

⚠️ **Match exactly** — including capital letters, spaces, and dots.

### 🔸 Step 3 — Add your devices (Row 2 onward)

| Sr. No. | Device Name | IP Address | Email Address |
|---------|-------------|------------|---------------|
| 1 | PC1 | 192.168.1.12 | admin@example.com |
| 2 | PC2 | 192.168.1.16 | admin@example.com |
| 3 | PC3 | 192.168.1.15 | admin@example.com |
| 4 | PC4 | 192.168.1.10 | admin@example.com |
| 5 | PC5 | 192.168.1.1 | admin@example.com |

### 🔸 Step 4 — Multiple emails for one device (optional)

To send alerts to **two or more people**, separate emails with a **semicolon** `;`:

| Sr. No. | Device Name | IP Address | Email Address |
|---------|-------------|------------|---------------|
| 1 | PC1 | 192.168.1.12 | admin@example.com;boss@example.com |

### 🔸 Step 5 — Save as CSV

1. Click **File → Save As**
2. Choose the folder (e.g., `C:\DeviceMonitor\`)
3. **File name:** `details.csv`
4. **Save as type:** `CSV UTF-8 (Comma delimited) (*.csv)` ✅
5. Click **Save**

> ⚠️ **Never** save as `.xlsx` — the script needs a real `.csv`.

### 🔸 Step 6 — Verify the CSV

In PowerShell:

```powershell
Import-Csv "C:\DeviceMonitor\details.csv" | Format-Table -AutoSize
```

Expected output:

```
Sr. No. Device Name IP Address    Email Address
------- ----------- ----------    -------------
1       PC1         192.168.1.12  admin@example.com
2       PC2         192.168.1.16  admin@example.com
```

✅ **If this works, your CSV is perfect.**

### 🔸 Step 7 — Reference Example CSV

Here's a full example you can copy into Notepad and save as `details.csv`:

```csv
Sr. No.,Device Name,IP Address,Email Address
1,PC1,192.168.1.12,admin@example.com
2,PC2,192.168.1.16,admin@example.com
3,PC3,192.168.1.15,admin@example.com
4,PC4,192.168.1.10,admin@example.com
5,PC5,192.168.1.1,admin@example.com
```

Change:
- 🖥️ `Device Name` → your real PC names
- 🌐 `IP Address` → your real LAN IPs
- 📧 `Email Address` → the person who should receive alerts

### 🔸 What to Put in Each Column

| 🏷️ Column | 📝 What to put | ✅ Example |
|-----------|----------------|-----------|
| `Sr. No.` | Serial number (1, 2, 3...) | `1` |
| `Device Name` | Friendly name of the device | `Lab-PC-01` |
| `IP Address` | IPv4 address you can ping | `192.168.1.12` |
| `Email Address` | Who receives the alert | `admin@example.com` |

> 💡 **Tip:** You can test with a public IP first — `8.8.8.8` (Google DNS) always responds to ping.

---

## ⚙️ How the Script Works

Here's the complete flow, step by step:

```
🔁 Every 10 seconds, for each device in details.csv:

  📡 Ping the device
  │
  ├── 🟢 SUCCESS (device responds)
  │     ├── Reset failure counter to 0
  │     ├── If device was DOWN:
  │     │     ├── Calculate total downtime
  │     │     ├── 📧 Send UP email
  │     │     └── Mark device as UP
  │     └── Continue
  │
  └── 🔴 FAILURE (device doesn't respond)
        ├── Increment failure counter
        ├── Log: "Fail #N"
        │
        └── If fail counter reaches 5 AND device is not already DOWN:
              ├── Mark device as DOWN
              ├── Record down-since time
              ├── 📧 Send DOWN email
              └── Continue monitoring
```

### 🔸 Key Behaviors

| 🎯 Scenario | 🔧 What Happens |
|-------------|-----------------|
| Device replies to ping | No email, silent success ✅ |
| 1–4 consecutive failures | ❌ Ignored (avoids false alarms) |
| 5th consecutive failure | 🔴 **DOWN email sent** |
| Device stays down | ⏸️ No duplicate emails |
| Device replies after being DOWN | 🟢 **UP email with downtime** |
| Device goes down again later | 🔴 **New DOWN email** |

### 🔸 Why Ignore First 4 Failures?

Network hiccups happen. A single dropped ping doesn't mean a device is down. By ignoring the first 4 failures, the script **only alerts on real outages** — not on momentary lag. 🎯

---

## 📧 Email Format

### 🔴 DOWN Email

**Subject:**
```
Device Down - PC1 - 192.168.1.12
```

**Body:**
```
Hello Team!

The following device has lost its connection:

Device Name: PC1
Device IP: 192.168.1.12
Down Time: 02:56:14 PM

Regards,
Device Monitor
```

### 🟢 UP Email

**Subject:**
```
Device UP - PC1 - 192.168.1.12
```

**Body:**
```
Hello Team!

The following device has successfully re-established its connection:

Device Name: PC1
Device IP: 192.168.1.12
Down Time (IST): 02:56:14 PM
Up Time (IST): 03:30:00 PM
Total Downtime: 0 hours, 33 minutes, 46 seconds

Regards,
Device Monitor
```

---

## 🖥️ Auto-Start at Windows Boot

So the script runs automatically every time your PC starts.

### 🔸 Step 1 — Open Task Scheduler

Press `Win + R` → type `taskschd.msc` → press `Enter`.

### 🔸 Step 2 — Create a new task

In the right pane, click **Create Task…** (not Basic Task).

### 🔸 Step 3 — General tab

| Setting | Value |
|---------|-------|
| Name | `DeviceMonitor` |
| Description | `Pings devices and sends email alerts` |
| Run whether user is logged on or not | ✅ Check |
| Run with highest privileges | ✅ Check |
| Configure for | Windows 10 / Windows 11 |

### 🔸 Step 4 — Triggers tab

Click **New…**

| Setting | Value |
|---------|-------|
| Begin the task | **At startup** |
| Enabled | ✅ Check |

Click **OK**.

### 🔸 Step 5 — Actions tab

Click **New…**

| Setting | Value |
|---------|-------|
| Action | Start a program |
| Program/script | `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe` |
| Add arguments | `-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\DeviceMonitor\DeviceMonitor.ps1"` |
| Start in | `C:\DeviceMonitor` |

Click **OK**.

### 🔸 Step 6 — Conditions tab

- ❌ **Uncheck** "Start the task only if the computer is on AC power"
- ✅ Check "Wake the computer to run this task" (optional)

### 🔸 Step 7 — Settings tab

- ✅ Allow task to be run on demand
- ✅ If the task fails, restart every: `1 minute`, up to `3 times`
- ❌ Uncheck "Stop the task if it runs longer than…"

### 🔸 Step 8 — Save

Click **OK**. Enter your **Windows password** when prompted.

### 🔸 Step 9 — Test it

1. Right-click the `DeviceMonitor` task → **Run**
2. Wait 10 seconds → click **Refresh**
3. Status should show **Running** ✅

### 🔸 Step 10 — Verify on reboot

Restart your PC. After login, wait 30 seconds and check:

```powershell
Get-Process powershell
```

You should see a `powershell` process running (it's the monitor). ✅

---

## 🐛 Troubleshooting

| ❌ Problem | 🔍 Cause | ✅ Fix |
|-----------|----------|--------|
| `running scripts is disabled` | Execution policy | Run `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned` |
| `CSV file not found` | Wrong path | Check `$CsvPath` in the script |
| `Loaded 0 device(s)` | CSV header mismatch | Header must be exactly `Sr. No.,Device Name,IP Address,Email Address` |
| `Skipping row with missing IP or Email` | Wrong column names or extra spaces | Recreate CSV in Notepad, save as UTF-8 |
| `5.7.8 Username and Password not accepted` | Wrong App Password | Regenerate at https://myaccount.google.com/apppasswords |
| `net_io_connectionclosed` | Gmail throttling or port blocked | Try `$SmtpPort = 465`, or reduce email rate |
| `Invalid character in mail header ';'` | Old script version | Update to the latest script (supports multiple recipients) |
| Emails in Spam | New sender | Mark as "Not Spam" once; add sender to contacts |
| Emails never arrive | Recipient's company filter | Ask recipient's IT to whitelist your Gmail |
| All devices show DOWN immediately | Firewall blocks ping | On each target device, run: `New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow` |

---

## 🔐 Security Best Practices

- 🔒 **Never commit your real App Password** to GitHub
- 🔄 **Rotate** App Passwords periodically
- 🚫 **Don't share** the script with the password baked in
- 📁 **Keep `config.json` local** if you use one
- 📸 **Don't screenshot** your password

---

## 📜 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

You are free to:
- ✅ Use commercially
- ✅ Modify
- ✅ Distribute
- ✅ Sublicense

Just include the original copyright notice.

---

## 🌟 Star This Repo

If this script helped you, please give it a ⭐ on GitHub!

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first.

---

## 📬 Contact

Created with ❤️ by **[@sunsarafaizan88](https://github.com/sunsarafaizan88)**

---

<p align="center">
  <b>🎯 Monitor Smarter, Not Harder 🚀</b>
</p>
```

---

## ✅ How to Save This as `README.md`

### 1️⃣ Copy the entire block above

Click on the code block, press **Ctrl + A** (select all inside), then **Ctrl + C**.

### 2️⃣ Open Notepad

Press **Win + R** → type `notepad` → Enter.

### 3️⃣ Paste it

Press **Ctrl + V**.

### 4️⃣ Save as `README.md`

- **File → Save As**
- Navigate to: `C:\Users\HP\OneDrive\Desktop\DeviceMonitor`
- **File name:** `README.md`
- **Save as type:** `All Files (*.*)`  ← ⚠️ **Very important**
- **Encoding:** `UTF-8`
- Click **Save**

### 5️⃣ Verify it saved correctly

Open PowerShell:

```powershell
Get-Content "C:\Users\HP\OneDrive\Desktop\DeviceMonitor\README.md" | Select-Object -First 5
```

**Expected output:**

```
# 🖥️ Device Monitor

> 📡 A PowerShell script that monitors network devices via ping and sends email alerts when a device goes **DOWN** 🔴 or comes back **UP** 🟢.
```

✅ If you see emojis — the encoding is correct.

### 6️⃣ Push to GitHub

```powershell
cd "C:\Users\HP\OneDrive\Desktop\DeviceMonitor"
git add README.md
git commit -m "Update: complete README with emojis and full setup guide"
git push
```

---

## 🧩 Notes About the File

| Item | Info |
|------|------|
| **Filename** | `README.md` (must be exactly this name) |
| **Location** | Same folder as your `.ps1` and `.csv` files |
| **Format** | Markdown (`.md`) — GitHub renders it automatically |
| **Encoding** | UTF-8 (needed for the emojis to display correctly) |
| **Size** | ~15 KB — well within GitHub limits |

---

## 🎯 What You'll See on GitHub

After pushing, your repo page will render:

- 🖥️ **Title** with emoji
- 📊 **Badges** (PowerShell, Platform, License)
- 📖 **Clickable table of contents**
- ✨ **Features** with emoji bullets
- 🚀 **Quick Start** with copy-paste PowerShell commands
- 🔑 **Complete App Password tutorial** with numbered steps
- ✏️ **All script changes** in 6 clearly labeled sections
- 📊 **CSV creation guide** with Excel steps and examples
- ⚙️ **Flow diagram** showing how the script works
- 📧 **Sample DOWN and UP emails**
- 🖥️ **Task Scheduler setup** in table format
- 🐛 **Troubleshooting** with 10+ common issues
- 🔐 **Security best practices**
- 📜 **MIT License** section
- ⭐ **Star request** and contact info

**Complete, professional, ready to share.** 🎉

---

**TL;DR:** Copy the big markdown block → save it as `README.md` in your `DeviceMonitor` folder → `git add README.md` → `git commit` → `git push`. Done. ✅
