#!/bin/sh

# Check subdirectory
if [ -z ${INPUT_CFN_SUBDIRECTORY} ] ; then
    echo "Input cfn_subdirectory cannot be empty"
    exit 1
fi

# List templates
grep --with-filename -r 'Resources' ${INPUT_CFN_SUBDIRECTORY}/* |cut -d':' -f1 > /tmp/cfn_templates

if [ -d "${PWD}/reports" ] ; then
    echo "Cleaning up existing report files"
    rm ${PWD}/reports/results*.txt
else
    echo "Creating ${PWD}/reports"
    mkdir ${PWD}/reports
fi

count=0

# Check cloudformation templates
for x in $(cat /tmp/cfn_templates); do
    echo "Checking Template file - ${x}"
    echo "Filename: ${x}" > ${PWD}/reports/results${count}.txt
    echo "Date Checked: "$(date +%Y%m%d_%H%M%S)  >> ${PWD}/reports/results${count}.txt
    echo "## Check results ##" >> ${PWD}/reports/results${count}.txt
    cfn-guard --strict-checks --rule_set ${PWD}/rules/cfn-guard-sqs.ruleset  --template ${PWD}/${x} >> ${PWD}/reports/results${count}.txt
    echo "" >> ${PWD}/reports/results${count}.txt
    count=`expr $count + 1`
done

echo ""
echo "###### Cloudformation Guard Report Summary"
cat reports/results*.txt > consolidated_report.txt
cat consolidated_report.txt

if [ $(grep -o 'Number of failures' consolidated_report.txt | wc -l) -gt "0" ]; then
    echo "### Non Compliant Templates Found ###"
    exit 1
fi