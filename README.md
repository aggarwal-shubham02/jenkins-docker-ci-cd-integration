# jenkins-docker-ci-cd-integration

Created a simple CI/CD pipeline using jenkins for the POC task
The Pipeline would be triggered if any changes happens on github like any commit or merge or any of the event fires.
Than this event will trigger CI/CD pipeline that is configured in jenkins and than create a docker image for the same and publish
the image to DockerHub.
At last that docker image is deployed on Kubernetes cluster

These all things are automated, just anybody pushes the code, all things started and image gets uploaded on docker hub.

# Flow of the POC or project 

Github event ---> jenkins ----> docker ---> kubernetes

Steps For the POC task
* Created a simple java project with hello world application
* Created a item in jenkins and do with all the configuration
  --> for installation of jenkins, simply download msi file and create a user and password for the same
  --> create a sample project (or new item ) in jenkins
  --> Install all the required plugins for the task like Pipeline, docker etc.
  --> configure the github project 
  --> configure your git repo in source code management
  --> Build a trigger with poll SCM and set it  to * * * * * (for every second when event collection from github ie it is a cron job, also set according to need)
  --> After build configure your docker with docker image name that you want to publish and set the credentials.
  
 This is also be can automated by creating a simple jenkins file that contains all the configuration that is above stated
 For example:
 {
    imagename = "v" + "-"   + env.BUILD_NUMBER
    env.IMAGE = "shubhamaggarwal02/ci-cd-jenkins-docker-integration"
    env.TAG = "${imagename}"
    env.REPO = "https://github.com/aggarwal-shubham02/jenkins-docker-ci-cd-integration.git"
    def app_name = 'code'
     node("kubernetes") {
         stage('Checkout') {
            git "${env.REPO}"
        }
         container("maven") {
            stage("build") {
                dir ("./${app_name}"){
                sh 'mvn -Dmaven.test.failure.ignore clean'
                sh 'mvn -Dmaven.test.failure.ignore test'
                sh 'mvn -Dmaven.test.failure.ignore package'
                }
             }
             stage("unit-test") 
                {
                dir ("./${app_name}"){
                junit '**/target/surefire-reports/TEST-*.xml'
              }
             }
         }
         container("docker") {
             stage("build") {
                 sh """docker image build -t ${env.IMAGE}:${env.TAG} ."""
                withCredentials([usernamePassword(
                credentialsId: "docker",
                usernameVariable: "USER",
                passwordVariable: "PASS"
                    )])
                    {
                 sh """docker login -u $USER -p $PASS"""
                    }
                 sh """docker image push ${env.IMAGE}:${env.TAG}"""
             }
         }
     }
 }
 
# Now your CI/CD pipeline is fully configure
# Can now check by making changes to the Github

# Deploy on Kubernetes cluster
--> Install kubernetes from the official website
-->Also install and configure Kubectl for running and cheking the kubernetes pos and cluster information
--> can also install minikube 
    (minikube is local Kubernetes, focusing on making it easy to learn and develop for Kubernetes)
 --> now can start it by simple command:
      minikube start (for starting it)
      kubectl get po -A (for checking of any cluster)
      Now you can just create or start your deployment just by normal command: 
      kubectl create deployment <name> --image=<docker image name >
      kubectl expose deployment <name>  --type=NodePort --port=8080
      
      Also u can directly do it through the dashboard, kubernetes provide dashboard for performing this task as well
      run command : minikube dashboard (this will open dashboard in your browser)
      Now just go to create button and fill all the required information
      
      
 Now, Kubernetes deployment also successfully done..!!
 
