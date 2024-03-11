FROM amazon/aws-cli

RUN yum install nfs-utils -y &&  \
    yum install amazon-efs-utils -y &&  \
    yum install vim -y

RUN mkdir ./efs

COPY ./start.sh /aws/start.sh

RUN chmod +x /aws/start.sh

WORKDIR /aws/

ENTRYPOINT ["/aws/start.sh"]
