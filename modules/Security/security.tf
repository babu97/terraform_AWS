#Creating dynamic ingress security groups
locals {
  security_groups = {

    ext-alb-sg ={
        name = "ext-alb-sg"
        description = "for external loadbalancer"
    }
    #security group for bastion
    bastion-sg = {
        name = "bastion-sg"
        description = "For bation instances"
    }
    #Security group for nginx
    nginx-sg = {
        name = "nginx-sg"
        description = "nginx instances"
    }
    #Security group for IALB
    int-alb-sg = {
        name ="int-alb-sg"
        description = "IALB security group"
    }
    #Security group for webservers 
    webserver-sg = {
        name = "webserver-sg"
        description = "webservers security group"
    }
    #security group for data-layer
    datalayer-sg = {
        name = "datalayer-sg"
        description = "data layer security group"
    }

  }

}