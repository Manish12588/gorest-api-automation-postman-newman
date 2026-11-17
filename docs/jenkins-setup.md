# Jenkins Setup

This guide installs Jenkins locally from the WAR file, creates the admin user, and installs the plugins needed to run the GoRest Newman collections. 

1. [Prerequisites](#1-prerequisites)
2. [Download and start Jenkins](#2-download-and-start-jenkins)
3. [Unlock Jenkins and create the admin user](#3-unlock-jenkins-and-create-the-admin-user)
4. [Update and install plugins](#4-update-and-install-plugins)
5. [Troubleshooting](#5-troubleshooting)

---

## 1. Prerequisites

| Tool | Why | Check |
|------|-----|-------|
| Java 21 (JDK) | Jenkins is a Java application | `java -version` |
| Git | Jenkins clones the repo | `git --version` |
| Node.js and Newman | The job runs Newman | `newman --version` |

Install Newman if missing:
```bash
npm install -g newman newman-reporter-htmlextra
```

---

## 2. Download and start Jenkins

1. Go to https://www.jenkins.io/download/
2. Under **LTS**, download **Generic Java package (.war)**. LTS is the stable release line, which is what you want for a local setup.
3. Put `jenkins.war` in a folder, e.g. `~/jenkins/`.
4. Start Jenkins from that folder:
   ```bash
   cd ~/jenkins
   java -jar jenkins.war --httpPort=8080
   ```
   If port 8080 is already in use, pick another one, e.g. `--httpPort=9090`.
5. Wait until the console prints a line saying that Jenkins is fully up and running, then open http://localhost:8080 (use your port).

Notes:
- Jenkins keeps its data (jobs, plugins, credentials) in `~/.jenkins` by default. To use another folder, start it with `JENKINS_HOME=/path/to/folder java -jar jenkins.war`.
- Jenkins stops when you close the terminal or press `Ctrl+C`. Start it again with the same command and your jobs are still there.
- Start Jenkins from a terminal where `newman` and `node` work. The Jenkins process inherits that terminal's `PATH`, so the job's shell step can find them.

---

## 3. Unlock Jenkins and create the admin user

1. On first start, Jenkins shows **Unlock Jenkins** and asks for the initial admin password.
2. The password is printed in the terminal where you started Jenkins, between rows of asterisks. It is also stored in:
   ```bash
   cat ~/.jenkins/secrets/initialAdminPassword
   ```
3. Paste it and click **Continue**.
4. Choose **Install suggested plugins** and wait for the installation to finish. This includes Git and Credentials Binding, which the job needs.
5. On **Create First Admin User**, enter a username, password, full name and email, then click **Save and Continue**.
6. Keep the default Jenkins URL (e.g. `http://localhost:8080/`) and click **Save and Finish**, then **Start using Jenkins**.

Remember the username and password you created. You use them for every later login.

---

## 4. Update and install plugins

1. **Manage Jenkins → Plugins → Updates**. Tick all available updates and click **Update**. Tick **Restart Jenkins when installation is complete and no jobs are running** if offered.
2. **Manage Jenkins → Plugins → Available plugins**. Search for and install:
   - **HTML Publisher**: publishes the Newman HTML report on the build page
   - **Git** and **Credentials Binding**: already installed by the suggested plugins; just check that they appear under *Installed plugins*
3. Restart Jenkins if asked, then log in again.

---

## 5. Troubleshooting

| Symptom | Cause and fix |
|---------|---------------|
| `Address already in use` on start | Another process uses the port. Start with a different port, e.g. `--httpPort=9090`. |
| `newman: command not found` in a job | Jenkins was started from a terminal without Newman on its `PATH`. Stop Jenkins, run `newman --version` in that terminal, then restart Jenkins from the same terminal. |
| Plugin install fails | Check your internet connection and try again from **Manage Jenkins → Plugins**. |
| Forgot the initial admin password | Read it again with `cat ~/.jenkins/secrets/initialAdminPassword`. This file exists only until the setup wizard is completed. |