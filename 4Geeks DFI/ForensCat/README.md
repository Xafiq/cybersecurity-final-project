# 🐾 Forenscat: Forensic Evidence Collection Tool

Forenscat is a 🐧 Linux forensic evidence collection tool. It gathers logs, configuration files, hidden files, and network activity data into a structured directory for analysis. The tool also provides options to archive the evidence and clean up its traces.

---

## 🚀 Installation
Install and run the tool with a single command:

```bash
curl -sSL https://raw.githubusercontent.com/xafiq/forenscat/main/forenscat.sh | sudo bash
```

This will:
1. 🛠️ Install the tool as `forenscat`.
2. ✅ Make it executable and ready to run from the terminal.

---

## 📖 Usage
To start the tool, run:
```bash
forenscat
```

### 🎯 Features
1. **🧰 Tool Check**:
   Verifies that required tools (`tcpdump`, `iftop`, `rkhunter`, etc.) are installed.
2. **📂 Evidence Collection**:
   Gathers logs, configuration files, and network data into a structured directory.
3. **🗜️ Archive Evidence**:
   Creates a `.tar.gz` archive and a 🔒 SHA256 hash for easy export and verification.
4. **🧹 Clean Up**:
   Removes its traces, leaving only the evidence directory for analysis.

---

## 📜 License
This project is open-source and available under the MIT License.

---

✨ Made with ❤️ by Xafiq 🐾
