# Command Execution Reference — App Engine: Qwik Start - PHP (GSP069)

All commands documented below were executed inside the **Google Cloud Shell** terminal environment during lab completion.

---

## 1. Verify Active Account and Project

### Command
```bash
gcloud auth list
gcloud config list project
```

- **What it does:** Lists the currently active authenticated user account and prints the default Google Cloud Project ID configured in the CLI context.
- **Why it is required:** Ensures the CLI commands are issued against the correct temporary Google Cloud Skills Boost lab project and not a personal account.
- **Expected Output:**
  ```text
  Credentialed Accounts
  ACTIVE: *
  ACCOUNT: student-xx-xxxxxxxxxxxx@qwiklabs.net

  [core]
  project = qwiklabs-gcp-xx-xxxxxxxxxxxx
  ```

---

## 2. Configure Default Compute Region

### Command
```bash
gcloud config set compute/region REGION
```

> [!NOTE]
> Replace `REGION` with the region specified in your lab instructions panel (e.g., `europe-west2`, `us-central1`, or `us-east1`).

- **What it does:** Sets the default geographical compute region in the Cloud Shell CLI environment.
- **Why it is required:** Prevents interactive CLI prompts by establishing a consistent geographical context for regional resource creation.
- **Expected Output:**
  ```text
  Updated property [compute/region].
  ```

---

## 3. Clone the PHP Sample Application Repository

### Command
```bash
git clone https://github.com/GoogleCloudPlatform/php-docs-samples.git
```

- **What it does:** Clones Google Cloud's official PHP documentation sample repository from GitHub to the Cloud Shell home directory.
- **Why it is required:** Obtains the pre-built reference code for the App Engine standard environment Hello World tutorial, including `index.php` and `app.yaml`.
- **Expected Output:**
  ```text
  Cloning into 'php-docs-samples'...
  remote: Enumerating objects: ...
  remote: Compressing objects: 100% ...
  Resolving deltas: 100% ... done.
  ```

---

## 4. Navigate to the Hello World Application Directory

### Command
```bash
cd php-docs-samples/appengine/standard/helloworld
```

- **What it does:** Changes the working directory to the target Hello World application folder.
- **Why it is required:** The `gcloud app deploy` command must be run from the root directory where the application's `app.yaml` file resides.
- **Expected Output:** Working directory prompt shifts to `~/php-docs-samples/appengine/standard/helloworld`.

---

## 5. Configure Modern PHP Runtime in `app.yaml`

### Command
```bash
sed -i 's/^runtime: php.*/runtime: php83/' app.yaml
```

- **What it does:** Uses stream editor (`sed`) to perform an in-place find-and-replace substitution on `app.yaml`, setting the runtime specification to `runtime: php83`.
- **Why it is required:** Google App Engine regularly updates supported language runtimes. Older samples may specify legacy versions (such as `php55` or generic `php`), so explicit configuration targeting modern PHP 8.3 ensures build compatibility and security patch support.
- **Expected Output:** Command runs silently without terminal errors.

---

## 6. Verify Runtime Configuration

### Command
```bash
grep runtime app.yaml
```

- **What it does:** Searches and displays lines matching `runtime` in the `app.yaml` descriptor file.
- **Why it is required:** Verifies that the file was correctly edited before initiating the deployment process.
- **Expected Output:**
  ```yaml
  runtime: php83
  ```

---

## 7. Deploy Application to App Engine

### Command
```bash
gcloud app deploy
```

- **What it does:** Packages local source files and `app.yaml`, uploads the bundle to Cloud Storage, triggers Cloud Build to compile the runtime container, creates an App Engine application version in the `default` service, and routes 100% of incoming traffic to it.
- **Interactive Prompts during Deployment:**
  - If App Engine has not been previously initialized in the project, the CLI prompts to select a region (e.g., entering the corresponding number for your region).
  - A confirmation prompt will ask:
    ```text
    Do you want to continue (Y/n)?
    ```
    Type `Y` and press `Enter`.
- **Expected Output:**
  ```text
  Services to deploy:
  descriptor:      [/home/.../app.yaml]
  source:          [/home/.../helloworld]
  target project:  [qwiklabs-gcp-xx-xxxxxxxxxxxx]
  target service:  [default]
  target version:  [20261103txxxxxx]
  target url:      [https://qwiklabs-gcp-xx-xxxxxxxxxxxx.xx.r.appspot.com]

  Beginning deployment of service [default]...
  Updating service [default]...done.
  Deployed service [default] to [https://qwiklabs-gcp-xx-xxxxxxxxxxxx.xx.r.appspot.com]
  ```

---

## 8. Open Deployed Application in Browser

### Command
```bash
gcloud app browse
```

- **What it does:** Prints the public application URL to the console and attempts to launch it in a browser window.
- **Why it is required:** Quick verification to validate that the App Engine service is active and responding over HTTPS.
- **Expected Output:**
  ```text
  Opening [https://qwiklabs-gcp-xx-xxxxxxxxxxxx.xx.r.appspot.com] in a new tab...
  ```
  The browser window displays:
  ```text
  hello world!
  ```

---

## 9. View Real-Time Application Logs

### Command
```bash
gcloud app logs tail -s default
```

- **What it does:** Streams real-time HTTP access and runtime stdout/stderr log entries for the `default` App Engine service directly into Cloud Shell.
- **Why it is required:** Essential for monitoring live traffic, inspecting request latency, verifying status codes (`200 OK`), and debugging runtime errors.
- **Expected Output:** Live log stream showing incoming GET requests from web browsers. Press `Ctrl + C` to exit log tailing.

---

## 10. Update the Application Source Code

### Command
```bash
nano index.php
```

- **What it does:** Opens the PHP entry-point script inside the `nano` terminal text editor.
- **Why it is required:** Modifies the output message from `hello world!` to `goodbye world!` to test application lifecycle updates and redeployment.
- **Original Content:**
  ```php
  <?php
  print "hello world!";
  ```
- **Updated Content:**
  ```php
  <?php
  print "Goodbye world!";
  ```
  *(Press `Ctrl + O`, `Enter` to save, and `Ctrl + X` to exit `nano`)*.

---

## 11. Redeploy Updated Application

### Command
```bash
gcloud app deploy
```

- **What it does:** Re-packages the updated source code, deploys a new incremental version to the `default` service, and automatically shifts 100% of production traffic to the new version.
- **Why it is required:** Serverless applications do not update in-place dynamically; deploying a new version is required so App Engine can build and serve the modified container.
- **Verification:** Refreshing the application URL in the browser displays:
  ```text
  goodbye world!
  ```

