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




