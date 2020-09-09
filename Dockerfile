FROM ubuntu:latest

ADD ./bin/cfn-guard /usr/bin/cfn-guard
ADD ./bin/cfn-guard-rulegen /usr/bin/cfn-guard-rulegen
ADD ./rules/cfn-guard-sqs.ruleset /rules/cfn-guard-sqs.ruleset
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh  && chmod +x /usr/bin/cfn-guard && chmod +x /usr/bin/cfn-guard-rulegen

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]

