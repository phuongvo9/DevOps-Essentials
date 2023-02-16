# What is Azure network watcher
Azure Network Watcher provides tools to monitor, diagnose, view metrics, and enable or disable logs for resources in an Azure virtual network.

---

Network Watcher is designed to monitor and repair the network health of IaaS (Infrastructure-as-a-Service) products including virtual machines (VMs), virtual networks (VNets), application gateways, load balancers, etc.

## Connection monitor ( connection troubleshoot )
The connection monitor capability monitors communication at a regular interval and informs you of reachability, latency, and network topology changes between the VM and the endpoint.
## Network performance monitor
monitor network performance between various points in your network infrastructure (cloud/hybrid/service/application endpoints/express route)

# Diagnostics

## Filtering problem to/from a Virtual Machine
### `IP flow verify` 
`IP flow verify`  specify a source and destination IPv4 address, port, protocol (TCP or UDP), and traffic direction (inbound or outbound). IP flow verify then tests the communication and informs you if the connection succeeds or fails

## Routing problems
### `Next hop`
`Next hop` specify a source and destination IPv4 address. Next hop then tests the communication and informs you what type of next hop is used to route the traffic. You can then remove, change, or add a route, to resolve a routing problem

## Outbound connections from VM problem
 `connection troubleshoot` capability enables you to test a connection between a VM and another VM, an FQDN, a URI, or an IPv4 address. The test returns similar information returned when using the `connection monitor` capability, but tests the connection at a point in time, rather than monitoring it over time, as connection monitor does.