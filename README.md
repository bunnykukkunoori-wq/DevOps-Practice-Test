# 🛡️ Automated Backup System — Bash Scripting Project

This project is a fully automated backup tool written in Bash. It safely backs up important files/folders, verifies backup integrity, and deletes older backups based on a smart rotation policy.

---

##  Features

| Feature | Description |
|--------|-------------|
|  Automated compressed backups | Archives files into `.tar.gz` format |
|  Configurable backup settings | Uses `backup.config` |
|  Exclusion rules | Skip `.git`, `node_modules`, etc. |
|  Checksum verification | Ensures backup integrity using SHA256 |
|  Backup rotation policy | Deletes old backups automatically |
|  Dry run support | Shows actions without performing them |
|  Logging system | Every action is saved in `backup.log` |
|  Lock file support | Prevents multiple instances |
|  Works on Linux, WSL, Git Bash | Cross-platform compatible |

---

##  Project Structure
automated-backup-system/
│
├── backup.sh                 # Main backup script
├── config/                   
│   └── backup.conf           # Configuration file (source, destination paths)
│
├── logs/
│   └── backup.log            # Log file for backup status
│
├── backups/                  # Folder to store backup archives (if local backup)
│   └── (auto-generated .tar.gz files)
│
├── README.md                 # Documentation
│
└── .gitignore                # Ignore unnecessary files like logs and backups



