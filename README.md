# gorest-api-automation-postman-newman
## Environment Setup

The real environment file (`environments/GoRestEnv.json`) is **not** committed because it contains an API token. To run the collections:

1. Get a free access token from https://gorest.co.in/consumer/login
2. Copy the template:
   ```bash
   cp environments/GoRestEnv.example.json environments/GoRestEnv.postman_environment.json
   ```
3. Open the copied file and set your values:

| Variable  | Description                  | Example               |
|-----------|------------------------------|-----------------------|
| `baseURL` | GoRest API base URL          | `https://gorest.co.in`|
| `token`   | Your GoRest access token     | `<your-token>`        |

The copied file is gitignored, so your token stays local.

## Running

```bash
newman run collections/GoRest-Workflow-v3.json \
  -e environments/GoRestEnv.json
```