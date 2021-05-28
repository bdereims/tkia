- don't forget to apply allow-runasnonroot-clusterrole.yaml
- if you want to integrate private registry, you have to path this: kubectl edit tkgserviceconfigurations 
'''
  defaultCNI: antrea
  trust:
    additionalTrustedCAs:
    - data: LS0tLS1CRUdJTi...
      name: harbor-cert
'''
- Same thing for proxy:
'''
spec:
  defaultCNI: antrea
  proxy:
    httpProxy: http://<user>:<pwd>@<ip>:<port>
'''
