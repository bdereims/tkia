![tkai image](images/tkia.png)

---

***Disclaimer:*** This is my repo of links, examples and best practices that I got or created about VMware Tanzu portfollio. It's personnal there are no hard commitments from VMware. Use as is and without warranty of any kind.

Brice  
  
---
  

## Training and 101
- [Kube Academy](https://kube.academy/) is a bunch of good lessons about k8s
- [Meetup with J. Petazzoni about Docker and Kubernetes](https://vmware-2019-11.container.training/#1) and check out (Jérôme's repo)(https://github.com/jpetazzo/container.training) 
- [eduk8s-labs](https://github.com/eduk8s-labs)
- [TKG for Dev - Labs](https://github.com/failk8s/tkg-dev-install)
- [Tanzu PoC Guide](https://core.vmware.com/resource/tanzu-proof-concept-guide)

## VMware & Kubernetes 
- [CNCF's Landscape](https://landscape.cncf.io/)
- [Countour Ingress Controler](https://projectcontour.io/)
- [Harbor Registry](https://goharbor.io/)
- [Tanzu Certified K8S distro](https://www.cncf.io/certification/software-conformance/)
- [Cluster API](https://github.com/kubernetes-sigs/cluster-api)
- [Backup/Restore with Velero](https://velero.io/)
- [Cluster Conformance with Sonobuoy](https://sonobuoy.io/)
- [Carvel tools suite](https://carvel.dev/)

## Tanzu RTFM
- [vSphere with Tanzu](https://docs.vmware.com/en/VMware-vSphere/7.0/vmware-vsphere-with-tanzu/GUID-152BE7D2-E227-4DAA-B527-557B564D9718.html)
- [Tanzu Kubernetes Grid](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/index.html)
- [Tanzu PoC Guide](https://core.vmware.com/resource/tanzu-proof-concept-guide#_Toc56496942)

## Tanzu & Cloud Partners
- [Tanzu on Microsft Azure](https://tanzu.vmware.com/partners/microsoft-azure)
- [Tanzu on Google Cloud](https://tanzu.vmware.com/partners/google)
- [Tanzu on Amazon Web Services](https://tanzu.vmware.com/partners/aws) 

## Tanzu & Technology Partners
- [Devops](https://tanzu.vmware.com/services-marketplace/devops-tooling)
- [Identity and Security](https://tanzu.vmware.com/services-marketplace/identity-and-security)
- [Monitoring, Metrics and Logging](https://tanzu.vmware.com/services-marketplace/monitoring-metrics-and-logging) 

## BLOGs / VLOGs
- [My Cloud Garage Blog](https://blog.cloud-garage.net)
- [Joe Beda's TGI Kubernetes and other awesome videos](https://www.youtube.com/channel/UCdkGV51Nu0unDNT58bHt9bg)
- [TKG in multitenant setup](https://tanzu.vmware.com/content/practitioners/a-closer-look-at-vmware-tanzu-kubernetes-grid-multitenant-setup)
- [vSphere with Kubernetes demo](https://www.youtube.com/watch?v=GCW4GtdCHLc)
- [Cloud Native Storage (CNS) in vSphere with Kubernetes/Tanzu](https://cormachogan.com/2020/07/21/cloud-native-storage-cns-in-vsphere-with-kubernetes-tanzu-video/)
- [vSphere with Kubernetes on VCF 4.0.1 Consolidated Architecture](https://cormachogan.com/2020/07/08/vsphere-with-kubernetes-on-vcf-4-0-1-consolidated-architecture/)
- [Integrating embedded vSphere with Kubernetes Harbor Registry with TKG (guest) clusters](https://cormachogan.com/2020/06/23/integrating-embedded-vsphere-with-kubernetes-harbor-registry-with-tkg-guest-clusters/)
- [vSAN File Services and Cloud Native Storage integration (Video)](https://cormachogan.com/2020/06/17/vsan-file-services-and-cloud-native-storage-integration/)
- [vSphere CSI driver versions and capabilities](https://cormachogan.com/2020/05/07/vsphere-csi-driver-versions-and-capabilities/)
- [vSphere 7.0, Cloud Native Storage, CSI and offline volume extend](https://cormachogan.com/2020/04/23/vsphere-7-0-cloud-native-storage-csi-and-offline-volume-extend/)
- Become a [Modern Apps Ninja](https://www.modernapps.ninja/)
- [HA Proxy as type Load Balancer for vSphere with Tanzu](https://cormachogan.com/2020/09/28/enabling-vsphere-with-tanzu-using-ha-proxy/)
- [Velero & Restic Doc](https://github.com/vmware-tanzu/velero/blob/master/site/docs/master/restic.md)

## Hands on Lab
HOL are available [here](https://labs.hol.vmware.com)
- HOL-2132-01-MAP - VMware Tanzu Mission Control
- HOL-2137-91-NET - VMware NSX Advanced Load Balancer (Avi Networks) Lighting Lab
- HOL-2033-01-CNA - Managing and Extending Kubernetes - Getting Started
- HOL-2132-92-ISM - VMware Tanzu Service Mesh Simulation
- HOL-2031-01-CNA - VMware TKGI (Formerly Enterprise PKS) - Getting Started
- HOL-2113-01-SDC - vSphere with Tanzu
- HOL-2047-01-ISM - Accelerate Machine Learning in vSphere Using GPUs
- HOL-2044-01-ISM - Modernizing Your Data Center with VMware Cloud Foundation
- HOL-2126-03-NET - NSX-T - Advanced Topics and Kubernetes Integration

## Best Practices and Useful Tools
- [pks-prep](https://github.com/bdereims/pks-prep) are scripts accelerating PoC and installation of PKS know as know as TKGI
- [koulpe](https://github.com/bdereims/koulpe) is installation and deployment scripts for TKG, will be replaced by this tkai repo
- [the tito app](https://github.com/vmeoc/Tito) from vmeoc, an app declined into mutiple flavors: VMs, containers, pods, etc. helping to understand app modernisation
- looking at kube GUI? check out [octant project](https://github.com/vmware-tanzu/octant)
- [antrea](https://github.com/vmware-tanzu/antrea) is the new [CNI](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/) plugin for kubernetes
- [VMs2PODs](https://github.com/bdereims/pks-prep/blob/master/k8s/VMs2PODs/VMs2Pods.pdf) explaining how to move app to something like micro services and leveraging k8s features (all assets)
- Volume expansion has been always an issue, [this is a how-to with vSphere CSI](https://github.com/kubernetes-sigs/vsphere-csi-driver/blob/master/docs/book/features/volume_expansion.md)
- [Automation engine for cloud native CI/CD](https://tanzu.vmware.com/concourse)

## Ecosystem
- [Metanext](https://www.metanext.com/) one of our partners on Tanzu

## VMworld 2020 Sessions
- Kubernetes Operators for VMware Tanzu Kubernetes Grid - KUB1248
- Connect and Secure Your Applications Through Tanzu Service Mesh - MAP2081
- Consuming Trusted Content from Tanzu Application Catalog - MAP2552
- How to Get Startd with VMware Container Networking with Antrea - VCNC1553
- The Datacenter of the Future - HCP3004
- vCenter Server 7 Deconstructed - HCP2328
- Tanzu Kubernetes Grid Networking Concepts - KUB2334
- Kubernetes Operators for VMware Tanzu Kubernetes Grid - KUB1248
- vSphere with Tanzu Deep Dive - KUB2469
- GitOps and Kubernetes – A Guide for the VI Admin - KUB2306
- [Tazu Service Mesh @ VMworld](https://blogs.vmware.com/networkvirtualization/2020/09/tanzu-service-mesh-vmworld2020.html/)


