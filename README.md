# L00205444-mini-pipeline

My mini CI/CD pipeline for Task 3 of DevOps Software Engineering at ATU (L00205444). The app is a small Node.js web app. The focus is the pipeline.

## The app

- `/` shows a greeting with the version number.
- `/health` returns `{"status":"ok"}`.
- `/metrics` shows the numbers that Prometheus collects.

## The pipeline

Every change goes through a pull request. `main` is protected, so a failed check blocks the merge. After a merge, the image is published and deployed.

| Stage | Tool | File |
| --- | --- | --- |
| Build, test, lint, audit | npm, Jest, ESLint, npm audit | `.github/workflows/node.js.yml` |
| Code security | CodeQL | `.github/workflows/codeql.yml` |
| Image security | Trivy (fails on CRITICAL) | `.github/workflows/trivy.yml` |
| Containerisation | Docker, GitHub Container Registry | `Dockerfile`, `.github/workflows/docker-publish.yml` |
| Deployment | Terraform, Kubernetes (Minikube) | `terraform/main.tf`, `.github/workflows/terraform.yml` |
| Monitoring | Prometheus, Grafana, alert | `docker-compose.yml` |

After the deploy, the pipeline calls `/health`. If the app does not answer, the run goes red.

## Run it locally

```bash
npm ci && npm test        # install and test
docker compose up --build # app, Prometheus, Grafana
```

The app is on http://localhost:3000, Prometheus on http://localhost:9090 and Grafana on http://localhost:3001. The alert `AppDown` fires when the app stops for 10 seconds.

## Deploy with Terraform

The Deploy workflow does this on GitHub. On my Mac with Minikube:

```bash
minikube start
docker build -t mini-pipeline:local .
minikube image load mini-pipeline:local
cd terraform && terraform init
terraform apply -var="image=mini-pipeline:local"
```

I build the image locally because my Mac is ARM and the published image is built for Intel/AMD.

## Security

No keys or passwords are stored in the repository. Third-party actions are pinned to full commit IDs. Terraform state is not committed.

## Demo

Demo video: *add link here*