#!/bin/bash

# Check subdirectory
if [ "${INPUT_CFN_SUBDIRECTORY}" == "" ]; then
    echo "Input cfn_subdirectory cannot be empty"
    exit 1
fi

# List templates
grep -r --exclude="entrypoint.sh" 'Resources' ${INPUT_CFN_SUBDIRECTORY}/* |cut -d':' -f1 > /tmp/cfn_templates

if [[ -d "${PWD}/reports" ]] ; then
    echo "Cleaning up existing report files"
    rm ${PWD}/reports/results*.txt
else
    echo "Creating ${PWD}/reports"
    mkdir ${PWD}/reports
fi

count=0

for x in $(cat /tmp/cfn_templates); do
    echo "Scanning file - ${x}"
    echo "Scanning file - ${x}" > ${PWD}/reports/results${count}.txt
    echo "Scanning datetime - "$(date +%Y%m%d_%H%M%S)  >> ${PWD}/reports/results${count}.txt
    ./cfn-guard check --strict-checks --rule_set ${PWD}/rules/cfn-guard-sqs.ruleset  --template ${PWD}/${x} >> ${PWD}/reports/results${count}.txt
    count=`expr $count + 1`
done
cat reports/results*.txt > consolidated_report.txt
cat consolidated_report.txt
