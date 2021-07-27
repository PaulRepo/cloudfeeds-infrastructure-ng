# CloudFeeds POC on AWS EKS
### Follow the below steps to create a CloudFeeds Cluster on AWS EKS. We will create a Trow registry deployed on EKS cluster for using locally build images.

## [EKS Cluster using eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html)
1. Install the proper version of AWS CLI, kubectl, eksctl as mentioned on the link https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html
2. In this guide we will follow the steps to create the Managed Node linux cluster. 
3. Create ec2 key pair, you can change the region as per your convenience.
    
    ```
    aws ec2 create-key-pair --region ap-south-1 --key-name cloudfeeds
    ```
4. Create the EKS cluster. This will create all the required resources IAM Roles, VPC, Security Groups...etc to run an EKS cluster including EC2 worker nodes. You can check the resources tab of CloudFormation stack to see all the resources.  

    ```
    eksctl create cluster \
    --name cloudfeeds \
    --tags "Owner=CloudFeeds" \
    --region ap-south-1 \
    --with-oidc \
    --node-type t3.medium \
    --ssh-access \
    --ssh-public-key cloudfeeds \
    --managed
    ```
5. This will take time ~20 Minutes. Once the cluster is ready we will get the output.

    ```
    [✓]  EKS cluster "cloudfeeds" in "ap-south-1" region is ready
    ```
6. Check for the runnings nodes.

    ```
    kubectl get nodes -o wide
    ```
7. Create *cloudfeeds* namespace on the cluster and set it in current context as default namespace for all future refferences.

    ```
    kubectl create namespace cloudfeeds
    kubectl config set-context --current --namespace=cloudfeeds
    ```
8. Allow traffic from your local machine to EC2 workder nodes using the public IP.
    - Go to the Security Group section under EC2 on AWS Console and find a Security Group that contains `*-remoteAccess` in the name. 
    - Modify the inbound rule to add your local IP for all TCP traffic.
        - Type-> All TCP
        - Source-> My IP 
        - Description-> Your Comments
    - Also modify Source-> My IP for SSH access. 
    - Remove IPv6 rule for SSH.
    - Hit `Apply Rules`
