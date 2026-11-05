# Command Execution Reference — App Engine: Qwik Start - Go (GSP070)

All commands documented below were executed inside the **Google Cloud Shell** terminal environment during lab completion.

---

## 1. Verify Active Account and Project

### Command
```bash
gcloud auth list
gcloud config list project
```

- **What it does:** Lists credentialed user accounts and verifies the default Google Cloud Project ID configured in the CLI session.
- **Why it is required:** Confirms CLI commands target the temporary lab project context rather than an unauthenticated or personal account.
- **Expected Output:**
  ```text
  Credentialed Accounts
  ACTIVE: *
  ACCOUNT: student-xx-xxxxxxxxxxxx@qwiklabs.net

  [core]
  project = qwiklabs-gcp-01-8bc83ebbbaef
  ```

---

## 2. Configure Default Compute Region

### Command
```bash
gcloud config set compute/region us-west1
```

> [!NOTE]
> Replace `us-west1` with the region provided in your lab instructions panel if different.

- **What it does:** Sets the default geographical compute region in Cloud Shell.
- **Why it is required:** Sets the regional target for App Engine provisioning and minimizes interactive CLI prompts.
- **Expected Output:**
  ```text
  Updated property [compute/region].
  ```

---

## 3. Clone the Go Sample Application Repository

### Command
```bash
git clone https://github.com/GoogleCloudPlatform/golang-samples.git
```

- **What it does:** Clones Google Cloud's official Go documentation samples repository to the Cloud Shell persistent disk.
- **Why it is required:** Retrieves the Hello World sample code designed for Google App Engine standard environment.
- **Expected Output:**
  ```text
  Cloning into 'golang-samples'...
  remote: Enumerating objects: 46521, done.
  remote: Compressing objects: 100% (426/426), done.
  remote: Total 46521 (delta 1206), reused 890 (delta 883), pack-reused 45212 (from 2)
  Receiving objects: 100% (46521/46521), 107.76 MiB | 19.95 MiB/s, done.
  Resolving deltas: 100% (31714/31714), done.
  ```

---

## 4. Navigate to the Hello World Directory

### Command
```bash
cd golang-samples/appengine/go11x/helloworld
```

- **What it does:** Navigates into the Go 1.1x Hello World application directory containing `main.go` and `app.yaml`.
- **Why it is required:** `gcloud app deploy` requires execution from the root directory where `app.yaml` is located.
- **Expected Output:** Working directory prompt shifts to `~/golang-samples/appengine/go11x/helloworld`.

---

## 5. Deploy Application to Google App Engine

### Command
```bash
gcloud app deploy
```

- **What it does:** Packages Go source files and `app.yaml`, uploads the archive to a Cloud Storage staging bucket, triggers Cloud Build to compile and build the container image, creates an immutable version in the `default` App Engine service, and routes 100% of traffic to it.
- **Interactive Prompts during Deployment:**
  - If App Engine is not yet initialized, you are prompted to select a region.
  - Confirmation prompt:
    ```text
    Do you want to continue (Y/n)?
    ```
    Type `Y` and press `Enter`.
- **Expected Output:**
  ```text
  Services to deploy:
  descriptor:      [/home/student_.../golang-samples/appengine/go11x/helloworld/app.yaml]
  source:          [/home/student_.../golang-samples/appengine/go11x/helloworld]
  target project:  [qwiklabs-gcp-01-8bc83ebbbaef]
  target service:  [default]
  target version:  [20261103t172239]
  target url:      [https://qwiklabs-gcp-01-8bc83ebbbaef.uw.r.appspot.com]
  target service account: [qwiklabs-gcp-01-8bc83ebbbaef@appspot.gserviceaccount.com]

  Do you want to continue (Y/n)?  y

  Beginning deployment of service [default]...
  Uploading 6 files to Google Cloud Storage
  File upload done.
  Waiting for operation [...] to complete...done.
  Setting traffic split for service [default]...done.
  Deployed service [default] to [https://qwiklabs-gcp-01-8bc83ebbbaef.uw.r.appspot.com]
  ```

---

## 6. Open Application in Web Browser

### Command
```bash
gcloud app browse
```

- **What it does:** Outputs the generated public URL and opens the application in the web browser.
- **Why it is required:** Validates that the deployed application is live, accessible via HTTPS, and serving HTTP responses.
- **Expected Output:**
  ```text
  Did not detect your browser. Go to this link to view your app:
  https://qwiklabs-gcp-01-8bc83ebbbaef.uw.r.appspot.com
  ```
  Navigating to the URL displays:
  ```text
  Hello, World!
  ```

---

## 7. Stream Real-Time Application Logs (Optional Verification)

### Command
```bash
gcloud app logs tail -s default
```

- **What it does:** Tails HTTP request logs and runtime stdout/stderr log entries in real-time.
- **Why it is required:** Provides observability into application performance, response codes (`200 OK`), and incoming user traffic.
- **Expected Output:** Continuous stream of HTTP request records. Exit with `Ctrl + C`.

