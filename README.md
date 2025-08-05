# Suricata Log Management & Automation

This repository documents how I set up log rotation, alert filtering, and automation for Suricata IDS on a Linux production server. The goal was to ensure logs remain manageable, security-relevant alerts are filtered by severity, and the entire process is automated daily without human intervention.

---

## Tools & Skills

- **Linux CLI** (via SSH Jumpserver)
- **Suricata IDS**
- **jq** – JSON filtering and parsing
- **cron** – Scheduled automation
- **logrotate** – Log size and age-based rotation
- **bash scripting**
- **Git & GitHub**

---

## Project Structure

```
suricata-log-management-and-automation/
├── alerts_by_severity/
│   ├── severity_1_alerts.json        # Suricata alerts with severity 1
│   ├── severity_2_alerts.json        # Suricata alerts with severity 2
│   └── update_severity_logs.sh       # Bash script to regenerate both files
│   └── cron_output.log               # Keeps log of cron actions
├── logrotate/
│   └── suricata-evejson              # Logrotate config for eve.json            
|   └── suricata-faststats            # Logrotate config for fast.log and stats.log
├── crontab.txt                       # Crontab entry for daily automation
├── README.md                         # Project documentation (this file)
```

---

## Tasks Completed

### 1. Log Rotation Setup (`logrotate`)

- Configured rotation for:
  - `/var/log/suricata/eve.json`
  - `/var/log/suricata/fast.log`
  - `/var/log/suricata/stats.log`
- Settings:
  - Rotate **daily** or when size exceeds **100MB**
  - Keep **7 compressed backups**
  - Use `copytruncate` to avoid breaking Suricata

**Tested with:**

```bash
logrotate -d /etc/logrotate.d/suricata
logrotate -f /etc/logrotate.d/suricata-faststats
```

---

### 2. Extract Alerts by Severity (`jq`)

Filtered Suricata alerts by severity from `eve.json`:

```bash
jq 'select(.event_type == "alert" and .alert.severity == 1)' /var/log/suricata/eve.json > alerts_by_severity/severity_1_alerts.json

jq 'select(.event_type == "alert" and .alert.severity == 2)' /var/log/suricata/eve.json > alerts_by_severity/severity_2_alerts.json
```

- These logs are now organized, filtered, and ready for triage or dashboarding.

---

### 3. Daily Automation with `cron`

Scheduled the filtering script to run every day:

**Crontab entry (`crontab.txt`):**
```cron
0 2 * * * /var/log/suricata/alerts_by_severity/update_severity_logs.sh >> /var/log/suricata/alerts_by_severity/cron_output.log 2>&1
```

- Runs daily at **2:00 AM**
- Automatically regenerates both severity-based JSON files
- Logs output and errors to `cron_output.log`

---

## Sample `jq` Command

```bash
jq 'select(.event_type == "alert") | {
  timestamp,
  src_ip,
  dest_ip,
  severity: .alert.severity,
  signature: .alert.signature
}' /var/log/suricata/eve.json | head -n 10
```

---

## Notes

- All work was performed on a **real production server** via a **Jumpserver**.
- Focused entirely on **shell-native tooling** — no Python, no pipelines.
- Example of applying **sysadmin**, **security**, and **automation** practices effectively.
- Great for building operational awareness and cloud security posture monitoring.
- All sample logs provided in this repository have been sanitized to remove sensitive IP addresses, hostnames, ports, and internal identifiers. These examples are purely illustrative and safe for public sharing.

## Author

**[@kimdobinn](https://github.com/kimdobinn)**