> :warning: **Teardown the cluster when you are done**:  Leaving it up costs money. [Instructions](#delete-cluster)

## Deply Trow registry on EKS
Deploy the Trow registry on eks cluster by following the instructions given on the link
https://github.com/ContainerSolutions/trow/blob/main/QUICK-INSTALL.md
Follow the **Automatic Installation** instructions and provide the namespace **cloudfeeds**.
    
***If you are on `Mac` and installing it again, just `remove` the `kubernetes certificate` present under `system keychain` using the `Keychain Access` app available on Mac***
- Get the code on local and install using script
    ```
    git clone git@github.com:ContainerSolutions/trow.git
    cd trow/quick-install/
    ./install.sh cloudfeeds
    ```
- Select **`N`** for 

    *Do you want to configure Trow as a validation webhook (NB this will stop external images from being deployed to the cluster)? (y/n)*
- **Restart Docker once the install script has completed**
- Use the Docker Desktop restart option from GUI or hit the below commands on terminal
    ```
    osascript -e 'quit app "Docker"'`
    open -a Docker
    ```
- Test using a sample nginx image: 

    ```
    docker pull nginx:alpine
    docker tag nginx:alpine trow.cloudfeeds:31000/test/nginx:alpine
    docker push trow.cloudfeeds:31000/test/nginx:alpine
    ```
- Create a deployment from the recently pushed image to prove the case
    ```
    kubectl create deploy trow-test --image=trow.cloudfeeds:31000/test/nginx:alpine
    kubectl get deploy trow-test`

    NAME        READY   UP-TO-DATE   AVAILABLE   AGE
    trow-test   1/1     1            1           28s
    ```
## Deploy CloudFeeds apps (Postgres, AtomHopper, Repose)
**Navigate to the manifests directory**
### Postgres
The postgres.yaml manifest file contains the resources (Persistent Volume, Persistent Volume Claim, Deployment, Service) required to run a Postgres database on a kubernetes cluster.
- Create the resouces for postgres.
  ```
  kubectl create -f postgres.yaml
  ```
- Get inside the Posgres pod to create the database and relations that is need to post and get the feeds.
    ```
    kubectl exec --stdin --tty postgres-0 -- /bin/bash
    psql -U postgres
    ```
- You should see the psql console: *postgres=#*
- Create database support and change current database
    ```
    create database support;
    \c support;
    ```
- Paste and execute the content on psql console from the [link](https://raw.githubusercontent.com/rackerlabs/atom-hopper/master/adapters/jdbc/src/main/resources/ddl/jdbc/atomhopper-fresh-schema-ddl-postgres.sql) 
- Quit psql console and exit the pod. 
    ```
    \q
    exit
    ```
- [Learn more on psql console](https://www.postgresql.org/docs/13/app-psql.html)
### Cloudfeeds - Atomhopper and Repose
- Change the application-context.xml file of the Atomhopper to connect postgres on **postgres:5432** 
- Build the Cloudfeeds Atomhopper image locally.
- Now tag the Atomhopper image and push to the trow registry
    ```
    docker tag cloudfeeds-atomhopper:eks trow.cloudfeeds:31000/cloudfeeds/atomhopper:eks
    docker push trow.cloudfeeds:31000/cloudfeeds/atomhopper:eks
    ```
- Make sure the Repose External configuration file system-model.cfg.xml is configured with     **hostname="atomhopper"**
- Build the Repose External image locally 
- Tag and push to the trow registry
    ```
    docker tag repose-external:eks trow.cloudfeeds:31000/cloudfeeds/repose-external:eks
    docker push trow.cloudfeeds:31000/cloudfeeds/repose-external:eks
    ```
- Create Cloudfeeds resources 
    ```
    kubectl apply -f cloudfeeds.yaml
    ```
- Final Snapshot of all k8s resources
    ```
            NAME                                                        READY   STATUS      RESTARTS   AGE
            pod/atomhopper-649bcb5d4c-r9qx5                             1/1     Running     0          44s
            pod/copy-certs-b282bbdb-fed7-4011-8c46-fac6217f783e-xssb5   0/1     Completed   0          166m
            pod/copy-certs-fa18038d-e808-49a0-9ca3-1de6305f3a95-pkxzw   0/1     Completed   0          166m
            pod/postgres-0                                              1/1     Running     0          114m
            pod/repose-external-7bfd6df5c4-j2lt2                        1/1     Running     0          43s
            pod/trow-deploy-7dc5bd7654-tncpp                            1/1     Running     0          167m

            NAME                      TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
            service/atomhopper        NodePort   10.xxx.xxx.xxx   <none>        8080:30001/TCP   45s
            service/postgres          NodePort   10.xxx.xxx.xxx   <none>        5432:30000/TCP   114m
            service/repose-external   NodePort   10.xxx.xxx.xxx   <none>        9090:30002/TCP   44s
            service/trow              NodePort   10.xxx.xxx.xxx   <none>        443:31000/TCP    167m

            NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
            deployment.apps/atomhopper        1/1     1            1           45s
            deployment.apps/repose-external   1/1     1            1           44s
            deployment.apps/trow-deploy       1/1     1            1           167m

            NAME                                         DESIRED   CURRENT   READY   AGE
            replicaset.apps/atomhopper-649bcb5d4c        1         1         1       45s
            replicaset.apps/repose-external-7bfd6df5c4   1         1         1       44s
            replicaset.apps/trow-deploy-7dc5bd7654       1         1         1       167m

            NAME                        READY   AGE
            statefulset.apps/postgres   1/1     114m

            NAME                                                        COMPLETIONS   DURATION   AGE
            job.batch/copy-certs-b282bbdb-fed7-4011-8c46-fac6217f783e   1/1           10s        166m
            job.batch/copy-certs-fa18038d-e808-49a0-9ca3-1de6305f3a95   1/1           10s        166m
    ```
 - ```kubectl get nodes -o wide``` and look for the External-IP field for public IP of the node. 
 - Get the feeds. 
   ```
    http://[Public IP of the Node]:30002/support/events
   ```

    ```
    curl http://x.x.x.x:30002/support/events

    <?xml version="1.0" encoding="UTF-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom">
    <link href="http://localhost/support/events/" rel="current"/>
    <link href="http://localhost/support/events/" rel="self"/>
    <link href="http://localhost/support/events/?marker=last&amp;limit=25&amp;search=&amp;direction=backward" rel="last"/> </feed>
    ```
- Post a support feed.
    ```
    curl \
    -H "Content-Type: application/atom+xml" \
    -X POST \
    -d '<?xml version="1.0" encoding="UTF-8"?>
    <?atom feed="support/events"?>
    <atom:entry xmlns:atom="http://www.w3.org/2005/Atom"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema"
            xmlns="http://www.w3.org/2001/XMLSchema">
    <atom:title>Support</atom:title>
    <atom:content type="application/xml">
      <event xmlns="http://docs.rackspace.com/core/event"
             xmlns:sample="http://docs.rackspace.com/event/support/account/roles"
             id="e53d007a-fc23-11e1-975c-cfa6b29bb818"
             version="1"
             resourceId="4a2b42f4-6c63-11e1-815b-7fcbcf67f549"
             eventTime="2013-03-15T11:51:11Z"
             type="CREATE"
             dataCenter="DFW1"
             region="DFW">
         <sample:product serviceCode="Support" version="1" resourceType="ACCOUNT_SUPPORT">
            <sample:role sso="sample_Name" role="ACCOUNT_MANAGER" roleId="1"/>
         </sample:product>
      </event>
    </atom:content>
    </atom:entry>' \
    http://x.x.x.x:30002/support/events
    ```

- The feed should be available on the next GET call.
    ```
    curl http://x.x.x.x:30002/support/events 
    ```
    ```
    <?xml version="1.0" encoding="UTF-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom">
    <link href="http://localhost/support/events/" rel="current"/>
    <link href="http://localhost/support/events/" rel="self"/>
    <id>urn:uuid:c734be1c-6d87-42f4-959b-6478c921e4b7</id>
    <title type="text">support/events</title>
    <link href="http://localhost/support/events/?marker=urn:uuid:e53d007a-fc23-11e1-975c-cfa6b29bb818&amp;limit=25&amp;search=&amp;direction=forward"
         rel="previous"/>
    <link href="http://localhost/support/events/?marker=last&amp;limit=25&amp;search=&amp;direction=backward"
         rel="last"/>
    <updated>2021-04-20T14:40:15.304Z</updated>
    <atom:entry xmlns:atom="http://www.w3.org/2005/Atom"
               xmlns="http://www.w3.org/2001/XMLSchema"
               xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <atom:id>urn:uuid:e53d007a-fc23-11e1-975c-cfa6b29bb818</atom:id>
      <atom:category term="rgn:DFW"/>
      <atom:category term="dc:DFW1"/>
      <atom:category term="rid:4a2b42f4-6c63-11e1-815b-7fcbcf67f549"/>
      <atom:category term="support.roles.account_support.create"/>
      <atom:category term="type:support.roles.account_support.create"/>
      <atom:title type="text">Support</atom:title>
      <atom:content type="application/xml">
         <event xmlns="http://docs.rackspace.com/core/event"
                xmlns:sample="http://docs.rackspace.com/event/support/account/roles"
                dataCenter="DFW1"
                environment="PROD"
                eventTime="2013-03-15T11:51:11Z"
                id="e53d007a-fc23-11e1-975c-cfa6b29bb818"
                region="DFW"
                resourceId="4a2b42f4-6c63-11e1-815b-7fcbcf67f549"
                type="CREATE"
                version="1">
            <sample:product resourceType="ACCOUNT_SUPPORT" serviceCode="Support" version="1">
               <sample:role role="ACCOUNT_MANAGER"
                            roleId="1"
                            sso="sample_Name"
                            suppressNotifications="false"/>
            </sample:product>
         </event>
      </atom:content>
      <atom:link href="http://localhost/support/events/entries/urn:uuid:e53d007a-fc23-11e1-975c-cfa6b29bb818"
                 rel="self"/>
      <atom:updated>2021-04-20T14:40:04.510Z</atom:updated>
      <atom:published>2021-04-20T14:40:04.510Z</atom:published>
    </atom:entry>
    </feed>
    ```

## <a id="delete-cluster"></a>Delete the cluster
```
eksctl delete cluster --name cloudfeeds --region ap-south-1
aws ec2 delete-key-pair --region ap-south-1 --key-name cloudfeeds
```
- If the stack deletion fails. Check and delete that particular failing resource manually from the AWS Console and hit the delete cluster command again.
