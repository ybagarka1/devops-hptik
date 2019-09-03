#!/usr/local/bin/python
import boto3

import datetime


import logging

def get_req_count(region, lb_name):
    client = boto3.client('cloudwatch', region_name=region)
    count = 0
    response = client.get_metric_statistics(
            Namespace="AWS/ELB",
            MetricName="RequestCount",
            Dimensions=[
                {
                    "Name": "LoadBalancerName",
                    "Value": lb_name
                },
            ],
            StartTime = datetime.datetime.utcnow() - datetime.timedelta(days=10),
            EndTime = datetime.datetime.utcnow(),
            Period=86460,
            Statistics=[
                "Sum",
            ]
    )  
  
    for r in response['Datapoints']:
        count = (r['Sum'])


    return count 



region = "ap-south-1"
lb_name = "terraform-elb"
ami_id = "ami-0d2692b6acea72ee6"
keypair_name="ybagarka"
instance_type = "t2.micro"
mongo_db_instance = 'i-0f737084d95923e37'
secruity_group = "terraform"

print((get_req_count(region, lb_name)))
if (get_req_count("ap-south-1", "terraform-elb")) > 4:
    print("Request threshold reached")
    print("Increasing the elastic search node")
    ec2_client = boto3.client('ec2')
    instances = ec2_client.run_instances(ImageId=ami_id,  MinCount=1,MaxCount=1,InstanceType=instance_type,KeyName=keypair_name, SecurityGroups=[secruity_group])
    instance_info = instances['Instances'][0]
    if instance_info is not None:
        instance_id = instance_info["InstanceId"]
        logging.info(f'Launched EC2 Instance {instance_info["InstanceId"]}')
        logging.info(f'VPC ID: {instance_info["VpcId"]}')
        logging.info(f'Private IP Address: {instance_info["PrivateIpAddress"]}')
        logging.info(f'Current State: {instance_info["State"]["Name"]}')
        client = boto3.client('elb')
        client.register_instances_with_load_balancer(
            LoadBalancerName=lb_name,
            Instances=[
                {
                    'InstanceId': instance_id
                },
            ]
        )
        print("Scaling of the ec2 instance done.....")
        client = boto3.client('ec2')
        # Stop the instance
        client.stop_instances(InstanceIds=[mongo_db_instance])
        waiter=client.get_waiter('instance_stopped')
        waiter.wait(InstanceIds=[mongo_db_instance])
        # Change the instance type
        client.modify_instance_attribute(InstanceId=mongo_db_instance, Attribute='instanceType', Value='t2.medium')
        # Start the instance
        client.start_instances(InstanceIds=[mongo_db_instance])