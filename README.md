### 📄 README.md Content


# Omni-LC (Location & Camera OSINT Tool) 🛰️📸

**Omni-LC** is a specialized OSINT (Open-Source Intelligence) and security research tool designed to demonstrate automated geolocation tracking and synchronized camera image capture. It features a robust backend for data management and a modern, encrypted dashboard for real-time monitoring.

---

## 🚀 Features
* **Precision Geolocation:** Captures real-time GPS coordinates (Latitude/Longitude).
* **Dual-Camera Capture:** Automated front and rear camera image acquisition.
* **Secure Dashboard:** A centralized PHP-based dashboard to view logs and images.
* **Stealth Execution:** Optimized for minimal footprint during data synchronization.
* **Cloudflare Integration:** Built-in support for secure tunneling using `cloudflared`.

---

## 🛠️ Project Structure
* `index.html`: The core landing page (Verification system).
* `.engine.py`: The injection engine for system updates.
* `core/`: Contains the logic for location (`locate.php`) and image uploads (`upload.php`).
* `logs/`: Secure storage for captured data and images.
* `run.sh`: Automated script to start the PHP server and Cloudflare tunnel.

---


## 📥 Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ANK-369/Omni-LC.git
   cd Omni-LC
   ```

2. **Set Permissions:**
   ```bash
   chmod +x run.sh
   ```

3. **Launch the System:**
   ```bash
   ./run.sh
   ```
   Or
   ```
   bash run.sh
   ```

---

## 🛡️ Disclaimer
**For Educational Purposes Only.** This tool was developed by **ANK-369** to explore cybersecurity concepts, digital forensics, and OSINT methodologies. Unauthorized use of this tool on devices without explicit consent is illegal and unethical. The developer is not responsible for any misuse.

---

## 👨‍💻 About the Developer
**Andualem Koriya (አንኬ) (ANK-369)** *Cybersecurity Student | OSINT Enthusiast | Ethiopian Air Force* Passionate about building intelligent security systems and defensive cyber-tools.
```
