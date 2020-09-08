#!/bin/bash

# Check subdirectory
if [ "${INPUT_CFN_SUBDIRECTORY}" == "" ]; then
    echo "Input cfn_subdirectory cannot be empty"
    exit 1
fi


# Cleanup old templates
rm ${PWD}/cfn_templates

# List templates
grep -r --exclude="entrypoint.sh" 'AWSTemplateFormatVersion' ${INPUT_CFN_SUBDIRECTORY}/* |cut -d':' -f1 > /tmp/cfn_templates

if [-d ] ${PWD}/reports ; then
    echo "cleaning up existing report files"
    rm ${PWD}/reports/results*.json
else
    echo "Creating ${PWD}/reports"
    mkdir ${PWD}/reports
fi

for x in $(cat /tmp/cfn_templates); do
    echo "Scanning file - ${x}"
    echo "Scanning file - ${x}" > ${PWD}/reports/results${count}.txt
    echo "Scanning datetime - "$(date +%Y%m%d_%H%M%S)  >> ${PWD}/reports/results${count}.txt
    cfn-guard check --strict-checks --rule_set /rules/cfn-guard-sqs.ruleset  --template ${x} >> ${PWD}/reports/results${count}.txt
    count=`expr $count + 1`
done
cat reports/results*.txt > consolidated_report.txt
cat consolidated_report.txt
