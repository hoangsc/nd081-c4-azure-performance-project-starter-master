# Change the ACR name in the commands below.
   # Assuming the acdnd-c4-project resource group is still available with you
   # ACR name should not have upper case letter
   az acr create --resource-group acdnd-c4-project --name hcacr2022 --sku Basic
   # Log in to the ACR
   az acr login --name hcacr2022
   # Get the ACR login server name
   # To use the azure-vote-front container image with ACR, the image needs to be tagged with the login server address of your registry. 
   # Find the login server address of your registry
   az acr show --name hcacr2022 --query loginServer --output table
   # Associate a tag to the local image. You can use a different tag (say v2, v3, v4, ....) everytime you edit the underlying image. 
   docker tag azure-vote-front:v1 hcacr2022.azurecr.io/azure-vote-front:v1
   # Now you will see hcacr2022.azurecr.io/azure-vote-front:v1 if you run "docker images"
   # Push the local registry to remote ACR
   docker push hcacr2022.azurecr.io/azure-vote-front:v1
   # Verify if your image is up in the cloud.
   az acr repository list --name hcacr2022 --output table
   # Associate the AKS cluster with the ACR
   az aks update -n udacity-cluster -g acdnd-c4-project --attach-acr hcacr2022
   
   
   # 7.0 Get ACR login server name
   az acr show --name hcacr2022 --query loginServer --output table
   # 7.0 
   # Deploy the application. Run the command below from the parent directory where the *azure-vote-all-in-one-redis.yaml* file is present. 
   kubectl apply -f azure-vote-all-in-one-redis.yaml
   kubectl set image deployment azure-vote-front azure-vote-front=hcacr2022.azurecr.io/azure-vote-front:v1
   # Test the application at the External IP
   # It will take a few minutes to come alive. 
   kubectl get service
   # Check the status of each node
   kubectl get pods
   # Push your local changes to the remote Github repo, preferably in the Deploy_to_AKS branch