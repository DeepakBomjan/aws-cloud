## Create VPC network with cloudformation
1. Go to Cloudformation
2. Create a new stack
3. Go to **create one with new resources**
4. Use the create template in **Designer selection**
5. Click on **create template in Designer**
6. Navigate to the bottom, switch to **template**, select YAML
7. Paste in below architecture's CloudFormation
8. Click on **validate**
9. Deploy

```yaml
AWSTemplateFormatVersion: 2010-09-09
Description: CloudFormation Demo
Parameters:
  InstanceTypeParameter:
    Type: String
    Default: t2.micro
    AllowedValues:
      - t2.micro
      - m1.small
      - m1.large
    Description: Enter t2.micro, m1.small, or m1.large. Default is t2.micro.
Mappings:
  SubnetConfig:
    VPC:
      CIDR: 10.0.0.0/16
    Public1:
      CIDR: 10.0.0.0/24
    Public2:
      CIDR: 10.0.1.0/24
    Public3:
      CIDR: 10.0.2.0/24
Resources:
  VPC:
    Type: 'AWS::EC2::VPC'
    Properties:
      EnableDnsSupport: 'true'
      EnableDnsHostnames: 'true'
      CidrBlock: !FindInMap 
        - SubnetConfig
        - VPC
        - CIDR
      Tags:
        - Key: Name
          Value: ACloudGuru
        - Key: Application
          Value: !Ref 'AWS::StackName'
        - Key: Network
          Value: VPC
  PublicSubnet1:
    Type: 'AWS::EC2::Subnet'
    Properties:
      VpcId: !Ref VPC
      AvailabilityZone: 
        Fn::Select: 
          - 0
          - Fn::GetAZs: ""
      CidrBlock: !FindInMap 
        - SubnetConfig
        - Public1
        - CIDR
      Tags:
        - Key: Application
          Value: !Ref 'AWS::StackName'
        - Key: Network
          Value: Public1
      MapPublicIpOnLaunch: true
  PublicSubnet2:
    Type: 'AWS::EC2::Subnet'
    Properties:
      VpcId: !Ref VPC
      AvailabilityZone: 
        Fn::Select: 
          - 1
          - Fn::GetAZs: ""
      CidrBlock: !FindInMap 
        - SubnetConfig
        - Public2
        - CIDR
      Tags:
        - Key: Application
          Value: !Ref 'AWS::StackName'
        - Key: Network
          Value: Public2
      MapPublicIpOnLaunch: true
  InternetGateway:
    Type: 'AWS::EC2::InternetGateway'
    Properties:
      Tags:
        - Key: Application
          Value: !Ref 'AWS::StackName'
        - Key: Network
          Value: Public
  GatewayToInternet:
    Type: 'AWS::EC2::VPCGatewayAttachment'
    Properties:
      VpcId: !Ref VPC
      InternetGatewayId: !Ref InternetGateway
  PublicRouteTable:
    Type: 'AWS::EC2::RouteTable'
    Properties:
      VpcId: !Ref VPC
      Tags:
        - Key: Application
          Value: !Ref 'AWS::StackName'
        - Key: Network
          Value: Public
  PublicRoute:
    Type: 'AWS::EC2::Route'
    DependsOn: GatewayToInternet
    Properties:
      RouteTableId: !Ref PublicRouteTable
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref InternetGateway
  PublicSubnetRouteTableAssociation1:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Properties:
      SubnetId: !Ref PublicSubnet1
      RouteTableId: !Ref PublicRouteTable
  PublicSubnetRouteTableAssociation2:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Properties:
      SubnetId: !Ref PublicSubnet2
      RouteTableId: !Ref PublicRouteTable
  PublicNetworkAcl:
    Type: 'AWS::EC2::NetworkAcl'
    Properties:
      VpcId: !Ref VPC
      Tags:
        - Key: Application
          Value: !Ref 'AWS::StackName'
        - Key: Network
          Value: Public
  InboundHTTPPublicNetworkAclEntry:
    Type: 'AWS::EC2::NetworkAclEntry'
    Properties:
      NetworkAclId: !Ref PublicNetworkAcl
      RuleNumber: '100'
      Protocol: '6'
      RuleAction: allow
      Egress: 'false'
      CidrBlock: 0.0.0.0/0
      PortRange:
        From: '80'
        To: '80'
  InboundHTTPSPublicNetworkAclEntry:
    Type: 'AWS::EC2::NetworkAclEntry'
    Properties:
      NetworkAclId: !Ref PublicNetworkAcl
      RuleNumber: '101'
      Protocol: '6'
      RuleAction: allow
      Egress: 'false'
      CidrBlock: 0.0.0.0/0
      PortRange:
        From: '443'
        To: '443'
  InboundSSHPublicNetworkAclEntry:
    Type: 'AWS::EC2::NetworkAclEntry'
    Properties:
      NetworkAclId: !Ref PublicNetworkAcl
      RuleNumber: '102'
      Protocol: '6'
      RuleAction: allow
      Egress: 'false'
      CidrBlock: 0.0.0.0/0
      PortRange:
        From: '22'
        To: '22'
  InboundEmphemeralPublicNetworkAclEntry:
    Type: 'AWS::EC2::NetworkAclEntry'
    Properties:
      NetworkAclId: !Ref PublicNetworkAcl
      RuleNumber: '103'
      Protocol: '6'
      RuleAction: allow
      Egress: 'false'
      CidrBlock: 0.0.0.0/0
      PortRange:
        From: '1024'
        To: '65535'
  OutboundPublicNetworkAclEntry:
    Type: 'AWS::EC2::NetworkAclEntry'
    Properties:
      NetworkAclId: !Ref PublicNetworkAcl
      RuleNumber: '100'
      Protocol: '6'
      RuleAction: allow
      Egress: 'true'
      CidrBlock: 0.0.0.0/0
      PortRange:
        From: '0'
        To: '65535'
  PublicSubnetNetworkAclAssociation1:
    Type: 'AWS::EC2::SubnetNetworkAclAssociation'
    Properties:
      SubnetId: !Ref PublicSubnet1
      NetworkAclId: !Ref PublicNetworkAcl
  PublicSubnetNetworkAclAssociation2:
    Type: 'AWS::EC2::SubnetNetworkAclAssociation'
    Properties:
      SubnetId: !Ref PublicSubnet2
      NetworkAclId: !Ref PublicNetworkAcl
  BastionEC2: 
    Type: AWS::EC2::Instance
    Properties: 
      ImageId: "ami-0e999cbd62129e3b1"
      InstanceType: !Ref InstanceTypeParameter
      UserData:
        Fn::Base64:
          !Sub |
            #!/bin/bash -xe
            yum install -y ec2-instance-connect
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
            curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
            sudo mv /tmp/eksctl /usr/local/bin
      NetworkInterfaces: 
      - AssociatePublicIpAddress: "true"
        DeviceIndex: "0"
        GroupSet: 
          - Ref: "BastionSG"
        SubnetId: !Ref PublicSubnet1
      Tags:
        - Key: Name
          Value: CLI Host
      IamInstanceProfile: !Ref RootInstanceProfile
    DependsOn: VPC
  BastionSG:
    Type: AWS::EC2::SecurityGroup
    Properties:
        GroupDescription: Allow ssh to client host
        VpcId: !Ref VPC
        SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
  RootRole:
    Type: 'AWS::IAM::Role'
    Properties:
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - ec2.amazonaws.com
            Action:
              - 'sts:AssumeRole'
      Path: /
      Policies:
        - PolicyName: root
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: Allow
                Action: '*'
                Resource: '*'
  RootInstanceProfile:
    Type: 'AWS::IAM::InstanceProfile'
    Properties:
      Path: /
      Roles:
        - !Ref RootRole
```
