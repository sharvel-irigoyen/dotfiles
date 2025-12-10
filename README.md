# 🚀 Dotfiles & Aliases

> **One config to rule them all.**
> A cross-platform configuration suite for **Windows**, **macOS**, and **Linux** designed to boost productivity with standardized aliases, robust error handling, and a beautiful CLI experience.

---

## 🌟 Features

- **🎨 UX/UI Focused**: All commands provide visual feedback with colors and emojis (`✅`, `❌`, `ℹ️`, `⚠️`).
- **🛡️ Robust Error Handling**: "Sad paths" are covered—no more silent failures.
- **⚡ Cross-Platform**: Same commands work on PowerShell, Bash, and Zsh.
- **🔧 Developer Ready**: Pre-built shortcuts for **Git**, **Laravel**, **Python**, **Docker**, and **Flutter**.

---

## 📦 Installation

### 🪟 Windows (PowerShell)

1.  **Open PowerShell** as Administrator (for best results, though not strictly required).
2.  Navigate to this folder:
    ```powershell
    cd ~\dotfiles
    ```
3.  Run the setup script:
    ```powershell
    .\setup.ps1
    ```
4.  **Restart PowerShell** or run `. $PROFILE` to load the changes.

> **Note:** If you see a script execution policy error, run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`.

### 🍎 macOS (Zsh)

1.  Open your **Terminal**.
2.  Navigate to this folder:
    ```zsh
    cd ~/dotfiles
    ```
3.  Make the install script executable and run it:
    ```zsh
    chmod +x install.sh
    ./install.sh
    ```
4.  **Restart Terminal** or run `source ~/.zshrc`.

### 🐧 Linux (Bash)

1.  Open your **Terminal**.
2.  Navigate to this folder:
    ```bash
    cd ~/dotfiles
    ```
3.  Run the install script:
    ```bash
    chmod +x install.sh
    ./install.sh
    ```
4.  **Restart Terminal** or run `source ~/.bashrc`.

---

## 🚀 Key Commands

### 🐙 Git
| Command | Description |
| :--- | :--- |
| `pull` | Pulls from `origin master` with visuals |
| `push` | Pushes to `origin master` with visuals |
| `commit "msg"` | Stages all files and commits with the message |
| `branch name` | Switches to the specified branch |
| `cbranch name` | **C**reates and switches to a new branch |
| `dbranch name` | **D**eletes the specified branch |
| `gst` | `git status` |
| `gl` | `git log` |

### 🐘 Laravel / PHP
| Command | Description |
| :--- | :--- |
| `serve` | Runs `php artisan serve` on port 8000 |
| `migrate` | Runs migrations |
| `fresh` | ⚠️ Wipes DB and runs `migrate:fresh` |
| `opt` | Clears all caches (`optimize:clear`) |
| `lrv "name"` | Creates a new Laravel project and links storage |
| `mm "Name"` | Makes a Model + Migration |

### 🐍 Python
| Command | Description |
| :--- | :--- |
| `pyinit` | Checks Python3, creates `venv` if missing, and advises on activation |
| `uvistart` | Starts Uvicorn (Use `-d` for background) |
| `uvistop` | Stops Uvicorn on a specific port |

### 🐳 Docker
| Command | Description |
| :--- | :--- |
| `dockup` | `docker-compose up -d --build` (Verified start) |
| `dock` | `docker-compose run php` |

### 📱 Flutter
| Command | Description |
| :--- | :--- |
| `pubget` | `flutter pub get` |
| `frun` | `flutter run -d chrome` |

### 🛠️ System
| Command | Description |
| :--- | :--- |
| `config` | Opens your shell config file in VS Code |
| `r` | Reloads your shell configuration instantly |
| `shserve` | SSH into the main server |

---

## 📂 Structure

- `common/`: Core aliases shared by all OSs.
- `windows/`: PowerShell profile logic.
- `mac/`: Zsh configuration.
- `bash/`: Ubuntu/Debian configuration.
- `install.sh`: Installer for Unix-like systems.
- `setup.ps1`: Installer for Windows.

---
