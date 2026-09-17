# Linux Administration & Security Toolkit

A modular collection of production-ready Bash scripts for system administration, automated monitoring, server security, and routine maintenance.

## Project Structure

- **`security/`**: Scripts for intrusion prevention, file integrity monitoring (FIM), and process auditing.
- **`monitoring/`**: System health monitors, self-healing services, and hardware resource watchdogs.
- **`automation/`**: Automated system reporting, log rotation/archival, and price monitoring.
- **`network_backup/`**: Automated multi-directory backup managers and network latency checkers.

## Prerequisites

- Bash 4.0+
- Standard Linux utilities: `systemd`, `iptables`, `curl`, `jq`, `bc`

## Usage

Grant execution permissions before running any script:
```bash
chmod +x **/*.sh
