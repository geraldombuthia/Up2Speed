# Up2speed

Provisioning script to rapidly setup a fresh Ubuntu environment for embedded systems and IoT development. It automates the bulk of installation of various tools I require in my workflow.

### What it does
* **System Updates:** Refreshes package lists and ensures core dependencies are current.
* **Toolchain Configuration:** Sets up the GNU Arm Embedded Toolchain and build systems for firmware compilation.
* **Hardware Access:** Configures user permissions for dialout and USB devices to allow hardware communication without root access.
* **Environment Isolation:** Creates a dedicated Python virtual environment for Mbed tools to prevent system Python conflicts and storage issues.
* **Docker Provisioning:** Removes legacy Docker versions and installs the official Docker Engine with rootless execution permissions.
* **Shell Setup:** Configures Git global settings and maps persistent aliases to the bash configuration.

### Tools downloaded
* **Compilers & Build:** `gcc-arm-none-eabi`, `gdb-multiarch`, `binutils-arm-none-eabi`, `cmake`, `ninja-build`, `build-essential`.
* **Hardware & Flash:** `stlink-tools`, `dfu-util`, `picocom`.
* **Containerization:** `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`.
* **Python & Shell:** `python3-venv`, `mbed-tools`, `zsh`, `git`.

### Requirements
* **OS:** Ubuntu 22.04 or 24.04 (LTS).
* **Permissions:** Sudo privileges for package and group management.
* **Hardware:** Active internet connection for package retrieval.
* **Post-Installation:** A full system reboot is required to initialize group permissions.

---
**Author:** Gerald Mbuthia
**Target:** Embedded Systems Development and Systems Engineering
