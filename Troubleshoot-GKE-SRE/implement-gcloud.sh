#### Reference: Cloud Operations Sandbox https://github.com/GoogleCloudPlatform/cloud-ops-sandbox/


# Navigate resource pages of Google Kubernetes Engine (GKE)

# Leverage the GKE dashboard to quickly view operational data

# Create logs-based metrics to capture specific issues

# Create a Service Level Objective (SLO)

# Define an Alert to notify SRE staff of incidents

git clone --depth 1 --branch cloudskillsboost https://github.com/GoogleCloudPlatform/cloud-ops-sandbox.git

# Creating a Service Level Objective (SLO)
# After creating the logs-based metric, the SRE team decides that it will define a Service Level Objective (SLO) on the recommendationservice. You use an SLO to specify service-level objectives for performance metrics.

{
  "name": null,
  "displayName": "99% - Availability - Calendar month",
  "goal": 0.99,
  "calendarPeriod": "MONTH",
  "serviceLevelIndicator": {
    "basicSli": {
      "availability": {}
    }
  }
}