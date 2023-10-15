#!/bin/bash

declare -i rowNum colNum;
declare -a initRow currRow nextRow;

declare -i DEFAULT_NUM_ROWS=10;
declare USAGE="USAGE: $(basename "${0}") [numRows=${DEFAULT_NUM_ROWS}]

where numRows is the number of rows of Pascal's Triangle to generate. Default
value is ${DEFAULT_NUM_ROWS}. If there is more than one argument, I yell* at
you for being silly and exit. If the input value does not parse as a positive
integer, I yell* at you and exit.

Integer overflow may not be handled by this program. If you ask for enough
rows, integer overflow will occur and the output will no longer be accurate.

* Yelling at you means an error message and printing this usage statement.";

declare -ri ERROR_CODE_TOO_MANY_ARGS=1;
declare -ri ERROR_CODE_INVALID_INPUT_ARG=2;

declare -r BRIGHT_RED="$(tput bold)$(tput setaf 1)"
declare -r BRIGHT_CYAN="$(tput bold)$(tput setaf 14)"
declare -r TPUT_RESET="$(tput sgr0)"
function logError() {
  echo "${BRIGHT_RED}${@}${TPUT_RESET}";
}

function printUsage() {
  echo "${BRIGHT_CYAN}${USAGE}${TPUT_RESET}";
}

function printCurrRow() {
 echo "${currRow[@]}";
}

function generatePascalsTriangle() {
  local -i numRows="${1}";
  initRow=(1);
  currRow=(${initRow[@]});
  printCurrRow;
  declare -i rowNum=1;
  while [ ${rowNum} -le ${numRows} ]; do
    nextRow=(1);
    colNum=1;
    while [ ${colNum} -lt ${rowNum} ]; do
      nextRow[${colNum}]+=$((currRow[colNum-1] + currRow[colNum]));
      colNum+=1;
    done;
    nextRow+=(1);
    currRow=(${nextRow[@]});
    printCurrRow;
    rowNum+=1;
  done
}

function main() {
  if [ $# -gt 1 ]; then
    logError "Too many input arguments. Expect 0 or 1 args, but got $#";
    printUsage;
    exit ${ERROR_CODE_TOO_MANY_ARGS};
  fi;

  local -i numRows="${1:-${DEFAULT_NUM_ROWS}}";

  if [ ${numRows} -lt 1 ]; then
    logError "Input argument '${1}' is not a positive int (parsed as '${numRows}')";
    printUsage;
    exit ${ERROR_CODE_INVALID_INPUT_ARG};
  fi;

  generatePascalsTriangle ${numRows};
}

main "${@}";

