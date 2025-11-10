# Backup System
Basic backup automation script.
# Smart Backup Tool (Bash Project)

##  Project Overview

This project is a **smart backup automation script** written entirely in **Bash**.
It allows you to:

* Automatically create compressed `.tar.gz` backups of any folder
* Verify integrity using **SHA256 checksum**
* Manage and delete old backups intelligently
* Configure everything through a simple config file
* Test behavior safely with **dry run mode**

Think of it as a smarter “copy and paste” that also cleans up after itself!

---

##  Features

 Create timestamped compressed backups
 Verify backup integrity (checksum validation)
 Automatically delete old backups based on retention rules
 Configurable backup destination and exclusions
 Lock mechanism to prevent multiple simultaneous runs
 Dry-run mode (safe simulation)
 Simple configuration via `backup.config`

---

## Project Structure

```
backup-system/
├── backup.sh              ← Main Bash script
├── backup.config          ← Configuration file
├── backups/               ← Where backups are stored
└── README.md              ← Documentation (this file)
```

---

## How to Use

### Installation

Clone or copy this project into your local machine:

```bash
git clone https://github.com/YourUsername/backup-system.git
cd backup-system
chmod +x backup.sh
```

### Configure Settings

Edit `backup.config` to suit your environment:

```bash
BACKUP_DESTINATION=/c/Users/bunny\ kukkunoori/Bash-practice/backups
EXCLUDE_PATTERNS=".git,node_modules,.cache"
DAILY_KEEP=7
WEEKLY_KEEP=4
MONTHLY_KEEP=3
CHECKSUM_CMD=sha256sum
```

### Dry Run (Test Mode)

Simulate what the script will do, without actually creating files:

```bash
./backup.sh --dry-run /path/to/source_folder
```

Output example:

```
[INFO] Dry run mode enabled
[INFO] Would backup folder: /home/user/my_docs
[INFO] Would save backup to: /home/user/backups
[INFO] Would skip patterns: .git,node_modules,.cache
```

###  Create a Real Backup

```bash
./backup.sh /path/to/source_folder
```

Output example:

```
[INFO] Creating backup for: /home/user/my_docs
[SUCCESS] Backup created: backup-2025-11-03-1430.tar.gz
[SUCCESS] Checksum verified successfully
[DONE] Backup process completed successfully
```

###  List Existing Backups

```bash
ls -lh backups/
```

###  Restore (optional — if added later)

```bash
./backup.sh --restore backup-2025-11-03-1430.tar.gz --to /home/user/restore_folder
```

---

##  How It Works

###  Backup Creation

* The script uses the `tar` command to compress files into `.tar.gz`.
* Excluded patterns (like `.git` or `node_modules`) are skipped.
* Each backup is named using date and time:

  ```
  backup-2025-11-03-1430.tar.gz
  ```

###  Checksum Verification

After creation, the script generates a SHA256 checksum:

```
sha256sum backup-2025-11-03-1430.tar.gz > backup-2025-11-03-1430.tar.gz.sha256
```

Then verifies it to ensure data integrity.

###  Backup Retention Policy

Old backups are automatically deleted:

* Keep **7 daily**, **4 weekly**, and **3 monthly** backups.
* The script lists files by date and removes older ones beyond the retention limits.

###  Lock Mechanism

Prevents accidental double runs using:

```
/tmp/backup.lock
```

---

##  Design Decisions

| Feature          | Reason                                          |
| ---------------- | ----------------------------------------------- |
| `.tar.gz` format | Universally supported and efficient             |
| SHA256 checksum  | Strong integrity verification                   |
| Config file      | Easier customization without editing the script |
| Dry-run mode     | Safe testing before running backups             |
| Lock file        | Avoids corrupted or overlapping backups         |

---

##  Testing Examples

1. **Test Backup Creation**

   ```bash
   mkdir -p test_data
   echo "File1" > test_data/a.txt
   ./backup.sh ./test_data
   ```

2. **Simulate Multiple Backups**
   Run script several times with different timestamps to test auto-deletion.

3. **Checksum Test**
   Modify a `.tar.gz` file and re-run the checksum verification — it should fail.

4. **Error Handling Tests**

   ```bash
   ./backup.sh /folder/does/not/exist
   ```

   Expected:

   ```
   Error: Source folder not found (/folder/does/not/exist)
   ```

---

## Known Limitations

* Incremental backups (only changed files) are not implemented yet.
* Restore feature (`--restore`) optional.
* Email notifications not yet configured (can be simulated).
* Works best on Linux or Git Bash on Windows (tested on both).

---

##  Future Improvements

* Add automatic email notifications.
* Implement incremental backups using `rsync`.
* Store logs in `backup.log` with timestamped entries.
* Add compression-level configuration.

---

##  Example Log Output

```
[2025-11-03 14:30:15] INFO: Starting backup of /home/user/documents
[2025-11-03 14:30:45] SUCCESS: Backup created: backup-2025-11-03-1430.tar.gz
[2025-11-03 14:30:46] INFO: Checksum verified successfully
[2025-11-03 14:30:50] INFO: Deleted old backup: backup-2025-10-05-0900.tar.gz
```

---

##  Author

**bunny kukkunoori**
DevOps & Bash Automation Enthusiast 
GitHub: [https://github.com/bunnykukkunoori](https://github.com/bunnykukkunoori)

---

##  Tip

> Start small, test often, and commit to GitHub frequently.
> Simple, working automation is better than complex, broken code.
