To connect with kubectl to Tanzu Mission control K8 deployed clusters:
A/ Connect through the downloaded kubeconfig from TMC interface. Tested OK on windows and Mac since you need a browser to open the initial connection.
B/ Once this is done, you can create a service account, bind it to the cluster role and update the kubeconfig file with the user ID and token. These steps are scripted in this folder files.

To connect from a tool such as Codestream to TMC deployed clusters:
Use the B/ procedure to get the user ID and token. The server address is in the kubeconfig file
